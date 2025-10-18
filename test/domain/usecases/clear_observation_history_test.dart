import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:whobird_flutter/core/usecases/usecase.dart';
import 'package:whobird_flutter/domain/repositories/observation_history_repository.dart';
import 'package:whobird_flutter/domain/usecases/clear_observation_history.dart';

class MockObservationHistoryRepository extends Mock
    implements ObservationHistoryRepository {}

void main() {
  late ClearObservationHistory usecase;
  late MockObservationHistoryRepository mockObservationHistoryRepository;

  setUp(() {
    mockObservationHistoryRepository = MockObservationHistoryRepository();
    usecase = ClearObservationHistory(mockObservationHistoryRepository);
  });

  test('should call clearHistory on the repository', () async {
    // Arrange
    when(() => mockObservationHistoryRepository.clearHistory())
        .thenAnswer((_) async => Future.value());

    // Act
    await usecase(NoParams());

    // Assert
    verify(() => mockObservationHistoryRepository.clearHistory()).called(1);
    verifyNoMoreInteractions(mockObservationHistoryRepository);
  });
}