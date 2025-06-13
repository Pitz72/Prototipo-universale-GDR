extends Node

# Percorsi delle risorse
const UNIT_SCRIPT_PATH = "res://modules/combat_system/src/unit.gd"
const CHARACTER_SHEET_PATH = "res://modules/character_system/resources/character_sheet.gd"

# Variabili di test
var unit: Node
var character_sheet: Resource

func _ready() -> void:
	# Carica gli script necessari
	var unit_script = load(UNIT_SCRIPT_PATH)
	var character_sheet_script = load(CHARACTER_SHEET_PATH)
	
	if not unit_script or not character_sheet_script:
		push_error("Impossibile caricare gli script necessari")
		return
	
	# Crea il character sheet
	character_sheet = character_sheet_script.new()
	character_sheet.character_name = "Test Unit"
	character_sheet.strength = 10
	character_sheet.dexterity = 10
	character_sheet.constitution = 10
	character_sheet.intelligence = 10
	character_sheet.wisdom = 10
	character_sheet.charisma = 10
	
	# Crea l'unità
	unit = unit_script.new()
	unit.character_sheet = character_sheet
	add_child(unit)

func test_initialization() -> bool:
	print("Test: Inizializzazione")
	var success = true
	
	# Verifica character sheet
	if not unit.character_sheet:
		push_error("Character sheet non assegnato")
		success = false
	
	# Verifica punti azione
	if unit.max_action_points != 2:
		push_error("Punti azione massimi non corretti")
		success = false
	
	# Verifica posizione griglia
	if unit.grid_position != Vector2i(0, 0):
		push_error("Posizione griglia non corretta")
		success = false
	
	print("Risultato: ", "✅" if success else "❌")
	return success

func test_movement() -> bool:
	print("Test: Movimento")
	var success = true
	
	# Test movimento valido
	if not unit.move_to(Vector2i(1, 0)):
		push_error("Movimento valido fallito")
		success = false
	
	# Test movimento senza punti azione
	unit.current_action_points = 0
	if unit.move_to(Vector2i(2, 0)):
		push_error("Movimento senza punti azione non bloccato")
		success = false
	
	# Reset per test successivi
	unit.current_action_points = unit.max_action_points
	unit.grid_position = Vector2i(0, 0)
	
	print("Risultato: ", "✅" if success else "❌")
	return success

func test_actions() -> bool:
	print("Test: Azioni")
	var success = true
	
	# Test overwatch
	if not unit.enter_overwatch():
		push_error("Overwatch fallito")
		success = false
	
	# Test hunker down
	if not unit.hunker_down():
		push_error("Hunker down fallito")
		success = false
	
	# Test azioni senza punti
	unit.current_action_points = 0
	if unit.enter_overwatch():
		push_error("Overwatch senza punti non bloccato")
		success = false
	
	print("Risultato: ", "✅" if success else "❌")
	return success

func test_health() -> bool:
	print("Test: Salute")
	var success = true
	
	# Test danno
	unit.take_damage(10)
	if unit.current_health != 90:
		push_error("Danno non applicato correttamente")
		success = false
	
	# Test cura
	unit.heal(5)
	if unit.current_health != 95:
		push_error("Cura non applicata correttamente")
		success = false
	
	# Test morte
	unit.take_damage(100)
	if not unit.is_dead:
		push_error("Unità non marcata come morta")
		success = false
	
	print("Risultato: ", "✅" if success else "❌")
	return success

func test_turn_management() -> bool:
	print("Test: Gestione Turni")
	var success = true
	
	# Test inizio turno
	unit.current_action_points = 0
	unit.is_overwatching = true
	unit.is_hunkered_down = true
	
	unit.start_turn()
	
	if unit.current_action_points != unit.max_action_points:
		push_error("Punti azione non resettati")
		success = false
	
	if unit.is_overwatching or unit.is_hunkered_down:
		push_error("Stati non resettati")
		success = false
	
	print("Risultato: ", "✅" if success else "❌")
	return success

func run_all_tests() -> void:
	print("\n=== Esecuzione Test Unit ===\n")
	
	var tests = [
		test_initialization,
		test_movement,
		test_actions,
		test_health,
		test_turn_management
	]
	
	var passed = 0
	var total = tests.size()
	
	for test in tests:
		if test.call():
			passed += 1
	
	print("\n=== Risultati Test ===")
	print("Passati: ", passed, "/", total)
	print("Percentuale: ", (float(passed) / total) * 100, "%") 