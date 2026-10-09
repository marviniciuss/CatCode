extends SceneTree

func _init() -> void:
	print("🐾 [TESTE] Testando modos de falha e feedback pedagógico do CatCode...")
	
	var main_scene = load("res://scenes/main/main.tscn")
	var main_instance = main_scene.instantiate()
	root.add_child(main_instance)
	await create_timer(0.2).timeout
	
	var hud = main_instance.hud
	var board = main_instance.board
	var robot = main_instance.robot
	
	# Teste 1: Bater na parede (andar além do grid de 6 colunas)
	print("Teste 1: Verificando colisão com a borda do mapa...")
	for k in range(7):
		main_instance._on_command_added(CommandTypes.MOVE_FORWARD)
		
	main_instance._on_run_requested()
	while main_instance.is_executing:
		await create_timer(0.1).timeout
	await create_timer(0.2).timeout
	
	assert(hud.failure_modal.visible, "Modal de falha deveria estar visível após bater na borda")
	print("✅ Colisão com borda detectada e feedback exibido com sucesso!")
	
	# Teste 2: Colisão com o arbusto em (2, 2)
	print("Teste 2: Verificando colisão com arbusto obstáculo em (2, 2)...")
	main_instance._on_reset_requested()
	main_instance._on_program_cleared()
	
	main_instance._on_command_added(CommandTypes.MOVE_FORWARD) # (1, 0)
	main_instance._on_command_added(CommandTypes.MOVE_FORWARD) # (2, 0)
	main_instance._on_command_added(CommandTypes.TURN_RIGHT)   # olha para Baixo
	main_instance._on_command_added(CommandTypes.MOVE_FORWARD) # (2, 1)
	main_instance._on_command_added(CommandTypes.MOVE_FORWARD) # tenta entrar em (2, 2) onde está o arbusto!
	
	main_instance._on_run_requested()
	while main_instance.is_executing:
		await create_timer(0.1).timeout
	await create_timer(0.2).timeout
	
	assert(hud.failure_modal.visible, "Modal de falha deveria estar visível após colidir com obstáculo")
	print("✅ Colisão com obstáculo detectada e feedback exibido com sucesso!")
	
	# Teste 3: Parada sem cumprir missão
	print("Teste 3: Verificando término do programa sem concluir objetivo...")
	main_instance._on_reset_requested()
	main_instance._on_program_cleared()
	
	main_instance._on_command_added(CommandTypes.MOVE_FORWARD)
	main_instance._on_run_requested()
	while main_instance.is_executing:
		await create_timer(0.1).timeout
	await create_timer(0.2).timeout
	
	assert(hud.failure_modal.visible, "Modal de falha deveria estar visível por não cumprir objetivo")
	print("✅ Feedback pedagógico de missão incompleta exibido com sucesso!")
	
	print("🌟 Todos os testes de regras e falhas passaram com 100% de sucesso!")
	quit(0)
