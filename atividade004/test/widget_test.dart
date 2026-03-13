// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter_test/flutter_test.dart';

import 'package:atividade004/main.dart';
import 'package:atividade004/domain/entities/product.dart';
import 'package:atividade004/domain/repositories/product_repository.dart';
import 'package:atividade004/domain/usecases/get_products.dart';

class _FakeProductRepository implements ProductRepository {
  @override
  Future<List<Product>> getProducts() async => const <Product>[];
}

void main() {
  testWidgets('Shows products screen', (WidgetTester tester) async {
    await tester.pumpWidget(
      MyApp(getProducts: GetProducts(_FakeProductRepository())),
    );

    expect(find.text('Produtos'), findsOneWidget);

    await tester.pumpAndSettle();
    expect(find.text('Produtos'), findsOneWidget);
  });
}
