@tool
class_name ProtectionItem extends ItemDefinition

# === STATISTICHE PROTEZIONE ===
@export_group("Statistiche Protezione")
# Resistenza ai diversi tipi di danno
# Chiave: WeaponItem.DamageType, Valore: riduzione del danno
@export var damage_resistance: Dictionary = {}

@export var shield_points: int = 0  # Punti scudo energetici ricaricabili
@export var max_shield_points: int = 0  # Capacità massima scudi
@export var shield_recharge_rate: float = 1.0  # Punti scudo per secondo di ricarica

# === USURA E DURABILITÀ ===
@export_group("Durabilità")
@export var max_durability: int = 100
@export var current_durability: int = 100
@export var armor_degradation_rate: float = 0.1  # % di usura per colpo subito

# === SLOT DI EQUIPAGGIAMENTO ===
@export_group("Equipaggiamento")
@export var equipment_slot: String = "Corpo"  # Slot dove può essere equipaggiato
@export var covers_multiple_slots: bool = false
@export var covered_slots: Array[String] = []  # Se copre più slot

# Segnali per eventi dell'armatura
signal shield_depleted(protection: ProtectionItem)
signal shield_recharged(protection: ProtectionItem, current_points: int)
signal armor_damaged(protection: ProtectionItem, damage_taken: int)
signal armor_broken(protection: ProtectionItem)

func _ready():
	# Imposta la categoria come ARMI_DIFESA
	category = ItemCategory.ARMI_DIFESA
	
	# Inizializza gli scudi alla capacità massima
	if max_shield_points > 0 and shield_points == 0:
		shield_points = max_shield_points

# Calcola la riduzione del danno per un tipo specifico
func get_damage_reduction(damage_type) -> int:
	# Verifica che il tipo di danno sia valido
	if damage_resistance.has(damage_type):
		# Applica la degradazione dell'armatura
		var degradation_factor = float(current_durability) / float(max_durability)
		var base_reduction = damage_resistance[damage_type]
		return int(base_reduction * degradation_factor)
	return 0

# Subisce danno e calcola quanto viene assorbito
func take_damage(incoming_damage: int, damage_type) -> Dictionary:
	var result = {
		"damage_absorbed": 0,
		"damage_to_character": incoming_damage,
		"shield_damage": 0,
		"armor_damage": 0,
		"shield_broken": false,
		"armor_broken": false
	}
	
	var remaining_damage = incoming_damage
	
	# Prima i scudi assorbono il danno
	if shield_points > 0:
		var shield_absorption = min(shield_points, remaining_damage)
		shield_points -= shield_absorption
		result.shield_damage = shield_absorption
		result.damage_absorbed += shield_absorption
		remaining_damage -= shield_absorption
		
		if shield_points <= 0:
			result.shield_broken = true
			shield_depleted.emit(self)
			print("Scudi di %s esauriti!" % item_name)
	
	# Poi l'armatura riduce il danno rimanente
	if remaining_damage > 0:
		var armor_reduction = get_damage_reduction(damage_type)
		var armor_absorption = min(armor_reduction, remaining_damage)
		result.damage_absorbed += armor_absorption
		remaining_damage -= armor_absorption
		
		# L'armatura subisce usura
		if armor_absorption > 0:
			_degrade_armor(armor_absorption)
			result.armor_damage = armor_absorption
	
	result.damage_to_character = remaining_damage
	
	if result.damage_absorbed > 0:
		armor_damaged.emit(self, result.damage_absorbed)
	
	return result

# Applica usura all'armatura
func _degrade_armor(damage_absorbed: int) -> void:
	var degradation = int(damage_absorbed * armor_degradation_rate)
	current_durability = max(0, current_durability - degradation)
	
	if current_durability <= 0:
		armor_broken.emit(self)
		print("Armatura %s completamente danneggiata!" % item_name)
	elif current_durability <= max_durability * 0.25:
		print("Armatura %s gravemente danneggiata (%d%% durabilità)" % [item_name, get_durability_percentage()])

# Ricarica gli scudi (chiamata periodicamente o manualmente)
func recharge_shields(amount: float = 1.0) -> void:
	if shield_points < max_shield_points:
		var old_shields = shield_points
		shield_points = min(max_shield_points, shield_points + int(amount * shield_recharge_rate))
		
		if shield_points > old_shields:
			shield_recharged.emit(self, shield_points)

# Ripara l'armatura
func repair_armor(amount: int = -1) -> void:
	if amount == -1:
		amount = max_durability
	
	current_durability = min(max_durability, current_durability + amount)
	print("Armatura %s riparata. Durabilità: %d%%" % [item_name, get_durability_percentage()])

# Ottiene la percentuale di durabilità
func get_durability_percentage() -> int:
	if max_durability <= 0:
		return 100
	return int((float(current_durability) / float(max_durability)) * 100)

# Verifica se l'armatura è funzionale
func is_functional() -> bool:
	return current_durability > 0

# Verifica se ha scudi attivi
func has_active_shields() -> bool:
	return shield_points > 0

# Aggiunge resistenza a un tipo di danno
func add_damage_resistance(damage_type, resistance: int) -> void:
	damage_resistance[damage_type] = resistance
	print("Aggiunta resistenza +%d a %s per %s" % [resistance, str(damage_type), item_name])

# Ottiene informazioni complete sulla protezione
func get_protection_info() -> String:
	var info = get_full_description() + "\n"
	
	# Informazioni scudi
	if max_shield_points > 0:
		info += "Scudi: %d/%d\n" % [shield_points, max_shield_points]
		info += "Ricarica scudi: %.1f/sec\n" % shield_recharge_rate
	
	# Informazioni durabilità
	info += "Durabilità: %d%% (%d/%d)\n" % [get_durability_percentage(), current_durability, max_durability]
	
	# Resistenze
	if not damage_resistance.is_empty():
		info += "Resistenze: "
		var resistances: Array[String] = []
		for damage_type in damage_resistance.keys():
			var resistance = get_damage_reduction(damage_type)
			resistances.append("%s -%d" % [str(damage_type), resistance])
		info += ", ".join(resistances) + "\n"
	
	# Slot di equipaggiamento
	info += "Slot: %s" % equipment_slot
	if covers_multiple_slots and not covered_slots.is_empty():
		info += " (copre anche: %s)" % ", ".join(covered_slots)
	
	return info

# Verifica se può essere equipaggiato in un determinato slot
func can_equip_in_slot(slot_name: String) -> bool:
	if slot_name == equipment_slot:
		return true
	if covers_multiple_slots and slot_name in covered_slots:
		return true
	return false 