# Gera uma imagem PNG de cada tela de Prototipos-NeuroSight.html, usando o Microsoft Edge sem abrir janela.
# Uso, na pasta do TCC:
#   powershell -ExecutionPolicy Bypass -File .\Prototipos-NeuroSight\gerar-imagens.ps1

$pasta = $PSScriptRoot
$html = Join-Path $pasta "Prototipos-NeuroSight.html"
$saida = Join-Path $pasta "imagens"
$perfil = Join-Path $env:TEMP "neurosight-prototipos-edge"

$edge = "${env:ProgramFiles(x86)}\Microsoft\Edge\Application\msedge.exe"
if (-not (Test-Path $edge)) { $edge = "$env:ProgramFiles\Microsoft\Edge\Application\msedge.exe" }
if (-not (Test-Path $edge)) { throw "Microsoft Edge não encontrado." }

$url = ([System.Uri]$html).AbsoluteUri
New-Item -ItemType Directory -Force $saida | Out-Null

# id da tela no HTML, nome da imagem, largura e altura da tela; a imagem sai com o dobro de pixels
$telas = @(
  @('web-landing',     'W01-apresentacao',        1440, 900),
  @('web-cadastro',    'W02-criar-conta',         1440, 900),
  @('web-login',       'W03-entrar',              1440, 900),
  @('web-pacientes',   'W04-pacientes',           1440, 900),
  @('web-paciente',    'W05-paciente',            1440, 900),
  @('web-estimulos',   'W06-estimulos',           1440, 900),
  @('web-modelo',      'W07-modelo-de-sessao',    1440, 900),
  @('web-nova-sessao', 'W08-nova-sessao',         1440, 900),
  @('web-sessoes',     'W09-sessoes',             1440, 900),
  @('web-sessao',      'W10-sessao-pronta',       1440, 900),
  @('web-analise',     'W11-analise-da-sessao',   1440, 900),
  @('web-oculos',      'W12-oculos-e-pareamento', 1440, 900),
  @('web-usuarios',    'W13-usuarios',            1440, 900),
  @('web-auditoria',   'W14-auditoria',           1440, 900),
  @('app-pareamento',  'A1-codigo-de-pareamento', 1280, 720),
  @('app-aguardando',  'A2-aguardando-sessao',    1280, 720),
  @('app-pronta',      'A3-sessao-pronta',        1280, 720),
  @('app-execucao',    'A4-execucao',             1280, 720),
  @('app-envio',       'A5-envio-dos-dados',      1280, 720)
)

foreach ($t in $telas) {
  $png = Join-Path $saida ($t[1] + ".png")
  & $edge --headless=new --disable-gpu --hide-scrollbars --no-first-run --force-device-scale-factor=2 `
    "--user-data-dir=$perfil" "--window-size=$($t[2]),$($t[3])" "--screenshot=$png" "$url#$($t[0])" 2>$null | Out-Null
  Write-Host ($t[1] + ".png")
}
