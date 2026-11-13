# 🐾 CatCode — Planejamento Pedagógico de Novos Blocos e Trilha de Evolução Lógica

> **Projeto:** CatCode — Jogo Educativo de Lógica de Programação e Pensamento Computacional  
> **Temática:** Cuidado e Acolhimento Animal — Projeto GABA / Universidade Estadual do Ceará (UECE)  
> **Motor:** Godot Engine 4.x (GDScript)  
> **Público-Alvo:** Crianças e adolescentes (10 a 17 anos) e iniciantes em programação  
> **Inspirações:** Lightbot, Scratch, Karel the Robot e Swift Playgrounds  

---

## 1. Visão Geral da Expansão

Atualmente, o **CatCode** conta com blocos de sequenciamento básico (`ANDAR`, `VIRE A ESQUERDA`, `VIRE A DIREITA`, `COLETAR`, `ALIMENTAR`) e a estrutura de repetição contada (`REPETIR N VEZES`).

Para transformar o jogo em uma **ferramenta completa de ensino de Ciência da Computação**, planejamos novos blocos que abordam os grandes pilares do pensamento computacional:
1. **Modularização e Abstração** (Funções / Sub-rotinas)
2. **Entradas Sensoriais** (Sensores do Robô e Percepção de Ambiente)
3. **Tomada de Decisão** (Estruturas Condicionais `Se` / `Senão`)
4. **Laços Dinâmicos Indeterminados** (Repetições baseadas em condição `Enquanto` / `While`)
5. **Gerenciamento de Estado e Memória** (Variáveis, Mochila e Contadores)

---

## 2. Catálogo Detalhado dos Novos Blocos

### 2.1. 🟡 Modularização: Funções e Procedimentos (`ROTINA F1 / F2`)
Permite criar blocos personalizados para resolver sub-problemas e reutilizar código.

* **Identificador Técnico:** `PROC_F1`, `CALL_F1`, `PROC_F2`, `CALL_F2`
* **Nome Visual:** `ROTINA F1` e `EXECUTAR F1()`
* **Cor Visual Sugerida:** Dourado / Âmbar `#f5a623`
* **Pilar Computacional:** **Decomposição**, **Abstração** e **Princípio DRY (*Don't Repeat Yourself*)**.
* **Mecânica na Interface:**
  * O jogador ganha uma área secundária chamada **"Caixa da Rotina F1"** (com capacidade fixa para 4 a 6 blocos).
  * No programa principal, o bloco `EXECUTAR F1()` aciona em sequência todos os passos armazenados em F1.
* **Exemplo Temático no Abrigo:**
  * *Padrão de contorno de canil:* `[Virar Direita, Andar, Virar Esquerda, Andar]` é guardado dentro de `F1`. Quando houver 3 canis no caminho, o jogador programa apenas `[F1, F1, F1]`.
* **Desafio Pedagógico:** Limite rígido de comandos no programa principal que força o aluno a modularizar.

---

### 2.2. 👁️ Percepção do Robô: Sensores de Ambiente
Antes de tomar decisões, o robô precisa de percepção sensorial sobre o tabuleiro do abrigo.

* **Cor Visual Sugerida:** Verde Oliva / Esmeralda `#2ec4b6`
* **Pilar Computacional:** **Entradas de dados (Input)** e **Lógica Booleana (Verdadeiro / Falso)**.
* **Blocos de Sensores Disponíveis:**
  1. `CAMINHO LIVRE À FRENTE`: Retorna verdadeiro se a próxima casa não tiver cerca, borda ou obstáculo.
  2. `OBSTÁCULO À FRENTE`: Detecta se há árvore, arbusto ou caixa logo à frente.
  3. `ESTÁ SOBRE ITEM`: Detecta se na casa atual existe ração, água ou remédio.
  4. `ANIMAL PRECISA DE CUIDADO`: Retorna verdadeiro se o animal acolhido na casa ainda não foi atendido.
  5. `COR DO PISO [AZUL / AMARELO]`: Lê o azulejo do piso na enfermaria para guiar o robô por trilhas coloridas.

---

### 2.3. 🟠 Tomada de Decisão: Condicionais (`SE` e `SE-SENÃO`)
Permite que o algoritmo execute ações diferentes dependendo do estado do mapa.

* **Identificador Técnico:** `IF_THEN`, `IF_ELSE`
* **Nome Visual:** `SE (condição) ENTÃO [ ... ]` / `SENÃO [ ... ]`
* **Cor Visual Sugerida:** Laranja Queimado `#ff7043`
* **Pilar Computacional:** **Fluxo de Controle Não Linear** e **Bifurcação Algorítmica**.
* **Mecânica na Interface:**
  * O bloco possui um encaixe para um **Sensor** e um espaço interno onde o jogador insere os comandos a serem executados caso a condição seja satisfeita.
* **Exemplos Temáticos no GABA:**
  * *Inspeção de baias:*
    ```
    SE (Animal com Fome) ENTÃO:
        [ Alimentar ]
    SENÃO:
        [ Andar ]
    ```
  * *Navegação Adaptativa:*
    ```
    SE (Obstáculo à Frente) ENTÃO:
        [ Virar à Direita ]
    SENÃO:
        [ Andar ]
    ```

---

### 2.4. 🔵 Laços Dinâmicos: Laço Condicional (`ENQUANTO` / `REPITA ATÉ`)
Diferente do `Repetir N Vezes` (laço estático onde o jogador precisa contar as casas), este bloco ensina algoritmos generalistas que funcionam mesmo se o tamanho do mapa mudar.

* **Identificador Técnico:** `WHILE_LOOP`, `REPEAT_UNTIL`
* **Nome Visual:** `ENQUANTO (condição) FAÇA [ ... ]` ou `REPITA ATÉ (destino)`
* **Cor Visual Sugerida:** Turquesa Profundo `#0077b6`
* **Pilar Computacional:** **Laços Indeterminados**, **Condição de Parada** e **Sentinelas**.
* **Exemplos Temáticos no GABA:**
  * *Corredor do Abrigo:*
    ```
    ENQUANTO (Caminho Livre) FAÇA:
        [ Andar ]
    ```
    *(O robô atravessa todo o corredor, seja ele de 3, 7 ou 15 casas de comprimento, sem precisar de contagem manual!)*
  * *Busca Ativa:*
    ```
    REPITA ATÉ (Chegar no Bento) FAÇA:
        [ Andar, Virar Direita, Andar ]
    ```

---

### 2.5. 🟣 Estado e Memória: Variáveis e Contadores (`INVENTÁRIO`)
Introduz a noção de que um programa pode guardar dados na memória para consulta posterior.

* **Identificador Técnico:** `SET_VAR`, `INCREMENT_VAR`, `CHECK_VAR`
* **Nome Visual:** `GUARDAR NA BOLSA` / `CONTADOR (+1)` / `SE QUANTIDADE >= X`
* **Cor Visual Sugerida:** Roxo / Violeta `#7209b7`
* **Pilar Computacional:** **Variáveis**, **Atribuição**, **Incremento/Decremento** e **Estado Mutável**.
* **Exemplo Temático no GABA:**
  * Na enfermaria da Luna, o robô precisa coletar 2 frascos de medicamento antes de aplicar o tratamento:
    ```
    Coletar Frasco -> Contador = 1
    Coletar Frasco -> Contador = 2
    SE (Contador == 2) ENTÃO [ Tratar Luna ]
    ```

---

## 3. Trilha de Evolução e Sequenciamento dos Blocos

Para garantir uma **curva de aprendizagem suave e sem frustrações**, os conceitos devem ser introduzidos de forma estritamente progressiva, respeitando a carga cognitiva de crianças e iniciantes:

```
┌─────────────────────────────────────────────────────────────┐
│ ETAPA 1: Sequenciamento Linear Puro                         │
│ Blocos: Andar, Virar (Esq/Dir), Coletar, Alimentar          │
└──────────────────────────────┬──────────────────────────────┘
                               │
                               ▼
┌─────────────────────────────────────────────────────────────┐
│ ETAPA 2: Eficiência e Reconhecimento de Padrões             │
│ Bloco: Repetir (N Vezes)                                    │
└──────────────────────────────┬──────────────────────────────┘
                               │
                               ▼
┌─────────────────────────────────────────────────────────────┐
│ ETAPA 3: Modularização e Abstração                          │
│ Blocos: Criar Rotina F1, Executar F1()                      │
└──────────────────────────────┬──────────────────────────────┘
                               │
                               ▼
┌─────────────────────────────────────────────────────────────┐
│ ETAPA 4: Percepção e Tomada de Decisão                      │
│ Blocos: Sensores de Caminho/Itens + Bloco Se / Senão        │
└──────────────────────────────┬──────────────────────────────┘
                               │
                               ▼
┌─────────────────────────────────────────────────────────────┐
│ ETAPA 5: Autonomia e Algoritmos Adaptativos                 │
│ Blocos: Enquanto (Caminho Livre) / Repita Até               │
└─────────────────────────────────────────────────────────────┘
```

---

### 🗺️ Matriz Pedagógica de Conteúdo por Cenário

| Nível / Cenário | Fases | Novos Blocos Liberados | Conceito Pedagógico Trabalhado | Narrativa do Abrigo (GABA) |
| :--- | :---: | :--- | :--- | :--- |
| **Cenário 1: Alimentação** | **1 a 3** | • `ANDAR`<br>• `VIRAR ESQ / DIR`<br>• `COLETAR`<br>• `ALIMENTAR` | **Execução Sequencial Linear**<br>Orientação espacial relativa (esquerda/direita do robô vs tela) e relação de causa/efeito. | Acolhimento da gatinha filhote **Mia**: levar ração e água fresca até a baia segura. |
| **Cenário 2: Exploração** | **4 a 6** | • `REPETIR (N vezes)` | **Laço Contado (*For Loop*)**<br>Identificação de repetições e economia de comandos no código. | O cãozinho **Bento** no pátio: caminhos longos de gramado e desvio de caixas com padrões repetitivos. |
| **Cenário 3: Cuidados Médicos** | **7 a 9** | • `ROTINA F1`<br>• `EXECUTAR F1()` | **Funções e Abstração Modular**<br>Decomposição de tarefas grandes em sub-rotinas reutilizáveis. | Enfermaria da gatinha **Luna**: protocolos de higienização e atendimento com rotinas que se repetem. |
| **Cenário 4: Abrigo Dinâmico (Expansão)** | **10 a 12** | • `SENSORES`<br>• `SE`<br>• `SENÃO` | **Lógica Booleana e Decisão (*If-Else*)**<br>Bifurcação de caminhos e reação dinâmica ao estado do cenário. | Portões do abrigo que podem estar abertos ou fechados; animais com necessidades diferentes. |
| **Cenário 5: Resgate Autônomo (Expansão)** | **13 a 15** | • `ENQUANTO (Condição)`<br>• `REPITA ATÉ` | **Laços Indeterminados (*While*)**<br>Algoritmos autônomos que resolvem mapas de qualquer tamanho. | O robô percorre corredores desconhecidos do abrigo até encontrar sozinho onde o animal está. |

---

## 4. Por Que a Ordem Pedagógica Importa?

1. **Por que `Funções (F1)` entram ANTES de `Condicionais (Se)`?**
   * *Evidência do Lightbot:* Criar uma função é algo mecânico e visual (é apenas "uma caixinha que guarda passos"). A criança entende imediatamente que serve para economizar espaço.
   * Já as condicionais exigem abstração booleana (entender hipóteses de "se isso for verdade, faça X, se for falso, faça Y"). Portanto, ensinar funções antes reduz a sobrecarga cognitiva.
2. **Por que `Repetir N` entra antes de `Enquanto`?**
   * É muito mais intuitivo para uma criança contar "1, 2, 3 passos" do que formular uma condição abstrata de sentinela como "enquanto não houver parede à frente".
3. **Limite de Blocos como Ferramenta Didática:**
   * O jogo não deve proibir o jogador de tentar uma solução longa; porém, para ganhar as **3 Estrelas da fase**, o jogador é desafiado a usar o número mínimo de blocos, incentivando espontaneamente o uso de Loops e Funções.

---

## 5. Organização Visual da Paleta na Interface da Godot

Para acomodar esses blocos sem sobrecarregar a tela da criança:

1. **Paleta com Cores Funcionais Padronizadas:**
   * 🟣 **Movimento:** Roxo / Magenta
   * 🔴 **Ações:** Coral / Rosa
   * 🔵 **Estruturas de Repetição:** Azul Claro / Turquesa
   * 🟡 **Sub-rotinas (Funções):** Amarelo / Dourado
   * 🟠 **Condicionais e Decisão:** Laranja
2. **Liberação Gradual de Abas:**
   * Nas Fases 1 a 3: Aparecem apenas as abas *Movimento* e *Ações*.
   * Na Fase 4: O botão *Repetir* surge com uma animação explicativa da Mia/ONG.
   * Na Fase 7: A aba *Rotinas (F1)* é desbloqueada.
   * Nas expansões: Os blocos de *Decisão* e *Sensores* são revelados.
