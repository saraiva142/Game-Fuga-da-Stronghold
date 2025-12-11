extends CanvasLayer

@onready var container = $HBoxContainer

func _ready():
	# Começa atualizando para 0 moedas (tudo apagado)
	atualizar_hud(0)

func atualizar_hud(moedas_coletadas):
	# Pega a lista dos 3 ícones (filhos do HBoxContainer)
	var icones = container.get_children()
	
	# Passa por cada ícone (0, 1 e 2)
	for i in range(icones.size()):
		if i < moedas_coletadas:
			# Se já coletou essa moeda, deixa totalmente visível
			icones[i].modulate.a = 1.0 
		else:
			# Se não coletou, deixa meio transparente (Opaco)
			icones[i].modulate.a = 0.3
			
# Referência ao texto que acabamos de criar
@onready var label_tempo = $TimerLabel 

func atualizar_tempo(segundos_restantes):
	# Transforma o número quebrado (ex: 59.9) em inteiro (59)
	var tempo_int = int(segundos_restantes)
	
	# Matemática básica de relógio
	var minutos = tempo_int / 60
	var segundos = tempo_int % 60
	
	# Formata para ficar bonito (ex: 01:05 em vez de 1:5)
	# %02d significa: "número com 2 dígitos, preenchido com zero"
	label_tempo.text = "%02d:%02d" % [minutos, segundos]
