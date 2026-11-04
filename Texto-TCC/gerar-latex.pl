#!/usr/bin/perl
# Gera o TCC em LaTeX, no modelo do curso (pasta TCC_TADS_Exemplo_Sistema_de_Estágios),
# a partir do artigo montado (Artigo-TCC1-NeuroSight.md).
# Uso (no Git Bash, na pasta do TCC, depois de montar o artigo com montar-artigo.pl):
#   perl Texto-TCC/gerar-latex.pl
# Grava a pasta Texto-TCC/LaTeX com o textoprincipal.tex, os arquivos do modelo e as figuras, e o
# mesmo conteúdo em Texto-TCC/TCC1-NeuroSight-LaTeX.zip, para enviar ao Overleaf
# (New Project > Upload Project).
# Com --pdf, também compila com o pdflatex (o do PATH ou o TinyTeX em %APPDATA%\TinyTeX) e grava
# Texto-TCC/TCC1-NeuroSight.pdf; os arquivos auxiliares ficam em Texto-TCC/LaTeX/build.
#   perl Texto-TCC/gerar-latex.pl --pdf
use strict;
use warnings;
use utf8;
use open qw(:std :encoding(UTF-8));
use FindBin;
use File::Copy qw(copy);
use File::Path qw(make_path);
use File::Spec;
use IO::Compress::Zip qw(zip $ZipError);
use POSIX qw(strftime);

my $compilar = grep { $_ eq '--pdf' } @ARGV;
@ARGV = grep { $_ ne '--pdf' } @ARGV;
my $dir    = $FindBin::Bin;
my $artigo = $ARGV[0] // "$dir/Artigo-TCC1-NeuroSight.md";
my $saida  = $ARGV[1] // "$dir/LaTeX";
my ($modelo) = glob("$dir/../TCC_TADS_Exemplo_Sistema*");
die "pasta do modelo (TCC_TADS_Exemplo_Sistema_de_Estágios) não encontrada ao lado de Texto-TCC\n" unless $modelo && -d $modelo;

# Largura das figuras: todas ocupam as duas colunas (figure*), como na versão em Word
my %largura = ('Figura-1' => '\textwidth', 'Figura-2' => '0.8\textwidth');

sub ler { my ($f) = @_; open my $h, '<', $f or die "não abri $f: $!\n"; local $/; my $t = <$h>; close $h; $t =~ s/\r\n/\n/g; return $t; }

# ---------------------------------------------------------------- chaves das referências
# O artigo montado traz as citações já numeradas; as chaves vêm das listas dos arquivos das seções,
# para o .tex usar os mesmos nomes ([LAUREYS], [META-MOVE]...) que o texto em Markdown.
my %chave;
for my $f (glob("$dir/*.md")) {
  my $t = ler($f);
  while ($t =~ /^- \*\*\[([A-Z][A-Z0-9-]+)\]\*\* (.+)$/mg) {
    my ($k, $e) = ($1, $2);
    $e =~ s/\s*\(Já citada no 1\.1[^)]*\)\s*$//;
    $chave{$e} //= $k;
  }
}

my @l = split /\n/, ler($artigo);
my $i = 0; $i++ while $i < @l && $l[$i] !~ /^# NeuroSight:/;
die "título do artigo não encontrado em $artigo\n" if $i >= @l;
@l = @l[$i .. $#l];

my (%nota, %cit, @refs);
my $nasRefs = 0;
for my $x (@l) {
  if ($x =~ /^\[\^(\d+)\]: (.+)$/) { $nota{$1} = $2; next }
  if ($x eq '## REFERÊNCIAS') { $nasRefs = 1; next }
  next unless $nasRefs && $x =~ /^\[(\d+)\] (.+)$/;
  my ($n, $e) = ($1, $2);
  my $k = $chave{$e};
  unless ($k) { $k = "ref$n"; warn "referência [$n] não encontrada nos arquivos das seções; ficou com a chave $k\n" }
  $cit{$n} = $k;
  push @refs, [$k, $e];
}

# ---------------------------------------------------------------- conversão do texto
sub esc {
  my ($s) = @_;
  $s =~ s/\\([<>])/$1/g;                 # escapes do Markdown
  $s =~ s/\\/\x{1}/g;
  $s =~ s/([&%\$#_{}])/\\$1/g;
  $s =~ s/~/\\textasciitilde{}/g;
  $s =~ s/\^/\\textasciicircum{}/g;
  $s =~ s/\x{1}/\\textbackslash{}/g;
  $s =~ s/×/\$\\times\$/g;
  $s =~ s/→/\$\\rightarrow\$/g;
  $s =~ s/←/\$\\leftarrow\$/g;
  $s =~ s/↔/\$\\leftrightarrow\$/g;
  $s =~ s/≥/\$\\geq\$/g;
  $s =~ s/≤/\$\\leq\$/g;
  $s =~ s/…/.../g;
  $s =~ s/[‘’]/'/g;
  $s =~ s/“/``/g;
  $s =~ s/”/''/g;
  $s =~ s/—/---/g;
  $s =~ s/–/--/g;
  $s =~ s/"([^"]*)"/``$1''/g;             # aspas retas viram aspas do LaTeX (o babel usa " para atalhos)
  $s =~ s/"/\\textquotedbl{}/g;
  $s =~ s/\bet al\. /et al.\\ /g;
  return $s;
}

my $tok = qr/\*\*(.+?)\*\*|\*(.+?)\*|`([^`]+)`|\[\^(\d+)\]|\[(\d+)\]|(https?:\/\/\S+?)(?=[.,;]?(?:\s|$))/;

sub inline {
  my ($s, $refs) = @_;
  my ($o, $pos) = ('', 0);
  while ($s =~ /$tok/g) {
    my ($ini, $fim) = ($-[0], $+[0]);
    my @g = ($1, $2, $3, $4, $5, $6);
    $o .= esc(substr($s, $pos, $ini - $pos));
    if    (defined $g[0]) { $o .= '\textbf{' . inline($g[0], $refs) . '}' }
    elsif (defined $g[1]) { $o .= '\textit{' . inline($g[1], $refs) . '}' }
    elsif (defined $g[2]) { $o .= '\texttt{' . esc($g[2]) . '}' }
    elsif (defined $g[3]) { die "nota de rodapé $g[3] sem texto\n" unless defined $nota{$g[3]}; $o .= '\footnote{' . inline($nota{$g[3]}, $refs) . '}' }
    elsif (defined $g[4]) { $o .= (!$refs && $cit{$g[4]}) ? '\cite{' . $cit{$g[4]} . '}' : esc("[$g[4]]") }
    else                  { $o .= '\url{' . $g[5] . '}' }
    $pos = $fim;
  }
  $o .= esc(substr($s, $pos));
  # a citação não começa linha sozinha (também depois de "et al.\ ", que o esc já marcou)
  $o =~ s/(?<!,)(?:\\ | )\\cite\{/~\\cite{/g;
  return $o;
}

sub fonte {
  my ($x, $o) = @_;
  $x =~ /^FONTE: (.+)$/ or die "linha FONTE não encontrada depois de $o\n";
  return inline($1);
}

sub proxima { my ($j) = @_; $j++ while $j < @l && $l[$j] =~ /^\s*$/; return $j; }

# Linhas da tabela em Markdown -> células (sem a linha separadora |---|)
sub celulas {
  my ($linhas) = @_;
  my @t;
  for my $x (grep { !/^\|\s*-/ } @$linhas) {
    my $y = $x =~ s/^\s*\|//r =~ s/\|\s*$//r;
    push @t, [ map { s/^\s+|\s+$//gr } split /\|/, $y ];
  }
  return @t;
}

sub tabela {
  my ($cel, $larg) = @_;
  my @t = @$cel;
  my $nc = @{ $t[0] };
  my $cols = $nc > 3 ? 'l|l|' . join('|', ('Y') x ($nc - 2)) : 'l|' . join('|', ('Y') x ($nc - 1));
  my @o = ('  \footnotesize', "  \\begin{tabularx}{$larg}{$cols}", '    \hline');
  my $cab = shift @t;
  push @o, '    ' . join(' & ', map { '\textbf{' . inline($_) . '}' } @$cab) . ' \\\\', '    \hline';
  push @o, '    ' . join(' & ', map { inline($_) } @$_) . ' \\\\' for @t;
  push @o, '    \hline', '  \end{tabularx}';
  return @o;
}

# ---------------------------------------------------------------- cabeçalho do artigo
my $titulo = $l[0] =~ s/^# //r;
my $k = 1;
my @cab;
while ($k < @l && $l[$k] !~ /^\*\*Resumo:\*\*/) { push @cab, $l[$k] if $l[$k] =~ /\S/; $k++ }
my ($nomes, $afiliacao) = @cab;
die "autores ou afiliação não encontrados abaixo do título\n" unless $nomes && $afiliacao;
my @autores = split /, /, $nomes;       # os autores vêm na mesma linha, separados por vírgula
my ($setor, $ufpr) = split /, /, $afiliacao, 2;

# ---------------------------------------------------------------- corpo
# O corpo do artigo vai em @corpo: duas colunas, figuras e tabelas flutuantes, como no modelo do curso.
my (%resumo, @corpo);
while ($k < @l) {
  my $x = $l[$k];
  if ($x =~ /^\s*$/ || $x eq '---' || $x =~ /^\[\^\d+\]: /) { $k++; next }
  last if $x eq '## REFERÊNCIAS';   # as referências já foram lidas acima; o artigo termina nelas
  if ($x =~ /^\*\*(Resumo|Palavras-chave|Abstract|Keywords):\*\* (.+)$/) { $resumo{$1} = inline($2); $k++; next }
  if ($x =~ /^## [IVX]+\. (.+)$/)  { push @corpo, '\section{' . inline($1) . '}', ''; $k++; next }
  if ($x =~ /^### (?:[A-Z]\. )?(.+)$/)  { push @corpo, '\subsection{' . inline($1) . '}', ''; $k++; next }
  if ($x =~ /^#### (.+)$/)  { push @corpo, '\paragraph*{' . inline($1) . '}'; $k++; next }
  if ($x =~ /^\*\d+\) (.+?):\* (.+)$/) { push @corpo, '\subsubsection{' . inline($1) . '} ' . inline($2), ''; $k++; next }
  if ($x =~ /^- /) {
    push @corpo, '\begin{itemize}';
    while ($k < @l && $l[$k] =~ /^- (.+)$/) { push @corpo, '  \item ' . inline($1); $k++ }
    push @corpo, '\end{itemize}', '';
    next;
  }
  if ($x =~ /^\d+\. /) {
    push @corpo, '\begin{enumerate}';
    while ($k < @l && $l[$k] =~ /^\d+\. (.+)$/) { push @corpo, '  \item ' . inline($1); $k++ }
    push @corpo, '\end{enumerate}', '';
    next;
  }
  if ($x =~ /^\*\*(FIGURA|TABELA) (\d+)\*\* - (.+)$/) {
    my ($tipo, $num, $leg) = ($1, $2, inline($3));
    my $j = proxima($k + 1);
    if ($tipo eq 'FIGURA') {
      $l[$j] =~ /^!\[[^\]]*\]\(([^)]+)\)/ or die "FIGURA $num sem a imagem logo abaixo da legenda\n";
      my $img = $1;
      my ($pref) = $img =~ m{(Figura-\d+)};
      my $larg = $largura{ $pref // '' } // '\textwidth';
      $j = proxima($j + 1);
      my $f = fonte($l[$j], "FIGURA $num");
      push @corpo, "\\begin{figuralarga}[!t]{$leg}{$f}{fig:$num}", "  \\includegraphics[width=$larg]{$img}", '\end{figuralarga}', '';
    } else {
      my @tab; while ($j < @l && $l[$j] =~ /^\|/) { push @tab, $l[$j]; $j++ }
      die "TABELA $num sem a tabela logo abaixo da legenda\n" unless @tab;
      $j = proxima($j);
      my $f = fonte($l[$j], "TABELA $num");
      my @cel = celulas(\@tab);
      # tabela com mais de 3 colunas ocupa as duas colunas da página, como a Tabela 1 na versão em Word
      if (@{ $cel[0] } > 3) { push @corpo, "\\begin{tabela*}[!t]{$leg}{$f}", tabela(\@cel, '\textwidth'), '\end{tabela*}', '' }
      else                  { push @corpo, "\\begin{tabela}[!t]{$leg}{$f}{tab:$num}", tabela(\@cel, '\columnwidth'), '\end{tabela}', '' }
    }
    $k = $j + 1;
    next;
  }
  if ($x =~ /^(#|\||!\[|FONTE:)/) { die "linha fora do padrão esperado: $x\n" }
  push @corpo, inline($x), '';
  $k++;
}
for (qw(Resumo Palavras-chave Abstract Keywords)) { die "falta o $_ no artigo montado\n" unless $resumo{$_} }
die "lista de referências vazia\n" unless @refs;

# ---------------------------------------------------------------- arquivo .tex
my $tex = <<'TEX';
% Gerado por Texto-TCC/gerar-latex.pl a partir de Artigo-TCC1-NeuroSight.md em %%DATA%%.
% Para mudar o texto, edite os arquivos das seções em Texto-TCC, monte o artigo com
% montar-artigo.pl e gere de novo este arquivo; mudanças feitas direto aqui se perdem na próxima geração.
% O preâmbulo e a capa seguem o textoprincipal.tex do modelo do curso. Diferenças: a classe é
% IEEEtran (com t minúsculo, que também funciona no Overleaf), o pacote tabularx e o ambiente
% figuralarga, porque o figura* do tads.tex usa figure, que ocupa uma coluna só.
\documentclass[conference,a4paper,10pt]{IEEEtran}

\usepackage{amsmath,amssymb,amsfonts}
\usepackage{algorithmic}
\usepackage{graphicx}
\usepackage{textcomp}
\usepackage{xcolor}
\usepackage{multirow}
\usepackage{setspace}
\usepackage{pdfpages}
\usepackage{float}
\usepackage{caption,newfloat}
\usepackage[T1]{fontenc}
\usepackage[brazilian]{babel}
\usepackage[utf8]{inputenc}
\usepackage{ifthen}
\usepackage[pages=some]{background}
\usepackage{tabularx}
\RequirePackage[obeyspaces,hyphens]{url}
\RequirePackage[plainpages,pdfpagelabels]{hyperref}	% PDF com links, metadados
\RequirePackage{bookmark}				% cria um índice no PDF
\RequirePackage{microtype}	% melhorar a qualidade da tipografia no PDF

% coluna de tabela que quebra linha, alinhada à esquerda
\newcolumntype{Y}{>{\raggedright\arraybackslash}X}

%% Se alguma hifenização não funcionar, adicionar aqui
\hyphenation{di-gi-ta-li-za-das}


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%     INÍCIO DO DOCUMENTO
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
\begin{document}

%%%% NÃO MEXER NESTES ARQUIVOS
%%%% Definições/Estilos customizadas para o TADS, Mais capa
\input{tads.tex}
\hypersetup{pdfauthor={%%AUTORES%%}}

% Figura na largura das duas colunas, com legenda e fonte como as do figura do tads.tex
\newenvironment{figuralarga}[4][!t]
{
  \refstepcounter{figuracounter}
  \label{#4}
  \def\fonteval{#3}
  \begin{figure*}[#1]
    \begin{center}
      \par\medskip\noindent
      FIGURA~\thefiguracounter~-~#2
      \par\medskip\noindent
}
{
      \par\noindent
      \fonte{\fonteval}
    \end{center}
  \end{figure*}
}

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%% Definições usadas para geração da capa, folha de rosto e títulos
\def\autorescapa{
%%AUTORESCAPA%%
}
\def\autorestitulo{
  %%AUTORESTITULO%%
}
\def\titulo{%%TITULO%%}

\def\orientadornome{Prof. Dr. Alessandro Brawerman}

\def\local{Curitiba, PR}
\def\ano{%%ANO%%}
\def\setor{%%SETOR%%}
\def\ufpr{%%UFPR%%}
\def\cidade{Curitiba, Brasil}
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%% Cria a capa em 1 coluna
\onecolumn

\capa{\autorescapa}

%% Inclusão do Termo de Aprovação (trocar o PDF pelo termo assinado depois da banca)
\includepdf{termo_aprovacao.pdf}

%% Cria o título do artigo
\twocolumn
\title{\titulo}

\autores{\autorestitulo}

\maketitle

\thispagestyle{plain}
\pagestyle{plain}

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Resumo e palavras-chave
\begin{resumo}
%%RESUMO%%
\end{resumo}

\begin{palavraschave}
%%PALAVRAS%%
\end{palavraschave}

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Abstract e keywords
\begin{abstract}
%%ABSTRACT%%
\end{abstract}

\begin{keywords}
%%KEYWORDS%%
\end{keywords}


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Início do documento propriamente dito

%%CORPO%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% REFERÊNCIAS (já na ordem da primeira citação, como no artigo montado)

\def\refname{Referências}

\begin{thebibliography}{99}

%%REFERENCIAS%%

\end{thebibliography}

\end{document}
TEX

my %v = (
  DATA => strftime('%d/%m/%Y', localtime), ANO => strftime('%Y', localtime),
  # na capa, um nome por linha; no título, os nomes separados por vírgula, como no modelo do curso
  AUTORESCAPA => join("\n", map { '    \textsc{\Large ' . esc(uc $_) . '}\\\\' } @autores),
  AUTORESTITULO => join(', ', map { esc($_) . '\refmark{1}' } @autores),
  AUTORES => esc(join(', ', @autores)), TITULO => inline($titulo),
  SETOR => esc($setor), UFPR => esc($ufpr),
  RESUMO => $resumo{'Resumo'}, PALAVRAS => $resumo{'Palavras-chave'},
  ABSTRACT => $resumo{'Abstract'}, KEYWORDS => $resumo{'Keywords'},
  CORPO => join("\n", @corpo),
  REFERENCIAS => join("\n\n", map { "\\bibitem{$_->[0]} " . inline($_->[1], 1) } @refs),
);
$tex =~ s/%%(\w+)%%/exists $v{$1} ? $v{$1} : die "marcador $1 sem valor\n"/ge;

# ---------------------------------------------------------------- conferências (não há LaTeX aqui para compilar)
my @erros;
{
  my $s = $tex =~ s/^%.*$//mgr;          # linhas de comentário
  $s =~ s/(?<!\\)%.*$//mg;               # comentários no fim da linha
  $s =~ s/\\[{}%&\$#_]//g;               # caracteres escapados
  my $p = 0; my $linha = 1;
  for my $c (split //, $s) { $linha++ if $c eq "\n"; $p++ if $c eq '{'; $p-- if $c eq '}'; push @erros, "chave fechada sem abrir perto da linha $linha" and last if $p < 0 }
  push @erros, "chaves desbalanceadas (saldo $p)" if $p > 0;
  my @pilha;
  while ($s =~ /\\(begin|end)\{([^}]+)\}/g) {
    if ($1 eq 'begin') { push @pilha, $2 }
    else { my $a = pop @pilha // ''; push @erros, "\\end{$2} fecha \\begin{$a}" if $a ne $2 }
  }
  push @erros, "ambientes sem \\end: @pilha" if @pilha;
  my %bib = map { $_->[0] => 1 } @refs;
  for my $c ($s =~ /\\cite\{([^}]+)\}/g) { push @erros, "\\cite{$c} sem \\bibitem" unless $bib{$c} }
  (my $sem = $s) =~ s/\\(?:url|includegraphics(?:\[[^\]]*\])?|includepdf|input)\{[^}]*\}//g;
  while ($sem =~ /(?<!\\)(#(?!\d)|[%_^"])/g) {
    my $ini = $-[0] > 40 ? $-[0] - 40 : 0;
    push @erros, "caractere especial sem escape ($1) em: ..." . substr($sem, $ini, 80) =~ s/\n/ /gr . '...';
  }
  push @erros, "caractere fora do Latin-1: " . sprintf('U+%04X', ord $1) while $tex =~ /([^\x{0}-\x{FF}])/g;
}
die join("\n", 'O .tex gerado tem problemas:', @erros) . "\n" if @erros;

# ---------------------------------------------------------------- pasta do projeto LaTeX
make_path("$saida/figuras");
unlink glob("$saida/figuras/*");   # figuras de versões anteriores, que já não estão no artigo
for my $f (qw(IEEEtran.cls tads.tex bg_capa.jpg termo_aprovacao.pdf)) {
  copy("$modelo/$f", "$saida/$f") or die "não copiei $f do modelo: $!\n";
}
my @figs = $tex =~ /\\includegraphics\[[^\]]*\]\{([^}]+)\}/g;
for my $f (@figs) { copy("$dir/$f", "$saida/$f") or die "não copiei a figura $f: $!\n" }
open my $o, '>', "$saida/textoprincipal.tex" or die "não gravei o textoprincipal.tex: $!\n";
print $o $tex;
close $o;

# Pacote para o Overleaf, com os caminhos relativos à pasta do projeto (figuras/...)
my $pacote = "$dir/TCC1-NeuroSight-LaTeX.zip";
my @arquivos = ('textoprincipal.tex', qw(tads.tex IEEEtran.cls bg_capa.jpg termo_aprovacao.pdf), @figs);
zip [ map { "$saida/$_" } @arquivos ] => $pacote, FilterName => sub { s{^\Q$saida\E/}{} }
  or die "não gerei o pacote .zip: $ZipError\n";

printf "Gerado: %s/textoprincipal.tex (%d seções, %d figuras, %d referências, %d notas de rodapé)\n",
  $saida, scalar(() = $tex =~ /\\section\{/g), scalar(@figs), scalar(@refs), scalar(keys %nota);
print "Pacote para o Overleaf: $pacote\n";

# ---------------------------------------------------------------- PDF (opcional)
exit 0 unless $compilar;
my ($pdflatex) = grep { -x $_ } map { ("$_/pdflatex.exe", "$_/pdflatex") } File::Spec->path();
unless ($pdflatex) {
  my $t = ($ENV{APPDATA} // '') =~ s{\\}{/}gr . '/TinyTeX/bin/windows/pdflatex.exe';
  $pdflatex = $t if -x $t;
}
die "pdflatex não encontrado (nem no PATH nem em %APPDATA%\\TinyTeX)\n" unless $pdflatex;
chdir $saida or die "não entrei em $saida: $!\n";
make_path('build');
# duas passadas: a segunda resolve as citações e a numeração
my $nulo = File::Spec->devnull;
for my $passada (1, 2) {
  system(qq{"$pdflatex" -interaction=nonstopmode -file-line-error -output-directory=build textoprincipal.tex > $nulo 2>&1});
  next unless $?;
  # o log do pdflatex não é UTF-8; lido em bytes, só para mostrar as linhas de erro
  open my $h, '<:raw', 'build/textoprincipal.log' or die "o pdflatex falhou e não deixou log\n";
  my @erros = grep { /^\.\/[^:]+:\d+:|^! / } <$h>;
  close $h;
  die join('', "O pdflatex parou com erro (veja Texto-TCC/LaTeX/build/textoprincipal.log):\n", @erros[0 .. ($#erros < 9 ? $#erros : 9)]);
}
copy('build/textoprincipal.pdf', "$dir/TCC1-NeuroSight.pdf") or die "não copiei o PDF: $!\n";
print "PDF: $dir/TCC1-NeuroSight.pdf\n";
