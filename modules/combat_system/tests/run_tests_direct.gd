extends SceneTree

## Script per eseguire test direttamente dalla console
## Uso: godot --headless --script modules/combat_system/tests/run_tests_direct.gd

func _init():
	print("🚀 === AVVIO TEST SUITE COMBAT SYSTEM ===")
	
	# Test 1: Unit System
	print("\n🔧 === TEST UNIT SYSTEM ===")
	run_unit_tests()
	
	# Test 2: Combat Manager
	print("\n⚔️ === TEST COMBAT MANAGER ===") 
	run_combat_manager_tests()
	
	print("\n✅ === TUTTI I TEST COMPLETATI ===")
	quit()

func run_unit_tests():
	var test_script = load("res://modules/combat_system/tests/simple_unit_test.gd")
	var test_instance = test_script.new()
	
	print("📋 Eseguendo 5 test Unit System...")
	test_instance.run_all_tests()
	
	# Cleanup
	test_instance.queue_free()

func run_combat_manager_tests():
	var test_script = load("res://modules/combat_system/tests/simple_combat_manager_test.gd")
	var test_instance = test_script.new()
	
	print("📋 Eseguendo 7 test Combat Manager...")
	test_instance.run_all_tests()
	
	# Cleanup
	test_instance.queue_free() 