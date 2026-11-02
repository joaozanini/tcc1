# Diagrama de estados da sessão

Versão de trabalho de 28/10/2026. Base: tabela "Estados da sessão" de [Diagrama-de-classes-NeuroSight.md](Diagrama-de-classes-NeuroSight.md) e tipo `estado_sessao` de [Modelo-logico-relacional-NeuroSight.md](Modelo-logico-relacional-NeuroSight.md).

O diagrama está em [Diagrama-de-estados-da-sessao.drawio](Diagrama-de-estados-da-sessao.drawio). É um diagrama de máquina de estados da UML: mostra os estados por que uma Sessao passa, da criação até a conclusão ou a falha, e o que a faz mudar de estado.

## Como ler

- **Círculo preto:** pseudoestado inicial. A sessão nasce em RASCUNHO.
- **Retângulos arredondados:** os estados.
- **Setas:** transições, com o rótulo no formato `evento [condição de guarda]`. Entre parênteses, o caso de uso ou o requisito indicado na tabela.
- **Círculo com anel:** estado final. CONCLUIDA e FALHA não têm saída.
- **Nota:** RN16, ligada a EM_EXECUCAO.

## Estados

RASCUNHO, ENVIADA_AO_OCULOS, BAIXADA, INICIO_SOLICITADO, EM_EXECUCAO, ENVIANDO, PROCESSANDO, CONCLUIDA e FALHA: os nove valores do enum EstadoDaSessao e do tipo `estado_sessao`.

## Transições

| De | Evento [guarda] | Para |
|---|---|---|
| RASCUNHO | Pesquisador envia a sessão a um óculos (UC07.4) [óculos sem outra sessão pendente] (RN14) | ENVIADA_AO_OCULOS |
| ENVIADA_AO_OCULOS | Óculos termina o download (UC08.1) | BAIXADA |
| BAIXADA | Pesquisador clica em "Iniciar" (UC07.6) [óculos online] (RN15) | INICIO_SOLICITADO |
| INICIO_SOLICITADO | Óculos confirma o início (RF41) | EM_EXECUCAO |
| INICIO_SOLICITADO | Óculos não confirma em alguns segundos (proposta) | BAIXADA |
| EM_EXECUCAO | Tempo configurado termina e o envio começa (RF48) | ENVIANDO |
| ENVIANDO | Servidor recebe tudo (RF51) | PROCESSANDO |
| PROCESSANDO | Vídeo montado (RF50) | CONCLUIDA |
| PROCESSANDO | Erro na montagem | FALHA |
| ENVIADA_AO_OCULOS | Pesquisador cancela (UC07.7) ou o óculos é despareado (UC03.4) | RASCUNHO |
| BAIXADA | Pesquisador cancela (UC07.7) ou o óculos é despareado (UC03.4) | RASCUNHO |
| INICIO_SOLICITADO | Óculos é despareado (UC03.4) | RASCUNHO |

## De onde saiu

- **Estados, eventos e referências:** da tabela "Estados da sessão", com o mesmo texto. A linha "ENVIADA_AO_OCULOS ou BAIXADA" virou duas transições, uma de cada estado.
- **Despareamento em INICIO_SOLICITADO:** segue a HU03.4, em que sessões "ainda não iniciadas" voltam a ser rascunho. O cancelamento (UC07.7) continua só em ENVIADA_AO_OCULOS e BAIXADA.
- **Guardas:** a tabela não tem coluna de condição. As duas guardas vêm das regras do mesmo documento: RN14 (no máximo uma sessão pendente por óculos, como em HU07.4) e RN15 (o "Iniciar" só é liberado com o óculos online, como em HU07.6).
- **Início:** HU07.1 e HU07.2 ("A sessão nasce como rascunho") e o valor padrão RASCUNHO da coluna `sessao.estado`. A transição inicial não tem evento, como manda a UML.
- **Fim:** a tabela não tem transição a partir de CONCLUIDA nem de FALHA (HU09.2).
- **Nota:** RN16 e HU07.7: depois do início, não é possível cancelar nem interromper a sessão.
