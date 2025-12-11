extends CharacterBody3D

const SPEED = 2.0
const GRAVITY = 9.8

var rng = RandomNumberGenerator.new()
var current_direction = Vector3.FORWARD

signal jogador_derrotado

func _ready():
	rng.randomize()
	# Começa escolhendo uma direção aleatória
	escolher_nova_direcao()
	
	# CONECTAR O AREA3D VIA CÓDIGO (Ou faça pelo editor se preferir)
	# Assumindo que você criou o nó com nome "Area3D"
	var area = $Area3D 
	if area:
		area.body_entered.connect(_on_area_3d_body_entered)
	else:
		print("ERRO: Faltou criar o Area3D na cena do monstro!")

func escolher_nova_direcao():
	# Escolhe um ângulo aleatório em 360 graus (PI * 2)
	var angulo_aleatorio = rng.randf_range(0, TAU) 
	current_direction = Vector3(sin(angulo_aleatorio), 0, cos(angulo_aleatorio)).normalized()
	
	# Gira o monstro para olhar para onde vai andar
	look_at(position + current_direction)

func _physics_process(delta):
	# 1. Aplicar Gravidade
	if not is_on_floor():
		velocity.y -= GRAVITY * delta
	
	# 2. Definir velocidade na direção atual
	velocity.x = current_direction.x * SPEED
	velocity.z = current_direction.z * SPEED
	
	# 3. Mover
	move_and_slide()
	
	# 4. Lógica "Roomba": Se bater na parede, muda de direção
	if is_on_wall():
		escolher_nova_direcao()

# FUNÇÃO DO SENSOR (AREA3D)
func _on_area_3d_body_entered(body):
	# Verifica se quem entrou na área é o Jogador
	# Verifica pelo nome OU pelo grupo (mais seguro)
	if body.name == "Jogador" or body.is_in_group("player"):
		print("O monstro pegou o jogador!")
		emit_signal("jogador_derrotado")
		# Opcional: Para o monstro não matar 2x seguidas
		set_physics_process(false)
