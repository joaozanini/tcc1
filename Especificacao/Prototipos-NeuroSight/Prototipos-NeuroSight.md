# Protótipos de tela do NeuroSight

Versão de trabalho de 26/10/2026. Base: [Casos-de-uso-e-historias-NeuroSight.md](../Casos-de-uso-e-historias-NeuroSight.md), [Requisitos-NeuroSight.md](../Requisitos-NeuroSight.md) e [Diagramas-de-sequencia-NeuroSight.md](../Diagramas-de-sequencia-NeuroSight.md).

São 19 telas: 14 do sistema web e 5 do app no óculos. São protótipos de média fidelidade: mostram o conteúdo, a organização e as ações de cada tela, com dados fictícios. O visual final pode mudar no desenvolvimento (TCC2).

## Arquivos

- **[Prototipos-NeuroSight.html](Prototipos-NeuroSight.html):** todas as telas numa página só. Abra no navegador.
  - A página começa com a lista das telas. Clicar numa delas mostra só aquela tela, no tamanho real.
  - Os menus e os botões levam às outras telas, como num protótipo navegável. Por exemplo, "Iniciar sessão" (W10) leva à visão do paciente no óculos (A4).
  - O botão Voltar do navegador volta à tela anterior. Para ver a lista de novo, apague o `#...` do endereço.
- **[imagens](imagens):** uma imagem PNG por tela, com o dobro da resolução (2880 × 1800 no web e 2560 × 1440 no óculos), boa para impressão.
- **[gerar-imagens.ps1](gerar-imagens.ps1):** gera as imagens de novo depois de uma alteração no HTML. Usa o Microsoft Edge, que já vem no Windows.

Para rodar o script, abra o PowerShell na pasta do TCC:

```powershell
powershell -ExecutionPolicy Bypass -File .\Prototipos-NeuroSight\gerar-imagens.ps1
```

## Telas do sistema web

| Tela | Imagem | Usuário logado | Casos de uso | O que mostra |
|---|---|---|---|---|
| W01 Página de apresentação | `W01-apresentacao.png` | Nenhum (visitante) | UC01.1 | O que o sistema faz, o acesso ao autocadastro e ao login e o aviso de que o sistema não faz diagnóstico |
| W02 Criar a conta do grupo | `W02-criar-conta.png` | Nenhum | UC01.2, UC01.3 | Autocadastro do tenant: quem cria vira proprietário e precisa confirmar o e-mail |
| W03 Entrar | `W03-entrar.png` | Nenhum | UC01.4, UC01.5 | Login e "Esqueci minha senha" |
| W04 Pacientes | `W04-pacientes.png` | Ana Lima (proprietária) | UC04.3 | Lista com busca por código e filtros por diagnóstico e etiologia |
| W05 Paciente | `W05-paciente.png` | Ana Lima | UC04.1, UC04.2, UC04.4, UC04.5 | Os campos do RF17, o histórico de sessões, os estímulos pessoais e a exclusão |
| W06 Estímulos | `W06-estimulos.png` | Ana Lima | UC05.1 a UC05.5 | Acervo com envio, etiquetas e filtros (pessoais e arquivados) |
| W07 Modelo de sessão | `W07-modelo-de-sessao.png` | Ana Lima | UC06.1, UC06.3, UC06.4, UC06.6, UC06.7 | Sequência com o tempo de cada estímulo, a tela neutra e a duração total. Os estímulos pessoais aparecem bloqueados (RN12) |
| W08 Nova sessão | `W08-nova-sessao.png` | Carla Mendes (pesquisadora) | UC07.1 a UC07.4 | Paciente, estado clínico do dia, óculos de destino e sequência ajustada a partir de um modelo |
| W09 Sessões | `W09-sessoes.png` | Ana Lima | UC07.8 | Lista com filtros por paciente, estado e período (RF37) |
| W10 Sessão pronta para iniciar | `W10-sessao-pronta.png` | Ana Lima | UC07.5, UC07.6, UC07.7, UC02.6 | O botão "Iniciar sessão" (RN15), o andamento pelos estados, o cancelamento e quem pode ver a sessão |
| W11 Análise da sessão | `W11-analise-da-sessao.png` | Carla Mendes | UC10.1 a UC10.7 | Vídeo com heatmap e ajustes, modo validação, linha do tempo dos estímulos, resumo por estímulo, gráfico das expressões, anotações e exportação |
| W12 Óculos e pareamento | `W12-oculos-e-pareamento.png` | Ana Lima | UC03.1 a UC03.4 | Lista dos óculos (RF15) e a janela de pareamento, com o código que aparece no óculos (A1) |
| W13 Usuários | `W13-usuarios.png` | Ana Lima | UC02.1 a UC02.5, UC01.8 | Convite, edição, desativação, perfis e transferência de propriedade |
| W14 Auditoria | `W14-auditoria.png` | Ana Lima | UC11.1, UC11.2 | Registros com filtros por usuário, ação e período, incluindo uma ação feita pelo óculos |

Usuários diferentes aparecem logados para mostrar os perfis. A pesquisadora (W08 e W11) não vê o grupo Administração no menu.

## Telas do app no óculos

| Tela | Imagem | Casos de uso | O que mostra |
|---|---|---|---|
| A1 Código de pareamento | `A1-codigo-de-pareamento.png` | UC03.1 (RF13) | O código que o administrador digita na tela W12 |
| A2 Aguardando sessão | `A2-aguardando-sessao.png` | UC08.1, UC08.2 | Óculos pareado, consultando o servidor, com o estado do rastreamento (RF39) |
| A3 Sessão pronta | `A3-sessao-pronta.png` | UC08.1 (RF40, RN19) | Código do paciente, número de estímulos e duração, à espera do "Iniciar" no sistema web |
| A4 Execução | `A4-execucao.png` | UC08.3 a UC08.6 | O que o paciente vê: só o estímulo, sem texto nem botão |
| A5 Envio dos dados | `A5-envio-dos-dados.png` | UC09.1 (RF48, RF49, RNF10) | O progresso do envio; o pesquisador já pode retirar o óculos |

O app não tem botões, porque o pesquisador não usa o controle em nenhuma etapa (RNF22). A1, A2, A3 e A5 são painéis no ambiente virtual, vistos por quem coloca o óculos. A4 é a visão do paciente durante a sessão.

## Casos de uso sem tela própria

Estes casos de uso não ganharam tela porque repetem padrões já mostrados:

- **UC01.6 Alterar meus dados e senha e UC01.7 Alterar dados do tenant:** formulários simples, como o de W05.
- **UC02.2 Enviar convite por e-mail:** é um e-mail, disparado pelo botão "Convidar usuário" de W13.
- **UC05.3 Editar informações do estímulo:** formulário com nome, descrição e etiquetas, aberto ao clicar num estímulo em W06.
- **UC06.2 Consultar modelos e UC06.5 Excluir modelo:** lista no mesmo padrão de W09.
- **UC09.2 Processar dados recebidos:** roda no servidor. Aparece nos estados "Processando", "Concluída" e "Falha" de W09 e W10.

## Dados fictícios

Todos os dados são inventados e batem de uma tela para outra.

- **Grupo:** Grupo de Pesquisa em Neurorreabilitação.
- **Usuários:** Ana Lima (proprietária), Bruno Rocha (administrador), Carla Mendes e Diego Alves (pesquisadores), Fábio Nunes (convite pendente) e Elisa Prado (desativada).
- **Paciente principal:** P-012 (EMC, CRS-R 11, lesão traumática).
- **Sessões:**
  - S-0042: baixada no Quest do laboratório 1 e pronta para iniciar (W10 e A3);
  - S-0041: concluída, usada na análise (W11);
  - S-0044: em execução no Quest do laboratório 2.
- **Sequência de S-0041 e S-0042:** 8 estímulos de 30 s com tela neutra de 5 s entre eles, ou seja, 4 min 35 s no total.
- **Estímulos:** desenhos genéricos, sem fotos nem rostos de pessoas reais.

## Como usar no TCC

- **No TCC1:** os protótipos entram como artefato de modelagem. Cite-os na Seção III, junto com os outros artefatos, e ponha as imagens no apêndice ou no link da documentação completa.
- **Se quiser alguma tela no corpo do artigo:** as que mais explicam o sistema são W10 (início da sessão pelo sistema web), W11 (análise) e A3 (sessão pronta no óculos).
  - Legenda acima: "FIGURA n - Protótipo da tela de análise da sessão."
  - Abaixo: "FONTE: O autor (2026)".
- **No TCC2:** a Seção IV.B (Apresentação do Sistema) mostra as telas reais, e os protótipos servem de comparação.

## Ferramenta

O arquivo de decisões citava o Figma para os protótipos. Eles foram feitos em HTML e CSS, sem JavaScript, para serem navegáveis e gerarem todas as imagens no mesmo tamanho. Se o orientador pedir Figma, as imagens PNG podem ser importadas como quadros. Também existem plugins que importam páginas web para o Figma (como o html.to.design), mas não foram testados com este arquivo.
