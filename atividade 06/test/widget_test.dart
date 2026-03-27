import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart' as provider;

import 'package:flutter_state_patterns/main.dart';
import 'package:flutter_state_patterns/state/provider/product_provider.dart';

void main() {
  testWidgets('Marca e desmarca produto como favorito', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      provider.ChangeNotifierProvider(
        create: (_) => ProductProvider(),
        child: const MyApp(),
      ),
    );

    expect(find.text('Produtos'), findsOneWidget);
    expect(find.text('Notebook'), findsOneWidget);
    expect(find.byIcon(Icons.star_border), findsNWidgets(4));

    await tester.tap(find.byIcon(Icons.star_border).first);
    await tester.pump();

    expect(find.byIcon(Icons.star), findsOneWidget);

    await tester.tap(find.byIcon(Icons.star).first);
    await tester.pump();

    expect(find.byIcon(Icons.star), findsNothing);
    expect(find.byIcon(Icons.star_border), findsNWidgets(4));
  });
}
