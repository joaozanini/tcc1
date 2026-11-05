# Arquitetura do NeuroSight (Subseção III.C do artigo e contextualização da Especificação Técnica)

Versão de trabalho de 26/10/2026. Base: [Decisoes-tecnicas-NeuroSight.md](Decisoes-tecnicas-NeuroSight.md), [Modelo-logico-relacional-NeuroSight.md](Modelo-logico-relacional-NeuroSight.md) e [Diagramas-de-sequencia-NeuroSight.md](Diagramas-de-sequencia-NeuroSight.md).

## Figuras para o artigo

O arquivo [Arquitetura-NeuroSight.drawio](Arquitetura-NeuroSight.drawio) tem duas páginas, já no formato de figura do artigo (sem título dentro da imagem, porque o título vai na legenda, como no modelo). Desde 03/11/2026 são as únicas figuras do artigo, que segue o modelo de 2026 (`Referencias-e-modelos/TCC_Artigo_Modelo_2026.pdf`) e não traz diagramas de modelagem; ficam na Subseção III.C. A primeira também abre a contextualização da Especificação Técnica.

1. **Figura – Arquitetura.** Figura 1 do artigo: "FIGURA 1 - Arquitetura do NeuroSight" e, abaixo, "FONTE: Os autores (2026)", sem ponto final, como no modelo.
2. **Figura – Fluxo de uma sessão.** Figura 2 do artigo (substituiu a Figura 1 do 1.2): "FIGURA 2 - Fluxo de uma sessão no NeuroSight" e "FONTE: Os autores (2026)".

Para exportar no draw.io, use Arquivo → Exportar como, PNG com zoom de 300% e a opção de recortar, e grave em `Texto-TCC/figuras/` como `Figura-1-arquitetura.png` e `Figura-2-fluxo-de-uma-sessao.png`. Sem o draw.io, use o processo do CLAUDE.md (visualizador do diagrams.net no Edge sem janela).

**O que mudou em relação à figura do 1.2:**
- Saiu a seta direta entre o sistema web e o Meta Quest Pro ("início da sessão e espelhamento, mesma rede").
- O comando de início agora passa pelo servidor.
- A gravação passou a aparecer como quadros enviados ao servidor, que monta o vídeo.
- Entrou uma nota sobre o pareamento do óculos.

**Revisão de 05/11/2026 (a pedido do autor):** na Figura 1, as setas passaram a indicar o sentido dos dados (duplas onde há leitura e gravação), a fila do pg-boss foi para a caixa do banco, onde o texto diz que ela fica, e o proxy reverso entrou na figura, porque o texto o cita. A Figura 2 deixou de ser um diagrama de componentes com listas de responsabilidades e virou um fluxo numerado (1 a 10), no estilo de um diagrama de sequência resumido, com os passos que faltavam: o aviso de "pronto" do óculos, a liberação do botão "Iniciar" e a confirmação do início na consulta seguinte. Os nomes dos componentes ficaram iguais nas duas figuras ("App de coleta", "Sistema web", "Servidor"). Fonte de 13 px nas duas páginas e as duas figuras na largura das duas colunas.

## Componentes

| Componente | Tecnologia | Responsabilidade |
|---|---|---|
| App de coleta | Unreal Engine 5.5 (C++), OpenXR e Meta XR, no Meta Quest Pro | Baixa a sessão e os estímulos, exibe os estímulos, coleta olhar e expressões, captura os quadros e envia os dados |
| Sistema web | Next.js (React, TypeScript) | Interface de pesquisadores e administradores; não tem regra de negócio |
| API | NestJS (TypeScript) com Prisma | Regras de negócio, autenticação (JWT e token do óculos), RLS por transação, auditoria e entrega dos arquivos |
| Banco de dados | PostgreSQL 15 ou mais novo, com RLS | Dados de todos os tenants, isolados; também guarda a fila de tarefas (pg-boss) |
| Arquivos | Disco do servidor (volume Docker), atrás de uma interface que permite trocar por S3 | Estímulos, JSON originais, quadros (temporários) e vídeos MP4 |
| Processamento | Worker com pg-boss e FFmpeg (mesmo código da API, em outro contêiner) | Importa eventos e amostras para o banco e monta o MP4 |
| Serviço de e-mail | SMTP de um provedor externo | Confirmação de e-mail, convite e redefinição de senha |
| Proxy reverso | Caddy ou Nginx | HTTPS (RNF02) e encaminhamento para a API e o sistema web; aparece na Figura 1 desde 05/11/2026 |

## Comunicação

| De → para | Protocolo | Autenticação | Quando |
|---|---|---|---|
| Sistema web → API | HTTPS (REST) | JWT do usuário, com tenant e perfil | Ações do usuário e consulta do estado da sessão |
| App → API | HTTPS (REST) | Token do óculos (o segredo do pareamento) | Consulta a cada ~1 s enquanto espera; envio dos dados no fim |
| API → banco | SQL (Prisma) | Papel `neurosight_api`, com RLS. Exceção: papel `neurosight_auth` no autocadastro, login, tokens e pareamento | Toda operação |
| API e processamento → arquivos | Sistema de arquivos | — | Envio e leitura de arquivos; montagem do vídeo |
| Processamento → banco | SQL | Papel `neurosight_api`, com o tenant da tarefa | Fila e importação das amostras |
| API → e-mail | SMTP | Credencial do provedor | Autocadastro, convite e redefinição de senha |

Não há comunicação direta entre o sistema web e o óculos, nem exigência de que estejam na mesma rede (RNF20).

## Implantação

- **Onde roda:** com Docker Compose (RNF26), numa VPS de preferência em região no Brasil ou num servidor da instituição; a escolha cabe ao protocolo aprovado pelo CEP (LGPD, art. 13).
- **Contêineres:** `proxy` (Caddy), `web` (Next.js), `api` (NestJS), `worker` (o mesmo código da API, rodando só o processamento) e `postgres`.
- **Arquivos:** um volume persistente, organizado em pastas por tenant (`/dados/<tenant_id>/...`).
- **Cópia de segurança:** diária, do banco e do volume de arquivos (RNF12).

## Roteiro para o texto do artigo (Subseções III.C e III.D)

O texto escrito a partir deste roteiro está em [III-Metodo-tecnologias-e-arquitetura.md](../Texto-TCC/III-Metodo-tecnologias-e-arquitetura.md). Até 03/11/2026 ele formava a Seção IV.A, com subseções numeradas ("1) Multi-tenant"); no modelo de 2026 a arquitetura é a Subseção C da Seção III e as regras de negócio, a Subseção D, ambas em parágrafos corridos, sem subseções numeradas. Para o NeuroSight:

1. **C. Arquitetura do Sistema.** A Figura 1 e um parágrafo por componente, com base na tabela "Componentes"; a implantação (contêineres, VPS ou servidor da instituição, LGPD art. 13); o multi-tenant (`tenant_id` em todas as tabelas com RLS, FKs compostas, os papéis do banco e os arquivos separados por tenant, do modelo lógico); a comunicação (Figura 2, pareamento de SD02, envio e início por consulta ao servidor de SD03 e SD04, por que não há espelhamento nem WebSocket); e o controle de acesso (HTTPS, JWT e token do óculos, perfis cumulativos).
2. **D. Regras de Negócio e Processamento dos Dados.** As regras das sessões (modelo e sessão personalizada, estímulos pessoais, uma sessão pendente por óculos, os nove estados, sem edição depois do envio e sem interrupção depois do início); os dados coletados (JSON com eventos de estímulo, olhar a cada quadro e expressões FACS, mais os quadros JPEG); o envio em lotes e o processamento (importação das amostras para tabelas, MP4 com FFmpeg, JSON original guardado, dados coletados imutáveis, volume estimado de cerca de 300 MB por sessão de 5 min, com base nos 88 MB por minuto da IC); a análise no sistema web (mapa de calor, modo validação, gráficos, resumo por estímulo); quem vê o quê e a auditoria imutável; LGPD (minimização, paciente só por código no óculos, nenhuma imagem do rosto, consentimento a cargo do protocolo da pesquisa).
3. **Limitações.** Vão na Seção IV (Considerações Finais), não na arquitetura: o rastreamento facial no Unreal depende de prova de conceito; o Meta Quest Pro saiu de linha; e o óculos precisa de internet no momento do início.
