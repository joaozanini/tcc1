# Diagramas de sequência do NeuroSight

Versão de trabalho de 26/10/2026. Base: [Casos-de-uso-e-historias-NeuroSight.md](Casos-de-uso-e-historias-NeuroSight.md), [Modelo-logico-relacional-NeuroSight.md](Modelo-logico-relacional-NeuroSight.md) e [Decisoes-tecnicas-NeuroSight.md](Decisoes-tecnicas-NeuroSight.md).

Os diagramas estão em [Diagramas-de-sequencia-NeuroSight.drawio](Diagramas-de-sequencia-NeuroSight.drawio), um por página, e cobrem os seis fluxos principais:

| Diagrama | Fluxo | Casos de uso |
|---|---|---|
| SD01 | Autocadastro do tenant e confirmação do e-mail | UC01.2, UC01.3 |
| SD02 | Pareamento do óculos | UC03.1 |
| SD03 | Criação e envio da sessão até o óculos | UC07.1, UC07.2, UC07.4, UC08.1, UC08.2 |
| SD04 | Início e execução da sessão | UC07.6, UC08.3 a UC08.6 |
| SD05 | Envio dos dados e montagem do vídeo | UC09.1, UC09.2 |
| SD06 | Consulta e análise da sessão | UC10.1 a UC10.5 |

## Como ler

- **Participantes:** atores (Visitante, Administrador, Pesquisador, Paciente) e os componentes da arquitetura: Sistema web (Next.js), API (NestJS), Banco (PostgreSQL), Armazenamento (disco), App do óculos (Unreal), Processamento (fila + FFmpeg) e Serviço de e-mail.
- **Seta cheia:** chamada. **Seta tracejada:** resposta. **Seta que volta para o próprio participante:** ação interna.
- **Mensagens numeradas:** as chamadas e as ações internas são numeradas na ordem; as respostas não.
- **Blocos `alt`, `loop` e `opt`:** caminhos alternativos (`alt`, separados pela linha tracejada), repetição (`loop`) e trecho opcional (`opt`). A condição aparece entre colchetes.
- **Notas:** registram regras que valem no trecho, como o uso do RLS ou do papel `neurosight_auth`.

## O que cada diagrama mostra

### SD01 – Autocadastro do tenant

- Ainda não existe tenant no contexto, por isso a API usa o papel `neurosight_auth`.
- Tenant, proprietário, token de confirmação e registro de auditoria são criados numa única transação.
- Se o e-mail já estiver cadastrado, a API responde 409 (RN02).
- A confirmação do e-mail usa o token de uso único (RF03). Ao confirmar, o sistema web recebe o JWT, com o tenant e o perfil.

### SD02 – Pareamento do óculos

- O app pede um código sem estar autenticado e recebe o código e um **segredo**.
- Enquanto mostra o código, o app consulta o servidor a cada ~2 s.
- O administrador digita o código no sistema web, e a API cria o dispositivo no tenant dele. Código inválido ou vencido recebe 404.
- O `token_hash` do dispositivo é o hash do segredo. Na consulta seguinte, o app recebe "pareado" e passa a usar o segredo como token (RNF04).

### SD03 – Criação e envio da sessão

- Em cada transação, a API define `app.tenant_id` para o RLS.
- Ao criar a sessão, a API valida os estímulos (RN09, RN12) e copia os itens do modelo (RN11).
- O envio a um óculos passa pelo índice que impede duas sessões pendentes no mesmo aparelho (RN14).
- O óculos consulta `GET /dispositivo/proxima-sessao` a cada ~1 s. A mesma consulta atualiza o último contato (o "online") e entrega a sessão.
- O app baixa só os estímulos que ainda não tem, comparando pelo hash do arquivo. Depois verifica o rastreamento (RF39), avisa que a sessão está baixada e mostra o código do paciente (RN19).
- O sistema web acompanha o estado consultando a sessão e só então libera o botão "Iniciar" (RN15).

### SD04 – Início e execução

- O início só é aceito com a sessão baixada e o óculos online. Caso contrário, a API responde 409.
- O óculos recebe o comando na consulta seguinte (RNF13) e confirma o início.
- A partir daí, a execução não depende da rede (RNF09) e os dados são salvos no óculos a cada ~5 s (RF47).
- Para cada estímulo, o app registra o instante real de início e de fim (RF43). A cada quadro, registra o olhar e as expressões (RF44, RF45) e captura a cena (RF46). Quando configurada, exibe a tela neutra entre os estímulos (RF29).
- A sessão termina sozinha, sem uso do controle (RF42); não há interrupção (RN16).

### SD05 – Envio e processamento

- O envio segue os três passos da IC: JSON, lotes de quadros e conclusão.
- Lote repetido é ignorado (RNF11) e lote que falha é reenviado (RF48). Sem conexão, o óculos guarda tudo e tenta de novo depois (RF49).
- Os dados só são apagados do óculos depois que o servidor confirma o recebimento (RNF10).
- Em segundo plano, o processamento pega a tarefa na fila, importa eventos e amostras para o banco (RF51) e monta o MP4 com FFmpeg (RF50).
- No fim, a sessão fica CONCLUIDA ou, se houver erro, FALHA.

### SD06 – Consulta e análise

- A API confere quem pode ver a sessão (RN18). Só quando o acesso é permitido, registra a VISUALIZACAO na auditoria (RF59); sem permissão, responde 403.
- O vídeo é entregue em trechos (requisição com `Range`), o que permite avançar e voltar sem baixar o arquivo inteiro.
- O sistema web busca as amostras do trecho que está sendo exibido e desenha o heatmap (RF53).
- O resumo por estímulo é calculado no banco, cruzando as amostras com os eventos de estímulo (RF56).

## Rotas da API citadas

| Método e rota | Quem chama | Para quê | Diagrama |
|---|---|---|---|
| `POST /tenants` | Sistema web | Autocadastro: cria tenant, proprietário e token de confirmação | SD01 |
| `POST /auth/confirmar-email` | Sistema web | Confirma o e-mail com o token de uso único | SD01 |
| `POST /pareamentos` | App | Pede um código de pareamento (sem autenticação) | SD02 |
| `GET /pareamentos/{id}` | App | Consulta se o código já foi confirmado (envia o segredo) | SD02 |
| `POST /dispositivos` | Sistema web | O administrador confirma o código e cria o óculos | SD02 |
| `POST /sessoes` | Sistema web | Cria a sessão, a partir de um modelo ou personalizada | SD03 |
| `POST /sessoes/{id}/envio` | Sistema web | Envia a sessão a um óculos | SD03 |
| `GET /dispositivo/proxima-sessao` | App | Consulta periódica: sinal de vida, sessão pendente e comando de início | SD03, SD04 |
| `GET /estimulos/{id}/arquivo` | App | Baixa um estímulo | SD03 |
| `POST /sessoes/{id}/baixada` | App | Avisa que a sessão está pronta e informa o estado do rastreamento | SD03 |
| `GET /sessoes/{id}` | Sistema web | Estado e dados da sessão | SD03, SD06 |
| `POST /sessoes/{id}/inicio` | Sistema web | Pede o início (botão "Iniciar") | SD04 |
| `POST /sessoes/{id}/inicio-confirmado` | App | Confirma que a execução começou | SD04 |
| `POST /sessoes/{id}/coleta` | App | Envia o JSON da coleta | SD05 |
| `POST /sessoes/{id}/quadros` | App | Envia um lote de quadros | SD05 |
| `POST /sessoes/{id}/coleta/concluir` | App | Fecha o envio e dispara o processamento | SD05 |
| `GET /sessoes/{id}/video` | Sistema web | Trecho do vídeo (requisição com `Range`) | SD06 |
| `GET /sessoes/{id}/amostras` | Sistema web | Amostras de olhar e de expressão de um trecho | SD06 |
| `GET /sessoes/{id}/resumo` | Sistema web | Resumo por estímulo | SD06 |

As rotas do app usam o token do óculos. As do sistema web usam o JWT do usuário, exceto as do autocadastro e da confirmação de e-mail. A lista completa será documentada em OpenAPI (RNF23).

## Decisões que aparecem nos diagramas

- **O segredo do pareamento vira o token do óculos.** É uma simplificação do OAuth 2.0 Device Authorization Grant (RFC 8628): em vez de emitir um token novo no fim, o servidor ativa o segredo que o app já recebeu.
- **Uma única consulta periódica do óculos** (`GET /dispositivo/proxima-sessao`) serve de sinal de vida, entrega a sessão e transmite o comando de início. Assim, não é preciso WebSocket.
- **O sistema web acompanha o estado consultando a sessão periodicamente**, também sem WebSocket.
- **Os estímulos ficam em cache no óculos**, identificados pelo hash do arquivo, e só são baixados de novo quando mudam.
