# II. Revisão de literatura

Versão de trabalho de 26/10/2026 (títulos das subseções com iniciais maiúsculas e legenda sem ponto final desde 03/11/2026, como no modelo `Referencias-e-modelos/TCC_Artigo_Modelo_2026.pdf`). Texto escrito a partir do 1.1 e no formato da Seção II do modelo: parágrafo de abertura e subseções com letras, a última com a tabela de comparação das soluções correlatas. Os estudos foram conferidos nas fontes originais, e as ferramentas da Subseção D, na documentação oficial de cada uma. Revista em 05/11/2026 conforme as observações do orientador: a subseção "Como os Experimentos São Conduzidos Hoje" foi adaptada e levada para a Introdução, a subseção "Proteção de Dados e Ética em Pesquisa" foi apagada, e "Trabalhos Semelhantes" ficou com as três ferramentas mais próximas do NeuroSight (iMotions, SightLab VR Pro e Cognitive3D); as subseções passaram a ser A a D.

## Como usar este arquivo

- **Citações:** as mesmas convenções das outras seções, com chaves entre colchetes. A numeração final é a do artigo montado, impressa pelo script.
- **Tabela:** a comparação da Subseção D é a Tabela 1 do artigo. Por isso, a tabela das tecnologias, na Seção III, é a Tabela 2.
- **Siglas:** DoC, SVNR, EMC, CRS-R, FACS, LGPD e IC já foram definidas na Introdução. RV é definida aqui; CEP, na Seção III.

---

## II. REVISÃO DE LITERATURA

Esta seção reúne os conceitos e os estudos que fundamentam o NeuroSight. As subseções tratam da avaliação clínica dos distúrbios da consciência, do uso do rastreamento ocular e das expressões faciais, da realidade virtual e dos trabalhos semelhantes ao proposto.

### A. Distúrbios da Consciência e Avaliação Clínica

Os DoC surgem após uma lesão cerebral grave, de origem traumática, vascular ou anóxica. No coma, o paciente não abre os olhos e não tem ciclo de sono e vigília. Na SVNR, os olhos se abrem e esse ciclo retorna, mas não há sinais de percepção de si ou do ambiente [LAUREYS]. No EMC, surgem sinais de consciência mínimos e flutuantes, porém reproduzíveis, como acompanhar um objeto com os olhos ou cumprir uma ordem simples [GIACINO2002].

A distinção entre esses estados é feita pela observação do paciente à beira do leito. A CRS-R, um dos instrumentos padronizados mais utilizados, examina seis domínios: audição, visão, motricidade, funções oromotoras e verbais, comunicação e nível de alerta [GIACINO2004]. Mesmo com uma escala padronizada, o resultado depende da interpretação do examinador e de respostas que podem não aparecer por motivos alheios à consciência, como paralisia, espasticidade, déficits sensoriais ou oscilações do nível de alerta. Schnakers et al. [SCHNAKERS] acompanharam 103 pacientes e verificaram que, dos 44 classificados em estado vegetativo pelo consenso da equipe médica, 18 (41%) estavam em EMC quando avaliados com a CRS-R; os autores alertam que esse erro pode ter consequências graves, principalmente em decisões de fim de vida. Em um estudo com 353 adultos de seis centros, Bodien et al. [BODIEN] identificaram a dissociação cognitivo-motora, em que o paciente executa tarefas mentais sem nenhuma resposta comportamental, em 60 dos 241 participantes (25%) sem resposta observável a comandos. A detecção dependeu de ressonância magnética funcional e de eletroencefalografia com tarefas, recursos de alto custo que, segundo os autores, ainda não estão amplamente disponíveis na avaliação clínica.

### B. Rastreamento Ocular e Expressões Faciais

O comportamento visual tem peso particular nessa avaliação. A fixação sustentada e a perseguição visual em resposta a estímulos em movimento ou relevantes estão entre os comportamentos que caracterizam o EMC [GIACINO2002]. À beira do leito, porém, esses comportamentos são julgados a olho nu: o examinador move um objeto ou um espelho diante do paciente e decide se os olhos o acompanharam. Movimentos pequenos, lentos ou inconsistentes podem passar despercebidos, e o exame não gera um registro que possa ser revisto depois.

O rastreamento ocular permite medir esses comportamentos de forma objetiva e deixa um registro do exame. Trojano et al. [TROJANO] apresentaram estímulos em movimento lento em um monitor e registraram o olhar com um rastreador infravermelho em 9 pacientes em estado vegetativo, 9 em EMC e 11 controles: a proporção de fixações sobre o alvo ficou no nível do acaso, ou abaixo dele, em todos os pacientes em estado vegetativo e acima do acaso em 7 dos 9 pacientes em EMC. Johansson et al. [JOHANSSON] registraram, com um rastreador vestível, os movimentos oculares de 12 pacientes com DoC prolongado durante a aplicação de quatro itens da CRS-R. A análise dos registros classificou como resposta 46,2% das tentativas, contra 18,1% na avaliação clínica feita ao mesmo tempo, com a diferença concentrada nos itens de perseguição e de fixação. Uma revisão sistemática recente, com 15 estudos publicados entre 2012 e 2025, concluiu que o rastreamento ocular detecta mais respostas do que a observação clínica, mas que a certeza da evidência ainda é baixa, e o recomendou como complemento à CRS-R, e não como substituto [ESTRANEO]. Na mesma linha, uma revisão de escopo apontou a fixação e a perseguição como indicadores sensíveis, porém dependentes do contexto [BAGNATO].

O tipo de estímulo também interfere na resposta. Na revisão sistemática de Magliacano et al. [MAGLIACANO], a maior parte dos estudos indicou que estímulos com significado pessoal, como o rosto do próprio paciente, rostos e vozes de familiares e o próprio nome, tendem a provocar mais respostas comportamentais e eletrofisiológicas do que imagens ou sons neutros, embora a qualidade geral das evidências seja baixa. Esse resultado reforça o interesse em observar, além do olhar, a reação emocional do paciente ao que é apresentado. As expressões faciais podem ser descritas de forma objetiva pelo FACS, que decompõe o rosto em unidades de ação associadas aos músculos faciais [EKMAN], e o reconhecimento de estados emocionais por sistemas computacionais é um dos temas da computação afetiva [PICARD].

### C. Realidade Virtual e Meta Quest Pro

A realidade virtual (RV) oferece um meio controlado para apresentar esses estímulos. Em óculos de RV, a imagem acompanha os movimentos da cabeça e permanece à mesma distância dos olhos, e o ambiente ao redor deixa de ser visto; como a cena é gerada por computador, ela é conhecida e pode ser reproduzida da mesma forma entre participantes, o que ajuda a padronizar as condições de cada sessão [CLAY]. Hyun et al. [HYUN] já empregaram RV combinada a rastreamento ocular na avaliação de 5 pacientes crônicos em estado vegetativo, em um estudo experimental de caso único: com três estímulos voltados à fixação, à perseguição e ao sobressalto visual, o sistema detectou fixação em três pacientes, o que a avaliação clínica não havia verificado.

Equipamentos como o Meta Quest Pro reúnem no mesmo dispositivo a exibição dos estímulos, o rastreamento ocular e o rastreamento das expressões faciais por câmeras internas [META-MOVE]. O rastreamento facial converte os movimentos do rosto em valores de expressões baseadas no FACS, cada um indicando uma intensidade. O aplicativo recebe apenas esses valores: as imagens das câmeras são processadas no próprio óculos e descartadas [META-FACE-PRIV].

### D. Trabalhos Semelhantes

Os estudos apresentados na Subseção B usaram instrumentos montados para cada pesquisa, sem uma ferramenta que organizasse o experimento do cadastro do paciente à análise. Entre as ferramentas disponíveis para pesquisas com rastreamento ocular, foram analisadas as três mais próximas do sistema proposto, cada uma por um aspecto: o iMotions, pela análise das expressões faciais e pela montagem da sequência de estímulos; o SightLab VR Pro, pela leitura do olhar e das expressões no Meta Quest Pro; e o Cognitive3D, pela gestão centralizada dos dados de vários grupos de pesquisa. A análise foi feita a partir da documentação oficial de cada uma, consultada em outubro de 2026.

O iMotions é uma plataforma comercial [IMOTIONS-PRICE] que analisa expressões faciais pela *webcam* ou por vídeo, com os algoritmos AFFDEX e Realeyes [IMOTIONS-FEA], e permite definir a ordem e a duração dos estímulos [IMOTIONS-SB]. O Meta Quest Pro passou a ser aceito em 2026, mas apenas pela importação de arquivos gravados no óculos, sem menção ao rastreamento facial do equipamento [IMOTIONS-NEWS]. Os dados ficam no computador do experimento, e o cumprimento do regulamento europeu de proteção de dados (GDPR) cabe ao cliente [IMOTIONS-TOS].

O SightLab VR Pro, da WorldViz, é um complemento comercial do ambiente Vizard para experimentos em RV [SIGHTLAB], [WORLDVIZ-PRICE]. É a ferramenta mais próxima do NeuroSight no óculos: lê o olhar e os parâmetros de expressão facial do Meta Quest Pro [SIGHTLAB-FACE], apresenta sequências de imagens e vídeos com troca por tempo [SIGHTLAB-MEDIA] e gera mapas de calor e reproduções das sessões [SIGHTLAB]. Os dados, porém, ficam no computador do experimento, e não foram encontrados recursos de contas por grupo de pesquisa nem de proteção de dados. O Cognitive3D é uma plataforma de análise para aplicações de RV, vendida como serviço por assinatura [COG3D-PRICING]. Reproduz as sessões em 3D, com o trajeto do olhar e mapas de calor, e organiza os dados em organizações, projetos e participantes, com papéis de acesso [COG3D-CONCEPTS]. Lê o olhar do Meta Quest Pro, mas a documentação lista o aparelho entre os dispositivos em fim de vida, que o fabricante deixou de vender e que podem não ter sido testados recentemente [COG3D-HARDWARE]. Também declara conformidade com o GDPR [COG3D-DPA] e oferece registro de auditoria no plano mais caro [COG3D-PRICING], mas não foram encontrados recursos para montar a sequência de estímulos nem suporte às expressões faciais. A Tabela 1 resume a comparação.

**TABELA 1** - Comparação entre as ferramentas semelhantes e o NeuroSight

| Ferramenta | Licença | Olhar no Meta Quest Pro | Expressões faciais | Sequência de estímulos com tempo | Dados de vários grupos, com papéis | Registro de auditoria |
|---|---|---|---|---|---|---|
| iMotions | Comercial | Só por importação | Pela *webcam* | Sim | Não (dados locais) | Não encontrado |
| SightLab VR Pro | Comercial | Sim | Valores do óculos | Sim | Não (dados locais) | Não encontrado |
| Cognitive3D | Assinatura | Sim (em fim de vida) | Não encontrado | Não encontrado | Sim | Só no plano Enterprise |
| NeuroSight | A definir | Sim | Valores do óculos | Sim | Sim | Sim |

FONTE: Os autores (2026), com base na documentação das ferramentas

Como mostra a Tabela 1, nenhuma das ferramentas analisadas reúne, ao mesmo tempo, a coleta do olhar e das expressões faciais no Meta Quest Pro, a apresentação de uma sequência de estímulos com tempo definido e o armazenamento centralizado dos dados de vários grupos de pesquisa, com controle de acesso e auditoria. O SightLab VR Pro é o mais próximo no que se refere ao óculos, mas guarda os dados localmente; o Cognitive3D é o mais próximo na gestão dos dados, mas não apresenta estímulos nem lê as expressões faciais. Também não foram encontrados, em nenhuma delas, recursos voltados a pacientes com DoC, como estímulos pessoais vinculados a cada paciente. Essa lacuna motiva o desenvolvimento do NeuroSight.

---

## Referências novas nesta seção

No formato do modelo. A numeração é dada pelo script de montagem, na ordem da primeira citação; desde 05/11/2026, [JOHANSSON] e [HYUN] são citadas antes, na Introdução. Os endereços responderam em 26/10/2026; os da Meta só abrem no navegador.

**Estudos e normas**

- **[JOHANSSON]** JOHANSSON, J. *et al*. Eye tracking to support assessment of patients with prolonged disorder of consciousness: a case series. *Journal of Rehabilitation Medicine*, v. 57, art. jrm41324, 2025. DOI: 10.2340/jrm.v57.41324.
- **[ESTRANEO]** ESTRANEO, A. *et al*. Eye-tracking assessment in patients with disorders of consciousness: a systematic review. *Brain Sciences*, v. 16, n. 6, art. 590, 2026. DOI: 10.3390/brainsci16060590.
- **[BAGNATO]** BAGNATO, S.; BOCCAGNI, C.; BONAVITA, J. Eye movements as indicators of awareness in prolonged disorders of consciousness: a scoping review of behavioral and neural evidence. *Neurological Sciences*, v. 47, n. 3, art. 317, 2026. DOI: 10.1007/s10072-026-08932-6.
- **[PICARD]** PICARD, R. W. *Affective computing*. Cambridge: MIT Press, 1997. DOI: 10.7551/mitpress/1140.001.0001.
- **[HYUN]** HYUN, C. *et al*. Quantitative evaluation of the consciousness level of patients in a vegetative state using virtual reality and an eye-tracking system: a single-case experimental design study. *Neuropsychological Rehabilitation*, v. 32, n. 10, p. 2628-2645, 2022. DOI: 10.1080/09602011.2021.1974496.

**Documentação da Meta**

- **[META-FACE-PRIV]** META PLATFORMS. *Natural Facial Expressions Privacy Notice*. 5 set. 2025. Disponível em: https://www.meta.com/legal/quest/natural-facial-expressions-privacy-notice/. Acesso em: 26 out. 2026.

**Ferramentas semelhantes**

- **[IMOTIONS-PRICE]** IMOTIONS. *iMotions Lab Pricing*. Disponível em: https://imotions.com/products/pricing/. Acesso em: 26 out. 2026.
- **[IMOTIONS-FEA]** IMOTIONS. *Facial Expression Analysis*: emotion detection software. Disponível em: https://imotions.com/products/imotions-lab/modules/fea-facial-expression-analysis/. Acesso em: 26 out. 2026.
- **[IMOTIONS-SB]** IMOTIONS. *Study Builder*. Disponível em: https://imotions.com/products/imotions-lab/features/study-builder/. Acesso em: 26 out. 2026.
- **[IMOTIONS-NEWS]** IMOTIONS. *iMotions Product & Feature News*: February 2026. 2026. Disponível em: https://imotions.com/about-us/news/imotions-product-feature-news-february-2026/. Acesso em: 26 out. 2026.
- **[IMOTIONS-TOS]** IMOTIONS. *Terms of Service*. Disponível em: https://imotions.com/terms-of-service/. Acesso em: 26 out. 2026.
- **[SIGHTLAB]** WORLDVIZ. *What is SightLab VR Pro and how does it work?* 2025. Disponível em: https://www.worldviz.com/post/what-is-sightlab-vr-pro-and-how-does-it-work. Acesso em: 26 out. 2026.
- **[WORLDVIZ-PRICE]** WORLDVIZ. *2026 WorldViz VR budgeting guidelines for scientific VR labs*. 2026. Disponível em: https://www.worldviz.com/post/worldviz-vr-budgeting-guidelines-for-scientific-vr-labs. Acesso em: 26 out. 2026.
- **[SIGHTLAB-FACE]** WORLDVIZ. *Face Tracking*: SightLab documentation. Disponível em: https://help.worldviz.com/sightlab/face-tracking. Acesso em: 26 out. 2026.
- **[SIGHTLAB-MEDIA]** WORLDVIZ. *Media Viewer*: SightLab documentation. Disponível em: https://help.worldviz.com/sightlab/media-viewer/. Acesso em: 26 out. 2026.
- **[COG3D-PRICING]** COGNITIVE3D. *XR Analytics Platform Pricing*. Disponível em: https://cognitive3d.com/pricing/. Acesso em: 26 out. 2026.
- **[COG3D-CONCEPTS]** COGNITIVE3D. *Concepts*: Cognitive3D documentation. Disponível em: https://docs.cognitive3d.com/dashboard/concepts/. Acesso em: 26 out. 2026.
- **[COG3D-DPA]** COGNITIVE3D. *Data Processing Addendum*. Disponível em: https://cognitive3d.com/dpa/. Acesso em: 26 out. 2026.
- **[COG3D-HARDWARE]** COGNITIVE3D. *Supported Hardware*: Cognitive3D documentation. Disponível em: https://docs.cognitive3d.com/hardware/. Acesso em: 2 nov. 2026.

**Referências retiradas em 05/11/2026** (ficavam na subseção de proteção de dados, apagada, e nas duas ferramentas que saíram da comparação; não são mais citadas, e o script de montagem as ignora)

- **[CNS466]** BRASIL. Conselho Nacional de Saúde. *Resolução nº 466, de 12 de dezembro de 2012*. Aprova as diretrizes e normas regulamentadoras de pesquisas envolvendo seres humanos. Diário Oficial da União: seção 1, Brasília, DF, p. 59, 13 jun. 2013. Disponível em: https://www.gov.br/conselho-nacional-de-saude/pt-br/atos-normativos/resolucoes/2012/resolucao-no-466.pdf. Acesso em: 26 out. 2026.
- **[META-ET]** META PLATFORMS. *Eye Tracking in Movement SDK for OpenXR*. 2026. Disponível em: https://developers.meta.com/horizon/documentation/native/android/move-eye-tracking/. Acesso em: 26 out. 2026.
- **[META-FT]** META PLATFORMS. *Face Tracking in Movement SDK for OpenXR*. 2026. Disponível em: https://developers.meta.com/horizon/documentation/native/android/move-face-tracking/. Acesso em: 26 out. 2026.
- **[META-POLICY]** META PLATFORMS. *Developer Data Use Policy*. 2 jul. 2026. Disponível em: https://developers.meta.com/horizon/policy/data-use/. Acesso em: 26 out. 2026.
- **[TOBII-PROLAB]** TOBII. *Tobii Pro Lab*: eye tracking software for behavior research. Disponível em: https://www.tobii.com/products/software/behavior-research-software/tobii-pro-lab. Acesso em: 26 out. 2026.
- **[PSYCHOPY-ABOUT]** PSYCHOPY. *About PsychoPy*. Disponível em: https://psychopy.org/about/index.html. Acesso em: 26 out. 2026.
- **[PSYCHOPY-TIMING]** PSYCHOPY. *Defining the onset/duration of components*. Disponível em: https://psychopy.org/builder/startStop.html. Acesso em: 26 out. 2026.
- **[PSYCHOPY-ET]** PSYCHOPY. *Communicating with an eyetracker*. Disponível em: https://psychopy.org/hardware/eyeTracking.html. Acesso em: 26 out. 2026.
- **[PSYCHOPY-RIFT]** PSYCHOPY. *psychopy.visual.Rift*. Disponível em: https://psychopy.org/api/visual/rift.html. Acesso em: 26 out. 2026.
- **[PSYCHOPY-ONLINE]** PSYCHOPY. *Advanced features for online experiments*. Disponível em: https://psychopy.org/online/advanced-features-online.html. Acesso em: 26 out. 2026.
- **[PSYCHOPY-PAVLOVIA]** PSYCHOPY. *Create a Pavlovia project*. Disponível em: https://psychopy.org/online/create-pavlovia-project.html. Acesso em: 2 nov. 2026.

## O que conferir antes de passar para o modelo

1. **Hospedagem e LGPD:** o art. 13 fala em tratar os dados "exclusivamente dentro do órgão" de pesquisa e veda a transferência a terceiro. Por isso, a Subseção III.C deixa as duas opções: uma VPS contratada no Brasil ou um servidor da instituição, conforme o protocolo aprovado pelo CEP.
2. **Ferramentas:** as informações vêm de páginas dos fabricantes e podem mudar. As duas que saíram da comparação em 05/11/2026 (Tobii Pro Lab e PsychoPy) continuam descritas na versão anterior do arquivo, no histórico do Git.
3. **Estudos:** o texto integral de Hyun et al. e de Bagnato et al. é pago; os dados citados vêm dos resumos.
4. **Tamanho:** a seção tem cerca de 1.500 palavras (com a Tabela 1) e 17 referências novas, depois dos cortes de 05/11/2026.
