// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'persistence_service.dart';

// **************************************************************************
// DriftDatabaseGenerator
// **************************************************************************

// ignore_for_file: type=lint
class BirdObservationsCompanion extends UpdateCompanion<BirdObservation> {
  final Value<int> id;
  final Value<String> commonName;
  final Value<String> scientificName;
  final Value<double> latitude;
  final Value<double> longitude;
  final Value<double> confidence;
  final Value<DateTime> timestamp;
  const BirdObservationsCompanion({
    this.id = const Value.absent(),
    this.commonName = const Value.absent(),
    this.scientificName = const Value.absent(),
    this.latitude = const Value.absent(),
    this.longitude = const Value.absent(),
    this.confidence = const Value.absent(),
    this.timestamp = const Value.absent(),
  });
  BirdObservationsCompanion.insert({
    this.id = const Value.absent(),
    required String commonName,
    required String scientificName,
    required double latitude,
    required double longitude,
    required double confidence,
    required DateTime timestamp,
  })  : commonName = Value(commonName),
        scientificName = Value(scientificName),
        latitude = Value(latitude),
        longitude = Value(longitude),
        confidence = Value(confidence),
        timestamp = Value(timestamp);
  static Insertable<BirdObservation> custom({
    Expression<int>? id,
    Expression<String>? commonName,
    Expression<String>? scientificName,
    Expression<double>? latitude,
    Expression<double>? longitude,
    Expression<double>? confidence,
    Expression<DateTime>? timestamp,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (commonName != null) 'common_name': commonName,
      if (scientificName != null) 'scientific_name': scientificName,
      if (latitude != null) 'latitude': latitude,
      if (longitude != null) 'longitude': longitude,
      if (confidence != null) 'confidence': confidence,
      if (timestamp != null) 'timestamp': timestamp,
    });
  }

  BirdObservationsCompanion copyWith(
      {Value<int>? id,
      Value<String>? commonName,
      Value<String>? scientificName,
      Value<double>? latitude,
      Value<double>? longitude,
      Value<double>? confidence,
      Value<DateTime>? timestamp}) {
    return BirdObservationsCompanion(
      id: id ?? this.id,
      commonName: commonName ?? this.commonName,
      scientificName: scientificName ?? this.scientificName,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      confidence: confidence ?? this.confidence,
      timestamp: timestamp ?? this.timestamp,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (commonName.present) {
      map['common_name'] = Variable<String>(commonName.value);
    }
    if (scientificName.present) {
      map['scientific_name'] = Variable<String>(scientificName.value);
    }
    if (latitude.present) {
      map['latitude'] = Variable<double>(latitude.value);
    }
    if (longitude.present) {
      map['longitude'] = Variable<double>(longitude.value);
    }
    if (confidence.present) {
      map['confidence'] = Variable<double>(confidence.value);
    }
    if (timestamp.present) {
      map['timestamp'] = Variable<DateTime>(timestamp.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('BirdObservationsCompanion(')
          ..write('id: $id, ')
          ..write('commonName: $commonName, ')
          ..write('scientificName: $scientificName, ')
          ..write('latitude: $latitude, ')
          ..write('longitude: $longitude, ')
          ..write('confidence: $confidence, ')
          ..write('timestamp: $timestamp')
          ..write(')'))
        .toString();
  }
}

class $BirdObservationsTable extends BirdObservations
    with TableInfo<$BirdObservationsTable, BirdObservation> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $BirdObservationsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _commonNameMeta =
      const VerificationMeta('commonName');
  @override
  late final GeneratedColumn<String> commonName = GeneratedColumn<String>(
      'common_name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _scientificNameMeta =
      const VerificationMeta('scientificName');
  @override
  late final GeneratedColumn<String> scientificName = GeneratedColumn<String>(
      'scientific_name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _latitudeMeta =
      const VerificationMeta('latitude');
  @override
  late final GeneratedColumn<double> latitude = GeneratedColumn<double>(
      'latitude', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _longitudeMeta =
      const VerificationMeta('longitude');
  @override
  late final GeneratedColumn<double> longitude = GeneratedColumn<double>(
      'longitude', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _confidenceMeta =
      const VerificationMeta('confidence');
  @override
  late final GeneratedColumn<double> confidence = GeneratedColumn<double>(
      'confidence', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _timestampMeta =
      const VerificationMeta('timestamp');
  @override
  late final GeneratedColumn<DateTime> timestamp = GeneratedColumn<DateTime>(
      'timestamp', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        commonName,
        scientificName,
        latitude,
        longitude,
        confidence,
        timestamp
      ];
  @override
  String get aliasedName => _alias ?? 'bird_observations';
  @override
  String get actualTableName => 'bird_observations';
  @override
  VerificationContext validateIntegrity(Insertable<BirdObservation> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('common_name')) {
      context.handle(
          _commonNameMeta,
          commonName.isAcceptableOrUnknown(
              data['common_name']!, _commonNameMeta));
    } else if (isInserting) {
      context.missing(_commonNameMeta);
    }
    if (data.containsKey('scientific_name')) {
      context.handle(
          _scientificNameMeta,
          scientificName.isAcceptableOrUnknown(
              data['scientific_name']!, _scientificNameMeta));
    } else if (isInserting) {
      context.missing(_scientificNameMeta);
    }
    if (data.containsKey('latitude')) {
      context.handle(_latitudeMeta,
          latitude.isAcceptableOrUnknown(data['latitude']!, _latitudeMeta));
    } else if (isInserting) {
      context.missing(_latitudeMeta);
    }
    if (data.containsKey('longitude')) {
      context.handle(_longitudeMeta,
          longitude.isAcceptableOrUnknown(data['longitude']!, _longitudeMeta));
    } else if (isInserting) {
      context.missing(_longitudeMeta);
    }
    if (data.containsKey('confidence')) {
      context.handle(
          _confidenceMeta,
          confidence.isAcceptableOrUnknown(
              data['confidence']!, _confidenceMeta));
    } else if (isInserting) {
      context.missing(_confidenceMeta);
    }
    if (data.containsKey('timestamp')) {
      context.handle(_timestampMeta,
          timestamp.isAcceptableOrUnknown(data['timestamp']!, _timestampMeta));
    } else if (isInserting) {
      context.missing(_timestampMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  BirdObservation map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return BirdObservation(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      commonName: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}common_name'])!,
      scientificName: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}scientific_name'])!,
      latitude: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}latitude'])!,
      longitude: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}longitude'])!,
      confidence: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}confidence'])!,
      timestamp: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}timestamp'])!,
    );
  }

  @override
  $BirdObservationsTable createAlias(String alias) {
    return $BirdObservationsTable(attachedDatabase, alias);
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  late final $BirdObservationsTable birdObservations =
      $BirdObservationsTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [birdObservations];
}