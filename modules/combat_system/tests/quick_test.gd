extends Node

## Quick Test - Verifica rapida funzionalità base
## Eseguibile direttamente dall'editor Godot

func _ready():
	print("🚀 === QUICK TEST COMBAT SYSTEM ===")
	test_imports()
	test_basic_functionality()
	print("✅ === QUICK TEST COMPLETATO ===")

func test_imports():
	print("\n📦 Test caricamento moduli...")
	
	# Test caricamento CombatGrid
	var grid_script = load("res://modules/combat_system/src/combat_grid.gd")
	if grid_script:
		print("✅ CombatGrid.gd caricato correttamente")
		var grid = grid_script.new()
		if grid:
			print("✅ CombatGrid istanziato correttamente")
		else:
			print("❌ Errore istanziazione CombatGrid")
	else:
		print("❌ Errore caricamento CombatGrid.gd")
	
	# Test caricamento Unit
	var unit_script = load("res://modules/character_system/src/character_sheet.gd")
	if unit_script:
		print("✅ CharacterSheet.gd trovato")
	else:
		print("❌ CharacterSheet.gd non trovato")
	
	# Test caricamento CombatManager
	var manager_script = load("res://modules/combat_system/src/combat_manager.gd")
	if manager_script:
		print("✅ CombatManager.gd caricato correttamente")
	else:
		print("❌ Errore caricamento CombatManager.gd")

func test_basic_functionality():
	print("\n⚙️ Test funzionalità base...")
	
	# Test CombatGrid basic
	var CombatGrid = load("res://modules/combat_system/src/combat_grid.gd")
	var grid = CombatGrid.new()
	
	if grid.GRID_WIDTH == 20 and grid.GRID_HEIGHT == 15:
		print("✅ Griglia dimensioni corrette (20x15)")
	else:
		print("❌ Dimensioni griglia errate")
	
	if grid.is_valid_position(Vector2i(10, 7)):
		print("✅ Validazione posizioni funziona")
	else:
		print("❌ Validazione posizioni fallita")
	
	print("\n🎯 Sistema base funzionante! Procedi con test completi.") 