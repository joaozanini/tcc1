# Gera a versão em Word (.docx) do artigo no formato do modelo do curso (Referencias-e-modelos/TCC_Artigo_Modelo_2026.pdf):
# capa, folha de rosto, página do termo de aprovação e o artigo em duas colunas.
# Usa o Microsoft Word instalado no computador.
# Uso, na pasta do TCC (depois de montar o artigo com montar-artigo.pl):
#   powershell -ExecutionPolicy Bypass -File .\Texto-TCC\gerar-docx.ps1
# Opcional: -Pdf <arquivo.pdf> também exporta um PDF; -Orientador "Prof. Dr. Fulano de Tal" preenche a folha de rosto.
param(
  [string]$Entrada    = (Join-Path $PSScriptRoot 'Artigo-TCC1-NeuroSight.md'),
  [string]$Saida      = (Join-Path $PSScriptRoot 'Artigo-TCC1-NeuroSight.docx'),
  [string]$Pdf        = '',
  [string]$Orientador = 'Prof. Dr. Alessandro Brawerman',
  [string]$Cidade     = 'CURITIBA, PR',
  [string]$Ano        = '2026'
)
$ErrorActionPreference = 'Stop'
$pasta  = Split-Path -Parent (Resolve-Path $Entrada)
$linhas = [System.IO.File]::ReadAllLines((Resolve-Path $Entrada), [System.Text.Encoding]::UTF8)

# O documento começa no título do artigo; as notas de trabalho acima dele ficam de fora.
$ini = -1
for ($k = 0; $k -lt $linhas.Count; $k++) { if ($linhas[$k] -like '# NeuroSight:*') { $ini = $k; break } }
if ($ini -lt 0) { throw 'Título do artigo não encontrado.' }
$linhas = $linhas[$ini..($linhas.Count - 1)]
$titulo = $linhas[0].Substring(2)
# Os autores vêm na mesma linha, separados por vírgula
$autores = @()
foreach ($l in $linhas[1..5]) { if ($l -match '\S' -and $l -notlike '**Resumo*') { $autores = @($l -split ', '); break } }

$notas = @{}
foreach ($l in $linhas) { if ($l -match '^\[\^(\d+)\]: (.+)$') { $notas[$Matches[1]] = $Matches[2] } }

$cm = 28.3465
$largTexto = 16.0          # 21 cm menos as margens de 3 cm e 2 cm
$espColunas = 0.6
$largColuna = ($largTexto - $espColunas) / 2
# Figuras ocupam a largura toda da página (como figure* no LaTeX), para o texto continuar legível
$larguras = @{ 'Figura-1' = 16.0; 'Figura-2' = 13.0 }
$padrao = '\*\*(.+?)\*\*|\*(.+?)\*|`([^`]+)`|\[\^(\d+)\]|\\([<>])'

$jaAberto = @(Get-Process WINWORD -ErrorAction SilentlyContinue).Count -gt 0
$word = New-Object -ComObject Word.Application
if (-not $jaAberto) { $word.Visible = $false }
$word.DisplayAlerts = 0
$doc = $word.Documents.Add()
$sel = $word.Selection

function Novo-Estilo([string]$nome, [scriptblock]$ajuste) {
  $s = $doc.Styles.Add($nome, 1)
  $s.BaseStyle = $doc.Styles.Item(-1).NameLocal
  & $ajuste $s
  $s.NameLocal
}

function Trecho([string]$t, [bool]$negrito, [bool]$italico, [bool]$codigo) {
  if ($t.Length -eq 0) { return }
  $sel.Font.Reset()
  if ($negrito) { $sel.Font.Bold = -1 }
  if ($italico) { $sel.Font.Italic = -1 }
  if ($codigo)  { $sel.Font.Name = 'Consolas'; $sel.Font.Size = $sel.Font.Size - 1 }
  $sel.TypeText($t)
}

function Inline([string]$texto) {
  $pos = 0
  foreach ($m in [regex]::Matches($texto, $padrao)) {
    if ($m.Index -gt $pos) { Trecho $texto.Substring($pos, $m.Index - $pos) $false $false $false }
    if     ($m.Groups[1].Success) { Trecho $m.Groups[1].Value $true $false $false }
    elseif ($m.Groups[2].Success) { Trecho $m.Groups[2].Value $false $true $false }
    elseif ($m.Groups[3].Success) { Trecho $m.Groups[3].Value $false $false $true }
    elseif ($m.Groups[4].Success) {
      $sel.Font.Reset()
      $null = $doc.Footnotes.Add($sel.Range, [Type]::Missing, $notas[$m.Groups[4].Value])
      $null = $sel.EndKey(6)
    }
    else { Trecho $m.Groups[5].Value $false $false $false }
    $pos = $m.Index + $m.Length
  }
  if ($pos -lt $texto.Length) { Trecho $texto.Substring($pos) $false $false $false }
}

function Paragrafo([string]$estilo, [string]$texto) {
  $sel.Style = $estilo
  Inline $texto
  $sel.Font.Reset()
  $sel.TypeParagraph()
}

# Parágrafo de texto simples com formatação ajustada na hora (usado na capa e na folha de rosto)
function Linha([string]$texto, [double]$espAntes, [int]$alinh, [double]$tam, [bool]$versalete) {
  $sel.Style = $estNormal
  $pf = $sel.ParagraphFormat
  $pf.Alignment = $alinh; $pf.FirstLineIndent = 0; $pf.LeftIndent = 0; $pf.SpaceBefore = $espAntes; $pf.SpaceAfter = 0; $pf.LineSpacingRule = 0
  $sel.Font.Reset()
  $sel.Font.Size = $tam
  if ($versalete) { $sel.Font.SmallCaps = -1 }
  $sel.TypeText($texto)
  $sel.Font.Reset()
  $sel.TypeParagraph()
}

# Nomes dos autores em maiúsculas, um por linha, como na capa do modelo do curso
function Autores([double]$espAntes) {
  foreach ($a in $autores) { Linha $a.ToUpper() $espAntes 1 12 $false; $espAntes = 0 }
}

# Bloco recuado à direita da folha de rosto (natureza do trabalho e orientador)
function Natureza([string]$texto, [double]$espAntes) {
  $sel.Style = $estNormal
  $pf = $sel.ParagraphFormat
  $pf.Alignment = 3; $pf.FirstLineIndent = 0; $pf.LeftIndent = 7.6 * $cm; $pf.SpaceBefore = $espAntes; $pf.SpaceAfter = 0
  $sel.Font.Size = 10
  $sel.TypeText($texto)
  $sel.Font.Reset()
  $sel.TypeParagraph()
}

function Inserir-Na-Celula($celula, [string]$t, [bool]$negrito, [bool]$italico) {
  if ($t.Length -eq 0) { return }
  $r = $celula.Range
  $null = $r.MoveEnd(1, -1)
  $r.Collapse(0)
  $r.InsertAfter($t)
  $r.Font.Bold   = $(if ($negrito) { -1 } else { 0 })
  $r.Font.Italic = $(if ($italico) { -1 } else { 0 })
}

function Celula($celula, [string]$texto) {
  $pos = 0
  foreach ($m in [regex]::Matches($texto, $padrao)) {
    if ($m.Index -gt $pos) { Inserir-Na-Celula $celula $texto.Substring($pos, $m.Index - $pos) $false $false }
    if     ($m.Groups[1].Success) { Inserir-Na-Celula $celula $m.Groups[1].Value $true $false }
    elseif ($m.Groups[2].Success) { Inserir-Na-Celula $celula $m.Groups[2].Value $false $true }
    else                          { Inserir-Na-Celula $celula $m.Value.Trim('`', '\') $false $false }
    $pos = $m.Index + $m.Length
  }
  if ($pos -lt $texto.Length) { Inserir-Na-Celula $celula $texto.Substring($pos) $false $false }
}

function Linhas-Da-Tabela([string[]]$tab) {
  $r = @()
  foreach ($l in $tab) {
    if ($l -match '^\|\s*-') { continue }
    $r += ,(@($l.Trim().Trim('|').Split('|') | ForEach-Object { $_.Trim() }))
  }
  ,$r
}

function Tabela($linhasTab, [string]$estilo, $alvo = $null) {
  $nl = $linhasTab.Count; $nc = $linhasTab[0].Count
  $aninhada = $null -ne $alvo
  if (-not $aninhada) { $sel.Style = $estilo; $alvo = $sel.Range }
  $t = $doc.Tables.Add($alvo, $nl, $nc)
  $t.Range.Style = $estilo
  for ($i = 0; $i -lt $nl; $i++) {
    for ($j = 0; $j -lt $nc; $j++) { Celula $t.Cell($i + 1, $j + 1) $linhasTab[$i][$j] }
  }
  # Linhas como no exemplo: em cima, embaixo do cabeçalho, embaixo e entre as colunas
  $t.Borders.Enable = 0
  foreach ($b in -1, -3, -6) { $t.Borders.Item($b).LineStyle = 1 }
  $cab = $t.Rows.Item(1)
  $cab.Borders.Item(-3).LineStyle = 1
  $cab.Range.Font.Bold = -1
  $cab.HeadingFormat = -1
  $t.AutoFitBehavior(1)
  $t.AutoFitBehavior(2)
  if ($nc -eq 2 -and -not $aninhada) {
    $t.AllowAutoFit = $false
    $t.Columns.Item(1).Width = 2.6 * $cm
    $t.Columns.Item(2).Width = ($largColuna - 2.6) * $cm
  }
  if (-not $aninhada) { $null = $sel.EndKey(6) }
}

# Bloco flutuante da largura da página, no topo da página (como figure* e table* no LaTeX):
# uma tabela sem bordas com a legenda, o conteúdo e a fonte, que o texto das duas colunas contorna
function Novo-Flutuante([string]$legenda, [string]$fonte) {
  $sel.Style = $estFigura
  $t = $doc.Tables.Add($sel.Range, 3, 1)
  $t.Borders.Enable = 0
  $t.AllowAutoFit = $false
  $t.LeftPadding = 0; $t.RightPadding = 0
  $t.Columns.Item(1).Width = $largTexto * $cm
  $t.Rows.WrapAroundText = -1
  $t.Rows.RelativeHorizontalPosition = 0
  $t.Rows.HorizontalPosition = -999995
  $t.Rows.RelativeVerticalPosition = 0
  $t.Rows.VerticalPosition = -999999
  $t.Rows.AllowOverlap = 0
  $t.Rows.DistanceTop = 0
  $t.Rows.DistanceBottom = 14
  $t.Cell(1, 1).Range.Style = $estLegenda
  $t.Cell(1, 1).Range.Text = $legenda
  $t.Cell(2, 1).Range.Style = $estFigura
  $t.Cell(3, 1).Range.Style = $estFonte
  $t.Cell(3, 1).Range.Text = $fonte
  $t
}

function Figura-Flutuante([string]$legenda, [string]$caminho, [string]$fonte) {
  $t = Novo-Flutuante $legenda $fonte
  $nome = [System.IO.Path]::GetFileNameWithoutExtension($caminho)
  $larg = $largTexto
  foreach ($k in $larguras.Keys) { if ($nome.StartsWith($k)) { $larg = $larguras[$k] } }
  $img = $t.Cell(2, 1).Range.InlineShapes.AddPicture($caminho, $false, $true)
  $img.LockAspectRatio = -1
  $img.Width = $larg * $cm
  $null = $sel.EndKey(6)
}

function Tabela-Flutuante([string]$legenda, $linhasTab, [string]$fonte) {
  $t = Novo-Flutuante $legenda $fonte
  $r = $t.Cell(2, 1).Range
  $r.Collapse(1)
  Tabela $linhasTab $estTabela $r
  $null = $sel.EndKey(6)
}

# Como o figure* do LaTeX, o bloco largo vai para o topo da página seguinte à da chamada: fica na fila
# e entra no primeiro ponto do texto que já estiver nessa página. Se entrasse logo depois da chamada e
# não coubesse na página, o Word o levaria para a próxima e deixaria o resto da coluna em branco.
$fila = New-Object System.Collections.ArrayList
function Pagina-Atual { [int]$sel.Range.Information(3) }

function Esvaziar-Fila([bool]$tudo) {
  while ($fila.Count -gt 0) {
    $b = $fila[0]
    if (-not $tudo -and (Pagina-Atual) -le $b.Pagina) { return }
    $fila.RemoveAt(0)
    if ($b.Figura) { Figura-Flutuante $b.Legenda $b.Figura $b.Fonte }
    else { Tabela-Flutuante $b.Legenda $b.Linhas $b.Fonte }
    # um bloco por página
    if ($fila.Count -gt 0) { $fila[0].Pagina = Pagina-Atual }
  }
}

# Quebra de seção contínua que muda o número de colunas (1 = largura toda, 2 = duas colunas)
function Colunas([int]$n) {
  $sel.InsertBreak(3)
  $cols = $sel.Sections.Item(1).PageSetup.TextColumns
  $cols.SetCount($n)
  if ($n -gt 1) { $cols.EvenlySpaced = -1; $cols.Spacing = $espColunas * $cm }
}

try {
  # Página A4 com as margens do modelo (3 cm em cima e à esquerda, 2 cm embaixo e à direita)
  $ps = $doc.PageSetup
  $ps.PageWidth = 21 * $cm; $ps.PageHeight = 29.7 * $cm
  $ps.TopMargin = 3 * $cm; $ps.LeftMargin = 3 * $cm; $ps.BottomMargin = 2 * $cm; $ps.RightMargin = 2 * $cm

  # Estilos do artigo, no padrão do exemplo: Times New Roman 10, espaço simples, recuo de primeira linha
  $normal = $doc.Styles.Item(-1)
  $normal.Font.Name = 'Times New Roman'; $normal.Font.Size = 10
  $pf = $normal.ParagraphFormat
  $pf.Alignment = 3; $pf.FirstLineIndent = 0.35 * $cm; $pf.LeftIndent = 0; $pf.LineSpacingRule = 0; $pf.SpaceBefore = 0; $pf.SpaceAfter = 0
  $pf.WidowControl = -1
  foreach ($id in -2, -3, -63) {
    $s = $doc.Styles.Item($id)
    $s.Font.Name = 'Times New Roman'; $s.Font.Color = -16777216; $s.Font.Size = 10; $s.Font.Bold = 0
    $s.ParagraphFormat.FirstLineIndent = 0; $s.ParagraphFormat.LeftIndent = 0; $s.ParagraphFormat.LineSpacingRule = 0
    $s.ParagraphFormat.KeepWithNext = -1
  }
  $h1 = $doc.Styles.Item(-2);  $h1.Font.Italic = 0;  $h1.Font.SmallCaps = -1; $h1.ParagraphFormat.Alignment = 1; $h1.ParagraphFormat.SpaceBefore = 12; $h1.ParagraphFormat.SpaceAfter = 6
  $h2 = $doc.Styles.Item(-3);  $h2.Font.Italic = -1; $h2.ParagraphFormat.Alignment = 0; $h2.ParagraphFormat.SpaceBefore = 8; $h2.ParagraphFormat.SpaceAfter = 3
  $ti = $doc.Styles.Item(-63); $ti.Font.Size = 24; $ti.Font.Italic = 0; $ti.ParagraphFormat.Alignment = 1; $ti.ParagraphFormat.SpaceBefore = 0; $ti.ParagraphFormat.SpaceAfter = 12
  $nr = $doc.Styles.Item(-30); $nr.Font.Name = 'Times New Roman'; $nr.Font.Size = 8
  $nr.ParagraphFormat.FirstLineIndent = 0; $nr.ParagraphFormat.LineSpacingRule = 0; $nr.ParagraphFormat.SpaceAfter = 0
  $li = $doc.Styles.Item(-49); $li.Font.Name = 'Times New Roman'; $li.Font.Size = 10
  $li.ParagraphFormat.Alignment = 3; $li.ParagraphFormat.LineSpacingRule = 0; $li.ParagraphFormat.SpaceAfter = 0
  $estLista = $li.NameLocal
  $estTitulo = $ti.NameLocal; $estH1 = $h1.NameLocal; $estH2 = $h2.NameLocal; $estNormal = $normal.NameLocal

  $estAutor = Novo-Estilo 'Autor IEEE' { param($s) $s.Font.Size = 11; $s.ParagraphFormat.Alignment = 1; $s.ParagraphFormat.FirstLineIndent = 0 }
  $estAfil = Novo-Estilo 'Afiliação IEEE' { param($s) $s.Font.Italic = -1; $s.ParagraphFormat.Alignment = 1; $s.ParagraphFormat.FirstLineIndent = 0 }
  $estResumo = Novo-Estilo 'Resumo IEEE' { param($s) $s.Font.Size = 9; $s.Font.Bold = -1; $s.ParagraphFormat.SpaceAfter = 3 }
  $estLegenda = Novo-Estilo 'Legenda IEEE' { param($s) $s.Font.Size = 9; $s.ParagraphFormat.Alignment = 1; $s.ParagraphFormat.FirstLineIndent = 0; $s.ParagraphFormat.SpaceBefore = 8; $s.ParagraphFormat.SpaceAfter = 4; $s.ParagraphFormat.KeepWithNext = -1 }
  $estFonte = Novo-Estilo 'Fonte IEEE' { param($s) $s.Font.Size = 9; $s.ParagraphFormat.Alignment = 1; $s.ParagraphFormat.FirstLineIndent = 0; $s.ParagraphFormat.SpaceBefore = 4; $s.ParagraphFormat.SpaceAfter = 8 }
  $estFigura = Novo-Estilo 'Figura IEEE' { param($s) $s.ParagraphFormat.Alignment = 1; $s.ParagraphFormat.FirstLineIndent = 0; $s.ParagraphFormat.KeepWithNext = -1 }
  $estTabela = Novo-Estilo 'Tabela IEEE' { param($s) $s.Font.Size = 8; $s.ParagraphFormat.Alignment = 0; $s.ParagraphFormat.FirstLineIndent = 0 }
  $estRef = Novo-Estilo 'Referência IEEE' { param($s) $s.Font.Size = 8; $s.ParagraphFormat.Alignment = 3; $s.ParagraphFormat.LeftIndent = 0.6 * $cm; $s.ParagraphFormat.FirstLineIndent = -0.6 * $cm; $s.ParagraphFormat.SpaceAfter = 2 }

  # ------------------------------------------------------------------ capa (o desenho do prédio entra no fim)
  # cada autor a mais ocupa uma linha (cerca de 0,5 cm), descontada do espaço antes do título para a página não crescer
  $linhasAMais = ($autores.Count - 1) * 0.5 * $cm
  Linha 'UNIVERSIDADE FEDERAL DO PARANÁ' 0 1 12 $false
  Autores (3.0 * $cm)
  Linha $titulo (9.0 * $cm - $linhasAMais) 1 12 $true
  Linha $Cidade (8.0 * $cm) 1 12 $true
  Linha $Ano 0 1 12 $false
  $sel.InsertBreak(7)

  # ------------------------------------------------------------------ folha de rosto
  Autores (0.5 * $cm)
  Linha $titulo (10.0 * $cm - $linhasAMais) 1 12 $true
  $natureza = 'Trabalho de conclusão de curso apresentado ao curso de graduação em Análise e Desenvolvimento de Sistemas, Setor de Educação Profissional e Tecnológica, Universidade Federal do Paraná, como requisito parcial à obtenção do título de tecnólogo.'
  Natureza $natureza (1.0 * $cm)
  Natureza "Orientador: $Orientador." 6.0
  Linha $Cidade (6.5 * $cm) 1 12 $true
  Linha $Ano 0 1 12 $false
  $sel.InsertBreak(7)

  # ------------------------------------------------------------------ termo de aprovação (entregue depois da banca)
  $sel.Style = $estNormal
  $sel.ParagraphFormat.FirstLineIndent = 0
  $sel.Font.Size = 12; $sel.Font.Color = 255
  $sel.TypeText('Insira aqui o termo de aprovação do TCC, fornecido após a aprovação em banca.')
  $sel.Font.Reset()
  $sel.TypeParagraph()

  # ------------------------------------------------------------------ artigo
  $sel.InsertBreak(2)
  $secArtigo = $sel.Sections.Item(1)
  $rodape = $secArtigo.Footers.Item(1)
  $rodape.LinkToPrevious = $false
  $null = $rodape.PageNumbers.Add(1, $true)

  $k = 0; $cabecalho = $true; $autorFeito = $false; $nasReferencias = $false
  while ($k -lt $linhas.Count) {
    $l = $linhas[$k]
    if ($l -match '^\s*$' -or $l -eq '---' -or $l -match '^\[\^\d+\]: ') { $k++; continue }
    if ($fila.Count -gt 0) { Esvaziar-Fila $false }
    if ($l -like '# *') { Paragrafo $estTitulo $l.Substring(2); $k++; continue }
    if ($cabecalho -and $l -notlike '**Resumo:*' -and $l -notlike '## *') {
      if (-not $autorFeito) { Paragrafo $estAutor $l; $autorFeito = $true }
      else { foreach ($parte in ($l -split ', ')) { Paragrafo $estAfil $parte } }
      $k++; continue
    }
    if ($cabecalho) { $cabecalho = $false; Colunas 2 }
    if ($l -match '^\*\*(Resumo|Palavras-chave|Abstract|Keywords):\*\* (.+)$') {
      $sel.Style = $estResumo
      if ($Matches[1] -eq 'Resumo') { $sel.ParagraphFormat.SpaceBefore = 8 }
      Trecho ($Matches[1] + ': ') $true $true $false
      Inline $Matches[2]
      $sel.Font.Reset(); $sel.TypeParagraph(); $k++; continue
    }
    if ($l -like '## *') { $nasReferencias = ($l -eq '## REFERÊNCIAS'); Paragrafo $estH1 $l.Substring(3); $k++; continue }
    if ($l -like '#### *') { Paragrafo $estH2 $l.Substring(5); $k++; continue }
    if ($l -like '### *') { Paragrafo $estH2 $l.Substring(4); $k++; continue }
    if ($l -match '^\*\*(FIGURA|TABELA) (\d+)\*\* - (.+)$') {
      $legenda = "{0} {1} - {2}" -f $Matches[1], $Matches[2], $Matches[3]
      # junta legenda, conteúdo (figura ou tabela) e fonte num bloco só
      $j = $k + 1; while ($j -lt $linhas.Count -and $linhas[$j] -match '^\s*$') { $j++ }
      if ($linhas[$j].StartsWith('![')) {
        $null = $linhas[$j] -match '^!\[[^\]]*\]\(([^)]+)\)'
        $caminho = Join-Path $pasta $Matches[1]
        $j++; while ($j -lt $linhas.Count -and $linhas[$j] -match '^\s*$') { $j++ }
        $null = $fila.Add([pscustomobject]@{ Legenda = $legenda; Figura = $caminho; Linhas = $null; Fonte = $linhas[$j]; Pagina = (Pagina-Atual) })
        $k = $j + 1; continue
      }
      $tab = @(); while ($j -lt $linhas.Count -and $linhas[$j] -like '|*') { $tab += $linhas[$j]; $j++ }
      while ($j -lt $linhas.Count -and $linhas[$j] -match '^\s*$') { $j++ }
      $fonteTab = $linhas[$j]
      $linhasTab = Linhas-Da-Tabela $tab
      if ($linhasTab[0].Count -gt 3) {
        $null = $fila.Add([pscustomobject]@{ Legenda = $legenda; Figura = $null; Linhas = $linhasTab; Fonte = $fonteTab; Pagina = (Pagina-Atual) })
      } else {
        # tabela estreita fica na coluna, como a Tabela 1 do exemplo
        Paragrafo $estLegenda $legenda
        Tabela $linhasTab $estTabela
        Paragrafo $estFonte $fonteTab
      }
      $k = $j + 1; continue
    }
    if ($l -like '|*') {
      $tab = @(); while ($k -lt $linhas.Count -and $linhas[$k] -like '|*') { $tab += $linhas[$k]; $k++ }
      Tabela (Linhas-Da-Tabela $tab) $estTabela; continue
    }
    if ($l -like '- *') { Paragrafo $estLista $l.Substring(2); $k++; continue }
    if ($l -match '^\d+\. ') { Paragrafo $estLista $l; $k++; continue }
    if ($nasReferencias) { Paragrafo $estRef $l; $k++; continue }
    Paragrafo $estNormal $l; $k++
  }
  Esvaziar-Fila $true
  # quebra contínua no fim equilibra as duas colunas da última página
  $sel.InsertBreak(3)

  # Desenho do prédio da UFPR atrás do texto da capa. Entra só agora, preso ao primeiro parágrafo,
  # porque preso ao documento ainda vazio ele acompanhava o texto digitado e ia parar no meio do artigo.
  $fundo = Join-Path $pasta 'figuras\capa-ufpr.jpg'
  if (Test-Path $fundo) {
    $img = $doc.Shapes.AddPicture($fundo, $false, $true, 0, 0, 100, 100, $doc.Paragraphs.Item(1).Range)
    $img.WrapFormat.Type = 5
    $img.RelativeHorizontalPosition = 1; $img.RelativeVerticalPosition = 1
    $img.LockAspectRatio = 0
    $img.Width = 19.3 * $cm; $img.Height = 27.9 * $cm
    $img.Left = 0.85 * $cm; $img.Top = 0.9 * $cm
  }

  # Idioma: português do Brasil, com o Abstract e as keywords em inglês
  $doc.Content.LanguageID = 1046
  foreach ($p in $doc.Paragraphs) {
    $txt = $p.Range.Text
    if ($txt.StartsWith('Abstract:') -or $txt.StartsWith('Keywords:')) { $p.Range.LanguageID = 1033 }
  }

  $doc.SaveAs2([string](Join-Path (Resolve-Path (Split-Path -Parent $Saida)) (Split-Path -Leaf $Saida)), 16)
  if ($Pdf) { $doc.ExportAsFixedFormat($Pdf, 17) }
  Write-Host ("Gerado: {0} ({1} páginas, {2} notas, {3} tabelas, {4} figuras)" -f $Saida, $doc.ComputeStatistics(2), $doc.Footnotes.Count, $doc.Tables.Count, $doc.InlineShapes.Count)
}
finally {
  $doc.Close(0)
  if (-not $jaAberto) { $word.Quit() }
  $null = [System.Runtime.InteropServices.Marshal]::ReleaseComObject($word)
}
