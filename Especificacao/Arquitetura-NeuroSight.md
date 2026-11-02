# Arquitetura do NeuroSight (Seção IV.A)

Versão de trabalho de 26/10/2026. Base: [Decisoes-tecnicas-NeuroSight.md](Decisoes-tecnicas-NeuroSight.md), [Modelo-logico-relacional-NeuroSight.md](Modelo-logico-relacional-NeuroSight.md) e [Diagramas-de-sequencia-NeuroSight.md](Diagramas-de-sequencia-NeuroSight.md).

## Figuras para o artigo

O arquivo [Arquitetura-NeuroSight.drawio](Arquitetura-NeuroSight.drawio) tem duas páginas, já no formato de figura do artigo (sem título dentro da imagem, porque o título vai na legenda, como no modelo).

1. **Figura – Arquitetura.** Legenda sugerida: "FIGURA n - Arquitetura do NeuroSight." e, abaixo, "FONTE: O autor (2026)".
2. **Figura – Fluxo de uma sessão.** Substitui a Figura 1 do 1.2. Legenda sugerida: "FIGURA n - Fluxo de uma sessão no NeuroSight." e "FONTE: O autor (2026)".

Para exportar no draw.io, use Arquivo → Exportar como. PNG com zoom de 300% e a opção de recortar serve para o Word. PDF ou SVG serve para o LaTeX.

**O que mudou em relação à figura do 1.2:**
- Saiu a seta direta entre o sistema web e o Meta Quest Pro ("início da sessão e espelhamento, mesma rede").
- O comando de início agora passa pelo servidor.
- A gravação passou a aparecer como quadros enviados ao servidor, que monta o vídeo.
- Entrou uma nota sobre o pareamento do óculos.

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
| Proxy reverso | Caddy ou Nginx | HTTPS (RNF02) e encaminhamento para a API e o sistema web; não aparece na figura |

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

## Roteiro para o texto da IV.A

O texto escrito a partir deste roteiro está em [IV-A-Arquitetura-do-sistema.md](../Texto-TCC/IV-A-Arquitetura-do-sistema.md).

O modelo do TCC abre a Seção IV com um parágrafo e, em IV.A, apresenta a figura da arquitetura, descreve os componentes e detalha a integração em subseções numeradas ("1) Integração com o SIGA"). Para o NeuroSight:

1. **Abertura da Seção IV.** Um parágrafo dizendo que a seção apresenta a arquitetura proposta; as telas ficam para o TCC2.
2. **A. Arquitetura do Sistema.** A Figura de arquitetura e um parágrafo por componente, com base na tabela "Componentes".
3. **1) Multi-tenant.** `tenant_id` em todas as tabelas com RLS, FKs compostas para garantir o mesmo tenant, os três papéis do banco e os arquivos separados por tenant. Fonte: modelo lógico.
4. **2) Comunicação entre sistema web, servidor e óculos.** A figura do fluxo, mais o pareamento (SD02), o envio da sessão e o início por consulta ao servidor (SD03, SD04) e o envio dos dados (SD05). Vale explicar por que não há espelhamento nem WebSocket.
5. **3) Dados coletados e gravação.**
   - O JSON: eventos de estímulo, olhar a cada quadro e expressões FACS.
   - Os quadros viram um MP4 montado no servidor.
   - A importação das amostras para tabelas, com o JSON original guardado.
   - O volume estimado: cerca de 300 MB por sessão de 5 min a 15 quadros/s. A base é a IC, que mediu 88 MB por minuto a ~22 quadros/s, com quadros de 1024 × 1024; falta medir no NeuroSight.
6. **4) Segurança e auditoria.**
   - Proteção do acesso: HTTPS, JWT e token do óculos.
   - Quem vê o quê: perfis cumulativos e visibilidade das sessões.
   - Auditoria que não pode ser alterada.
   - LGPD: minimização de dados, paciente identificado só por código no óculos e nenhuma imagem do rosto guardada.
   - O consentimento fica a cargo do protocolo da pesquisa.
7. **Limitações a citar.** O Meta Quest Pro saiu de linha; o rastreamento facial no Unreal ainda depende de prova de conceito; e o óculos precisa de internet no momento do início.
