# Resumo e Abstract

Versão de trabalho de 26/10/2026. Escritos depois das Seções I a IV.A, como prevê o checklist, no formato do exemplo: parágrafo único com objetivo, método, tecnologias e resultado, seguido de quatro palavras-chave. O script de montagem do artigo lê as quatro linhas abaixo e as coloca no início do artigo.

## Como usar este arquivo

- **Edição:** mantenha cada item numa linha só, começando por "**Resumo:**", "**Palavras-chave:**", "**Abstract:**" e "**Keywords:**". É assim que o script os encontra.
- **Tamanho:** o Resumo do exemplo tem cerca de 170 palavras; este tem cerca de 210, e o Abstract, cerca de 195.
- **Citações e siglas:** como no exemplo, o Resumo e o Abstract não citam referências. A única sigla que aparece sem explicação é UML, ao lado de BPMN, que são nomes de notações.

---

**Resumo:** O diagnóstico do nível de consciência em pessoas com distúrbios da consciência depende da observação de respostas comportamentais que muitos pacientes não conseguem produzir. Experimentos que registram o olhar e as expressões faciais desses pacientes diante de estímulos controlados ajudam a medir essas respostas, mas costumam depender de ferramentas isoladas e de transferência manual de arquivos. O objetivo deste trabalho é modelar e desenvolver o NeuroSight, um sistema de apoio à pesquisa que reúne as etapas desses experimentos em realidade virtual: o cadastro de pacientes e de estímulos, a configuração e o início das sessões, a coleta do olhar e das expressões faciais no Meta Quest Pro, o armazenamento dos dados e a sua análise. O trabalho parte de um protótipo de rastreamento ocular desenvolvido em Iniciação Científica e segue o Scrum adaptado a uma equipe de dois integrantes. Nesta primeira etapa, foram levantados os requisitos e elaborados os modelos em UML e BPMN, os protótipos das telas e a arquitetura do sistema, formada por um aplicativo em Unreal Engine, um servidor em NestJS, um sistema web em Next.js e um banco de dados PostgreSQL compartilhado por vários grupos de pesquisa, com isolamento dos dados, controle de acesso e auditoria. O sistema não faz diagnóstico: organiza os experimentos e o registro dos dados para a análise dos pesquisadores.

**Palavras-chave:** Distúrbios da consciência; Rastreamento ocular; Realidade virtual; Expressões faciais.

**Abstract:** The diagnosis of the level of consciousness in people with disorders of consciousness depends on observing behavioral responses that many patients cannot produce. Experiments that record these patients' gaze and facial expressions in response to controlled stimuli help to measure such responses, but they usually rely on isolated tools and manual file transfers. The objective of this work is to model and develop NeuroSight, a research support system that brings together the steps of these virtual reality experiments: registering patients and stimuli, configuring and starting sessions, collecting gaze and facial expression data with the Meta Quest Pro, storing the data, and analyzing it. The work builds on an eye-tracking prototype developed in an undergraduate research project and follows Scrum adapted to a two-person team. In this first stage, the requirements were gathered, and the UML and BPMN models, the screen prototypes, and the system architecture were produced. The architecture consists of an Unreal Engine application, a NestJS server, a Next.js web system, and a PostgreSQL database shared by multiple research groups, with data isolation, access control, and auditing. The system does not perform diagnosis: it organizes the experiments and the data recording for the researchers' analysis.

**Keywords:** Disorders of consciousness; Eye tracking; Virtual reality; Facial expressions.

---

## O que conferir

1. **Resultado do TCC1:** o Resumo apresenta como resultado a modelagem (requisitos, modelos, protótipos e arquitetura). No TCC2, troque esse trecho pelo sistema implementado e pelos testes.
2. **Palavras-chave:** se o orientador pedir descritores padronizados da área da saúde, confira os termos no DeCS (Descritores em Ciências da Saúde).
3. **Abstract:** é a tradução do Resumo, frase a frase. Se mudar o Resumo, ajuste o Abstract também.
