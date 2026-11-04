# Processo atual (BPMN), sem o NeuroSight

Versão de trabalho de 27/10/2026. Base: Subseção "E. Como os Experimentos São Conduzidos Hoje" de [II-Revisao-de-literatura.md](../Texto-TCC/II-Revisao-de-literatura.md).

O diagrama está em [BPMN-Processo-atual.drawio](BPMN-Processo-atual.drawio). Ele mostra o processo **sem o NeuroSight** (o processo atual, ou as-is), para comparar com o [BPMN do experimento com o NeuroSight](BPMN-Experimento-NeuroSight.md). Junta os dois fluxos da Subseção II.E: o dos estudos citados, em tópicos, e o do protótipo da IC, no parágrafo seguinte.

## Como ler

- **Uma piscina e duas raias**, com as cores do BPMN com o NeuroSight:
  - **Pesquisador**, com as tarefas feitas por pessoas, em branco;
  - **Equipamento (rastreador ou óculos)**, em cinza.
- **Gateways:** o losango com X é a decisão "Há rede?"; o segundo losango junta os dois caminhos.
- **Anotações:** os colchetes registram duas faltas que o texto aponta.

## De onde saiu cada parte

| Elemento | Raia | Trecho da Subseção II.E |
|---|---|---|
| Paciente incluído na pesquisa (início) | Pesquisador | Não vem do texto: é o mesmo início do BPMN com o NeuroSight, para facilitar a comparação |
| Escolher estímulos de fixação e perseguição | Pesquisador | 1º tópico: o pesquisador escolhe estímulos que testam a fixação e a perseguição visual, muitas vezes inspirados nos itens da CRS-R |
| Anotação "Sem cadastro de pacientes nem de estímulos" | — | Parágrafo da IC: "Não havia cadastro de pacientes nem de estímulos" |
| Abrir o aplicativo no óculos | Pesquisador | Parágrafo da IC: o pesquisador abria o aplicativo no óculos |
| Apresentar os estímulos e gravar o olhar | Equipamento | 2º e 3º tópicos: os estímulos aparecem em um monitor, com objetos reais ou em um aplicativo de RV, e o rastreador grava o olhar |
| Encerrar a sessão pelo botão do controle | Pesquisador | Parágrafo da IC: o pesquisador encerrava a sessão por um botão do controle |
| Há rede? → sim → Enviar os dados ao servidor | Equipamento | Parágrafo da IC: o botão enviava os dados ao servidor |
| Há rede? → não → Copiar os arquivos do óculos por cabo → Enviar os arquivos ao servidor por um script | Pesquisador | Parágrafo da IC: sem rede, os arquivos eram copiados do óculos por cabo e enviados depois por um *script* |
| Associar a sessão ao paciente correto | Pesquisador | Parágrafo da IC: associar cada sessão ao paciente correto ficava a cargo do pesquisador |
| Rever as gravações em um programa de análise | Pesquisador | 3º tópico: as gravações são revistas em um programa de análise, como o do fabricante do rastreador |
| Anotação "Sem controle de quem acessa os dados nem registro das ações" | — | Última frase do parágrafo da IC |
| Comparar os registros com a avaliação clínica | Pesquisador | 4º tópico: a análise é feita depois, em geral comparando os registros com a avaliação clínica |
| Sessão analisada (fim) | Pesquisador | Fim do 4º tópico |

## Escolhas feitas ao juntar os fluxos

- **"Há rede?" e servidor:** vêm só do protótipo da IC. Os tópicos dos estudos não falam em rede nem em servidor.
- **Apresentação dos estímulos:** fica na raia do equipamento, como no aplicativo de RV e no protótipo da IC. No estudo com objetos reais, os itens da CRS-R são aplicados pelo examinador (Subseção II.B), e o equipamento só grava o olhar.
- **Associação ao paciente:** o texto não diz em que momento ela acontece. O diagrama a coloca depois que os dados chegam ao servidor e antes da análise.
- **Passos manuais:** a cópia por cabo, o envio por *script* e a associação ao paciente aparecem como tarefas do pesquisador. É o que o texto chama de etapas que dependem de programas diferentes e de transferências manuais.
