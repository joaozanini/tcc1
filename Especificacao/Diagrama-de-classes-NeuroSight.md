# Diagrama de classes do NeuroSight

Versão de trabalho de 26/10/2026. Base: [Requisitos-NeuroSight.md](Requisitos-NeuroSight.md), [Casos-de-uso-e-historias-NeuroSight.md](Casos-de-uso-e-historias-NeuroSight.md) e [Decisoes-tecnicas-NeuroSight.md](Decisoes-tecnicas-NeuroSight.md).

O diagrama está em [Diagrama-de-classes-NeuroSight.drawio](Diagrama-de-classes-NeuroSight.drawio), com duas páginas:

1. **Diagrama de classes do NeuroSight:** todas as classes, com atributos, relações e enumerações.
2. **Tenant e isolamento:** as composições entre o Tenant e as classes que pertencem a ele.

É um modelo de domínio: mostra o que o sistema guarda e como as coisas se relacionam. Tabelas, colunas e chaves ficam para o modelo lógico do banco (próximo artefato).

## Como ler o diagrama

- **«tenant»:** a classe pertence a exatamente um tenant (RN01). As composições com o Tenant estão na página 2, para não cruzar o diagrama principal.
- **{abstrata}, nome em itálico:** SequenciaDeEstimulos não existe sozinha; ModeloDeSessao e Sessao herdam dela.
- **Losango preenchido (composição):** a parte não existe sem o todo, e excluir o todo exclui as partes.
- **Atributo com tipo de classe** (por exemplo, `autor: Usuario` ou `oculos: Dispositivo`): é uma associação mostrada como atributo, para não encher o diagrama de linhas até Usuario.
- **"/" antes do nome:** atributo derivado, calculado a partir de outros.
- **Tipos:** Texto, Inteiro, Decimal, Booleano, Data, DataHora, UUID e JSON. Vetor2 e Vetor3 são pares e trincas de Decimal; `Mapa<Texto, Decimal>` associa um nome a um valor.

## Classes

| Classe | O que representa | Requisitos |
|---|---|---|
| Tenant | Instituição ou grupo de pesquisa; isola os dados dos demais | RF02, RN01 |
| Usuario | Pessoa com conta no tenant, com um perfil | RF04–RF11 |
| TokenDeUsoUnico | Link de uso único e com prazo: confirmação de e-mail, convite e redefinição de senha | RF03, RF05, RF09 |
| Dispositivo | Óculos pareado ao tenant, com o próprio acesso e o estado do rastreamento | RF13–RF16, RF39 |
| SolicitacaoDePareamento | Código que o app mostra antes de o óculos ser pareado; existe antes de haver tenant | RF13, RF14 |
| Paciente | Pessoa que participa dos experimentos, identificada por código | RF17–RF21 |
| Estimulo | Imagem ou vídeo do acervo; pode ser pessoal de um paciente | RF22–RF26 |
| SequenciaDeEstimulos | Lista ordenada de estímulos, com tempos e tela neutra; base de modelos e sessões (UC06.6) | RF27, RF29, RF31 |
| ItemDaSequencia | Um estímulo dentro da sequência, com ordem e duração | RN08, RN10 |
| ModeloDeSessao | Protocolo reutilizável | RF27, RF28 |
| Sessao | Aplicação de uma sequência a um paciente, enviada a um óculos, com estado | RF30–RF37 |
| Anotacao | Observação do pesquisador sobre a sessão | RF57 |
| Coleta | Dados que o óculos envia no fim da sessão | RF48–RF51 |
| EventoDeEstimulo | Instante real de início e de fim de cada estímulo, medido no óculos | RF43 |
| AmostraDeOlhar | Uma leitura do olhar por quadro | RF44 |
| AmostraDeExpressao | Uma leitura das expressões faciais (FACS) | RF45 |
| Gravacao | Vídeo MP4 montado no servidor a partir dos quadros | RF46, RF50 |
| RegistroDeAuditoria | Quem fez o quê, quando e em qual registro | RF59, RF60 |

## Enumerações

| Enumeração | Valores |
|---|---|
| Perfil | PESQUISADOR, ADMINISTRADOR, PROPRIETARIO |
| TipoDeToken | CONFIRMACAO_EMAIL, CONVITE, REDEFINICAO_SENHA |
| TipoDeEstimulo | IMAGEM, VIDEO |
| Sexo | FEMININO, MASCULINO |
| Etiologia | TRAUMATICA, VASCULAR, ANOXICA |
| Diagnostico | COMA, SVNR, EMC |
| EstadoDaSessao | RASCUNHO, ENVIADA_AO_OCULOS, BAIXADA, INICIO_SOLICITADO, EM_EXECUCAO, ENVIANDO, PROCESSANDO, CONCLUIDA, FALHA |
| TipoDeAcao | LOGIN, CRIACAO, EDICAO, EXCLUSAO, ENVIO_DE_SESSAO, INICIO_DE_SESSAO, VISUALIZACAO, EXPORTACAO, MUDANCA_DE_PERMISSAO |

## Regras que o diagrama não mostra

- **RN06, RN07 e RN08** já aparecem no próprio diagrama: Paciente não tem conta nem perfil; toda Sessao pertence a um único Paciente (composição); e toda sessão é uma SequenciaDeEstimulos.
- **RN04:** só o PROPRIETARIO concede ou retira o perfil ADMINISTRADOR. É uma regra de permissão, verificada na API.
- **RN02:** `Usuario.email` é único em todo o sistema.
- **RN03:** cada Tenant tem exatamente um Usuario com perfil PROPRIETARIO.
- **RN05:** os perfis são cumulativos, na ordem PESQUISADOR < ADMINISTRADOR < PROPRIETARIO.
- **Unicidade:** `Paciente.codigo` e `Dispositivo.nome` são únicos dentro do tenant.
- **RN10:** `ItemDaSequencia.duracaoSegundos` é maior que zero.
- **Derivado:** `SequenciaDeEstimulos.duracaoTotalSegundos` é a soma das durações dos itens mais as telas neutras entre eles.
- **RN09 e RN12:** um item só usa estímulo do mesmo tenant e não arquivado. Um estímulo pessoal só entra em sessões do paciente dele e, por isso, não entra em modelos.
- **RN11:** a Sessao copia os itens do modelo; a associação "origem" é só uma referência.
- **RN13:** um estímulo usado em algum item não é excluído, só arquivado.
- **RN14:** um Dispositivo tem no máximo uma Sessao nos estados ENVIADA_AO_OCULOS, BAIXADA, INICIO_SOLICITADO ou EM_EXECUCAO.
- **RN15:** a sessão só passa para INICIO_SOLICITADO a partir de BAIXADA, com o dispositivo online.
- **RN16:** os itens da sessão só podem ser alterados em RASCUNHO.
- **RN17:** a Coleta e suas partes não podem ser alteradas. As anotações e os dados descritivos da sessão (`diagnosticoNoDia` e `escoreCrsRNoDia`) podem.
- **RN18:** veem a sessão quem a criou (`criadaPor`), o proprietário, os administradores e os usuários em `autorizados`.
- **RN19:** o app recebe só `Paciente.codigo`, nunca o nome.
- **RN20:** RegistroDeAuditoria só aceita inclusão.
- **RF21:** excluir um paciente exclui as sessões dele (composição) e também os estímulos pessoais dele, que não podem estar em sessões de outros pacientes (RN12).
- **Derivado:** `Dispositivo.online` é verdadeiro quando o último contato foi há poucos segundos. A "sessão atual" do óculos (RF15) também é derivada: é a sessão pendente ou em execução que tem esse óculos em `oculos`.
- **Quadros JPEG:** são temporários. Servem para montar a Gravacao e não fazem parte do modelo.
- **Tela neutra:** os intervalos de tela neutra não viram eventos; correspondem aos espaços entre um EventoDeEstimulo e o seguinte.

## Estados da sessão

| De | Evento | Para |
|---|---|---|
| RASCUNHO | Pesquisador envia a sessão a um óculos (UC07.4) | ENVIADA_AO_OCULOS |
| ENVIADA_AO_OCULOS | Óculos termina o download (UC08.1) | BAIXADA |
| BAIXADA | Pesquisador clica em "Iniciar" (UC07.6) | INICIO_SOLICITADO |
| INICIO_SOLICITADO | Óculos confirma o início (RF41) | EM_EXECUCAO |
| INICIO_SOLICITADO | Óculos não confirma em alguns segundos (proposta) | BAIXADA |
| EM_EXECUCAO | Tempo configurado termina e o envio começa (RF48) | ENVIANDO |
| ENVIANDO | Servidor recebe tudo (RF51) | PROCESSANDO |
| PROCESSANDO | Vídeo montado (RF50) | CONCLUIDA |
| PROCESSANDO | Erro na montagem | FALHA |
| ENVIADA_AO_OCULOS ou BAIXADA | Pesquisador cancela (UC07.7) ou o óculos é despareado (UC03.4) | RASCUNHO |
| INICIO_SOLICITADO | Óculos é despareado (UC03.4) | RASCUNHO |

Cancelar devolve a sessão a rascunho, como já acontece quando o óculos é despareado (HU03.4). Assim, o pesquisador pode corrigir a sessão e enviá-la de novo (RN16). O despareamento também vale em INICIO_SOLICITADO, porque a sessão ainda não começou (HU03.4); o cancelamento (UC07.7), não. Esta tabela já serve de base para o diagrama de estados, que é opcional no checklist.

O diagrama de estados está em [Diagrama-de-estados-da-sessao.drawio](Diagrama-de-estados-da-sessao.drawio), com a descrição em [Diagrama-de-estados-da-sessao.md](Diagrama-de-estados-da-sessao.md).

## Para o modelo lógico do banco

Estes pontos foram decididos em [Modelo-logico-relacional-NeuroSight.md](Modelo-logico-relacional-NeuroSight.md):

- Todas as tabelas com dados de um tenant, inclusive as partes, recebem `tenant_id`, com FKs compostas.
- SequenciaDeEstimulos não vira tabela: cada classe concreta tem as suas (`modelo_sessao` + `item_modelo`, `sessao` + `item_sessao`).
- As amostras são importadas do JSON para tabelas, e o JSON original fica guardado.
- `Sessao.autorizados` virou a tabela de ligação `sessao_autorizado`.
