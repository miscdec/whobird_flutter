import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:whobird_flutter/core/usecases/usecase.dart';
import 'package:whobird_flutter/domain/entities/bird_observation.dart';
import 'package:whobird_flutter/domain/usecases/clear_observation_history.dart';
import 'package:whobird_flutter/domain/usecases/get_observation_history.dart';
import 'package:whobird_flutter/presentation/bloc/history/history_bloc.dart';

class MockGetObservationHistory extends Mock implements GetObservationHistory {}
class MockClearObservationHistory extends Mock implements ClearObservationHistory {}

void main() {
  late HistoryBloc bloc;
  late MockGetObservationHistory mockGetObservationHistory;
  late MockClearObservationHistory mockClearObservationHistory;

  setUp(() {
    mockGetObservationHistory = MockGetObservationHistory();
    mockClearObservationHistory = MockClearObservationHistory();
    bloc = HistoryBloc(
      getObservationHistory: mockGetObservationHistory,
      clearObservationHistory: mockClearObservationHistory,
    );
  });

  final testObservation = BirdObservation(
    id: '1',
    commonName: 'House Sparrow',
    scientificName: 'Passer domesticus',
    latitude: 51.5,
    longitude: -0.12,
    confidence: 0.9,
    timestamp: DateTime.now(),
  );

  test('initial state should be HistoryInitial', () {
    expect(bloc.state, HistoryInitial());
  });

  group('LoadHistory', () {
    blocTest<HistoryBloc, HistoryState>(
      'should emit [HistoryLoading, HistoryLoaded] when data is gotten successfully',
      build: () {
        when(() => mockGetObservationHistory(NoParams())).thenAnswer((_) async => [testObservation]);
        return bloc;
      },
      act: (bloc) => bloc.add(LoadHistory()),
      expect: () => [
        HistoryLoading(),
        HistoryLoaded([testObservation]),
      ],
    );

    blocTest<HistoryBloc, HistoryState>(
      'should emit [HistoryLoading, HistoryEmpty] when there is no data',
      build: () {
        when(() => mockGetObservationHistory(NoParams())).thenAnswer((_) async => []);
        return bloc;
      },
      act: (bloc) => bloc.add(LoadHistory()),
      expect: () => [
        HistoryLoading(),
        HistoryEmpty(),
      ],
    );
  });

  group('ClearHistory', () {
    blocTest<HistoryBloc, HistoryState>(
      'should emit [HistoryLoading, HistoryEmpty] when history is cleared',
      build: () {
        when(() => mockClearObservationHistory(NoParams())).thenAnswer((_) async => Future.value());
        return bloc;
      },
      act: (bloc) => bloc.add(ClearHistory()),
      expect: () => [
        HistoryLoading(),
        HistoryEmpty(),
      ],
    );
  });
}