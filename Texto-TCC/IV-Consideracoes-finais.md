# IV. Considerações Finais

Versão de trabalho de 03/11/2026. Fecha o artigo como a Seção IV do modelo (`Referencias-e-modelos/TCC_Artigo_Modelo_2026.pdf`): o que o trabalho apresentou, o que a revisão confirmou, o que a modelagem produziu, as limitações e as etapas seguintes. Os riscos que antes ficavam na IV.A.5 (prova de conceito no Unreal, Quest Pro fora de linha e internet no início) entram aqui como limitações. Em 10/11/2026, a pedido do autor, o texto foi enxugado para o artigo caber em 8 páginas: saíram a lista das etapas do experimento, a frase sobre o protótipo da IC, as tecnologias da arquitetura e parte dos totais da modelagem, que estão nas Seções I e III. Em 12/11/2026, a pedido do autor, o artigo foi reduzido para 6 páginas, como o modelo de 2026 (a Resolução nº 01/25 do curso recomenda de 6 a 8): as etapas do experimento e o achado sobre os estímulos pessoais saíram do primeiro parágrafo, a lista dos diagramas virou "diagramas em UML" e "processos em BPMN", e saíram as 20 tabelas do modelo lógico, a medição do volume de dados de uma sessão real entre as etapas seguintes e o consentimento dos representantes legais, que está na Subseção III.D.

## Como usar este arquivo

- **Citações:** chaves entre colchetes, como nas outras seções. [IC] já é citada na Seção III; [HAYDEN] é nova e está no fim do arquivo.
- **Tempo verbal:** o que foi feito, no passado; o sistema, no presente; o TCC2, no futuro.
- **Sem figuras nem tabelas**, como no modelo.

---

## IV. CONSIDERAÇÕES FINAIS

Este trabalho apresentou a modelagem do NeuroSight, que reúne em uma única ferramenta as etapas de experimentos com rastreamento ocular e expressões faciais em realidade virtual com pessoas com DoC. A revisão de literatura confirmou o potencial do rastreamento ocular nesses pacientes e mostrou que nenhuma das ferramentas analisadas reúne a coleta no Meta Quest Pro, a sequência de estímulos com tempo definido e o armazenamento centralizado dos dados de vários grupos de pesquisa, com controle de acesso e auditoria.

A modelagem produziu os requisitos, os diagramas em UML, os processos em BPMN, as 60 histórias de usuário, o modelo lógico do banco de dados e 19 protótipos de tela, reunidos na Especificação Técnica, e definiu uma arquitetura com isolamento por *Row-Level Security*, controle de acesso e auditoria, que atende aos requisitos de proteção dos dados de saúde; o Scrum, com as reuniões de orientação, permitiu validar as decisões ao longo do trabalho.

A implementação fica para a etapa seguinte, em que três pontos precisam ser verificados. O primeiro é a leitura das expressões faciais no Unreal Engine: o protótipo da IC lê apenas o olhar, pelo OpenXR, e as expressões exigem outra integração do motor, incompatível com a do protótipo [IC]; por isso, a primeira tarefa será uma prova de conceito que leia o olhar e as expressões ao mesmo tempo e meça a taxa de amostragem com a captura de quadros, que na IC foi de 22 Hz, tendo o Unity como alternativa. O segundo é o equipamento: o Meta Quest Pro saiu de linha em janeiro de 2025 [HAYDEN], e a reposição do aparelho seria difícil. O terceiro é a dependência de internet no início da sessão, que exige testar a rede do local da coleta.

As etapas seguintes são a prova de conceito, o desenvolvimento e os testes com o óculos; o uso com pacientes depende da aprovação de um protocolo de pesquisa pelo CEP e da escolha da hospedagem conforme esse protocolo. Sem fazer diagnóstico, o NeuroSight pode facilitar a pesquisa sobre as respostas visuais e emocionais dessas pessoas e contribuir, no futuro, para o apoio ao diagnóstico.

---

## Referências novas nesta seção

- **[HAYDEN]** HAYDEN, S. Meta officially discontinues Quest Pro, its first (and most expensive) mixed reality headset. *Road to VR*, 6 jan. 2025. Disponível em: https://roadtovr.com/meta-discontinues-quest-pro/. Acesso em: 26 out. 2026.

O endereço respondeu em 26/10/2026 (a página bloqueia scripts e abre no navegador).

## O que conferir antes de passar para o modelo

1. **Totais:** os números desta seção (60 histórias e 19 telas) têm de bater com a Especificação Técnica; os demais totais (60 RF, 20 RN, 26 RNF, 60 casos de uso em 12 diagramas, 6 fluxos com diagrama de sequência) ficaram só na Seção III, e as 20 tabelas do modelo lógico saíram do artigo em 12/11/2026.
2. **Prova de conceito:** se o plano B (Unity) for adotado, ajuste este parágrafo e a Seção III.
3. **Tamanho:** cerca de 350 palavras (eram cerca de 570 antes do corte de 12/11/2026 e cerca de 700 antes do de 10/11/2026), como as Considerações Finais do modelo, que têm cerca de 350. O artigo inteiro tem de caber em 6 páginas: ver o item "Tamanho do artigo" no arquivo da Seção III.
