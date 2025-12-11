extends Node3D

@onready var menu = $Menu
@onready var hud = $HUD 
@onready var tela_vitoria = $Vitoria
@onready var tela_derrota = $Derrota

func _on_moeda_coletada():
	moedas_coletadas += 1
	print("Moedas: ", moedas_coletadas)
	
	# Atualiza o HUD
	hud.atualizar_hud(moedas_coletadas)
	
	# VERIFICA VITORIA IMEDIATA
	if moedas_coletadas >= total_moedas:
		vitoria()

func vitoria():
	print("PARABENS! VOCÊ VENCEU!")
	jogo_ativo = false
	
	# Apenas mostramos o Overlay. NÃO trocamos de cena aqui.
	# O script da TelaVitoria vai pausar o jogo e soltar o mouse.
	if tela_vitoria:
		tela_vitoria.mostrar_vitoria()
	else:
		print("ERRO: Nó da Tela de Vitória não encontrado!")

#TEMPO
@export var tempo_total = 600.0 # Tempo em segundos (1 minuto)
var tempo_atual = 0.0
var jogo_ativo = true # Para parar o relógio se ganhar ou perder


# CONFIGURAÇÕES
@export var largura_labirinto = 20  # Tamanho em blocos
@export var altura_labirinto = 20
@onready var grid_map = $GridMap

# ITENS PARA SPAWNAR (Arraste as cenas .tscn aqui no Inspector)
@export var cena_jogador: PackedScene
@export var cena_moeda: PackedScene
@export var cena_monstro: PackedScene


# VARIÁVEIS DE CONTROLE
var celulas_visitadas = []
var pilha = []
var moedas_coletadas = 0
var total_moedas = 3

# IDs DA MESHLIBRARY 
const ID_PAREDE = 1 
const ID_CHAO = 0 
const VAZIO = -1

# --- MODIFIQUE O _READY ---
func _ready():
	randomize()
	tempo_atual = tempo_total # Começa com o tanque cheio
	gerar_labirinto()
	if tela_vitoria:
		tela_vitoria.visible = false 
	if tela_derrota:
		tela_derrota.visible = false
	menu.mostrar_menu()


func _process(delta):
	# Só conta o tempo se o jogo estiver valendo
	if jogo_ativo:
		tempo_atual -= delta # Diminui o tempo a cada frame
		
		# Atualiza o HUD visualmente
		hud.atualizar_tempo(tempo_atual)
		
		# VERIFICA DERROTA
		if tempo_atual <= 0:
			game_over()

func game_over():
	jogo_ativo = false
	print("TEMPO ESGOTADO! VOCÊ PERDEU!")
	tela_derrota.mostrar_derrota()


func gerar_labirinto():
	grid_map.clear()
	
	# 1. PREENCHE TUDO COM PAREDES (Bloco sólido)
	for x in range(largura_labirinto):
		for z in range(altura_labirinto):
			grid_map.set_cell_item(Vector3i(x, 0, z), ID_PAREDE)

	# 2. ALGORITMO RECURSIVE BACKTRACKER (Cava os túneis)
	var inicio = Vector2i(1, 1) # Começa na posição 1,1
	grid_map.set_cell_item(Vector3i(inicio.x, 0, inicio.y), ID_CHAO)
	pilha.append(inicio)
	celulas_visitadas.append(inicio)
	
	var pos_chao_validas = [inicio] # Lista para saber onde podemos por moedas

	while not pilha.is_empty():
		var atual = pilha.back()
		var vizinhos = pegar_vizinhos_nao_visitados(atual)
		
		if vizinhos.size() > 0:
			var proximo = vizinhos.pick_random()
			# Remove a parede ENTRE o atual e o próximo (Cava o túnel)
			var parede_meio = (atual + proximo) / 2
			grid_map.set_cell_item(Vector3i(parede_meio.x, 0, parede_meio.y), ID_CHAO)
			# Define o próximo como chão
			grid_map.set_cell_item(Vector3i(proximo.x, 0, proximo.y), ID_CHAO)
			
			pilha.append(proximo)
			celulas_visitadas.append(proximo)
			pos_chao_validas.append(proximo)
		else:
			pilha.pop_back()

	# 3. COLOCAR ITENS
	pos_chao_validas.shuffle() # Embaralha as posições livres
	
	# Colocar Jogador (na primeira posição livre)
	var pos_player = pos_chao_validas.pop_front()
	var player = cena_jogador.instantiate()
	player.name = "Jogador"
	add_child(player)
	player.position = grid_map.map_to_local(Vector3i(pos_player.x, 0, pos_player.y))
	
	# Colocar 3 Moedas
	for i in range(total_moedas):
		if pos_chao_validas.is_empty(): break
		var pos_moeda = pos_chao_validas.pop_front()
		var moeda = cena_moeda.instantiate()
		add_child(moeda)
		moeda.position = grid_map.map_to_local(Vector3i(pos_moeda.x, 0, pos_moeda.y))
		# Conecta o sinal da moeda (se ela tiver um sinal 'coletada')
		moeda.connect("coletada", _on_moeda_coletada)
		
	# COLOCAR O MONSTRO
	if not pos_chao_validas.is_empty():
		# Pega uma posição aleatória longe do início
		var pos_monstro = pos_chao_validas.pick_random() # Usar pick_random é melhor que o primeiro da lista
		
		var monstro = cena_monstro.instantiate()
		add_child(monstro)

		# Posiciona no grid
		var posicao_real = grid_map.map_to_local(Vector3i(pos_monstro.x, 0, pos_monstro.y))
		monstro.position = posicao_real
		monstro.position.y = 0.5 # Coloca mais perto do chão para não bugar na queda
		
		# Conectar o sinal de derrota
		monstro.connect("jogador_derrotado", Callable(self, "_quando_monstro_derrota"))

func pegar_vizinhos_nao_visitados(pos):
	var lista = []
	# Verifica Cima, Baixo, Esquerda, Direita (pula de 2 em 2 para deixar paredes)
	var direcoes = [Vector2i(0, 2), Vector2i(0, -2), Vector2i(2, 0), Vector2i(-2, 0)]
	
	for dir in direcoes:
		var nova_pos = pos + dir
		if nova_pos.x > 0 and nova_pos.x < largura_labirinto - 1 and \
		   nova_pos.y > 0 and nova_pos.y < altura_labirinto - 1:
			if not nova_pos in celulas_visitadas:
				lista.append(nova_pos)
	return lista

func _input(event):
	# Se apertar ESC (tecla ui_cancel)
	if event.is_action_pressed("ui_cancel"):
		# Alterna: Se está visível, esconde. Se está escondido, mostra.
		if menu.visible:
			menu.esconder_menu()
		else:
			menu.mostrar_menu()

func _quando_monstro_derrota():
	print("O MONSTRO TE PEGOU! GAME OVER!")
	game_over()
