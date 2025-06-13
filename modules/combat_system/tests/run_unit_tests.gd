@tool
extends EditorScript

func _run() -> void:
	print("\n=== Esecuzione Test Unit ===\n")
	
	# Carica la scena di test
	var test_scene = load("res://modules/combat_system/scenes/test_unit.tscn")
	if not test_scene:
		push_error("Impossibile caricare la scena di test")
		return
		
	var test_instance = test_scene.instantiate()
	if not test_instance:
		push_error("Impossibile istanziare la scena di test")
		return
	
	# Aggiungi la scena al tree
	var root = get_editor_interface().get_edited_scene_root()
	if root:
		root.add_child(test_instance)
		# Attendi un frame per l'inizializzazione
		await get_editor_interface().get_tree().process_frame
		
		# Esegui i test
		var test_script = test_instance.get_script()
		if test_script:
			test_script.run_all_tests()
		else:
			push_error("Impossibile ottenere lo script di test")
		
		# Rimuovi la scena di test
		test_instance.queue_free()
	else:
		push_error("Impossibile ottenere la root della scena")
	
	print("\n=== Test Unit Completati ===\n") 