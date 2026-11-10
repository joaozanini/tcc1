# Modelo lógico-relacional do NeuroSight

Versão de trabalho de 26/10/2026. Base: [Diagrama-de-classes-NeuroSight.md](Diagrama-de-classes-NeuroSight.md) e [Decisoes-tecnicas-NeuroSight.md](Decisoes-tecnicas-NeuroSight.md). Banco: PostgreSQL 15 ou mais novo.

O diagrama está em [Modelo-logico-relacional-NeuroSight.drawio](Modelo-logico-relacional-NeuroSight.drawio), em três páginas, uma por assunto:

1. **Experimento:** estímulos, modelos, sessões, pacientes, autorizações e anotações.
2. **Dados coletados:** coleta, eventos, amostras de olhar e de expressão, e gravação.
3. **Acesso, óculos e auditoria:** tenant, usuários, tokens, óculos, pareamento e auditoria.

São 20 tabelas e 8 tipos enumerados.

## Como ler o diagrama

- **Linhas com pé de galinha:** `||` é exatamente um; `o|` é zero ou um; `o<` é zero ou muitos; `|<` é um ou muitos.
- **PK** é chave primária, **FK** é chave estrangeira e **UK** é valor único.
- **Tipo em itálico:** a coluna aceita nulo.
- **Tabela em cinza tracejado:** está detalhada em outra página e aparece só para mostrar a ligação.
- **Ligações não desenhadas:** as FKs para `tenant` (coluna `tenant_id`) e para `usuario` nas colunas de autoria (`enviado_por`, `criado_por`, `criada_por`, `autor_id`) aparecem só nas colunas, para não cruzar o diagrama.

## Decisões de mapeamento

1. **`tenant_id` em todas as tabelas com dados de um tenant, inclusive as tabelas filhas.** O RLS fica simples, sem junções nas políticas.
2. **FKs compostas com o tenant:** por exemplo, `(tenant_id, paciente_id)` aponta para `paciente(tenant_id, id)`. No PostgreSQL, a checagem de FK ignora o RLS. Sem a FK composta, um id de outro tenant enviado por engano ou de propósito seria aceito como referência. Com ela, o próprio banco garante que filho e pai são do mesmo tenant.
3. **A classe abstrata SequenciaDeEstimulos não vira tabela.** Cada classe concreta tem as suas tabelas: `modelo_sessao` + `item_modelo` e `sessao` + `item_sessao`. Assim, a exclusão em cascata é direta (paciente → sessões → itens) e o mapeamento nas entidades do TypeORM fica simples.
4. **As amostras viram tabelas.** No processamento da sessão, o servidor importa o JSON para `amostra_olhar` e `amostra_expressao`, o que facilita os gráficos e o resumo por estímulo (RF55, RF56). O JSON original continua guardado como registro bruto (`coleta.arquivo_json`).
5. **As expressões faciais ficam num vetor** `real[]`, com uma posição por expressão. A ordem das posições fica na tabela `expressao_facial`.
6. **`Sessao.autorizados`** vira a tabela de ligação `sessao_autorizado`.
7. **Outras conversões:**
   - Vetor2 e Vetor3 viram colunas separadas (`uv_camera_u`, `uv_camera_v`, `mundo_x`...).
   - As enumerações viram tipos `ENUM` do PostgreSQL.
   - As datas e horas usam `timestamptz`.
   - Os ids são `uuid`, gerados com `gen_random_uuid()`. As amostras usam `bigint` sequencial, por causa do volume.

## Da classe à tabela

| Classe | Tabela | Observação |
|---|---|---|
| Tenant | `tenant` | |
| Usuario | `usuario` | |
| TokenDeUsoUnico | `token_uso_unico` | |
| Dispositivo | `dispositivo` | `online` não é guardado: é calculado a partir de `ultimo_contato` |
| SolicitacaoDePareamento | `solicitacao_pareamento` | Sem `tenant_id`: existe antes do pareamento |
| Paciente | `paciente` | |
| Estimulo | `estimulo` | `etiquetas` é `text[]` |
| SequenciaDeEstimulos | — | Abstrata: as colunas aparecem em `modelo_sessao` e em `sessao` |
| ItemDaSequencia | `item_modelo` e `item_sessao` | |
| ModeloDeSessao | `modelo_sessao` | |
| Sessao | `sessao` e `sessao_autorizado` | `oculos` vira `dispositivo_id` e "origem" vira `modelo_origem_id` |
| Anotacao | `anotacao` | |
| Coleta | `coleta` | A chave primária é o próprio `sessao_id` (relação 1 para 0..1) |
| EventoDeEstimulo | `evento_estimulo` | `item` vira `(coleta_id, ordem)` → `item_sessao(sessao_id, ordem)` |
| AmostraDeOlhar | `amostra_olhar` | |
| AmostraDeExpressao | `amostra_expressao` e `expressao_facial` | `Mapa<Texto, Decimal>` vira `real[]` |
| Gravacao | `gravacao` | A chave primária é o próprio `coleta_id` |
| RegistroDeAuditoria | `registro_auditoria` | `detalhes` é `jsonb` |

## Tipos enumerados

```sql
CREATE TYPE perfil        AS ENUM ('PESQUISADOR', 'ADMINISTRADOR', 'PROPRIETARIO');
CREATE TYPE tipo_token    AS ENUM ('CONFIRMACAO_EMAIL', 'CONVITE', 'REDEFINICAO_SENHA');
CREATE TYPE tipo_estimulo AS ENUM ('IMAGEM', 'VIDEO');
CREATE TYPE sexo          AS ENUM ('FEMININO', 'MASCULINO');
CREATE TYPE etiologia     AS ENUM ('TRAUMATICA', 'VASCULAR', 'ANOXICA');
CREATE TYPE diagnostico   AS ENUM ('COMA', 'SVNR', 'EMC');
CREATE TYPE estado_sessao AS ENUM ('RASCUNHO', 'ENVIADA_AO_OCULOS', 'BAIXADA', 'INICIO_SOLICITADO',
                                   'EM_EXECUCAO', 'ENVIANDO', 'PROCESSANDO', 'CONCLUIDA', 'FALHA');
CREATE TYPE tipo_acao     AS ENUM ('LOGIN', 'CRIACAO', 'EDICAO', 'EXCLUSAO', 'ENVIO_DE_SESSAO',
                                   'INICIO_DE_SESSAO', 'VISUALIZACAO', 'EXPORTACAO', 'MUDANCA_DE_PERMISSAO');
```

## Isolamento por tenant (RLS)

O banco tem três papéis:

- **`neurosight_owner`:** é o dono das tabelas e só roda as migrações.
- **`neurosight_api`:** é o papel usado pela API. Não é dono das tabelas nem tem `BYPASSRLS`.
- **`neurosight_auth`:** tem `BYPASSRLS` e é usado só no login, no autocadastro, nos tokens de uso único e no pareamento. Esses fluxos acontecem antes de existir tenant no contexto.

Em cada tabela com `tenant_id`, a política é esta:

```sql
ALTER TABLE paciente ENABLE ROW LEVEL SECURITY;
ALTER TABLE paciente FORCE ROW LEVEL SECURITY;
CREATE POLICY isolamento_tenant ON paciente
  USING      (tenant_id = current_setting('app.tenant_id', true)::uuid)
  WITH CHECK (tenant_id = current_setting('app.tenant_id', true)::uuid);

-- FK composta: o filho só aponta para um pai do mesmo tenant
ALTER TABLE paciente ADD UNIQUE (tenant_id, id);
ALTER TABLE sessao ADD FOREIGN KEY (tenant_id, paciente_id)
  REFERENCES paciente (tenant_id, id) ON DELETE CASCADE;
```

- **Como a API informa o tenant:** em cada transação, a API executa `set_config('app.tenant_id', <tenant do token>, true)`. O valor vale só para a transação e não passa para outras conexões do pool. Sem ele, a política não devolve nenhuma linha.
- **Exceções à política:**
  - `tenant` usa a política `id = current_setting('app.tenant_id', true)::uuid`.
  - `solicitacao_pareamento` não tem `tenant_id` e só é acessada pelo papel `neurosight_auth`.
  - `expressao_facial` é uma tabela de referência global, só de leitura.
- **Permissões que garantem as regras de imutabilidade:**
  - RN20: o papel `neurosight_api` não tem `UPDATE` nem `DELETE` em `registro_auditoria`.
  - RN17: o papel `neurosight_api` não tem `UPDATE` em `coleta`, `evento_estimulo`, `amostra_olhar`, `amostra_expressao` e `gravacao`.

## Restrições e índices

| Restrição ou índice | Regra |
|---|---|
| `UNIQUE INDEX ON usuario (lower(email))` | RN02: e-mail único no sistema, sem diferenciar maiúsculas |
| `UNIQUE INDEX ON usuario (tenant_id) WHERE perfil = 'PROPRIETARIO'` | RN03: no máximo um proprietário por tenant (o autocadastro cria exatamente um) |
| `UNIQUE (tenant_id, codigo)` em `paciente` | Código do paciente único no tenant |
| `UNIQUE (tenant_id, nome)` em `dispositivo` | Nome do óculos único no tenant |
| `UNIQUE INDEX ON sessao (dispositivo_id) WHERE estado IN ('ENVIADA_AO_OCULOS', 'BAIXADA', 'INICIO_SOLICITADO', 'EM_EXECUCAO')` | RN14: no máximo uma sessão pendente por óculos |
| `UNIQUE (tenant_id, id)` em `usuario`, `dispositivo`, `paciente`, `estimulo`, `modelo_sessao` e `sessao`; `UNIQUE (tenant_id, sessao_id)` em `coleta` | Necessários para as FKs compostas |
| `CHECK (duracao_segundos > 0)` e `CHECK (ordem >= 1)` em `item_modelo` e `item_sessao` | RN10 |
| `CHECK (tela_neutra_segundos >= 0)` em `modelo_sessao` e `sessao` | Tela neutra (RF29) |
| `CHECK (escore_crs_r BETWEEN 0 AND 23)` em `paciente`; idem para `escore_crs_r_no_dia` em `sessao` | Faixa da CRS-R |
| `CHECK (ano_nascimento BETWEEN 1900 AND 2100)` em `paciente` | Valor plausível |
| `CHECK (formato IN ('image/jpeg', 'image/png', 'video/mp4'))` e `CHECK (tamanho_bytes > 0)` em `estimulo` | RNF19 |
| `CHECK ((tipo = 'VIDEO') = (duracao_segundos IS NOT NULL))` em `estimulo` | Só vídeo tem duração |
| `CHECK (fim_s >= inicio_s)` em `evento_estimulo` | Intervalo válido |
| `CHECK (confianca BETWEEN 0 AND 1)` em `amostra_olhar` | Faixa da confiança |
| `CHECK (fps > 0 AND largura > 0 AND altura > 0 AND total_quadros >= 0)` em `gravacao` | Valores plausíveis |
| `CHECK (expira_em > criada_em)` em `solicitacao_pareamento` | Prazo válido |
| `UNIQUE (dispositivo_id)` em `solicitacao_pareamento` | Uma solicitação gera no máximo um óculos |
| `GIN (etiquetas)` em `estimulo` | Busca por etiqueta (RF23) |
| `INDEX (coleta_id, t_s)` em `amostra_olhar` e `amostra_expressao` | Leitura das amostras por trecho de tempo (heatmap, gráficos e resumo) |
| `INDEX (tenant_id, paciente_id)` e `INDEX (tenant_id, estado)` em `sessao` | Filtros da lista de sessões (RF37) |
| `INDEX (tenant_id, data_hora DESC)` em `registro_auditoria` | Consulta por período (RF60) |

Não há `CHECK` para o tamanho de `intensidades`, porque o número de expressões depende da versão do SDK da Meta. A importação confere se o vetor tem o mesmo tamanho que `expressao_facial`.

## Exclusões em cascata

| FK | Ao excluir o pai |
|---|---|
| `sessao` → `paciente` | `CASCADE`: excluir o paciente exclui as sessões dele (RF21) |
| `estimulo.paciente_id` → `paciente` | `CASCADE`: os estímulos pessoais vão junto (RF21, RN12) |
| `item_modelo` → `modelo_sessao`; `item_sessao`, `sessao_autorizado`, `anotacao` e `coleta` → `sessao` | `CASCADE` |
| `evento_estimulo`, `amostra_olhar`, `amostra_expressao` e `gravacao` → `coleta` | `CASCADE` |
| `token_uso_unico` → `usuario`; `sessao_autorizado` → `usuario` | `CASCADE` |
| `sessao.modelo_origem_id` → `modelo_sessao` | `SET NULL (modelo_origem_id)`: a sessão continua com a própria cópia dos itens (RN11). A sintaxe com lista de colunas exige PostgreSQL 15 |
| `sessao.dispositivo_id` → `dispositivo`; `solicitacao_pareamento.dispositivo_id` → `dispositivo` | `SET NULL` (só da coluna do dispositivo) |
| `item_modelo` e `item_sessao` → `estimulo`; `evento_estimulo` → `item_sessao` | `NO ACTION`: um estímulo em uso não é excluído (RN13). `NO ACTION`, e não `RESTRICT`, porque a checagem acontece no fim do comando, depois das cascatas de RF21 |
| Colunas de autoria e de auditoria → `usuario` e `dispositivo`; todas as `tenant_id` → `tenant` | `NO ACTION`: usuários e óculos são desativados ou revogados, não excluídos |

## Dicionário de dados

Nas tabelas abaixo, "Nulo" indica se a coluna aceita nulo. Os valores padrão aparecem na descrição.

### tenant

| Coluna | Tipo | Nulo | Chave | Descrição |
|---|---|---|---|---|
| id | uuid | não | PK | Identificador |
| nome | text | não | | Nome da instituição ou do grupo |
| criado_em | timestamptz | não | | Data do autocadastro; padrão `now()` |

### usuario

| Coluna | Tipo | Nulo | Chave | Descrição |
|---|---|---|---|---|
| id | uuid | não | PK | Identificador |
| tenant_id | uuid | não | FK | Tenant do usuário (RN02) |
| nome | text | não | | Nome |
| email | text | não | UK | E-mail de login, único no sistema (RN02) |
| senha_hash | text | sim | | Hash Argon2 ou bcrypt (RNF03); nulo até o convidado definir a senha |
| perfil | perfil | não | | PESQUISADOR, ADMINISTRADOR ou PROPRIETARIO (RN05); padrão PESQUISADOR |
| ativo | boolean | não | | Falso quando desativado (HU02.4); padrão verdadeiro |
| email_confirmado | boolean | não | | Confirmação de e-mail (RF03); padrão falso |
| criado_em | timestamptz | não | | Data do cadastro; padrão `now()` |

### token_uso_unico

| Coluna | Tipo | Nulo | Chave | Descrição |
|---|---|---|---|---|
| id | uuid | não | PK | Identificador |
| tenant_id | uuid | não | FK | Tenant do usuário |
| usuario_id | uuid | não | FK | Dono do token |
| tipo | tipo_token | não | | Confirmação de e-mail, convite ou redefinição de senha |
| hash | text | não | UK | Hash do token enviado por e-mail; o token em si nunca é guardado |
| expira_em | timestamptz | não | | Prazo de validade |
| usado_em | timestamptz | sim | | Preenchido no uso; um token usado não vale mais |

### dispositivo

| Coluna | Tipo | Nulo | Chave | Descrição |
|---|---|---|---|---|
| id | uuid | não | PK | Identificador |
| tenant_id | uuid | não | FK | Tenant ao qual o óculos foi pareado |
| nome | text | não | | Nome dado pelo administrador, único no tenant |
| token_hash | text | não | UK | Hash do token de acesso do óculos (RNF04); é o hash do segredo da solicitação de pareamento (SD02) |
| pareado_em | timestamptz | não | | Data do pareamento; padrão `now()` |
| ultimo_contato | timestamptz | sim | | Última consulta do óculos ao servidor; base do "online" (RF15) |
| rastreamento_ocular_ativo | boolean | não | | Informado pelo app (RF39); padrão falso |
| rastreamento_facial_ativo | boolean | não | | Informado pelo app (RF39); padrão falso |
| versao_app | text | não | | Versão do app no óculos |
| revogado_em | timestamptz | sim | | Preenchido ao desfazer o pareamento (RF16) |

### solicitacao_pareamento

| Coluna | Tipo | Nulo | Chave | Descrição |
|---|---|---|---|---|
| id | uuid | não | PK | Identificador |
| codigo | text | não | UK | Código curto mostrado no óculos (RF13) |
| segredo_hash | text | não | | Hash do segredo entregue ao app na solicitação; depois da confirmação, o segredo passa a ser o token do óculos (SD02) |
| criada_em | timestamptz | não | | Padrão `now()` |
| expira_em | timestamptz | não | | Prazo do código (poucos minutos) |
| confirmada_em | timestamptz | sim | | Quando o administrador digitou o código |
| dispositivo_id | uuid | sim | FK | Óculos criado na confirmação; único |

### paciente

| Coluna | Tipo | Nulo | Chave | Descrição |
|---|---|---|---|---|
| id | uuid | não | PK | Identificador |
| tenant_id | uuid | não | FK | Tenant |
| codigo | text | não | UK | Código do paciente, único no tenant; é o único dado exibido no óculos (RN19) |
| nome | text | sim | | Opcional (RF17) |
| ano_nascimento | smallint | sim | | |
| sexo | sexo | sim | | |
| etiologia | etiologia | sim | | Traumática, vascular ou anóxica |
| data_lesao | date | sim | | |
| diagnostico_atual | diagnostico | sim | | Coma, SVNR ou EMC |
| escore_crs_r | smallint | sim | | 0 a 23 |
| observacoes | text | sim | | |

### estimulo

| Coluna | Tipo | Nulo | Chave | Descrição |
|---|---|---|---|---|
| id | uuid | não | PK | Identificador |
| tenant_id | uuid | não | FK | Tenant |
| nome | text | não | | |
| descricao | text | sim | | |
| etiquetas | text[] | não | | Etiquetas de busca; padrão vazio |
| tipo | tipo_estimulo | não | | Imagem ou vídeo |
| formato | text | não | | `image/jpeg`, `image/png` ou `video/mp4` (RNF19) |
| tamanho_bytes | bigint | não | | Tamanho do arquivo |
| duracao_segundos | numeric(8,3) | sim | | Só para vídeo |
| arquivo | text | não | | Caminho do arquivo no armazenamento (`/dados/<tenant_id>/...`) |
| hash_arquivo | text | não | | SHA-256 do arquivo; o óculos usa para não baixar de novo |
| arquivado | boolean | não | | Arquivado sai das novas sessões (RF26); padrão falso |
| enviado_em | timestamptz | não | | Padrão `now()` |
| enviado_por | uuid | não | FK | Usuário que enviou |
| paciente_id | uuid | sim | FK | Preenchido quando o estímulo é pessoal (RF25, RN12) |

### modelo_sessao

| Coluna | Tipo | Nulo | Chave | Descrição |
|---|---|---|---|---|
| id | uuid | não | PK | Identificador |
| tenant_id | uuid | não | FK | Tenant |
| nome | text | não | | |
| descricao | text | sim | | |
| tela_neutra_segundos | numeric(6,2) | sim | | Tela neutra entre estímulos (RF29) |
| criado_em | timestamptz | não | | Padrão `now()` |
| criado_por | uuid | não | FK | Usuário que criou |

### item_modelo

| Coluna | Tipo | Nulo | Chave | Descrição |
|---|---|---|---|---|
| modelo_id | uuid | não | PK FK | Modelo |
| ordem | smallint | não | PK | Posição na sequência, a partir de 1 |
| tenant_id | uuid | não | FK | Tenant |
| estimulo_id | uuid | não | FK | Estímulo exibido; não pode ser pessoal |
| duracao_segundos | numeric(6,2) | não | | Tempo de exibição, maior que zero (RN10) |

### sessao

| Coluna | Tipo | Nulo | Chave | Descrição |
|---|---|---|---|---|
| id | uuid | não | PK | Identificador |
| tenant_id | uuid | não | FK | Tenant |
| paciente_id | uuid | não | FK | Paciente da sessão (RN07) |
| modelo_origem_id | uuid | sim | FK | Modelo de origem, só como referência (RN11) |
| dispositivo_id | uuid | sim | FK | Óculos de destino |
| estado | estado_sessao | não | | Estado da sessão (RF34); padrão RASCUNHO |
| tela_neutra_segundos | numeric(6,2) | sim | | Copiada do modelo ou definida na hora |
| diagnostico_no_dia | diagnostico | sim | | Estado clínico do dia (RF32) |
| escore_crs_r_no_dia | smallint | sim | | 0 a 23 (RF32) |
| criada_em | timestamptz | não | | Padrão `now()` |
| criada_por | uuid | não | FK | Quem criou; vê a sessão por padrão (RN18) |
| enviada_em | timestamptz | sim | | Envio ao óculos |
| iniciada_em | timestamptz | sim | | Confirmação do início pelo óculos |
| encerrada_em | timestamptz | sim | | Fim da execução |
| concluida_em | timestamptz | sim | | Fim do processamento |

### item_sessao

| Coluna | Tipo | Nulo | Chave | Descrição |
|---|---|---|---|---|
| sessao_id | uuid | não | PK FK | Sessão |
| ordem | smallint | não | PK | Posição na sequência, a partir de 1 |
| tenant_id | uuid | não | FK | Tenant |
| estimulo_id | uuid | não | FK | Estímulo exibido (RN09, RN12) |
| duracao_segundos | numeric(6,2) | não | | Tempo de exibição, maior que zero (RN10) |

### sessao_autorizado

| Coluna | Tipo | Nulo | Chave | Descrição |
|---|---|---|---|---|
| sessao_id | uuid | não | PK FK | Sessão |
| usuario_id | uuid | não | PK FK | Usuário liberado pelo administrador (RF12, RN18) |
| tenant_id | uuid | não | FK | Tenant |

### anotacao

| Coluna | Tipo | Nulo | Chave | Descrição |
|---|---|---|---|---|
| id | uuid | não | PK | Identificador |
| tenant_id | uuid | não | FK | Tenant |
| sessao_id | uuid | não | FK | Sessão |
| autor_id | uuid | não | FK | Autor da anotação |
| texto | text | não | | Conteúdo (RF57) |
| criada_em | timestamptz | não | | Padrão `now()` |
| editada_em | timestamptz | sim | | Última edição |

### coleta

| Coluna | Tipo | Nulo | Chave | Descrição |
|---|---|---|---|---|
| sessao_id | uuid | não | PK FK | Sessão de origem (relação 1 para 0..1) |
| tenant_id | uuid | não | FK | Tenant |
| versao_app | text | não | | Versão do app que coletou |
| fov_captura_graus | numeric(5,2) | não | | Campo de visão da câmera de captura |
| arquivo_json | text | não | | Caminho do JSON original, guardado sem alteração (RN17) |
| recebida_em | timestamptz | não | | Fim do envio; padrão `now()` |

### evento_estimulo

| Coluna | Tipo | Nulo | Chave | Descrição |
|---|---|---|---|---|
| coleta_id | uuid | não | PK FK | Coleta; com `ordem`, aponta para `item_sessao` |
| ordem | smallint | não | PK FK | Item exibido |
| tenant_id | uuid | não | FK | Tenant |
| inicio_s | double precision | não | | Início real, em segundos desde o começo da sessão (RF43) |
| fim_s | double precision | não | | Fim real, em segundos |

### amostra_olhar

| Coluna | Tipo | Nulo | Chave | Descrição |
|---|---|---|---|---|
| id | bigint | não | PK | Sequencial |
| tenant_id | uuid | não | FK | Tenant |
| coleta_id | uuid | não | FK | Coleta |
| t_s | double precision | não | | Instante da amostra, em segundos (RNF16) |
| valida | boolean | não | | Falso em piscadas ou sem dado válido |
| confianca | real | sim | | 0 a 1 |
| mundo_x, mundo_y, mundo_z | real | sim | | Ponto 3D olhado |
| uv_camera_u, uv_camera_v | real | sim | | Posição na câmera de captura, de 0 a 1 |
| uv_estimulo_u, uv_estimulo_v | real | sim | | Posição no estímulo, de 0 a 1; nulo com o olhar fora do estímulo |

### amostra_expressao

| Coluna | Tipo | Nulo | Chave | Descrição |
|---|---|---|---|---|
| id | bigint | não | PK | Sequencial |
| tenant_id | uuid | não | FK | Tenant |
| coleta_id | uuid | não | FK | Coleta |
| t_s | double precision | não | | Instante da amostra, em segundos (RNF16) |
| valida | boolean | não | | Validade informada pelo SDK |
| intensidades | real[] | não | | Uma intensidade (0 a 1) por expressão, na ordem de `expressao_facial.indice` |

### expressao_facial

| Coluna | Tipo | Nulo | Chave | Descrição |
|---|---|---|---|---|
| indice | smallint | não | PK | Posição no vetor `intensidades` |
| nome | text | não | UK | Nome da expressão FACS (ex.: `EYES_CLOSED_L`) |

### gravacao

| Coluna | Tipo | Nulo | Chave | Descrição |
|---|---|---|---|---|
| coleta_id | uuid | não | PK FK | Coleta (relação 1 para 0..1) |
| tenant_id | uuid | não | FK | Tenant |
| arquivo_video | text | não | | Caminho do MP4 montado no servidor (RF50) |
| fps | numeric(5,2) | não | | Quadros por segundo |
| largura | smallint | não | | Em pixels |
| altura | smallint | não | | Em pixels |
| total_quadros | integer | não | | Quadros recebidos |

### registro_auditoria

| Coluna | Tipo | Nulo | Chave | Descrição |
|---|---|---|---|---|
| id | uuid | não | PK | Identificador |
| tenant_id | uuid | não | FK | Tenant |
| data_hora | timestamptz | não | | Padrão `now()` |
| acao | tipo_acao | não | | Tipo de ação (RF59) |
| entidade | text | não | | Tabela afetada (ex.: `sessao`) |
| id_entidade | uuid | sim | | Registro afetado; sem FK, para o registro sobreviver à exclusão |
| detalhes | jsonb | sim | | Dados extras (ex.: perfil antigo e novo) |
| usuario_id | uuid | sim | FK | Quem fez, quando foi um usuário |
| dispositivo_id | uuid | sim | FK | Quem fez, quando foi o óculos |
