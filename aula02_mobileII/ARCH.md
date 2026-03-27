# ARCH

## Estrutura final (feature-first)

```text
lib/
  core/
    errors/
      app_error.dart
    ui/
      app_root.dart
  features/
    todos/
      data/
        datasources/
          todo_local_datasource.dart
          todo_remote_datasource.dart
        models/
          todo_model.dart
        repositories/
          todo_repository_impl.dart
      domain/
        entities/
          todo.dart
        repositories/
          todo_repository.dart
      presentation/
        pages/
          todos_page.dart
        viewmodels/
          todo_viewmodel.dart
        widgets/
          add_todo_dialog.dart
  main.dart
```

## Fluxo de dependências

UI (`TodosPage`) -> ViewModel (`TodoViewModel`) -> Repository (`TodoRepository`/`TodoRepositoryImpl`) -> DataSources (`TodoRemoteDataSource`, `TodoLocalDataSource`)

## Diagrama do fluxo

```text
[TodosPage + AddTodoDialog]
            |
            v
      [TodoViewModel]
            |
            v
      [TodoRepository]
            |
            v
[TodoRepositoryImpl]
      |            |
      v            v
[Remote DS]   [Local DS]
```

## Justificativa da estrutura

- Organização por feature (`todos`) reduz acoplamento entre camadas de módulos distintos.
- Separação `presentation/domain/data` deixa claro onde UI, contrato de negócio e integração externa devem ficar.
- `core` guarda componentes compartilháveis, fora de uma feature específica.

## Decisões de responsabilidade

- Validação de entrada mínima (título vazio) ficou no `TodoViewModel`, mantendo a regra já existente.
- Parsing JSON ficou em `TodoModel.fromJson`, na camada `data/models`.
- A escolha e orquestração entre remoto/local ficou centralizada no `TodoRepositoryImpl`.
- A UI não acessa HTTP nem `SharedPreferences` diretamente; apenas consome estado e ações do ViewModel.
- O ViewModel não conhece Widgets nem `BuildContext`; ele expõe apenas estado e operações assíncronas.
