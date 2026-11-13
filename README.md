# CatCode

[![Godot](https://img.shields.io/badge/Godot-4.7-478cbf?logo=godot-engine&logoColor=white)](https://godotengine.org/)
[![Linguagem](https://img.shields.io/badge/Linguagem-GDScript-478cbf?logo=godot-engine&logoColor=white)](https://docs.godotengine.org/en/stable/tutorials/scripting/gdscript/)
[![Renderização](https://img.shields.io/badge/Renderização-Compatibility%20%2F%20GL%20Compatibility-6b7280)](project.godot)
[![Versão](https://img.shields.io/badge/versão-2.0.0-7c3aed)](project.godot)

## Sobre o jogo

No CatCode, o jogador programa um robô assistente de uma ONG de proteção animal. A missão é montar uma sequência de blocos, executar o algoritmo e levar alimento até o animal acolhido, desviando de obstáculos e aprendendo lógica de programação na prática.

O jogo foi pensado para crianças, adolescentes e iniciantes em programação, com foco em:

- sequenciamento de instruções;
- orientação  e resolução de problemas;
- tentativa, erro e feedback visual.


## Como jogar

1. Abra o jogo pelo menu inicial.
2. Escolha uma fase disponível.
3. Clique nos blocos da paleta para montar o programa.
4. Ajuste repetições e condições quando necessário.
5. Pressione **Executar** para rodar o algoritmo.
6. Use **Reiniciar** para reposicionar o robô ou **Limpar** para apagar o programa.

O objetivo é coletar o item e executar `ALIMENTAR` na casa do animal. Se o robô bater em uma borda ou obstáculo, o jogo interrompe a execução e explica o que precisa ser corrigido.

## Arquitetura

```text
CatCode/
├── project.godot              # Configuração do projeto e cena inicial
├── assets/                    # Sprites, ícones, fontes, músicas e efeitos
├── scenes/
│   ├── board/                 # Grade, obstáculos e itens
│   ├── entities/              # Animais acolhidos
│   ├── main/                 # Orquestração da partida
│   ├── menus/                # Menu inicial e seleção de fases
│   ├── robot/                # Robô programável
│   └── ui/                   # HUD, paleta e cartões de comandos
├── scripts/core/              # Comandos, fases e gerenciamento de áudio
└── test/                      # Testes automatizados de cenas e gameplay
```

O projeto usa cenas modulares e scripts em GDScript para facilitar manutenção, testes e trabalho em equipe.

## Executar o projeto

O CatCode usa **Godot 4.7**. Baixe a versão padrão (não a versão .NET) em
[godotengine.org/download](https://godotengine.org/download/).

### 1. Obter o código

Se você ainda não tem o projeto:

```bash
git clone https://github.com/marviniciuss/CatCode.git
cd CatCode
```

> Não abra apenas `scenes/` ou `scripts/`. O arquivo `project.godot` deve ficar na raiz selecionada no Godot.

### 2. Windows

#### Pelo editor

1. Abra o **Godot Project Manager**.
2. Clique em **Import**.
3. Selecione `project.godot` dentro da pasta `CatCode`.
4. Selecione o projeto e clique em **Edit**.
5. Pressione **F5** para iniciar o jogo ou **F6** para executar a cena aberta.

A cena inicial configurada é:

```text
res://scenes/menus/start_menu.tscn
```

#### Pelo PowerShell

Na raiz do projeto, se `godot` estiver no `PATH`:

```powershell
godot --path . --editor
godot --path .
```

Se não estiver no `PATH`, use o caminho completo do executável:

```powershell
& "C:\Godot\Godot_v4.7-stable_win64.exe" --path "C:\Users\SeuNome\CatCode" --editor
& "C:\Godot\Godot_v4.7-stable_win64.exe" --path "C:\Users\SeuNome\CatCode"
```

### 3. Linux

Depois de baixar o executável do Godot, dê permissão de execução:

```bash
chmod +x Godot_v4.7-stable_linux.x86_64
```

Na raiz do projeto, abra o editor ou execute o jogo:

```bash
./Godot_v4.7-stable_linux.x86_64 --path . --editor
./Godot_v4.7-stable_linux.x86_64 --path .
```

Se o Godot estiver instalado no sistema, use:

```bash
godot --path . --editor
godot --path .
```

### 4. Executar os testes

Os testes devem ser executados a partir da raiz do projeto.

**Windows / PowerShell:**

```powershell
godot --headless --path . -s test/verify_menus.gd
godot --headless --path . -s test/test_gameplay.gd
godot --headless --path . -s test/test_failures.gd
```

**Linux:**

```bash
godot --headless --path . -s test/verify_menus.gd
godot --headless --path . -s test/test_gameplay.gd
godot --headless --path . -s test/test_failures.gd
```

Se estiver usando o executável baixado diretamente no Linux, troque `godot` por `./Godot_v4.7-stable_linux.x86_64`.

## Testes automatizados

Os testes ficam em [`test/`](test/) e cobrem:

- integridade e instanciação dos menus e da cena principal;
- solução completa da Fase 1;
- colisão com borda e obstáculo;
- programa vazio e missão incompleta;
- exibição dos modais de vitória e falha.

Execute cada teste em modo headless:

```powershell
godot --headless --path . -s test/verify_menus.gd
godot --headless --path . -s test/test_gameplay.gd
godot --headless --path . -s test/test_failures.gd
```

## Desenvolvimento

- **Engine:** Godot 4.7
- **Linguagem:** GDScript
- **Renderização:** Compatibility / GL Compatibility
- **Resolução-base:** 1280 × 720
- **Versão atual:** 2.0.0
