import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart' as provider;

import 'package:flutter_state_patterns/domain/models/product.dart';
import 'package:flutter_state_patterns/main.dart';
import 'package:flutter_state_patterns/state/provider/product_provider.dart';

void main() {
  testWidgets('Navega da tela inicial ate produtos e marca favorito', (
    WidgetTester tester,
  ) async {
    final fakeProducts = [
      Product(
        id: 1,
        title: 'Notebook',
        price: 3500,
        description: 'Descricao de teste',
        image: 'https://fakestoreapi.com/img/test.png',
      ),
    ];

    await tester.pumpWidget(
      provider.ChangeNotifierProvider(
        create: (_) => ProductProvider(initialProducts: fakeProducts),
        child: const MyApp(),
      ),
    );

    expect(find.text('Tela Inicial'), findsOneWidget);

    await tester.tap(find.text('Ver produtos'));
    await tester.pumpAndSettle();

    expect(find.text('Produtos'), findsOneWidget);
    expect(find.text('Notebook'), findsOneWidget);
    expect(find.byIcon(Icons.star_border), findsOneWidget);

    await tester.tap(find.byIcon(Icons.star_border).first);
    await tester.pump();

    expect(find.byIcon(Icons.star), findsOneWidget);

    await tester.tap(find.byIcon(Icons.star).first);
    await tester.pump();

    expect(find.byIcon(Icons.star), findsNothing);
    expect(find.byIcon(Icons.star_border), findsOneWidget);
  });
}
