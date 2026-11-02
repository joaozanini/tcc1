# Checklist do TCC1 — NeuroSight

Tudo o que falta para a entrega do TCC1, que vai até **IV. Resultados → A. Arquitetura do Sistema**. As seções estão na ordem sugerida de trabalho. Marque `[x]` conforme for concluindo. A revisão final de 02/11/2026 está na seção 10: um item bloqueante (o link da nota 2) e os ajustes recomendados.

As decisões técnicas e os motivos de cada uma estão em [Decisoes-tecnicas-NeuroSight.md](Especificacao/Decisoes-tecnicas-NeuroSight.md).

## 0. Decisões e preparação

- [x] Tecnologias de cada parte (Unreal, NestJS, Next.js, PostgreSQL)
- [x] Acompanhamento ao vivo: não haverá
- [x] Multi-tenant: `tenant_id` + RLS
- [x] Envio da sessão (web → óculos pareado) e início (botão "Iniciar" no web)
- [x] Pegar o arquivo-fonte do modelo: está em `TCC_TADS_Exemplo_Sistema_de_Estágios` (LaTeX, classe IEEEtran adaptada). A entrega será nesse modelo
- [x] Definir o título: "NeuroSight: sistema de rastreamento ocular e emocional em realidade virtual para estudo e apoio ao diagnóstico de pessoas com distúrbios da consciência"
- [x] Nome do orientador: Prof. Dr. Alessandro Brawerman (sem coorientador)
- [x] Quest Pro disponível: o grupo tem o aparelho usado na IC
- [x] Definir de onde vêm os requisitos: literatura, protótipo da IC e reuniões com o orientador (nota de informação verbal na Seção III)
- [x] Definir o que o pesquisador pode editar nos dados registrados (só anotações) e se haverá exportação (desejável, RF58 de [Requisitos-NeuroSight.md](Especificacao/Requisitos-NeuroSight.md))
- [x] Documentação completa: repositório https://github.com/joaozanini/tcc1 (remoto `origin` deste repositório Git), com README na raiz e as 28 páginas dos `.drawio` exportadas em PNG em `Especificacao/imagens-dos-diagramas`. O endereço está na nota 2 da Seção III. Falta só o `git push`, e o repositório precisa estar público (seção 10)
- [x] Combinado: não há limite de páginas, o TCC1 termina na IV.A (sem cronograma nem fechamento) e a documentação entra por link
- [x] Separar o que dá para reaproveitar do relatório final da IC: o texto usa o relatório [11] para o protótipo, a gravação (88 MB por minuto, 22 Hz) e os testes feitos pelo autor; a figura de arquitetura foi refeita para o NeuroSight

## 1. Artefatos de modelagem

O modelo cita todos estes; confirme com o orientador quais são obrigatórios.

- [x] Requisitos funcionais e não funcionais ([Requisitos-NeuroSight.md](Especificacao/Requisitos-NeuroSight.md))
- [x] Diagrama de processo de negócio (BPMN) do experimento com o NeuroSight: [BPMN-Experimento-NeuroSight.drawio](Especificacao/BPMN-Experimento-NeuroSight.drawio) e [BPMN-Experimento-NeuroSight.md](Especificacao/BPMN-Experimento-NeuroSight.md)
- [x] (Opcional) BPMN do processo atual, sem o NeuroSight, a partir da Seção II.E: [BPMN-Processo-atual.drawio](Especificacao/BPMN-Processo-atual.drawio) e [BPMN-Processo-atual.md](Especificacao/BPMN-Processo-atual.md)
- [x] Atualizar o diagrama macro do fluxo (Figura 1 do 1.2): nova versão na página "Figura – Fluxo de uma sessão" de [Arquitetura-NeuroSight.drawio](Especificacao/Arquitetura-NeuroSight.drawio)
- [x] Diagramas de casos de uso: 12 páginas em [Casos-de-uso-NeuroSight.drawio](Especificacao/Casos-de-uso-NeuroSight.drawio). UC00 e UC07 estão no artigo como Figuras 1 e 2, e todas as páginas estão exportadas em `Especificacao/imagens-dos-diagramas`. A notação de UC11.2 foi ajustada em 02/11/2026 (seção 10)
- [x] Histórias de usuário: um épico por diagrama, no formato <SENDO><QUERO><PARA> ([Casos-de-uso-e-historias-NeuroSight.md](Especificacao/Casos-de-uso-e-historias-NeuroSight.md))
- [x] Diagrama de classes ([Diagrama-de-classes-NeuroSight.drawio](Especificacao/Diagrama-de-classes-NeuroSight.drawio) e [Diagrama-de-classes-NeuroSight.md](Especificacao/Diagrama-de-classes-NeuroSight.md))
- [x] (Opcional) Diagrama de estados da sessão, a partir da tabela "Estados da sessão": [Diagrama-de-estados-da-sessao.drawio](Especificacao/Diagrama-de-estados-da-sessao.drawio) e [Diagrama-de-estados-da-sessao.md](Especificacao/Diagrama-de-estados-da-sessao.md)
- [x] Diagrama lógico-relacional do banco ([Modelo-logico-relacional-NeuroSight.drawio](Especificacao/Modelo-logico-relacional-NeuroSight.drawio) e dicionário de dados em [Modelo-logico-relacional-NeuroSight.md](Especificacao/Modelo-logico-relacional-NeuroSight.md))
- [x] Diagramas de sequência: seis fluxos em [Diagramas-de-sequencia-NeuroSight.drawio](Especificacao/Diagramas-de-sequencia-NeuroSight.drawio), descritos com as rotas da API em [Diagramas-de-sequencia-NeuroSight.md](Especificacao/Diagramas-de-sequencia-NeuroSight.md)
- [x] Protótipos das telas web: 14 telas em [Prototipos-NeuroSight.html](Especificacao/Prototipos-NeuroSight/Prototipos-NeuroSight.html), com as imagens na pasta `Especificacao/Prototipos-NeuroSight/imagens` e o mapa das telas em [Prototipos-NeuroSight.md](Especificacao/Prototipos-NeuroSight/Prototipos-NeuroSight.md)
- [x] Protótipos das telas do app no óculos: código de pareamento, aguardando sessão, sessão pronta, execução e envio dos dados, no mesmo arquivo
- [x] Diagrama de arquitetura: página "Figura – Arquitetura" de [Arquitetura-NeuroSight.drawio](Especificacao/Arquitetura-NeuroSight.drawio), com o roteiro da IV.A em [Arquitetura-NeuroSight.md](Especificacao/Arquitetura-NeuroSight.md)

## 2. III. Método e tecnologias

O texto está em [III-Metodo-e-tecnologias.md](Texto-TCC/III-Metodo-e-tecnologias.md), com as Figuras 1 e 2 na pasta `Texto-TCC/figuras`.

- [x] Método de pesquisa: revisão bibliográfica, protótipo da IC e reuniões com o orientador
- [x] Ponto de partida: o protótipo da IC
- [x] Processo de desenvolvimento: Scrum adaptado ao trabalho individual, sprints de duas semanas e Kanban no GitHub Projects
- [x] Etapas: modelagem (TCC1) e desenvolvimento (TCC2)
- [x] Lista dos artefatos produzidos e das notações (UML, BPMN), incluindo os protótipos de tela
- [x] Figura 1 com os atores e a hierarquia dos perfis (UC00), acrescentada em 02/11/2026, e Figura 2 com um diagrama de casos de uso de exemplo (UC07 – Sessões)
- [x] Parágrafo sobre as histórias de usuário (épicos, formato SENDO/QUERO/PARA)
- [x] Nota de rodapé com o link da documentação completa: https://github.com/joaozanini/tcc1 (pasta Especificacao), na linha 59 de [III-Metodo-e-tecnologias.md](Texto-TCC/III-Metodo-e-tecnologias.md). Artigo montado, LaTeX, pacote do Overleaf e Word regenerados em 02/11/2026; o PDF ainda precisa ser recompilado (seção 10)
- [x] Nome do orientador na nota de informação verbal (BRAWERMAN, A.)
- [x] Tabela 2 – Tecnologias, com uma referência para cada uma (a Tabela 1 é a comparação da Seção II)
- [x] Trazer do 1.2 os perfis (proprietário, administrador, pesquisador) e o escopo funcional

## 3. IV. Resultados (abertura) + A. Arquitetura do Sistema

O texto está em [IV-A-Arquitetura-do-sistema.md](Texto-TCC/IV-A-Arquitetura-do-sistema.md), com as Figuras 3 e 4 na pasta `Texto-TCC/figuras`.

- [x] Parágrafo de abertura do capítulo
- [x] Figura de arquitetura com a tecnologia de cada bloco (Figura 3)
- [x] Descrição dos componentes: app do óculos (Unreal), API (NestJS), banco (PostgreSQL), armazenamento de arquivos, sistema web (Next.js), montagem do vídeo (FFmpeg)
- [x] 1) Multi-tenant: `tenant_id` + RLS e arquivos separados por tenant
- [x] 2) Comunicação entre sistema web, servidor e óculos: pareamento, envio da sessão, início por consulta ao servidor e envio dos dados, com a figura do fluxo atualizada (Figura 4)
- [x] 3) Dados coletados e gravação: estrutura do JSON (eventos de estímulo, olhar, expressões), quadros e MP4
- [x] 4) Segurança e auditoria: perfis, visibilidade das sessões, registro das ações, LGPD, paciente identificado só por código
- [x] 5) Riscos e limitações: rastreamento facial no Unreal, Quest Pro fora de linha (o grupo tem o aparelho da IC; o risco é a reposição) e internet no início
- [x] Hospedagem: o texto deixa as duas opções, VPS no Brasil ou servidor da instituição, conforme o protocolo aprovado pelo CEP (LGPD, art. 13); a Figura 3 diz "Servidor (VPS ou da instituição)"
- [x] Aplicar as mudanças da seção 7 do arquivo de decisões: estão no texto da IV.A e na Figura 4. Ao reaproveitar trechos do 1.2 em outras seções, não trazer o espelhamento nem a exigência de mesma rede

## 4. I. Introdução (base: 1.1)

O texto está em [I-Introducao.md](Texto-TCC/I-Introducao.md).

- [x] Enxugar contexto e problema em poucos parágrafos e levar o detalhamento para a Seção II
- [x] Escrever a frase de objetivo: "O objetivo deste trabalho é..."
- [x] Dizer que o trabalho parte do protótipo da IC
- [x] Manter a delimitação: o sistema não faz diagnóstico
- [x] Parágrafo final com a organização do documento

## 5. II. Revisão de literatura (base: 1.1)

O texto está em [II-Revisao-de-literatura.md](Texto-TCC/II-Revisao-de-literatura.md).

- [x] A. Distúrbios da consciência e avaliação clínica
- [x] B. Rastreamento ocular e expressões faciais, com duas revisões de 2026
- [x] C. Realidade virtual e Meta Quest Pro
- [x] D. Proteção de dados (LGPD, arts. 5º, 11 e 13), Resolução CNS 466/2012 e regras da Meta. O consentimento fica a cargo do protocolo da pesquisa, fora do sistema
- [x] E. Como os experimentos são conduzidos hoje: fluxo dos estudos citados e do protótipo da IC, em tópicos
- [x] F. Trabalhos semelhantes, com a Tabela 1 comparando iMotions, Tobii Pro Lab, SightLab VR Pro, Cognitive3D e PsychoPy, mais os estudos de Trojano, Johansson e Hyun
- [x] Pôr citação nas afirmações sem fonte: capacidades do Quest Pro, vantagens da RV e "aplicativos isolados, scripts e transferência manual"
- [x] Política de dados da Meta (§ 3.1): o orientador confirmou que o uso em pesquisa está de acordo. Hospedagem diante do art. 13 da LGPD: resolvida na IV.A, com as duas opções

## 6. Referências

- [x] Montar a lista das 13 obras já citadas: Laureys 2010, Giacino 2002, Giacino/Kalmar/Whyte 2004, Schnakers 2009, Bodien 2024, Trojano 2012, Johansson 2025, Magliacano 2019, Ekman/Friesen 1978, Picard 1997, Hyun 2022, LGPD 2018, Meta [202-]. Estão nas listas de [I-Introducao.md](Texto-TCC/I-Introducao.md) (com Johansson, Hyun e Picard separadas para a Seção II), [III-Metodo-e-tecnologias.md](Texto-TCC/III-Metodo-e-tecnologias.md) (Meta) e [IV-A-Arquitetura-do-sistema.md](Texto-TCC/IV-A-Arquitetura-do-sistema.md) (Ekman e LGPD)
- [x] Converter as citações de autor-data para numéricas [n], na ordem em que aparecem no texto: aplicado no artigo montado ([Artigo-TCC1-NeuroSight.md](Texto-TCC/Artigo-TCC1-NeuroSight.md)), com 63 referências
- [x] Acrescentar as referências do método e das tecnologias (lista no fim de [III-Metodo-e-tecnologias.md](Texto-TCC/III-Metodo-e-tecnologias.md))
- [x] Acrescentar as referências dos trabalhos semelhantes (lista no fim de [II-Revisao-de-literatura.md](Texto-TCC/II-Revisao-de-literatura.md))
- [x] Trocar "Meta, [202-]" pela página exata da documentação, com data de acesso: use [META-MOVE], da Seção III
- [x] Conferir os dados de cada referência: as obras do 1.1 e os estudos novos foram conferidos no Crossref ou no PubMed; os endereços das normas, do método, das tecnologias e das ferramentas responderam em 26/10/2026
- [x] Reconferência de 02/11/2026: as 63 referências são citadas no texto na ordem 1 a 63 e nenhuma sobra; os 14 DOIs batem com o Crossref (título, periódico, volume, páginas); os 46 endereços responderam, e as seis páginas da Meta e a do Road to VR, que bloqueiam scripts, abriram no navegador com os títulos e datas da lista. Único ajuste: o ano "[2026]" da referência da LGPD (seção 10)
- [x] Referências novas em 02/11/2026, para sustentar duas células da Tabela 1: [COG3D-HARDWARE] (Supported Hardware, documentação do Cognitive3D) e [PSYCHOPY-PAVLOVIA] (Create a Pavlovia project, documentação do PsychoPy). A lista passou a 65 referências, renumeradas a partir de [35]

## 7. Resumo e Abstract (por último)

O texto está em [Resumo-e-Abstract.md](Texto-TCC/Resumo-e-Abstract.md) e já entra no artigo montado.

- [x] Resumo em parágrafo único (o exemplo tem cerca de 170 palavras; este tem cerca de 210), com objetivo, método, tecnologias e resultado, mais as palavras-chave (quatro, como no exemplo)
- [x] Abstract e keywords

## 8. Pré-textuais e cabeçalho

- [x] Capa: UFPR, autor, título, Curitiba, PR, ano, com o desenho do prédio da UFPR ao fundo, como no exemplo (no LaTeX e no Word)
- [x] Folha de rosto: o mesmo, mais a natureza do trabalho e o orientador (no LaTeX e no Word)
- [x] Nome do orientador na folha de rosto (no LaTeX e no Word)
- [ ] Termo de aprovação: a página 3 tem só o aviso em vermelho do modelo; o termo entra depois da banca
- [x] Título, autor e afiliação no início do artigo

## 9. Formatação e revisão final

O artigo montado está em [Artigo-TCC1-NeuroSight.md](Texto-TCC/Artigo-TCC1-NeuroSight.md). A versão para entrega, no modelo LaTeX do curso, fica na pasta `Texto-TCC/LaTeX` (com o `textoprincipal.tex`) e no pacote `Texto-TCC/TCC1-NeuroSight-LaTeX.zip`, que vai direto para o Overleaf (New Project > Upload Project). A versão em Word, que continua sendo gerada junto, fica em `Texto-TCC/Artigo-TCC1-NeuroSight.docx`. Depois de editar uma seção, rode no Git Bash, na pasta do TCC: `perl Texto-TCC/montar-artigo.pl` e `perl Texto-TCC/gerar-latex.pl --pdf` (o `--pdf` compila com o TinyTeX e grava `Texto-TCC/TCC1-NeuroSight.pdf`). Para o Word, rode também `powershell -ExecutionPolicy Bypass -File .\Texto-TCC\gerar-docx.ps1`.

- [x] Versão em LaTeX no modelo do curso: capa, folha de rosto, termo (PDF do modelo, a trocar depois da banca) e artigo, com as mesmas chaves de citação dos arquivos das seções
- [x] Compilar a versão em LaTeX e conferir o PDF: recompilado em 02/11/2026 com o TinyTeX reinstalado em `%APPDATA%\TinyTeX` (TinyTeX v2026.11, TeX Live 2026, mais os pacotes background, everypage, babel-portuges e hyphen-portuguese), sem erros, em [TCC1-NeuroSight.pdf](Texto-TCC/TCC1-NeuroSight.pdf): 13 páginas, autor nos metadados, 65 citações em ordem, Figura 3 centrada, nota 2 com o link. O TinyTeX não foi posto no PATH; o `gerar-latex.pl --pdf` o encontra pelo `%APPDATA%`. Para gerar de novo, rode `perl Texto-TCC/gerar-latex.pl --pdf`
- [x] Versão em Word no formato do exemplo: capa, folha de rosto, página do termo de aprovação e o artigo em duas colunas (A4, Times New Roman 10, título em 24, seções em versalete, numeração de página embaixo), com as Figuras 1 a 4 e a Tabela 1 no alto da página, na largura toda, e a Tabela 2 dentro da coluna. São 14 páginas, das quais 11 são o artigo. A opção `-Pdf arquivo.pdf` também exporta um PDF

- [x] Legendas "FIGURA n - Título." acima e "FONTE: O autor (2026)" abaixo; o mesmo padrão nas tabelas
- [x] Tirar o título que está dentro da imagem da Figura 1 do 1.2 (a Figura 4 da IV.A substitui essa figura e não tem título dentro)
- [x] Trocar "seção 1.1" pela numeração nova (o artigo não cita mais o 1.1 nem o 1.2)
- [x] Toda figura e tabela citada no texto antes de aparecer (a Tabela 2 fica no alto da coluna, acima da frase que a cita, na mesma página: comportamento normal do *float*, igual ao do exemplo)
- [x] Termos estrangeiros em itálico e siglas definidas na primeira ocorrência (conferido no artigo montado; refaça a conferência se mudar o texto)
- [x] Tempo verbal: modelagem no passado; sistema no presente ou no futuro
- [x] Limite de páginas: não há (o artigo tem cerca de 5.450 palavras, 4 figuras, 2 tabelas e 65 referências)
- [x] Conferido em 02/11/2026: `Texto-TCC/TCC1-NeuroSight.pdf` e `Texto-TCC/LaTeX/build/textoprincipal.pdf` são o mesmo arquivo; o `.zip` tem exatamente os arquivos da pasta `LaTeX`; os `.md` regeneram um `.tex` idêntico ao entregue; o log não tem erro, *overfull* nem referência indefinida; os PNGs de `Texto-TCC/figuras` e `Texto-TCC/LaTeX/figuras` são idênticos, com fundo branco opaco e resolução efetiva acima de 430 dpi no PDF; os 19 protótipos estão completos, em português e coerentes entre si; nomes de estados, atores e perfis são os mesmos no texto, nos requisitos, nas classes, no banco, nos diagramas e nas telas; todo RF tem caso de uso e toda tela tem caso de uso
- [x] Comparação com o exemplo do curso (02/11/2026): até a IV.A, a estrutura é a mesma (pré-textuais, cabeçalho, resumo e abstract com quatro palavras-chave, Seções I a IV.A com o mesmo padrão de títulos, legendas e referências ABNT numéricas); o texto tem cerca de 6.300 palavras até a IV.A contra cerca de 2.900 do exemplo. O exemplo só tem a mais o link da documentação resolvido (nota 2) e as Seções IV.B, V e VI, que ficam para o TCC2

## 10. Pendências da revisão final (02/11/2026)

Revisão completa do PDF, dos fontes, dos oito `.drawio`, dos 19 protótipos, dos requisitos, das entregas 1.1 e 1.2 e do modelo do curso. O que passou está registrado nas seções 6 e 9. Abaixo, o que falta, em ordem de prioridade. Depois de qualquer mudança nos `.md`, rode `perl Texto-TCC/montar-artigo.pl`, `perl Texto-TCC/gerar-latex.pl --pdf` e, para o Word, `powershell -ExecutionPolicy Bypass -File .\Texto-TCC\gerar-docx.ps1`.

### Bloqueante

- [x] Nota 2 da Seção III: trocada em 02/11/2026 por `² Disponível em: https://github.com/joaozanini/tcc1 (pasta Especificacao). Acesso em: 2 nov. 2026.` ([III-Metodo-e-tecnologias.md](Texto-TCC/III-Metodo-e-tecnologias.md), linha 59). O repositório é o remoto `origin` deste Git; entraram um README na raiz e as 28 páginas dos `.drawio` em PNG em `Especificacao/imagens-dos-diagramas`. Artigo montado, LaTeX, zip do Overleaf e Word regenerados
- [ ] Fazer o `git push` para `origin` e deixar o repositório público; sem isso o link da nota 2 não abre
- [x] PDF recompilado em 02/11/2026 depois de reinstalar o TinyTeX (seção 9): 13 páginas, sem erro; figura do fluxo (hoje Figura 4) centrada e com texto maior, Tabela 1 com "Parcial (projetos no Pavlovia)" (p. 8), nota 2 com o link (p. 8), 65 referências em ordem (p. 12 e 13), autor nos metadados

### Importantes

- [x] Figura do fluxo (Figura 3 na época, hoje Figura 4): nota sem "(SD02)" no `.drawio` e PNG regenerado em 02/11/2026 com recorte e margens iguais às das outras figuras (renderizado com o visualizador do diagrams.net no Edge, que reproduziu a Figura 2 pixel a pixel no teste). Copiado para `Texto-TCC/figuras` e `Texto-TCC/LaTeX/figuras`; o PDF só mostra a figura nova depois de recompilado
- [x] Tabela 1: a II.F ganhou uma frase para o Cognitive3D (o Quest Pro está na lista de dispositivos em fim de vida da documentação, nova referência [COG3D-HARDWARE]) e outra para o PsychoPy (projetos privados no Pavlovia, compartilhados por convite com os papéis do GitLab, nova referência [PSYCHOPY-PAVLOVIA]); a célula virou "Parcial (projetos no Pavlovia)" (02/11/2026)
- [ ] Licença do NeuroSight na Tabela 1 continua "A definir": decisão sua. O protótipo da IC no GitHub não tem arquivo de licença, então "código aberto" ainda não está formalizado
- [x] BPMN do experimento: o evento de mensagem "Comando recebido" saiu, e "Enviar o comando de início" liga direto a "Executar a sessão…"; o `.md` foi ajustado (02/11/2026)
- [x] BPMN do experimento: "Falha registrada" virou evento de fim do tipo terminar, que encerra também o ramo do pesquisador que ficaria preso no join paralelo (02/11/2026)
- [x] UC11: UC07.6 "Iniciar sessão" entrou em cinza tracejado com «include» para UC11.2, e a tabela de casos de uso do `.md` registra o exemplo (02/11/2026)

### Menores (fazer se der tempo)

- [ ] Texto das Figuras 2 e 3 (UC07 e arquitetura) fica com cerca de 5 pt na impressão. Em [gerar-latex.pl](Texto-TCC/gerar-latex.pl), mudar `'Figura-2' => '0.75\textwidth'` para `'\textwidth'`, ou aumentar a fonte para 14 px no draw.io antes de exportar
- [x] Siglas da Figura 3 (arquitetura): VPS definida e pg-boss citado pelo nome na IV.A (02/11/2026)
- [x] "heatmap" nas telas W01, W11 e W14 trocado por "mapa de calor" e as três imagens regeneradas (02/11/2026). Nos documentos da especificação o termo heatmap continua, como nome técnico
- [x] RF59 passou a incluir a exportação de dados de sessão (02/11/2026)
- [x] Tabela de rotas dos diagramas de sequência: `GET /sessoes/{id}` marcada como "SD03 (só como nota), SD06" (02/11/2026)
- [x] Referência [LGPD] com o ano "[2018]" (02/11/2026)
- [x] Metadados do PDF: `gerar-latex.pl` passou a emitir `\hypersetup{pdfauthor={...}}` com o nome do autor (02/11/2026); vale a partir da próxima compilação
- [x] Decisões técnicas alinhadas ao RNF13: início em até cerca de 2 s, com consulta a cada ~1 s (02/11/2026)
- [ ] Opcionais de estilo: "o óculos" no singular em todo o texto (a norma culta pede "os óculos"); dizer na IV.A.2 que o espelhamento previsto na descrição inicial foi abandonado; "Multi-tenant" em itálico no título da subseção 1); distinguir a duração das sprints por etapa, como faz o exemplo

## Fica para o TCC2 (não fazer agora)

- IV.B Apresentação do Sistema, V. Considerações finais e VI. Artefatos
- Especificação técnica no template do curso ([Template Especificação Técnica TCC TADS UFPR.docx](Referencias-e-modelos/Template%20Especificação%20Técnica%20TCC%20TADS%20UFPR.docx)), com os apêndices de casos de uso, classes, histórias com protótipos e sequência, modelo do banco em pé de galinha e APIs: os artefatos da pasta `Especificacao` já cobrem esses apêndices (confirmar com o orientador se é entrega do TCC2)
- Termo de aprovação (fornecido depois da banca)
- Prova de conceito com o olhar e as expressões faciais juntos no Unreal, como primeira tarefa do desenvolvimento (se falhar, o plano B é Unity)
- Testes práticos: medir o tamanho do envio de uma sessão real (a IV.A estima cerca de 300 MB por sessão de 5 min) e testar a internet no local da coleta antes dos experimentos
- Desenvolvimento do sistema
