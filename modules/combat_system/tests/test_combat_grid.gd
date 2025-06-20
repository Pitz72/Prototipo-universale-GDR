extends Node

## Test Suite per CombatGrid v2
## Verifica funzionalità: griglia, coperture, pathfinding, utilities

@onready var test_results: Array[String] = []
var grid: CombatGrid

func _ready():
	# Auto-run test abilitato per validation v0.2.4
	print("🧪 === TEST SUITE COMBAT GRID v2 AVVIATO ===")
	run_all_tests()

func run_all_tests():
	test_grid_creation()
	test_position_validation()
	test_cell_data_access()
	test_cover_system()
	test_pathfinding_placeholder()
	test_debug_utilities()
	
	print_test_summary()

func test_grid_creation():
	print("\n🔧 TEST: Creazione CombatGrid...")
	
	grid = CombatGrid.new()
	if grid:
		add_result("✅ CombatGrid creato senza errori")
		
		# Verifica dimensioni
		if grid.GRID_WIDTH == 20 and grid.GRID_HEIGHT == 15:
			add_result("✅ Dimensioni griglia corrette (20x15)")
		else:
			add_result("❌ Dimensioni griglia errate")
		
		# Verifica inizializzazione
		var total_expected = grid.GRID_WIDTH * grid.GRID_HEIGHT
		var walkable_count = grid.count_walkable_cells()
		if walkable_count == total_expected:
			add_result("✅ Tutte le celle inizializzate come walkable (%d)" % walkable_count)
		else:
			add_result("❌ Inizializzazione celle fallita")
	else:
		add_result("❌ CRITICO: Impossibile creare CombatGrid")

func test_position_validation():
	print("\n📍 TEST: Validazione posizioni...")
	
	# Test posizioni valide
	var valid_positions = [
		Vector2i(0, 0),      # Angolo top-left
		Vector2i(19, 14),    # Angolo bottom-right
		Vector2i(10, 7)      # Centro
	]
	
	for pos in valid_positions:
		if grid.is_valid_position(pos):
			add_result("✅ Posizione valida: %s" % pos)
		else:
			add_result("❌ Posizione dovrebbe essere valida: %s" % pos)
	
	# Test posizioni non valide
	var invalid_positions = [
		Vector2i(-1, 0),     # Fuori bounds x
		Vector2i(0, -1),     # Fuori bounds y
		Vector2i(20, 0),     # Oltre grid width
		Vector2i(0, 15)      # Oltre grid height
	]
	
	for pos in invalid_positions:
		if not grid.is_valid_position(pos):
			add_result("✅ Posizione non valida correttamente rilevata: %s" % pos)
		else:
			add_result("❌ Posizione dovrebbe essere non valida: %s" % pos)

func test_cell_data_access():
	print("\n📦 TEST: Accesso dati cella...")
	
	var test_pos = Vector2i(5, 5)
	var cell = grid.get_cell_data(test_pos)
	
	if cell:
		add_result("✅ CellData ottenuta per posizione %s" % test_pos)
		
		# Verifica valori default
		if cell.is_walkable:
			add_result("✅ Cella walkable di default")
		else:
			add_result("❌ Cella dovrebbe essere walkable di default")
		
		if cell.occupant_id == "":
			add_result("✅ Nessun occupante di default")
		else:
			add_result("❌ Occupante dovrebbe essere vuoto di default")
		
		# Test modifica walkable
		grid.set_cell_walkable(test_pos, false)
		if not cell.is_walkable:
			add_result("✅ set_cell_walkable funziona correttamente")
		else:
			add_result("❌ set_cell_walkable non ha modificato il valore")
		
		# Ripristina
		grid.set_cell_walkable(test_pos, true)
	else:
		add_result("❌ CRITICO: Impossibile ottenere CellData")

func test_cover_system():
	print("\n🛡️ TEST: Sistema coperture...")
	
	var test_pos = Vector2i(8, 8)
	
	# Test impostazione coperture
	grid.set_cover(test_pos, "north", CombatGrid.CoverType.HIGH)
	grid.set_cover(test_pos, "south", CombatGrid.CoverType.LOW)
	grid.set_cover(test_pos, "east", CombatGrid.CoverType.HIGH)
	grid.set_cover(test_pos, "west", CombatGrid.CoverType.NONE)
	
	# Test lettura coperture
	var cover_tests = [
		["north", CombatGrid.CoverType.HIGH],
		["south", CombatGrid.CoverType.LOW],
		["east", CombatGrid.CoverType.HIGH],
		["west", CombatGrid.CoverType.NONE]
	]
	
	for test in cover_tests:
		var direction = test[0]
		var expected = test[1]
		var actual = grid.get_cover_from(test_pos, direction)
		
		if actual == expected:
			add_result("✅ Copertura %s: %d (corretto)" % [direction, actual])
		else:
			add_result("❌ Copertura %s: atteso %d, ottenuto %d" % [direction, expected, actual])

func test_pathfinding_placeholder():
	print("\n🗺️ TEST: Pathfinding placeholder...")
	
	var start = Vector2i(0, 0)
	var end = Vector2i(5, 5)
	var path = grid.find_path(start, end)
	
	if path.size() > 0:
		add_result("✅ find_path restituisce path non vuoto")
		if path[0] == start and path[-1] == end:
			add_result("✅ Path contiene start e end corretti")
		else:
			add_result("❌ Path non contiene start/end corretti")
	else:
		add_result("❌ find_path restituisce path vuoto")

func test_debug_utilities():
	print("\n🔍 TEST: Utility debug...")
	
	# Test count_walkable_cells
	var initial_count = grid.count_walkable_cells()
	grid.set_cell_walkable(Vector2i(0, 0), false)
	var after_count = grid.count_walkable_cells()
	
	if after_count == initial_count - 1:
		add_result("✅ count_walkable_cells funziona correttamente")
	else:
		add_result("❌ count_walkable_cells non aggiornato correttamente")
	
	# Test print_grid_info (non possiamo testare output, ma verifichiamo che non crashi)
	grid.print_grid_info()
	add_result("✅ print_grid_info eseguito senza crash")

func add_result(message: String):
	test_results.append(message)
	print(message)

func print_test_summary():
	print("\n📊 === RESOCONTO TEST ===")
	
	var passed = 0
	var failed = 0
	
	for result in test_results:
		if result.begins_with("✅"):
			passed += 1
		elif result.begins_with("❌"):
			failed += 1
	
	print("✅ Test PASSATI: %d" % passed)
	print("❌ Test FALLITI: %d" % failed)
	print("📊 TOTALE TEST: %d" % test_results.size())
	
	if failed == 0:
		print("🎉 TUTTI I TEST SUPERATI! CombatGrid v2 FUNZIONANTE")
	else:
		print("⚠️ ALCUNI TEST FALLITI - Rivedere implementazione")
	
	print("=== FINE TEST SUITE ===\n") 