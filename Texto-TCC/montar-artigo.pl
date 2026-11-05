#!/usr/bin/perl
# Junta as seções do artigo do TCC1 num arquivo só, troca as chaves de citação pela
# numeração final (ordem da primeira citação) e monta a lista de referências.
# Uso (no Git Bash, na pasta do TCC): perl Texto-TCC/montar-artigo.pl
# Sem argumentos, lê as seções da pasta do script e grava Artigo-TCC1-NeuroSight.md nela.
# O artigo segue o modelo Referencias-e-modelos/TCC_Artigo_Modelo_2026.pdf: Seções I a IV e as
# referências, sem apêndices. A modelagem completa vai na Especificação Técnica (Especificacao-Tecnica/).
use strict;
use warnings;
use utf8;
use open qw(:std :encoding(UTF-8));
use FindBin;
use POSIX qw(strftime);

my $dir   = $ARGV[0] // $FindBin::Bin;
my $saida = $ARGV[1] // "$dir/Artigo-TCC1-NeuroSight.md";

my @secoes = (
  ['I-Introducao.md',                         qr/^## I\. INTRODUÇÃO/m,                           qr/^## Referências citadas/m],
  ['II-Revisao-de-literatura.md',             qr/^## II\. REVISÃO DE LITERATURA/m,               qr/^## Referências novas/m],
  ['III-Metodo-tecnologias-e-arquitetura.md', qr/^## III\. MÉTODO, TECNOLOGIAS E ARQUITETURA/m,  qr/^## Referências citadas/m],
  ['IV-Consideracoes-finais.md',              qr/^## IV\. CONSIDERAÇÕES FINAIS/m,                qr/^## Referências novas/m],
);

sub ler { my ($f) = @_; open my $h, '<', $f or die "não abri $f: $!\n"; local $/; my $t = <$h>; close $h; $t =~ s/\r\n/\n/g; return $t; }

# ---------------------------------------------------------------- referências de todos os arquivos
my (%ref, %origem);
for my $s (@secoes) {
  my $t = ler("$dir/$s->[0]");
  while ($t =~ /^- \*\*\[([A-Z][A-Z0-9-]+)\]\*\* (.+)$/mg) {
    my ($k, $e) = ($1, $2);
    $e =~ s/\s*\(Já citada no 1\.1[^)]*\)\s*$//;
    if (exists $ref{$k} && $ref{$k} ne $e) { die "referência [$k] diferente em $origem{$k} e $s->[0]\n"; }
    $ref{$k} = $e; $origem{$k} //= $s->[0];
  }
}

# ---------------------------------------------------------------- corpos das seções
my @corpos;
for my $s (@secoes) {
  my ($arq, $ini, $fim) = @$s;
  my $t = ler("$dir/$arq");
  $t =~ $ini or die "início não encontrado em $arq\n"; my $a = $-[0];
  $t =~ $fim or die "fim não encontrado em $arq\n";    my $b = $-[0];
  my $c = substr($t, $a, $b - $a);
  $c =~ s/\n---\s*\n\s*$/\n/;            # separador antes das referências
  $c =~ s/\s+$/\n/;
  push @corpos, $c;
}

# notas de rodapé da Seção III viram notas do Markdown
for my $c (@corpos) {
  next unless $c =~ /\*\*Notas de rodapé\*\*/;
  $c =~ s/orientador¹/orientador[^1]/;
  $c =~ s/on-line²/on-line[^2]/;
  $c =~ s/\*\*Notas de rodapé\*\*\n\n¹ (.+)\n\n² (.+)\n/[^1]: $1\n\n[^2]: $2\n/ or die "notas de rodapé da Seção III fora do formato esperado\n";
}

# ---------------------------------------------------------------- numeração pela primeira citação
my (%num, @ordem);
my $todos = join("\n", @corpos);
while ($todos =~ /\[([A-Z][A-Z0-9-]+)\]/g) {
  my $k = $1;
  next if exists $num{$k};
  die "citação [$k] sem referência completa\n" unless exists $ref{$k};
  push @ordem, $k; $num{$k} = scalar @ordem;
}
s/\[([A-Z][A-Z0-9-]+)\]/exists $num{$1} ? "[$num{$1}]" : "[$1]"/ge for @corpos;
my @sobra = grep { !exists $num{$_} } sort keys %ref;

# ---------------------------------------------------------------- conferências de formato
# Figuras e tabelas numeradas em sequência e citadas no texto; legendas e fontes sem ponto final
my @figs = $todos =~ /^\*\*FIGURA (\d+)\*\* - /mg;
my @tabs = $todos =~ /^\*\*TABELA (\d+)\*\* - /mg;
for my $x (['Figura', \@figs], ['Tabela', \@tabs]) {
  my ($nome, $lista) = @$x;
  for my $i (0 .. $#$lista) {
    die "$nome $lista->[$i] fora de sequência (esperava " . ($i + 1) . ")\n" unless $lista->[$i] == $i + 1;
    die "$nome $lista->[$i] não é citada no texto\n" unless $todos =~ /\b$nome $lista->[$i]\b/;
  }
}
for my $l ($todos =~ /^(\*\*(?:FIGURA|TABELA) \d+\*\* - .+|FONTE: .+)$/mg) {
  warn "legenda ou fonte com ponto final (o modelo não usa): $l\n" if $l =~ /\.$/;
}

# ---------------------------------------------------------------- saída
# resumo e abstract: lidos de Resumo-e-Abstract.md, se o arquivo existir
my @rotulos = ('Resumo', 'Palavras-chave', 'Abstract', 'Keywords');
my %vazio = (
  'Resumo'         => '[A escrever por último: parágrafo único com objetivo, método, tecnologias e resultado.]',
  'Palavras-chave' => '[cinco palavras-chave, como no modelo].',
  'Abstract'       => '[To be written last.]',
  'Keywords'       => '[five keywords].',
);
my %resumo = map { $_ => "**$_:** $vazio{$_}" } @rotulos;
my $tem_resumo = -e "$dir/Resumo-e-Abstract.md";
if ($tem_resumo) {
  my $t = ler("$dir/Resumo-e-Abstract.md");
  for my $r (@rotulos) {
    $t =~ /^(\*\*\Q$r\E:\*\* .+)$/m or die "linha \"**$r:**\" não encontrada em Resumo-e-Abstract.md\n";
    $resumo{$r} = $1;
  }
}

my $pendencias = $tem_resumo ? '' : '**Ainda falta:** Resumo e Abstract. ';
my $data = strftime('%d/%m/%Y', localtime);

my $cab = "# Artigo do TCC1 – NeuroSight (versão montada)\n\n"
  . "Versão de trabalho de $data, montada a partir dos arquivos das Seções I a IV desta pasta, no formato do modelo do curso (Referencias-e-modelos/TCC_Artigo_Modelo_2026.pdf). As citações já estão com a numeração final, e a lista de referências vem no fim. Para mudar o texto, edite o arquivo da seção e monte de novo com `perl Texto-TCC/montar-artigo.pl`, no Git Bash, a partir da pasta do TCC. Para atualizar a versão de entrega, no modelo LaTeX do curso, rode em seguida `perl Texto-TCC/gerar-latex.pl --pdf` (grava a pasta Texto-TCC/LaTeX, o .zip para o Overleaf e o PDF compilado); para a versão em Word, `powershell -ExecutionPolicy Bypass -File .\\Texto-TCC\\gerar-docx.ps1`.\n\n"
  . "${pendencias}Os artefatos de modelagem não entram no artigo: estão na Especificação Técnica (pasta Especificacao-Tecnica). O desenvolvimento do sistema fica para o TCC2.\n\n"
  . "---\n\n"
  . "# NeuroSight: sistema de rastreamento ocular e emocional em realidade virtual para estudo e apoio ao diagnóstico de pessoas com distúrbios da consciência\n\n"
  . "João Vitor Zanini Pedro, Lucas Sarnacki Guiraud\n\n"
  . "Setor de Educação Profissional e Tecnológica, Universidade Federal do Paraná\n\n"
  . join("\n\n", map { $resumo{$_} } @rotulos) . "\n\n";

my $refs = "## REFERÊNCIAS\n\n" . join("\n\n", map { "[$num{$_}] $ref{$_}" } @ordem) . "\n";

open my $o, '>', $saida or die "não gravei $saida: $!\n";
print $o $cab, join("\n", @corpos), "\n", $refs;
close $o;

printf "%d referências numeradas; %d sem citação: %s\n", scalar @ordem, scalar @sobra, join(' ', @sobra) || '-';
printf "%d figuras e %d tabelas\n", scalar @figs, scalar @tabs;
print join(' ', map { "[$_]=$num{$_}" } @ordem), "\n";
