@tool
class_name TechEquipment extends UsableItem

# === BONUS ABILITÀ ===
@export_group("Bonus Abilità")
# Mappa che associa il path di una SkillDefinition al bonus numerico
# Es. { "res://path/to/informatica.tres": 2, "res://path/to/percezione.tres": 1 }
@export var skill_bonus_map: Dictionary = {}

# Segnale emesso quando viene attivato un boost tecnologico
signal tech_boost_activated(target: CharacterSheet, skill_bonuses: Dictionary)

# Override della funzione _use per implementare logiche tecnologiche specifiche
func _use(target: CharacterSheet) -> void:
	# Chiama la funzione base per gestire cariche e segnali
	super._use(target)
	
	# Se l'uso è andato a buon fine (aveva cariche), attiva i boost tecnologici
	if charges != 0:
		_activate_tech_boost(target)

# Attiva i boost tecnologici specifici di questo equipaggiamento
func _activate_tech_boost(target: CharacterSheet) -> void:
	if skill_bonus_map.is_empty():
		print("Equipaggiamento %s attivato senza bonus specifici" % item_name)
		return
	
	print("Equipaggiamento %s attiva i seguenti bonus:" % item_name)
	for skill_path in skill_bonus_map.keys():
		var bonus = skill_bonus_map[skill_path]
		print("  - Abilità %s: +%d" % [skill_path.get_file().get_basename(), bonus])
	
	# Emette il segnale per permettere ad altri sistemi di reagire
	tech_boost_activated.emit(target, skill_bonus_map)

# Restituisce tutti i bonus alle abilità passivi (quando l'oggetto è nell'inventario)
func get_passive_skill_bonuses() -> Dictionary:
	return skill_bonus_map.duplicate()

# Verifica se questo equipaggiamento fornisce un bonus a una specifica abilità
func provides_bonus_for_skill(skill_definition: SkillDefinition) -> bool:
	return skill_bonus_map.has(skill_definition.resource_path)

# Ottiene il bonus per una specifica abilità
func get_skill_bonus(skill_definition: SkillDefinition) -> int:
	if provides_bonus_for_skill(skill_definition):
		return skill_bonus_map[skill_definition.resource_path]
	return 0

# Aggiunge un bonus a una specifica abilità (utile per oggetti modificabili)
func add_skill_bonus(skill_definition: SkillDefinition, bonus: int) -> void:
	skill_bonus_map[skill_definition.resource_path] = bonus
	print("Aggiunto bonus +%d a %s per l'equipaggiamento %s" % [bonus, skill_definition.skill_name, item_name])

# Funzione di utilità per descrivere i bonus dell'equipaggiamento
func get_bonus_description() -> String:
	if skill_bonus_map.is_empty():
		return "Nessun bonus alle abilità"
	
	var bonus_list: Array[String] = []
	for skill_path in skill_bonus_map.keys():
		var bonus = skill_bonus_map[skill_path]
		var skill_name = skill_path.get_file().get_basename()
		bonus_list.append("%s +%d" % [skill_name, bonus])
	
	return "Bonus: " + ", ".join(bonus_list) 