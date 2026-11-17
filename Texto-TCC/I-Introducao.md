# I. Introdução

Versão de trabalho de 26/10/2026, revista em 03/11/2026. Texto escrito a partir do 1.1 e no formato da Introdução do modelo de 2026 (`Referencias-e-modelos/TCC_Artigo_Modelo_2026.pdf`), sem subseções: contexto, problema, objetivo e organização do documento. O detalhamento do 1.1 (escalas, estudos com rastreamento ocular, estímulos pessoais, computação afetiva) fica para a Seção II. Em 05/11/2026, por observação do orientador, a descrição de como os experimentos são conduzidos hoje (antiga Subseção II.E) foi adaptada e entrou no terceiro e no quarto parágrafos. Em 10/11/2026, a pedido do autor, o texto foi enxugado para o artigo caber em 8 páginas: saíram os detalhes que a Seção II repete (do estudo de Schnakers et al. ficaram só os 41%), a frase sobre o reaproveitamento do protótipo da IC, que está na Subseção III.A, e o roteiro das Seções II a IV, que o modelo de 2026 também não tem; o último parágrafo ficou com a etapa do trabalho e a remissão à Especificação Técnica. Em 12/11/2026, a pedido do autor, o artigo foi reduzido para 6 páginas, como o modelo de 2026 (a Resolução nº 01/25 do curso recomenda de 6 a 8): a frase sobre a dissociação cognitivo-motora (Bodien et al.) saiu daqui, porque a Subseção II.A a traz com os números, e os parágrafos ficaram mais curtos, sem tirar estudos.

## Como usar este arquivo

- **Citações:** as mesmas convenções das Seções III e IV, com chaves entre colchetes. Como esta é a primeira seção com citações, a numeração final começa aqui (tabela no fim do arquivo).
- **Siglas:** DoC, SVNR, EMC, CRS-R, FACS, LGPD e IC são definidas aqui, na primeira ocorrência.
- **Tempo verbal:** o problema e o contexto estão no presente; o objetivo, no infinitivo ("modelar e desenvolver"), valendo para o TCC1 e o TCC2.

---

## I. INTRODUÇÃO

Os distúrbios da consciência (DoC, do inglês *disorders of consciousness*) são condições em que a pessoa, após uma lesão cerebral grave, perde total ou parcialmente a capacidade de estar desperta e de perceber a si mesma e o ambiente. O grupo inclui o coma, a síndrome da vigília não responsiva (SVNR), antes chamada de estado vegetativo, e o estado minimamente consciente (EMC) [LAUREYS], [GIACINO2002], distinguidos pela observação de respostas comportamentais à beira do leito, com escalas padronizadas como a *Coma Recovery Scale-Revised* (CRS-R) [GIACINO2004]. Muitos pacientes, porém, não conseguem produzir essas respostas por motivos alheios à consciência, como paralisia ou déficits sensoriais, e o erro de diagnóstico é frequente: em um estudo, 41% dos pacientes classificados em estado vegetativo pela equipe médica estavam em EMC [SCHNAKERS].

O comportamento visual tem peso particular nessa avaliação: a fixação sustentada e a perseguição visual estão entre os sinais que caracterizam o EMC [GIACINO2002], mas são julgadas a olho nu e não deixam registro. O rastreamento ocular (*eye tracking*) mede esses comportamentos de forma objetiva [TROJANO], e as expressões faciais, descritas pelo *Facial Action Coding System* (FACS) [EKMAN], ajudam a observar a reação a estímulos com significado pessoal, que tendem a provocar mais respostas do que estímulos neutros [MAGLIACANO]. Óculos de realidade virtual como o Meta Quest Pro apresentam esses estímulos de forma controlada e reproduzível [CLAY] e rastreiam, no mesmo equipamento, o olhar e as expressões faciais [META-MOVE].

O equipamento, porém, resolve apenas parte da questão. Nos estudos com esses pacientes, o pesquisador escolhe estímulos que testam a fixação e a perseguição visual, muitas vezes inspirados nos itens da CRS-R [JOHANSSON], [HYUN]; apresenta-os em um monitor [TROJANO], com objetos reais e um rastreador vestível [JOHANSSON] ou em um aplicativo de realidade virtual feito para o estudo [HYUN]; e revê as gravações do olhar depois, em outro programa [TROJANO], [JOHANSSON]. No protótipo de rastreamento ocular em realidade virtual desenvolvido por um dos autores em seu projeto de Iniciação Científica (IC), que deu origem a este trabalho, a sessão era aberta e encerrada no próprio óculos, os dados seguiam para o servidor pela rede ou, sem ela, por cabo, e não havia cadastro de pacientes nem de estímulos [IC].

Nos dois casos, as etapas dependem de programas diferentes e de transferências manuais de arquivos, e cabe ao pesquisador preparar os estímulos, controlar a exibição, associar os dados ao estímulo de cada instante e guardar tudo vinculado ao paciente e à sessão corretos, o que aumenta o risco de perda ou troca de dados e dificulta a repetição do protocolo. Além disso, dados de saúde são dados pessoais sensíveis segundo a Lei Geral de Proteção de Dados Pessoais (LGPD) [LGPD], e esses participantes não conseguem consentir nem acompanhar o uso das suas informações, o que exige controle de acesso e registro das ações.

Diante desse cenário, o objetivo deste trabalho é modelar e desenvolver o NeuroSight, um sistema de apoio à pesquisa que reúne em uma única ferramenta as etapas de experimentos em realidade virtual com pessoas com DoC, do cadastro dos pacientes e dos estímulos à coleta do olhar e das expressões faciais no Meta Quest Pro e à análise dos dados. O sistema é formado por um aplicativo para o óculos, um sistema web e um servidor que atende a vários grupos de pesquisa, com os dados de cada um isolados. O NeuroSight não faz diagnóstico nem substitui a avaliação clínica.

Este artigo apresenta a primeira etapa do trabalho, dedicada à modelagem; a implementação será realizada na segunda. Os artefatos da modelagem, como os diagramas, as histórias de usuário e os protótipos de tela, estão na Especificação Técnica que acompanha este artigo.

---

## Referências citadas nesta seção

A numeração final é dada pelo script de montagem, na ordem da primeira citação, e começa aqui. As obras citadas nesta seção e listadas em outro arquivo são [EKMAN], [META-MOVE], [IC] e [LGPD], na Seção III, e [JOHANSSON] e [HYUN], na Seção II (também listadas abaixo, em "Obras do 1.1").

- **[LAUREYS]** LAUREYS, S. *et al*. Unresponsive wakefulness syndrome: a new name for the vegetative state or apallic syndrome. *BMC Medicine*, v. 8, art. 68, 2010. DOI: 10.1186/1741-7015-8-68.
- **[GIACINO2002]** GIACINO, J. T. *et al*. The minimally conscious state: definition and diagnostic criteria. *Neurology*, v. 58, n. 3, p. 349-353, 2002. DOI: 10.1212/WNL.58.3.349.
- **[GIACINO2004]** GIACINO, J. T.; KALMAR, K.; WHYTE, J. The JFK Coma Recovery Scale-Revised: measurement characteristics and diagnostic utility. *Archives of Physical Medicine and Rehabilitation*, v. 85, n. 12, p. 2020-2029, 2004. DOI: 10.1016/j.apmr.2004.02.033.
- **[SCHNAKERS]** SCHNAKERS, C. *et al*. Diagnostic accuracy of the vegetative and minimally conscious state: clinical consensus versus standardized neurobehavioral assessment. *BMC Neurology*, v. 9, art. 35, 2009. DOI: 10.1186/1471-2377-9-35.
- **[BODIEN]** BODIEN, Y. G. *et al*. Cognitive motor dissociation in disorders of consciousness. *New England Journal of Medicine*, v. 391, n. 7, p. 598-608, 2024. DOI: 10.1056/NEJMoa2400645.
- **[TROJANO]** TROJANO, L. *et al*. Quantitative assessment of visual behavior in disorders of consciousness. *Journal of Neurology*, v. 259, n. 9, p. 1888-1895, 2012. DOI: 10.1007/s00415-012-6435-4.
- **[MAGLIACANO]** MAGLIACANO, A. *et al*. Can salient stimuli enhance responses in disorders of consciousness? A systematic review. *Current Neurology and Neuroscience Reports*, v. 19, n. 12, art. 98, 2019. DOI: 10.1007/s11910-019-1018-8.
- **[CLAY]** CLAY, V.; KÖNIG, P.; KÖNIG, S. U. Eye tracking in virtual reality. *Journal of Eye Movement Research*, v. 12, n. 1, 2019. DOI: 10.16910/jemr.12.1.3.

Os dados de todas essas obras foram conferidos no Crossref em 26/10/2026.

## Obras do 1.1 que ficam para a Seção II

Também conferidas no Crossref, para já entrarem na lista quando a Seção II for escrita:

- **[JOHANSSON]** JOHANSSON, J. *et al*. Eye tracking to support assessment of patients with prolonged disorder of consciousness: a case series. *Journal of Rehabilitation Medicine*, v. 57, art. jrm41324, 2025. DOI: 10.2340/jrm.v57.41324.
- **[HYUN]** HYUN, C. *et al*. Quantitative evaluation of the consciousness level of patients in a vegetative state using virtual reality and an eye-tracking system: a single-case experimental design study. *Neuropsychological Rehabilitation*, v. 32, n. 10, p. 2628-2645, 2022. DOI: 10.1080/09602011.2021.1974496.
- **[PICARD]** PICARD, R. W. *Affective computing*. Cambridge: MIT Press, 1997. DOI: 10.7551/mitpress/1140.001.0001.
- **"Meta, [202-]" do 1.2:** pode virar a mesma referência [META-MOVE] da Seção III.

Na busca, apareceram duas revisões recentes que podem servir à Seção II: uma revisão sistemática sobre rastreamento ocular na avaliação de DoC (ESTRANEO *et al*., *Brain Sciences*, 2026, DOI: 10.3390/brainsci16060590) e uma revisão de escopo sobre movimentos oculares como sinal de consciência (BAGNATO *et al*., *Neurological Sciences*, 2026, DOI: 10.1007/s10072-026-08932-6). Vale ler antes de citar.

## O que conferir antes de passar para o modelo

1. **Frase de objetivo:** "modelar e desenvolver" vale para o TCC1 e o TCC2. Se o orientador preferir um objetivo só do TCC1, troque por "modelar".
2. **Organização do documento:** o último parágrafo diz que o artigo apresenta a etapa de modelagem e remete os artefatos à Especificação Técnica, o segundo documento da entrega (03/11/2026). O roteiro das Seções II a IV saiu em 10/11/2026, no corte para 8 páginas.
3. **Afirmação sobre a IC:** o texto usa o relatório da IC para mostrar que as sessões ficavam como arquivos locais. Confirme que você concorda com essa leitura.
4. **Tamanho:** são cerca de 610 palavras (eram cerca de 940 antes do corte de 10/11/2026 e 780 antes do de 12/11/2026), ainda mais que a Introdução do modelo de 2026, que tem cerca de 500; a diferença vem do fluxo atual dos experimentos, que o orientador pediu para trazer para cá (05/11/2026). O artigo inteiro tem de caber em 6 páginas: ver o item "Tamanho do artigo" no arquivo da Seção III.
