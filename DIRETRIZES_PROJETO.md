# 🐾 Diretrizes e Documentação do Projeto: CatCode — Aventura Lógica

> **Projeto:** Jogo Educativo de Lógica de Programação — CatCode / GABA (UECE)  
> **Motor:** Godot Engine 4.x (GDScript)  
> **Público-alvo:** Crianças e adolescentes (10 a 17 anos) e iniciantes em programação  
> **Documento Oficial:** `CatCode.pdf`  
> **Status:** Fase 1 — Implementada e Validada (Robô, Mia, Menu Iniciar, Seleção de Fases e Gameplay)

---

## 1. Visão Geral e Narrativa do Jogo

O **CatCode** é um jogo educativo 2D de puzzle em visão superior (*top-down* baseada em grade).
A história se passa em uma ONG de proteção e cuidado animal:
- O jogador programa um **pequeno Robô assistente** do abrigo.
- O objetivo é planejar sequências algorítmicas de blocos de comando para alimentar, hidratar e cuidar dos animais acolhidos.
- **Personagens acolhidos:**
  - **Mia:** Gatinha filhote assustada, precisa de alimento, água e carinho.
  - **Bento:** Cãozinho brincalhão e explorador, gosta de passear por caminhos com obstáculos.
  - **Luna:** Gata adulta na enfermaria que necessita de medicamentos e cuidados especiais.

---

## 2. Estrutura Modular de Cenas e Código

A arquitetura do projeto foi reformulada para ser 100% modular, desacoplada e perfeita para desenvolvimento em equipe no Git/GitHub:

```
Jogo_robo/
├── .gitignore                      # Exclusão de caches da Godot (.godot/)
├── project.godot                   # Configuração e inicialização da cena
├── CatCode.pdf                     # Documento de especificações
├── PLANEJAMENTO_PROJETO_CATCODE.md # Documento para reunião de alinhamento da equipe
├── assets/
│   ├── sprites/
│   │   ├── sprits.png              # Folha original de sprites
│   │   ├── menu_iniciar.png        # Arte do Menu Principal
│   │   ├── menu_fases_niveis.png   # Arte da Seleção de Níveis
│   │   ├── cena_principal.png      # Layout de referência da jogabilidade
│   │   ├── cutouts/                # Sprites recortados com transparência
│   │   │   ├── robot_down.png, robot_up.png, robot_left.png, robot_right.png, robot_happy.png
│   │   │   ├── cat_mia.png, cat_orange.png, cat_tabby.png, cat_black.png
│   │   │   ├── bowl_food.png, bowl_water.png
│   │   │   ├── bush_white.png, bush_yellow.png, tree.png, box_1.png, box_2.png, tile_stone.png...
│   │   └── ui/                     # Recortes de UI (seta voltar, Mia miau)
├── scenes/
│   ├── robot/                      # Personagem programável do Robô
│   │   ├── robot.gd
│   │   └── robot.tscn
│   ├── entities/                   # Entidades alvo (Mia, Bento, Luna)
│   │   ├── cat_target.gd
│   │   └── cat_target.tscn
│   ├── board/                      # Tabuleiro em grade e obstáculos
│   │   ├── board.gd
│   │   └── board.tscn
│   ├── ui/                         # Interface da IDE e botões
│   │   ├── hud.gd
│   │   ├── hud.tscn
│   │   ├── palette_button.gd
│   │   ├── palette_button.tscn
│   │   ├── command_item.gd
│   │   └── command_item.tscn
│   ├── menus/                      # Telas de navegação
│   │   ├── start_menu.gd & .tscn
│   │   └── level_select.gd & .tscn
│   └── main/                       # Orquestrador da partida
│       ├── main.gd
│       └── main.tscn
├── scripts/
│   └── core/
│       ├── command_types.gd        # Definição e cores dos comandos
│       └── level_data.gd           # Dados e progressão pedagógica das fases
└── test/
    ├── test_gameplay.gd            # Validação automatizada de vitória da Fase 1
    ├── test_failures.gd            # Validação de colisões e feedback pedagógico
    └── verify_menus.gd             # Validação de integridade de todas as cenas
```

---

## 3. Comandos Disponíveis no Jogo

| Comando | Rótulo no Jogo | Cor Visual | Função Pedagógica |
| :--- | :--- | :--- | :--- |
| `MOVE_FORWARD` | `ANDAR` | Magenta `#d938ff` | Avança 1 casa na direção em que o robô está olhando. |
| `TURN_LEFT` | `VIRE A ESQUERDA` | Verde `#00c875` | Gira o robô 90° no sentido anti-horário. |
| `TURN_RIGHT` | `VIRE A DIREITA` | Azul `#4568f5` | Gira o robô 90° no sentido horário. |
| `COLLECT` | `COLETAR` | Laranja `#f27249` | Recolhe o item (ração, água ou remédio) na casa atual. |
| `FEED` | `ALIMENTAR` | Rosa `#f73b6b` | Alimenta ou atende o animal acolhido na casa atual. |
| `LOOP` | `REPETIR ( )` | Ciano `#2bd4f7` | Repete uma sequência de comandos (introduzido no Cenário 2). |

---

## 4. Como Executar e Testar

### No Editor Godot 4:
1. Abra o **Godot Engine 4.x**.
2. Abra o projeto na pasta `Jogo_robo`.
3. Pressione **F5** para iniciar pelo **Menu Iniciar** (`res://scenes/menus/start_menu.tscn`), ou **F6** em `res://scenes/main/main.tscn` para rodar diretamente a Fase 1 da Mia!

### Pelo Terminal / Linha de Comando:
```powershell
# Iniciar o jogo:
& "C:\Program Files\Godot\Godot_v4.6.2-stable_win64_console.exe" --path "g:\Outros computadores\Meu laptop\Ciência da Computação\UECE - Ciência da Computação\Extensão II\Jogo_robo"

# Executar os testes automatizados da Fase 1:
& "C:\Program Files\Godot\Godot_v4.6.2-stable_win64_console.exe" --headless --path "g:\Outros computadores\Meu laptop\Ciência da Computação\UECE - Ciência da Computação\Extensão II\Jogo_robo" -s "test/test_gameplay.gd"
```
