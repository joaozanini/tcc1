# Histórias de usuário do NeuroSight (refeitas do zero)

Versão de 03/11/2026. Lista escrita de novo a partir dos atores, dos requisitos funcionais (RF01–RF60), das regras de negócio e dos requisitos não funcionais de [Requisitos-NeuroSight.md](Requisitos-NeuroSight.md), sem usar [Casos-de-uso-e-historias-NeuroSight.md](Casos-de-uso-e-historias-NeuroSight.md) como base. Serve para comparar com a lista oficial e decidir se algo muda lá.

Formato: **Sendo** (ator), **quero** (ação), **para** (motivo). Depois de cada história, os requisitos que ela cobre e os critérios de aceitação principais. Agrupadas por ator, e não por grupo de requisitos, para a derivação ficar independente da lista atual.

Os perfis são cumulativos (RN05): tudo o que o pesquisador faz, o administrador e o proprietário também fazem; tudo o que o administrador faz, o proprietário também faz. O paciente não é usuário (RN06) e por isso não tem histórias próprias: o que acontece no óculos é contado do ponto de vista do pesquisador, que é quem precisa que aquilo aconteça.

## Visitante (sem conta)

**H01 – Conhecer o sistema.** Sendo visitante, quero uma página que explique o que o NeuroSight faz e o que não faz, para decidir se ele serve ao meu grupo. *RF01.*
- A página deixa claro que o sistema não faz diagnóstico.
- A página leva ao autocadastro e ao login.

**H02 – Criar o espaço do meu grupo.** Sendo visitante, quero criar um tenant informando a instituição ou o grupo, meu nome, meu e-mail e uma senha, para usar o sistema sem precisar de uma instalação própria. *RF02, RN01, RN03, RNF25.*
- Quem cria o tenant vira o seu único proprietário.
- O tenant nasce vazio e não enxerga dados de nenhum outro.

**H03 – Confirmar meu e-mail.** Sendo visitante que acabou de criar um tenant, quero confirmar meu e-mail por um link, para provar que a conta é minha antes de entrar. *RF03.*
- O link expira; sem confirmar, o login é recusado.

## Usuário (qualquer pessoa com conta)

**H04 – Entrar e sair.** Sendo usuário, quero entrar com e-mail e senha e sair quando terminar, para acessar só os dados do meu tenant. *RF04, RN01, RN02, RNF03, RNF04.*
- A mensagem de erro não diz se o problema foi o e-mail ou a senha.
- Cada entrada fica na auditoria.

**H05 – Recuperar a senha.** Sendo usuário, quero receber por e-mail um link para redefinir a senha, para voltar a entrar se eu a esquecer. *RF05.*
- O link é de uso único e expira; a tela não revela se o e-mail existe.

**H06 – Manter minha conta.** Sendo usuário, quero alterar meus dados e minha senha, para manter a conta atualizada. *RF06.*
- Trocar a senha exige a senha atual.

**H07 – Aceitar o convite.** Sendo pessoa convidada por um administrador, quero definir minha própria senha a partir do link do convite, para ninguém mais conhecer a senha da minha conta. *RF09.*
- O link é de uso único e expira.

## Proprietário

**H08 – Alterar os dados do tenant.** Sendo proprietário, quero corrigir o nome da instituição ou do grupo, para o tenant ficar identificado certo. *RF07.*

**H09 – Escolher os administradores.** Sendo proprietário, quero dar e tirar o perfil de administrador, para decidir quem gerencia o grupo. *RF11, RN04.*
- Só o proprietário faz isso; a mudança vai para a auditoria.

**H10 – Passar a propriedade adiante.** Sendo proprietário, quero transferir a propriedade do tenant a um administrador, para o grupo continuar gerido se eu sair. *RF08, RN03.*
- Depois da transferência, continuo como administrador e o tenant segue com um único proprietário.

## Administrador

**H11 – Cadastrar pessoas da equipe.** Sendo administrador, quero cadastrar usuários com nome, e-mail e perfil, para a equipe usar o sistema. *RF09, RN02, RN04.*
- O e-mail não pode estar em uso; a pessoa recebe o convite (H07).
- Só o proprietário pode cadastrar alguém já como administrador.

**H12 – Ver quem tem acesso.** Sendo administrador, quero a lista de usuários do tenant, com perfil e situação, para saber quem acessa o quê. *RF10.*

**H13 – Corrigir um usuário.** Sendo administrador, quero editar nome e perfil de um usuário, para refletir mudanças de função. *RF10, RN04.*
- O perfil de administrador só muda pelas mãos do proprietário (H09).

**H14 – Desativar um usuário.** Sendo administrador, quero desativar quem saiu do grupo, para cortar o acesso sem apagar o histórico. *RF10.*
- Usuário desativado não entra; a auditoria dele permanece; o proprietário não pode ser desativado.

**H15 – Liberar uma sessão para outros.** Sendo administrador, quero escolher quais pesquisadores veem cada sessão, para restringir o acesso aos dados de saúde ao necessário. *RF12, RN18.*
- Por padrão veem a sessão quem a criou, os administradores e o proprietário.
- Liberar e retirar vão para a auditoria.

**H16 – Parear um óculos.** Sendo administrador, quero digitar no sistema web o código que o óculos mostra e dar um nome ao aparelho, para ele receber sessões do grupo. *RF13, RF14, RNF04.*
- O código expira em poucos minutos; o aparelho recebe um acesso próprio e revogável.

**H17 – Ver os óculos do grupo.** Sendo administrador, quero a lista de óculos com situação (online ou offline), último contato e sessão atual, para saber quais estão prontos. *RF15.*

**H18 – Renomear um óculos.** Sendo administrador, quero renomear um óculos, para identificá-lo com facilidade. *RF16.*
- O nome é único no tenant.

**H19 – Desfazer o pareamento.** Sendo administrador, quero desvincular um óculos, para cortar o acesso de um aparelho perdido ou que saiu do grupo. *RF16, RNF04.*
- O acesso é revogado na hora; sessões enviadas e não iniciadas voltam a rascunho.

**H20 – Apagar um paciente.** Sendo administrador, quero excluir um paciente com os dados das suas sessões, para atender a um pedido de exclusão (LGPD). *RF21, RNF08.*
- Pede confirmação; a exclusão vai para a auditoria sem guardar o que foi apagado.

**H21 – Consultar a auditoria.** Sendo administrador, quero consultar os registros de auditoria por usuário, ação e período, para saber quem fez o quê e quando. *RF60, RN01.*

**H22 – Confiar na auditoria.** Sendo administrador, quero que toda ação relevante seja registrada sozinha e nunca possa ser alterada, para responder por cada acesso aos dados. *RF59, RN20.*
- Entram login, criação, edição, exclusão, envio e início de sessão, visualização e exportação de dados e mudanças de permissão.

## Pesquisador – pacientes

**H23 – Cadastrar um paciente.** Sendo pesquisador, quero cadastrar um paciente com um código obrigatório e só os dados clínicos necessários, para vincular as sessões a ele sem guardar dados demais. *RF17, RNF07.*
- O código é único no tenant; o nome é opcional e nunca aparece no óculos.
- Campos: ano de nascimento, sexo, etiologia, data da lesão, diagnóstico atual, escore CRS-R e observações.

**H24 – Atualizar um paciente.** Sendo pesquisador, quero editar os dados de um paciente, para registrar um novo diagnóstico ou escore. *RF18.*

**H25 – Encontrar um paciente.** Sendo pesquisador, quero listar os pacientes e buscá-los pelo código, para achar rápido quem vai participar. *RF19.*

**H26 – Ver o histórico do paciente.** Sendo pesquisador, quero ver as sessões já feitas com um paciente, para acompanhar a evolução dele. *RF20, RN18.*
- Só aparecem as sessões que tenho permissão de ver.

## Pesquisador – estímulos e modelos

**H27 – Montar o acervo.** Sendo pesquisador, quero enviar imagens e vídeos ao acervo do grupo, para usá-los como estímulos. *RF22, RNF19.*
- Aceita JPEG, PNG e MP4 (H.264) até o tamanho configurado; recusa o resto com mensagem clara.

**H28 – Escolher estímulos.** Sendo pesquisador, quero listar, buscar e pré-visualizar os estímulos, para escolher o que vou exibir. *RF23.*

**H29 – Organizar o acervo.** Sendo pesquisador, quero editar nome, descrição e etiquetas de um estímulo, para manter o acervo organizado. *RF24.*
- O arquivo em si não se troca; para isso, envia-se outro estímulo.

**H30 – Reservar um estímulo a um paciente.** Sendo pesquisador, quero marcar um estímulo como pessoal de um paciente (a foto de um familiar, por exemplo), para ele só aparecer nas sessões desse paciente. *RF25, RN12.*

**H31 – Aposentar um estímulo.** Sendo pesquisador, quero arquivar um estímulo, para tirá-lo das novas sessões sem perder o histórico. *RF26, RN13.*
- Estímulo já usado não se exclui, só se arquiva; as sessões antigas continuam íntegras.

**H32 – Criar um protocolo reutilizável.** Sendo pesquisador, quero salvar um modelo de sessão com nome, a ordem dos estímulos e o tempo de cada um, para aplicar o mesmo protocolo a vários pacientes. *RF27, RN09, RN10.*
- Pelo menos um estímulo, todos do acervo e não arquivados, cada um com tempo maior que zero; a duração total aparece na tela.

**H33 – Ver os protocolos.** Sendo pesquisador, quero a lista de modelos com o número de estímulos e a duração, para escolher qual aplicar. *RF28.*

**H34 – Ajustar um protocolo.** Sendo pesquisador, quero editar um modelo, para corrigir o protocolo sem mexer nas sessões já criadas com ele. *RF28, RN11.*

**H35 – Variar um protocolo.** Sendo pesquisador, quero duplicar um modelo, para criar uma variação sem montar tudo de novo. *RF28.*

**H36 – Descartar um protocolo.** Sendo pesquisador, quero excluir um modelo, para manter só os protocolos em uso. *RF28, RN11.*

**H37 – Ter uma linha de base.** Sendo pesquisador, quero inserir uma tela neutra com duração configurável entre os estímulos, para ter uma linha de base das expressões. *RF29.*
- A tela neutra conta na duração total.

## Pesquisador – preparar e conduzir a sessão

**H38 – Criar uma sessão a partir de um modelo.** Sendo pesquisador, quero criar uma sessão para um paciente a partir de um modelo e ajustá-la antes do envio, para repetir um protocolo sem retrabalho. *RF30, RN07, RN11.*
- A sessão tem um único paciente, nasce como rascunho e não altera o modelo.

**H39 – Criar uma sessão sob medida.** Sendo pesquisador, quero montar uma sessão escolhendo estímulos, ordem e tempos, para um protocolo específico daquele dia. *RF31, RN08, RN09, RN10, RN12.*

**H40 – Registrar o estado do dia.** Sendo pesquisador, quero anotar na sessão o diagnóstico e o escore CRS-R do paciente naquele dia, para relacionar as respostas ao estado dele no momento. *RF32.*
- Campos opcionais.

**H41 – Mandar a sessão para o óculos.** Sendo pesquisador, quero enviar a sessão a um óculos pareado, para ele baixá-la antes de eu colocar o aparelho no paciente. *RF33, RN14, RN16.*
- Só aparecem óculos do meu tenant sem outra sessão pendente; depois do envio a sessão não se edita, só se cancela.

**H42 – Saber em que pé está a sessão.** Sendo pesquisador, quero ver o estado da sessão (rascunho, enviada, baixada, início solicitado, em execução, enviando, processando, concluída ou falha) e se o óculos está online, para saber quando posso iniciar e quando os dados estão prontos. *RF34.*

**H43 – Ser avisado de problema no rastreamento.** Sendo pesquisador, quero ser avisado no sistema web se o rastreamento ocular ou facial do óculos não estiver ativo, para corrigir antes de colocar o óculos no paciente. *RF39.*

**H44 – Iniciar sem tocar no óculos.** Sendo pesquisador, quero iniciar a sessão por um botão no sistema web depois de posicionar o óculos no paciente, para não usar o controle em nenhum momento. *RF35, RN15, RNF13, RNF22.*
- O botão só libera com o óculos online e a sessão baixada; o óculos começa em até cerca de 2 s; quem iniciou vai para a auditoria.

**H45 – Desistir antes de começar.** Sendo pesquisador, quero cancelar uma sessão ainda não iniciada, para corrigi-la ou desistir da coleta. *RF36, RN16.*
- Depois de iniciada não há cancelamento nem interrupção; se já estava no óculos, ele a descarta.

**H46 – Encontrar uma sessão.** Sendo pesquisador, quero listar as sessões que posso ver, filtrando por paciente, estado e período, para achar uma coleta. *RF37, RN18.*

## Pesquisador – o que o óculos faz sozinho

**H47 – Óculos pronto sem minha intervenção.** Sendo pesquisador, quero que o óculos baixe sozinho a sessão e todos os estímulos e mostre na espera o código do paciente, o número de estímulos e a duração, para a exibição não depender da rede. *RF38, RF40, RN19, RNF20.*
- O óculos consulta o servidor a cada ~1 s; o paciente aparece só pelo código.

**H48 – Sessão igual para todos.** Sendo pesquisador, quero que o óculos execute a sessão na ordem e nos tempos configurados e termine sozinho, para todos os pacientes passarem pelo mesmo protocolo. *RF41, RF42, RN08, RN16, RNF09.*
- Confirma o início ao servidor; depois disso não depende da rede e não pode ser interrompida pelo sistema.

**H49 – Saber o que foi olhado e quando.** Sendo pesquisador, quero o olhar registrado a cada quadro, junto com o instante real de início e fim de cada estímulo, para analisar as reações a cada um. *RF43, RF44, RNF14, RNF16.*
- Cada amostra tem validade, confiança, ponto 3D e posições na cena e no estímulo, todas no relógio do óculos.

**H50 – Registrar as expressões sem filmar o rosto.** Sendo pesquisador, quero as expressões faciais (FACS) registradas com intensidade e validade, sem nenhuma imagem do rosto, para medir as reações respeitando a privacidade. *RF45, RNF06.*

**H51 – Rever o que o paciente viu.** Sendo pesquisador, quero a cena exibida gravada durante a sessão, para rever depois exatamente o que o paciente viu. *RF46, RNF15.*
- Taxa, resolução e qualidade configuráveis, sem engasgos na exibição.

**H52 – Não perder a coleta.** Sendo pesquisador, quero os dados gravados no próprio óculos em intervalos curtos, para não perder a sessão se o aplicativo fechar. *RF47.*

**H53 – Dados chegam sozinhos ao servidor.** Sendo pesquisador, quero que o óculos envie os dados e os quadros ao servidor ao fim da sessão, em lotes, repetindo o que falhar e esperando a conexão voltar se preciso, para não transferir arquivos à mão. *RF48, RF49, RNF10, RNF11.*
- Os dados só saem do óculos depois da confirmação do servidor; reenviar um lote não duplica nada.

**H54 – Vídeo pronto na sessão certa.** Sendo pesquisador, quero que o servidor monte o vídeo em segundo plano e o associe à sessão e ao paciente, para encontrar tudo pronto no sistema web. *RF50, RF51.*
- Estado "processando" durante a montagem; "concluída" ao terminar ou "falha" em caso de erro.

## Pesquisador – analisar a sessão

**H55 – Assistir à sessão.** Sendo pesquisador autorizado, quero abrir uma sessão concluída e assistir ao vídeo, para rever a coleta. *RF52, RN18, RNF05.*
- A visualização vai para a auditoria.

**H56 – Ver para onde o paciente olhou.** Sendo pesquisador, quero o mapa de calor do olhar sobre o vídeo, com janela temporal, raio e opacidade ajustáveis, para identificar o que atraiu a atenção. *RF53.*

**H57 – Conferir o rastreamento.** Sendo pesquisador, quero um modo validação com o ponto do olhar desenhado sobre o vídeo, para avaliar a qualidade da coleta. *RF54.*

**H58 – Ver as expressões no tempo.** Sendo pesquisador, quero gráficos das expressões ao longo do tempo com a marcação de cada estímulo, para relacionar reação e estímulo. *RF55.*

**H59 – Comparar os estímulos.** Sendo pesquisador, quero um resumo por estímulo com tempo de olhar dentro dele, porcentagem de amostras válidas e intensidade média das expressões, para comparar as respostas. *RF56.*

**H60 – Anotar a sessão.** Sendo pesquisador, quero registrar anotações e dados descritivos na sessão, para guardar o que aconteceu na coleta (por exemplo, o óculos foi retirado). *RF57, RN17.*
- Os dados coletados nunca são editados.

**H61 – Levar os dados para fora.** Sendo pesquisador, quero exportar os dados da sessão em JSON e CSV, para analisá-los em outras ferramentas. *RF58.*
- A exportação vai para a auditoria.

## Diferenças em relação à lista oficial (HU01.1 a HU11.2)

- São 61 histórias aqui contra 60 lá. O conteúdo coberto é o mesmo: todos os RF01–RF60 aparecem.
- Aqui "editar" e "desativar" usuário são duas histórias (H13 e H14); lá é uma (HU02.4).
- Aqui o convite é contado pela pessoa convidada (H07); lá é um caso de uso do sistema (HU02.2) narrado pela própria pessoa cadastrada, o que dá no mesmo.
- Aqui "montar sequência de estímulos" não é história própria: entrou nos critérios de H32 e H39. Lá é HU06.6, porque é um caso de uso incluído por três outros.
- Aqui a parte do óculos (H47–H54) está agrupada pelo que o pesquisador precisa que aconteça; lá segue os grupos 2.8 e 2.9 dos requisitos. O recorte é quase o mesmo.
- Aqui não há história para o paciente, pelo mesmo motivo da lista oficial (RN06).
