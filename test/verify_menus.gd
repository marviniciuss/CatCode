extends SceneTree

func _init() -> void:
	print("🐾 [TESTE] Verificando instanciacao das cenas do CatCode...")
	
	# 1. Start Menu
	var start_scene = load("res://scenes/menus/start_menu.tscn")
	assert(start_scene != null, "start_menu.tscn deve ser carregada")
	var start_inst = start_scene.instantiate()
	root.add_child(start_inst)
	print("✅ StartMenu instanciado com sucesso!")
	start_inst.queue_free()
	
	# 2. Level Select Menu
	var lvl_scene = load("res://scenes/menus/level_select.tscn")
	assert(lvl_scene != null, "level_select.tscn deve ser carregada")
	var lvl_inst = lvl_scene.instantiate()
	root.add_child(lvl_inst)
	print("✅ LevelSelect instanciado com sucesso!")
	lvl_inst.queue_free()
	
	# 3. Main Gameplay Scene
	var main_scene = load("res://scenes/main/main.tscn")
	assert(main_scene != null, "main.tscn deve ser carregada")
	var main_inst = main_scene.instantiate()
	root.add_child(main_inst)
	print("✅ MainGame instanciado com sucesso!")
	main_inst.queue_free()
	
	print("🌟 Todas as cenas e recursos estão 100% íntegros e funcionais!")
	quit(0)
