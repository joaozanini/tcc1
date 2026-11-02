# Requisitos do NeuroSight

Versão de trabalho de 26/10/2026. Base: os textos 1.1 e 1.2, o arquivo [Decisoes-tecnicas-NeuroSight.md](Decisoes-tecnicas-NeuroSight.md) e o protótipo da IC.

**Prioridade:** **Essencial** (sem ele o sistema não cumpre o objetivo), **Importante** (deve entrar, mas o sistema funciona sem) e **Desejável** (entra se houver tempo).

**Origem:** **1.1** e **1.2** (seus textos), **DT** (arquivo de decisões técnicas), **IC** (protótipo da IC), **Proposta** (sugestão para você aceitar ou cortar) e **Confirmado** (proposta aceita por você em 26/10/2026). Os itens marcados como Proposta podem ser retirados sem afetar o resto. Os pontos que mudavam ou completavam o 1.2 estão decididos na seção 5, e o que ficou de fora está na seção 6.

Os grupos da seção 2 (2.1 a 2.11) servem de ponto de partida para os casos de uso e os épicos das histórias de usuário.

## 1. Atores

| Ator | Descrição |
|---|---|
| Visitante | Pessoa sem conta. Acessa a landing page e pode criar um tenant |
| Usuário | Qualquer pessoa com conta no tenant (pesquisador, administrador ou proprietário) |
| Proprietário | Quem criou o tenant. Tem todas as permissões do administrador e define quem é administrador |
| Administrador | Gerencia usuários, permissões, óculos, visibilidade das sessões e auditoria do tenant |
| Pesquisador | Cadastra pacientes, estímulos, modelos e sessões; envia, inicia e analisa as sessões |
| Paciente | Não é usuário do sistema. É cadastrado e usa o óculos durante a sessão; aparece como ator secundário na execução da sessão |

O app do óculos faz parte do NeuroSight (é um dos seus três componentes), por isso não aparece como ator nos casos de uso.

## 2. Requisitos funcionais

### 2.1 Tenant, acesso e conta

| ID | Requisito | Prioridade | Origem |
|---|---|---|---|
| RF01 | O sistema deve exibir uma landing page que apresente o NeuroSight e dê acesso ao autocadastro e ao login. | Importante | 1.2 |
| RF02 | O sistema deve permitir que um visitante crie um tenant, informando o nome da instituição ou do grupo e os próprios dados de acesso; quem cria passa a ser o proprietário. | Essencial | 1.2 |
| RF03 | O sistema deve confirmar o e-mail de quem cria o tenant antes de liberar o acesso. | Importante | Proposta |
| RF04 | O sistema deve permitir que o usuário entre com e-mail e senha e saia do sistema. | Essencial | 1.2 |
| RF05 | O sistema deve permitir que o usuário recupere a senha por e-mail. | Importante | Proposta |
| RF06 | O sistema deve permitir que o usuário altere a própria senha e os próprios dados. | Desejável | Proposta |
| RF07 | O sistema deve permitir que o proprietário altere os dados do tenant. | Desejável | Proposta |
| RF08 | O sistema deve permitir que o proprietário transfira a propriedade do tenant para um administrador. | Desejável | Proposta |

### 2.2 Usuários e permissões

| ID | Requisito | Prioridade | Origem |
|---|---|---|---|
| RF09 | O sistema deve permitir que o administrador cadastre usuários no tenant, com nome, e-mail e perfil; o usuário recebe um convite por e-mail para definir a senha. | Essencial | 1.2 + Proposta |
| RF10 | O sistema deve permitir que o administrador liste, edite e desative os usuários do tenant. | Essencial | 1.2 |
| RF11 | O sistema deve permitir que o proprietário conceda e retire o perfil de administrador. | Essencial | 1.2 |
| RF12 | O sistema deve permitir que o administrador defina quais usuários podem visualizar cada sessão. | Essencial | 1.2 |

### 2.3 Óculos (dispositivos)

| ID | Requisito | Prioridade | Origem |
|---|---|---|---|
| RF13 | O app deve exibir um código de pareamento enquanto o óculos não estiver vinculado a um tenant. | Essencial | DT |
| RF14 | O sistema deve permitir que o administrador pareie um óculos ao tenant digitando esse código e dando um nome ao aparelho. | Essencial | DT |
| RF15 | O sistema deve listar os óculos do tenant, com nome, situação (online ou offline), último contato e sessão atual. | Importante | DT |
| RF16 | O sistema deve permitir que o administrador renomeie um óculos e desfaça o pareamento, revogando o acesso do aparelho. | Importante | DT |

### 2.4 Pacientes

| ID | Requisito | Prioridade | Origem |
|---|---|---|---|
| RF17 | O sistema deve permitir que o pesquisador cadastre pacientes com: código de identificação (obrigatório); nome (opcional, nunca exibido no óculos); ano de nascimento; sexo; etiologia da lesão (traumática, vascular ou anóxica); data da lesão; diagnóstico atual (coma, SVNR ou EMC); escore CRS-R; e observações. | Essencial | 1.2 + Confirmado |
| RF18 | O sistema deve permitir que o pesquisador edite os dados de um paciente. | Essencial | 1.2 |
| RF19 | O sistema deve permitir que o pesquisador liste os pacientes e os busque pelo código. | Essencial | 1.2 |
| RF20 | O sistema deve exibir o histórico de sessões de um paciente. | Essencial | 1.2 |
| RF21 | O sistema deve permitir que o administrador exclua um paciente e os dados das suas sessões, registrando a exclusão na auditoria. | Importante | Proposta |

### 2.5 Estímulos

| ID | Requisito | Prioridade | Origem |
|---|---|---|---|
| RF22 | O sistema deve permitir que o pesquisador envie imagens e vídeos para o acervo de estímulos do tenant. | Essencial | 1.2 |
| RF23 | O sistema deve permitir que o pesquisador liste, busque e pré-visualize os estímulos. | Essencial | 1.2 |
| RF24 | O sistema deve permitir que o pesquisador edite o nome, a descrição e as etiquetas de um estímulo. | Importante | Proposta |
| RF25 | O sistema deve permitir marcar um estímulo como pessoal de um paciente (por exemplo, a foto de um familiar), restringindo seu uso às sessões desse paciente. | Importante | 1.2 + Proposta |
| RF26 | O sistema deve permitir que o pesquisador arquive um estímulo, retirando-o das novas sessões. | Importante | Proposta |

### 2.6 Modelos de sessão

| ID | Requisito | Prioridade | Origem |
|---|---|---|---|
| RF27 | O sistema deve permitir que o pesquisador cadastre modelos de sessão, com nome, a lista ordenada de estímulos e o tempo de exibição de cada um. | Essencial | 1.2 |
| RF28 | O sistema deve permitir que o pesquisador liste, edite, duplique e exclua modelos de sessão. | Importante | 1.2 + Proposta |
| RF29 | O sistema deve permitir definir uma tela neutra entre os estímulos, com duração configurável, que sirva de linha de base para as expressões. | Desejável | Proposta |

### 2.7 Sessões (sistema web)

| ID | Requisito | Prioridade | Origem |
|---|---|---|---|
| RF30 | O sistema deve permitir que o pesquisador crie uma sessão para um paciente a partir de um modelo, podendo ajustá-la antes do envio sem alterar o modelo. | Essencial | 1.2 |
| RF31 | O sistema deve permitir que o pesquisador crie uma sessão personalizada, escolhendo os estímulos, a ordem e o tempo de exibição de cada um. | Essencial | 1.2 |
| RF32 | O sistema deve permitir registrar na sessão o estado clínico do paciente no dia (diagnóstico e escore CRS-R, se houver). | Desejável | Proposta |
| RF33 | O sistema deve permitir que o pesquisador envie a sessão a um óculos pareado. | Essencial | DT |
| RF34 | O sistema deve mostrar o estado da sessão (rascunho, enviada ao óculos, baixada, início solicitado, em execução, enviando, processando, concluída ou falha) e se o óculos de destino está online. | Essencial | DT |
| RF35 | O sistema deve permitir que o pesquisador inicie a sessão pelo botão "Iniciar", liberado só quando o óculos está online e já baixou a sessão. | Essencial | 1.2 + DT |
| RF36 | O sistema deve permitir que o pesquisador cancele uma sessão antes do início. | Importante | Proposta |
| RF37 | O sistema deve listar as sessões que o usuário pode ver, com filtros por paciente, estado e período. | Essencial | 1.2 |

### 2.8 Execução no óculos (app)

| ID | Requisito | Prioridade | Origem |
|---|---|---|---|
| RF38 | O app deve consultar o servidor periodicamente enquanto aguarda e baixar a sessão enviada a ele, com todos os estímulos. | Essencial | 1.2 + DT |
| RF39 | O app deve verificar se as permissões e o rastreamento ocular e facial estão ativos e avisar o servidor se não estiverem. | Importante | IC + Proposta |
| RF40 | O app deve avisar o servidor quando a sessão estiver baixada e mostrar, na espera, o código do paciente, o número de estímulos e a duração. | Essencial | DT |
| RF41 | O app deve iniciar a sessão ao receber o comando de início e confirmar o início ao servidor. | Essencial | DT |
| RF42 | O app deve apresentar os estímulos na ordem e pelo tempo configurados e encerrar a sessão sozinho ao fim do tempo. | Essencial | 1.2 |
| RF43 | O app deve registrar o instante real de início e de fim de cada estímulo. | Essencial | DT |
| RF44 | O app deve registrar o olhar a cada quadro: validade, confiança, ponto 3D, posição (u,v) na câmera de captura e posição (u,v) no estímulo olhado. | Essencial | 1.2 + DT + IC |
| RF45 | O app deve registrar as expressões faciais baseadas no FACS, com intensidade e validade. | Essencial | 1.2 + DT |
| RF46 | O app deve capturar quadros da cena exibida ao paciente para a gravação da sessão. | Essencial | 1.2 + IC |
| RF47 | O app deve gravar os dados no armazenamento do óculos durante a sessão, em intervalos curtos, para não perdê-los se o app fechar. | Essencial | IC |

### 2.9 Envio e processamento

| ID | Requisito | Prioridade | Origem |
|---|---|---|---|
| RF48 | Ao fim da sessão, o app deve enviar automaticamente o JSON e os quadros ao servidor, em lotes, repetindo os lotes que falharem. | Essencial | 1.2 + IC |
| RF49 | Sem conexão, o app deve guardar a sessão e reenviá-la quando a conexão voltar. | Essencial | DT |
| RF50 | O servidor deve montar o vídeo MP4 da sessão a partir dos quadros, em segundo plano. | Essencial | DT + IC |
| RF51 | O servidor deve associar os dados e o vídeo à sessão e ao paciente. | Essencial | 1.2 |

### 2.10 Consulta e análise

| ID | Requisito | Prioridade | Origem |
|---|---|---|---|
| RF52 | O sistema deve permitir que o usuário autorizado abra uma sessão concluída e assista ao vídeo. | Essencial | 1.2 + DT |
| RF53 | O sistema deve exibir o heatmap do olhar sobre o vídeo, com janela temporal, raio e opacidade ajustáveis. | Essencial | DT + IC |
| RF54 | O sistema deve oferecer um modo validação, com o ponto do olhar gravado desenhado sobre o vídeo. | Importante | IC |
| RF55 | O sistema deve exibir gráficos das expressões faciais ao longo do tempo, com a marcação de cada estímulo. | Essencial | 1.2 + DT |
| RF56 | O sistema deve exibir um resumo por estímulo: tempo com o olhar dentro do estímulo, porcentagem de amostras válidas e intensidade média das expressões. | Importante | 1.2 |
| RF57 | O sistema deve permitir que o pesquisador registre e edite anotações e os dados descritivos da sessão; os dados coletados não podem ser editados (RN17). | Importante | 1.2 + Confirmado |
| RF58 | O sistema deve permitir exportar os dados de uma sessão em JSON e CSV. | Desejável | Proposta |

### 2.11 Auditoria

| ID | Requisito | Prioridade | Origem |
|---|---|---|---|
| RF59 | O sistema deve registrar automaticamente quem fez cada ação, quando e em qual registro: login, criação, edição e exclusão de dados, envio e início de sessões, visualização e exportação de dados de sessão e mudanças de permissão. | Essencial | 1.1 + 1.2 |
| RF60 | O sistema deve permitir que o administrador consulte os registros de auditoria, filtrando por usuário, ação e período. | Essencial | 1.2 |

## 3. Regras de negócio

| ID | Regra | Origem |
|---|---|---|
| RN01 | Todo usuário, paciente, estímulo, modelo, sessão, óculos e registro de auditoria pertence a um único tenant, e nenhum usuário acessa dados de outro tenant. | 1.2 |
| RN02 | Cada usuário pertence a um único tenant. | DT |
| RN03 | Cada tenant tem um único proprietário: quem o criou, até uma eventual transferência (RF08). | 1.2 |
| RN04 | Só o proprietário concede ou retira o perfil de administrador. | 1.2 |
| RN05 | Os perfis são cumulativos: o proprietário pode tudo o que o administrador pode, e o administrador pode tudo o que o pesquisador pode. | 1.2 + Confirmado |
| RN06 | O paciente não é usuário e não acessa o sistema. | 1.2 |
| RN07 | Toda sessão pertence a exatamente um paciente. | 1.2 |
| RN08 | Toda sessão é um fluxo de imagens e vídeos exibidos em sequência, cada um pelo tempo definido na configuração. | 1.2 |
| RN09 | Uma sessão só usa estímulos que já estão no acervo do tenant. | 1.2 |
| RN10 | Todo estímulo de um modelo ou de uma sessão tem tempo de exibição maior que zero. | Proposta |
| RN11 | Alterar um modelo não altera as sessões já criadas a partir dele. | Proposta |
| RN12 | Um estímulo pessoal só pode ser usado em sessões do paciente ao qual pertence. | Proposta |
| RN13 | Um estímulo já usado em alguma sessão não pode ser excluído, só arquivado. | Proposta |
| RN14 | Uma sessão só pode ser enviada a um óculos pareado ao mesmo tenant, e cada óculos tem no máximo uma sessão pendente por vez. | DT + Proposta |
| RN15 | O botão "Iniciar" só fica liberado quando o óculos de destino está online e já baixou a sessão. | DT |
| RN16 | Depois do envio ao óculos, a sessão não pode mais ser editada (para mudar, é preciso cancelar). Depois do início, ela sempre vai até o fim do tempo configurado: não há interrupção pelo sistema. | 1.2 + Confirmado |
| RN17 | Os dados coletados (olhar, expressões, quadros e vídeo) não podem ser alterados; o pesquisador só registra anotações e dados descritivos. | Confirmado |
| RN18 | Os dados de uma sessão só ficam visíveis para quem a criou, para o proprietário, para os administradores e para quem o administrador autorizar. | 1.2 + Confirmado |
| RN19 | No óculos, o paciente é identificado só pelo código. | DT |
| RN20 | Registros de auditoria não podem ser alterados nem excluídos. | DT |

## 4. Requisitos não funcionais

### 4.1 Segurança e privacidade

| ID | Requisito | Origem |
|---|---|---|
| RNF01 | Os dados de cada tenant devem ficar isolados em duas camadas: filtro na API e Row-Level Security no PostgreSQL. | DT |
| RNF02 | Toda comunicação entre óculos, navegador e servidor deve usar HTTPS. | DT |
| RNF03 | As senhas devem ser guardadas apenas como hash (Argon2 ou bcrypt). | Proposta |
| RNF04 | Toda chamada à API deve exigir token: JWT com tenant e perfil para usuários; token próprio e revogável para cada óculos, obtido no pareamento. | DT |
| RNF05 | Estímulos, quadros, vídeos e JSON só devem ser entregues pela API, depois da checagem de permissão; nenhum arquivo fica em endereço público. | DT |
| RNF06 | O app não deve capturar nem enviar imagens do rosto do paciente, só os valores das expressões. A gravação mostra apenas o que o paciente viu. | 1.2 |
| RNF07 | O cadastro do paciente deve guardar só os dados necessários à pesquisa (minimização da LGPD), listados em RF17. | 1.1 + Confirmado |
| RNF08 | O tratamento dos dados deve seguir a LGPD, considerando os dados de saúde como dados pessoais sensíveis. | 1.1 |

### 4.2 Confiabilidade

| ID | Requisito | Origem |
|---|---|---|
| RNF09 | Depois do início, a execução não pode depender da rede: uma queda de conexão não interrompe a sessão. | DT |
| RNF10 | Os dados de uma sessão só podem ser apagados do óculos depois que o servidor confirmar o recebimento completo. | DT + IC |
| RNF11 | O recebimento dos lotes deve ser idempotente: reenviar um lote não duplica dados. | IC |
| RNF12 | O banco e os arquivos devem ter cópia de segurança diária. | Proposta |

### 4.3 Desempenho

| ID | Requisito | Origem |
|---|---|---|
| RNF13 | O óculos deve começar a sessão em até cerca de 2 s depois do clique em "Iniciar" (consulta ao servidor a cada ~1 s). | DT |
| RNF14 | O olhar deve ser amostrado a cada quadro de renderização (~72 a 90 Hz). | IC |
| RNF15 | O registro de dados e a captura de quadros não podem causar engasgos perceptíveis na exibição dos estímulos; taxa, resolução e qualidade da captura devem ser configuráveis. | IC |
| RNF16 | Os instantes dos estímulos e as amostras de olhar e de expressões devem usar o mesmo relógio do óculos. | DT |

### 4.4 Compatibilidade

| ID | Requisito | Origem |
|---|---|---|
| RNF17 | O app deve rodar sozinho no Meta Quest Pro (standalone), sem cabo nem computador. | IC |
| RNF18 | O sistema web deve funcionar nas versões atuais de Chrome, Edge, Firefox e Safari, em computador. | Proposta |
| RNF19 | Os estímulos aceitos são imagens JPEG e PNG e vídeos MP4 (H.264), com tamanho máximo por arquivo configurável. | Proposta |
| RNF20 | O óculos e o computador do pesquisador não precisam estar na mesma rede; basta acesso à internet. | DT |

### 4.5 Usabilidade

| ID | Requisito | Origem |
|---|---|---|
| RNF21 | A interface web deve estar em português do Brasil. | Proposta |
| RNF22 | O pesquisador não deve precisar usar o controle do óculos em nenhuma etapa da sessão. | 1.2 + DT |

### 4.6 Manutenibilidade e implantação

| ID | Requisito | Origem |
|---|---|---|
| RNF23 | A API deve ser documentada em OpenAPI, que serve de contrato com o app do óculos. | DT |
| RNF24 | O armazenamento de arquivos deve ficar atrás de uma interface que permita trocar o disco por um serviço compatível com S3 sem mudar o resto do sistema. | DT |
| RNF25 | Uma única instalação deve atender vários tenants. | 1.2 |
| RNF26 | O servidor deve ser implantado com Docker Compose, de preferência em região no Brasil. | DT |

## 5. Pontos confirmados (26/10/2026)

1. **Dados do paciente (RF17, RNF07):** a proposta mínima. Código obrigatório, nome opcional e nunca exibido no óculos, e os dados clínicos listados em RF17.
2. **Perfis (RN05):** cumulativos. O administrador também faz tudo o que o pesquisador faz.
3. **Visibilidade (RN18):** por padrão, veem a sessão quem a criou, os administradores e o proprietário; o administrador libera para outros pesquisadores.
4. **Edição (RF57, RN17):** só anotações e dados descritivos da sessão. Os dados coletados ficam imutáveis, para preservar a integridade da pesquisa.
5. **Interrupção:** não haverá. A sessão sempre vai até o fim do tempo configurado (RN16). Se for preciso tirar o óculos do paciente, o pesquisador registra o ocorrido nas anotações.
6. **Consentimento:** fica fora do sistema, controlado pelo protocolo da pesquisa (comitê de ética).

## 6. Fora do escopo

- Diagnóstico: o NeuroSight não faz diagnóstico nem substitui a avaliação clínica (1.1).
- Acompanhamento ao vivo: o pesquisador não vê o que o paciente vê durante a sessão (DT).
- Interrupção de uma sessão em andamento (ponto 5).
- Registro e controle do consentimento do responsável legal (ponto 6).
