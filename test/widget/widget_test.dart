import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../lib/main.dart';
import '../../lib/pages/budget.dart';

void main() {
  Widget makeTestableWidget({Widget child}) {
    return MaterialApp(
      home: child,
    );
  }

  testWidgets('Budget test', (WidgetTester tester) async {
    BudgetPage budgetPage = BudgetPage();
    await tester.pumpWidget(makeTestableWidget(child: budgetPage));

    await  tester.tap(find.byKey(Key('saveNewCategorie')));
  });

  testWidgets('description', (WidgetTester tester) async {
    await tester.pumpWidget(new MyApp());

    expect(find.text('0'), findsOneWidget);
    expect(find.text('1'), findsNothing);

    await tester.tap(find.byIcon(Icons.add));
    await tester.pump();

    expect(find.text('0'), findsNothing);
    expect(find.text('1'), findsOneWidget);
  });
}
