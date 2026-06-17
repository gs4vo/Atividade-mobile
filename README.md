# Projeto Final

Projeto Flutter mobile com autenticacao, sessao de usuario e listagem de
produtos usando a API DummyJSON.

## Funcionalidades

- Login com `POST https://dummyjson.com/auth/login`
- Validacao de usuario e senha no formulario
- Tratamento de erro no login
- Sessao autenticada em memoria com token e dados do usuario
- Bloqueio da tela de produtos quando nao ha usuario autenticado
- Nome do usuario autenticado exibido na tela principal
- Logout
- Listagem de produtos com `GET https://dummyjson.com/products`
- Modelo `Product` ajustado para a resposta da DummyJSON
- Lista com titulo, preco e imagem
- Tela de detalhes com nome, preco, descricao e imagem
- Navegacao com `Navigator.push` e retorno com `Navigator.pop`
- Controle local de favoritos com atualizacao automatica da interface
- Tratamento de carregamento e erro nas requisicoes

## Credenciais de teste

Use as credenciais abaixo:

- Usuario: `admin`
- Senha: `admin`

O app usa essas credenciais como alias local e autentica na DummyJSON com
`POST /auth/login`.

## Organizacao

```text
lib/
  models/
    authenticated_user.dart
    product.dart
  providers/
    product_provider.dart
    session_provider.dart
  screens/
    auth_gate.dart
    login_screen.dart
    product_detail_screen.dart
    product_form_screen.dart
    product_list_screen.dart
  services/
    auth_service.dart
    product_service.dart
  widgets/
    product_card.dart
    product_form_field.dart
```

## Gerenciamento de estado

O projeto usa Provider porque o escopo da aplicacao e direto: uma sessao de
usuario e uma lista de produtos compartilhada entre telas. `SessionProvider`
controla autenticacao, usuario atual e logout. `ProductProvider` controla
carregamento, erros, lista de produtos, cadastro, edicao, exclusao e favoritos.

## Executando

```bash
flutter pub get
flutter run
```

## Verificacao

```bash
flutter analyze
flutter test
```
