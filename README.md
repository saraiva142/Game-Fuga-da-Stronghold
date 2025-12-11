# Fuga da Stronghold

## Visão Geral do Projeto

O projeto **Fuga da Stronghold** é um jogo eletrônico desenvolvido como trabalho final para a disciplina de **Computação Gráfica**. Inspirado na temática das *Strongholds* do Minecraft, o jogo desafia o jogador a navegar por um labirinto gerado aleatoriamente, com o objetivo de coletar três *Ender Pearls* (Pérolas do Fim) antes que o tempo se esgote, enquanto evita o contato com um monstro.

O jogo foi desenvolvido utilizando a **Godot Engine 4.x**, aproveitando seus recursos de renderização 3D e sistema de *GridMap* para a construção dinâmica do cenário.

### 👥 Desenvolvedores

| Nome | Função |
| :--- | :--- |
| **João Saraiva** | Desenvolvedor |
| **Lucas Antonelli** | Desenvolvedor |
| **Sérgio Filho** | Desenvolvedor |

---

## Jogabilidade e Mecânicas

### Objetivo
O jogador deve coletar **3 Ender Pearls** espalhadas pelo labirinto para alcançar a vitória.

### Mecânicas Principais
1.  **Exploração do Labirinto:** O cenário é um labirinto 3D gerado de forma procedural, garantindo uma experiência única a cada partida.
2.  **Coleta de Itens:** As *Ender Pearls* (representadas como moedas no código) são os itens de objetivo. A coleta é registrada no HUD.
3.  **Ameaça Constante:** Um monstro patrulha o labirinto. O contato com o monstro resulta em derrota imediata (*Game Over*).
4.  **Tempo Limite:** O jogo possui um cronômetro regressivo de 10 minutos (600 segundos). Se o tempo zerar, o jogador perde.
5.  **Menu de Pausa:** O jogo pode ser pausado a qualquer momento pressionando a tecla `ESC`.

---

## 🛠️ Documentação Técnica

### Motor de Jogo
O projeto foi desenvolvido na **Godot Engine**, versão 4.x.

### Estrutura de Cenas e Hierarquia

A cena principal do jogo é `main.tscn`, que orquestra a lógica do jogo, a geração do labirinto e o gerenciamento de estado (Menu, HUD, Vitória, Derrota).

| Cena | Descrição | Propriedades Chave |
| :--- | :--- | :--- |
| `main.tscn` | Nó principal (`Node3D`) que contém o script de controle do jogo (`main.gd`). | `cena_jogador`, `cena_moeda`, `cena_monstro` (referências a cenas empacotadas), `largura_labirinto`, `altura_labirinto`, `total_moedas` (3). |
| `Fase_1.tscn` | Representa o jogador (`CharacterBody3D`). | Script `jogador.gd` (movimentação e controle), `PcModel.glb` (modelo 3D), `Camera3D` (visão do jogador), `SpotLight3D` (lanterna). |
| `moeda.tscn` | Representa a *Ender Pearl* (`Area3D`). | Script `moeda.gd` (lógica de coleta), `SphereShape3D` (colisão), `QuadMesh` com textura `enderPearl.png` (billboard para sempre encarar a câmera). |
| `monstro.tscn` | Representa o inimigo (`CharacterBody3D`). | Script `monstro.gd` (lógica de patrulha/perseguição), `DeviSk8.glb` (modelo 3D), `BoxShape3D` e `CapsuleShape3D` (colisão). |
| `HUD.tscn` | Interface de Usuário. | Exibe o contador de *Ender Pearls* coletadas e o tempo restante. |
| `Menu.tscn` | Menu de pausa e inicial. | Permite iniciar o jogo e pausar/retomar a partida. |
| `Vitoria.tscn` | Tela de vitória. | Exibida ao coletar as 3 *Ender Pearls*. |
| `Derrota.tscn` | Tela de derrota. | Exibida ao ser pego pelo monstro ou ao esgotar o tempo. |

### Geração Procedural do Labirinto

O labirinto é gerado dinamicamente no script `main.gd` utilizando o nó **GridMap** e o algoritmo **Recursive Backtracker** (Retrocesso Recursivo).

1.  **Inicialização:** O `GridMap` é preenchido inteiramente com blocos de parede (`ID_PAREDE = 1`).
2.  **Criação de Caminhos:** O algoritmo "cava" os túneis, transformando as células de parede em chão (`ID_CHAO = 0`), garantindo que todos os pontos do labirinto sejam acessíveis.
3.  **Posicionamento de Itens:** Após a geração do labirinto, o jogador, as 3 *Ender Pearls* e o monstro são instanciados em posições de chão válidas e aleatórias, garantindo que o jogador comece em um local seguro e os objetivos estejam espalhados.

### Texturas e Propriedades Gráficas

O projeto utiliza texturas e modelos 3D que remetem ao estilo visual do Minecraft, conforme a proposta do trabalho.

| Asset | Tipo | Uso | Propriedades Gráficas |
| :--- | :--- | :--- | :--- |
| `chaoMine.jpg` | Textura | Aplicada ao chão do labirinto. | Textura de piso com tema Minecraft. |
| `enderPearl.png` | Textura | Aplicada ao `QuadMesh` da *Ender Pearl*. | Utilizada em um material com transparência e *cull mode* desativado para criar um efeito de item 2D que sempre olha para a câmera (*billboard*). |
| `PcModel.glb` | Modelo 3D | Modelo do jogador. | Importado e escalado para se adequar ao ambiente do labirinto. |
| `DeviSk8.glb` | Modelo 3D | Modelo do monstro. | Importado e escalado. |
| `minha_library.tres` | MeshLibrary | Contém os blocos 3D (parede e chão) utilizados pelo `GridMap`. | Define as malhas e materiais para os IDs `ID_PAREDE` e `ID_CHAO`. |
| `SpotLight3D` | Luz | Lanterna do jogador. | `light_energy` ajustada para criar um ambiente escuro e tenso, com foco no caminho do jogador. |

---

## 🚀 Como Executar o Projeto

1.  **Pré-requisitos:** Instale a **Godot Engine 4.x** (versão compatível com o `config_version=5` do `project.godot`).
2.  **Clonar o Repositório:**
    ```bash
    git clone https://github.com/saraiva142/Game-Fuga-da-Stronghold.git
    ```
3.  **Abrir na Godot:** Abra a Godot Engine e importe o projeto selecionando o arquivo `project.godot` dentro da pasta clonada.
4.  **Executar:** Pressione o botão "Play" (ou F5) na Godot Engine para iniciar o jogo.

## Imagens

<img width="1915" height="935" alt="image" src="https://github.com/user-attachments/assets/dd6ddc25-19ec-4d5a-9832-e1a36db0d948" />

<img width="1919" height="961" alt="image" src="https://github.com/user-attachments/assets/e2ac6d7e-8b78-4dbb-baa4-f5d979beb7b2" />

<img width="1919" height="963" alt="image" src="https://github.com/user-attachments/assets/f6f02334-d3db-4d52-adeb-de7bb0ba652d" />

<img width="464" height="308" alt="image 1 (3)" src="https://github.com/user-attachments/assets/300c0814-cefe-4b36-be18-9a8223a5970d" />
