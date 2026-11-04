# II. Revisão de literatura

Versão de trabalho de 26/10/2026 (títulos das subseções com iniciais maiúsculas e legenda sem ponto final desde 03/11/2026, como no modelo `Referencias-e-modelos/TCC_Artigo_Modelo_2026.pdf`). Texto escrito a partir do 1.1 e no formato da Seção II do modelo: parágrafo de abertura e subseções com letras, a última com a tabela de comparação das soluções correlatas. Os estudos e as normas foram conferidos nas fontes originais, e as ferramentas da Subseção F, na documentação oficial de cada uma.

## Como usar este arquivo

- **Citações:** as mesmas convenções das outras seções, com chaves entre colchetes. A Seção II vem logo depois da Introdução, então a numeração final das referências novas também já pode ser fixada (tabela no fim do arquivo).
- **Tabela:** a comparação da Subseção F é a Tabela 1 do artigo. Por isso, a tabela das tecnologias, na Seção III, passou a ser a Tabela 2.
- **Fluxo atual (Subseção E):** descrito a partir dos estudos citados e do protótipo da IC, sem atribuí-lo a um grupo específico, conforme combinado.
- **Siglas:** DoC, SVNR, EMC, CRS-R, FACS, LGPD e IC já foram definidas na Introdução. RV e CEP são definidas aqui.

---

## II. REVISÃO DE LITERATURA

Esta seção reúne os conceitos e os estudos que fundamentam o NeuroSight. As subseções tratam da avaliação clínica dos distúrbios da consciência, do uso do rastreamento ocular e das expressões faciais, da realidade virtual, da proteção dos dados, da forma como esses experimentos são conduzidos hoje e dos trabalhos semelhantes ao proposto.

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

### D. Proteção de Dados e Ética em Pesquisa

Informações de saúde são dados pessoais sensíveis segundo a LGPD (art. 5º, II) [LGPD]. O tratamento desses dados só pode ocorrer nas hipóteses do art. 11, entre elas o consentimento do titular ou de seu responsável legal e, sem consentimento, a realização de estudos por órgão de pesquisa, garantida, sempre que possível, a anonimização dos dados. Para estudos em saúde pública, o art. 13 determina que os dados sejam tratados em ambiente controlado e seguro, com anonimização ou pseudonimização sempre que possível. A pseudonimização é o tratamento pelo qual o dado perde a possibilidade de associação a um indivíduo, senão pelo uso de informação adicional mantida separadamente pelo controlador [LGPD].

A pesquisa com seres humanos segue, ainda, a Resolução nº 466/2012 do Conselho Nacional de Saúde [CNS466]. Quando o participante tem a capacidade de decisão substancialmente diminuída, como ocorre com pacientes com DoC, o consentimento é dado por seus representantes legais, e o protocolo precisa justificar essa escolha e ser aprovado pelo Comitê de Ética em Pesquisa (CEP) antes do início do estudo (itens IV.6 e XI.2). O fabricante do equipamento também impõe regras: no Meta Quest Pro, o rastreamento ocular e o facial são permissões que o aplicativo precisa pedir, e o desenvolvedor deve informar o usuário e obter o seu consentimento antes da coleta [META-ET], [META-FT]. O uso desses dados é limitado, ainda, pela política de uso de dados da Meta para desenvolvedores [META-POLICY].

Assim, o consentimento para a participação fica a cargo do protocolo de cada pesquisa, por meio do termo assinado pelo representante legal, e não é tratado pelo sistema. Cabe ao sistema reduzir os dados ao necessário, identificar o paciente por um código, o que corresponde à pseudonimização, controlar o acesso às sessões e registrar as ações realizadas.

### E. Como os Experimentos São Conduzidos Hoje

Nos estudos citados, os experimentos com rastreamento ocular em pacientes com DoC seguem, em linhas gerais, o seguinte fluxo:

- o pesquisador escolhe estímulos que testam a fixação e a perseguição visual, muitas vezes inspirados nos itens da CRS-R [JOHANSSON], [HYUN];
- os estímulos são apresentados em um monitor diante do paciente [TROJANO], com objetos reais enquanto o paciente usa um rastreador vestível [JOHANSSON] ou em um aplicativo de RV próprio [HYUN];
- o rastreador grava o olhar, e as gravações são revistas em um programa de análise, como o do fabricante do rastreador [JOHANSSON];
- a análise é feita depois, em geral comparando os registros com a avaliação clínica [TROJANO], [JOHANSSON].

No protótipo da IC [IC], o fluxo era parecido, mas já reunia parte das etapas: o pesquisador abria o aplicativo no óculos e encerrava a sessão por um botão do controle, que enviava os dados ao servidor; sem rede, os arquivos eram copiados do óculos por cabo e enviados depois por um *script*. Não havia cadastro de pacientes nem de estímulos, e associar cada sessão ao paciente correto ficava a cargo do pesquisador. Nesse fluxo, as etapas dependem de programas diferentes e de transferências manuais, e não há controle de quem acessa os dados nem registro das ações.

### F. Trabalhos Semelhantes

Os estudos apresentados na Subseção B usaram instrumentos montados para cada pesquisa, sem uma ferramenta que organizasse o experimento do cadastro do paciente à análise. Entre as ferramentas disponíveis para pesquisas com rastreamento ocular, foram analisadas cinco, escolhidas por apresentarem estímulos, registrarem o olhar ou trabalharem com RV: iMotions, Tobii Pro Lab, SightLab VR Pro, Cognitive3D e PsychoPy. A análise foi feita a partir da documentação oficial de cada uma, consultada em outubro de 2026.

O iMotions é uma plataforma comercial [IMOTIONS-PRICE] que analisa expressões faciais pela *webcam* ou por vídeo, com os algoritmos AFFDEX e Realeyes [IMOTIONS-FEA], e permite definir a ordem e a duração dos estímulos [IMOTIONS-SB]. O Meta Quest Pro passou a ser aceito em 2026, mas apenas pela importação de arquivos gravados no óculos, sem menção ao rastreamento facial do equipamento [IMOTIONS-NEWS]. Os dados ficam no computador do experimento, e o cumprimento do regulamento europeu de proteção de dados (GDPR) cabe ao cliente [IMOTIONS-TOS]. O Tobii Pro Lab, do fabricante de rastreadores Tobii, é um programa comercial para gravar e analisar o olhar, com mapas de calor, áreas de interesse e estímulos organizados em uma linha do tempo, e os projetos ficam no computador local [TOBII-PROLAB]. Foi o programa usado por Johansson et al. para rever as gravações dos pacientes [JOHANSSON], mas não foram encontrados suporte atual a óculos de RV nem análise de expressões faciais.

O SightLab VR Pro, da WorldViz, é um complemento comercial do ambiente Vizard para experimentos em RV [SIGHTLAB], [WORLDVIZ-PRICE]. É a ferramenta mais próxima do NeuroSight no óculos: lê o olhar e os parâmetros de expressão facial do Meta Quest Pro [SIGHTLAB-FACE], apresenta sequências de imagens e vídeos com troca por tempo [SIGHTLAB-MEDIA] e gera mapas de calor e reproduções das sessões [SIGHTLAB]. Os dados, porém, ficam no computador do experimento, e não foram encontrados recursos de contas por grupo de pesquisa nem de proteção de dados. O Cognitive3D é uma plataforma de análise para aplicações de RV, vendida como serviço por assinatura [COG3D-PRICING]. Reproduz as sessões em 3D, com o trajeto do olhar e mapas de calor, e organiza os dados em organizações, projetos e participantes, com papéis de acesso [COG3D-CONCEPTS]. Lê o olhar do Meta Quest Pro, mas a documentação lista o aparelho entre os dispositivos em fim de vida, que o fabricante deixou de vender e que podem não ter sido testados recentemente [COG3D-HARDWARE]. Também declara conformidade com o GDPR [COG3D-DPA] e oferece registro de auditoria no plano mais caro [COG3D-PRICING], mas não foram encontrados recursos para montar a sequência de estímulos nem suporte às expressões faciais.

O PsychoPy é um programa gratuito e de código aberto para experimentos de psicologia [PSYCHOPY-ABOUT], que define o início e a duração de cada estímulo [PSYCHOPY-TIMING] e se comunica com rastreadores oculares [PSYCHOPY-ET]. O suporte a RV, contudo, limita-se ao Oculus Rift [PSYCHOPY-RIFT], e a análise de expressões faciais só existe nos experimentos on-line, pela *webcam* [PSYCHOPY-ONLINE]. Esses experimentos ficam em projetos da plataforma Pavlovia, privados por padrão e compartilhados com outros usuários ou grupos por convite, com os papéis de acesso do GitLab [PSYCHOPY-PAVLOVIA]. A Tabela 1 resume a comparação.

**TABELA 1** - Comparação entre as ferramentas semelhantes e o NeuroSight

| Ferramenta | Licença | Olhar no Meta Quest Pro | Expressões faciais | Sequência de estímulos com tempo | Dados de vários grupos, com papéis | Registro de auditoria |
|---|---|---|---|---|---|---|
| iMotions | Comercial | Só por importação | Pela *webcam* | Sim | Não (dados locais) | Não encontrado |
| Tobii Pro Lab | Comercial | Não encontrado | Não encontrado | Sim | Não (dados locais) | Não encontrado |
| SightLab VR Pro | Comercial | Sim | Valores do óculos | Sim | Não (dados locais) | Não encontrado |
| Cognitive3D | Assinatura | Sim (em fim de vida) | Não encontrado | Não encontrado | Sim | Só no plano Enterprise |
| PsychoPy | Gratuita | Não (só Oculus Rift) | Pela *webcam*, só on-line | Sim | Parcial (projetos no Pavlovia) | Não encontrado |
| NeuroSight | A definir | Sim | Valores do óculos | Sim | Sim | Sim |

FONTE: Os autores (2026), com base na documentação das ferramentas

Como mostra a Tabela 1, nenhuma das ferramentas analisadas reúne, ao mesmo tempo, a coleta do olhar e das expressões faciais no Meta Quest Pro, a apresentação de uma sequência de estímulos com tempo definido e o armazenamento centralizado dos dados de vários grupos de pesquisa, com controle de acesso e auditoria. O SightLab VR Pro é o mais próximo no que se refere ao óculos, mas guarda os dados localmente; o Cognitive3D é o mais próximo na gestão dos dados, mas não apresenta estímulos nem lê as expressões faciais. Também não foram encontrados, em nenhuma delas, recursos voltados a pacientes com DoC, como estímulos pessoais vinculados a cada paciente. Essa lacuna motiva o desenvolvimento do NeuroSight.

---

## Referências novas nesta seção

Na ordem em que aparecem no texto, no formato do modelo. As chaves já usadas na Introdução mantêm os números de lá ([1] a [12]).

| Chave | Número | | Chave | Número |
|---|---|---|---|---|
| [JOHANSSON] | [13] | | [IMOTIONS-TOS] | [27] |
| [ESTRANEO] | [14] | | [TOBII-PROLAB] | [28] |
| [BAGNATO] | [15] | | [SIGHTLAB] | [29] |
| [PICARD] | [16] | | [WORLDVIZ-PRICE] | [30] |
| [HYUN] | [17] | | [SIGHTLAB-FACE] | [31] |
| [META-FACE-PRIV] | [18] | | [SIGHTLAB-MEDIA] | [32] |
| [CNS466] | [19] | | [COG3D-PRICING] | [33] |
| [META-ET] | [20] | | [COG3D-CONCEPTS] | [34] |
| [META-FT] | [21] | | [COG3D-DPA] | [35] |
| [META-POLICY] | [22] | | [PSYCHOPY-ABOUT] | [36] |
| [IMOTIONS-PRICE] | [23] | | [PSYCHOPY-TIMING] | [37] |
| [IMOTIONS-FEA] | [24] | | [PSYCHOPY-ET] | [38] |
| [IMOTIONS-SB] | [25] | | [PSYCHOPY-RIFT] | [39] |
| [IMOTIONS-NEWS] | [26] | | [PSYCHOPY-ONLINE] | [40] |

A numeração foi conferida por script, pela ordem da primeira citação na Introdução e nesta seção. Os endereços responderam em 26/10/2026; os da Meta só abrem no navegador. Em 02/11/2026 entraram [COG3D-HARDWARE] e [PSYCHOPY-PAVLOVIA] na Subseção F, o que desloca a numeração a partir de [36]; a numeração válida é a do artigo montado.

**Estudos e normas**

- **[JOHANSSON]** JOHANSSON, J. *et al*. Eye tracking to support assessment of patients with prolonged disorder of consciousness: a case series. *Journal of Rehabilitation Medicine*, v. 57, art. jrm41324, 2025. DOI: 10.2340/jrm.v57.41324.
- **[ESTRANEO]** ESTRANEO, A. *et al*. Eye-tracking assessment in patients with disorders of consciousness: a systematic review. *Brain Sciences*, v. 16, n. 6, art. 590, 2026. DOI: 10.3390/brainsci16060590.
- **[BAGNATO]** BAGNATO, S.; BOCCAGNI, C.; BONAVITA, J. Eye movements as indicators of awareness in prolonged disorders of consciousness: a scoping review of behavioral and neural evidence. *Neurological Sciences*, v. 47, n. 3, art. 317, 2026. DOI: 10.1007/s10072-026-08932-6.
- **[PICARD]** PICARD, R. W. *Affective computing*. Cambridge: MIT Press, 1997. DOI: 10.7551/mitpress/1140.001.0001.
- **[HYUN]** HYUN, C. *et al*. Quantitative evaluation of the consciousness level of patients in a vegetative state using virtual reality and an eye-tracking system: a single-case experimental design study. *Neuropsychological Rehabilitation*, v. 32, n. 10, p. 2628-2645, 2022. DOI: 10.1080/09602011.2021.1974496.
- **[CNS466]** BRASIL. Conselho Nacional de Saúde. *Resolução nº 466, de 12 de dezembro de 2012*. Aprova as diretrizes e normas regulamentadoras de pesquisas envolvendo seres humanos. Diário Oficial da União: seção 1, Brasília, DF, p. 59, 13 jun. 2013. Disponível em: https://www.gov.br/conselho-nacional-de-saude/pt-br/atos-normativos/resolucoes/2012/resolucao-no-466.pdf. Acesso em: 26 out. 2026.

**Documentação da Meta**

- **[META-FACE-PRIV]** META PLATFORMS. *Natural Facial Expressions Privacy Notice*. 5 set. 2025. Disponível em: https://www.meta.com/legal/quest/natural-facial-expressions-privacy-notice/. Acesso em: 26 out. 2026.
- **[META-ET]** META PLATFORMS. *Eye Tracking in Movement SDK for OpenXR*. 2026. Disponível em: https://developers.meta.com/horizon/documentation/native/android/move-eye-tracking/. Acesso em: 26 out. 2026.
- **[META-FT]** META PLATFORMS. *Face Tracking in Movement SDK for OpenXR*. 2026. Disponível em: https://developers.meta.com/horizon/documentation/native/android/move-face-tracking/. Acesso em: 26 out. 2026.
- **[META-POLICY]** META PLATFORMS. *Developer Data Use Policy*. 2 jul. 2026. Disponível em: https://developers.meta.com/horizon/policy/data-use/. Acesso em: 26 out. 2026.

**Ferramentas semelhantes**

- **[IMOTIONS-PRICE]** IMOTIONS. *iMotions Lab Pricing*. Disponível em: https://imotions.com/products/pricing/. Acesso em: 26 out. 2026.
- **[IMOTIONS-FEA]** IMOTIONS. *Facial Expression Analysis*: emotion detection software. Disponível em: https://imotions.com/products/imotions-lab/modules/fea-facial-expression-analysis/. Acesso em: 26 out. 2026.
- **[IMOTIONS-SB]** IMOTIONS. *Study Builder*. Disponível em: https://imotions.com/products/imotions-lab/features/study-builder/. Acesso em: 26 out. 2026.
- **[IMOTIONS-NEWS]** IMOTIONS. *iMotions Product & Feature News*: February 2026. 2026. Disponível em: https://imotions.com/about-us/news/imotions-product-feature-news-february-2026/. Acesso em: 26 out. 2026.
- **[IMOTIONS-TOS]** IMOTIONS. *Terms of Service*. Disponível em: https://imotions.com/terms-of-service/. Acesso em: 26 out. 2026.
- **[TOBII-PROLAB]** TOBII. *Tobii Pro Lab*: eye tracking software for behavior research. Disponível em: https://www.tobii.com/products/software/behavior-research-software/tobii-pro-lab. Acesso em: 26 out. 2026.
- **[SIGHTLAB]** WORLDVIZ. *What is SightLab VR Pro and how does it work?* 2025. Disponível em: https://www.worldviz.com/post/what-is-sightlab-vr-pro-and-how-does-it-work. Acesso em: 26 out. 2026.
- **[WORLDVIZ-PRICE]** WORLDVIZ. *2026 WorldViz VR budgeting guidelines for scientific VR labs*. 2026. Disponível em: https://www.worldviz.com/post/worldviz-vr-budgeting-guidelines-for-scientific-vr-labs. Acesso em: 26 out. 2026.
- **[SIGHTLAB-FACE]** WORLDVIZ. *Face Tracking*: SightLab documentation. Disponível em: https://help.worldviz.com/sightlab/face-tracking. Acesso em: 26 out. 2026.
- **[SIGHTLAB-MEDIA]** WORLDVIZ. *Media Viewer*: SightLab documentation. Disponível em: https://help.worldviz.com/sightlab/media-viewer/. Acesso em: 26 out. 2026.
- **[COG3D-PRICING]** COGNITIVE3D. *XR Analytics Platform Pricing*. Disponível em: https://cognitive3d.com/pricing/. Acesso em: 26 out. 2026.
- **[COG3D-CONCEPTS]** COGNITIVE3D. *Concepts*: Cognitive3D documentation. Disponível em: https://docs.cognitive3d.com/dashboard/concepts/. Acesso em: 26 out. 2026.
- **[COG3D-DPA]** COGNITIVE3D. *Data Processing Addendum*. Disponível em: https://cognitive3d.com/dpa/. Acesso em: 26 out. 2026.
- **[COG3D-HARDWARE]** COGNITIVE3D. *Supported Hardware*: Cognitive3D documentation. Disponível em: https://docs.cognitive3d.com/hardware/. Acesso em: 2 nov. 2026.
- **[PSYCHOPY-ABOUT]** PSYCHOPY. *About PsychoPy*. Disponível em: https://psychopy.org/about/index.html. Acesso em: 26 out. 2026.
- **[PSYCHOPY-TIMING]** PSYCHOPY. *Defining the onset/duration of components*. Disponível em: https://psychopy.org/builder/startStop.html. Acesso em: 26 out. 2026.
- **[PSYCHOPY-ET]** PSYCHOPY. *Communicating with an eyetracker*. Disponível em: https://psychopy.org/hardware/eyeTracking.html. Acesso em: 26 out. 2026.
- **[PSYCHOPY-RIFT]** PSYCHOPY. *psychopy.visual.Rift*. Disponível em: https://psychopy.org/api/visual/rift.html. Acesso em: 26 out. 2026.
- **[PSYCHOPY-ONLINE]** PSYCHOPY. *Advanced features for online experiments*. Disponível em: https://psychopy.org/online/advanced-features-online.html. Acesso em: 26 out. 2026.
- **[PSYCHOPY-PAVLOVIA]** PSYCHOPY. *Create a Pavlovia project*. Disponível em: https://psychopy.org/online/create-pavlovia-project.html. Acesso em: 2 nov. 2026.

## O que conferir antes de passar para o modelo

1. **Política de dados da Meta:** o § 3.1 da política limita o uso dos dados de olhar e de expressões a operar e melhorar o aplicativo, a análises agregadas ou desidentificadas e ao cumprimento da lei. Confirmado com o orientador: o uso em pesquisa está de acordo com a política.
2. **Hospedagem e LGPD:** o art. 13 fala em tratar os dados "exclusivamente dentro do órgão" de pesquisa e veda a transferência a terceiro. Por isso, a Subseção III.C deixa as duas opções: uma VPS contratada no Brasil ou um servidor da instituição, conforme o protocolo aprovado pelo CEP.
3. **Ferramentas:** as informações vêm de páginas dos fabricantes e podem mudar. A informação de que o Tobii Pro Lab não tem mais projetos em RV vem de um artigo de suporte que não abriu por completo, por isso o texto diz "não foram encontrados".
4. **Estudos:** o texto integral de Hyun et al. e de Bagnato et al. é pago; os dados citados vêm dos resumos.
5. **Tamanho:** a seção tem cerca de 2.000 palavras e 28 referências novas. Se precisar cortar, as primeiras candidatas são as revisões de 2026 na Subseção B e o detalhamento de cada ferramenta na Subseção F, que a Tabela 1 já resume.
