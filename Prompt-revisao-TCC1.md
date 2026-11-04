Você vai fazer a revisão final do meu TCC1 (Tecnologia em Análise e Desenvolvimento de Sistemas, UFPR), o projeto **NeuroSight**: sistema de rastreamento ocular e emocional em realidade virtual (Unreal + Meta Quest Pro, API NestJS, web Next.js, PostgreSQL multi-tenant com RLS). O TCC1 é a etapa de modelagem e tem **dois documentos**: o artigo (`Texto-TCC/TCC1-NeuroSight.pdf`, que segue o modelo `Referencias-e-modelos/TCC_Artigo_Modelo_2026.pdf`: Seções I a IV, sem apêndices) e a Especificação Técnica (`Especificacao-Tecnica/Especificacao-Tecnica-NeuroSight.pdf` e `.docx`, no template `.docx` do curso, com toda a modelagem nos apêndices A a I). Os dois são a entrega; o repositório on-line é só complemento.

A pasta de trabalho é `C:\Users\joaoz\OneDrive\Documentos\TCC`. Leia **tudo** antes de concluir qualquer coisa. Não altere nenhum arquivo: quero só o relatório. Se precisar gerar arquivos temporários (PNGs extraídos de PDF, por exemplo), use uma pasta temporária fora do projeto.

## O que existe na pasta

- `Texto-TCC/TCC1-NeuroSight.pdf` e `Texto-TCC/LaTeX/build/textoprincipal.pdf`: **a versão final que vai ser entregue**. É o documento principal da revisão. Confira se os dois PDFs são a mesma versão; se não forem, diga qual é o mais recente.
- `Texto-TCC/LaTeX/textoprincipal.tex`, `tads.tex`, `figuras/`, `build/textoprincipal.log`: fonte LaTeX (classe IEEEtran adaptada) e log da compilação.
- `Texto-TCC/*.md` (I-Introducao, II-Revisao-de-literatura, III-Metodo-tecnologias-e-arquitetura, IV-Consideracoes-finais, Resumo-e-Abstract, Artigo-TCC1-NeuroSight.md) e `Artigo-TCC1-NeuroSight.docx`: fontes do texto. Os scripts `montar-artigo.pl`, `gerar-latex.pl` e `gerar-docx.ps1` geram o .tex e o .docx a partir dos .md.
- `Texto-TCC/figuras/`: figuras usadas no artigo (arquitetura e fluxo de uma sessão, mais o fundo da capa).
- `Especificacao-Tecnica/`: a Especificação Técnica. `Contextualizacao.md` e `Resumo-e-Abstract.md` são escritos à mão; `montar-especificacao.pl` gera `Especificacao-Tecnica-NeuroSight.md` e `figuras/` a partir da pasta `Especificacao`; `gerar-especificacao-docx.ps1` preenche o template do curso no Word e exporta o PDF. Confira o PDF página a página: capa, folha de rosto, resumo, sumário, contextualização (1 a 3 páginas, um parágrafo por apêndice), referências e os apêndices A a I (para cada caso de uso do Apêndice C: história, protótipo e diagrama de sequência).
- `Especificacao/`: todos os artefatos de modelagem. Cada diagrama tem um `.drawio` (XML, dá para ler direto) e um `.md` que o descreve: arquitetura, BPMN do experimento, BPMN do processo atual, casos de uso (12 páginas) e histórias, diagrama de classes, diagrama de estados da sessão, diagramas de sequência (6 fluxos), modelo lógico-relacional com dicionário de dados, requisitos (RFs e RNFs) e decisões técnicas.
- `Especificacao/Prototipos-NeuroSight/`: protótipos em HTML e as imagens exportadas em `imagens/` (W01–W14 web, A1–A5 app do óculos).
- `Checklist-TCC1-NeuroSight.md`: o que eu considero feito e o que falta.
- `Referencias-e-modelos/` e `TCC_TADS_Exemplo_Sistema_de_Estágios/`: os modelos do curso. `TCC_Artigo_Modelo_2026.pdf` é o modelo do artigo (estrutura, capa, legendas, citações e nomes das seções: confira se o artigo o segue como está); o template `.docx` é o modelo da Especificação Técnica; `TCC_TADS_Exemplo.pdf` é um exemplo antigo, com outra estrutura, e não serve mais de referência. A completude não se mede pelos modelos, e sim pela pasta Especificacao, cujos artefatos devem estar todos na Especificação Técnica (regra em CLAUDE.md).
- `Entregas-anteriores/`: entregas 1.1 (problema) e 1.2 (descrição do software). O TCC final não pode contradizer o que foi entregue sem explicar a mudança.

## Como ler

1. Leia o PDF final inteiro, página por página. Para cada figura, **olhe a imagem renderizada** (renderize as páginas do PDF como imagem se preciso), não só a legenda.
2. Leia o `.tex` e o `.log` (procure `Overfull`, `Underfull`, `undefined`, `multiply defined`, `Missing`, figuras não encontradas, referências `??`).
3. Abra cada PNG em `Texto-TCC/figuras/`, `Texto-TCC/LaTeX/figuras/` e `Especificacao/Prototipos-NeuroSight/imagens/` e veja de fato o conteúdo.
4. Leia cada `.drawio` (o XML) e o `.md` correspondente, e compare com a figura exportada e com o texto.
5. Leia os requisitos, decisões técnicas, checklist, entregas anteriores e o modelo do curso.

## Foco principal: diagramas e imagens

Para **cada figura do PDF** e **cada diagrama da Especificação**, verifique e relate:

- **Legibilidade no PDF:** o texto da figura dá para ler no tamanho em que foi impresso (coluna IEEE é estreita)? Está pixelado, borrado, cortado nas bordas, com fundo transparente que ficou preto, esticado/distorcido?
- **Figura PNG × .drawio:** a imagem exportada está atualizada em relação ao `.drawio`? Há elementos, nomes ou setas diferentes? Os PNGs em `Texto-TCC/figuras/` e `Texto-TCC/LaTeX/figuras/` são idênticos (compare hash ou conteúdo)?
- **Correção da notação:**
  - Casos de uso (UML): atores fora do sistema, fronteira do sistema, `<<include>>`/`<<extend>>` com a seta no sentido certo, generalização de atores, nomes de casos de uso com verbo no infinitivo.
  - BPMN: eventos de início e fim, raias/piscinas, gateways com saídas rotuladas e convergência, fluxo de mensagem só entre piscinas, nenhuma tarefa solta.
  - Classes: multiplicidades nos dois lados, tipos de atributos, associação × agregação × composição usadas com sentido, herança, enums.
  - Estados: estado inicial e final, toda transição com evento/condição, nenhum estado inalcançável ou sem saída (a não ser o final). Batem com a tabela "Estados da sessão"?
  - Sequência: linhas de vida, mensagens síncronas/assíncronas e retornos, fragmentos `alt`/`opt`/`loop` bem formados. As rotas da API batem com o `.md`?
  - Lógico-relacional: PK/FK marcadas, cardinalidades, `tenant_id` nas tabelas que devem ter RLS, coerência com o dicionário de dados e com o diagrama de classes.
  - Arquitetura: componentes, protocolos e direção da comunicação coerentes com Decisoes-tecnicas e com o texto da IV.A.
- **Consistência cruzada:** o mesmo conceito tem o mesmo nome em todos os diagramas, nos requisitos e no texto (entidades, estados da sessão, atores, telas). Todo RF importante aparece em algum caso de uso; toda tela dos protótipos corresponde a algum caso de uso; toda tabela do banco corresponde a uma classe.
- **Uso no texto:** toda figura é citada no texto antes de aparecer, a numeração é sequencial, a legenda descreve bem a figura e tem fonte quando não for de autoria própria. O texto diz algo que a figura não mostra, ou o contrário?
- **Protótipos:** as imagens W01–W14 e A1–A5 estão completas, sem texto de exemplo esquecido (lorem ipsum, "TODO"), com rótulos em português, coerentes entre si e com os requisitos?

## Também revise (com menos peso)

- Aderência ao modelo do curso: seções obrigatórias, capa, termo de aprovação, resumo e abstract, palavras-chave, formato IEEE das referências.
- Texto: erros de português, concordância, siglas sem definição na primeira ocorrência, frases ambíguas, termos em inglês sem itálico, inconsistência de tempo verbal.
- Referências: toda citação `[n]` existe na lista e toda referência da lista é citada; formato consistente; links funcionando no formato.
- Notas de rodapé: a nota 2 da Seção III deve ter o link do repositório no GitHub (o checklist diz que ainda falta). Aponte qualquer outro item pendente do checklist que esteja visível no PDF.
- Resumo e abstract dizem a mesma coisa e refletem o que o texto realmente entrega.

## Formato do relatório

Responda em português, organizado assim:

1. **Resumo geral** (5 linhas): está pronto para entregar? O que é bloqueante?
2. **Tabela de figuras e diagramas:** uma linha por figura/diagrama, com colunas: arquivo, onde aparece (página do PDF ou "só na especificação"), estado (OK / ajustar / refazer), problemas encontrados.
3. **Problemas por gravidade:**
   - **Bloqueantes** (erro de conteúdo, figura ilegível ou errada, contradição, item obrigatório faltando)
   - **Importantes** (notação incorreta, inconsistência de nomes, legenda ruim)
   - **Menores** (estilo, português, ajustes visuais)

   Para cada um: arquivo e página/linha/elemento exatos, o que está errado, e a correção sugerida (no caso de texto, a frase já reescrita).
4. **Itens que você não conseguiu verificar** e por quê.

Seja específico e crítico: prefiro uma lista longa de problemas reais a elogios. Não invente problemas; se algo estiver certo, diga que está certo.
