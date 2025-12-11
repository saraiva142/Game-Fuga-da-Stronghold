extends Area3D

var aberta = false

func _ready():
	# Garante que a porta tenha um material próprio para podermos mudar a cor
	var mesh = $MeshInstance3D
	if mesh.material_override == null:
		mesh.material_override = StandardMaterial3D.new()
	
	trancar() # Começa trancada e vermelha

func trancar():
	aberta = false
	if $MeshInstance3D.material_override:
		$MeshInstance3D.material_override.albedo_color = Color.RED

func destrancar():
	aberta = true
	if $MeshInstance3D.material_override:
		$MeshInstance3D.material_override.albedo_color = Color.GREEN

func _on_body_entered(body):
	# Verifica se quem encostou é o jogador E se a porta está aberta
	if body.name == "Jogador" and aberta:
		print("VOCÊ GANHOU! FIM DE JOGO")
		# Aqui você pode mudar para uma cena de "Vitória" ou fechar o jogo
		get_tree().quit() # Fecha o jogo
