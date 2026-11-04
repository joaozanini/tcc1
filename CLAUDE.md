# CLAUDE.md – TCC1 NeuroSight

Instruções para quem trabalha neste repositório com o Claude. Leia antes de mexer no texto, nos diagramas ou nos scripts.

## Regra principal: a entrega são dois documentos, cada um no seu modelo

Decidido em 03/11/2026: o TCC tem **dois documentos**, e cada um segue um modelo próprio do curso. Não misture os dois.

### 1. O artigo (`Texto-TCC/`) segue `Referencias-e-modelos/TCC_Artigo_Modelo_2026.pdf`

É um TCC de 2026 do mesmo orientador, e o artigo do NeuroSight tem de seguir esse PDF **como está**:

- **Pré-textuais:** capa (UFPR, autores um por linha, título, Curitiba, PR, ano, com o desenho do prédio da UFPR ao fundo), folha de rosto (autores, título, natureza do trabalho, orientador, Curitiba, ano) e a página do termo de aprovação ("Insira aqui o termo de aprovação...").
- **Cabeçalho do artigo:** título, autores com ¹, "¹Setor de Educação Profissional e Tecnológica / Universidade Federal do Paraná"; depois Resumo, Palavras-chave, Abstract e Keywords, em duas colunas.
- **Seções, nesta ordem e com estes títulos:** I. INTRODUÇÃO (contexto, problema e objetivo, sem subseções); II. REVISÃO DE LITERATURA (subseções com letras; a última é "Trabalhos Semelhantes", com a Tabela 1 comparando as soluções correlatas e o sistema proposto); III. MÉTODO, TECNOLOGIAS E ARQUITETURA, com as subseções A. Processo de Desenvolvimento, B. Tecnologias Utilizadas (Tabela 2), C. Arquitetura do Sistema (Figura 1, a arquitetura) e D. Regras de Negócio e Processamento dos Dados; IV. CONSIDERAÇÕES FINAIS; REFERÊNCIAS (numéricas, na ordem de citação).
- **Sem apêndices e sem diagramas de modelagem no corpo.** No modelo, a única figura é a da arquitetura; os casos de uso, as classes e os demais diagramas são citados no texto e ficam na Especificação Técnica. O NeuroSight mantém só as duas figuras de arquitetura (a arquitetura e o fluxo de uma sessão).
- **Legendas:** "FIGURA n - Título" e "TABELA n - Título" acima, "FONTE: Os autores (2026)" abaixo, sem ponto final. Títulos de subseção com iniciais maiúsculas ("B. Tecnologias Utilizadas").
- **Citações:** numéricas entre colchetes, referências no padrão do modelo.

O exemplo mais antigo, `Referencias-e-modelos/TCC_TADS_Exemplo.pdf` (Sistema de Estágios, 2023), tem outra estrutura (IV. Resultados, V. Considerações Finais, VI. Artefatos) e **não é mais o modelo** do artigo. O LaTeX dele, em `TCC_TADS_Exemplo_Sistema_de_Estágios/`, continua sendo a base da classe, da capa e dos ambientes de figura e tabela.

### 2. A Especificação Técnica (`Especificacao-Tecnica/`) segue `Referencias-e-modelos/Template Especificação Técnica TCC TADS UFPR.docx`

É nela que entram **todos os artefatos de modelagem**: diagramas, histórias de usuário, requisitos, protótipos, modelo do banco, APIs. A estrutura do template é:

- Capa ("ESPECIFICAÇÃO TÉCNICA DO SISTEMA NEUROSIGHT"), folha de rosto (natureza do trabalho e orientador), página do termo de aprovação, RESUMO (150 a 500 palavras, parágrafo único, cinco palavras-chave), ABSTRACT e SUMÁRIO.
- **1 CONTEXTUALIZAÇÃO:** de 1 a 3 páginas, começando pela descrição macro do software e com pelo menos um parágrafo por apêndice, dizendo em qual apêndice cada diagrama está; pelo menos três referências, no padrão ABNT (Manual de Normalização da UFPR).
- **REFERÊNCIAS.**
- **Apêndices, com as letras do template:** A – Diagrama de casos de uso; B – Diagrama de classes; C – Histórias de usuário, protótipos de tela e diagramas de sequência (para cada caso de uso: a história, o protótipo e o diagrama de sequência, com a história no estilo "Título HU"); D – Diagrama lógico do banco de dados (notação pé de galinha); E – Especificação de APIs; F – Modelos de inteligência artificial (não se aplica ao NeuroSight, e o apêndice diz isso). Os artefatos que o template não prevê entram em apêndices a mais, depois do F: G – Requisitos do sistema, H – Diagrama de estados da sessão, I – Processos de negócio (BPMN).
- Estilos do template: "Texto" para parágrafos, "Título 1" (numerado) para a Contextualização, "Título pós-textual" para Referências, "Apêndice" (numeração automática "APÊNDICE A - ") para os apêndices, "Título HU" (numeração "HU n.") para as histórias, "Referência" para a lista de referências, "Resumo" para o resumo. Página A4 com margens de 3 cm (superior e esquerda) e 2 cm (inferior e direita), Arial 12, número de página no cabeçalho.

### Completude

O modelo do artigo é referência de **formato e de estrutura do artigo**; a completude da modelagem se mede pela pasta `Especificacao`, e tudo o que está lá tem de estar na Especificação Técnica (corpo ou apêndices). Nunca reduza, resuma ou deixe um artefato de fora com a justificativa "o template só pede A a F" ou "o modelo do artigo não tem isso". Nada fica só "disponível on-line": o link do repositório (nota 2 do artigo) é um complemento, não a entrega.

## O que é o projeto

NeuroSight: sistema de apoio à pesquisa com pessoas com distúrbios da consciência. App em Unreal Engine no Meta Quest Pro (olhar e expressões faciais), sistema web em Next.js, servidor em NestJS com PostgreSQL multi-tenant. TCC em dupla (João Vitor Zanini Pedro e Lucas Sarnacki Guiraud), TADS/UFPR, 2026, orientador Prof. Dr. Alessandro Brawerman. O TCC1 é a etapa de modelagem: o artigo vai até as Considerações Finais e a Especificação Técnica traz a modelagem completa; o desenvolvimento é o TCC2.

## Onde está cada coisa

- `Texto-TCC/`: fonte do artigo, um `.md` por seção (`I-Introducao.md`, `II-Revisao-de-literatura.md`, `III-Metodo-tecnologias-e-arquitetura.md`, `IV-Consideracoes-finais.md` e `Resumo-e-Abstract.md`). `montar-artigo.pl` junta tudo em `Artigo-TCC1-NeuroSight.md`, numerando as citações; `gerar-latex.pl --pdf` gera `LaTeX/`, o `.zip` do Overleaf e `TCC1-NeuroSight.pdf`; `gerar-docx.ps1` gera o Word. Depois de qualquer mudança nos `.md`, rode os três, nessa ordem.
- `Texto-TCC/figuras/`: as figuras do artigo (`Figura-1-arquitetura.png`, `Figura-2-fluxo-de-uma-sessao.png`) e o fundo da capa. As larguras ficam em `gerar-latex.pl` (`%largura`) e `gerar-docx.ps1` (`$larguras`); ao renumerar, ajuste os dois.
- `Especificacao-Tecnica/`: a Especificação Técnica. `Contextualizacao.md` e `Resumo-e-Abstract.md` são escritos à mão; `montar-especificacao.pl` gera `Especificacao-Tecnica-NeuroSight.md` e a pasta `figuras/` a partir deles e dos artefatos de `Especificacao/`; `gerar-especificacao-docx.ps1` preenche o template `.docx` do curso com o Word e grava `Especificacao-Tecnica-NeuroSight.docx` e `.pdf`. Não edite o `.md` gerado nem o `.docx`: mude o artefato na especificação (ou a contextualização) e gere de novo.
- `Especificacao/`: os artefatos de modelagem, a fonte de tudo: um `.drawio` e um `.md` por tema, os protótipos em `Prototipos-NeuroSight/` e todas as páginas exportadas em PNG em `imagens-dos-diagramas/`.
- `Checklist-TCC1-NeuroSight.md`: estado de cada item e histórico das decisões, com data. Registre ali o que mudar. `Pendencias-completude-TCC1.md` é o levantamento de 03/11/2026 sobre completude e legibilidade.
- `Referencias-e-modelos/`: o modelo do artigo (`TCC_Artigo_Modelo_2026.pdf`), o exemplo antigo, o LaTeX do curso e o template da Especificação Técnica.

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
- Os artefatos entram na entrega conforme o autor pedir; não acrescente artefatos ou apêndices que ele não pediu.
