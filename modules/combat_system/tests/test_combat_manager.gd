extends Node

# Test per CombatManager
# Verifica gestione turni, iniziativa, e integrazione con Unit system

# Costanti
const COMBAT_MANAGER_PATH = "res://modules/combat_system/src/combat_manager.gd"
const UNIT_PATH = "res://modules/combat_system/src/unit.gd"
const CHARACTER_SHEET_PATH = "res://modules/character_system/resources/character_sheet.gd"

# Variabili di test
var combat_manager: Node
var test_player_units: Array[Node] = []
var test_enemy_units: Array[Node] = []
var test_character_sheet_script

func _ready() -> void:
	print("=== Inizializzazione Test CombatManager ===")
	_setup_test_environment()

func _setup_test_environment() -> void:
	"""Setup dell'ambiente di test"""
	# Carica gli script necessari
	var combat_manager_script = load(COMBAT_MANAGER_PATH)
	var unit_script = load(UNIT_PATH)
	test_character_sheet_script = load(CHARACTER_SHEET_PATH)
	
	if not combat_manager_script or not unit_script or not test_character_sheet_script:
		push_error("Impossibile caricare gli script necessari")
		return
	
	# Crea il combat manager
	combat_manager = combat_manager_script.new()
	add_child(combat_manager)
	
	# Crea unità di test
	_create_test_units(unit_script)
	
	print("Ambiente di test inizializzato correttamente")

func _create_test_units(unit_script) -> void:
	"""Crea unità di test per i vari scenari"""
	
	# Crea 2 unità giocatore
	for i in range(2):
		var character_sheet = test_character_sheet_script.new()
		character_sheet.character_name = "Player Unit " + str(i + 1)
		character_sheet.dexterity = 12 + i  # Varia per test iniziativa
		character_sheet.constitution = 14
		
		var unit = unit_script.new()
		unit.character_sheet = character_sheet
		unit.max_action_points = 2
		unit.grid_position = Vector2i(i, 0)
		
		add_child(unit)
		test_player_units.append(unit)
		combat_manager.add_player_unit(unit)
	
	# Crea 2 unità nemiche
	for i in range(2):
		var character_sheet = test_character_sheet_script.new()
		character_sheet.character_name = "Enemy Unit " + str(i + 1)
		character_sheet.dexterity = 10 + i
		character_sheet.constitution = 12
		
		var unit = unit_script.new()
		unit.character_sheet = character_sheet
		unit.max_action_points = 2
		unit.grid_position = Vector2i(i, 5)
		
		add_child(unit)
		test_enemy_units.append(unit)
		combat_manager.add_enemy_unit(unit)

# === TEST CASES ===

func test_combat_manager_initialization() -> bool:
	"""Test inizializzazione CombatManager"""
	print("Test: Inizializzazione CombatManager")
	var success = true
	
	# Verifica stato iniziale
	if combat_manager.get_combat_state() != combat_manager.CombatState.INACTIVE:
		push_error("Stato iniziale non corretto")
		success = false
	
	# Verifica unità registrate
	if combat_manager.player_units.size() != 2:
		push_error("Numero unità giocatore non corretto")
		success = false
	
	if combat_manager.enemy_units.size() != 2:
		push_error("Numero unità nemiche non corretto")
		success = false
	
	print("Risultato: ", "✅" if success else "❌")
	return success

func test_combat_start_and_initiative() -> bool:
	"""Test avvio combattimento e calcolo iniziativa"""
	print("Test: Avvio Combattimento e Iniziativa")
	var success = true
	
	# Avvia combattimento
	combat_manager.start_combat()
	
	# Verifica stato
	if combat_manager.get_combat_state() != combat_manager.CombatState.ACTIVE:
		push_error("Stato combattimento non attivo")
		success = false
	
	# Verifica iniziativa calcolata
	var all_units = test_player_units + test_enemy_units
	for unit in all_units:
		if not unit.has_method("get") or unit.get("initiative") == null:
			push_error("Iniziativa non calcolata per unità: " + unit.character_sheet.character_name)
			success = false
	
	# Verifica ordine iniziativa
	if combat_manager.initiative_order.size() != 4:
		push_error("Ordine iniziativa non corretto")
		success = false
	
	print("Risultato: ", "✅" if success else "❌")
	return success

func test_turn_management() -> bool:
	"""Test gestione turni"""
	print("Test: Gestione Turni")
	var success = true
	
	# Verifica turno corrente
	var current_unit = combat_manager.get_current_unit()
	if not current_unit:
		push_error("Nessuna unità corrente")
		success = false
	
	# Verifica info turno
	var turn_info = combat_manager.get_turn_info()
	if turn_info.turn_number != 1:
		push_error("Numero turno non corretto")
		success = false
	
	# Test cambio turno
	var initial_unit = current_unit
	combat_manager.end_current_turn()
	
	# Verifica che sia cambiata unità o fase
	var new_unit = combat_manager.get_current_unit()
	if new_unit == initial_unit and combat_manager.current_phase == combat_manager.TurnPhase.PLAYER:
		# Se siamo ancora nella fase giocatore, dovrebbe essere un'unità diversa
		var units_in_phase = combat_manager.player_units + combat_manager.ally_units
		if units_in_phase.size() > 1:
			push_error("Turno non cambiato correttamente")
			success = false
	
	print("Risultato: ", "✅" if success else "❌")
	return success

func test_phase_transitions() -> bool:
	"""Test transizioni tra fasi"""
	print("Test: Transizioni Fasi")
	var success = true
	
	# Termina tutti i turni della fase corrente
	var max_iterations = 10  # Sicurezza anti-loop
	var iterations = 0
	
	while combat_manager.current_phase == combat_manager.TurnPhase.PLAYER and iterations < max_iterations:
		combat_manager.end_current_turn()
		iterations += 1
	
	# Verifica passaggio alla fase nemici
	if combat_manager.current_phase != combat_manager.TurnPhase.ENEMY:
		push_error("Non è passato alla fase nemici")
		success = false
	
	# Continua per testare ciclo completo
	iterations = 0
	while combat_manager.current_phase == combat_manager.TurnPhase.ENEMY and iterations < max_iterations:
		combat_manager.end_current_turn()
		iterations += 1
	
	# Dovrebbe essere nella fase neutrali o tornato al giocatore
	if combat_manager.current_phase != combat_manager.TurnPhase.NEUTRAL and combat_manager.current_phase != combat_manager.TurnPhase.PLAYER:
		push_error("Transizione fase non corretta")
		success = false
	
	print("Risultato: ", "✅" if success else "❌")
	return success

func test_unit_death_handling() -> bool:
	"""Test gestione morte unità"""
	print("Test: Gestione Morte Unità")
	var success = true
	
	# Uccidi un'unità nemica
	var enemy_unit = test_enemy_units[0]
	var initial_enemy_count = combat_manager.enemy_units.size()
	
	# Simula morte
	enemy_unit.take_damage(1000)  # Danno letale
	
	# Verifica rimozione
	await get_tree().process_frame  # Aspetta elaborazione segnali
	
	if combat_manager.enemy_units.size() == initial_enemy_count:
		push_error("Unità morta non rimossa")
		success = false
	
	print("Risultato: ", "✅" if success else "❌")
	return success

func test_combat_end_conditions() -> bool:
	"""Test condizioni fine combattimento"""
	print("Test: Condizioni Fine Combattimento")
	var success = true
	
	# Uccidi tutti i nemici rimanenti
	for unit in combat_manager.enemy_units.duplicate():
		unit.take_damage(1000)
	
	await get_tree().process_frame  # Aspetta elaborazione
	
	# Verifica fine combattimento
	if combat_manager.get_combat_state() != combat_manager.CombatState.COMPLETED:
		push_error("Combattimento non terminato")
		success = false
	
	print("Risultato: ", "✅" if success else "❌")
	return success

func test_pause_resume_combat() -> bool:
	"""Test pausa e ripresa combattimento"""
	print("Test: Pausa e Ripresa")
	var success = true
	
	# Reset per nuovo test
	_reset_combat_for_test()
	
	# Pausa
	combat_manager.pause_combat()
	if combat_manager.get_combat_state() != combat_manager.CombatState.PAUSED:
		push_error("Combattimento non in pausa")
		success = false
	
	# Riprendi
	combat_manager.resume_combat()
	if combat_manager.get_combat_state() != combat_manager.CombatState.ACTIVE:
		push_error("Combattimento non ripreso")
		success = false
	
	print("Risultato: ", "✅" if success else "❌")
	return success

func _reset_combat_for_test() -> void:
	"""Reset combattimento per nuovi test"""
	# Termina combattimento corrente se attivo
	if combat_manager.get_combat_state() == combat_manager.CombatState.ACTIVE:
		combat_manager.end_combat(true)
	
	# Rimuovi unità morte
	for unit in test_enemy_units:
		if is_instance_valid(unit) and unit.is_dead:
			combat_manager.remove_unit(unit)
			unit.queue_free()
	
	# Ricrea unità se necessario
	if combat_manager.enemy_units.size() == 0:
		_create_replacement_enemies()
	
	# Riavvia combattimento
	await get_tree().process_frame
	combat_manager.start_combat()

func _create_replacement_enemies() -> void:
	"""Crea nuove unità nemiche per i test"""
	var unit_script = load(UNIT_PATH)
	test_enemy_units.clear()
	
	for i in range(2):
		var character_sheet = test_character_sheet_script.new()
		character_sheet.character_name = "New Enemy " + str(i + 1)
		character_sheet.dexterity = 10 + i
		character_sheet.constitution = 12
		
		var unit = unit_script.new()
		unit.character_sheet = character_sheet
		unit.max_action_points = 2
		unit.grid_position = Vector2i(i, 5)
		
		add_child(unit)
		test_enemy_units.append(unit)
		combat_manager.add_enemy_unit(unit)

# === TEST RUNNER ===

func run_all_tests() -> void:
	"""Esegue tutti i test del CombatManager"""
	print("\n=== Esecuzione Test CombatManager ===\n")
	
	var tests = [
		test_combat_manager_initialization,
		test_combat_start_and_initiative,
		test_turn_management,
		test_phase_transitions,
		test_unit_death_handling,
		test_combat_end_conditions,
		test_pause_resume_combat
	]
	
	var passed = 0
	var total = tests.size()
	
	for test in tests:
		if test.call():
			passed += 1
		await get_tree().process_frame  # Aspetta tra i test
	
	print("\n=== Risultati Test CombatManager ===")
	print("Passati: ", passed, "/", total)
	print("Percentuale: ", (float(passed) / total) * 100, "%")
	
	if passed == total:
		print("🎉 Tutti i test CombatManager sono passati!")
	else:
		print("⚠️ Alcuni test CombatManager sono falliti")

# Autorun se scene is launched directly
func _enter_tree() -> void:
	# Aspetta che tutto sia inizializzato
	call_deferred("_delayed_autorun")

func _delayed_autorun() -> void:
	await get_tree().process_frame
	if get_parent() == get_tree().current_scene:
		run_all_tests() 