#!/usr/bin/perl
# Monta a Especificação Técnica do NeuroSight (Especificacao-Tecnica-NeuroSight.md) no padrão do template
# do curso (Referencias-e-modelos/Template Especificação Técnica TCC TADS UFPR.docx), a partir de:
#   - Contextualizacao.md e Resumo-e-Abstract.md, desta pasta, escritos à mão;
#   - os artefatos da pasta Especificacao (os .md e as imagens de imagens-dos-diagramas e dos protótipos);
#   - as referências completas, lidas das listas "- **[CHAVE]** ..." dos arquivos de Texto-TCC.
# As imagens entram em Especificacao-Tecnica/figuras. O .md gerado é lido por gerar-especificacao-docx.ps1,
# que preenche o template no Word. Para mudar um apêndice, mude o artefato na Especificacao e monte de novo.
# Uso (no Git Bash, na pasta do TCC): perl Especificacao-Tecnica/montar-especificacao.pl
#
# Apêndices, com as letras do template: A casos de uso, B classes, C histórias + protótipos + sequência,
# D modelo lógico do banco, E APIs, F modelos de IA (não se aplica); e os que o template não prevê:
# G requisitos, H estados da sessão, I processos de negócio (BPMN).
use strict;
use warnings;
use utf8;
use open qw(:std :encoding(UTF-8));
use FindBin;
use File::Copy qw(copy);
use File::Path qw(make_path);
use POSIX qw(strftime);

my $dir    = $FindBin::Bin;
my $esp    = "$dir/../Especificacao";
my $texto  = "$dir/../Texto-TCC";
my $imgdir = "$dir/figuras";
my $saida  = "$dir/Especificacao-Tecnica-NeuroSight.md";
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
sub primeira_tabela { my ($t) = @_; $t =~ /((?:^\|.*\n)+)/m or die "tabela não encontrada em: " . substr($t, 0, 60) . "\n"; return $1 }
sub linhas_tabela {   # linhas de dados de uma tabela em Markdown, como listas de células
  my ($tabela) = @_;
  my @r;
  for my $l (split /\n/, $tabela) {
    next if $l =~ /^\|\s*-/;
    push @r, [ map { s/^\s+|\s+$//gr } split /\|/, $l =~ s/^\s*\|//r =~ s/\|\s*$//r, -1 ];
  }
  return @r;
}
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
  $t =~ s/```.*?```\n?//gs;
  $t =~ s/^\|.*\n//mg;
  $t =~ s/!\[[^\]]*\]\([^)]*\)//g;
  $t =~ s/\[([^\]]+)\]\([^)]+\)/$1/g;
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
sub lista { my ($t) = @_; my $x = texto($t); return join('', map { "$_\n" } grep { /^(?:- |\d+\. )/ } split /\n/, $x) . "\n" }
sub paragrafos { my ($t) = @_; my $x = texto($t); my @p = grep { /\S/ && !/^(?:- |\d+\. |#)/ } split /\n/, $x; return @p ? join("\n\n", @p) . "\n\n" : '' }

# ---------------------------------------------------------------- figuras e tabelas numeradas
my $fonte = 'FONTE: Os autores (2026)';
my ($fig, $tab) = (1, 1);
my %gerada;
sub figura {   # legenda, arquivo de origem (caminho completo), nome de destino opcional
  my ($legenda, $origem, $nome) = @_;
  $nome //= $origem =~ s{.*/}{}r;
  copy($origem, "$imgdir/$nome") or die "não copiei $origem: $!\n";
  $gerada{$nome} = 1;
  my $s = "**FIGURA $fig** - $legenda\n\n![$legenda](figuras/$nome)\n\n$fonte\n\n";
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
sub ap { my ($k) = @_; return "## APÊNDICE $k\n\n" }
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
my @sds = (
  ['SD01', 'Autocadastro do tenant',    'Diagramas-de-sequencia--SD01-Autocadastro-do-tenant.png'],
  ['SD02', 'Pareamento do óculos',      'Diagramas-de-sequencia--SD02-Pareamento-do-oculos.png'],
  ['SD03', 'Criação e envio da sessão', 'Diagramas-de-sequencia--SD03-Criacao-e-envio-da-sessao.png'],
  ['SD04', 'Início e execução',         'Diagramas-de-sequencia--SD04-Inicio-e-execucao-da-sessao.png'],
  ['SD05', 'Envio e processamento',     'Diagramas-de-sequencia--SD05-Envio-dos-dados-e-montagem-do-video.png'],
  ['SD06', 'Consulta e análise',        'Diagramas-de-sequencia--SD06-Consulta-e-analise-da-sessao.png'],
);
my %sd_nome = map { $_->[0] => $_->[1] } @sds;
my %sd_arq  = map { $_->[0] => $_->[2] } @sds;

# Expande "UC05.1 a UC05.5", "UC01.2, UC01.3", "UC03.1 (RF13)" numa lista de casos de uso
sub expande_ucs {
  my ($s) = @_;
  $s =~ s/\([^)]*\)//g;
  my @r;
  for my $p (map { s/^\s+|\s+$//gr } split /\s*,\s*/, $s) {
    if ($p =~ /^(UC\d\d)\.(\d+) a UC\d\d\.(\d+)$/) { push @r, map { "$1.$_" } $2 .. $3 }
    elsif ($p =~ /^(UC\d\d\.\d+)$/) { push @r, $1 }
    elsif ($p =~ /\S/) { die "não entendi a lista de casos de uso: $p\n" }
  }
  return @r;
}
# caso de uso -> diagramas de sequência (da tabela dos diagramas)
my %sd_de;
{
  my ($t) = $md{sd} =~ /((?:^\|.*\n)+)/m;
  for my $r (linhas_tabela($t)) {
    next unless $r->[0] =~ /^SD\d\d$/;
    push @{ $sd_de{$_} }, $r->[0] for expande_ucs($r->[2]);
  }
}
# caso de uso -> telas (das tabelas dos protótipos), e telas sem caso de uso próprio
my (%tela_de, %tela, @telas_web, @telas_app, %sem_tela);
{
  for my $r (linhas_tabela(primeira_tabela(secao($md{prot}, 'Telas do sistema web')))) {
    next unless $r->[0] =~ /^(W\d\d) (.+)$/;
    my ($id, $nome) = ($1, $2);
    $tela{$id} = { nome => $nome, arq => $r->[1] =~ s/`//gr, ucs => $r->[3], mostra => $r->[4] };
    push @telas_web, $id;
    push @{ $tela_de{$_} }, $id for expande_ucs($r->[3]);
  }
  for my $r (linhas_tabela(primeira_tabela(secao($md{prot}, 'Telas do app no óculos')))) {
    next unless $r->[0] =~ /^(A\d) (.+)$/;
    my ($id, $nome) = ($1, $2);
    $tela{$id} = { nome => $nome, arq => $r->[1] =~ s/`//gr, ucs => $r->[2], mostra => $r->[3] };
    push @telas_app, $id;
    push @{ $tela_de{$_} }, $id for expande_ucs($r->[2]);
  }
  for my $l (grep { /^- \*\*/ } split /\n/, secao($md{prot}, 'Casos de uso sem tela própria')) {
    $l =~ /^- \*\*(.+?):\*\* (.+)$/ or die "item fora do padrão em 'Casos de uso sem tela própria': $l\n";
    my ($ids, $expl) = ($1, $2);
    $sem_tela{$_} = $expl for $ids =~ /(UC\d\d\.\d+)/g;
  }
}
# casos de uso sem diagrama de sequência próprio: por que, e qual diagrama mostra o padrão
my $sd_padrao = 'Não tem diagrama de sequência próprio: é um caso de uso de cadastro ou consulta, cujas chamadas seguem o padrão mostrado no SD03 (sistema web → API → banco de dados, na transação com o *tenant* do usuário e com registro na auditoria).';
my %sd_nota = (
  'UC01.1' => 'Não tem diagrama de sequência: a página de apresentação é estática e não chama a API.',
  'UC01.4' => 'Não tem diagrama de sequência próprio: o *login* segue o padrão do SD01, com o papel `neurosight_auth`, porque ainda não há *tenant* no contexto, e devolve o JWT com o *tenant* e o perfil do usuário.',
  'UC01.5' => 'Não tem diagrama de sequência próprio: a recuperação de senha segue o padrão do SD01, com um *token* de uso único enviado por e-mail.',
  'UC02.2' => 'Não tem diagrama de sequência próprio: o convite segue o padrão do SD01, com um *token* de uso único enviado por e-mail para a definição da senha.',
  'UC07.3' => 'Faz parte da criação da sessão mostrada no SD03: o estado clínico do dia é enviado junto com os dados da sessão.',
  'UC07.5' => 'Aparece no SD03 e no SD04 como a consulta periódica do sistema web ao estado da sessão (`GET /sessoes/{id}`).',
  'UC10.6' => 'Não tem diagrama de sequência próprio: o registro de anotações segue o padrão do SD06, com a checagem de quem pode ver a sessão.',
  'UC10.7' => 'Não tem diagrama de sequência próprio: a exportação segue o padrão do SD06, com a checagem de quem pode ver a sessão e o registro da exportação na auditoria.',
  'UC11.1' => 'Não tem diagrama de sequência próprio: a consulta à auditoria segue o padrão do SD03, com o filtro pelo *tenant* do administrador.',
  'UC11.2' => 'O registro automático aparece como nota nos diagramas SD01, SD03, SD04 e SD06, nos pontos em que a API grava a auditoria.',
);

# ================================================================ A – Diagramas de casos de uso
sub bloco_uc {
  $out .= ap('A – DIAGRAMA DE CASOS DE USO');
  $out .= "Este apêndice apresenta os doze diagramas de casos de uso do NeuroSight, na notação UML: um com os atores e a hierarquia dos perfis (UC00) e um para cada grupo de requisitos (UC01 a UC11), totalizando 60 casos de uso. Nos diagramas, os casos de uso com borda tracejada e fundo cinza pertencem a outro diagrama e aparecem apenas para mostrar as relações de inclusão e extensão. Nas tabelas, o ator \"—\" marca os casos de uso incluídos ou estendidos: quem interage neles é o ator do caso base, e a coluna Relações registra, nos casos estendidos, a condição e o ponto de extensão. A coluna Requisitos dá a rastreabilidade entre cada caso de uso e os requisitos do Apêndice G.\n\n";
  $out .= tabela('Atores do NeuroSight', primeira_tabela(secao($md{uc}, 'Atores (diagrama UC00)')));
  $out .= "A herança entre os atores representa os perfis cumulativos (RN05): cada perfil faz tudo o que o perfil de quem herda faz. O aplicativo do óculos faz parte do NeuroSight, por isso não é ator. A Figura $fig reúne, numa visão geral, o diagrama das sessões (UC07), que concentra o fluxo principal do sistema, com a hierarquia dos perfis e o paciente.\n\n";
  $out .= figura('Diagrama de casos de uso das sessões, com os perfis de usuário', "$esp/imagens-dos-diagramas/Casos-de-uso--Figura-Sessoes-e-perfis.png");
  $out .= tabela('Resumo dos diagramas de casos de uso e dos épicos', primeira_tabela(secao($md{uc}, 'Resumo dos diagramas')));
  for my $u (@ucs) {
    my ($id, $nome, $arq) = @$u;
    $out .= "### $id – $nome\n\n";
    $out .= figura("Diagrama de casos de uso $id – $nome", "$esp/imagens-dos-diagramas/$arq");
    next if $id eq 'UC00';
    my $e = $epico{$id} or die "épico do $id não encontrado\n";
    $out .= tabela("Casos de uso do diagrama $id – $nome", primeira_tabela($e->{corpo}));
  }
}

# ================================================================ B – Diagrama de classes
my $tabEnum;
sub bloco_cls {
  $out .= ap('B – DIAGRAMA DE CLASSES');
  $out .= "O diagrama de classes é um modelo de domínio: mostra o que o sistema guarda e como as informações se relacionam. Tabelas, colunas e chaves ficam para o modelo lógico-relacional (Apêndice D). O diagrama tem duas páginas: a primeira com todas as classes, atributos, relações e enumerações (Figura $fig) e a segunda com as composições entre o *tenant* e as classes que pertencem a ele (Figura " . ($fig + 1) . "). O comportamento da classe Sessao ao longo do tempo está no diagrama de estados do Apêndice H.\n\n";
  $out .= lista(secao($md{cls}, 'Como ler o diagrama'));
  $out .= figura('Diagrama de classes do NeuroSight', "$esp/imagens-dos-diagramas/Diagrama-de-classes--Diagrama-de-classes-do-NeuroSight.png");
  $out .= figura('Diagrama de classes: tenant e isolamento', "$esp/imagens-dos-diagramas/Diagrama-de-classes--Tenant-e-isolamento.png");
  $out .= tabela('Classes do NeuroSight', primeira_tabela(secao($md{cls}, 'Classes')));
  $tabEnum = $tab;
  $out .= tabela('Enumerações do diagrama de classes', primeira_tabela(secao($md{cls}, 'Enumerações')));
  $out .= "As regras de negócio que o diagrama não representa graficamente, e que serão garantidas na API ou no banco, são as seguintes.\n\n";
  $out .= lista(secao($md{cls}, 'Regras que o diagrama não mostra'));
}

# ================================================================ C – Histórias, protótipos e sequência
sub bloco_hu {
  $out .= ap('C – HISTÓRIAS DE USUÁRIO, PROTÓTIPOS DE TELA E DIAGRAMAS DE SEQUÊNCIA');
  $out .= "Este apêndice apresenta, para cada caso de uso do Apêndice A, a história de usuário, o protótipo de tela e o diagrama de sequência relacionados. Cada diagrama de casos de uso corresponde a um épico, e cada caso de uso tem uma história de usuário com o mesmo número (UC07.6 e HU07.6, por exemplo), no formato \"sendo, quero, para\", com critérios de aceitação. A prioridade de cada história é a maior entre as dos requisitos ligados a ela: são 35 histórias essenciais, 19 importantes e 6 desejáveis. As histórias dos casos de uso incluídos ou estendidos são escritas do ponto de vista do ator do caso base.\n\n";
  $out .= "Os protótipos são 19 telas de média fidelidade, 14 do sistema web (W01 a W14) e 5 do aplicativo do óculos (A1 a A5): mostram o conteúdo, a organização e as ações de cada tela, com dados fictícios coerentes entre si, e foram feitos em HTML e CSS, de forma navegável. O visual final pode mudar no desenvolvimento. Usuários diferentes aparecem logados nas telas do sistema web para mostrar os perfis: a pesquisadora não vê o grupo Administração no menu. O aplicativo não tem botões, porque o pesquisador não usa o controle em nenhuma etapa (RNF22); A1, A2, A3 e A5 são painéis no ambiente virtual, vistos por quem coloca o óculos, e A4 é a visão do paciente durante a sessão. Os casos de uso que repetem padrões já mostrados não ganharam tela própria, e a história indica qual tela os representa. Cada protótipo aparece uma vez, na primeira história que o usa, e as demais remetem à figura.\n\n";
  $out .= "Os seis diagramas de sequência cobrem os fluxos principais do sistema, do autocadastro do *tenant* à análise da sessão, e mostram a comunicação entre os atores e os componentes da arquitetura: sistema web (Next.js), API (NestJS), banco de dados (PostgreSQL), armazenamento, aplicativo do óculos (Unreal Engine), processamento (fila e FFmpeg) e serviço de e-mail. A Tabela $tab mostra os casos de uso cobertos por cada um; os casos de uso de cadastro e consulta, cujas chamadas seguem o mesmo padrão, remetem ao diagrama que o ilustra. As rotas da API usadas nos diagramas estão no Apêndice E. Cada diagrama aparece na primeira história que o usa.\n\n";
  $out .= tabela('Diagramas de sequência e casos de uso cobertos', primeira_tabela($md{sd} =~ s/^## Como ler.*//msr));
  $out .= "Para ler os diagramas de sequência:\n\n";
  $out .= lista(secao($md{sd}, 'Como ler'));
  my $oque = secao($md{sd}, 'O que cada diagrama mostra');
  my (%fig_tela, %fig_sd);   # número da figura de cada tela e de cada diagrama, depois de mostrados
  my %tela_vista;
  for my $u (@ucs[1 .. $#ucs]) {
    my ($id, $nome) = @$u;
    my $e = $epico{$id} or die "épico do $id não encontrado\n";
    $out .= "### $e->{epico} – $nome (diagrama $id)\n\n";
    my $c = $e->{corpo};
    $c =~ s/^.*?(?=^#### )//ms;
    while ($c =~ /^#### (HU\d\d\.\d+) – (.+?)\n(.*?)(?=^#### |\z)/msg) {
      my ($hu, $titulo, $corpo) = ($1, $2, $3);
      (my $uc = $hu) =~ s/^HU/UC/;
      $out .= "#### $hu – $titulo\n\n";
      $out .= texto($corpo);
      my (@mostrar, @frases);
      # protótipo de tela
      if (my $telas = $tela_de{$uc}) {
        my @partes;
        for my $t (@$telas) {
          if (!$fig_tela{$t}) { $fig_tela{$t} = $fig + @mostrar; push @mostrar, ['tela', $t] }
          push @partes, "$t $tela{$t}{nome} (Figura $fig_tela{$t})";
        }
        push @frases, "**Protótipo de tela:** " . join('; ', @partes) . '.';
      } elsif (exists $sem_tela{$uc}) {
        push @frases, "**Protótipo de tela:** este caso de uso não tem tela própria: " . lcfirst($sem_tela{$uc});
      } else { die "caso de uso $uc sem tela e sem justificativa em Prototipos-NeuroSight.md\n" }
      # diagrama de sequência
      if (my $lista = $sd_de{$uc}) {
        my @partes;
        for my $s (@$lista) {
          if (!$fig_sd{$s}) { $fig_sd{$s} = $fig + @mostrar; push @mostrar, ['sd', $s] }
          push @partes, "$s – $sd_nome{$s} (Figura $fig_sd{$s})";
        }
        push @frases, "**Diagrama de sequência:** " . join('; ', @partes) . '.';
      } else {
        push @frases, "**Diagrama de sequência:** " . ($sd_nota{$uc} // $sd_padrao);
      }
      $out .= join("\n\n", @frases) . "\n\n";
      for my $m (@mostrar) {
        my ($tipo, $k) = @$m;
        if ($tipo eq 'tela') {
          my $t = $tela{$k};
          my $leg = $k =~ /^W/ ? "Protótipo da tela $k $t->{nome}" : "Protótipo da tela $k $t->{nome}, do aplicativo do óculos";
          $out .= figura($leg, "$esp/Prototipos-NeuroSight/imagens/$t->{arq}");
          $out .= "A tela $k mostra: " . lcfirst($t->{mostra}) . ".\n\n";
        } else {
          $out .= figura("Diagrama de sequência $k – $sd_nome{$k}", "$esp/imagens-dos-diagramas/$sd_arq{$k}");
          $out .= "O diagrama $k mostra os seguintes pontos:\n\n";
          $out .= lista(secao($oque, "$k – $sd_nome{$k}", 3));
        }
      }
    }
  }
  my @faltam = grep { !$fig_tela{$_} } (@telas_web, @telas_app);
  die "telas sem história que as mostre: @faltam\n" if @faltam;
  my @sd_faltam = grep { !$fig_sd{$_} } map { $_->[0] } @sds;
  die "diagramas de sequência sem história que os mostre: @sd_faltam\n" if @sd_faltam;
}

# ================================================================ D – Modelo lógico do banco
sub bloco_ml {
  $out .= ap('D – DIAGRAMA LÓGICO DO BANCO DE DADOS');
  $out .= "O modelo lógico-relacional do banco de dados (PostgreSQL 15 ou mais novo), na notação pé de galinha, tem 20 tabelas e 8 tipos enumerados, apresentados em três páginas, uma por assunto: experimento (estímulos, modelos, sessões, pacientes, autorizações e anotações), dados coletados (coleta, eventos, amostras de olhar e de expressão, e gravação) e acesso, óculos e auditoria (*tenant*, usuários, *tokens*, óculos, pareamento e auditoria). Os tipos enumerados correspondem às enumerações do diagrama de classes" . (defined $tabEnum ? " (Tabela $tabEnum)" : '') . ".\n\n";
  $out .= lista(secao($md{ml}, 'Como ler o diagrama'));
  $out .= figura('Modelo lógico-relacional: experimento', "$esp/imagens-dos-diagramas/Modelo-logico-relacional--Modelo-logico-1-Experimento.png");
  $out .= figura('Modelo lógico-relacional: dados coletados', "$esp/imagens-dos-diagramas/Modelo-logico-relacional--Modelo-logico-2-Dados-coletados.png");
  $out .= figura('Modelo lógico-relacional: acesso, óculos e auditoria', "$esp/imagens-dos-diagramas/Modelo-logico-relacional--Modelo-logico-3-Acesso-oculos-e-auditoria.png");
  $out .= "### Decisões de mapeamento\n\n";
  $out .= texto(secao($md{ml}, 'Decisões de mapeamento'));
  $out .= tabela('Correspondência entre as classes e as tabelas', primeira_tabela(secao($md{ml}, 'Da classe à tabela')));
  $out .= "### Isolamento por tenant\n\n";
  my $rls = secao($md{ml}, 'Isolamento por tenant (RLS)');
  $rls =~ s/^Em cada tabela com `tenant_id`, a política é esta:$/Em cada tabela com `tenant_id`, o RLS é ativado e forçado (`ENABLE` e `FORCE ROW LEVEL SECURITY`), e a política `isolamento_tenant` compara a coluna `tenant_id` com o valor de `current_setting('app.tenant_id')`, tanto na leitura (`USING`) quanto na escrita (`WITH CHECK`). As chaves estrangeiras compostas, como `sessao (tenant_id, paciente_id)` apontando para `paciente (tenant_id, id)`, garantem que o filho só referencia um pai do mesmo *tenant*./m
    or die "parágrafo da política de RLS não encontrado\n";
  $out .= texto($rls);
  $out .= "### Restrições, índices e exclusões em cascata\n\n";
  my $r = secao($md{ml}, 'Restrições e índices');
  $out .= tabela('Restrições e índices do banco de dados', primeira_tabela($r));
  $out .= paragrafos($r);
  $out .= tabela('Comportamento das chaves estrangeiras na exclusão', primeira_tabela(secao($md{ml}, 'Exclusões em cascata')));
  $out .= "### Dicionário de dados\n\n";
  my $d = secao($md{ml}, 'Dicionário de dados');
  $out .= paragrafos($d =~ s/^###.*//msr);
  while ($d =~ /^### (\S+)\n(.*?)(?=^### |\z)/msg) {
    my ($nome, $corpo) = ($1, $2);
    $out .= tabela("Dicionário de dados: tabela `$nome`", primeira_tabela($corpo));
  }
}

# ================================================================ E – APIs
sub bloco_api {
  $out .= ap('E – ESPECIFICAÇÃO DE APPLICATION PROGRAMMING INTERFACES (APIS)');
  $out .= "O sistema web e o aplicativo do óculos se comunicam apenas com a API do servidor, por HTTPS, no estilo REST. As rotas do aplicativo usam o *token* do óculos, obtido no pareamento; as do sistema web usam o JWT do usuário, com o *tenant* e o perfil, exceto as do autocadastro e da confirmação de e-mail, que acontecem antes de existir um usuário autenticado. A Tabela $tab lista as rotas usadas nos diagramas de sequência do Apêndice C, com quem as chama, para quê e em qual diagrama aparecem. A lista completa das rotas, com os parâmetros e as respostas de cada uma, será documentada em OpenAPI na etapa de desenvolvimento (RNF23), como contrato entre o servidor e o aplicativo.\n\n";
  my $r = secao($md{sd}, 'Rotas da API citadas');
  $out .= tabela('Rotas da API usadas nos diagramas de sequência', primeira_tabela($r));
  $out .= "As decisões de projeto que aparecem nas rotas e nos diagramas são as seguintes.\n\n";
  $out .= lista(secao($md{sd}, 'Decisões que aparecem nos diagramas'));
}

# ================================================================ F – Modelos de IA (não se aplica)
sub bloco_ia {
  $out .= ap('F – MODELOS DE INTELIGÊNCIA ARTIFICIAL');
  $out .= "Este apêndice não se aplica ao NeuroSight. O sistema não treina nem executa modelos de inteligência artificial: os valores das expressões faciais, baseados no *Facial Action Coding System*, são fornecidos pelo kit de desenvolvimento da Meta, que os calcula no próprio óculos a partir das câmeras internas e descarta as imagens, e o olhar é lido pelo padrão OpenXR. O sistema registra esses valores, junto com os instantes de cada estímulo, e os apresenta ao pesquisador em gráficos, mapas de calor e resumos por estímulo; a interpretação das respostas do paciente cabe aos pesquisadores. O uso de modelos de aprendizado de máquina sobre os dados coletados, se vier a ser considerado, fica para trabalhos futuros, fora do escopo deste projeto.\n\n";
}

# ================================================================ G – Requisitos
sub bloco_req {
  $out .= ap('G – REQUISITOS DO SISTEMA');
  $out .= "Este apêndice reúne os requisitos levantados na etapa de modelagem: os requisitos funcionais, agrupados pelos mesmos onze grupos que deram origem aos diagramas de casos de uso (Apêndice A) e aos épicos das histórias de usuário (Apêndice C), as regras de negócio e os requisitos não funcionais. A prioridade de cada requisito funcional segue três níveis: essencial (sem ele o sistema não cumpre o objetivo), importante (deve entrar, mas o sistema funciona sem ele) e desejável (entra se houver tempo). Os atores citados nos requisitos estão descritos na Tabela 1 do Apêndice A.\n\n";
  my $rf = secao($md{req}, '2. Requisitos funcionais');
  while ($rf =~ /^### 2\.\d+ (.+?)\n(.*?)(?=^### |\z)/msg) {
    my ($nome, $corpo) = ($1, $2);
    $out .= tabela("Requisitos funcionais: $nome", tira_colunas(primeira_tabela($corpo), 'Origem'));
  }
  $out .= tabela('Regras de negócio', tira_colunas(primeira_tabela(secao($md{req}, '3. Regras de negócio')), 'Origem'));
  my $rnf = secao($md{req}, '4. Requisitos não funcionais');
  while ($rnf =~ /^### 4\.\d+ (.+?)\n(.*?)(?=^### |\z)/msg) {
    my ($nome, $corpo) = ($1, $2);
    $out .= tabela("Requisitos não funcionais: $nome", tira_colunas(primeira_tabela($corpo), 'Origem'));
  }
  my $fora = secao($md{req}, '6. Fora do escopo');
  $out .= "Ficaram fora do escopo do NeuroSight:\n\n" . join('', map { s/\s*\([^)]*\)\.?$/./r . "\n" } grep { /^- / } split /\n/, $fora) . "\n";
}

# ================================================================ H – Estados da sessão
sub bloco_est {
  $out .= ap('H – DIAGRAMA DE ESTADOS DA SESSÃO');
  $out .= "O diagrama de máquina de estados, na notação UML, mostra os estados por que uma sessão passa, da criação até a conclusão ou a falha, e o que a faz mudar de estado. Os nove estados são os valores da enumeração EstadoDaSessao do diagrama de classes" . (defined $tabEnum ? " (Tabela $tabEnum)" : '') . " e do tipo `estado_sessao` do banco de dados.\n\n";
  $out .= lista(secao($md{est}, 'Como ler'));
  $out .= figura('Diagrama de estados da sessão', "$esp/imagens-dos-diagramas/Diagrama-de-estados-da-sessao--Estados-da-sessao.png");
  $out .= tabela('Transições do diagrama de estados da sessão', primeira_tabela(secao($md{est}, 'Transições')));
}

# ================================================================ I – Processos de negócio (BPMN)
sub bloco_bpmn {
  $out .= ap('I – PROCESSOS DE NEGÓCIO');
  $out .= "Os dois diagramas de processo de negócio, em BPMN, mostram como o experimento é conduzido hoje, sem o NeuroSight (processo atual), e como passa a ser conduzido com o sistema (processo proposto), do paciente incluído na pesquisa até a sessão analisada.\n\n";
  $out .= "### Processo atual, sem o NeuroSight\n\n";
  $out .= "O diagrama junta os dois fluxos descritos na revisão de literatura do artigo: o dos estudos com rastreamento ocular em pacientes com distúrbios da consciência e o do protótipo da Iniciação Científica.\n\n";
  $out .= lista(secao($md{asis}, 'Como ler'));
  $out .= figura('Processo atual do experimento, sem o NeuroSight (BPMN)', "$esp/imagens-dos-diagramas/BPMN-Processo-atual--BPMN-Processo-atual-sem-o-NeuroSight.png");
  $out .= tabela('Origem de cada elemento do processo atual', primeira_tabela(secao($md{asis}, 'De onde saiu cada parte')));
  $out .= lista(secao($md{asis}, 'Escolhas feitas ao juntar os fluxos'));
  $out .= "### Processo com o NeuroSight\n\n";
  $out .= lista(secao($md{bpmn}, 'Como ler'));
  $out .= figura('Processo do experimento com o NeuroSight (BPMN)', "$esp/imagens-dos-diagramas/BPMN-Experimento--BPMN-Experimento-com-o-NeuroSight.png");
  $out .= tabela('Etapas do processo com o NeuroSight e casos de uso correspondentes', primeira_tabela(secao($md{bpmn}, 'Etapas e casos de uso')));
  $out .= lista(secao($md{bpmn}, 'Pontos do processo'));
}

# ---------------------------------------------------------------- contextualização, resumo e referências
my $ctx = ler("$dir/Contextualizacao.md");
$ctx =~ s/^.*?(?=^## 1 CONTEXTUALIZAÇÃO)//ms or die "Contextualizacao.md sem o título '## 1 CONTEXTUALIZAÇÃO'\n";
$ctx =~ s/^## 1 CONTEXTUALIZAÇÃO\n+//;
$ctx =~ s/\s+$/\n/;
# a figura da contextualização: numerada e copiada como as outras
$ctx =~ s{^\*\*FIGURA \d+\*\* - (.+)\n\n!\[[^\]]*\]\(figuras/([^)]+)\)\n\nFONTE: [^\n]+\n}{
  my ($leg, $arq) = ($1, $2);
  figura($leg, "$texto/figuras/$arq");
}gme;
$ctx =~ s/\n{3,}/\n\n/g;

my $res = ler("$dir/Resumo-e-Abstract.md");
my %resumo;
for my $r ('Resumo', 'Palavras-chave', 'Abstract', 'Keywords') {
  $res =~ /^\*\*\Q$r\E:\*\* (.+)$/m or die "linha \"**$r:**\" não encontrada em Resumo-e-Abstract.md\n";
  $resumo{$r} = $1;
}
my $n = () = $resumo{Resumo} =~ /\S+/g;
warn "o resumo tem $n palavras; o template pede de 150 a 500\n" if $n < 150 || $n > 500;

my %ref;
for my $f (glob("$texto/*.md")) {
  my $t = ler($f);
  while ($t =~ /^- \*\*\[([A-Z][A-Z0-9-]+)\]\*\* (.+)$/mg) {
    my ($k, $e) = ($1, $2);
    $e =~ s/\s*\(Já citada no 1\.1[^)]*\)\s*$//;
    $ref{$k} //= $e;
  }
}

# ---------------------------------------------------------------- montagem
bloco_uc(); bloco_cls(); bloco_hu(); bloco_ml(); bloco_api(); bloco_ia(); bloco_req(); bloco_est(); bloco_bpmn();

my $corpo = $ctx . "\n" . $out;
my (%num, @ordem);
while ($corpo =~ /\[([A-Z][A-Z0-9-]+)\]/g) {
  my $k = $1;
  next if exists $num{$k};
  die "citação [$k] sem referência nas listas de Texto-TCC\n" unless exists $ref{$k};
  push @ordem, $k; $num{$k} = scalar @ordem;
}
$corpo =~ s/\[([A-Z][A-Z0-9-]+)\]/exists $num{$1} ? "[$num{$1}]" : "[$1]"/ge;
die "a contextualização precisa de pelo menos três referências; tem " . scalar(@ordem) . "\n" if @ordem < 3;
my $refs = "## REFERÊNCIAS\n\n" . join("\n\n", map { "[$num{$_}] $ref{$_}" } @ordem) . "\n\n";
($corpo, my $apendices) = $corpo =~ /^(.*?)(^## APÊNDICE.*)$/ms;
$corpo =~ s/\n{3,}/\n\n/g; $apendices =~ s/\n{3,}/\n\n/g;

# conferências: figuras e tabelas em sequência e citadas; nenhuma legenda com ponto final
my $tudo = $corpo . $apendices;
my @figs = $tudo =~ /^\*\*FIGURA (\d+)\*\* - /mg;
my @tabs = $tudo =~ /^\*\*TABELA (\d+)\*\* - /mg;
for my $x (['Figura', \@figs], ['Tabela', \@tabs]) {
  my ($nome, $lista) = @$x;
  for my $i (0 .. $#$lista) { die "$nome $lista->[$i] fora de sequência\n" unless $lista->[$i] == $i + 1 }
}
for my $l ($tudo =~ /^(\*\*(?:FIGURA|TABELA) \d+\*\* - .+|FONTE: .+)$/mg) { warn "legenda ou fonte com ponto final: $l\n" if $l =~ /\.$/ }
for my $f (glob("$imgdir/*")) { my $b = $f =~ s{.*/}{}r; unlink $f unless $gerada{$b} }

my $data = strftime('%d/%m/%Y', localtime);
open my $o, '>', $saida or die "não gravei $saida: $!\n";
print $o "# ESPECIFICAÇÃO TÉCNICA DO SISTEMA NEUROSIGHT\n\n",
  "Gerado em $data por montar-especificacao.pl a partir de Contextualizacao.md, Resumo-e-Abstract.md e da pasta Especificacao. Não edite aqui: mude a fonte e monte de novo. O arquivo gerar-especificacao-docx.ps1 lê este .md e preenche o template do curso no Word.\n\n",
  "Autores: João Vitor Zanini Pedro, Lucas Sarnacki Guiraud\n\nOrientador: Prof. Dr. Alessandro Brawerman\n\nAno: 2026\n\n",
  (map { "**$_:** $resumo{$_}\n\n" } 'Resumo', 'Palavras-chave', 'Abstract', 'Keywords'),
  "## CONTEXTUALIZAÇÃO\n\n", $corpo, "\n", $refs, $apendices;
close $o;
printf "Especificação montada: %d figuras, %d tabelas, %d referências, %d histórias; imagens em %s\n",
  scalar @figs, scalar @tabs, scalar @ordem, scalar(() = $tudo =~ /^#### HU/mg), $imgdir;
