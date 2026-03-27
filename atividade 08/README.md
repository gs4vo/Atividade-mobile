# Flutter State Management Examples

Este projeto demonstra diferentes estratégias de **gerenciamento de
estado em aplicações Flutter**, comparando três abordagens amplamente
utilizadas no ecossistema do framework:

-   Provider
-   Riverpod
-   BLoC

O objetivo do projeto é apresentar, de forma prática, como cada
abordagem organiza o fluxo de dados entre a lógica da aplicação e a
interface do usuário.

Este material foi desenvolvido como apoio didático para disciplinas
relacionadas a **desenvolvimento mobile e arquitetura de aplicações**.

------------------------------------------------------------------------

# Repositório

O projeto pode ser encontrado em:

https://github.com/jeffersonspeck/state_mobile_aula01

------------------------------------------------------------------------

# Objetivo do projeto

Aplicações modernas precisam reagir continuamente a mudanças de dados.
Sempre que o estado da aplicação muda, a interface precisa ser
atualizada.

Esse processo é conhecido como **gerenciamento de estado**.

Este projeto apresenta três formas diferentes de lidar com esse problema
no Flutter, utilizando um exemplo simples de **contador interativo**.

Cada abordagem implementa exatamente a mesma funcionalidade, permitindo
observar apenas as diferenças arquiteturais entre os padrões.

------------------------------------------------------------------------

# Estrutura do projeto

    lib/

    main.dart

    presentation/
      pages/
        home_page.dart
        provider_page.dart
        riverpod_page.dart
        bloc_page.dart

    state/
      provider/
        counter_provider.dart

      riverpod/
        counter_riverpod.dart

      bloc/
        counter_event.dart
        counter_state.dart
        counter_bloc.dart

### presentation

Contém as telas da aplicação e os componentes de interface.

### state

Contém os componentes responsáveis pelo gerenciamento de estado em cada
abordagem.

------------------------------------------------------------------------

# Abordagens implementadas

## Provider

Provider é uma solução simples baseada no padrão **Observer**.

Fluxo:

    Widget
       ↓
    ChangeNotifier
       ↓
    notifyListeners()
       ↓
    Interface reconstruída

Características:

-   simples de utilizar
-   pouco código
-   ideal para aplicações pequenas e médias

------------------------------------------------------------------------

## Riverpod

Riverpod é uma evolução conceitual do Provider, oferecendo melhor
controle de dependências e maior previsibilidade no fluxo de dados.

Fluxo:

    Widget
       ↓
    ref.watch(provider)
       ↓
    Provider mantém estado
       ↓
    Estado muda
       ↓
    Interface reconstruída

Características:

-   não depende de BuildContext
-   melhor organização de dependências
-   mais seguro para aplicações maiores

------------------------------------------------------------------------

## BLoC

BLoC (Business Logic Component) utiliza um modelo baseado em **eventos e
estados**.

Fluxo:

    Interface
       ↓
    Evento
       ↓
    Bloc processa lógica
       ↓
    Novo estado
       ↓
    Interface reage

Características:

-   fluxo de dados explícito
-   alta previsibilidade
-   melhor testabilidade
-   mais estrutura arquitetural

------------------------------------------------------------------------

# Comparação entre abordagens

  Abordagem   Complexidade   Fluxo explícito   Escalabilidade
  ----------- -------------- ----------------- ----------------
  Provider    baixa          não               média
  Riverpod    média          parcial           alta
  BLoC        alta           sim               muito alta

------------------------------------------------------------------------

# Executando o projeto

Clone o repositório:

    git clone https://github.com/jeffersonspeck/state_mobile_aula01

Entre na pasta:

    cd state_mobile_aula01

Instale dependências:

    flutter pub get

Execute:

    flutter run

------------------------------------------------------------------------

# Telas da aplicação

A aplicação possui uma tela inicial que permite acessar três exemplos:

-   Provider
-   Riverpod
-   BLoC

Cada tela implementa o mesmo comportamento utilizando uma estratégia
diferente de gerenciamento de estado.

------------------------------------------------------------------------

# Atividade sugerida

Modifique o projeto para criar uma pequena aplicação de **listagem de
produtos**, permitindo:

-   visualizar uma lista de produtos
-   adicionar produtos a uma lista de favoritos
-   compartilhar o estado entre duas telas

Você deve escolher **uma das abordagens apresentadas no projeto** para
implementar essa funcionalidade.

------------------------------------------------------------------------

# Tecnologias utilizadas

-   Flutter
-   Dart
-   Provider
-   Riverpod
-   Flutter BLoC

------------------------------------------------------------------------

# Autor

Jefferson Rodrigo Speck

Professor e pesquisador em Ciência da Computação, com atuação em
desenvolvimento de software, inteligência artificial e tecnologias
educacionais.

------------------------------------------------------------------------

# Licença

Este projeto é destinado a fins educacionais.
