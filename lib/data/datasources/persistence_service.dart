import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
import 'package:whobird_flutter/domain/entities/bird_observation.dart' as domain;

part 'persistence_service.g.dart';

// --- 1. Define Table Structure ---
@DataClassName('BirdObservation')
class BirdObservations extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get commonName => text()();
  TextColumn get scientificName => text()();
  RealColumn get latitude => real()();
  RealColumn get longitude => real()();
  RealColumn get confidence => real()();
  DateTimeColumn get timestamp => dateTime()();
}

// --- 2. Define AppDatabase Class ---
@DriftDatabase(tables: [BirdObservations])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 1;
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'db.sqlite'));
    return NativeDatabase.createInBackground(file);
  });
}

// --- 3. Define PersistenceService Interface ---
abstract class PersistenceService {
  Future<void> saveObservation(domain.BirdObservation observation);
  Future<List<domain.BirdObservation>> getObservations();
  Future<void> clearHistory();
}

// --- 4. Define DriftPersistenceService Implementation ---
class DriftPersistenceService implements PersistenceService {
  final AppDatabase database;

  DriftPersistenceService({required this.database});

  @override
  Future<void> saveObservation(domain.BirdObservation observation) {
    return database.into(database.birdObservations).insert(
          BirdObservationsCompanion.insert(
            commonName: observation.commonName,
            scientificName: observation.scientificName,
            latitude: observation.latitude,
            longitude: observation.longitude,
            confidence: observation.confidence,
            timestamp: observation.timestamp,
          ),
        );
  }

  @override
  Future<List<domain.BirdObservation>> getObservations() async {
    final results = await database.select(database.birdObservations).get();
    return results.map((row) {
      return domain.BirdObservation(
        id: row.id.toString(),
        commonName: row.commonName,
        scientificName: row.scientificName,
        latitude: row.latitude,
        longitude: row.longitude,
        confidence: row.confidence,
        timestamp: row.timestamp,
      );
    }).toList();
  }

  @override
  Future<void> clearHistory() {
    return database.delete(database.birdObservations).go();
  }
}