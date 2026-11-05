# Prompt para gerar a Especificação Técnica em outro computador

Copie o texto abaixo e cole numa sessão nova do Claude Code aberta na pasta do repositório (`git clone https://github.com/joaozanini/tcc1`, branch `apendices-casos-de-uso-e-historias`).

---

Leia o CLAUDE.md antes de começar. Estou na branch `apendices-casos-de-uso-e-historias` do repositório do meu TCC1 (NeuroSight). A entrega são dois documentos: o artigo (`Texto-TCC/`, já gerado e pronto) e a Especificação Técnica (`Especificacao-Tecnica/`), que é o que falta gerar.

Situação:

- `Especificacao-Tecnica/montar-especificacao.pl` já funciona: lê os artefatos de `Especificacao/`, `Contextualizacao.md` e `Resumo-e-Abstract.md` e gera `Especificacao-Tecnica-NeuroSight.md` (cerca de 22 mil palavras, 47 figuras, 61 tabelas, 60 histórias de usuário, 11 referências) e a pasta `figuras/`. Rode-o primeiro para confirmar.
- `Especificacao-Tecnica/gerar-especificacao-docx.ps1` preenche o template do curso (`Referencias-e-modelos/Template Especificação Técnica TCC TADS UFPR.docx`) via COM do Word e exporta `.docx` e `.pdf`. Ele chegou a preencher capa, folha de rosto, resumo e os apêndices A a C, mas é inviável: digita parágrafo a parágrafo pela Selection e ficou mais de três horas sem terminar, travado no Apêndice D. Precisa ser reescrito.

O que quero:

1. Reescrever o gerador do `.docx` para montar o corpo de uma vez, em vez de digitar no Word. Sugestão: gerar o corpo inteiro como HTML (ou RTF) com os nomes de estilo do template e inseri-lo com `Selection.InsertFile` em uma única chamada, deixando o Word só para capa, folha de rosto, resumo, sumário, numeração e exportação do PDF. Outra opção é montar o OOXML diretamente a partir do template (System.IO.Packaging ou similar) e usar o Word só para atualizar o sumário e exportar o PDF. Escolha a que terminar em minutos, não em horas, e mantenha os requisitos do template descritos no CLAUDE.md (estilos "Texto", "Título 1", "Título pós-textual", "Apêndice" com numeração automática "APÊNDICE A - ", "Título HU" com numeração "HU n.", "Referência", "Resumo", legendas "FIGURA n - Título" acima e "FONTE: Os autores (2026)" abaixo, tabelas no estilo do template, páginas paisagem para os diagramas largos, A4 com margens 3/3/2/2 cm, Arial 12, número de página no cabeçalho, sumário atualizado).
2. Conferir o PDF gerado página por página (capa, folha de rosto, termo de aprovação, resumo, abstract, sumário, contextualização, referências e todos os apêndices A a I), e registrar no `Checklist-TCC1-NeuroSight.md`, seção 12, o resultado e o número de páginas.
3. Regenerar o Word do artigo com `powershell -ExecutionPolicy Bypass -File ./Texto-TCC/gerar-docx.ps1`: o `.docx` atual está com quatro palavras-chave e o `.md` já tem cinco.
4. Atualizar o CLAUDE.md e o README se o fluxo de geração mudar.

Armadilhas conhecidas (também na memória do CLAUDE.md): os `.ps1` precisam de BOM UTF-8 para os acentos não quebrarem no Windows PowerShell 5.1 (a ferramenta Edit remove o BOM, confira depois de editar); o nome do template está em Unicode NFD no disco, então localize-o com `Get-ChildItem -Filter 'Template*.docx'`; o Word em segundo plano responde RPC_E_CALL_REJECTED logo depois de abrir, use tentativas com espera; não mate o WINWORD por script, o gerador tem que fechar o Word sozinho; não edite os arquivos gerados (`.md` montado, `.docx`, `.pdf`), mude a fonte e gere de novo.

Regras: português do Brasil, "os autores" no plural; não acrescente artefatos nem apêndices além dos que já estão em `Especificacao/`; não faça commit nem push sem eu pedir. Quando terminar, me diga o que gerou e o que conferiu.
