# II. Revisão de literatura

Versão de trabalho de 26/10/2026 (títulos das subseções com iniciais maiúsculas e legenda sem ponto final desde 03/11/2026, como no modelo `Referencias-e-modelos/TCC_Artigo_Modelo_2026.pdf`). Texto escrito a partir do 1.1 e no formato da Seção II do modelo: parágrafo de abertura e subseções com letras, a última com a tabela de comparação das soluções correlatas. Os estudos foram conferidos nas fontes originais, e as ferramentas da Subseção D, na documentação oficial de cada uma. Revista em 05/11/2026 conforme as observações do orientador: a subseção "Como os Experimentos São Conduzidos Hoje" foi adaptada e levada para a Introdução, a subseção "Proteção de Dados e Ética em Pesquisa" foi apagada, e "Trabalhos Semelhantes" ficou com as três ferramentas mais próximas do NeuroSight (iMotions, SightLab VR Pro e Cognitive3D); as subseções passaram a ser A a D. Em 10/11/2026, a pedido do autor, a seção foi enxugada para o artigo caber em 8 páginas, sem tirar estudos nem ferramentas: os parágrafos ficaram mais curtos, e saíram a lista do que cada subseção trata, a origem das lesões, alguns números dos estudos (os 353 adultos de Bodien et al. e os 11 controles de Trojano et al.), o motivo da escolha de cada ferramenta e a conformidade do Cognitive3D com o GDPR, com a referência [COG3D-DPA]. Em 12/11/2026, a pedido do autor, o artigo foi reduzido para 6 páginas, como o modelo de 2026 (a Resolução nº 01/25 do curso recomenda de 6 a 8). Nesta seção saíram a descrição do coma, que a Introdução já define, a revisão de escopo de Bagnato et al. [BAGNATO], a frase sobre computação afetiva [PICARD], os estímulos usados por Hyun et al. e a repetição dos critérios da Tabela 1 no parágrafo final; os demais parágrafos ficaram mais curtos. A Tabela 1 passou a vir logo depois do parágrafo de abertura da Subseção D: no LaTeX, a tabela larga só sai no alto da página seguinte à do ponto em que é definida, e a Tabela 2 não pode sair antes dela; definida mais cedo, a Tabela 1 fica no alto da página 6, e a Tabela 2 volta a ficar logo abaixo do título da Subseção III.B.

## Como usar este arquivo

- **Citações:** as mesmas convenções das outras seções, com chaves entre colchetes. A numeração final é a do artigo montado, impressa pelo script.
- **Tabela:** a comparação da Subseção D é a Tabela 1 do artigo. Por isso, a tabela das tecnologias, na Seção III, é a Tabela 2.
- **Siglas:** DoC, SVNR, EMC, CRS-R, FACS, LGPD e IC já foram definidas na Introdução. RV é definida aqui; CEP, na Seção III.

---

## II. REVISÃO DE LITERATURA

Esta seção reúne os conceitos e os estudos que fundamentam o NeuroSight e os trabalhos semelhantes ao proposto.

### A. Distúrbios da Consciência e Avaliação Clínica

Na SVNR, o ciclo de sono e vigília retorna, mas não há sinais de percepção de si ou do ambiente [LAUREYS]; no EMC, surgem sinais de consciência mínimos e flutuantes, porém reproduzíveis, como acompanhar um objeto com os olhos ou cumprir uma ordem simples [GIACINO2002].

A CRS-R, um dos instrumentos padronizados mais utilizados para distinguir esses estados, examina a audição, a visão, a motricidade, as funções oromotoras e verbais, a comunicação e o nível de alerta [GIACINO2004]. O resultado, porém, depende da interpretação do examinador e de respostas que podem faltar por paralisia, espasticidade, déficits sensoriais ou oscilações do alerta. Schnakers et al. [SCHNAKERS] verificaram que 18 dos 44 pacientes (41%) classificados em estado vegetativo pelo consenso da equipe médica estavam em EMC segundo a CRS-R, erro que, segundo os autores, pode ter consequências graves em decisões de fim de vida. Bodien et al. [BODIEN] identificaram a dissociação cognitivo-motora, em que o paciente executa tarefas mentais sem nenhuma resposta comportamental, em 25% dos 241 participantes sem resposta a comandos, com ressonância magnética funcional e eletroencefalografia, exames de alto custo e ainda pouco disponíveis.

### B. Rastreamento Ocular e Expressões Faciais

À beira do leito, o examinador move um objeto diante do paciente e decide, a olho nu, se os olhos o acompanharam, e movimentos pequenos, lentos ou inconsistentes podem passar despercebidos. Com rastreamento ocular e estímulos em movimento lento em um monitor, Trojano et al. [TROJANO] registraram fixações sobre o alvo no nível do acaso, ou abaixo dele, nos 9 pacientes em estado vegetativo e acima do acaso em 7 dos 9 pacientes em EMC. Com um rastreador vestível em 12 pacientes com DoC prolongado, Johansson et al. [JOHANSSON] classificaram como resposta 46,2% das tentativas em quatro itens da CRS-R, contra 18,1% na avaliação clínica feita ao mesmo tempo. Uma revisão sistemática com 15 estudos concluiu que o rastreamento ocular detecta mais respostas do que a observação clínica, embora a certeza da evidência ainda seja baixa, e o recomendou como complemento à CRS-R [ESTRANEO].

O tipo de estímulo também interfere na resposta: na revisão sistemática de Magliacano et al. [MAGLIACANO], a maior parte dos estudos indicou que estímulos com significado pessoal, como rostos e vozes de familiares e o próprio nome, tendem a provocar mais respostas comportamentais e eletrofisiológicas do que estímulos neutros, embora a qualidade das evidências seja baixa. Isso reforça o interesse em observar também a reação emocional do paciente, que o FACS descreve de forma objetiva ao decompor o rosto em unidades de ação associadas aos músculos faciais [EKMAN].

### C. Realidade Virtual e Meta Quest Pro

A realidade virtual (RV) oferece um meio controlado para apresentar esses estímulos: nos óculos, a cena, gerada por computador, ocupa o campo de visão e se repete da mesma forma entre participantes, o que ajuda a padronizar as sessões [CLAY]. Hyun et al. [HYUN] combinaram RV e rastreamento ocular na avaliação de 5 pacientes crônicos em estado vegetativo e detectaram fixação em três deles, o que a avaliação clínica não havia verificado.

No Meta Quest Pro, câmeras internas convertem os movimentos do rosto em valores de expressões baseadas no FACS [META-MOVE]; as imagens são processadas no próprio óculos e descartadas, e o aplicativo recebe apenas esses valores [META-FACE-PRIV].

### D. Trabalhos Semelhantes

Os estudos da Subseção B usaram instrumentos montados para cada pesquisa, sem uma ferramenta que organizasse o experimento do cadastro do paciente à análise. Entre as ferramentas para pesquisas com rastreamento ocular, foram analisadas, pela documentação oficial consultada em outubro de 2026, as três mais próximas do sistema proposto: o iMotions, o SightLab VR Pro e o Cognitive3D.

**TABELA 1** - Comparação entre as ferramentas semelhantes e o NeuroSight

| Ferramenta | Licença | Olhar no Meta Quest Pro | Expressões faciais | Sequência de estímulos com tempo | Dados de vários grupos, com papéis | Registro de auditoria |
|---|---|---|---|---|---|---|
| iMotions | Comercial | Só por importação | Pela *webcam* | Sim | Não (dados locais) | Não encontrado |
| SightLab VR Pro | Comercial | Sim | Valores do óculos | Sim | Não (dados locais) | Não encontrado |
| Cognitive3D | Assinatura | Sim (em fim de vida) | Não encontrado | Não encontrado | Sim | Só no plano Enterprise |
| NeuroSight | A definir | Sim | Valores do óculos | Sim | Sim | Sim |

FONTE: Os autores (2026), com base na documentação das ferramentas

O iMotions é uma plataforma comercial [IMOTIONS-PRICE] que analisa expressões faciais pela *webcam* ou por vídeo [IMOTIONS-FEA] e permite definir a ordem e a duração dos estímulos [IMOTIONS-SB]. Desde 2026, aceita o Meta Quest Pro, mas apenas pela importação de arquivos gravados no óculos, sem menção ao rastreamento facial do equipamento [IMOTIONS-NEWS]. Os dados ficam no computador do experimento, e o cumprimento do regulamento europeu de proteção de dados (GDPR) cabe ao cliente [IMOTIONS-TOS].

O SightLab VR Pro, da WorldViz, é um complemento comercial do ambiente Vizard para experimentos em RV [SIGHTLAB], [WORLDVIZ-PRICE] e a ferramenta mais próxima do NeuroSight no óculos: lê o olhar e os parâmetros de expressão facial do Meta Quest Pro [SIGHTLAB-FACE], apresenta sequências de imagens e vídeos com troca por tempo [SIGHTLAB-MEDIA] e gera mapas de calor e reproduções das sessões [SIGHTLAB]. Os dados, porém, ficam no computador do experimento, e não foram encontrados recursos de contas por grupo de pesquisa nem de proteção de dados. O Cognitive3D, plataforma de análise para RV vendida por assinatura [COG3D-PRICING], reproduz as sessões em 3D, com o trajeto do olhar e mapas de calor, e organiza os dados em organizações, projetos e participantes, com papéis de acesso [COG3D-CONCEPTS]. Lê o olhar do Meta Quest Pro, embora a documentação liste o aparelho entre os dispositivos em fim de vida [COG3D-HARDWARE], e oferece registro de auditoria no plano mais caro [COG3D-PRICING], mas não foram encontrados recursos para montar a sequência de estímulos nem suporte às expressões faciais. A Tabela 1 resume a comparação.

Nenhuma das ferramentas reúne todos esses recursos, e não foram encontradas funções voltadas a pacientes com DoC, como estímulos pessoais vinculados a cada paciente; essa lacuna motiva o desenvolvimento do NeuroSight.

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
- **[COG3D-HARDWARE]** COGNITIVE3D. *Supported Hardware*: Cognitive3D documentation. Disponível em: https://docs.cognitive3d.com/hardware/. Acesso em: 2 nov. 2026.

**Referências que deixaram de ser citadas em 12/11/2026:** [BAGNATO] e [PICARD], no corte para 6 páginas. As entradas continuam na lista acima, e o script de montagem as ignora.

**Referência retirada em 10/11/2026** (a frase sobre a conformidade do Cognitive3D com o GDPR saiu no corte para 8 páginas; não é mais citada, e o script de montagem a ignora)

- **[COG3D-DPA]** COGNITIVE3D. *Data Processing Addendum*. Disponível em: https://cognitive3d.com/dpa/. Acesso em: 26 out. 2026.

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
4. **Tamanho:** depois do corte de 12/11/2026, a seção tem cerca de 880 palavras de texto, fora a Tabela 1, e 14 referências novas (eram cerca de 1.170 palavras e 16 referências depois do corte de 10/11/2026, e cerca de 1.500 e 17 antes dele). O artigo inteiro tem de caber em 6 páginas: ver o item "Tamanho do artigo" no arquivo da Seção III.
