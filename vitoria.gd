extends CanvasLayer

func _ready():
	# IMPORTANTE: Garante que ela começa invisível e não pausa o jogo de cara
	visible = false 
	process_mode = Node.PROCESS_MODE_ALWAYS # Garante que funcione no pause

func mostrar_vitoria():
	visible = true
	get_tree().paused = true
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE

func _on_button_reiniciar_pressed():
	get_tree().paused = false
	get_tree().reload_current_scene()

func _on_button_sair_pressed():
	get_tree().quit()
