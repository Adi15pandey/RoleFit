// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:rolefit/main.dart';
import 'package:rolefit/bloc/rolefit_bloc.dart';

void main() {
  testWidgets('RoleFit app loads', (WidgetTester tester) async {
    await tester.pumpWidget(
      BlocProvider(
        create: (context) => RoleFitBloc(),
        child: const RoleFitApp(),
      ),
    );

    expect(find.text('RoleFit'), findsOneWidget);
  });
}
