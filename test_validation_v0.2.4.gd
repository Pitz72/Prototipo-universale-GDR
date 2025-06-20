@tool
extends EditorScript

## Test Validation v0.2.4 - Environment Recovery
## Verifica che tutti i moduli siano funzionanti

func _run():
	print("🔧 === VALIDATION SUITE v0.2.4 ===")
	print("📁 Project: ", ProjectSettings.globalize_path("res://"))
	
	test_core_classes()
	test_combat_system()
	test_integration()
	
	print("✅ === VALIDATION COMPLETATA ===")

func test_core_classes():
	print("\n🧪 TEST: Core Classes Loading...")
	
	var tests = [
		["UCS", test_ucs_singleton],
		["CharacterSheet", test_character_sheet],
		["SkillDefinition", test_skill_definition],
		["ItemDefinition", test_item_definition]
	]
	
	for test in tests:
		var name = test[0]
		var func_ref = test[1]
		print("  🔍 Testing %s..." % name)
		func_ref.call()

func test_ucs_singleton():
	if UCS:
		print("    ✅ UCS singleton accessible")
		# Test basic function
		var mod = UCS.get_attribute_modifier(15)
		if mod == 2:
			print("    ✅ UCS.get_attribute_modifier(15) = 2 ✓")
		else:
			print("    ❌ UCS modifier calculation failed")
	else:
		print("    ❌ UCS singleton not found")

func test_character_sheet():
	var char = CharacterSheet.new()
	if char:
		print("    ✅ CharacterSheet instantiated")
		char.character_name = "Test Hero"
		if char.character_name == "Test Hero":
			print("    ✅ CharacterSheet properties working")
		else:
			print("    ❌ CharacterSheet property assignment failed")
	else:
		print("    ❌ CharacterSheet creation failed")

func test_skill_definition():
	var skill = SkillDefinition.new()
	if skill:
		print("    ✅ SkillDefinition instantiated")
		skill.skill_name = "Test Skill"
		if skill.skill_name == "Test Skill":
			print("    ✅ SkillDefinition properties working")
		else:
			print("    ❌ SkillDefinition property assignment failed")
	else:
		print("    ❌ SkillDefinition creation failed")

func test_item_definition():
	var item = ItemDefinition.new()
	if item:
		print("    ✅ ItemDefinition instantiated")
		item.item_name = "Test Item"
		if item.item_name == "Test Item":
			print("    ✅ ItemDefinition properties working")
		else:
			print("    ❌ ItemDefinition property assignment failed")
	else:
		print("    ❌ ItemDefinition creation failed")

func test_combat_system():
	print("\n⚔️ TEST: Combat System Classes...")
	
	# Test CombatGrid
	var grid = CombatGrid.new()
	if grid:
		print("  ✅ CombatGrid instantiated")
		if grid.GRID_WIDTH == 20 and grid.GRID_HEIGHT == 15:
			print("  ✅ CombatGrid dimensions correct (20x15)")
		else:
			print("  ❌ CombatGrid dimensions incorrect")
			
		# Test basic functionality
		var test_pos = Vector2i(5, 5)
		if grid.is_valid_position(test_pos):
			print("  ✅ CombatGrid position validation working")
		else:
			print("  ❌ CombatGrid position validation failed")
	else:
		print("  ❌ CombatGrid creation failed")
	
	# Test Unit
	var unit = Unit.new()
	if unit:
		print("  ✅ Unit instantiated")
	else:
		print("  ❌ Unit creation failed")

func test_integration():
	print("\n🔗 TEST: Integration Tests...")
	
	# Test UCS + CharacterSheet integration
	var char = CharacterSheet.new()
	char.strength = 14
	
	var modifier = UCS.get_attribute_modifier(char.strength)
	if modifier == 2:
		print("  ✅ UCS + CharacterSheet integration working")
	else:
		print("  ❌ UCS + CharacterSheet integration failed")
	
	print("  🎯 Integration tests completed")
