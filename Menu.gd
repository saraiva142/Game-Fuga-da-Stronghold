extends CanvasLayer

signal jogo_continuado

func _ready():
	# Garante que começa visível e com mouse solto (para clicar em Iniciar)
	mostrar_menu()

func mostrar_menu():
	visible = true
	get_tree().paused = true
	
	# MÁGICA AQUI: Solta o mouse para virar uma setinha e clicar
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE

func esconder_menu():
	visible = false
	get_tree().paused = false
	
	# MÁGICA AQUI: Prende o mouse de volta para o jogo FPS
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

func _on_button_iniciar_pressed():
	esconder_menu()
	emit_signal("jogo_continuado")

func _on_button_sair_pressed():
	get_tree().quit()
