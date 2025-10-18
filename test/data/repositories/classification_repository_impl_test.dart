import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:whobird_flutter/data/datasources/location_service.dart';
import 'package:whobird_flutter/data/datasources/ml_service.dart';
import 'package:whobird_flutter/data/datasources/spectrogram_service.dart';
import 'package:whobird_flutter/data/repositories/classification_repository_impl.dart';
import 'package:whobird_flutter/domain/entities/audio_chunk.dart';
import 'package:whobird_flutter/domain/entities/classification.dart';
import 'dart:typed_data';

class MockMLService extends Mock implements MLService {}
class MockLocationService extends Mock implements LocationService {}
class MockSpectrogramService extends Mock implements SpectrogramService {}

void main() {
  late ClassificationRepositoryImpl repository;
  late MockMLService mockMLService;
  late MockLocationService mockLocationService;
  late MockSpectrogramService mockSpectrogramService;

  setUp(() {
    mockMLService = MockMLService();
    mockLocationService = MockLocationService();
    mockSpectrogramService = MockSpectrogramService();
    repository = ClassificationRepositoryImpl(
      mlService: mockMLService,
      locationService: mockLocationService,
      spectrogramService: mockSpectrogramService,
    );
  });

  final testAudioChunk = AudioChunk(buffer: Float32List(144000));
  final testSpectrogram = Float32List(128 * 298); // Example shape
  final testLocation = Location(latitude: 50.0, longitude: 10.0);
  final mainResults = [
    const Classification(label: 'Sparrow', score: 0.8),
    const Classification(label: 'Robin', score: 0.6),
  ];
  final metaScores = [0.9, 0.2]; // High score for Sparrow, low for Robin

  test('should orchestrate services and combine results', () async {
    // Arrange
    when(() => mockSpectrogramService.createSpectrogram(any())).thenReturn(testSpectrogram);
    when(() => mockLocationService.getCurrentLocation()).thenAnswer((_) async => testLocation);
    when(() => mockMLService.runInference(any())).thenAnswer((_) async => mainResults);
    when(() => mockMLService.runMetaInference(location: any(named: 'location'), weekOfYear: any(named: 'weekOfYear'))).thenAnswer((_) async => metaScores);
    when(() => mockMLService.labels).thenReturn(['Sparrow', 'Robin']);

    // Act
    final result = await repository.classifyAudio(testAudioChunk);

    // Assert
    verify(() => mockSpectrogramService.createSpectrogram(testAudioChunk)).called(1);
    verify(() => mockMLService.runInference(testSpectrogram)).called(1);
    verify(() => mockLocationService.getCurrentLocation()).called(1);
    verify(() => mockMLService.runMetaInference(location: testLocation, weekOfYear: any(named: 'weekOfYear'))).called(1);

    // Check if scores are combined correctly (0.8*0.5 + 0.9*0.5 = 0.85 for Sparrow)
    expect(result.first.label, 'Sparrow');
    expect(result.first.score, closeTo(0.85, 0.01));
  });
}