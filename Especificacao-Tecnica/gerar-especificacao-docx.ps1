# Preenche o template da Especificação Técnica do curso (Referencias-e-modelos/Template Especificação Técnica
# TCC TADS UFPR.docx) com o conteúdo de Especificacao-Tecnica-NeuroSight.md, gerado por montar-especificacao.pl,
# e grava o .docx e o PDF.
#
# Como funciona: o template é um .docx (um .zip com XML). O script descompacta o template, troca os textos da
# capa, da folha de rosto, do resumo e do abstract, apaga o conteúdo de exemplo depois do título CONTEXTUALIZAÇÃO
# e escreve ali o corpo inteiro (contextualização, referências e apêndices) em OOXML, com os estilos do próprio
# template (Texto, Título 1, Título pós-textual, Apêndice, Título HU, Referência, Resumo, Legenda, Fonte,
# Legenda-Tabela, Fonte-Tabela, Texto-Tabela). As figuras entram como imagens embutidas; os diagramas largos vão
# em páginas paisagem, numa seção própria. Depois compacta tudo de novo e abre o Word só para atualizar o sumário,
# gravar o .docx e exportar o PDF: leva poucos minutos.
#
# Uso, na pasta do TCC (depois de montar a especificação):
#   powershell -ExecutionPolicy Bypass -File .\Especificacao-Tecnica\gerar-especificacao-docx.ps1
param(
  [string]$Entrada    = (Join-Path $PSScriptRoot 'Especificacao-Tecnica-NeuroSight.md'),
  # o nome do template tem acentos; ele é localizado por curinga, porque a normalização Unicode do nome no disco pode variar
  [string]$Template   = (Get-ChildItem (Join-Path $PSScriptRoot '..\Referencias-e-modelos') -Filter 'Template*.docx' | Select-Object -First 1 -ExpandProperty FullName),
  [string]$Saida      = (Join-Path $PSScriptRoot 'Especificacao-Tecnica-NeuroSight.docx'),
  [string]$Pdf        = (Join-Path $PSScriptRoot 'Especificacao-Tecnica-NeuroSight.pdf'),
  [string]$Sistema    = 'NEUROSIGHT',
  [switch]$SemWord    # só monta o .docx, sem atualizar o sumário nem gerar o PDF
)
$ErrorActionPreference = 'Stop'
Add-Type -AssemblyName System.Drawing
Add-Type -AssemblyName System.IO.Compression
Add-Type -AssemblyName System.IO.Compression.FileSystem
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

# ------------------------------------------------------------------ descompacta o template
$tmp = Join-Path ([System.IO.Path]::GetTempPath()) ('especificacao-docx-' + [guid]::NewGuid().ToString('N'))
New-Item -ItemType Directory -Path $tmp | Out-Null
[System.IO.Compression.ZipFile]::ExtractToDirectory((Resolve-Path $Template).Path, $tmp)
$utf8 = New-Object System.Text.UTF8Encoding($false)
$docXml  = [System.IO.File]::ReadAllText((Join-Path $tmp 'word\document.xml'), $utf8)
$stylesXml = [System.IO.File]::ReadAllText((Join-Path $tmp 'word\styles.xml'), $utf8)
$relsXml = [System.IO.File]::ReadAllText((Join-Path $tmp 'word\_rels\document.xml.rels'), $utf8)
$typesXml = [System.IO.File]::ReadAllText((Join-Path $tmp '[Content_Types].xml'), $utf8)

# ------------------------------------------------------------------ utilitários de XML
function Esc([string]$t) { $t.Replace('&', '&amp;').Replace('<', '&lt;').Replace('>', '&gt;').Replace('"', '&quot;') }
$padrao = '\*\*(.+?)\*\*|\*(.+?)\*|`([^`]+)`|\\([<>])'
function Run([string]$t, [string]$rpr) {
  if ($t.Length -eq 0) { return '' }
  $r = '<w:r>'
  if ($rpr) { $r += "<w:rPr>$rpr</w:rPr>" }
  $r + '<w:t xml:space="preserve">' + (Esc $t) + '</w:t></w:r>'
}
# Converte a marcação inline do .md (**negrito**, *itálico*, `código`, \< \>) em runs
function Runs([string]$texto, [string]$rprBase = '') {
  $sb = New-Object System.Text.StringBuilder
  $pos = 0
  foreach ($m in [regex]::Matches($texto, $padrao)) {
    if ($m.Index -gt $pos) { $null = $sb.Append((Run $texto.Substring($pos, $m.Index - $pos) $rprBase)) }
    # a ordem dos filhos de <w:rPr> importa para o Word: rFonts, b, i, sz, lang
    if     ($m.Groups[1].Success) { $null = $sb.Append((Run $m.Groups[1].Value ($(if ($rprBase -like '*<w:b/>*') { $rprBase } else { '<w:b/><w:bCs/>' + $rprBase })))) }
    elseif ($m.Groups[2].Success) { $null = $sb.Append((Run $m.Groups[2].Value ('<w:i/><w:iCs/>' + $rprBase))) }
    elseif ($m.Groups[3].Success) { $null = $sb.Append((Run $m.Groups[3].Value ('<w:rFonts w:ascii="Consolas" w:hAnsi="Consolas" w:cs="Consolas"/>' + ($rprBase -replace '<w:lang [^>]*/>', '') + '<w:sz w:val="20"/><w:szCs w:val="20"/>' + [regex]::Match($rprBase, '<w:lang [^>]*/>').Value))) }
    else { $null = $sb.Append((Run $m.Groups[4].Value $rprBase)) }
    $pos = $m.Index + $m.Length
  }
  if ($pos -lt $texto.Length) { $null = $sb.Append((Run $texto.Substring($pos) $rprBase)) }
  $sb.ToString()
}
function P([string]$estilo, [string]$texto, [string]$pprExtra = '', [string]$rprBase = '') {
  "<w:p><w:pPr><w:pStyle w:val=`"$estilo`"/>$pprExtra</w:pPr>" + (Runs $texto $rprBase) + '</w:p>'
}
# Texto de um parágrafo do XML (só o que está em <w:t>)
function Texto-De([string]$pXml) { (([regex]::Matches($pXml, '<w:t(?: [^>]*)?>([^<]*)</w:t>') | ForEach-Object { $_.Groups[1].Value }) -join '').Replace('&lt;', '<').Replace('&gt;', '>').Replace('&quot;', '"').Replace('&amp;', '&') }
# Parágrafos do documento: <w:p ...>...</w:p>, sem confundir com <w:pPr> nem com <w:p .../> vazio
$regexP = [regex]'(?s)<w:p(?: [^>]*?)?(?<!/)>(.*?)</w:p>'
# Troca o conteúdo (os runs) do primeiro parágrafo cujo texto casa com o padrão, mantendo o <w:pPr>
function Substituir-Paragrafo([string]$padraoTexto, [string]$novosRuns, [string]$pprNovo = $null) {
  $avaliador = [System.Text.RegularExpressions.MatchEvaluator]{
    param($m)
    if ($script:trocado -or ((Texto-De $m.Value) -notmatch $padraoTexto)) { return $m.Value }
    $script:trocado = $true
    $abre = [regex]::Match($m.Value, '^<w:p(?: [^>]*?)?>').Value
    $ppr = [regex]::Match($m.Value, '(?s)<w:pPr>.*?</w:pPr>').Value
    if ($null -ne $pprNovo) { $ppr = $pprNovo }
    $abre + $ppr + $novosRuns + '</w:p>'
  }
  $script:docXml = $regexP.Replace($script:docXml, $avaliador)
  if (-not $script:trocado) { throw "não achei no template o parágrafo '$padraoTexto'" }
  $script:trocado = $false
}
$script:trocado = $false

# ------------------------------------------------------------------ capa, folha de rosto, resumo e abstract
Write-Host 'Preenchendo a capa, a folha de rosto, o resumo e o abstract...'
$nomes = ($autores | ForEach-Object { Run $_.ToUpper() '<w:caps/>' }) -join '<w:r><w:br/></w:r>'
Substituir-Paragrafo '^NOME DOs\(As\) ALUNOs\(As\)$' $nomes
# a capa do template tem espaço para um nome: cada nome a mais consome um parágrafo vazio logo abaixo, para o ano não cair na página seguinte
$regexVazio = New-Object regex ('(?s)(' + [regex]::Escape($nomes) + '</w:p>)\s*(?:<w:p(?: [^>]*)?/>|<w:p(?: [^>]*?)?>(?:(?!<w:t[ >]).)*?</w:p>)')
for ($k = 1; $k -lt $autores.Count; $k++) { $script:docXml = $regexVazio.Replace($script:docXml, '$1', 1) }
Substituir-Paragrafo '^ESPECIFICAÇÃO TÉCNICA DO SISTEMA <NOME DO SISTEMA>$' (Run "ESPECIFICAÇÃO TÉCNICA DO SISTEMA $Sistema" '')
Substituir-Paragrafo '^202_AUTORES \(nome dos alunos/as\)$' ((Run $meta['Ano'] '') + '<w:r><w:br w:type="page"/></w:r>' + $nomes)
Substituir-Paragrafo '^ESPECIFICAÇÃO TÉCNICA DO SISTEMA <>$' (Run "ESPECIFICAÇÃO TÉCNICA DO SISTEMA $Sistema" '')
Substituir-Paragrafo '^Orientador\(a\): Prof\(a\)\. Dr\(a\)\. _+$' (Run ('Orientador: ' + $meta['Orientador']) '') '<w:pPr><w:pStyle w:val="Naturezadotrabalho"/></w:pPr>'
Substituir-Paragrafo '^202_$' (Run $meta['Ano'] '') '<w:pPr><w:pStyle w:val="Capa-Folhaderosto"/></w:pPr>'
# o parágrafo-modelo do resumo no template está no estilo Normal (centralizado); o template manda usar o estilo "Resumo"
$pprResumo = '<w:pPr><w:pStyle w:val="Resumo"/></w:pPr>'
Substituir-Paragrafo '^Utilize o estilo Resumo\.' (Runs $meta['Resumo']) $pprResumo
Substituir-Paragrafo '^Utilize o estilo Resumo\.' (Runs $meta['Abstract'] '<w:lang w:val="en-US"/>') $pprResumo
Substituir-Paragrafo '^Palavras-chave: Palavra-chave 1' ((Run 'Palavras-chave' '<w:b/><w:bCs/>') + (Run (': ' + $meta['Palavras-chave']) '')) $pprResumo
Substituir-Paragrafo '^Keywords: Keyword 1' ((Run 'Keywords' '<w:b/><w:bCs/><w:lang w:val="en-US"/>') + (Run (': ' + $meta['Keywords']) '<w:lang w:val="en-US"/>')) $pprResumo

# ------------------------------------------------------------------ estilos: ajustes e estilos novos
# legendas e fontes das figuras centralizadas e sem recuo, legenda presa à figura; tabelas com os estilos do template
$stylesXml = $stylesXml -replace '(?s)(<w:style w:type="paragraph" w:styleId="Legenda">.*?)<w:pPr>.*?</w:pPr>', '$1<w:pPr><w:keepNext/><w:spacing w:before="240" w:after="120" w:line="240" w:lineRule="auto"/><w:ind w:firstLine="0"/><w:jc w:val="center"/></w:pPr>'
$stylesXml = $stylesXml -replace '(?s)(<w:style w:type="paragraph" w:customStyle="1" w:styleId="Fonte">.*?)(<w:rPr>)', '$1<w:pPr><w:spacing w:before="120" w:after="240" w:line="240" w:lineRule="auto"/><w:ind w:firstLine="0"/><w:jc w:val="center"/></w:pPr>$2'
$stylesXml = $stylesXml -replace '(?s)(<w:style w:type="paragraph" w:customStyle="1" w:styleId="Legenda-Tabela">.*?)<w:pPr>.*?</w:pPr>', '$1<w:pPr><w:keepNext/><w:spacing w:before="240" w:after="120" w:line="240" w:lineRule="auto"/><w:ind w:firstLine="0"/><w:jc w:val="left"/></w:pPr>'
$stylesXml = $stylesXml -replace '(?s)(<w:style w:type="paragraph" w:customStyle="1" w:styleId="Fonte-Tabela">.*?)<w:pPr>.*?</w:pPr>', '$1<w:pPr><w:spacing w:before="120" w:after="240" w:line="240" w:lineRule="auto"/><w:ind w:firstLine="0"/><w:jc w:val="left"/></w:pPr>'
$stylesXml = $stylesXml -replace '(?s)(<w:style w:type="paragraph" w:customStyle="1" w:styleId="Texto-Tabela">.*?)<w:pPr>.*?</w:pPr>', '$1<w:pPr><w:spacing w:after="0" w:line="240" w:lineRule="auto"/><w:ind w:firstLine="0"/><w:jc w:val="left"/></w:pPr>'
$novosEstilos = @'
<w:style w:type="paragraph" w:customStyle="1" w:styleId="Figura"><w:name w:val="Figura"/><w:basedOn w:val="Normal"/><w:next w:val="Fonte"/><w:qFormat/><w:pPr><w:keepNext/><w:spacing w:after="0" w:line="240" w:lineRule="auto"/><w:ind w:firstLine="0"/><w:jc w:val="center"/></w:pPr></w:style>
<w:style w:type="paragraph" w:customStyle="1" w:styleId="SubtitulodeApendice"><w:name w:val="Subtítulo de apêndice"/><w:basedOn w:val="Texto"/><w:next w:val="Texto"/><w:qFormat/><w:pPr><w:keepNext/><w:spacing w:before="360" w:after="120"/><w:ind w:firstLine="0"/><w:jc w:val="left"/></w:pPr><w:rPr><w:b/><w:bCs/></w:rPr></w:style>
<w:style w:type="paragraph" w:customStyle="1" w:styleId="AlineadeTexto"><w:name w:val="Alínea de texto"/><w:basedOn w:val="Texto"/><w:qFormat/><w:pPr><w:ind w:left="709" w:hanging="425"/></w:pPr></w:style>
'@ -replace "`r?`n", ''
$stylesXml = $stylesXml -replace '</w:styles>\s*$', ($novosEstilos + '</w:styles>')

# ------------------------------------------------------------------ figuras: imagens embutidas e seções em paisagem
$cm = 360000   # EMU por centímetro
$largTexto = 16.0;  $altMaxRetrato  = 20.5      # A4 retrato, margens 3 cm (sup./esq.) e 2 cm (inf./dir.), menos legenda e fonte
$largPais  = 24.7;  $altMaxPaisagem = 13.3      # A4 paisagem, mesmas margens
if (-not (Test-Path (Join-Path $tmp 'word\media'))) { New-Item -ItemType Directory -Path (Join-Path $tmp 'word\media') | Out-Null }
if ($typesXml -notmatch 'Extension="png"') { $typesXml = $typesXml -replace '<Default Extension="rels"', '<Default Extension="png" ContentType="image/png"/><Default Extension="rels"' }
$nImg = 0
$proxDocPr = 1000
function Imagem-Xml([string]$caminho, [double]$maxL, [double]$maxA) {
  $img = [System.Drawing.Image]::FromFile($caminho)
  $w = $img.Width; $h = $img.Height
  $img.Dispose()
  $largura = $maxL; $altura = $largura * $h / $w
  if ($altura -gt $maxA) { $altura = $maxA; $largura = $altura * $w / $h }
  $cx = [long]($largura * $cm); $cy = [long]($altura * $cm)
  $script:nImg++
  $nome = 'imagem' + $script:nImg + '.png'
  Copy-Item $caminho (Join-Path $tmp ('word\media\' + $nome))
  $rid = 'rIdImg' + $script:nImg
  $script:relsXml = $script:relsXml -replace '</Relationships>', ('<Relationship Id="' + $rid + '" Type="http://schemas.openxmlformats.org/officeDocument/2006/relationships/image" Target="media/' + $nome + '"/></Relationships>')
  $id = $script:proxDocPr++
  '<w:r><w:drawing><wp:inline distT="0" distB="0" distL="0" distR="0"><wp:extent cx="' + $cx + '" cy="' + $cy + '"/><wp:effectExtent l="0" t="0" r="0" b="0"/><wp:docPr id="' + $id + '" name="' + $nome + '"/><wp:cNvGraphicFramePr><a:graphicFrameLocks xmlns:a="http://schemas.openxmlformats.org/drawingml/2006/main" noChangeAspect="1"/></wp:cNvGraphicFramePr><a:graphic xmlns:a="http://schemas.openxmlformats.org/drawingml/2006/main"><a:graphicData uri="http://schemas.openxmlformats.org/drawingml/2006/picture"><pic:pic xmlns:pic="http://schemas.openxmlformats.org/drawingml/2006/picture"><pic:nvPicPr><pic:cNvPr id="0" name="' + $nome + '"/><pic:cNvPicPr/></pic:nvPicPr><pic:blipFill><a:blip r:embed="' + $rid + '"/><a:stretch><a:fillRect/></a:stretch></pic:blipFill><pic:spPr><a:xfrm><a:off x="0" y="0"/><a:ext cx="' + $cx + '" cy="' + $cy + '"/></a:xfrm><a:prstGeom prst="rect"><a:avLst/></a:prstGeom></pic:spPr></pic:pic></a:graphicData></a:graphic></wp:inline></w:drawing></w:r>'
}
function Paisagem([string]$caminho) {
  $img = [System.Drawing.Image]::FromFile($caminho)
  $r = ($img.Width -ge 2600 -and ($img.Width / $img.Height) -ge 1.4)
  $img.Dispose()
  $r
}
# a última seção do template (cabeçalho com número de página, A4, margens) serve de base para as seções do corpo
$sectFinal = [regex]::Match($docXml, '(?s)<w:sectPr(?: [^>]*)?>(?:(?!<w:sectPr).)*?</w:sectPr>\s*</w:body>').Value -replace '\s*</w:body>$', ''
$sectFinal = $sectFinal -replace '<w:sectPr [^>]*>', '<w:sectPr>'
$sectRetrato  = $sectFinal
$sectPaisagem = $sectFinal -replace '<w:pgSz [^>]*/>', '<w:pgSz w:w="16838" w:h="11906" w:orient="landscape" w:code="9"/>'
function Fim-De-Secao([string]$sect) { '<w:p><w:pPr><w:spacing w:after="0" w:line="240" w:lineRule="auto"/><w:rPr><w:sz w:val="2"/></w:rPr>' + $sect + '</w:pPr></w:p>' }

# ------------------------------------------------------------------ tabelas
function Linhas-Da-Tabela([string[]]$tab) {
  $r = @()
  foreach ($l in $tab) {
    if ($l -match '^\|\s*-') { continue }
    $r += ,(@($l.Trim().Trim('|').Split('|') | ForEach-Object { $_.Trim() }))
  }
  ,$r
}
function Tabela($lin) {
  $nc = $lin[0].Count
  # cada coluna recebe no mínimo a largura da sua maior palavra (até 24 caracteres, a ~120 twips cada, mais as margens
  # da célula), para não quebrar palavras no meio; o que sobra é repartido na proporção do texto mais longo de cada
  # coluna (com piso e teto); as larguras somam 16 cm
  $pesos = @(0) * $nc; $palavras = @(0) * $nc
  foreach ($r in $lin) {
    for ($j = 0; $j -lt $nc; $j++) {
      $t = ($r[$j] -replace $padrao, '$1$2$3$4')
      $n = [Math]::Min($t.Length, 50); if ($n -gt $pesos[$j]) { $pesos[$j] = $n }
      foreach ($w in ($t -split '\s+')) { $n = [Math]::Min($w.Length, 24); if ($n -gt $palavras[$j]) { $palavras[$j] = $n } }
    }
  }
  for ($j = 0; $j -lt $nc; $j++) { $pesos[$j] = [Math]::Max($pesos[$j], 5) + 3 }
  $total = 9072
  $minimos = @($palavras | ForEach-Object { [int]($_ * 120 + 140) })
  $somaMin = ($minimos | Measure-Object -Sum).Sum
  if ($somaMin -ge $total) { $larg = @($minimos | ForEach-Object { [int]($total * $_ / $somaMin) }) }
  else {
    $soma = ($pesos | Measure-Object -Sum).Sum
    $resto = $total - $somaMin
    $larg = @(0..($nc - 1) | ForEach-Object { $minimos[$_] + [int]($resto * $pesos[$_] / $soma) })
  }
  $borda = '<w:top w:val="single" w:sz="4" w:space="0" w:color="auto"/><w:left w:val="single" w:sz="4" w:space="0" w:color="auto"/><w:bottom w:val="single" w:sz="4" w:space="0" w:color="auto"/><w:right w:val="single" w:sz="4" w:space="0" w:color="auto"/><w:insideH w:val="single" w:sz="4" w:space="0" w:color="auto"/><w:insideV w:val="single" w:sz="4" w:space="0" w:color="auto"/>'
  $sb = New-Object System.Text.StringBuilder
  $null = $sb.Append('<w:tbl><w:tblPr><w:tblW w:w="' + $total + '" w:type="dxa"/><w:tblInd w:w="0" w:type="dxa"/><w:tblBorders>' + $borda + '</w:tblBorders><w:tblLayout w:type="fixed"/><w:tblCellMar><w:left w:w="57" w:type="dxa"/><w:right w:w="57" w:type="dxa"/></w:tblCellMar><w:tblLook w:val="04A0" w:firstRow="1" w:lastRow="0" w:firstColumn="0" w:lastColumn="0" w:noHBand="0" w:noVBand="1"/></w:tblPr><w:tblGrid>')
  foreach ($w in $larg) { $null = $sb.Append('<w:gridCol w:w="' + $w + '"/>') }
  $null = $sb.Append('</w:tblGrid>')
  for ($i = 0; $i -lt $lin.Count; $i++) {
    $null = $sb.Append('<w:tr><w:trPr><w:cantSplit/>' + $(if ($i -eq 0) { '<w:tblHeader/>' } else { '' }) + '</w:trPr>')
    for ($j = 0; $j -lt $nc; $j++) {
      $celula = if ($j -lt $lin[$i].Count) { $lin[$i][$j] } else { '' }
      $rpr = if ($i -eq 0) { '<w:b/><w:bCs/>' } else { '' }
      $null = $sb.Append('<w:tc><w:tcPr><w:tcW w:w="' + $larg[$j] + '" w:type="dxa"/></w:tcPr><w:p><w:pPr><w:pStyle w:val="Texto-Tabela"/></w:pPr>' + (Runs $celula $rpr) + '</w:p></w:tc>')
    }
    $null = $sb.Append('</w:tr>')
  }
  $null = $sb.Append('</w:tbl>')
  $sb.ToString()
}

# ------------------------------------------------------------------ corpo: contextualização, referências e apêndices
Write-Host 'Montando o corpo (contextualização, referências e apêndices)...'
$corpo = New-Object System.Text.StringBuilder
$emPaisagem = $false
$quebraPendente = $false     # a próxima coisa escrita começa em página nova
function Escrever([string]$xml) { $null = $script:corpo.Append($xml) }
# Antes de escrever algo em retrato, fecha a seção paisagem se ela estiver aberta; a troca de seção já muda de página
function Retrato() {
  if ($script:emPaisagem) { Escrever (Fim-De-Secao $script:sectPaisagem); $script:emPaisagem = $false; $script:quebraPendente = $false }
}
function Ppr-Quebra() {
  if ($script:quebraPendente) { $script:quebraPendente = $false; return '<w:pageBreakBefore/>' }
  ''
}
$k = 0; $nasReferencias = $false; $naContextualizacao = $true; $letra = 0; $numero = 0
$nTab = 0; $nFig = 0
while ($k -lt $linhas.Count) {
  $l = $linhas[$k]
  if ($l -match '^\s*$' -or $l -eq '---') { $k++; continue }
  if ($l -notmatch '^(- |\d+\. )') { $letra = 0; $numero = 0 }
  if ($l -match '^## APÊNDICE [A-Z] – (.+)$') {
    Write-Host ('  ' + $l.Substring(3)); $nasReferencias = $false
    # se a seção paisagem estava aberta, fechá-la já muda de página; a quebra explícita deixaria uma página em branco
    $ppr = if ($emPaisagem) { '' } else { '<w:pageBreakBefore/>' }
    Retrato; Escrever (P 'Apndice' $Matches[1] $ppr); $k++; continue
  }
  if ($l -eq '## REFERÊNCIAS') {
    $ppr = if ($emPaisagem) { '' } else { '<w:pageBreakBefore/>' }
    Retrato; $nasReferencias = $true; $naContextualizacao = $false; Escrever (P 'Ttulops-textual' 'REFERÊNCIAS' $ppr); $k++; continue
  }
  if ($l -like '#### *') {
    # história de usuário: estilo do template, sem a numeração automática "HU n.", porque o número já está no título
    Retrato; Escrever (P 'TtuloHU' $l.Substring(5) ((Ppr-Quebra) + '<w:numPr><w:ilvl w:val="0"/><w:numId w:val="0"/></w:numPr><w:ind w:left="0" w:firstLine="0"/>')); $k++; continue
  }
  if ($l -like '### *') { Retrato; Escrever (P 'SubtitulodeApendice' $l.Substring(4) (Ppr-Quebra)); $k++; continue }
  if ($l -match '^\*\*(FIGURA|TABELA) (\d+)\*\* - (.+)$') {
    $legenda = '{0} {1} - {2}' -f $Matches[1], $Matches[2], $Matches[3]
    $j = $k + 1; while ($j -lt $linhas.Count -and $linhas[$j] -match '^\s*$') { $j++ }
    if ($linhas[$j].StartsWith('![')) {
      $null = $linhas[$j] -match '^!\[[^\]]*\]\(([^)]+)\)'
      $caminho = Join-Path $pasta $Matches[1]
      if (-not (Test-Path $caminho)) { throw "figura não encontrada: $caminho" }
      $j++; while ($j -lt $linhas.Count -and $linhas[$j] -match '^\s*$') { $j++ }
      $fonte = $linhas[$j]
      # diagramas largos vão em página paisagem; na contextualização a figura fica no fluxo do texto, em retrato
      if ((Paisagem $caminho) -and -not $naContextualizacao) {
        if (-not $emPaisagem) { Escrever (Fim-De-Secao $sectRetrato); $emPaisagem = $true; $quebraPendente = $false }
        else { $quebraPendente = $true }     # segunda figura paisagem seguida: página nova na mesma seção
        Escrever (P 'Legenda' $legenda (Ppr-Quebra))
        Escrever ('<w:p><w:pPr><w:pStyle w:val="Figura"/></w:pPr>' + (Imagem-Xml $caminho $largPais $altMaxPaisagem) + '</w:p>')
      } else {
        Retrato
        Escrever (P 'Legenda' $legenda (Ppr-Quebra))
        Escrever ('<w:p><w:pPr><w:pStyle w:val="Figura"/></w:pPr>' + (Imagem-Xml $caminho $largTexto $altMaxRetrato) + '</w:p>')
      }
      Escrever (P 'Fonte' $fonte)
      $nFig++; $k = $j + 1; continue
    }
    $tab = @(); while ($j -lt $linhas.Count -and $linhas[$j] -like '|*') { $tab += $linhas[$j]; $j++ }
    while ($j -lt $linhas.Count -and $linhas[$j] -match '^\s*$') { $j++ }
    Retrato
    Escrever (P 'Legenda-Tabela' $legenda (Ppr-Quebra))
    Escrever (Tabela (Linhas-Da-Tabela $tab))
    Escrever (P 'Fonte-Tabela' $linhas[$j])
    $nTab++; $k = $j + 1; continue
  }
  Retrato
  if ($l -like '- *') { $letra++; Escrever (P 'AlineadeTexto' ([string][char](96 + $letra) + ') ' + $l.Substring(2)) (Ppr-Quebra)); $k++; continue }
  if ($l -match '^\d+\. (.+)$') { $numero++; Escrever (P 'AlineadeTexto' ("$numero) " + $Matches[1]) (Ppr-Quebra)); $k++; continue }
  if ($nasReferencias) { Escrever (P 'Referncia' $l ((Ppr-Quebra) + '<w:spacing w:after="240"/>')); $k++; continue }
  Escrever (P 'Texto' $l (Ppr-Quebra)); $k++
}
Retrato

# ------------------------------------------------------------------ apaga o conteúdo de exemplo depois do título da contextualização e insere o corpo
$titulo = $null
foreach ($m in $regexP.Matches($docXml)) {
  if ($m.Value -match 'w:val="Ttulo1"' -and (Texto-De $m.Value) -eq 'CONTEXTUALIZAÇÃO') { $titulo = $m; break }
}
if ($null -eq $titulo) { throw 'Título CONTEXTUALIZAÇÃO não encontrado no template.' }
$inicioCorpo = $titulo.Index + $titulo.Length
$fimCorpo = [regex]::Match($docXml, '(?s)<w:sectPr(?: [^>]*)?>(?:(?!<w:sectPr).)*?</w:sectPr>\s*</w:body>').Index
$docXml = $docXml.Substring(0, $inicioCorpo) + $corpo.ToString() + $docXml.Substring($fimCorpo)

# ------------------------------------------------------------------ grava os XML e compacta o .docx
[System.IO.File]::WriteAllText((Join-Path $tmp 'word\document.xml'), $docXml, $utf8)
[System.IO.File]::WriteAllText((Join-Path $tmp 'word\styles.xml'), $stylesXml, $utf8)
[System.IO.File]::WriteAllText((Join-Path $tmp 'word\_rels\document.xml.rels'), $relsXml, $utf8)
[System.IO.File]::WriteAllText((Join-Path $tmp '[Content_Types].xml'), $typesXml, $utf8)
$saidaAbs = Join-Path (Resolve-Path (Split-Path -Parent $Saida)) (Split-Path -Leaf $Saida)
if (Test-Path $saidaAbs) { Remove-Item $saidaAbs -Force }
# compacta à mão, com barras normais nos nomes das entradas: ZipFile::CreateFromDirectory usaria barras invertidas e o Word não abriria
$zip = [System.IO.Compression.ZipFile]::Open($saidaAbs, [System.IO.Compression.ZipArchiveMode]::Create)
foreach ($f in Get-ChildItem $tmp -Recurse -File) {
  $nome = $f.FullName.Substring($tmp.Length + 1).Replace('\', '/')
  $null = [System.IO.Compression.ZipFileExtensions]::CreateEntryFromFile($zip, $f.FullName, $nome, [System.IO.Compression.CompressionLevel]::Optimal)
}
$zip.Dispose()
Remove-Item $tmp -Recurse -Force
Write-Host ("Montado: {0} ({1} figuras, {2} tabelas)" -f $saidaAbs, $nFig, $nTab)
if ($SemWord) { exit 0 }

# ------------------------------------------------------------------ Word: sumário, gravação e PDF
# O passo do Word roda pelo cscript (atualizar-sumario-e-pdf.vbs): gravar e exportar o PDF pela ponte COM do
# Windows PowerShell 5.1 travava com 100% de CPU por horas; pelo VBScript a sequência inteira leva menos de um minuto.
Write-Host 'Abrindo o Word para atualizar o sumário, gravar e exportar o PDF...'
$vbs = Join-Path $PSScriptRoot 'atualizar-sumario-e-pdf.vbs'
$argumentos = @('//nologo', $vbs, $saidaAbs)
if ($Pdf) {
  $pdfAbs = Join-Path (Resolve-Path (Split-Path -Parent $Pdf)) (Split-Path -Leaf $Pdf)
  if (Test-Path $pdfAbs) { Remove-Item $pdfAbs -Force }
  $argumentos += $pdfAbs
}
$linhas = & cscript @argumentos 2>&1
$linhas | Where-Object { $_ -notmatch '^PAGINAS=' } | ForEach-Object { Write-Host $_ }
$resumo = $linhas | Where-Object { $_ -match '^PAGINAS=' }
if ($LASTEXITCODE -ne 0 -or -not $resumo -or ($Pdf -and -not (Test-Path $pdfAbs))) {
  Write-Host 'ERRO: o Word não concluiu a atualização do sumário, a gravação ou o PDF.'
  exit 1
}
Write-Host ("Gerado: {0} ({1})" -f $saidaAbs, ($resumo -replace '=', ' ' -replace 'PAGINAS', 'páginas:' -replace 'TABELAS', 'tabelas:' -replace 'FIGURAS', 'figuras:' -replace 'SECOES', 'seções:'))
