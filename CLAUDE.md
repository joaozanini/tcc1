# CLAUDE.md – TCC1 NeuroSight

Instruções para quem trabalha neste repositório com o Claude. Leia antes de mexer no texto, nos diagramas ou nos scripts.

## Regra principal: o exemplo do curso é só formato, o TCC tem de ser completo

`Referencias-e-modelos/TCC_TADS_Exemplo.pdf` serve **apenas** como referência de formato: estrutura das seções, capa e folha de rosto, estilo das legendas ("FIGURA n -" em cima, "FONTE:" embaixo), citações numéricas e referências. **Ele não é referência de completude nem de profundidade.** O exemplo mostra um único diagrama de casos de uso "como exemplo" porque é um exemplo; este é o TCC de verdade.

Portanto:

- O documento e os diagramas devem estar **completos**. Tudo o que foi modelado na pasta `Especificacao` (todos os diagramas de casos de uso, histórias de usuário, requisitos, classes, estados, modelo lógico-relacional, sequência, BPMN, protótipos) precisa aparecer na entrega, e não só um recorte ilustrativo.
- Nunca reduzir, resumir ou deixar algo de fora com a justificativa "o exemplo do curso só tem um" ou "o exemplo não tem isso". Se o exemplo tem menos, o exemplo é que está incompleto para o nosso caso.
- Um diagrama de "exemplo" no texto é insuficiente. Se o artigo mostra um diagrama de uma família (por exemplo, um dos doze de casos de uso), os outros também entram: no corpo do texto ou em apêndice, mas entram.
- Onde entra cada coisa (corpo do artigo ou apêndices, ou a especificação técnica no template do curso) é decisão do autor com o orientador. A regra é que nada fique só "disponível on-line".
- Os artefatos entram na entrega por etapas, conforme o autor pedir em cada vez. Não acrescente apêndices nem artefatos que ele não pediu: em 03/11/2026 foram pedidos só os casos de uso e as histórias de usuário, e uma montagem com os nove apêndices teve de ser desfeita.

## O que é o projeto

NeuroSight: sistema de apoio à pesquisa com pessoas com distúrbios da consciência. App em Unreal Engine no Meta Quest Pro (olhar e expressões faciais), sistema web em Next.js, servidor em NestJS com PostgreSQL multi-tenant. TCC em dupla (João Vitor Zanini Pedro e Lucas Sarnacki Guiraud), TADS/UFPR, 2026. O TCC1 vai até a Seção IV.A (Arquitetura); IV.B em diante é TCC2.

## Onde está cada coisa

- `Texto-TCC/`: fonte do artigo, um `.md` por seção. `montar-artigo.pl` junta tudo em `Artigo-TCC1-NeuroSight.md`; `gerar-latex.pl --pdf` gera `LaTeX/`, o `.zip` do Overleaf e `TCC1-NeuroSight.pdf`; `gerar-docx.ps1` gera o Word. Depois de qualquer mudança nos `.md`, rode os três, nessa ordem.
- `Texto-TCC/figuras/`: PNGs das figuras do artigo, numerados (`Figura-1-...`). As larguras ficam em `gerar-latex.pl` (`%largura`) e `gerar-docx.ps1` (`$larguras`); ao renumerar, ajuste os dois. A subpasta `apendices/` é gerada: não edite nada nela.
- `Texto-TCC/Apendices.md`: gerado por `montar-apendices.pl` (chamado por `montar-artigo.pl`) a partir dos `.md` e das imagens da pasta `Especificacao`. Hoje o artigo traz dois apêndices, A (os doze diagramas de casos de uso) e B (as histórias de usuário); os blocos dos outros artefatos estão prontos no script, desligados na lista `@ativos`, até o autor e o orientador decidirem incluí-los. Para mudar um apêndice, mude o artefato na especificação e monte o artigo de novo; nunca edite `Apendices.md` à mão. No LaTeX, os apêndices vão numa coluna só, com figuras e tabelas flutuantes presas ao próprio apêndice e as figuras largas em página paisagem.
- `Especificacao/`: os artefatos de modelagem, um `.drawio` e um `.md` por tema. `imagens-dos-diagramas/` tem todas as páginas exportadas em PNG.
- `Checklist-TCC1-NeuroSight.md`: estado de cada item e histórico das decisões, com data. Registre ali o que mudar.
- `Referencias-e-modelos/`: o exemplo do curso, o modelo LaTeX e o template da especificação técnica.

## Como exportar um diagrama em PNG

Não há draw.io instalado. Gere um HTML com `<div class="mxgraph" data-mxgraph="...">` (o JSON leva `page`, `border: 20` e o XML inteiro do `.drawio`), carregue `https://viewer.diagrams.net/js/viewer-static.min.js` e renderize com o Edge sem janela:

```
msedge --headless=new --disable-gpu --hide-scrollbars --user-data-dir=<pasta temporária> --window-size=<pageWidth>,<pageHeight> --force-device-scale-factor=3 --virtual-time-budget=20000 --screenshot=<saida.png> file:///<arquivo.html>
```

Fator 3 para as figuras do artigo, fator 2 para `Especificacao/imagens-dos-diagramas`. Use fonte de 13 px nos diagramas que entram no artigo na largura das duas colunas; com 11 px o texto impresso fica com cerca de 5 pt.

## Convenções

- Texto em português do Brasil, no plural ("os autores"); a IC foi só do João ("um dos autores").
- Não fazer commit nem push sem o autor pedir.
- Nos diagramas de casos de uso, elipse cinza tracejada = caso de uso de outro diagrama; ator "—" na tabela = caso incluído ou estendido, cujo ator é o do caso base.
