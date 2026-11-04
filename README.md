# NeuroSight – TCC1

Sistema de rastreamento ocular e emocional em realidade virtual para estudo e apoio ao diagnóstico de pessoas com distúrbios da consciência. Trabalho de Conclusão de Curso de João Vitor Zanini Pedro e Lucas Sarnacki Guiraud, orientado pelo Prof. Dr. Alessandro Brawerman, no curso de Tecnologia em Análise e Desenvolvimento de Sistemas da Universidade Federal do Paraná (2026).

Este repositório é a documentação completa citada na nota 2 da Seção III do artigo. A entrega do TCC1 (etapa de modelagem) são dois documentos, cada um no modelo do curso: o **artigo** e a **Especificação Técnica**. O desenvolvimento do sistema é o TCC2.

## Onde está cada coisa

- [Texto-TCC/TCC1-NeuroSight.pdf](Texto-TCC/TCC1-NeuroSight.pdf): o artigo do TCC1 no modelo do curso (I. Introdução; II. Revisão de Literatura; III. Método, Tecnologias e Arquitetura; IV. Considerações Finais; Referências). As fontes do texto estão nos `.md` de `Texto-TCC/`, e os scripts da mesma pasta geram o LaTeX (`Texto-TCC/LaTeX/`), o pacote para o Overleaf e a versão em Word.
- [Especificacao-Tecnica/Especificacao-Tecnica-NeuroSight.pdf](Especificacao-Tecnica/Especificacao-Tecnica-NeuroSight.pdf) (e o `.docx` de mesmo nome): a Especificação Técnica do sistema, no template do curso, com a contextualização, as referências e os apêndices A (diagramas de casos de uso), B (diagrama de classes), C (histórias de usuário, protótipos de tela e diagramas de sequência, caso de uso por caso de uso), D (modelo lógico do banco de dados e dicionário de dados), E (rotas da API), F (modelos de IA: não se aplica), G (requisitos), H (diagrama de estados da sessão) e I (processos de negócio em BPMN). É gerada da pasta `Especificacao` por `montar-especificacao.pl` e `gerar-especificacao-docx.ps1`.
- [Especificacao/](Especificacao/): os artefatos de modelagem, a fonte de tudo. Cada diagrama tem um `.drawio`, que abre no [draw.io](https://www.drawio.com/) ou em app.diagrams.net, e um `.md` que o descreve.
  - [Requisitos-NeuroSight.md](Especificacao/Requisitos-NeuroSight.md): requisitos funcionais, regras de negócio e requisitos não funcionais.
  - [Decisoes-tecnicas-NeuroSight.md](Especificacao/Decisoes-tecnicas-NeuroSight.md): tecnologias escolhidas e os motivos.
  - [Casos-de-uso-NeuroSight.drawio](Especificacao/Casos-de-uso-NeuroSight.drawio) e [Casos-de-uso-e-historias-NeuroSight.md](Especificacao/Casos-de-uso-e-historias-NeuroSight.md): 12 diagramas de casos de uso e as histórias de usuário, com rastreabilidade para os requisitos.
  - [Diagrama-de-classes-NeuroSight.drawio](Especificacao/Diagrama-de-classes-NeuroSight.drawio) e [Diagrama-de-classes-NeuroSight.md](Especificacao/Diagrama-de-classes-NeuroSight.md): modelo de domínio e enumerações.
  - [Diagrama-de-estados-da-sessao.drawio](Especificacao/Diagrama-de-estados-da-sessao.drawio) e [Diagrama-de-estados-da-sessao.md](Especificacao/Diagrama-de-estados-da-sessao.md): estados da sessão.
  - [Diagramas-de-sequencia-NeuroSight.drawio](Especificacao/Diagramas-de-sequencia-NeuroSight.drawio) e [Diagramas-de-sequencia-NeuroSight.md](Especificacao/Diagramas-de-sequencia-NeuroSight.md): seis fluxos principais e as rotas da API.
  - [Modelo-logico-relacional-NeuroSight.drawio](Especificacao/Modelo-logico-relacional-NeuroSight.drawio) e [Modelo-logico-relacional-NeuroSight.md](Especificacao/Modelo-logico-relacional-NeuroSight.md): tabelas, chaves, isolamento por tenant e dicionário de dados.
  - [BPMN-Experimento-NeuroSight.drawio](Especificacao/BPMN-Experimento-NeuroSight.drawio) e [BPMN-Processo-atual.drawio](Especificacao/BPMN-Processo-atual.drawio): processo do experimento com o NeuroSight e processo atual, descritos nos `.md` de mesmo nome.
  - [Arquitetura-NeuroSight.drawio](Especificacao/Arquitetura-NeuroSight.drawio) e [Arquitetura-NeuroSight.md](Especificacao/Arquitetura-NeuroSight.md): figuras de arquitetura e do fluxo de uma sessão (Figuras 1 e 2 do artigo).
  - [imagens-dos-diagramas/](Especificacao/imagens-dos-diagramas/): todas as páginas dos `.drawio` exportadas em PNG, para leitura sem o draw.io.
- [Especificacao/Prototipos-NeuroSight/](Especificacao/Prototipos-NeuroSight/): protótipos das 14 telas do sistema web e das 5 telas do aplicativo do óculos, em HTML navegável e em PNG na pasta `imagens/`.
- [Entregas-anteriores/](Entregas-anteriores/): entregas 1.1 (descrição do problema) e 1.2 (descrição do software).
- [Referencias-e-modelos/](Referencias-e-modelos/) e [TCC_TADS_Exemplo_Sistema_de_Estágios/](TCC_TADS_Exemplo_Sistema_de_Estágios/): o modelo do artigo (`TCC_Artigo_Modelo_2026.pdf`), o template da Especificação Técnica e o LaTeX do curso.
- [Checklist-TCC1-NeuroSight.md](Checklist-TCC1-NeuroSight.md): andamento e pendências.
