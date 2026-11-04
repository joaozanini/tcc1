# Preenche o template da Especificação Técnica do curso (Referencias-e-modelos/Template Especificação Técnica
# TCC TADS UFPR.docx) com o conteúdo de Especificacao-Tecnica-NeuroSight.md, gerado por montar-especificacao.pl,
# e grava o .docx e o PDF. Usa o Microsoft Word instalado no computador e os estilos do próprio template
# (Texto, Título 1, Título pós-textual, Apêndice, Título HU, Referência, Resumo, Legenda, Fonte, Texto-Tabela...).
# Uso, na pasta do TCC (depois de montar a especificação):
#   powershell -ExecutionPolicy Bypass -File .\Especificacao-Tecnica\gerar-especificacao-docx.ps1
param(
  [string]$Entrada    = (Join-Path $PSScriptRoot 'Especificacao-Tecnica-NeuroSight.md'),
  # o nome do template tem acentos; ele é localizado por curinga, porque a normalização Unicode do nome no disco pode variar
  [string]$Template   = (Get-ChildItem (Join-Path $PSScriptRoot '..\Referencias-e-modelos') -Filter 'Template*.docx' | Select-Object -First 1 -ExpandProperty FullName),
  [string]$Saida      = (Join-Path $PSScriptRoot 'Especificacao-Tecnica-NeuroSight.docx'),
  [string]$Pdf        = (Join-Path $PSScriptRoot 'Especificacao-Tecnica-NeuroSight.pdf'),
  [string]$Sistema    = 'NEUROSIGHT'
)
$ErrorActionPreference = 'Stop'
Add-Type -AssemblyName System.Drawing
$pasta  = Split-Path -Parent (Resolve-Path $Entrada)
$linhas = [System.IO.File]::ReadAllLines((Resolve-Path $Entrada), [System.Text.Encoding]::UTF8)

# ------------------------------------------------------------------ cabeçalho do .md: autores, orientador, ano, resumo
$meta = @{}
foreach ($l in $linhas) {
  if ($l -match '^(Autores|Orientador|Ano): (.+)$') { $meta[$Matches[1]] = $Matches[2] }
  if ($l -match '^\*\*(Resumo|Palavras-chave|Abstract|Keywords):\*\* (.+)$') { $meta[$Matches[1]] = $Matches[2] }
  if ($l -eq '## CONTEXTUALIZAÇÃO') { break }
}
foreach ($c in 'Autores', 'Orientador', 'Ano', 'Resumo', 'Palavras-chave', 'Abstract', 'Keywords') { if (-not $meta[$c]) { throw "faltou '$c' no cabeçalho de $Entrada" } }
$autores = @($meta['Autores'] -split ', ')
$ini = [array]::IndexOf($linhas, '## CONTEXTUALIZAÇÃO')
if ($ini -lt 0) { throw 'Título CONTEXTUALIZAÇÃO não encontrado.' }
$linhas = $linhas[($ini + 1)..($linhas.Count - 1)]

$cm = 28.3465
$largTexto = 16.0      # A4 com margens de 3 cm (esquerda) e 2 cm (direita)
$altTexto  = 24.7      # 29,7 cm menos 3 cm (superior) e 2 cm (inferior)
$padrao = '\*\*(.+?)\*\*|\*(.+?)\*|`([^`]+)`|\\([<>])'

$jaAberto = @(Get-Process WINWORD -ErrorAction SilentlyContinue).Count -gt 0
$word = New-Object -ComObject Word.Application
if (-not $jaAberto) { $word.Visible = $false }
$word.DisplayAlerts = 0
# Depois de um encerramento forçado, o Word abre o painel de recuperação e rejeita chamadas por alguns segundos
# (RPC_E_CALL_REJECTED): espera, fecha o que ele tiver reaberto e repete as chamadas iniciais se preciso.
Start-Sleep -Seconds 8
function Repetir([scriptblock]$acao) {
  for ($tent = 0; $tent -lt 15; $tent++) { try { return (& $acao) } catch { $erro = $_; Start-Sleep -Seconds 2 } }
  throw $erro
}
Repetir { foreach ($d in @($word.Documents)) { $d.Close(0) } } | Out-Null
# sem redesenhar a tela nem repaginar a cada parágrafo, a digitação pelo COM fica muito mais rápida
Repetir { $word.Options.Pagination = $false } | Out-Null
$doc = Repetir { $word.Documents.Open((Resolve-Path $Template).Path, $false, $true) }   # o template abre só para leitura
$sel = Repetir { $s = $word.Selection; if ($null -eq $s) { throw 'sem seleção' }; $s }

function Estilo([string[]]$nomes) {
  # logo depois de abrir o documento o Word às vezes recusa chamadas (RPC_E_CALL_REJECTED); tenta de novo
  for ($tent = 0; $tent -lt 10; $tent++) {
    foreach ($n in $nomes) { try { return $doc.Styles.Item($n).NameLocal } catch { $erro = $_.Exception.Message } }
    Start-Sleep -Seconds 2
  }
  throw ("estilo não encontrado no template: " + ($nomes -join ', ') + " (" + $erro + ")")
}
function Novo-Estilo([string]$nome, [string]$base, [scriptblock]$ajuste) {
  Repetir {
    $s = $null
    try { $s = $doc.Styles.Item($nome) } catch { $s = $doc.Styles.Add($nome, 1) }
    $s.BaseStyle = $base
    & $ajuste $s
    $s.NameLocal
  }
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
    else { Trecho $m.Groups[4].Value $false $false $false }
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
function Quebra-De-Pagina { $sel.InsertBreak(7) }

function Inserir-Na-Celula($celula, [string]$t, [bool]$negrito, [bool]$italico, [bool]$codigo) {
  if ($t.Length -eq 0) { return }
  $r = $celula.Range
  $null = $r.MoveEnd(1, -1)
  $r.Collapse(0)
  $r.InsertAfter($t)
  $r.Font.Bold   = $(if ($negrito) { -1 } else { 0 })
  $r.Font.Italic = $(if ($italico) { -1 } else { 0 })
  if ($codigo) { $r.Font.Name = 'Consolas' }
}
function Celula($celula, [string]$texto) {
  $pos = 0
  foreach ($m in [regex]::Matches($texto, $padrao)) {
    if ($m.Index -gt $pos) { Inserir-Na-Celula $celula $texto.Substring($pos, $m.Index - $pos) $false $false $false }
    if     ($m.Groups[1].Success) { Inserir-Na-Celula $celula $m.Groups[1].Value $true $false $false }
    elseif ($m.Groups[2].Success) { Inserir-Na-Celula $celula $m.Groups[2].Value $false $true $false }
    elseif ($m.Groups[3].Success) { Inserir-Na-Celula $celula $m.Groups[3].Value $false $false $true }
    else                          { Inserir-Na-Celula $celula $m.Groups[4].Value $false $false $false }
    $pos = $m.Index + $m.Length
  }
  if ($pos -lt $texto.Length) { Inserir-Na-Celula $celula $texto.Substring($pos) $false $false $false }
}
function Linhas-Da-Tabela([string[]]$tab) {
  $r = @()
  foreach ($l in $tab) {
    if ($l -match '^\|\s*-') { continue }
    $r += ,(@($l.Trim().Trim('|').Split('|') | ForEach-Object { $_.Trim() }))
  }
  ,$r
}
function Tabela($linhasTab) {
  $nl = $linhasTab.Count; $nc = $linhasTab[0].Count
  $sel.Style = $estTextoTab
  $t = $doc.Tables.Add($sel.Range, $nl, $nc)
  $t.Range.Style = $estTextoTab
  $t.Range.ParagraphFormat.SpaceAfter = 0
  for ($i = 0; $i -lt $nl; $i++) {
    for ($j = 0; $j -lt $nc; $j++) { Celula $t.Cell($i + 1, $j + 1) $linhasTab[$i][$j] }
  }
  $t.Borders.Enable = -1
  $cab = $t.Rows.Item(1)
  $cab.Range.Font.Bold = -1
  $cab.HeadingFormat = -1
  $t.Rows.AllowBreakAcrossPages = 0
  $t.AutoFitBehavior(1)
  $t.AutoFitBehavior(2)
  $null = $sel.EndKey(6)
}

# Figura no lugar: diagramas largos vão numa página em paisagem, numa seção própria
function Figura([string]$legenda, [string]$caminho, [string]$fonte) {
  $img = [System.Drawing.Image]::FromFile($caminho)
  $w = $img.Width; $h = $img.Height
  $img.Dispose()
  $paisagem = ($w -ge 2600 -and ($w / $h) -ge 1.4)
  if ($paisagem) {
    $sel.InsertBreak(2)                                  # nova seção, na página seguinte
    $sel.Sections.Item(1).PageSetup.Orientation = 1      # paisagem
    $maxL = 24.7; $maxA = 13.3
  } else { $maxL = $largTexto; $maxA = 20.5 }
  Paragrafo $estLegenda $legenda
  $sel.Style = $estFigura
  $forma = $sel.InlineShapes.AddPicture($caminho, $false, $true)
  $forma.LockAspectRatio = -1
  $forma.Width = $maxL * $cm
  if ($forma.Height -gt $maxA * $cm) { $forma.Height = $maxA * $cm }
  $sel.TypeParagraph()
  Paragrafo $estFonte $fonte
  if ($paisagem) {
    $sel.InsertBreak(2)
    $sel.Sections.Item(1).PageSetup.Orientation = 0      # de volta ao retrato
  }
}

# Troca um texto em todo o documento (capa, folha de rosto)
function Substituir([string]$de, [string]$para) {
  $f = $doc.Content.Find
  $f.ClearFormatting(); $f.Replacement.ClearFormatting()
  $null = $f.Execute($de, $true, $false, $false, $false, $false, $true, 1, $false, $para, 2)
}
# Troca o texto de um parágrafo inteiro (sem a marca de parágrafo), mantendo o estilo
function Texto-Do-Paragrafo($p, [string]$texto) {
  if ($p.Range.Fields.Count -gt 0) { $p.Range.Fields.Unlink() }
  $r = $p.Range
  $null = $r.MoveEnd(1, -1)
  $r.Text = $texto
}

try {
  $estTexto    = Estilo 'Texto'
  $estTitulo1  = Estilo @('Título 1', 'heading 1')
  $estPos      = Estilo 'Título pós-textual'
  $estApendice = Estilo 'Apêndice'
  $estHU       = Estilo 'Título HU'
  $estRef      = Estilo 'Referência'
  $estLegenda  = Estilo @('Legenda', 'caption')
  $estFonte    = Estilo 'Fonte'
  $estLegTab   = Estilo 'Legenda-Tabela'
  $estFonteTab = Estilo 'Fonte-Tabela'
  $estTextoTab = Estilo 'Texto-Tabela'
  $estNormal   = $doc.Styles.Item(-1).NameLocal
  # legendas e fontes centralizadas, como no artigo; as tabelas têm estilos próprios no template (à esquerda)
  foreach ($n in $estLegenda, $estFonte) { $s = $doc.Styles.Item($n); $s.ParagraphFormat.Alignment = 1; $s.ParagraphFormat.FirstLineIndent = 0; $s.ParagraphFormat.LeftIndent = 0 }
  $doc.Styles.Item($estLegenda).ParagraphFormat.KeepWithNext = -1
  $doc.Styles.Item($estLegTab).ParagraphFormat.KeepWithNext = -1
  $doc.Styles.Item($estLegTab).ParagraphFormat.SpaceBefore = 12
  $doc.Styles.Item($estFonteTab).ParagraphFormat.SpaceAfter = 12
  $doc.Styles.Item($estFonte).ParagraphFormat.SpaceAfter = 12
  $doc.Styles.Item($estTextoTab).ParagraphFormat.Alignment = 0
  $estFigura = Novo-Estilo 'Figura' $estNormal { param($s) $s.ParagraphFormat.Alignment = 1; $s.ParagraphFormat.FirstLineIndent = 0; $s.ParagraphFormat.LeftIndent = 0; $s.ParagraphFormat.LineSpacingRule = 0; $s.ParagraphFormat.KeepWithNext = -1 }
  $estSub = Novo-Estilo 'Subtítulo de apêndice' $estTexto { param($s) $s.Font.Bold = -1; $s.ParagraphFormat.Alignment = 0; $s.ParagraphFormat.FirstLineIndent = 0; $s.ParagraphFormat.LeftIndent = 0; $s.ParagraphFormat.SpaceBefore = 18; $s.ParagraphFormat.SpaceAfter = 6; $s.ParagraphFormat.KeepWithNext = -1 }
  $estItem = Novo-Estilo 'Alínea de texto' $estTexto { param($s) $s.ParagraphFormat.LeftIndent = 1.25 * $cm; $s.ParagraphFormat.FirstLineIndent = -0.75 * $cm }

  # ------------------------------------------------------------------ capa, folha de rosto, resumo e abstract
  Write-Host 'Estilos prontos; preenchendo a capa, a folha de rosto e o resumo...'
  Substituir '<NOME DO SISTEMA>' $Sistema
  Substituir 'SISTEMA <>' "SISTEMA $Sistema"
  Substituir '202_' $meta['Ano']
  Substituir 'AUTORES (nome dos alunos/as)' (($autores | ForEach-Object { $_.ToUpper() }) -join '^l')
  Substituir 'Orientador(a): Prof(a). Dr(a). ____________' ("Orientador: " + $meta['Orientador'])
  $resumosVistos = 0
  foreach ($p in $doc.Paragraphs) {
    $t = $p.Range.Text
    if ($t -match 'NOME DO.*ALUNO') { Texto-Do-Paragrafo $p (($autores | ForEach-Object { $_.ToUpper() }) -join "`v"); continue }
    if ($t -like 'Utilize o estilo Resumo*') {
      $resumosVistos++
      if ($resumosVistos -eq 1) { Texto-Do-Paragrafo $p $meta['Resumo'] } else { Texto-Do-Paragrafo $p $meta['Abstract']; $p.Range.LanguageID = 1033 }
      continue
    }
    if ($t -like 'Palavras-chave: Palavra-chave 1*') { Texto-Do-Paragrafo $p ('Palavras-chave: ' + $meta['Palavras-chave']); continue }
    if ($t -like 'Keywords: Keyword 1*') { Texto-Do-Paragrafo $p ('Keywords: ' + $meta['Keywords']); $p.Range.LanguageID = 1033; continue }
  }

  # ------------------------------------------------------------------ apaga o conteúdo de exemplo depois do título da contextualização
  $cab = $null
  foreach ($p in $doc.Paragraphs) { if ($p.Range.Text -like 'CONTEXTUALIZA*' -and $p.Style.NameLocal -eq $estTitulo1) { $cab = $p; break } }
  if ($null -eq $cab) { throw 'Título CONTEXTUALIZAÇÃO não encontrado no template.' }
  Write-Host 'Capa preenchida; apagando o conteúdo de exemplo e escrevendo o corpo...'
  $null = $doc.Range($cab.Range.End, $doc.Content.End).Delete()
  $null = $sel.EndKey(6)
  $sel.Style = $estTexto
  $sel.ParagraphFormat.Reset()
  $sel.Font.Reset()

  # ------------------------------------------------------------------ corpo: contextualização, referências e apêndices
  $k = 0; $nasReferencias = $false; $letra = 0; $numero = 0
  while ($k -lt $linhas.Count) {
    $l = $linhas[$k]
    if ($l -match '^\s*$' -or $l -eq '---') { $k++; continue }
    if ($l -notmatch '^(- |\d+\. )') { $letra = 0; $numero = 0 }
    if ($l -match '^## APÊNDICE [A-Z] – (.+)$') { Write-Host ("  " + $l.Substring(3)); Quebra-De-Pagina; $nasReferencias = $false; Paragrafo $estApendice $Matches[1]; $k++; continue }
    if ($l -eq '## REFERÊNCIAS') { Quebra-De-Pagina; $nasReferencias = $true; Paragrafo $estPos 'REFERÊNCIAS'; $k++; continue }
    if ($l -like '#### *') {
      # história de usuário: estilo do template, sem a numeração automática "HU n.", porque o número está no título
      $sel.Style = $estHU
      $sel.Range.ListFormat.RemoveNumbers()
      $sel.ParagraphFormat.LeftIndent = 0; $sel.ParagraphFormat.FirstLineIndent = 0
      Inline $l.Substring(5)
      $sel.Font.Reset(); $sel.TypeParagraph(); $k++; continue
    }
    if ($l -like '### *') { Paragrafo $estSub $l.Substring(4); $k++; continue }
    if ($l -match '^\*\*(FIGURA|TABELA) (\d+)\*\* - (.+)$') {
      $legenda = "{0} {1} - {2}" -f $Matches[1], $Matches[2], $Matches[3]
      $j = $k + 1; while ($j -lt $linhas.Count -and $linhas[$j] -match '^\s*$') { $j++ }
      if ($linhas[$j].StartsWith('![')) {
        $null = $linhas[$j] -match '^!\[[^\]]*\]\(([^)]+)\)'
        $caminho = Join-Path $pasta $Matches[1]
        $j++; while ($j -lt $linhas.Count -and $linhas[$j] -match '^\s*$') { $j++ }
        Figura $legenda $caminho $linhas[$j]
        $k = $j + 1; continue
      }
      $tab = @(); while ($j -lt $linhas.Count -and $linhas[$j] -like '|*') { $tab += $linhas[$j]; $j++ }
      while ($j -lt $linhas.Count -and $linhas[$j] -match '^\s*$') { $j++ }
      Paragrafo $estLegTab $legenda
      Tabela (Linhas-Da-Tabela $tab)
      Paragrafo $estFonteTab $linhas[$j]
      $k = $j + 1; continue
    }
    if ($l -like '- *') { $letra++; Paragrafo $estItem ([string][char](96 + $letra) + ') ' + $l.Substring(2)); $k++; continue }
    if ($l -match '^\d+\. (.+)$') { $numero++; Paragrafo $estItem ("$numero) " + $Matches[1]); $k++; continue }
    if ($nasReferencias) { Paragrafo $estRef $l; $k++; continue }
    Paragrafo $estTexto $l; $k++
  }

  # ------------------------------------------------------------------ sumário, idioma e gravação
  Write-Host 'Corpo escrito; atualizando o sumário e gravando...'
  $word.Options.Pagination = $true
  $doc.Repaginate()
  foreach ($toc in $doc.TablesOfContents) { $toc.Update() }
  $doc.Content.LanguageID = 1046
  foreach ($p in $doc.Paragraphs) {
    $txt = $p.Range.Text
    if ($txt.StartsWith('Keywords:') -or $txt.StartsWith('ABSTRACT')) { $p.Range.LanguageID = 1033 }
  }
  $doc.SaveAs2([string](Join-Path (Resolve-Path (Split-Path -Parent $Saida)) (Split-Path -Leaf $Saida)), 16)
  if ($Pdf) { $doc.ExportAsFixedFormat([string](Join-Path (Resolve-Path (Split-Path -Parent $Pdf)) (Split-Path -Leaf $Pdf)), 17) }
  Write-Host ("Gerado: {0} ({1} páginas, {2} tabelas, {3} figuras, {4} seções)" -f $Saida, $doc.ComputeStatistics(2), $doc.Tables.Count, $doc.InlineShapes.Count, $doc.Sections.Count)
}
catch {
  Write-Host ("ERRO: " + $_.Exception.Message)
  Write-Host $_.InvocationInfo.PositionMessage
  if ($k -ne $null -and $linhas -ne $null -and $k -lt $linhas.Count) { Write-Host ("na linha {0} do .md: {1}" -f ($k + 1), $linhas[$k]) }
  $falhou = $true
}
finally {
  # o Word pode recusar a chamada por alguns instantes depois de um erro; tenta fechar algumas vezes
  for ($tent = 0; $tent -lt 10; $tent++) { try { $doc.Close(0); break } catch { Start-Sleep -Milliseconds 500 } }
  if (-not $jaAberto) { try { $word.Quit() } catch {} }
  $null = [System.Runtime.InteropServices.Marshal]::ReleaseComObject($word)
  if ($falhou) { exit 1 }
}
