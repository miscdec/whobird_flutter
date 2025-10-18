import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mocktail/mocktail.dart';
import 'package:whobird_flutter/presentation/bloc/history/history_bloc.dart';
import 'package:whobird_flutter/presentation/screens/history_screen.dart';

// Mock BLoC for testing
class MockHistoryBloc extends Mock implements HistoryBloc {}

void main() {
  late MockHistoryBloc mockHistoryBloc;

  setUp(() {
    mockHistoryBloc = MockHistoryBloc();
  });

  Widget createWidgetUnderTest() {
    return MaterialApp(
      home: BlocProvider<HistoryBloc>.value(
        value: mockHistoryBloc,
        child: const HistoryScreen(),
      ),
    );
  }

  testWidgets('should display "No observations yet." when state is HistoryEmpty', (widgetTester) async {
    // Arrange
    when(() => mockHistoryBloc.state).thenReturn(HistoryEmpty());

    // Act
    await widgetTester.pumpWidget(createWidgetUnderTest());

    // Assert
    expect(find.text('No observations yet.'), findsOneWidget);
  });

  testWidgets('should display a loading indicator when state is HistoryLoading', (widgetTester) async {
    // Arrange
    when(() => mockHistoryBloc.state).thenReturn(HistoryLoading());

    // Act
    await widgetTester.pumpWidget(createWidgetUnderTest());

    // Assert
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });
}