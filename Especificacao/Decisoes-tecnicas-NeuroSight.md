# Decisões técnicas do NeuroSight

Registro das decisões fechadas em 25/10/2026. Serve de base para a Tabela 2 (Subseção III.B) e para as Subseções III.C e III.D do artigo, e para a contextualização da Especificação Técnica.

## 1. Resumo

| Tema | Decisão |
|---|---|
| App do óculos | Unreal Engine 5.5 (C++), partindo do protótipo da IC ([QuestPro-EyeTracking](https://github.com/joaozanini/QuestPro-EyeTracking)) |
| Servidor (API) | NestJS (TypeScript), no lugar do FastAPI da IC |
| Sistema web | Next.js (React + TypeScript) |
| Banco de dados | PostgreSQL |
| Multi-tenant | Banco único com `tenant_id` em todas as tabelas; filtro no servidor e Row-Level Security (RLS) no PostgreSQL |
| Envio da sessão | No sistema web, o pesquisador envia a sessão a um óculos pareado; o óculos baixa a sessão e os estímulos |
| Início da sessão | Botão "Iniciar" no sistema web; o óculos recebe o comando na consulta seguinte ao servidor (até cerca de 2 s, com consulta a cada ~1 s; RNF13) |
| Acompanhamento ao vivo | Não existe. O pesquisador não vê o que o paciente vê: acompanha só o estado da sessão e vê os dados depois que ela termina |
| Gravação | Igual à IC: o app captura quadros JPEG da cena, envia em lotes ao fim da sessão e o servidor monta o vídeo MP4 (H.264) |
| Comunicação | Só HTTPS (REST): óculos ↔ servidor e navegador ↔ servidor. Enquanto espera, o óculos consulta o servidor a cada ~1 s. Sem WebSocket e sem exigir mesma rede, mas o óculos precisa de internet no momento do início |

### Por que cada decisão (e o que foi descartado)

- **Unreal 5.5 no app:** reaproveita o protótipo da IC, já verificado em dispositivo real (olhar, gravação e envio). Descartado por ora: Unity, que tem um caminho mais documentado para o rastreamento facial e fica como plano B (seção 6).
- **NestJS + Next.js:** uma só linguagem (TypeScript) no servidor e no sistema web. O Next.js usa React, o que permite reaproveitar o player com heatmap da IC. Descartados: manter o FastAPI da IC, Java/Spring + Angular e C#/.NET + React.
- **PostgreSQL:** tem Row-Level Security, usado para isolar os tenants, e já era uma das opções da IC.
- **`tenant_id` + RLS:** o autocadastro só insere uma linha e há um banco só para manter. O RLS é uma segunda barreira caso o código esqueça um filtro, o que pesa com dados de saúde (LGPD). Descartados: um schema por tenant (exige criar schema e rodar migrações a cada autocadastro) e um banco por tenant (inviável com autocadastro).
- **Envio pelo web a um óculos:** tudo é decidido no computador e o óculos só mostra a próxima sessão, com pouca interação em RV. Descartados: lista de sessões no óculos e escolha por paciente no óculos.
- **Início pelo botão no web:** o pesquisador conduz tudo pelo computador, sem usar o controle. Custo: precisa de internet no momento do início (seção 6). Descartados: gatilho no controle, gatilho com contagem regressiva e início pelo sensor de presença.
- **Sem acompanhamento ao vivo:** o pesquisador não precisa ver o que o paciente vê durante a sessão. Isso elimina WebSocket e WebRTC e os problemas de rede que viriam junto (bloqueio de `ws://` em página HTTPS, redes que isolam os aparelhos). Descartados: painel ao vivo, imagem via servidor e vídeo direto por WebRTC.
- **Gravação como na IC:** já validada; o óculos não codifica vídeo (só salva JPEG) e o MP4 é montado no servidor. Descartados: gravar vídeo no próprio óculos (exige plugin ou código nativo) e replay só a partir dos dados.
- **HTTPS/REST com consulta periódica:** simples e funciona em qualquer rede com internet. Descartado: WebSocket, desnecessário sem acompanhamento ao vivo.
- **Arquivos no disco do servidor:** basta para o tamanho do projeto; o MinIO, opção usual para isso, foi arquivado em 2026. Fica uma interface para trocar por S3 depois.
- **Token por pareamento do óculos:** evita digitar senha no óculos e substitui a chave fixa da IC, que não identifica de qual tenant é o aparelho.

## 2. Tecnologias (base da Tabela 2)

| Tecnologia | Uso | Observação |
|---|---|---|
| Meta Quest Pro | Exibição dos estímulos e coleta do olhar e das expressões faciais | Fora de linha desde 2025 (ver riscos) |
| Unreal Engine 5.5 (C++) | App do óculos | Reaproveita o `GazeRecorderActor` da IC |
| Plugins OpenXR, OpenXR Eye Tracker e Meta XR | Rastreamento ocular e facial no Unreal | O facial ainda precisa de prova de conceito (seção 6) |
| NestJS (Node.js, TypeScript) | API: regras de negócio, autenticação, recepção dos dados | Documentar a API com OpenAPI (`@nestjs/swagger`): é o contrato com o app do óculos |
| Prisma | Acesso ao banco e migrações | RLS por extensão do Prisma Client (há exemplo oficial `row-level-security`) |
| PostgreSQL (15 ou mais novo) | Banco de dados | RLS para isolar os tenants; a versão 15 é exigida pelo `ON DELETE SET NULL (coluna)` do modelo lógico |
| Next.js (React, TypeScript) | Sistema web | Só interface: toda regra de negócio fica no NestJS. O player com heatmap da IC (React) pode ser reaproveitado |
| FFmpeg | Montagem do MP4 a partir dos quadros JPEG | Como no servidor da IC |
| pg-boss (opcional) | Fila de tarefas em segundo plano (montagem do vídeo) | Roda sobre o próprio PostgreSQL, sem Redis |
| Disco do servidor (volume Docker) | Estímulos, quadros, vídeos e JSON | Acesso só pela API, por trás de uma interface que permita trocar por S3 depois (o MinIO foi arquivado em 2026) |
| Docker Compose + proxy reverso com HTTPS (Caddy ou Nginx) | Implantação numa VPS ou em servidor da instituição | VPS de preferência em região no Brasil; servidor da instituição se o protocolo aprovado pelo CEP exigir (LGPD, art. 13) |
| Git + GitHub + GitHub Projects | Versionamento e quadro Kanban | |
| draw.io | Diagramas UML e BPMN | Todos os diagramas desta pasta estão em `.drawio` |
| HTML e CSS | Protótipos de tela | Imagens geradas pelo Edge, que podem ser importadas no Figma se for preciso ([Prototipos-NeuroSight.md](Prototipos-NeuroSight/Prototipos-NeuroSight.md)) |

Sugestão: web e API num mesmo repositório (monorepo com pnpm workspaces), para compartilhar os tipos TypeScript. O app do Unreal continua no repositório próprio.

## 3. Fluxo de uma sessão

1. **Pareamento do óculos (uma vez por aparelho).** O app pede um código curto e recebe também um segredo. Um administrador digita o código no sistema web, o servidor vincula o óculos ao tenant, e o segredo passa a valer como token próprio do dispositivo (ver SD02 em Diagramas-de-sequencia-NeuroSight.md). Substitui a chave fixa (`X-Api-Key`) da IC. Modelo de referência: OAuth 2.0 Device Authorization Grant (RFC 8628).
2. **Preparação (sistema web).** O pesquisador escolhe o paciente, aplica um modelo ou monta a sessão na hora e a envia para um óculos pareado.
3. **Download (óculos).** Na tela de espera, o app consulta o servidor a cada ~1 s (a consulta também serve de sinal de vida do aparelho), baixa a sessão e todos os estímulos e avisa o servidor que está pronto. A tela mostra algo como "Sessão pronta: paciente P-012 · 8 estímulos · 4 min · aguardando início". O paciente aparece só pelo código, nunca pelo nome.
4. **Início (sistema web).** O sistema web mostra o óculos online e a sessão baixada, e só então libera o botão "Iniciar". O pesquisador coloca o óculos no paciente e clica em "Iniciar". Na consulta seguinte (até cerca de 2 s), o app começa e confirma; o web passa a mostrar "em execução" e o início fica registrado na auditoria, com o usuário que clicou. Daí em diante tudo roda no óculos, sem depender da rede.
5. **Execução e fim.** O app exibe os estímulos na ordem e pelo tempo configurados, coleta o olhar e as expressões, captura os quadros e encerra sozinho no fim do tempo.
6. **Envio.** Como na IC: cria a sessão no servidor (JSON), envia os quadros em lotes com nova tentativa e finaliza. Sem rede, os dados ficam no óculos e o app tenta de novo depois (na IC isso era manual, via `adb`).
7. **Processamento (servidor).** Monta o MP4 em segundo plano e associa tudo à sessão e ao paciente.
8. **Análise (sistema web).** O pesquisador abre a sessão: vídeo com heatmap, modo validação e curvas das expressões ao longo do tempo, por estímulo.

Estados da sessão (servem para o diagrama de classes e para um diagrama de estados): rascunho → enviada ao óculos → baixada → início solicitado → em execução → enviando → processando → concluída (ou falha).

## 4. Multi-tenant

- Toda tabela que pertence a um tenant tem `tenant_id`: usuários, pacientes, estímulos, modelos, sessões, dispositivos e auditoria.
- Cada usuário pertence a um único tenant. O token de login carrega o `tenant_id` e o perfil (proprietário, administrador ou pesquisador).
- Duas barreiras: (1) o servidor filtra pelo tenant do usuário em toda consulta; (2) o PostgreSQL aplica uma política RLS em cada tabela:

  ```sql
  ALTER TABLE paciente ENABLE ROW LEVEL SECURITY;
  CREATE POLICY isolamento ON paciente
    USING (tenant_id = current_setting('app.tenant_id', true)::uuid);
  ```

- Arquivos em pastas por tenant (`/dados/<tenant_id>/...`), entregues só pela API, depois da checagem de permissão.
- O autocadastro cria o tenant e o proprietário na mesma transação.

Cuidados na implementação (TCC2):

- O usuário do banco usado pela API não pode ser superusuário nem dono das tabelas, senão o RLS é ignorado (ou use `FORCE ROW LEVEL SECURITY`).
- Definir o tenant por transação, com `set_config('app.tenant_id', ..., true)`, para não vazar entre conexões do pool.
- Login e autocadastro acontecem antes de existir tenant no contexto: precisam de um caminho separado (função no banco ou papel com `BYPASSRLS` usado só pelo módulo de autenticação).
- A tabela de auditoria só aceita INSERT para o usuário da API.

## 5. Dados gravados (evolução do `gaze.json` da IC)

A IC já grava `meta`, `frames[]` e `samples[]` (tempo, validade, ponto 3D, `(u,v)` na câmera de captura e confiança). Para o NeuroSight, acrescentar:

- **Identificação:** id da sessão, do dispositivo e versão do app.
- **Eventos de estímulo:** id do estímulo e instantes reais de início e de fim, medidos no óculos. Não basta o tempo configurado, porque carregar um vídeo atrasa a exibição.
- **Olhar sobre o estímulo:** id do estímulo olhado e `(u,v)` no próprio estímulo (no Unreal: opção *Support UV From Hit Results* + `FindCollisionUV`), além do `(u,v)` na câmera que a IC já grava.
- **Expressões faciais:** as expressões baseadas no FACS (cerca de 70), com intensidade de 0 a 1 e validade. Volume: 70 valores × ~72 Hz × 300 s ≈ 1,5 milhão de números, dezenas de MB em JSON por sessão de 5 min. Considerar taxa menor ou arquivo separado.

## 6. Riscos para testar cedo

1. **Rastreamento facial no Unreal (o maior).** O protótipo da IC só lê o olhar, pelo caminho OpenXR da Epic. O README da IC registra que as opções de rastreamento da Meta só aparecem no backend OVRPlugin e que, nesse backend, o `GetGazeData` para de funcionar. Fazer uma prova de conceito com olhar e rosto juntos (por exemplo, lendo os dois pelo módulo Movement do plugin Meta XR). Se não der, a alternativa é Unity, onde os dois vêm do mesmo SDK.
2. **Quest Pro fora de linha.** O grupo tem o aparelho usado na IC; a dificuldade de reposição está citada como limitação no TCC.
3. **Tamanho do envio.** A IC mediu 88 MB por minuto, com quadros JPEG de 1024×1024 (cerca de 67 KB cada) a ~22 quadros/s. A 15 quadros/s, uma sessão de 5 min tem 4.500 quadros, cerca de 300 MB. Medir na prova de conceito e ajustar fps, resolução e qualidade.
4. **Carga da captura.** A IC já registra engasgos com fps alto. Para estímulos em vídeo, fps baixo deixa o replay picotado.
5. **Internet na hora do início.** Como o comando sai do sistema web, sem internet no local da coleta a sessão não começa. Testar a rede do local; se ela for instável, um plano B é permitir o início também pelo controle (por exemplo, segurando o gatilho por 3 s).

## 7. O que muda no texto do 1.2

- Tirar o espelhamento e a exigência de mesma rede. O início continua pelo sistema web, como o 1.2 já diz, mas o comando passa pelo servidor: o óculos o recebe ao consultar o servidor, então basta internet.
- A frase "sem que seja preciso nenhuma ação no controle" continua valendo: o controle não é usado nem no início nem no fim.
- Acrescentar o pareamento do óculos, o envio da sessão a um óculos e a montagem do vídeo no servidor.
- Figura 1: tirar a seta direta "início da sessão e espelhamento (mesma rede)" entre o sistema web e o Quest. O comando de início passa a seguir o caminho sistema web → servidor → Quest (por exemplo, "o Quest busca a sessão e o comando de início").

## 8. Premissas confirmadas (25/10/2026)

- **Envio:** o pesquisador envia a sessão a um óculos pelo sistema web; o óculos mostra só a próxima sessão.
- **Início:** pelo botão "Iniciar" do sistema web, com o óculos já no paciente. Substitui a premissa anterior (gatilho do controle).

## Fontes

- Meta. Face tracking (Unity): https://developers.meta.com/horizon/documentation/unity/move-face-tracking/
- Meta. Eye tracking (Unity): https://developers.meta.com/horizon/documentation/unity/move-eye-tracking/
- Meta. Meta XR plugin settings (Unreal): https://developers.meta.com/horizon/documentation/unreal/unreal-plugin-settings
- Prisma. Client extension examples (row-level-security): https://www.prisma.io/docs/orm/prisma-client/client-extensions/extension-examples
- IETF. RFC 8628, OAuth 2.0 Device Authorization Grant: https://www.rfc-editor.org/rfc/rfc8628
- Road to VR. Meta discontinues Quest Pro: https://roadtovr.com/meta-discontinues-quest-pro/
- MinIO CE arquivado (fonte secundária; conferir no GitHub do MinIO): https://glukhov.org/data-infrastructure/object-storage/minio-dead/
- Protótipo da IC: https://github.com/joaozanini/QuestPro-EyeTracking
