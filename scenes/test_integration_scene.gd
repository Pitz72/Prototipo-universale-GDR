extends Control

@onready var results_label: RichTextLabel = $VBoxContainer/ScrollContainer/ResultsLabel

var character: CharacterSheet
var atletica_skill: SkillDefinition
var informatica_skill: SkillDefinition

func _ready():
	# OPZIONE 1: Carica le risorse (se esistono)
	character = ResourceLoader.load("res://modules/character_system/characters/test_character.tres")
	atletica_skill = ResourceLoader.load("res://modules/core_rules/resources/test_atletica.tres")
	informatica_skill = ResourceLoader.load("res://modules/core_rules/resources/test_informatica.tres")
	
	# OPZIONE 2: Se falliscono, crea dati di test hardcoded
	if not character:
		print("Creando personaggio di test hardcoded...")
		character = CharacterSheet.new()
		character.character_name = "Ufficiale di Sicurezza (Test)"
		character.strength = 16
		character.dexterity = 14
		character.constitution = 15
		character.intelligence = 12
		character.wisdom = 13
		character.charisma = 10
		character.level = 1
		character.experience_points = 0
	
	if not atletica_skill:
		print("Creando abilità Atletica hardcoded...")
		atletica_skill = SkillDefinition.new()
		atletica_skill.skill_name = "Atletica"
		atletica_skill.description = "Movimento fisico generale"
		atletica_skill.base_attribute = SkillDefinition.PrimaryAttribute.FOR
	
	if not informatica_skill:
		print("Creando abilità Informatica hardcoded...")
		informatica_skill = SkillDefinition.new()
		informatica_skill.skill_name = "Informatica"
		informatica_skill.description = "Hacking e programmazione"
		informatica_skill.base_attribute = SkillDefinition.PrimaryAttribute.INT
	
	# Simula i gradi nelle abilità per il test
	character.skill_ranks[atletica_skill.resource_path] = 3
	character.skill_ranks[informatica_skill.resource_path] = 1
	
	print("Sistema di test pronto!")
	# Mostra informazioni iniziali del personaggio
	display_character_info()

func display_character_info():
	var info_text = "[center][b]SCHEDA PERSONAGGIO[/b][/center]\n\n"
	info_text += "[b]Nome:[/b] " + character.character_name + "\n"
	info_text += "[b]Livello:[/b] " + str(character.level) + "\n\n"
	
	info_text += "[b]ATTRIBUTI:[/b]\n"
	info_text += "• Forza: " + str(character.strength) + " (Mod: " + str(UCS.get_attribute_modifier(character.strength)) + ")\n"
	info_text += "• Destrezza: " + str(character.dexterity) + " (Mod: " + str(UCS.get_attribute_modifier(character.dexterity)) + ")\n"
	info_text += "• Costituzione: " + str(character.constitution) + " (Mod: " + str(UCS.get_attribute_modifier(character.constitution)) + ")\n"
	info_text += "• Intelligenza: " + str(character.intelligence) + " (Mod: " + str(UCS.get_attribute_modifier(character.intelligence)) + ")\n"
	info_text += "• Saggezza: " + str(character.wisdom) + " (Mod: " + str(UCS.get_attribute_modifier(character.wisdom)) + ")\n"
	info_text += "• Carisma: " + str(character.charisma) + " (Mod: " + str(UCS.get_attribute_modifier(character.charisma)) + ")\n\n"
	
	info_text += "[b]ABILITÀ:[/b]\n"
	info_text += "• " + atletica_skill.skill_name + ": " + str(character.get_skill_rank(atletica_skill)) + " gradi\n"
	info_text += "• " + informatica_skill.skill_name + ": " + str(character.get_skill_rank(informatica_skill)) + " gradi\n\n"
	
	info_text += "[b]STATISTICHE DERIVATE:[/b]\n"
	info_text += "• PF Massimi: " + str(UCS.calculate_max_health(character)) + "\n"
	info_text += "• Iniziativa: " + str(UCS.calculate_initiative(character)) + "\n"
	info_text += "• Capacità Carico: " + str(UCS.calculate_carrying_capacity(character)) + " kg\n\n"
	
	info_text += "[color=gray]Premi i pulsanti sopra per eseguire test delle prove di abilità[/color]"
	
	results_label.text = info_text

func _on_test_atletica_button_pressed():
	perform_skill_test(atletica_skill, 15)

func _on_test_informatica_button_pressed():
	perform_skill_test(informatica_skill, 12)

func perform_skill_test(skill: SkillDefinition, difficulty_class: int):
	var attribute_value = character.get_attribute_value(skill.base_attribute)
	var attribute_mod = UCS.get_attribute_modifier(attribute_value)
	var skill_rank = character.get_skill_rank(skill)
	
	# Simula il tiro di dado (per mostrare anche i calcoli)
	var dice_roll = randi_range(1, 20)
	var total_result = dice_roll + attribute_mod + skill_rank
	var success = total_result >= difficulty_class
	
	# Costruisce il testo del risultato
	var result_text = "[center][b]PROVA DI " + skill.skill_name.to_upper() + "[/b][/center]\n\n"
	
	result_text += "[b]Personaggio:[/b] " + character.character_name + "\n"
	result_text += "[b]Abilità:[/b] " + skill.skill_name + "\n"
	result_text += "[b]Attributo Base:[/b] " + get_attribute_name(skill.base_attribute) + " (" + str(attribute_value) + ")\n\n"
	
	result_text += "[b]CALCOLI:[/b]\n"
	result_text += "• Tiro d20: " + str(dice_roll) + "\n"
	result_text += "• Modificatore Attributo: " + ("+" if attribute_mod >= 0 else "") + str(attribute_mod) + "\n"
	result_text += "• Grado Abilità: +" + str(skill_rank) + "\n"
	result_text += "• [b]Totale: " + str(total_result) + "[/b]\n"
	result_text += "• Classe Difficoltà: " + str(difficulty_class) + "\n\n"
	
	if success:
		result_text += "[color=green][b]✓ SUCCESSO![/b][/color]\n"
	else:
		result_text += "[color=red][b]✗ FALLIMENTO[/b][/color]\n"
	
	result_text += "\n[color=gray]────────────────────────────[/color]\n\n"
	
	# Aggiungi sempre le info del personaggio alla fine
	result_text += get_character_summary()
	
	results_label.text = result_text

func get_attribute_name(attribute_enum: SkillDefinition.PrimaryAttribute) -> String:
	match attribute_enum:
		SkillDefinition.PrimaryAttribute.FOR: return "Forza"
		SkillDefinition.PrimaryAttribute.DES: return "Destrezza"
		SkillDefinition.PrimaryAttribute.COS: return "Costituzione"
		SkillDefinition.PrimaryAttribute.INT: return "Intelligenza"
		SkillDefinition.PrimaryAttribute.SAG: return "Saggezza"
		SkillDefinition.PrimaryAttribute.CAR: return "Carisma"
	return "Sconosciuto"

func get_character_summary() -> String:
	var summary = "[b]RIASSUNTO PERSONAGGIO:[/b]\n"
	summary += "• PF Massimi: " + str(UCS.calculate_max_health(character)) + "\n"
	summary += "• Iniziativa: " + str(UCS.calculate_initiative(character)) + "\n"
	summary += "• Capacità Carico: " + str(UCS.calculate_carrying_capacity(character)) + " kg"
	return summary 