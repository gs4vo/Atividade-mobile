# Atividade 05 — Evolução Arquitetural da Aplicação

Aplicação Flutter estruturada em camadas (`presentation` / `domain` / `data` / `core`) consumindo produtos da FakeStore API.

## Melhorias implementadas

1) **Estado da interface**
- A tela de produtos representa explicitamente os estados: **carregando**, **erro**, **dados carregados**.
- O controle do estado fica no ViewModel (`ProductsViewModel`).

2) **Tratamento de erros**
- Falhas de comunicação com a API geram erro tratado e exibido ao usuário.

3) **Cache local simples**
- Implementado cache via `shared_preferences` (armazenando uma lista JSON de produtos).
- Se a API não estiver disponível, o repositório tenta retornar os dados previamente salvos.

## Requisitos arquiteturais (como foi atendido)
- **UI não faz HTTP diretamente**: a UI conversa apenas com o ViewModel.
- **ViewModel coordena o estado**: `ProductsViewModel` decide loading/error/success e notifica a UI.
- **Repository decide a origem**: `ProductRepositoryImpl` tenta remoto e faz fallback para cache local.
- **DataSources fazem apenas IO**: remoto faz HTTP; local lê/escreve no armazenamento simples.

## Questionário de Reflexão

### 1) Em qual camada foi implementado o mecanismo de cache? Por quê?
O cache foi implementado na **camada `data`**, dividido em:
- um **DataSource local** (responsável apenas por IO: salvar/carregar JSON do armazenamento), e
- a **decisão de fallback** dentro do **Repository**.

Isso é adequado porque o Repository é quem deve **decidir de onde vêm os dados** (remoto vs. local), mantendo a UI e o domínio independentes de detalhes de infraestrutura.

### 2) Por que o ViewModel não deve realizar chamadas HTTP diretamente?
Porque isso acopla o ViewModel a detalhes de infraestrutura (HTTP, URLs, parsing), dificultando testes e manutenção. O ViewModel deve focar em **orquestrar casos de uso e estado de tela**, delegando IO para `data`.

### 3) O que poderia acontecer se a interface acessasse diretamente o DataSource?
A UI ficaria acoplada ao detalhe de IO (HTTP/cache), espalhando regras de erro e de origem de dados pela tela. Isso tende a gerar **código duplicado**, piora testabilidade e dificulta evoluções (ex.: mudar API, adicionar autenticação, trocar cache).

### 4) Como essa arquitetura facilitaria a substituição da API por um banco de dados local?
Basta criar/alterar um DataSource (ou um Repository) para buscar no banco local, mantendo a mesma interface de `ProductRepository`. Assim, **usecases e UI não mudam**, porque dependem apenas das abstrações do domínio.
