@tool
extends EditorScript

## Test Runner per Combat System
## Esegui con: Tools > Execute Script

func _run():
	print("🚀 AVVIO TEST RUNNER COMBAT SYSTEM")
	print("📁 Workspace: ", ProjectSettings.globalize_path("res://"))
	
	# Test CombatGrid classe
	test_combat_grid_class()

func test_combat_grid_class():
	print("\n🧪 === TEST COMBAT GRID CLASS ===")
	
	# Verifica che la classe sia riconosciuta
	var grid = CombatGrid.new()
	if grid:
		print("✅ CombatGrid classe caricata correttamente")
		
		# Test basic functionality
		grid.print_grid_info()
		
		# Test posizione
		var test_pos = Vector2i(5, 5)
		if grid.is_valid_position(test_pos):
			print("✅ Validazione posizione funziona")
			
			# Test cell data
			var cell = grid.get_cell_data(test_pos)
			if cell and cell.is_walkable:
				print("✅ CellData accessibile e walkable")
				
				# Test coperture
				grid.set_cover(test_pos, "north", CombatGrid.CoverType.HIGH)
				var cover = grid.get_cover_from(test_pos, "north")
				if cover == CombatGrid.CoverType.HIGH:
					print("✅ Sistema coperture funzionante")
				else:
					print("❌ Sistema coperture non funziona")
			else:
				print("❌ CellData non accessibile")
		else:
			print("❌ Validazione posizione non funziona")
		
		print("🎯 Test classe base completato!")
	else:
		print("❌ ERRORE CRITICO: CombatGrid non può essere istanziato")
		print("💡 Verifica che modules/combat_system/src/combat_grid.gd esista")
	
	print("=== FINE TEST RUNNER ===\n") 