#!/usr/bin/perl
# Monta os apêndices do artigo (Apendices.md) a partir dos artefatos da pasta Especificacao, para o
# artigo trazer os diagramas, as tabelas e as histórias de usuário inteiros, e não só um exemplo de cada.
# As imagens entram em Texto-TCC/figuras/apendices (copiadas de Especificacao/imagens-dos-diagramas
# e de Especificacao/Prototipos-NeuroSight/imagens).
# Uso: chamado por montar-artigo.pl com os números da próxima figura e da próxima tabela do artigo:
#   perl Texto-TCC/montar-apendices.pl 4 3
# A fonte do conteúdo é sempre a pasta Especificacao: para mudar um apêndice, mude o artefato lá.
#
# Quais apêndices entram está na lista @ativos, logo abaixo. Em 03/11/2026 o autor pediu só os diagramas
# de casos de uso e as histórias de usuário; os blocos dos outros artefatos (requisitos, classes, estados,
# sequência, modelo lógico, BPMN e protótipos) ficam prontos aqui, desligados, até o autor e o orientador
# decidirem incluí-los (ver Pendencias-completude-TCC1.md). As letras dos apêndices e as remissões entre
# eles são calculadas a partir da lista, na ordem em que as chaves aparecem.
use strict;
use warnings;
use utf8;
use open qw(:std :encoding(UTF-8));
use FindBin;
use File::Copy qw(copy);
use File::Path qw(make_path);

# ---------------------------------------------------------------- quais apêndices entram
# Chaves: req (requisitos), uc (diagramas de casos de uso), hu (histórias de usuário), cls (diagrama de
# classes), est (estados da sessão), sd (diagramas de sequência e rotas da API), ml (modelo lógico-relacional
# e dicionário de dados), bpmn (processos de negócio) e prot (protótipos de tela).
my @ativos = qw(uc hu);
my %titulo = (
  req  => 'REQUISITOS DO SISTEMA',
  uc   => 'DIAGRAMAS DE CASOS DE USO',
  hu   => 'HISTÓRIAS DE USUÁRIO',
  cls  => 'DIAGRAMA DE CLASSES',
  est  => 'DIAGRAMA DE ESTADOS DA SESSÃO',
  sd   => 'DIAGRAMAS DE SEQUÊNCIA',
  ml   => 'MODELO LÓGICO-RELACIONAL',
  bpmn => 'PROCESSOS DE NEGÓCIO',
  prot => 'PROTÓTIPOS DE TELA',
);
for (@ativos) { die "apêndice \"$_\" desconhecido\n" unless $titulo{$_} }
my %letra; { my $l = 'A'; $letra{$_} = $l++ for @ativos }
# remissão a outro apêndice dentro do texto; se ele não estiver ativo, remete à documentação on-line
sub ap { my ($k) = @_; return exists $letra{$k} ? "Apêndice $letra{$k}" : 'documentação completa, disponível on-line' }
sub cabecalho { my ($k) = @_; return "## APÊNDICE $letra{$k} – $titulo{$k}\n\n" }

my $fig = $ARGV[0] // 4;   # número da próxima figura
my $tab = $ARGV[1] // 3;   # número da próxima tabela
my $dir = $FindBin::Bin;
my $esp = "$dir/../Especificacao";
my $imgdir = "$dir/figuras/apendices";
make_path($imgdir);

sub ler { my ($f) = @_; open my $h, '<', $f or die "não abri $f: $!\n"; local $/; my $t = <$h>; close $h; $t =~ s/\r\n/\n/g; return $t }

my %md = (
  req   => ler("$esp/Requisitos-NeuroSight.md"),
  uc    => ler("$esp/Casos-de-uso-e-historias-NeuroSight.md"),
  cls   => ler("$esp/Diagrama-de-classes-NeuroSight.md"),
  est   => ler("$esp/Diagrama-de-estados-da-sessao.md"),
  ml    => ler("$esp/Modelo-logico-relacional-NeuroSight.md"),
  sd    => ler("$esp/Diagramas-de-sequencia-NeuroSight.md"),
  bpmn  => ler("$esp/BPMN-Experimento-NeuroSight.md"),
  asis  => ler("$esp/BPMN-Processo-atual.md"),
  prot  => ler("$esp/Prototipos-NeuroSight/Prototipos-NeuroSight.md"),
);

# ---------------------------------------------------------------- utilitários de extração
# Conteúdo de uma seção "## Título" (ou "### Título") até o próximo título do mesmo nível ou acima
sub secao {
  my ($t, $titulo, $nivel) = @_;
  $nivel //= 2;
  my $h = '#' x $nivel;
  $t =~ /^\Q$h\E \Q$titulo\E[^\n]*\n(.*?)(?=^#{1,$nivel} |\z)/ms or die "seção \"$titulo\" não encontrada\n";
  return $1;
}
# Primeira tabela (linhas consecutivas que começam com |) de um trecho
sub primeira_tabela { my ($t) = @_; $t =~ /((?:^\|.*\n)+)/m or die "tabela não encontrada em: " . substr($t, 0, 60) . "\n"; return $1 }
# Todas as tabelas de um trecho
sub tabelas { my ($t) = @_; return $t =~ /((?:^\|.*\n)+)/mg }
# Remove colunas pelo nome do cabeçalho
sub tira_colunas {
  my ($tabela, @nomes) = @_;
  my @linhas = split /\n/, $tabela;
  my @cab = map { s/^\s+|\s+$//gr } split /\|/, $linhas[0] =~ s/^\s*\|//r =~ s/\|\s*$//r;
  my %tira = map { $_ => 1 } @nomes;
  my @fica = grep { !$tira{ $cab[$_] } } 0 .. $#cab;
  my @saida;
  for my $l (@linhas) {
    my @c = split /\|/, $l =~ s/^\s*\|//r =~ s/\|\s*$//r, -1;
    push @saida, '| ' . join(' | ', map { s/^\s+|\s+$//gr } @c[@fica]) . ' |';
  }
  return join("\n", @saida) . "\n";
}
# Texto corrido de um trecho: tira links e blocos de código, achata listas aninhadas, remove tabelas
sub texto {
  my ($t) = @_;
  $t =~ s/```.*?```\n?//gs;                          # blocos de código
  $t =~ s/^\|.*\n//mg;                               # tabelas (entram à parte, com legenda)
  $t =~ s/!\[[^\]]*\]\([^)]*\)//g;                   # imagens
  $t =~ s/\[([^\]]+)\]\([^)]+\)/$1/g;                # links viram só o texto
  # listas aninhadas: o subitem entra no item de cima, separado por ponto e vírgula
  my @l = split /\n/, $t; my @o;
  for my $x (@l) {
    if ($x =~ /^\s+- (.+)$/) {
      my $s = $1;
      if (@o && $o[-1] =~ /^(?:- |\d+\. )/) {
        $s =~ s/[;.]$//;
        my $dois_pontos = $o[-1] =~ /:\**\s*$/;
        $o[-1] =~ s/[;.]?\s*$//;
        $o[-1] .= ($dois_pontos ? ' ' : '; ') . $s;
        next;
      }
    }
    push @o, $x;
  }
  $t = join("\n", @o);
  $t =~ s/\n{3,}/\n\n/g;
  $t =~ s/^\s+|\s+$//g;
  return $t ? "$t\n\n" : '';
}
# Só os itens de lista (- ...) de um trecho, já achatados
sub lista { my ($t) = @_; my $x = texto($t); return join('', map { "$_\n" } grep { /^(?:- |\d+\. )/ } split /\n/, $x) . "\n" }
# Só os parágrafos (sem listas) de um trecho
sub paragrafos { my ($t) = @_; my $x = texto($t); my @p = grep { /\S/ && !/^(?:- |\d+\. |#)/ } split /\n/, $x; return @p ? join("\n\n", @p) . "\n\n" : '' }

# ---------------------------------------------------------------- figuras e tabelas numeradas
my $fonte = 'FONTE: Os autores (2026).';
my %gerada;   # imagens copiadas nesta montagem; as outras da pasta são apagadas no fim
sub figura {
  my ($legenda, $origem, $nome) = @_;
  $nome //= $origem =~ s{.*/}{}r;
  copy("$esp/$origem", "$imgdir/$nome") or die "não copiei $origem: $!\n";
  $gerada{$nome} = 1;
  my $s = "**FIGURA $fig** - $legenda\n\n![$legenda](figuras/apendices/$nome)\n\n$fonte\n\n";
  $fig++;
  return $s;
}
sub tabela {
  my ($legenda, $md) = @_;
  $md =~ s/\s+$//;
  my $s = "**TABELA $tab** - $legenda\n\n$md\n\n$fonte\n\n";
  $tab++;
  return $s;
}
my $out = '';

# ---------------------------------------------------------------- dados usados por mais de um bloco
my @ucs = (
  ['UC00', 'Atores e perfis',          'Casos-de-uso--UC00-Atores-e-perfis.png'],
  ['UC01', 'Acesso e conta',           'Casos-de-uso--UC01-Acesso-e-conta.png'],
  ['UC02', 'Usuários e permissões',    'Casos-de-uso--UC02-Usuarios-e-permissoes.png'],
  ['UC03', 'Óculos',                   'Casos-de-uso--UC03-Oculos.png'],
  ['UC04', 'Pacientes',                'Casos-de-uso--UC04-Pacientes.png'],
  ['UC05', 'Estímulos',                'Casos-de-uso--UC05-Estimulos.png'],
  ['UC06', 'Modelos de sessão',        'Casos-de-uso--UC06-Modelos-de-sessao.png'],
  ['UC07', 'Sessões',                  'Casos-de-uso--UC07-Sessoes.png'],
  ['UC08', 'Execução no óculos',       'Casos-de-uso--UC08-Execucao-no-oculos.png'],
  ['UC09', 'Envio e processamento',    'Casos-de-uso--UC09-Envio-e-processamento.png'],
  ['UC10', 'Consulta e análise',       'Casos-de-uso--UC10-Consulta-e-analise.png'],
  ['UC11', 'Auditoria',                'Casos-de-uso--UC11-Auditoria.png'],
);
my %epico;   # UC01 => { epico => 'E01', nome => ..., corpo => conteúdo da seção }
while ($md{uc} =~ /^## (E\d\d) – (.+?) \(diagrama (UC\d\d)\)\n(.*?)(?=^## |\z)/msg) { $epico{$3} = { nome => $2, epico => $1, corpo => $4 } }
my ($tabAtores, $tabEnum);   # números de tabelas citadas por outros blocos

my %bloco;

# ================================================================ Requisitos
$bloco{req} = sub {
  $out .= cabecalho('req');
  my $ucs_hu = (exists $letra{uc} && exists $letra{hu}) ? "Apêndices $letra{uc} e $letra{hu}" : ap('uc');
  $out .= "Este apêndice reúne os requisitos levantados na etapa de modelagem: os requisitos funcionais, agrupados pelos mesmos onze grupos que deram origem aos diagramas de casos de uso e aos épicos das histórias de usuário ($ucs_hu), as regras de negócio e os requisitos não funcionais. A prioridade de cada requisito funcional segue três níveis: essencial (sem ele o sistema não cumpre o objetivo), importante (deve entrar, mas o sistema funciona sem ele) e desejável (entra se houver tempo).";
  if (exists $letra{uc}) { $out .= " Os atores citados nos requisitos estão descritos na Tabela \@\@TAB_ATORES\@\@ do Apêndice $letra{uc}.\n\n" }
  else { $out .= "\n\n"; $out .= tabela('Atores do NeuroSight.', primeira_tabela(secao($md{uc}, 'Atores (diagrama UC00)'))) }
  my $rf = secao($md{req}, '2. Requisitos funcionais');
  while ($rf =~ /^### 2\.\d+ (.+?)\n(.*?)(?=^### |\z)/msg) {
    my ($nome, $corpo) = ($1, $2);
    $out .= tabela("Requisitos funcionais: $nome.", tira_colunas(primeira_tabela($corpo), 'Origem'));
  }
  $out .= tabela('Regras de negócio.', tira_colunas(primeira_tabela(secao($md{req}, '3. Regras de negócio')), 'Origem'));
  my $rnf = secao($md{req}, '4. Requisitos não funcionais');
  while ($rnf =~ /^### 4\.\d+ (.+?)\n(.*?)(?=^### |\z)/msg) {
    my ($nome, $corpo) = ($1, $2);
    $out .= tabela("Requisitos não funcionais: $nome.", tira_colunas(primeira_tabela($corpo), 'Origem'));
  }
  my $fora = secao($md{req}, '6. Fora do escopo');
  $out .= "Ficaram fora do escopo do NeuroSight:\n\n" . join('', map { s/\s*\([^)]*\)\.?$/./r . "\n" } grep { /^- / } split /\n/, $fora) . "\n";
};

# ================================================================ Diagramas de casos de uso
$bloco{uc} = sub {
  $out .= cabecalho('uc');
  $out .= "Este apêndice apresenta os doze diagramas de casos de uso do NeuroSight: um com os atores e a hierarquia dos perfis e um para cada grupo de requisitos, totalizando 60 casos de uso. A Figura 1, no corpo do artigo, é o diagrama das sessões (UC07) redesenhado com a hierarquia dos perfis e o paciente. Nos diagramas, os casos de uso com borda tracejada e fundo cinza pertencem a outro diagrama e aparecem apenas para mostrar as relações de inclusão e extensão. Nas tabelas, o ator \"—\" marca os casos de uso incluídos ou estendidos: quem interage neles é o ator do caso base, e a coluna Relações registra, nos casos estendidos, a condição e o ponto de extensão.\n\n";
  $tabAtores = $tab;
  $out .= tabela('Atores do NeuroSight.', primeira_tabela(secao($md{uc}, 'Atores (diagrama UC00)')));
  $out .= tabela('Resumo dos diagramas de casos de uso e dos épicos.', primeira_tabela(secao($md{uc}, 'Resumo dos diagramas')));
  for my $u (@ucs) {
    my ($id, $nome, $arq) = @$u;
    $out .= "### $id – $nome\n\n";
    $out .= figura("Diagrama de casos de uso $id – $nome.", "imagens-dos-diagramas/$arq");
    next if $id eq 'UC00';
    my $e = $epico{$id} or die "épico do $id não encontrado\n";
    $out .= tabela("Casos de uso do diagrama $id – $nome.", primeira_tabela($e->{corpo}));
  }
};

# ================================================================ Histórias de usuário
$bloco{hu} = sub {
  $out .= cabecalho('hu');
  $out .= "Cada diagrama de casos de uso corresponde a um épico, e cada caso de uso tem uma história de usuário com o mesmo número (UC07.6 e HU07.6, por exemplo), no formato \"sendo, quero, para\", com critérios de aceitação. A prioridade de cada história é a maior entre as dos requisitos ligados a ela: são 35 histórias essenciais, 19 importantes e 6 desejáveis. As histórias dos casos de uso incluídos ou estendidos são escritas do ponto de vista do ator do caso base.\n\n";
  for my $u (@ucs[1 .. $#ucs]) {
    my ($id, $nome) = @$u;
    my $e = $epico{$id} or die "épico do $id não encontrado\n";
    $out .= "### $e->{epico} – $nome\n\n";
    my $c = $e->{corpo};
    $c =~ s/^.*?(?=^#### )//ms;          # começa na primeira história
    $out .= texto($c);
  }
};

# ================================================================ Diagrama de classes
$bloco{cls} = sub {
  $out .= cabecalho('cls');
  $out .= "O diagrama de classes é um modelo de domínio: mostra o que o sistema guarda e como as informações se relacionam. Tabelas, colunas e chaves ficam para o modelo lógico-relacional (" . ap('ml') . "). O diagrama tem duas páginas: a primeira com todas as classes, atributos, relações e enumerações (Figura $fig) e a segunda com as composições entre o *tenant* e as classes que pertencem a ele (Figura " . ($fig + 1) . ").\n\n";
  $out .= lista(secao($md{cls}, 'Como ler o diagrama'));
  $out .= figura('Diagrama de classes do NeuroSight.', 'imagens-dos-diagramas/Diagrama-de-classes--Diagrama-de-classes-do-NeuroSight.png');
  $out .= figura('Diagrama de classes: tenant e isolamento.', 'imagens-dos-diagramas/Diagrama-de-classes--Tenant-e-isolamento.png');
  $out .= tabela('Classes do NeuroSight.', primeira_tabela(secao($md{cls}, 'Classes')));
  $tabEnum = $tab;
  $out .= tabela('Enumerações do diagrama de classes.', primeira_tabela(secao($md{cls}, 'Enumerações')));
  $out .= "As regras de negócio que o diagrama não representa graficamente, e que serão garantidas na API ou no banco, são as seguintes.\n\n";
  $out .= lista(secao($md{cls}, 'Regras que o diagrama não mostra'));
};

# ================================================================ Diagrama de estados
$bloco{est} = sub {
  $out .= cabecalho('est');
  $out .= "O diagrama de máquina de estados mostra os estados por que uma sessão passa, da criação até a conclusão ou a falha, e o que a faz mudar de estado. Os nove estados são os valores da enumeração EstadoDaSessao" . (defined $tabEnum ? " (Tabela $tabEnum)" : '') . ".\n\n";
  $out .= lista(secao($md{est}, 'Como ler'));
  $out .= figura('Diagrama de estados da sessão.', 'imagens-dos-diagramas/Diagrama-de-estados-da-sessao--Estados-da-sessao.png');
  $out .= tabela('Transições do diagrama de estados da sessão.', primeira_tabela(secao($md{est}, 'Transições')));
};

# ================================================================ Diagramas de sequência
$bloco{sd} = sub {
  $out .= cabecalho('sd');
  $out .= "Os seis diagramas de sequência cobrem os fluxos principais do sistema, do autocadastro do *tenant* à análise da sessão, e mostram a comunicação entre os atores e os componentes da arquitetura: sistema web (Next.js), API (NestJS), banco (PostgreSQL), armazenamento, aplicativo do óculos (Unreal Engine), processamento (fila e FFmpeg) e serviço de e-mail.\n\n";
  $out .= tabela('Diagramas de sequência e casos de uso cobertos.', primeira_tabela($md{sd} =~ s/^## Como ler.*//msr));
  $out .= lista(secao($md{sd}, 'Como ler'));
  my @sds = (
    ['SD01', 'Autocadastro do tenant',               'Diagramas-de-sequencia--SD01-Autocadastro-do-tenant.png'],
    ['SD02', 'Pareamento do óculos',                 'Diagramas-de-sequencia--SD02-Pareamento-do-oculos.png'],
    ['SD03', 'Criação e envio da sessão',            'Diagramas-de-sequencia--SD03-Criacao-e-envio-da-sessao.png'],
    ['SD04', 'Início e execução',                    'Diagramas-de-sequencia--SD04-Inicio-e-execucao-da-sessao.png'],
    ['SD05', 'Envio e processamento',                'Diagramas-de-sequencia--SD05-Envio-dos-dados-e-montagem-do-video.png'],
    ['SD06', 'Consulta e análise',                   'Diagramas-de-sequencia--SD06-Consulta-e-analise-da-sessao.png'],
  );
  my $oque = secao($md{sd}, 'O que cada diagrama mostra');
  for my $s (@sds) {
    my ($id, $nome, $arq) = @$s;
    $out .= "### $id – $nome\n\n";
    $out .= figura("Diagrama de sequência $id – $nome.", "imagens-dos-diagramas/$arq");
    $out .= lista(secao($oque, "$id – $nome", 3));
  }
  $out .= "### Rotas da API\n\n";
  my $r = secao($md{sd}, 'Rotas da API citadas');
  $out .= tabela('Rotas da API citadas nos diagramas de sequência.', primeira_tabela($r));
  $out .= paragrafos($r);
  $out .= "As decisões de projeto que aparecem nos diagramas são as seguintes.\n\n";
  $out .= lista(secao($md{sd}, 'Decisões que aparecem nos diagramas'));
};

# ================================================================ Modelo lógico-relacional
$bloco{ml} = sub {
  $out .= cabecalho('ml');
  $out .= "O modelo lógico-relacional do banco de dados (PostgreSQL 15 ou mais novo) tem 20 tabelas e 8 tipos enumerados, apresentados em três páginas, uma por assunto: experimento (estímulos, modelos, sessões, pacientes, autorizações e anotações), dados coletados (coleta, eventos, amostras de olhar e de expressão, e gravação) e acesso, óculos e auditoria (*tenant*, usuários, *tokens*, óculos, pareamento e auditoria). Os tipos enumerados correspondem às enumerações do diagrama de classes" . (defined $tabEnum ? " (Tabela $tabEnum)" : '') . ".\n\n";
  $out .= lista(secao($md{ml}, 'Como ler o diagrama'));
  $out .= figura('Modelo lógico-relacional: experimento.', 'imagens-dos-diagramas/Modelo-logico-relacional--Modelo-logico-1-Experimento.png');
  $out .= figura('Modelo lógico-relacional: dados coletados.', 'imagens-dos-diagramas/Modelo-logico-relacional--Modelo-logico-2-Dados-coletados.png');
  $out .= figura('Modelo lógico-relacional: acesso, óculos e auditoria.', 'imagens-dos-diagramas/Modelo-logico-relacional--Modelo-logico-3-Acesso-oculos-e-auditoria.png');
  $out .= "### Decisões de mapeamento\n\n";
  $out .= texto(secao($md{ml}, 'Decisões de mapeamento'));
  $out .= tabela('Correspondência entre as classes e as tabelas.', primeira_tabela(secao($md{ml}, 'Da classe à tabela')));
  $out .= "### Isolamento por tenant\n\n";
  my $rls = secao($md{ml}, 'Isolamento por tenant (RLS)');
  # a política em SQL fica só na especificação; aqui ela é descrita em texto
  $rls =~ s/^Em cada tabela com `tenant_id`, a política é esta:$/Em cada tabela com `tenant_id`, o RLS é ativado e forçado (`ENABLE` e `FORCE ROW LEVEL SECURITY`), e a política `isolamento_tenant` compara a coluna `tenant_id` com o valor de `current_setting('app.tenant_id')`, tanto na leitura (`USING`) quanto na escrita (`WITH CHECK`). As chaves estrangeiras compostas, como `sessao (tenant_id, paciente_id)` apontando para `paciente (tenant_id, id)`, garantem que o filho só referencia um pai do mesmo *tenant*./m
    or die "parágrafo da política de RLS não encontrado\n";
  $out .= texto($rls);
  $out .= "### Restrições, índices e exclusões em cascata\n\n";
  my $r = secao($md{ml}, 'Restrições e índices');
  $out .= tabela('Restrições e índices do banco de dados.', primeira_tabela($r));
  $out .= paragrafos($r);
  $out .= tabela('Comportamento das chaves estrangeiras na exclusão.', primeira_tabela(secao($md{ml}, 'Exclusões em cascata')));
  $out .= "### Dicionário de dados\n\n";
  my $d = secao($md{ml}, 'Dicionário de dados');
  $out .= paragrafos($d =~ s/^###.*//msr);
  while ($d =~ /^### (\S+)\n(.*?)(?=^### |\z)/msg) {
    my ($nome, $corpo) = ($1, $2);
    $out .= tabela("Dicionário de dados: tabela `$nome`.", primeira_tabela($corpo));
  }
};

# ================================================================ Processos de negócio (BPMN)
$bloco{bpmn} = sub {
  $out .= cabecalho('bpmn');
  $out .= "Os dois diagramas de processo de negócio, em BPMN, mostram como o experimento é conduzido hoje, sem o NeuroSight (processo atual), e como passa a ser conduzido com o sistema (processo proposto), do paciente incluído na pesquisa até a sessão analisada.\n\n";
  $out .= "### Processo atual, sem o NeuroSight\n\n";
  $out .= "O diagrama junta os dois fluxos descritos na Subseção II.E: o dos estudos citados e o do protótipo da IC.\n\n";
  $out .= lista(secao($md{asis}, 'Como ler'));
  $out .= figura('Processo atual do experimento, sem o NeuroSight (BPMN).', 'imagens-dos-diagramas/BPMN-Processo-atual--BPMN-Processo-atual-sem-o-NeuroSight.png');
  $out .= tabela('Origem de cada elemento do processo atual.', primeira_tabela(secao($md{asis}, 'De onde saiu cada parte')));
  $out .= lista(secao($md{asis}, 'Escolhas feitas ao juntar os fluxos'));
  $out .= "### Processo com o NeuroSight\n\n";
  $out .= lista(secao($md{bpmn}, 'Como ler'));
  $out .= figura('Processo do experimento com o NeuroSight (BPMN).', 'imagens-dos-diagramas/BPMN-Experimento--BPMN-Experimento-com-o-NeuroSight.png');
  $out .= tabela('Etapas do processo com o NeuroSight e casos de uso correspondentes.', primeira_tabela(secao($md{bpmn}, 'Etapas e casos de uso')));
  $out .= lista(secao($md{bpmn}, 'Pontos do processo'));
};

# ================================================================ Protótipos de tela
$bloco{prot} = sub {
  $out .= cabecalho('prot');
  $out .= "São 19 protótipos de média fidelidade: 14 telas do sistema web e 5 do aplicativo do óculos. Eles mostram o conteúdo, a organização e as ações de cada tela, com dados fictícios, e foram feitos em HTML e CSS, de forma navegável. O visual final pode mudar no desenvolvimento (TCC2). Usuários diferentes aparecem logados nas telas do sistema web para mostrar os perfis: a pesquisadora não vê o grupo Administração no menu. O aplicativo não tem botões, porque o pesquisador não usa o controle em nenhuma etapa (RNF22).\n\n";
  $out .= "### Telas do sistema web\n\n";
  {
    my $w = secao($md{prot}, 'Telas do sistema web');
    my $t = primeira_tabela($w);
    $out .= tabela('Telas do sistema web e casos de uso correspondentes.', tira_colunas($t, 'Imagem'));
    for my $l (grep { /^\| W\d\d/ } split /\n/, $t) {
      my @c = map { s/^\s+|\s+$//gr } split /\|/, $l =~ s/^\s*\|//r =~ s/\|\s*$//r;
      my ($tela, $img) = ($c[0], $c[1] =~ s/`//gr);
      $out .= figura("Protótipo da tela $tela.", "Prototipos-NeuroSight/imagens/$img");
    }
  }
  $out .= "### Telas do aplicativo do óculos\n\n";
  {
    my $a = secao($md{prot}, 'Telas do app no óculos');
    my $t = primeira_tabela($a);
    $out .= tabela('Telas do aplicativo do óculos e casos de uso correspondentes.', tira_colunas($t, 'Imagem'));
    for my $l (grep { /^\| A\d/ } split /\n/, $t) {
      my @c = map { s/^\s+|\s+$//gr } split /\|/, $l =~ s/^\s*\|//r =~ s/\|\s*$//r;
      my ($tela, $img) = ($c[0], $c[1] =~ s/`//gr);
      $out .= figura("Protótipo da tela $tela do aplicativo do óculos.", "Prototipos-NeuroSight/imagens/$img");
    }
  }
  $out .= "Alguns casos de uso não ganharam tela própria porque repetem padrões já mostrados.\n\n";
  $out .= lista(secao($md{prot}, 'Casos de uso sem tela própria'));
};

# ---------------------------------------------------------------- montagem, na ordem da lista
$bloco{$_}->() for @ativos;

# ---------------------------------------------------------------- saída
$out =~ s/\@\@TAB_ATORES\@\@/$tabAtores/g if defined $tabAtores;
$out =~ s/\n{3,}/\n\n/g;
open my $o, '>', "$dir/Apendices.md" or die "não gravei Apendices.md: $!\n";
print $o "# Apêndices\n\nGerado por montar-apendices.pl a partir da pasta Especificacao. Não edite aqui: mude o artefato na especificação e monte o artigo de novo.\n\n", $out;
close $o;
# imagens que sobraram de montagens anteriores, de apêndices que não estão mais ativos
for my $f (glob("$imgdir/*")) { my $n = $f =~ s{.*/}{}r; unlink $f unless $gerada{$n} }
printf "Apêndices %s: %d figuras (até a Figura %d) e %d tabelas (até a Tabela %d)\n",
  join(', ', map { $letra{$_} } @ativos), $fig - ($ARGV[0] // 4), $fig - 1, $tab - ($ARGV[1] // 3), $tab - 1;
