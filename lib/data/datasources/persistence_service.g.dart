// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'persistence_service.dart';

// ignore_for_file: type=lint
class $BirdObservationsTable extends BirdObservations
    with TableInfo<$BirdObservationsTable, BirdObservationTable> {
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
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'bird_observations';
  @override
  VerificationContext validateIntegrity(
      Insertable<BirdObservationTable> instance,
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
  BirdObservationTable map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return BirdObservationTable(
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

class BirdObservationTable extends DataClass
    implements Insertable<BirdObservationTable> {
  final int id;
  final String commonName;
  final String scientificName;
  final double latitude;
  final double longitude;
  final double confidence;
  final DateTime timestamp;
  const BirdObservationTable(
      {required this.id,
      required this.commonName,
      required this.scientificName,
      required this.latitude,
      required this.longitude,
      required this.confidence,
      required this.timestamp});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['common_name'] = Variable<String>(commonName);
    map['scientific_name'] = Variable<String>(scientificName);
    map['latitude'] = Variable<double>(latitude);
    map['longitude'] = Variable<double>(longitude);
    map['confidence'] = Variable<double>(confidence);
    map['timestamp'] = Variable<DateTime>(timestamp);
    return map;
  }

  BirdObservationsCompanion toCompanion(bool nullToAbsent) {
    return BirdObservationsCompanion(
      id: Value(id),
      commonName: Value(commonName),
      scientificName: Value(scientificName),
      latitude: Value(latitude),
      longitude: Value(longitude),
      confidence: Value(confidence),
      timestamp: Value(timestamp),
    );
  }

  factory BirdObservationTable.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return BirdObservationTable(
      id: serializer.fromJson<int>(json['id']),
      commonName: serializer.fromJson<String>(json['commonName']),
      scientificName: serializer.fromJson<String>(json['scientificName']),
      latitude: serializer.fromJson<double>(json['latitude']),
      longitude: serializer.fromJson<double>(json['longitude']),
      confidence: serializer.fromJson<double>(json['confidence']),
      timestamp: serializer.fromJson<DateTime>(json['timestamp']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'commonName': serializer.toJson<String>(commonName),
      'scientificName': serializer.toJson<String>(scientificName),
      'latitude': serializer.toJson<double>(latitude),
      'longitude': serializer.toJson<double>(longitude),
      'confidence': serializer.toJson<double>(confidence),
      'timestamp': serializer.toJson<DateTime>(timestamp),
    };
  }

  BirdObservationTable copyWith(
          {int? id,
          String? commonName,
          String? scientificName,
          double? latitude,
          double? longitude,
          double? confidence,
          DateTime? timestamp}) =>
      BirdObservationTable(
        id: id ?? this.id,
        commonName: commonName ?? this.commonName,
        scientificName: scientificName ?? this.scientificName,
        latitude: latitude ?? this.latitude,
        longitude: longitude ?? this.longitude,
        confidence: confidence ?? this.confidence,
        timestamp: timestamp ?? this.timestamp,
      );
  BirdObservationTable copyWithCompanion(BirdObservationsCompanion data) {
    return BirdObservationTable(
      id: data.id.present ? data.id.value : this.id,
      commonName:
          data.commonName.present ? data.commonName.value : this.commonName,
      scientificName: data.scientificName.present
          ? data.scientificName.value
          : this.scientificName,
      latitude: data.latitude.present ? data.latitude.value : this.latitude,
      longitude: data.longitude.present ? data.longitude.value : this.longitude,
      confidence:
          data.confidence.present ? data.confidence.value : this.confidence,
      timestamp: data.timestamp.present ? data.timestamp.value : this.timestamp,
    );
  }

  @override
  String toString() {
    return (StringBuffer('BirdObservationTable(')
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

  @override
  int get hashCode => Object.hash(id, commonName, scientificName, latitude,
      longitude, confidence, timestamp);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is BirdObservationTable &&
          other.id == this.id &&
          other.commonName == this.commonName &&
          other.scientificName == this.scientificName &&
          other.latitude == this.latitude &&
          other.longitude == this.longitude &&
          other.confidence == this.confidence &&
          other.timestamp == this.timestamp);
}

class BirdObservationsCompanion extends UpdateCompanion<BirdObservationTable> {
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
  static Insertable<BirdObservationTable> custom({
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

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $BirdObservationsTable birdObservations =
      $BirdObservationsTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [birdObservations];
}

typedef $$BirdObservationsTableCreateCompanionBuilder
    = BirdObservationsCompanion Function({
  Value<int> id,
  required String commonName,
  required String scientificName,
  required double latitude,
  required double longitude,
  required double confidence,
  required DateTime timestamp,
});
typedef $$BirdObservationsTableUpdateCompanionBuilder
    = BirdObservationsCompanion Function({
  Value<int> id,
  Value<String> commonName,
  Value<String> scientificName,
  Value<double> latitude,
  Value<double> longitude,
  Value<double> confidence,
  Value<DateTime> timestamp,
});

class $$BirdObservationsTableFilterComposer
    extends Composer<_$AppDatabase, $BirdObservationsTable> {
  $$BirdObservationsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get commonName => $composableBuilder(
      column: $table.commonName, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get scientificName => $composableBuilder(
      column: $table.scientificName,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get latitude => $composableBuilder(
      column: $table.latitude, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get longitude => $composableBuilder(
      column: $table.longitude, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get confidence => $composableBuilder(
      column: $table.confidence, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get timestamp => $composableBuilder(
      column: $table.timestamp, builder: (column) => ColumnFilters(column));
}

class $$BirdObservationsTableOrderingComposer
    extends Composer<_$AppDatabase, $BirdObservationsTable> {
  $$BirdObservationsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get commonName => $composableBuilder(
      column: $table.commonName, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get scientificName => $composableBuilder(
      column: $table.scientificName,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get latitude => $composableBuilder(
      column: $table.latitude, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get longitude => $composableBuilder(
      column: $table.longitude, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get confidence => $composableBuilder(
      column: $table.confidence, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get timestamp => $composableBuilder(
      column: $table.timestamp, builder: (column) => ColumnOrderings(column));
}

class $$BirdObservationsTableAnnotationComposer
    extends Composer<_$AppDatabase, $BirdObservationsTable> {
  $$BirdObservationsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get commonName => $composableBuilder(
      column: $table.commonName, builder: (column) => column);

  GeneratedColumn<String> get scientificName => $composableBuilder(
      column: $table.scientificName, builder: (column) => column);

  GeneratedColumn<double> get latitude =>
      $composableBuilder(column: $table.latitude, builder: (column) => column);

  GeneratedColumn<double> get longitude =>
      $composableBuilder(column: $table.longitude, builder: (column) => column);

  GeneratedColumn<double> get confidence => $composableBuilder(
      column: $table.confidence, builder: (column) => column);

  GeneratedColumn<DateTime> get timestamp =>
      $composableBuilder(column: $table.timestamp, builder: (column) => column);
}

class $$BirdObservationsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $BirdObservationsTable,
    BirdObservationTable,
    $$BirdObservationsTableFilterComposer,
    $$BirdObservationsTableOrderingComposer,
    $$BirdObservationsTableAnnotationComposer,
    $$BirdObservationsTableCreateCompanionBuilder,
    $$BirdObservationsTableUpdateCompanionBuilder,
    (
      BirdObservationTable,
      BaseReferences<_$AppDatabase, $BirdObservationsTable,
          BirdObservationTable>
    ),
    BirdObservationTable,
    PrefetchHooks Function()> {
  $$BirdObservationsTableTableManager(
      _$AppDatabase db, $BirdObservationsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$BirdObservationsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$BirdObservationsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$BirdObservationsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> commonName = const Value.absent(),
            Value<String> scientificName = const Value.absent(),
            Value<double> latitude = const Value.absent(),
            Value<double> longitude = const Value.absent(),
            Value<double> confidence = const Value.absent(),
            Value<DateTime> timestamp = const Value.absent(),
          }) =>
              BirdObservationsCompanion(
            id: id,
            commonName: commonName,
            scientificName: scientificName,
            latitude: latitude,
            longitude: longitude,
            confidence: confidence,
            timestamp: timestamp,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required String commonName,
            required String scientificName,
            required double latitude,
            required double longitude,
            required double confidence,
            required DateTime timestamp,
          }) =>
              BirdObservationsCompanion.insert(
            id: id,
            commonName: commonName,
            scientificName: scientificName,
            latitude: latitude,
            longitude: longitude,
            confidence: confidence,
            timestamp: timestamp,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$BirdObservationsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $BirdObservationsTable,
    BirdObservationTable,
    $$BirdObservationsTableFilterComposer,
    $$BirdObservationsTableOrderingComposer,
    $$BirdObservationsTableAnnotationComposer,
    $$BirdObservationsTableCreateCompanionBuilder,
    $$BirdObservationsTableUpdateCompanionBuilder,
    (
      BirdObservationTable,
      BaseReferences<_$AppDatabase, $BirdObservationsTable,
          BirdObservationTable>
    ),
    BirdObservationTable,
    PrefetchHooks Function()>;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$BirdObservationsTableTableManager get birdObservations =>
      $$BirdObservationsTableTableManager(_db, _db.birdObservations);
}
