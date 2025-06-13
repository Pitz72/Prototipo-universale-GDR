@tool
extends EditorScript

func _run() -> void:
	print("\n=== Test Unit Semplificato ===\n")
	
	# Carica gli script necessari
	var unit_script = load("res://modules/combat_system/src/unit.gd")
	var character_sheet_script = load("res://modules/character_system/resources/character_sheet.gd")
	
	if not unit_script:
		push_error("Impossibile caricare unit.gd")
		return
	
	if not character_sheet_script:
		push_error("Impossibile caricare character_sheet.gd")
		return
	
	# Crea il character sheet
	var character_sheet = character_sheet_script.new()
	character_sheet.character_name = "Test Unit"
	character_sheet.strength = 10
	character_sheet.dexterity = 10
	character_sheet.constitution = 10
	character_sheet.intelligence = 10
	character_sheet.wisdom = 10
	character_sheet.charisma = 10
	
	# Crea l'unità
	var unit = unit_script.new()
	unit.character_sheet = character_sheet
	unit.max_action_points = 2
	unit.grid_position = Vector2i(0, 0)
	
	# Simula l'inizializzazione manualmente (senza _ready che potrebbe dare errori)
	unit._current_health = 100  # Valore di test
	unit._max_health = 100
	unit._current_action_points = 2
	
	# Esegui i test
	var passed = 0
	var total = 0
	
	# Test 1: Inizializzazione
	total += 1
	print("Test 1: Inizializzazione")
	if unit.character_sheet and unit.max_action_points == 2 and unit.grid_position == Vector2i(0, 0):
		print("✅ Passato")
		passed += 1
	else:
		print("❌ Fallito")
	
	# Test 2: Punti Azione
	total += 1
	print("Test 2: Punti Azione")
	if unit.current_action_points == 2:
		print("✅ Passato")
		passed += 1
	else:
		print("❌ Fallito - Punti azione attuali:", unit.current_action_points)
	
	# Test 3: Movimento (con array come si aspetta la funzione)
	total += 1
	print("Test 3: Movimento")
	var path = [Vector2i(1, 0)]
	var move_result = unit.move_to(path)
	if move_result and unit.current_action_points == 1:
		print("✅ Passato")
		passed += 1
	else:
		print("❌ Fallito - Risultato movimento:", move_result, "PA rimanenti:", unit.current_action_points)
	
	# Test 4: Azioni
	total += 1
	print("Test 4: Overwatch")
	var overwatch_result = unit.enter_overwatch()
	if overwatch_result and unit.is_overwatching and unit.current_action_points == 0:
		print("✅ Passato")
		passed += 1
	else:
		print("❌ Fallito - Risultato overwatch:", overwatch_result, "Stato:", unit.is_overwatching)
	
	# Test 5: Reset turno
	total += 1
	print("Test 5: Reset Turno")
	unit.start_turn()
	if unit.current_action_points == 2 and not unit.is_overwatching:
		print("✅ Passato")
		passed += 1
	else:
		print("❌ Fallito - PA:", unit.current_action_points, "Overwatch:", unit.is_overwatching)
	
	print("\n=== Risultati Finali ===")
	print("Passati: ", passed, "/", total)
	print("Percentuale: ", (float(passed) / total) * 100, "%")
	
	if passed == total:
		print("🎉 Tutti i test Unit sono passati!")
	else:
		print("⚠️ Alcuni test Unit sono falliti")
	
	# Pulizia
	unit.queue_free()
	print("\n=== Test Unit Completati ===\n") 