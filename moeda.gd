extends Area3D

signal coletada

func _on_body_entered(body):
	# O MODO DETETIVE:
	print("Alguém encostou na moeda! O nome dele é: ", body.name)
	
	# Verifica se o nome COMEÇA com "Jogador" (mais seguro)
	if body.name.begins_with("Jogador") or body.name == "CharacterBody3D":
		print("Era o jogador! Coletando...")
		emit_signal("coletada")
		queue_free()
		
var tempo = 0.0

func _process(delta):
	rotate_y(3.0 * delta) # Gira na horizontal
	
	# Faz flutuar (Senoide)
	tempo += delta
	var flutuacao = sin(tempo * 5.0) * 0.0005 # Ajuste o 0.005 para a altura
	position.y += flutuacao
