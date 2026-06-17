import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';

import 'package:projeto_final/main.dart';
import 'package:projeto_final/models/authenticated_user.dart';
import 'package:projeto_final/models/product.dart';
import 'package:projeto_final/providers/product_provider.dart';
import 'package:projeto_final/providers/session_provider.dart';
import 'package:projeto_final/services/product_service.dart';

class FakeProductService extends ProductService {
  FakeProductService({required List<Product> seed})
      : _database = List<Product>.from(seed),
        _nextId = seed.fold<int>(1, (maxId, p) {
          if (p.id == null) {
            return maxId;
          }
          return p.id! >= maxId ? p.id! + 1 : maxId;
        });

  final List<Product> _database;
  int _nextId;

  @override
  Future<List<Product>> fetchProducts() async {
    return List<Product>.from(_database);
  }

  @override
  Future<Product> addProduct(Product product) async {
    final created = product.copyWith(id: _nextId++);
    _database.insert(0, created);
    return created;
  }

  @override
  Future<Product> updateProduct(Product product) async {
    final index = _database.indexWhere((item) => item.id == product.id);
    if (index != -1) {
      _database[index] = product;
    }
    return product;
  }

  @override
  Future<bool> deleteProduct(String id) async {
    final parsedId = int.tryParse(id);
    final removedCount = _database.length;
    _database.removeWhere((item) => item.id == parsedId);
    return removedCount != _database.length;
  }
}

void main() {
  testWidgets('Lista, cadastra, edita e exclui produto', (
    WidgetTester tester,
  ) async {
    final fakeService = FakeProductService(
      seed: [
        const Product(
          id: 1,
          name: 'Notebook',
          price: 3500,
          description: 'Descricao de teste',
          image: 'https://dummyjson.com/icon/notebook/128',
          category: 'eletronicos',
        ),
      ],
    );

    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider(
            create: (_) => SessionProvider(
              initialUser: const AuthenticatedUser(
                id: 1,
                username: 'emilys',
                firstName: 'Emily',
                lastName: 'Johnson',
                email: 'emily.johnson@x.dummyjson.com',
                image: 'https://dummyjson.com/icon/emilys/128',
                accessToken: 'access-token',
                refreshToken: 'refresh-token',
              ),
            ),
          ),
          ChangeNotifierProvider(
            create: (_) => ProductProvider(service: fakeService),
          ),
        ],
        child: const MyApp(),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Produtos'), findsOneWidget);
    expect(find.text('Notebook'), findsOneWidget);

    await tester.tap(find.byTooltip('Novo produto'));
    await tester.pumpAndSettle();

    await tester.enterText(find.byKey(const Key('name_field')), 'Mouse');
    await tester.enterText(find.byKey(const Key('price_field')), '199.90');
    await tester.enterText(
        find.byKey(const Key('category_field')), 'perifericos');
    await tester.enterText(
      find.byKey(const Key('image_field')),
      'https://dummyjson.com/icon/mouse/128',
    );
    await tester.enterText(
      find.byKey(const Key('description_field')),
      'Mouse sem fio para testes',
    );

    await tester.tap(find.byKey(const Key('save_product_button')));
    await tester.pumpAndSettle();

    expect(find.text('Mouse'), findsOneWidget);

    await tester.tap(find.byKey(const ValueKey('edit_button_2')));
    await tester.pumpAndSettle();

    await tester.enterText(find.byKey(const Key('name_field')), 'Mouse Pro');
    await tester.tap(find.byKey(const Key('save_product_button')));
    await tester.pumpAndSettle();

    expect(find.text('Mouse Pro'), findsOneWidget);

    await tester.tap(find.byKey(const ValueKey('delete_button_2')));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Excluir'));
    await tester.pumpAndSettle();

    expect(find.text('Mouse Pro'), findsNothing);
  });
}
