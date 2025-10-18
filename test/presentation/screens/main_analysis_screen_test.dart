import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mocktail/mocktail.dart';
import 'package:whobird_flutter/presentation/bloc/analysis/analysis_bloc.dart';
import 'package:whobird_flutter/presentation/screens/main_analysis_screen.dart';

// Mock BLoC for testing
class MockAnalysisBloc extends Mock implements AnalysisBloc {}

void main() {
  late MockAnalysisBloc mockAnalysisBloc;

  setUp(() {
    mockAnalysisBloc = MockAnalysisBloc();
  });

  Widget createWidgetUnderTest() {
    return MaterialApp(
      home: BlocProvider<AnalysisBloc>.value(
        value: mockAnalysisBloc,
        child: const MainAnalysisScreen(),
      ),
    );
  }

  testWidgets('should display "Start Analysis" button when state is AnalysisInitial', (widgetTester) async {
    // Arrange
    when(() => mockAnalysisBloc.state).thenReturn(AnalysisInitial());

    // Act
    await widgetTester.pumpWidget(createWidgetUnderTest());

    // Assert
    expect(find.text('Start Analysis'), findsOneWidget);
    expect(find.byIcon(Icons.mic), findsOneWidget);
  });

  testWidgets('should display "Listening..." when state is AnalysisInProgress with no detections', (widgetTester) async {
    // Arrange
    when(() => mockAnalysisBloc.state).thenReturn(const AnalysisInProgress([]));

    // Act
    await widgetTester.pumpWidget(createWidgetUnderTest());

    // Assert
    expect(find.text('Listening...'), findsOneWidget);
    expect(find.text('Stop'), findsOneWidget);
    expect(find.byIcon(Icons.stop), findsOneWidget);
  });
}