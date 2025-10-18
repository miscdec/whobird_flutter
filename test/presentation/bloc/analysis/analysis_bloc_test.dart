import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:whobird_flutter/core/usecases/usecase.dart';
import 'package:whobird_flutter/domain/entities/classification.dart';
import 'package:whobird_flutter/domain/usecases/start_real_time_analysis.dart';
import 'package:whobird_flutter/domain/usecases/stop_real_time_analysis.dart';
import 'package:whobird_flutter/presentation/bloc/analysis/analysis_bloc.dart';

class MockStartRealTimeAnalysis extends Mock implements StartRealTimeAnalysis {}

class MockStopRealTimeAnalysis extends Mock implements StopRealTimeAnalysis {}

void main() {
  late AnalysisBloc bloc;
  late MockStartRealTimeAnalysis mockStartRealTimeAnalysis;
  late MockStopRealTimeAnalysis mockStopRealTimeAnalysis;

  setUp(() {
    mockStartRealTimeAnalysis = MockStartRealTimeAnalysis();
    mockStopRealTimeAnalysis = MockStopRealTimeAnalysis();
    bloc = AnalysisBloc(
        startRealTimeAnalysis: mockStartRealTimeAnalysis,
        stopRealTimeAnalysis: mockStopRealTimeAnalysis
    );
  });

  tearDown(() {
    bloc.close();
  });

  test('initial state should be AnalysisInitial', () {
    expect(bloc.state, AnalysisInitial());
  });

  group('StartAnalysis', () {
    final testDetections = [const Classification(label: 'Sparrow', score: 0.9)];

    blocTest<AnalysisBloc, AnalysisState>(
      'should emit [AnalysisInProgress] when analysis starts successfully',
      build: () {
        when(() => mockStartRealTimeAnalysis(NoParams()))
            .thenAnswer((_) async => Stream.fromIterable([testDetections]));
        return bloc;
      },
      act: (bloc) => bloc.add(StartAnalysis()),
      expect: () => [
        const AnalysisInProgress([]),
        AnalysisInProgress(testDetections),
      ],
    );

    blocTest<AnalysisBloc, AnalysisState>(
      'should emit [AnalysisFailure] when analysis fails',
      build: () {
        when(() => mockStartRealTimeAnalysis(NoParams()))
            .thenAnswer((_) async => Stream.error(Exception('Test Error')));
        return bloc;
      },
      act: (bloc) => bloc.add(StartAnalysis()),
      expect: () => [
        const AnalysisInProgress([]),
        isA<AnalysisFailure>(),
      ],
    );
  });

  group('StopAnalysis', () {
    blocTest<AnalysisBloc, AnalysisState>(
      'should emit [AnalysisPaused] when analysis is stopped',
      build: () => bloc,
      act: (bloc) => bloc.add(StopAnalysis()),
      expect: () => [AnalysisPaused()],
    );
  });
}