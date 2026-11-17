# Resumo e Abstract

Versão de trabalho de 26/10/2026, revista em 03/11/2026 e em 09/11/2026 (cortes pequenos para o Resumo, o Abstract e as palavras-chave caberem na primeira coluna da página). Escritos depois das Seções I a IV, no formato do modelo de 2026 (`Referencias-e-modelos/TCC_Artigo_Modelo_2026.pdf`): parágrafo único com objetivo, método, tecnologias e resultado, seguido de cinco palavras-chave, como no modelo. O script de montagem do artigo lê as quatro linhas abaixo e as coloca no início do artigo. Em 12/11/2026, no corte do artigo para 6 páginas, o Resumo e o Abstract ficaram com cerca de 150 palavras, como os do modelo: saíram a lista das etapas do experimento, a menção ao protótipo da Iniciação Científica, a remissão à especificação técnica e a frase final sobre o diagnóstico, que continua na Introdução e nas Considerações Finais.

## Como usar este arquivo

- **Edição:** mantenha cada item numa linha só, começando por "**Resumo:**", "**Palavras-chave:**", "**Abstract:**" e "**Keywords:**". É assim que o script os encontra.
- **Tamanho:** o Resumo do modelo de 2026 tem cerca de 150 palavras; desde 12/11/2026, este tem cerca de 155, e o Abstract, cerca de 145 (tinham cerca de 220 e 205).
- **Citações e siglas:** como no exemplo, o Resumo e o Abstract não citam referências. A única sigla que aparece sem explicação é UML, ao lado de BPMN, que são nomes de notações.

---

**Resumo:** O diagnóstico do nível de consciência em pessoas com distúrbios da consciência depende de respostas comportamentais que muitos pacientes não conseguem produzir. Experimentos que registram o olhar e as expressões faciais desses pacientes diante de estímulos controlados ajudam a medir essas respostas, mas dependem de ferramentas isoladas e de transferências manuais de arquivos. O objetivo deste trabalho é modelar e desenvolver o NeuroSight, um sistema de apoio à pesquisa que reúne as etapas desses experimentos em realidade virtual, do cadastro de pacientes e de estímulos à coleta no Meta Quest Pro e à análise dos dados. Nesta primeira etapa, conduzida com o Scrum, foram levantados os requisitos, elaborados os modelos em UML e BPMN e os protótipos de tela e definida a arquitetura: um aplicativo em Unreal Engine, um servidor em NestJS, um sistema web em Next.js e um banco PostgreSQL compartilhado por vários grupos de pesquisa, com isolamento dos dados, controle de acesso e auditoria.

**Palavras-chave:** Distúrbios da consciência; Rastreamento ocular; Expressões faciais; Realidade virtual; Meta Quest Pro.

**Abstract:** The diagnosis of the level of consciousness in people with disorders of consciousness depends on behavioral responses that many patients cannot produce. Experiments that record these patients' gaze and facial expressions in response to controlled stimuli help to measure such responses, but they rely on isolated tools and manual file transfers. The objective of this work is to model and develop NeuroSight, a research support system that brings together the steps of these virtual reality experiments, from registering patients and stimuli to data collection with the Meta Quest Pro and data analysis. In this first stage, carried out with Scrum, the requirements were gathered, the UML and BPMN models and the screen prototypes were produced, and the architecture was defined: an Unreal Engine application, a NestJS server, a Next.js web system, and a PostgreSQL database shared by multiple research groups, with data isolation, access control, and auditing.

**Keywords:** Disorders of consciousness; Eye tracking; Facial expressions; Virtual reality; Meta Quest Pro.

---

## O que conferir

1. **Resultado do TCC1:** o Resumo apresenta como resultado a modelagem (requisitos, modelos, protótipos e arquitetura). No TCC2, troque esse trecho pelo sistema implementado e pelos testes.
2. **Palavras-chave:** se o orientador pedir descritores padronizados da área da saúde, confira os termos no DeCS (Descritores em Ciências da Saúde).
3. **Abstract:** é a tradução do Resumo, frase a frase. Se mudar o Resumo, ajuste o Abstract também.
