# IV. Considerações Finais

Versão de trabalho de 03/11/2026. Fecha o artigo como a Seção IV do modelo (`Referencias-e-modelos/TCC_Artigo_Modelo_2026.pdf`): o que o trabalho apresentou, o que a revisão confirmou, o que a modelagem produziu, as limitações e as etapas seguintes. Os riscos que antes ficavam na IV.A.5 (prova de conceito no Unreal, Quest Pro fora de linha e internet no início) entram aqui como limitações.

## Como usar este arquivo

- **Citações:** chaves entre colchetes, como nas outras seções. [IC] já é citada na Seção III; [HAYDEN] é nova e está no fim do arquivo.
- **Tempo verbal:** o que foi feito, no passado; o sistema, no presente; o TCC2, no futuro.
- **Sem figuras nem tabelas**, como no modelo.

---

## IV. CONSIDERAÇÕES FINAIS

Este trabalho apresentou a modelagem do NeuroSight, um sistema de apoio à pesquisa com pessoas com distúrbios da consciência que reúne, em uma única ferramenta, as etapas dos experimentos com rastreamento ocular e expressões faciais em realidade virtual: o cadastro de pacientes e de estímulos, a configuração e o início das sessões pelo sistema web, a coleta no Meta Quest Pro, o envio e o processamento dos dados e a sua análise. A revisão de literatura confirmou que o rastreamento ocular detecta mais respostas do que a observação clínica nesses pacientes, que estímulos com significado pessoal tendem a provocar mais respostas do que estímulos neutros e que as ferramentas disponíveis não reúnem a coleta do olhar e das expressões faciais no Meta Quest Pro, a apresentação de uma sequência de estímulos com tempo definido e o armazenamento centralizado dos dados de vários grupos de pesquisa, com controle de acesso e auditoria. A proposta parte do protótipo desenvolvido na Iniciação Científica, cujo aplicativo e cuja forma de gravação das sessões são reaproveitados.

A etapa de modelagem produziu 60 requisitos funcionais, 20 regras de negócio e 26 requisitos não funcionais; doze diagramas de casos de uso, com 60 casos de uso, e as 60 histórias de usuário correspondentes; o diagrama de classes; o diagrama de estados da sessão; seis diagramas de sequência; o modelo lógico do banco de dados, com 20 tabelas; dois diagramas de processo de negócio; e 19 protótipos de tela, todos reunidos na Especificação Técnica que acompanha este artigo. A arquitetura definida, com um aplicativo em Unreal Engine, uma API em NestJS, um sistema web em Next.js e um banco de dados PostgreSQL compartilhado por vários grupos de pesquisa, com isolamento por *Row-Level Security*, controle de acesso e auditoria, atende aos requisitos de proteção dos dados de saúde e serve de base para o desenvolvimento. Do ponto de vista metodológico, o Scrum adaptado a uma equipe de dois integrantes, com o quadro Kanban no GitHub Projects e as reuniões de orientação, organizou o trabalho e permitiu validar as decisões ao longo da modelagem.

Cabe ressaltar que este trabalho concentrou-se no levantamento de requisitos, na modelagem e no projeto da arquitetura, não incluindo ainda a implementação. Três pontos da arquitetura dependem de verificação na etapa seguinte. O primeiro é a leitura das expressões faciais no Unreal Engine: o protótipo da IC lê apenas o olhar, pelo padrão OpenXR, e as opções de rastreamento da Meta, que fornecem as expressões, exigem outra integração do motor, incompatível com a usada no protótipo [IC]. Por isso, a primeira tarefa do desenvolvimento será uma prova de conceito que leia o olhar e as expressões ao mesmo tempo e meça a taxa de amostragem obtida com a captura de quadros ativa, que na IC ficou em 22 Hz [IC]; se a prova de conceito falhar, a alternativa é desenvolver o aplicativo em Unity, em que o olhar e as expressões vêm do mesmo SDK. O segundo ponto é o equipamento: o Meta Quest Pro saiu de linha em janeiro de 2025 [HAYDEN] e, embora o grupo de pesquisa disponha do aparelho usado na IC, a reposição, em caso de defeito, seria difícil. O terceiro é a dependência de internet no momento do início da sessão, já que o comando sai do sistema web e chega ao óculos pelo servidor; por isso, a rede do local da coleta precisa ser testada antes dos experimentos.

As etapas seguintes envolvem a prova de conceito, o desenvolvimento do aplicativo, da API e do sistema web em *sprints*, a partir do *backlog* formado pelas histórias de usuário, a medição do volume de dados de uma sessão real, estimado em cerca de 300 MB para 5 minutos, e os testes do sistema com o óculos. O uso com pacientes depende da aprovação de um protocolo de pesquisa pelo Comitê de Ética em Pesquisa, com o consentimento dos representantes legais, e da escolha da hospedagem conforme esse protocolo. O NeuroSight não faz diagnóstico nem substitui a avaliação clínica: a expectativa é que, ao organizar os experimentos e o registro dos dados, ele facilite a pesquisa sobre as respostas visuais e emocionais dessas pessoas e contribua, no futuro, para o apoio ao diagnóstico.

---

## Referências novas nesta seção

- **[HAYDEN]** HAYDEN, S. Meta officially discontinues Quest Pro, its first (and most expensive) mixed reality headset. *Road to VR*, 6 jan. 2025. Disponível em: https://roadtovr.com/meta-discontinues-quest-pro/. Acesso em: 26 out. 2026.

O endereço respondeu em 26/10/2026 (a página bloqueia scripts e abre no navegador).

## O que conferir antes de passar para o modelo

1. **Totais:** os números (60 RF, 20 RN, 26 RNF, 12 diagramas, 60 casos, 60 histórias, 6 diagramas de sequência, 20 tabelas, 2 BPMN, 19 telas) têm de bater com a Especificação Técnica.
2. **Prova de conceito:** se o plano B (Unity) for adotado, ajuste este parágrafo e a Seção III.
3. **Tamanho:** cerca de 650 palavras, um pouco mais que as Considerações Finais do modelo, que têm cerca de 350.
