@tool
extends EditorScript

func _run() -> void:
	print("\n=== Test CombatManager Semplificato ===\n")
	
	# Carica gli script necessari
	var combat_manager_script = load("res://modules/combat_system/src/combat_manager.gd")
	var unit_script = load("res://modules/combat_system/src/unit.gd")
	var character_sheet_script = load("res://modules/character_system/resources/character_sheet.gd")
	
	if not combat_manager_script or not unit_script or not character_sheet_script:
		push_error("Impossibile caricare gli script necessari")
		return
	
	# Crea il combat manager
	var combat_manager = combat_manager_script.new()
	
	# Crea unità di test
	var player_units = []
	var enemy_units = []
	
	# Crea 2 unità giocatore
	for i in range(2):
		var character_sheet = character_sheet_script.new()
		character_sheet.character_name = "Player " + str(i + 1)
		character_sheet.dexterity = 12 + i
		character_sheet.constitution = 14
		
		var unit = unit_script.new()
		unit.character_sheet = character_sheet
		unit.max_action_points = 2
		unit.grid_position = Vector2i(i, 0)
		unit._ready()  # Inizializza manualmente
		
		player_units.append(unit)
		combat_manager.add_player_unit(unit)
	
	# Crea 2 unità nemiche
	for i in range(2):
		var character_sheet = character_sheet_script.new()
		character_sheet.character_name = "Enemy " + str(i + 1)
		character_sheet.dexterity = 10 + i
		character_sheet.constitution = 12
		
		var unit = unit_script.new()
		unit.character_sheet = character_sheet
		unit.max_action_points = 2
		unit.grid_position = Vector2i(i, 5)
		unit._ready()  # Inizializza manualmente
		
		enemy_units.append(unit)
		combat_manager.add_enemy_unit(unit)
	
	# Esegui i test
	var passed = 0
	var total = 0
	
	# Test 1: Inizializzazione
	total += 1
	print("Test 1: Inizializzazione CombatManager")
	if combat_manager.get_combat_state() == combat_manager.CombatState.INACTIVE and combat_manager.player_units.size() == 2 and combat_manager.enemy_units.size() == 2:
		print("✅ Passato")
		passed += 1
	else:
		print("❌ Fallito - Stato:", combat_manager.get_combat_state(), "Player units:", combat_manager.player_units.size(), "Enemy units:", combat_manager.enemy_units.size())
	
	# Test 2: Avvio combattimento
	total += 1
	print("Test 2: Avvio Combattimento")
	combat_manager.start_combat()
	if combat_manager.get_combat_state() == combat_manager.CombatState.ACTIVE:
		print("✅ Passato")
		passed += 1
	else:
		print("❌ Fallito - Stato dopo start_combat:", combat_manager.get_combat_state())
	
	# Test 3: Iniziativa calcolata
	total += 1
	print("Test 3: Calcolo Iniziativa")
	var all_units = player_units + enemy_units
	var initiative_calculated = true
	for unit in all_units:
		if unit.initiative == 0:
			initiative_calculated = false
			break
	
	if initiative_calculated and combat_manager.initiative_order.size() == 4:
		print("✅ Passato")
		passed += 1
	else:
		print("❌ Fallito - Iniziativa non calcolata o ordine sbagliato")
	
	# Test 4: Gestione turni
	total += 1
	print("Test 4: Gestione Turni")
	var current_unit = combat_manager.get_current_unit()
	var turn_info = combat_manager.get_turn_info()
	if current_unit and turn_info.turn_number == 1:
		print("✅ Passato")
		passed += 1
	else:
		print("❌ Fallito - Unità corrente:", current_unit, "Turn number:", turn_info.turn_number)
	
	# Test 5: Cambio turno
	total += 1
	print("Test 5: Cambio Turno")
	var initial_unit = current_unit
	combat_manager.end_current_turn()
	var new_unit = combat_manager.get_current_unit()
	if new_unit != initial_unit or combat_manager.current_phase != combat_manager.TurnPhase.PLAYER:
		print("✅ Passato")
		passed += 1
	else:
		print("❌ Fallito - Turno non cambiato")
	
	# Test 6: Pausa e ripresa
	total += 1
	print("Test 6: Pausa e Ripresa")
	combat_manager.pause_combat()
	var paused = combat_manager.get_combat_state() == combat_manager.CombatState.PAUSED
	combat_manager.resume_combat()
	var resumed = combat_manager.get_combat_state() == combat_manager.CombatState.ACTIVE
	if paused and resumed:
		print("✅ Passato")
		passed += 1
	else:
		print("❌ Fallito - Pausa/Ripresa non funziona")
	
	# Test 7: Fine combattimento
	total += 1
	print("Test 7: Fine Combattimento")
	combat_manager.end_combat(true)
	if combat_manager.get_combat_state() == combat_manager.CombatState.COMPLETED:
		print("✅ Passato")
		passed += 1
	else:
		print("❌ Fallito - Combattimento non terminato")
	
	print("\n=== Risultati Finali ===")
	print("Passati: ", passed, "/", total)
	print("Percentuale: ", (float(passed) / total) * 100, "%")
	
	if passed == total:
		print("🎉 Tutti i test CombatManager sono passati!")
	else:
		print("⚠️ Alcuni test CombatManager sono falliti")
	
	# Pulizia
	for unit in all_units:
		unit.queue_free()
	combat_manager.queue_free()
	
	print("\n=== Test CombatManager Completati ===\n") 