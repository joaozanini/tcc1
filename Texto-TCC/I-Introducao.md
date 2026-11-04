# I. Introdução

Versão de trabalho de 26/10/2026, revista em 03/11/2026. Texto escrito a partir do 1.1 e no formato da Introdução do modelo de 2026 (`Referencias-e-modelos/TCC_Artigo_Modelo_2026.pdf`), sem subseções: contexto, problema, objetivo e organização do documento. O detalhamento do 1.1 (escalas, estudos com rastreamento ocular, estímulos pessoais, computação afetiva) fica para a Seção II.

## Como usar este arquivo

- **Citações:** as mesmas convenções das Seções III e IV, com chaves entre colchetes. Como esta é a primeira seção com citações, a numeração final começa aqui (tabela no fim do arquivo).
- **Siglas:** DoC, SVNR, EMC, CRS-R, FACS, LGPD e IC são definidas aqui, na primeira ocorrência.
- **Tempo verbal:** o problema e o contexto estão no presente; o objetivo, no infinitivo ("modelar e desenvolver"), valendo para o TCC1 e o TCC2.

---

## I. INTRODUÇÃO

Os distúrbios da consciência (DoC, do inglês *disorders of consciousness*) são condições em que a pessoa, após uma lesão cerebral grave, perde total ou parcialmente a capacidade de estar desperta e de perceber a si mesma e o ambiente. O grupo inclui o coma, a síndrome da vigília não responsiva (SVNR), antes chamada de estado vegetativo, e o estado minimamente consciente (EMC) [LAUREYS], [GIACINO2002]. Na prática clínica, a distinção entre esses estados depende da observação de respostas comportamentais à beira do leito, feita com escalas padronizadas como a *Coma Recovery Scale-Revised* (CRS-R) [GIACINO2004]. Muitos pacientes, porém, não conseguem produzir essas respostas por motivos alheios à consciência, como paralisia ou déficits sensoriais, e o erro de diagnóstico é frequente: em um estudo com 103 pacientes, 41% dos que haviam sido classificados em estado vegetativo pelo consenso da equipe médica estavam, na verdade, em EMC [SCHNAKERS]. Há ainda pacientes sem nenhuma resposta comportamental que conseguem executar tarefas mentais quando solicitados, o que só foi detectado com exames de alto custo, como a ressonância magnética funcional e a eletroencefalografia [BODIEN].

O comportamento visual tem peso particular nessa avaliação: a fixação sustentada e a perseguição visual estão entre os sinais que caracterizam o EMC [GIACINO2002], mas, à beira do leito, são julgadas a olho nu e não deixam registro que possa ser revisto. O rastreamento ocular (*eye tracking*) permite medir esses comportamentos de forma objetiva [TROJANO]. As expressões faciais, por sua vez, podem ser descritas pelo *Facial Action Coding System* (FACS) [EKMAN] e ajudam a observar a reação do paciente a estímulos com significado pessoal, como rostos e vozes de familiares, que tendem a provocar mais respostas do que estímulos neutros [MAGLIACANO]. A realidade virtual oferece um meio controlado e reproduzível para apresentar esses estímulos [CLAY], e óculos como o Meta Quest Pro reúnem no mesmo equipamento a exibição das imagens e o rastreamento do olhar e das expressões faciais [META-MOVE].

O equipamento, porém, resolve apenas parte da questão. Para conduzir esses experimentos, o pesquisador precisa preparar os estímulos de cada paciente, controlar o momento em que cada um é exibido, associar os dados do olhar e das expressões ao estímulo apresentado em cada instante e guardar tudo vinculado ao paciente e à sessão corretos. Sem uma ferramenta que integre essas etapas, o trabalho se divide entre aplicativos isolados, *scripts* e transferência manual de arquivos, situação observada também no desenvolvimento do protótipo que deu origem a este trabalho, em que as sessões ficavam como arquivos locais, sem catalogação [IC]. Isso aumenta o risco de perda ou troca de dados, dificulta a repetição do mesmo protocolo entre sessões e pacientes e torna a análise mais demorada. Há também a questão da proteção dos dados: informações de saúde são dados pessoais sensíveis segundo a Lei Geral de Proteção de Dados Pessoais (LGPD) [LGPD], e os participantes desses estudos, pela própria condição, não conseguem consentir nem acompanhar o uso das suas informações. Por isso, o acesso às sessões precisa ser controlado, e as ações realizadas no sistema, registradas.

Diante desse cenário, o objetivo deste trabalho é modelar e desenvolver o NeuroSight, um sistema de apoio à pesquisa que reúne em uma única ferramenta as etapas de experimentos em realidade virtual com pessoas com DoC: o cadastro dos pacientes, a preparação dos estímulos, a configuração e o início das sessões, a coleta do olhar e das expressões faciais no Meta Quest Pro, o armazenamento dos dados e a sua análise. O sistema é formado por um aplicativo para o óculos, um sistema web e um servidor, e uma mesma instalação atende a diferentes grupos de pesquisa, com os dados de cada um isolados dos demais. O trabalho parte do protótipo de rastreamento ocular em realidade virtual desenvolvido por um dos autores em seu projeto de Iniciação Científica (IC) [IC]. O NeuroSight não faz diagnóstico nem substitui a avaliação clínica: ele organiza a realização dos experimentos e o registro dos dados para que os pesquisadores possam analisá-los.

Este artigo apresenta a primeira etapa do trabalho, dedicada à modelagem do sistema; a implementação será realizada na segunda etapa. A Seção II apresenta a revisão de literatura e os trabalhos semelhantes ao proposto; a Seção III descreve o método de trabalho, as tecnologias escolhidas, a arquitetura proposta e as regras de negócio do sistema; e a Seção IV traz as considerações finais. Os artefatos da modelagem, como os diagramas de casos de uso, as histórias de usuário, o diagrama de classes, o modelo do banco de dados e os protótipos das telas, estão na Especificação Técnica que acompanha este artigo.

---

## Referências citadas nesta seção

Como a Introdução é a primeira seção com citações, a numeração final destas referências já pode ser fixada. As obras sem lista aqui estão na Seção III: [EKMAN], [LGPD], [META-MOVE] e [IC].

| Chave | Número | Onde está a referência completa |
|---|---|---|
| [LAUREYS] | [1] | Abaixo |
| [GIACINO2002] | [2] | Abaixo |
| [GIACINO2004] | [3] | Abaixo |
| [SCHNAKERS] | [4] | Abaixo |
| [BODIEN] | [5] | Abaixo |
| [TROJANO] | [6] | Abaixo |
| [EKMAN] | [7] | [III-Metodo-tecnologias-e-arquitetura.md](III-Metodo-tecnologias-e-arquitetura.md) |
| [MAGLIACANO] | [8] | Abaixo |
| [CLAY] | [9] | Abaixo |
| [META-MOVE] | [10] | [III-Metodo-tecnologias-e-arquitetura.md](III-Metodo-tecnologias-e-arquitetura.md) |
| [IC] | [11] | [III-Metodo-tecnologias-e-arquitetura.md](III-Metodo-tecnologias-e-arquitetura.md) |
| [LGPD] | [12] | [III-Metodo-tecnologias-e-arquitetura.md](III-Metodo-tecnologias-e-arquitetura.md) |

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
2. **Organização do documento:** o último parágrafo cita as Seções II a IV e remete a modelagem à Especificação Técnica, o segundo documento da entrega (03/11/2026).
3. **Afirmação sobre a IC:** o texto usa o relatório da IC para mostrar que as sessões ficavam como arquivos locais. Confirme que você concorda com essa leitura.
4. **Tamanho:** são cerca de 700 palavras, um pouco mais que a Introdução do modelo de 2026, que tem cerca de 500.
