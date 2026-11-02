# Processo de negócio (BPMN) do experimento com o NeuroSight

Versão de trabalho de 26/10/2026. Base: [Casos-de-uso-e-historias-NeuroSight.md](Casos-de-uso-e-historias-NeuroSight.md) e [Diagramas-de-sequencia-NeuroSight.md](Diagramas-de-sequencia-NeuroSight.md).

O diagrama está em [BPMN-Experimento-NeuroSight.drawio](BPMN-Experimento-NeuroSight.drawio). Ele mostra o processo **com o NeuroSight** (o processo "futuro", ou to-be): do paciente incluído na pesquisa até a sessão analisada.

## Como ler

- **Uma piscina e três raias:**
  - **Pesquisador**, com as tarefas feitas por pessoas, em branco;
  - **NeuroSight (web e servidor)**, com tarefas automáticas, em azul;
  - **App do óculos**, também com tarefas automáticas, em cinza.
- **Eventos:**
  - início (círculo fino);
  - fim (círculo grosso);
  - fim com falha (círculo grosso com disco preenchido): evento de término, que encerra o processo inteiro, inclusive o ramo paralelo do pesquisador.
- **Gateways:**
  - losango com X é decisão exclusiva (só um caminho segue);
  - losango com + divide o fluxo em caminhos paralelos e depois espera os dois.
- **Anotação:** o colchete no início lista as pré-condições.

## Etapas e casos de uso

| Etapa | Raia | Caso de uso / diagrama |
|---|---|---|
| Paciente incluído na pesquisa (início) | Pesquisador | Pré-condições: tenant criado (SD01), óculos pareado (SD02) e consentimento obtido pelo protocolo da pesquisa |
| Cadastrar ou atualizar o paciente | Pesquisador | UC04.1, UC04.2 |
| Estímulos e modelo prontos? → Enviar estímulos e montar o modelo | Pesquisador | UC05.1, UC06.1, UC06.6 |
| Criar a sessão e enviar ao óculos | Pesquisador | UC07.1 ou UC07.2, UC07.4 |
| Disponibilizar a sessão ao óculos | NeuroSight | SD03 |
| Baixar a sessão e verificar o rastreamento | App | UC08.1, UC08.2 |
| Rastreamento ativo? → Ajustar o óculos e o rastreamento | App → Pesquisador | HU08.2 (o aviso aparece no sistema web) |
| Colocar o óculos no paciente e iniciar a sessão | Pesquisador | UC07.6 |
| Enviar o comando de início | NeuroSight → App | SD04: o app recebe o comando na consulta seguinte ao servidor |
| Executar a sessão e coletar olhar, expressões e quadros | App | UC08.3 a UC08.6 |
| Acompanhar o paciente e retirar o óculos no fim | Pesquisador | Tarefa manual, em paralelo com a execução |
| Enviar o JSON e os quadros | App | UC09.1 |
| Importar as amostras e montar o vídeo | NeuroSight | UC09.2 |
| Processamento concluído? → Falha registrada | NeuroSight | Estado FALHA da sessão; evento de término |
| Analisar a sessão e registrar anotações | Pesquisador | UC10.1 a UC10.6 |
| Nova sessão com o paciente? | Pesquisador | Volta para "Criar a sessão" ou termina |

## Pontos do processo

- **Execução em paralelo:** o pesquisador acompanha o paciente enquanto o óculos executa a sessão. As duas linhas se juntam no gateway paralelo antes da análise: a análise só começa quando o processamento termina.
- **Falha no processamento:** o fim "Falha registrada" é um evento de término. Sem ele, o ramo do pesquisador ficaria preso no gateway paralelo de junção quando o processamento falha.
- **Sem interrupção:** não há caminho para interromper a sessão (RN16). Se for preciso tirar o óculos antes do fim, o pesquisador registra o ocorrido nas anotações.
- **Laço de ajuste:** se o rastreamento não estiver ativo, o pesquisador ajusta o óculos e o app verifica de novo antes de liberar o início.
- **Repetição com o mesmo paciente:** o último gateway volta para "Criar a sessão e enviar ao óculos". Assim, o cadastro do paciente e a preparação dos estímulos não se repetem.

## O processo atual (as-is)

O processo de hoje, sem o NeuroSight, está no BPMN [BPMN-Processo-atual.drawio](BPMN-Processo-atual.drawio), descrito em [BPMN-Processo-atual.md](BPMN-Processo-atual.md). Ele segue a Subseção II.E do artigo (o fluxo dos estudos citados e o do protótipo da IC) e serve para comparar com o processo deste arquivo.
