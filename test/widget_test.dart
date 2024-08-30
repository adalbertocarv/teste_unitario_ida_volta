import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:teste_unitario_idavolta/main.dart';

void main() {
  testWidgets('Lista de percursos é exibida', (WidgetTester tester) async {
    // Construa nosso app e dispare um frame.
    await tester.pumpWidget(MyApp());

    // Verifique se há um CircularProgressIndicator enquanto os dados estão sendo carregados.
    expect(find.byType(CircularProgressIndicator), findsOneWidget);

    // Aguarde a conclusão do Future.
    await tester.pumpAndSettle();

    // Verifique se pelo menos um ListTile está presente na lista (indicando que percursos foram carregados).
    expect(find.byType(ListTile), findsWidgets);
  });
}
