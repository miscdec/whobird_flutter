import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:whobird_flutter/data/datasources/persistence_service.dart';
import 'package:whobird_flutter/domain/entities/bird_observation.dart' as domain;

void main() {
  late AppDatabase database;
  late DriftPersistenceService service;

  setUp(() {
    database = AppDatabase(executor: NativeDatabase.memory());
    service = DriftPersistenceService(database: database);
  });

  tearDown(() async {
    await database.close();
  });

  final testObservation = domain.BirdObservation(
    id: '1',
    commonName: 'House Sparrow',
    scientificName: 'Passer domesticus',
    latitude: 51.5,
    longitude: -0.12,
    confidence: 0.9,
    timestamp: DateTime.now(),
  );

  test('should save and retrieve an observation', () async {
    // Act
    await service.saveObservation(testObservation);
    final observations = await service.getObservations();

    // Assert
    expect(observations.length, 1);
    expect(observations.first.commonName, 'House Sparrow');
  });

  test('should clear all observations', () async {
    // Arrange
    await service.saveObservation(testObservation);
    await service.saveObservation(testObservation);

    // Act
    await service.clearHistory();
    final observations = await service.getObservations();

    // Assert
    expect(observations.isEmpty, isTrue);
  });
}