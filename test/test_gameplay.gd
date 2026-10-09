extends SceneTree

func _init() -> void:
	print("🐾 [TESTE] Iniciando validação do CatCode (Fase 1 — Robô & Mia)...")
	
	var main_scene = load("res://scenes/main/main.tscn")
	var main_instance = main_scene.instantiate()
	root.add_child(main_instance)
	
	await create_timer(0.2).timeout
	
	var hud = main_instance.hud
	var board = main_instance.board
	var robot = main_instance.robot
	
	assert(board != null, "Board deve existir")
	assert(robot != null, "Robot deve existir")
	assert(hud != null, "HUD deve existir")
	
	print("✅ Cena principal instanciada com sucesso.")
	print("📍 Posição inicial do Robô: ", robot.grid_pos, " | Olhando para: ", robot.facing_dir)
	print("🥣 Posição da comida: ", board.food_pos)
	print("🐱 Posição da Mia: ", board.animal_pos)
	
	# Sequência exata da Fase 1:
	var sol = [
		CommandTypes.MOVE_FORWARD, # (1, 0)
		CommandTypes.MOVE_FORWARD, # (2, 0)
		CommandTypes.MOVE_FORWARD, # (3, 0)
		CommandTypes.MOVE_FORWARD, # (4, 0)
		CommandTypes.TURN_RIGHT,   # olha para Baixo
		CommandTypes.MOVE_FORWARD, # (4, 1)
		CommandTypes.COLLECT,      # pega ração
		CommandTypes.MOVE_FORWARD, # (4, 2)
		CommandTypes.MOVE_FORWARD, # (4, 3)
		CommandTypes.MOVE_FORWARD, # (4, 4)
		CommandTypes.TURN_LEFT,    # olha para Direita
		CommandTypes.MOVE_FORWARD, # (5, 4)
		CommandTypes.FEED          # alimenta Mia
	]
	
	print("📝 Inserindo comandos no algoritmo...")
	for cmd in sol:
		main_instance._on_command_added(cmd)
	
	assert(main_instance.program_commands.size() == 13, "Deveriam existir 13 comandos")
	print("▶ Executando programa...")
	main_instance._on_run_requested()
	
	while main_instance.is_executing:
		await create_timer(0.1).timeout
	
	await create_timer(0.3).timeout
	
	print("🏁 Execução concluída!")
	print("🤖 Robô finalizou em: ", robot.grid_pos)
	print("🐱 Mia foi alimentada?: ", board.is_animal_fed)
	print("🎉 Modal de vitória visível?: ", hud.victory_modal.visible)
	
	if board.is_animal_fed and hud.victory_modal.visible:
		print("🌟 SUCESSO TOTAL! Fase 1 do CatCode validada de ponta a ponta com vitória!")
		quit(0)
	else:
		printerr("❌ FALHA no teste de jogabilidade!")
		quit(1)
