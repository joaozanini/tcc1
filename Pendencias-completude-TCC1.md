# Pendências para o TCC1 completo – NeuroSight

Levantamento de 03/11/2026. Motivo: até aqui o artigo foi montado tomando o exemplo do curso (`Referencias-e-modelos/TCC_TADS_Exemplo.pdf`) como medida também de completude: uma figura de casos de uso "como exemplo" no corpo do texto, e todo o resto da modelagem só no link da nota 2. O exemplo é referência apenas de formato (regra registrada em [CLAUDE.md](CLAUDE.md)); este é o TCC de verdade, e tudo o que foi modelado na pasta `Especificacao` precisa estar na entrega.

**Atualização de 03/11/2026, à tarde:** o autor pediu, por ora, só os diagramas de casos de uso e as histórias de usuário, que entraram no artigo como Apêndices A e B. Uma montagem com os nove apêndices chegou a ser gerada e foi desfeita.

**Atualização de 03/11/2026, à noite (decisão final):** a entrega são dois documentos, cada um no seu modelo (regra em [CLAUDE.md](CLAUDE.md)): o artigo segue `Referencias-e-modelos/TCC_Artigo_Modelo_2026.pdf` como está (Seções I a IV, sem apêndices e sem diagramas de modelagem no corpo), e **toda a modelagem vai na Especificação Técnica**, no template `.docx` do curso, gerada em `Especificacao-Tecnica/` por `montar-especificacao.pl` e `gerar-especificacao-docx.ps1`. Com isso, o Decidir 1 ficou resolvido como (b), os Decidir 2 a 4 e 6 ficaram sem objeto (numeração contínua na especificação; o artigo mantém só as figuras de arquitetura; o gerador lê os `.md` da `Especificacao`), e os Apêndices A e B do artigo foram desfeitos. As letras dos apêndices são as do template (A casos de uso, B classes, C histórias + protótipos + sequência, D modelo lógico, E APIs, F IA), mais G requisitos, H estados e I BPMN. As seções 3, 4 e 6 abaixo descrevem a proposta anterior, de apêndices no artigo, e ficam como histórico; continuam valendo a seção 5 (legibilidade das figuras, Decidir 5) e a seção 7 (repositório, histórias refeitas). O andamento está na seção 12 do [Checklist](Checklist-TCC1-NeuroSight.md).

Este arquivo lista: (1) o que existe na especificação e o que está na entrega hoje; (2) as decisões tomadas "como no exemplo" que precisam ser revistas; (3) a proposta de onde cada coisa entra; (4) as mudanças no texto; (5) as mudanças nos diagramas e nas imagens; (6) as mudanças nos scripts de montagem; (7) outras pendências encontradas no levantamento; e (8) a ordem de trabalho. Os pontos que cabem ao autor decidir, com o orientador, estão marcados com **Decidir**. O andamento fica na seção 11 do [Checklist](Checklist-TCC1-NeuroSight.md).

## 1. O que existe na Especificacao e o que está na entrega

| Artefato | Na pasta `Especificacao` | Na entrega hoje (PDF de 14 páginas) | Situação |
|---|---|---|---|
| Requisitos | 60 RF, 20 RN e 26 RNF, com prioridade e origem ([Requisitos-NeuroSight.md](Especificacao/Requisitos-NeuroSight.md)) | Só os totais e os onze grupos, num parágrafo da Seção III | **Falta**: as tabelas |
| Diagramas de casos de uso | 12 diagramas (UC00 a UC11) com 60 casos, mais a página composta "Figura – Sessões e perfis" (13 páginas no `.drawio`) | 1 figura (Figura 1, a página composta), apresentada "como exemplo" | **Faltam** os 12 diagramas e as tabelas de casos por diagrama |
| Histórias de usuário | 60 histórias (HU01.1 a HU11.2), com critérios de aceitação e prioridade, e tabela de rastreabilidade RF → UC | Só os totais (35/19/6) num parágrafo da Seção III | **Faltam** as 60 histórias e a rastreabilidade |
| Diagrama de classes | 2 páginas (diagrama principal e "Tenant e isolamento"), 18 classes, 8 enumerações e as regras que o diagrama não mostra | Citado na lista de artefatos | **Falta** |
| Diagrama de estados da sessão | 1 página, 9 estados, 12 transições com guardas | Citado; os 9 estados aparecem em prosa na IV.A.2 | **Falta** |
| Diagramas de sequência | 6 páginas (SD01 a SD06), cobrindo 20 dos 60 casos de uso | Citados ("seis fluxos principais"); o pareamento, o envio e o início estão em prosa na IV.A.2 | **Faltam** |
| Rotas da API | 19 rotas, com quem chama, para quê e em qual diagrama ([Diagramas-de-sequencia-NeuroSight.md](Especificacao/Diagramas-de-sequencia-NeuroSight.md)) | "A API será documentada em OpenAPI" | **Falta** a tabela (o template da especificação técnica tem um apêndice só para APIs) |
| Modelo lógico-relacional | 3 páginas, 20 tabelas, 8 tipos, política de RLS, restrições, cascatas e dicionário de dados completo | Citado; o RLS e as chaves compostas estão em prosa na IV.A.1 | **Faltam** as 3 figuras e o dicionário |
| BPMN | 2 diagramas: processo atual (as-is) e experimento com o NeuroSight (to-be) | Citados; o processo atual está em prosa na II.E | **Faltam** |
| Arquitetura | 2 páginas (arquitetura e fluxo de uma sessão) | Figuras 2 e 3 | OK |
| Decisões técnicas | Tabela de tecnologias, alternativas descartadas, riscos | Tabela 2 e IV.A | OK |
| Protótipos de tela | 19 telas (14 web, 5 do óculos), em HTML e PNG, com o mapa tela → caso de uso | "Fazem parte da documentação completa" (abertura da Seção IV) | **Faltam** as 19 telas e o mapa |

Em números: a entrega tem 3 figuras e 2 tabelas. Ficaram de fora 26 páginas de diagramas e 19 protótipos (45 figuras), mais quatro blocos de tabelas: requisitos (106 linhas), histórias (60), dicionário de dados (20 tabelas) e rotas (19). A estimativa é de 50 a 60 páginas a mais no PDF.

## 2. Decisões tomadas "como no exemplo" que precisam ser revistas

| Onde | O que foi decidido | Por que precisa mudar |
|---|---|---|
| [III-Metodo-e-tecnologias.md](Texto-TCC/III-Metodo-e-tecnologias.md), linha 25 | "A Figura 1 apresenta, **como exemplo**, o diagrama de casos de uso das sessões" e, no fim do parágrafo, "A documentação completa está disponível on-line²" como único caminho para os outros onze diagramas | A frase e a legenda ("Exemplo de diagrama de casos de uso") vieram do exemplo do curso. Os doze diagramas têm de estar na entrega |
| Mesmo arquivo, linha 3 (cabeçalho de trabalho) | "no formato da Seção III do exemplo (parágrafos corridos, **uma figura de casos de uso** e a tabela das tecnologias)" | "Uma figura" é completude, não formato |
| [IV-A-Arquitetura-do-sistema.md](Texto-TCC/IV-A-Arquitetura-do-sistema.md), linha 16 | "os protótipos das telas (...) fazem parte da documentação completa" | Os protótipos têm de aparecer na entrega |
| [Checklist](Checklist-TCC1-NeuroSight.md), seção 2 | "Figura 1 com um diagrama de casos de uso de exemplo (UC07 – Sessões) (...) foram juntadas numa só, como no exemplo do curso, que tem uma única figura de casos de uso" | A quantidade de figuras do exemplo não é critério |
| Checklist, seção 10, item "Figuras 1 e 2 juntadas numa só (03/11/2026)" | A figura dos atores (UC00) e a do UC07 foram fundidas para ficar com uma só figura, "como no exemplo" | Idem. A figura composta pode continuar no corpo (ver Decidir 3), mas UC00 e UC07 entram inteiros no apêndice |
| Checklist, seção 9, "Comparação com o exemplo do curso" | O critério de aprovação foi "a estrutura é a mesma" | A comparação vale só para o formato (capa, legendas, citações). Completude se mede pela pasta `Especificacao` |
| Checklist, "Fica para o TCC2" | "Especificação técnica no template do curso, com os apêndices (...) confirmar com o orientador se é entrega do TCC2" | Os apêndices com os artefatos entram agora. O que pode ficar para confirmar é só se o orientador quer, além do PDF do artigo, o documento separado no template `.docx` |
| [Prompt-revisao-TCC1.md](Prompt-revisao-TCC1.md) | Manda usar o modelo do curso "como referência de formato e de seções esperadas" | Trocar por "só de formato"; acrescentar a verificação de que todo artefato da `Especificacao` está na entrega |
| [Resumo-e-Abstract.md](Texto-TCC/Resumo-e-Abstract.md), linha 3, e Checklist, seção 7 | "quatro palavras-chave, como no exemplo"; tamanho comparado ao do exemplo | Não precisa mudar: é formato. Fica registrado só para deixar claro o que é formato e o que não é |

## 3. Onde cada coisa entra (proposta)

**Recomendação:** manter o corpo do artigo como está (Seções I a IV.A, Figuras 1 a 3, Tabelas 1 e 2) e acrescentar, no mesmo PDF, apêndices em coluna única depois das Referências, com todos os artefatos. Motivos: o corpo em duas colunas não comporta os diagramas grandes; o texto já explica cada artefato e passa a remeter ao apêndice; e o próprio template da especificação técnica do curso organiza esses artefatos como apêndices (A. casos de uso, B. classes, C. histórias com protótipos e sequência, D. modelo lógico, E. APIs).

| Apêndice | Título | Conteúdo | Fonte na `Especificacao` | Figuras / tabelas |
|---|---|---|---|---|
| A | Requisitos | Atores; RF por grupo; RN; RNF; pontos confirmados e fora do escopo | Requisitos-NeuroSight.md | 6 tabelas |
| B | Diagramas de casos de uso | UC00 a UC11, cada um com a tabela de casos (ator, relações, requisitos) | Casos-de-uso-NeuroSight.drawio, Casos-de-uso-e-historias-NeuroSight.md | 12 figuras, 12 tabelas |
| C | Histórias de usuário | HU01.1 a HU11.2, com critérios e prioridade; rastreabilidade RF → UC/HU | Casos-de-uso-e-historias-NeuroSight.md | 60 histórias, 1 tabela |
| D | Diagrama de classes | Diagrama principal; Tenant e isolamento; enumerações; regras que o diagrama não mostra | Diagrama-de-classes-NeuroSight.drawio e .md | 2 figuras, 2 tabelas |
| E | Diagrama de estados da sessão | Figura e tabela de transições | Diagrama-de-estados-da-sessao.drawio e .md | 1 figura, 1 tabela |
| F | Diagramas de sequência e rotas da API | SD01 a SD06, o que cada um mostra, tabela das 19 rotas | Diagramas-de-sequencia-NeuroSight.drawio e .md | 6 figuras, 2 tabelas |
| G | Modelo lógico-relacional | 3 figuras; tipos enumerados; RLS e papéis; restrições e cascatas; dicionário de dados | Modelo-logico-relacional-NeuroSight.drawio e .md | 3 figuras, 20 tabelas do dicionário + 3 |
| H | Processos de negócio | BPMN do processo atual e BPMN do experimento com o NeuroSight, com a tabela etapa → caso de uso | BPMN-Processo-atual e BPMN-Experimento (.drawio e .md) | 2 figuras, 2 tabelas |
| I | Protótipos de tela | W01 a W14 e A1 a A5, com o mapa tela → caso de uso e os casos sem tela própria | Prototipos-NeuroSight/ | 19 figuras, 2 tabelas |

**Decidir 1 – Formato da entrega dos artefatos.** (a) Apêndices no mesmo PDF do artigo, como acima (recomendado); ou (b) além do artigo, a Especificação Técnica separada, no template `.docx` do curso ([Template Especificação Técnica TCC TADS UFPR.docx](Referencias-e-modelos/Template%20Especificação%20Técnica%20TCC%20TADS%20UFPR.docx)): Contextualização de 1 a 3 páginas, Referências e Apêndices A a F. Os dois saem dos mesmos arquivos `.md`. Se for (b), observar que o Apêndice C do template pede, **para cada caso de uso**, a história, o protótipo e o diagrama de sequência: hoje os 6 diagramas de sequência cobrem 20 dos 60 casos, e sete casos não têm tela própria (lista em [Prototipos-NeuroSight.md](Especificacao/Prototipos-NeuroSight/Prototipos-NeuroSight.md)); e que o Apêndice F (modelos de IA) não se aplica ao NeuroSight. Confirmar com o orientador.

**Decidir 2 – Numeração.** Continuar a numeração das figuras e tabelas nos apêndices (FIGURA 4 em diante, TABELA 3 em diante), como na ABNT (recomendado), ou reiniciar por apêndice (FIGURA A.1).

**Decidir 3 – Figura 1.** Manter no corpo a figura composta "Sessões e perfis" (UC07 com a hierarquia dos perfis), já que ela resume o fluxo principal, e pôr UC00 a UC11 inteiros no Apêndice B (recomendado); ou voltar às duas figuras de antes de 03/11 (UC00 e UC07) no corpo.

**Decidir 4 – Figuras no corpo da IV.A.** Opcionalmente, trazer para o corpo o diagrama de estados (na IV.A.2, onde os nove estados estão em prosa) e a página "Tenant e isolamento" (na IV.A.1). Não é obrigatório: com os apêndices, o texto só precisa remeter a eles. Se entrarem, precisam das mesmas adaptações de fonte da seção 5.

## 4. Mudanças no texto do artigo

Trechos a mudar nos `.md` das seções (as letras dos apêndices seguem a tabela da seção 3; ajustar se a ordem mudar). Depois, rodar `montar-artigo.pl`, `gerar-latex.pl --pdf` e `gerar-docx.ps1`.

| Arquivo e trecho | Hoje | Proposta |
|---|---|---|
| [I-Introducao.md](Texto-TCC/I-Introducao.md), último parágrafo (organização do documento) | "(...) e a Seção IV apresenta a arquitetura proposta para o sistema." | Acrescentar: "Os apêndices reúnem os artefatos da modelagem: requisitos, diagramas de casos de uso, histórias de usuário, diagramas de classes, de estados e de sequência, modelo lógico do banco de dados, processos de negócio e protótipos das telas." |
| [II-Revisao-de-literatura.md](Texto-TCC/II-Revisao-de-literatura.md), II.E, parágrafo da IC | "Nesse fluxo, as etapas dependem de programas diferentes (...)" | Acrescentar, no fim: "O Apêndice H representa esse processo em BPMN, ao lado do processo com o NeuroSight." |
| [III-Metodo-e-tecnologias.md](Texto-TCC/III-Metodo-e-tecnologias.md), parágrafo 1 (requisitos) | "(...) e, por fim, auditoria." | Acrescentar: "A lista completa está no Apêndice A." |
| III, parágrafo 4 (lista dos artefatos) | "(...) e dos protótipos de tela: 14 do sistema web e 5 do aplicativo do óculos." | Acrescentar, depois da frase da notação: "Todos esses artefatos estão nos Apêndices A a I." |
| III, parágrafo 5 (Figura 1) | "A Figura 1 apresenta, como exemplo, o diagrama de casos de uso das sessões, (...)" | "A Figura 1 apresenta o diagrama de casos de uso das sessões, (...)" |
| III, mesmo parágrafo, última frase | "A documentação completa está disponível on-line²." | "Os doze diagramas, com a tabela de casos de uso de cada um, estão no Apêndice B. Os arquivos-fonte dos diagramas e dos protótipos estão disponíveis on-line²." |
| III, legenda da Figura 1 | "Exemplo de diagrama de casos de uso - Sessões e perfis de usuário." | "Diagrama de casos de uso das sessões, com os perfis de usuário." |
| III, parágrafo 6 (histórias) | "Ao todo, são 60 histórias: 35 essenciais, 19 importantes e 6 desejáveis." | "Ao todo, são 60 histórias, 35 essenciais, 19 importantes e 6 desejáveis, apresentadas no Apêndice C com os critérios de aceitação e a rastreabilidade para os requisitos." |
| III, cabeçalho de trabalho (linha 3) | "(parágrafos corridos, uma figura de casos de uso e a tabela das tecnologias)" | "(parágrafos corridos, a figura de casos de uso do fluxo principal e a tabela das tecnologias; os demais diagramas vão para os apêndices)" |
| III, nota 2 | "Disponível em: https://github.com/joaozanini/tcc1 (pasta Especificacao). Acesso em: 2 nov. 2026." | Manter. O repositório precisa estar público (seção 7) |
| [IV-A-Arquitetura-do-sistema.md](Texto-TCC/IV-A-Arquitetura-do-sistema.md), abertura da IV | "os protótipos das telas, que antecipam essa apresentação, fazem parte da documentação completa." | "os protótipos das telas, que antecipam essa apresentação, estão no Apêndice I." |
| IV.A.1 Multi-tenant, frase das chaves compostas | "(...) o que impede, por exemplo, que uma sessão aponte para o paciente de outro grupo." | Acrescentar: "O modelo lógico do banco, com as vinte tabelas, as políticas de RLS e o dicionário de dados, está no Apêndice G; o diagrama de classes de que ele deriva, no Apêndice D." |
| IV.A.2 Comunicação, depois de "A Figura 3 resume o fluxo de uma sessão." | — | Acrescentar: "Os diagramas de sequência do pareamento, do envio, do início e do envio dos dados (SD02 a SD05) estão no Apêndice F, e o diagrama de estados da sessão, no Apêndice E." |
| IV.A.2, frase dos estados ("Ao longo do processo, a sessão passa pelos estados (...)") | Termina em "que o sistema web exibe ao pesquisador." | Acrescentar "(Apêndice E)" antes do ponto final |
| IV.A.2, parágrafo "A API será documentada em OpenAPI" | "(...) que serve de contrato entre o servidor e o aplicativo." | "(...) que serve de contrato entre o servidor e o aplicativo; as rotas usadas nos diagramas de sequência estão no Apêndice F." |
| IV.A.3 Dados coletados, frase da importação para tabelas | "(...) o que facilita os gráficos e o resumo por estímulo (...)" | Acrescentar "(tabelas de amostras do Apêndice G)" |
| [Resumo-e-Abstract.md](Texto-TCC/Resumo-e-Abstract.md) | Não cita o exemplo nem o link | Opcional: "(...) os protótipos das telas e a arquitetura do sistema, apresentados nos apêndices". Não é obrigatório |

Conferir, depois da montagem, que toda menção "Apêndice X" aponta para a letra certa e que nenhuma figura ou tabela dos apêndices é citada antes de existir.

## 5. Diagramas e imagens

### 5.1 Legibilidade em impressão

Os diagramas da `Especificacao` foram desenhados para leitura em tela, com fonte de 10 e 11 px. Impressos na largura do texto (cerca de 16 cm em coluna única), o texto deles fica abaixo de 6 pt; o IEEE recomenda pelo menos 8 pt dentro das figuras, e o próprio checklist já considerou 5 pt pequeno demais (por isso a Figura 1 foi refeita com 13 px). A tabela abaixo estima o tamanho impresso da fonte de cada página (fonte em px × largura impressa ÷ largura da página do draw.io) a 16 cm, em retrato, e a cerca de 24 cm, em paisagem.

| Página | Tamanho (px) | Fonte | Retrato, 16 cm | Paisagem, 24 cm | Tratamento recomendado |
|---|---|---|---|---|---|
| UC00 Atores e perfis | 840 × 470 | 10–11 | 5,4–5,9 pt | — | Subir a fonte para 16 px (como foi feito na Figura 1 com 13 px) e reorganizar; cabe em retrato |
| UC01, UC02, UC03, UC07, UC10, UC11 | 910 de largura | 10–11 | 5,0–5,5 pt | — | Idem |
| UC04, UC05 | 600 × 655 | 11 | 8,3 pt | — | Já legíveis; podem ficar lado a lado ou em meia página |
| UC06, UC09 | 1220 de largura | 10–11 | 3,7–4,1 pt | 5,6–6,1 pt | Fonte 16 px e quebra em duas linhas de casos de uso, ou paisagem |
| UC08 Execução no óculos | 1370 × 655 | 10–11 | 3,3–3,6 pt | 5,0–5,5 pt | Idem |
| Figura – Sessões e perfis (Figura 1) | 1140 × 915 | 13 | 5,2 pt | — | Já no artigo e aceita na revisão de 03/11; opcional subir para 16 px |
| Diagrama de classes | 1820 × 1500 | 10–11 | 2,5–2,7 pt | 3,7–4,1 pt | Ilegível em qualquer orientação. Dividir em 3 ou 4 páginas por área (acesso e tenant; experimento; dados coletados; auditoria), como já está o modelo lógico, com fonte 13–14 px |
| Tenant e isolamento | 1520 × 490 | 10–11 | 3,0–3,3 pt | 4,5–4,9 pt | Reorganizar as composições em duas ou três linhas e subir a fonte; cabe em retrato |
| Estados da sessão | 920 × 970 | 10–11 | 4,9–5,4 pt | — | Fonte 14 px; cabe numa página em retrato |
| SD01, SD02, SD05, SD06 | 1365 a 1504 de largura | 11 | 3,3–3,7 pt | 5,0–5,5 pt | Paisagem, uma por página, com fonte 14 px (chega a 6,5–7 pt); ou dividir cada um em duas figuras (por exemplo, SD02 em "pedido do código" e "confirmação") |
| SD03, SD04 | 1887 × 1060 e 1514 × 1144 | 11 | 2,6–3,3 pt | 4,0–4,9 pt | Dividir em duas figuras cada (SD03: criação da sessão / download no óculos; SD04: início / execução) e paisagem com fonte 14 px |
| Modelo lógico 1 e 2 | 1630 de largura | 11 | 3,1 pt | 4,6 pt | Paisagem com fonte 14 px; se não chegar a 7 pt, dividir a página 1 (experimento) em "estímulos e modelos" e "sessões" |
| Modelo lógico 3 | 1220 × 740 | 11 | 4,1 pt | 6,1 pt | Paisagem com fonte 14 px |
| BPMN – Experimento | 2560 × 640 | 10 | 1,8 pt | 2,7 pt | Redesenhar o fluxo em duas ou três faixas (quebrando a linha do tempo) ou em duas figuras (preparação e início / execução e análise), com fonte 13 px, em paisagem |
| BPMN – Processo atual | 1860 × 440 | 10 | 2,4 pt | 3,7 pt | Idem, em duas faixas |
| Arquitetura (Figura 2) | 1060 × 600 | 11 | 4,7 pt | — | Já aceita; opcional subir para 13 px |
| Fluxo de uma sessão (Figura 3) | 830 × 660 a 12,8 cm | 11 | 4,8 pt | — | Já aceita |
| Protótipos W01 a W14 | 2880 × 1800 (PNG) | — | Texto da tela em cerca de 5 pt a 16 cm | — | Uma tela por página na largura do texto; conferir no PDF. Se ficar pequeno, manter uma por página (duas colunas de telas não ajudam) |
| Protótipos A1 a A5 | 2560 × 1440 (PNG) | — | Legíveis (texto grande) | — | Duas por página |

**Decidir 5 – Meta de legibilidade.** Definir o mínimo aceitável (7 pt é um compromisso razoável; 8 pt é o recomendado) e se haverá páginas em paisagem nos apêndices. Se a banca ler só em tela, a resolução (fator 3) basta e as fontes podem subir menos; para impressão, os tratamentos acima são necessários. Em qualquer caso, as páginas ilegíveis em retrato (classes, sequência, modelo lógico, BPMN) precisam de mudança no `.drawio`, não só de exportação.

### 5.2 Exportação

- Exportar as 26 páginas de diagramas (12 UC, 2 classes, 1 estados, 6 SD, 3 ML, 2 BPMN) em fator 3 para `Texto-TCC/figuras/`, numeradas na sequência do artigo (`Figura-4-...` em diante), pelo processo do [CLAUDE.md](CLAUDE.md) (visualizador do diagrams.net no Edge sem janela). Regenerar também as versões de fator 2 em `Especificacao/imagens-dos-diagramas/` para as páginas que mudarem.
- Os 19 protótipos já existem em PNG em `Especificacao/Prototipos-NeuroSight/imagens/`; copiar para `Texto-TCC/figuras/` com a numeração do artigo, ou fazer o script ler direto da pasta de origem.
- Se o diagrama de classes, os de sequência e os BPMN forem divididos, o número de figuras sobe (cerca de 50 a 55 no total). Atualizar `%largura` em `gerar-latex.pl` e `$larguras` em `gerar-docx.ps1`.
- Conferir, para cada figura nova, o que o checklist já confere para as três atuais: fundo branco opaco, recorte igual, PNG de `Texto-TCC/figuras` idêntico ao de `Texto-TCC/LaTeX/figuras`.

## 6. Scripts de montagem

Hoje os três scripts só conhecem as quatro seções e as referências; nenhum sabe montar apêndice.

- **Fonte única dos apêndices.** Para não duplicar as tabelas de requisitos, histórias, dicionário e rotas, criar um script (`montar-apendices.pl`, ao lado de `montar-artigo.pl`) que leia os `.md` da `Especificacao` e gere `Texto-TCC/Apendices.md` com os títulos "APÊNDICE A – REQUISITOS" etc., as tabelas, as legendas "FIGURA n - ..." e "FONTE: Os autores (2026)" e as imagens. Alternativa mais simples, porém com duplicação: escrever os apêndices à mão em `.md` separados (`Apendice-A-Requisitos.md`...). **Decidir 6.**
- **`montar-artigo.pl`:** incluir os apêndices depois das referências; numerar as figuras e tabelas dos apêndices na sequência (ou por apêndice, conforme Decidir 2); tratar as citações `[n]` que aparecerem nos apêndices (por exemplo, a RFC 8628 nos diagramas de sequência) com a mesma numeração do corpo.
- **`gerar-latex.pl`:** depois de `\end{thebibliography}`, emitir `\onecolumn` e os apêndices com `\appendices` do IEEEtran (renomeando `\appendixname` para "Apêndice") ou com `\section*{APÊNDICE A – ...}` e `\addcontentsline`; ambiente de figura em coluna única (o `figuralarga` atual é `figure*`, próprio das duas colunas); páginas em paisagem com o pacote `pdflscape` para as figuras marcadas; tabelas que atravessam páginas com `longtable` (requisitos, histórias e dicionário não cabem numa página); títulos de nível 2 dentro dos apêndices (um por diagrama, por história ou por tabela do dicionário); e a lista de figuras a copiar para `LaTeX/figuras` e para o `.zip` do Overleaf. Incluir as conferências já existentes (chaves, ambientes, `\cite`) nos apêndices.
- **`gerar-docx.ps1`:** quebra de seção para uma coluna depois das referências (a função de quebra já existe, linha 236); títulos "APÊNDICE A – ..." no estilo dos títulos de seção; figuras na largura da página; orientação paisagem nas seções com figuras largas; tabelas longas com cabeçalho repetido; `$larguras` para as figuras novas.
- **Conferência final:** repetir o que o checklist faz nas seções 9 e 10 (log sem `Overfull` nem referência indefinida, PDF e `.zip` coerentes, PNGs idênticos) e acrescentar: toda figura e tabela dos apêndices citada no texto ou no próprio apêndice, numeração sem furo, e os totais do texto (60 RF, 20 RN, 26 RNF, 12 diagramas, 60 casos, 60 histórias, 19 telas, 20 tabelas, 19 rotas) iguais aos dos apêndices.

## 7. Outras pendências encontradas no levantamento

- **Repositório privado.** A nota 2 da Seção III só funciona depois de tornar https://github.com/joaozanini/tcc1 público (já era bloqueante na seção 10 do checklist). Mesmo com os apêndices, o link continua sendo o caminho para os arquivos-fonte `.drawio` e para o HTML navegável dos protótipos.
- **Histórias refeitas.** [Historias-de-usuario-refeitas.md](Especificacao/Historias-de-usuario-refeitas.md) (61 histórias, de 03/11/2026, ainda não versionado) é uma segunda lista, feita para comparar com a oficial. **Decidir 7:** incorporar as diferenças que valerem a pena na lista oficial (a única de conteúdo é separar "editar" de "desativar usuário", HU02.4) e apagar o arquivo, ou deixá-lo fora do repositório. Não pode ir para a entrega como lista paralela, porque os totais do texto (60) deixariam de bater.
- **Mudanças não commitadas.** O `git status` mostra 24 arquivos modificados e 4 novos desde o último commit (renumeração das figuras de 03/11, `CLAUDE.md`, histórias refeitas, PNG da figura composta). Commit só quando o autor pedir, de preferência depois de decidir o item anterior.
- **Checklist, seção 10:** dizia "28 páginas dos `.drawio`" no item da nota 2; são 29 (2 + 1 + 1 + 13 + 2 + 1 + 6 + 3), como diz a seção 0. Corrigido neste levantamento.
- **Diagramas de sequência × casos de uso.** Os seis diagramas cobrem 20 dos 60 casos. É suficiente para o artigo (fluxos principais), mas, se o orientador exigir o template da especificação técnica (Decidir 1b), faltariam diagramas para os outros casos ou uma justificativa de que os casos de cadastro simples (CRUD) seguem o mesmo padrão de SD01 e SD03.
- **Rastreamento facial.** A IV.A.5 já registra que a leitura das expressões no Unreal depende de prova de conceito. Nada a mudar; fica a observação de que os apêndices devem manter a mesma ressalva (por exemplo, na tabela `expressao_facial` do dicionário, que depende da versão do SDK).
- **Itens opcionais de estilo** da seção 10 do checklist ("o óculos" no singular, "Multi-tenant" em itálico, duração das sprints por etapa) continuam em aberto e não mudam com este levantamento.

## 8. Ordem de trabalho sugerida

1. Decidir, com o orientador, os itens Decidir 1 a 7 (formato da entrega, numeração, Figura 1, figuras no corpo, meta de legibilidade, geração dos apêndices, histórias refeitas). O que mais pesa é o Decidir 1, porque muda o que se gera.
2. Ajustar os `.drawio` dos diagramas grandes conforme a seção 5.1 (dividir o diagrama de classes, SD03 e SD04 e os dois BPMN; subir as fontes) e exportar as imagens em fator 3.
3. Escrever ou gerar os apêndices (seção 6) e adaptar os três scripts.
4. Alterar o texto das Seções I a IV conforme a seção 4.
5. Montar, gerar o LaTeX, o PDF e o Word; conferir legibilidade, numeração e citações dos apêndices; atualizar as seções 9 e 10 do checklist com a nova conferência.
6. Resolver as histórias refeitas, tornar o repositório público, atualizar o README (número de páginas, apêndices) e, quando o autor pedir, commit e push.
