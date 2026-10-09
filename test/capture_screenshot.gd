extends SceneTree

func _init() -> void:
	var main_scene = load("res://scenes/main/main.tscn")
	var main_instance = main_scene.instantiate()
	root.add_child(main_instance)
	
	await create_timer(0.4).timeout
	
	# Adicionar comandos de exemplo
	main_instance._on_command_added(CommandTypes.MOVE_FORWARD)
	main_instance._on_command_added(CommandTypes.MOVE_FORWARD)
	main_instance._on_command_added(CommandTypes.MOVE_FORWARD)
	main_instance._on_command_added(CommandTypes.MOVE_FORWARD)
	main_instance._on_command_added(CommandTypes.TURN_RIGHT)
	main_instance._on_command_added(CommandTypes.MOVE_FORWARD)
	main_instance._on_command_added(CommandTypes.COLLECT)
	
	await create_timer(0.3).timeout
	
	var img = root.get_texture().get_image()
	img.save_png("screenshot_level1.png")
	print("📸 Captura de tela salva em screenshot_level1.png!")
	quit(0)
