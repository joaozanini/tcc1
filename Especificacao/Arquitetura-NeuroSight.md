# Arquitetura do NeuroSight (Subseção III.C do artigo e contextualização da Especificação Técnica)

Versão de trabalho de 26/10/2026. Base: [Decisoes-tecnicas-NeuroSight.md](Decisoes-tecnicas-NeuroSight.md), [Modelo-logico-relacional-NeuroSight.md](Modelo-logico-relacional-NeuroSight.md) e [Diagramas-de-sequencia-NeuroSight.md](Diagramas-de-sequencia-NeuroSight.md).

## Figuras para o artigo

O arquivo [Arquitetura-NeuroSight.drawio](Arquitetura-NeuroSight.drawio) tem duas páginas, já no formato de figura do artigo (sem título dentro da imagem, porque o título vai na legenda, como no modelo). Desde 03/11/2026 são as únicas figuras do artigo, que segue o modelo de 2026 (`Referencias-e-modelos/TCC_Artigo_Modelo_2026.pdf`) e não traz diagramas de modelagem; ficam na Subseção III.C. A primeira também abre a contextualização da Especificação Técnica.

1. **Figura – Arquitetura.** Figura 1 do artigo: "FIGURA 1 - Arquitetura do NeuroSight" e, abaixo, "FONTE: Os autores (2026)", sem ponto final, como no modelo.
2. **Figura – Fluxo de uma sessão.** Figura 2 do artigo (substituiu a Figura 1 do 1.2): "FIGURA 2 - Fluxo de uma sessão no NeuroSight" e "FONTE: Os autores (2026)".

Para exportar no draw.io, use Arquivo → Exportar como, PNG com zoom de 300% e a opção de recortar, e grave em `Texto-TCC/figuras/` como `Figura-1-arquitetura.png` e `Figura-2-fluxo-de-uma-sessao.png`. Sem o draw.io, use o processo do CLAUDE.md (visualizador do diagrams.net no Edge sem janela).

**O que mudou em relação à figura do 1.2:**
- Saiu a seta direta entre o sistema web e o Meta Quest Pro ("início da sessão e espelhamento, mesma rede").
- O comando de início agora passa pelo servidor.
- A gravação passou a aparecer como quadros enviados ao servidor, que monta o vídeo.
- Entrou uma nota sobre o pareamento do óculos.

**Revisão de 05/11/2026 (a pedido do autor):** na Figura 1, as setas passaram a indicar o sentido dos dados (duplas onde há leitura e gravação), a fila do pg-boss foi para a caixa do banco, onde o texto diz que ela fica, e o proxy reverso entrou na figura, porque o texto o cita. A Figura 2 deixou de ser um diagrama de componentes com listas de responsabilidades e virou um fluxo numerado (1 a 10), no estilo de um diagrama de sequência resumido, com os passos que faltavam: o aviso de "pronto" do óculos, a liberação do botão "Iniciar" e a confirmação do início na consulta seguinte. Os nomes dos componentes ficaram iguais nas duas figuras ("App de coleta", "Sistema web", "Servidor"). Fonte de 13 px nas duas páginas e as duas figuras na largura das duas colunas.

**Revisão de 09/11/2026 (a pedido do autor):** a Figura 1 misturava a arquitetura lógica com a implantação e passou a ser uma arquitetura em camadas, como a Figura 1 do modelo de 2026: Apresentação (app de coleta e sistema web), Aplicação (API e processamento) e Dados (banco de dados e armazenamento de arquivos), com o serviço de e-mail fora das camadas, como serviço externo. Saíram da figura a moldura "Servidor (VPS ou da instituição) / Docker Compose", o proxy reverso, o "disco do servidor" e o HTTPS nos rótulos das setas; esses itens continuam no texto da III.C (parágrafo da implantação) e na seção "Implantação" abaixo. O sistema web deixou de aparecer como "Navegador" fora do servidor, o que contradizia o contêiner `web` da implantação. Não há diagrama de implantação: o autor preferiu deixar esse conteúdo só no texto.

**Segunda revisão de 09/11/2026 (a pedido do autor):** a descrição de cada caixa passou a cobrir tudo o que o componente faz, conferida com os requisitos, os diagramas de sequência (SD01 a SD06) e o modelo lógico; a tabela "Componentes" foi alinhada com a figura. Entraram no app o pareamento, a gravação local e o envio dos dados; no sistema web, o visitante (página inicial e autocadastro) e as funções de cada perfil; na API, os perfis de acesso, a comunicação com os óculos, o recebimento e a entrega dos arquivos e o disparo do processamento; no processamento, a conclusão da sessão ou o registro da falha; no banco, o que ele guarda (cadastros, sessões, amostras e auditoria); no armazenamento, o acesso só pela API.

**Terceira revisão de 09/11/2026 (a pedido do autor):** as descrições saíram das caixas, que ficaram só com o nome e a tecnologia do componente (App de coleta: Unreal Engine 5.5 e Meta Quest Pro; Sistema web: Next.js; API: NestJS; Processamento: pg-boss e FFmpeg; Banco de dados: PostgreSQL; Armazenamento de arquivos: disco ou serviço compatível com S3; Serviço de e-mail: externo, SMTP). As responsabilidades de cada componente ficam no texto da III.C e na tabela "Componentes" abaixo, que continua completa.

## Componentes

| Componente | Tecnologia | Responsabilidade |
|---|---|---|
| App de coleta | Unreal Engine 5.5 (C++), OpenXR e Meta XR, no Meta Quest Pro | Exibe o código de pareamento; consulta o servidor, baixa a sessão e os estímulos e verifica o rastreamento; exibe os estímulos; coleta olhar e expressões e captura os quadros; grava os dados no óculos e os envia em lotes, com reenvio |
| Sistema web | Next.js (React, TypeScript) | Interface do visitante (página inicial, autocadastro) e dos usuários: login e conta; pacientes, estímulos, modelos e sessões (envio, início e acompanhamento); análise; usuários, óculos e auditoria. Não tem regra de negócio |
| API | NestJS (TypeScript) com Prisma | Regras de negócio e perfis de acesso; autenticação (JWT e token do óculos) e isolamento por tenant (filtro e RLS por transação); pareamento, entrega da sessão e comando de início aos óculos; recebimento dos dados e entrega dos arquivos e das exportações; disparo do processamento (fila); auditoria; envio dos e-mails |
| Banco de dados | PostgreSQL 15 ou mais novo, com RLS | Dados de todos os tenants, isolados por RLS: cadastros, sessões, amostras e auditoria; também guarda a fila de tarefas (pg-boss) |
| Arquivos | Disco do servidor (volume Docker), atrás de uma interface que permite trocar por S3 | Estímulos, JSON originais, quadros (temporários) e vídeos MP4, separados por tenant e entregues só pela API |
| Processamento | Worker com pg-boss e FFmpeg (mesmo código da API, em outro contêiner) | Pega a tarefa na fila, importa eventos e amostras para o banco, monta o MP4 e deixa a sessão concluída ou, se houver erro, em falha |
| Serviço de e-mail | SMTP de um provedor externo | Confirmação de e-mail, convite e redefinição de senha |
| Proxy reverso | Caddy ou Nginx | HTTPS (RNF02) e encaminhamento para a API e o sistema web; é infraestrutura e, desde 09/11/2026, fica fora da Figura 1 (só no texto da implantação) |

## Comunicação

| De → para | Protocolo | Autenticação | Quando |
|---|---|---|---|
| Sistema web → API | HTTPS (REST) | JWT do usuário, com tenant e perfil | Ações do usuário e consulta do estado da sessão |
| App → API | HTTPS (REST) | Token do óculos (o segredo do pareamento) | Consulta a cada ~1 s enquanto espera; envio dos dados no fim |
| API → banco | SQL (Prisma) | Papel `neurosight_api`, com RLS. Exceção: papel `neurosight_auth` no autocadastro, login, tokens e pareamento | Toda operação |
| API e processamento → arquivos | Sistema de arquivos | — | Envio e leitura de arquivos; montagem do vídeo |
| Processamento → banco | SQL | Papel `neurosight_api`, com o tenant da tarefa | Fila e importação das amostras |
| API → e-mail | SMTP | Credencial do provedor | Autocadastro, convite e redefinição de senha |

Não há comunicação direta entre o sistema web e o óculos, nem exigência de que estejam na mesma rede (RNF20).

## Implantação

- **Onde roda:** com Docker Compose (RNF26), numa VPS de preferência em região no Brasil ou num servidor da instituição; a escolha cabe ao protocolo aprovado pelo CEP (LGPD, art. 13).
- **Contêineres:** `proxy` (Caddy), `web` (Next.js), `api` (NestJS), `worker` (o mesmo código da API, rodando só o processamento) e `postgres`.
- **Arquivos:** um volume persistente, organizado em pastas por tenant (`/dados/<tenant_id>/...`).
- **Cópia de segurança:** diária, do banco e do volume de arquivos (RNF12).

## Roteiro para o texto do artigo (Subseções III.C e III.D)

O texto escrito a partir deste roteiro está em [III-Metodo-tecnologias-e-arquitetura.md](../Texto-TCC/III-Metodo-tecnologias-e-arquitetura.md). Até 03/11/2026 ele formava a Seção IV.A, com subseções numeradas ("1) Multi-tenant"); no modelo de 2026 a arquitetura é a Subseção C da Seção III e as regras de negócio, a Subseção D, ambas em parágrafos corridos, sem subseções numeradas. Para o NeuroSight:

1. **C. Arquitetura do Sistema.** A Figura 1 e um parágrafo por componente, com base na tabela "Componentes"; a implantação (contêineres, VPS ou servidor da instituição, LGPD art. 13); o multi-tenant (`tenant_id` em todas as tabelas com RLS, FKs compostas, os papéis do banco e os arquivos separados por tenant, do modelo lógico); a comunicação (Figura 2, pareamento de SD02, envio e início por consulta ao servidor de SD03 e SD04, por que não há espelhamento nem WebSocket); e o controle de acesso (HTTPS, JWT e token do óculos, perfis cumulativos).
2. **D. Regras de Negócio e Processamento dos Dados.** As regras das sessões (modelo e sessão personalizada, estímulos pessoais, uma sessão pendente por óculos, os nove estados, sem edição depois do envio e sem interrupção depois do início); os dados coletados (JSON com eventos de estímulo, olhar a cada quadro e expressões FACS, mais os quadros JPEG); o envio em lotes e o processamento (importação das amostras para tabelas, MP4 com FFmpeg, JSON original guardado, dados coletados imutáveis, volume estimado de cerca de 300 MB por sessão de 5 min, com base nos 88 MB por minuto da IC); a análise no sistema web (mapa de calor, modo validação, gráficos, resumo por estímulo); quem vê o quê e a auditoria imutável; LGPD (minimização, paciente só por código no óculos, nenhuma imagem do rosto, consentimento a cargo do protocolo da pesquisa).
3. **Limitações.** Vão na Seção IV (Considerações Finais), não na arquitetura: o rastreamento facial no Unreal depende de prova de conceito; o Meta Quest Pro saiu de linha; e o óculos precisa de internet no momento do início.
