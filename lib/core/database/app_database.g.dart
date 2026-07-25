// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $GajiTableTable extends GajiTable
    with TableInfo<$GajiTableTable, GajiTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $GajiTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _jumlahMeta = const VerificationMeta('jumlah');
  @override
  late final GeneratedColumn<double> jumlah = GeneratedColumn<double>(
    'jumlah',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _jumlahBebasMeta = const VerificationMeta(
    'jumlahBebas',
  );
  @override
  late final GeneratedColumn<double> jumlahBebas = GeneratedColumn<double>(
    'jumlah_bebas',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _tanggalMeta = const VerificationMeta(
    'tanggal',
  );
  @override
  late final GeneratedColumn<DateTime> tanggal = GeneratedColumn<DateTime>(
    'tanggal',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _catatanMeta = const VerificationMeta(
    'catatan',
  );
  @override
  late final GeneratedColumn<String> catatan = GeneratedColumn<String>(
    'catatan',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _isSyncedMeta = const VerificationMeta(
    'isSynced',
  );
  @override
  late final GeneratedColumn<bool> isSynced = GeneratedColumn<bool>(
    'is_synced',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_synced" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _isDeletedMeta = const VerificationMeta(
    'isDeleted',
  );
  @override
  late final GeneratedColumn<bool> isDeleted = GeneratedColumn<bool>(
    'is_deleted',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_deleted" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    jumlah,
    jumlahBebas,
    tanggal,
    catatan,
    updatedAt,
    isSynced,
    isDeleted,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'gaji_table';
  @override
  VerificationContext validateIntegrity(
    Insertable<GajiTableData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('jumlah')) {
      context.handle(
        _jumlahMeta,
        jumlah.isAcceptableOrUnknown(data['jumlah']!, _jumlahMeta),
      );
    } else if (isInserting) {
      context.missing(_jumlahMeta);
    }
    if (data.containsKey('jumlah_bebas')) {
      context.handle(
        _jumlahBebasMeta,
        jumlahBebas.isAcceptableOrUnknown(
          data['jumlah_bebas']!,
          _jumlahBebasMeta,
        ),
      );
    }
    if (data.containsKey('tanggal')) {
      context.handle(
        _tanggalMeta,
        tanggal.isAcceptableOrUnknown(data['tanggal']!, _tanggalMeta),
      );
    } else if (isInserting) {
      context.missing(_tanggalMeta);
    }
    if (data.containsKey('catatan')) {
      context.handle(
        _catatanMeta,
        catatan.isAcceptableOrUnknown(data['catatan']!, _catatanMeta),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    if (data.containsKey('is_synced')) {
      context.handle(
        _isSyncedMeta,
        isSynced.isAcceptableOrUnknown(data['is_synced']!, _isSyncedMeta),
      );
    }
    if (data.containsKey('is_deleted')) {
      context.handle(
        _isDeletedMeta,
        isDeleted.isAcceptableOrUnknown(data['is_deleted']!, _isDeletedMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  GajiTableData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return GajiTableData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      jumlah: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}jumlah'],
      )!,
      jumlahBebas: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}jumlah_bebas'],
      ),
      tanggal: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}tanggal'],
      )!,
      catatan: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}catatan'],
      ),
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
      isSynced: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_synced'],
      )!,
      isDeleted: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_deleted'],
      )!,
    );
  }

  @override
  $GajiTableTable createAlias(String alias) {
    return $GajiTableTable(attachedDatabase, alias);
  }
}

class GajiTableData extends DataClass implements Insertable<GajiTableData> {
  final String id;
  final double jumlah;
  final double? jumlahBebas;
  final DateTime tanggal;
  final String? catatan;
  final DateTime updatedAt;
  final bool isSynced;
  final bool isDeleted;
  const GajiTableData({
    required this.id,
    required this.jumlah,
    this.jumlahBebas,
    required this.tanggal,
    this.catatan,
    required this.updatedAt,
    required this.isSynced,
    required this.isDeleted,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['jumlah'] = Variable<double>(jumlah);
    if (!nullToAbsent || jumlahBebas != null) {
      map['jumlah_bebas'] = Variable<double>(jumlahBebas);
    }
    map['tanggal'] = Variable<DateTime>(tanggal);
    if (!nullToAbsent || catatan != null) {
      map['catatan'] = Variable<String>(catatan);
    }
    map['updated_at'] = Variable<DateTime>(updatedAt);
    map['is_synced'] = Variable<bool>(isSynced);
    map['is_deleted'] = Variable<bool>(isDeleted);
    return map;
  }

  GajiTableCompanion toCompanion(bool nullToAbsent) {
    return GajiTableCompanion(
      id: Value(id),
      jumlah: Value(jumlah),
      jumlahBebas: jumlahBebas == null && nullToAbsent
          ? const Value.absent()
          : Value(jumlahBebas),
      tanggal: Value(tanggal),
      catatan: catatan == null && nullToAbsent
          ? const Value.absent()
          : Value(catatan),
      updatedAt: Value(updatedAt),
      isSynced: Value(isSynced),
      isDeleted: Value(isDeleted),
    );
  }

  factory GajiTableData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return GajiTableData(
      id: serializer.fromJson<String>(json['id']),
      jumlah: serializer.fromJson<double>(json['jumlah']),
      jumlahBebas: serializer.fromJson<double?>(json['jumlahBebas']),
      tanggal: serializer.fromJson<DateTime>(json['tanggal']),
      catatan: serializer.fromJson<String?>(json['catatan']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
      isSynced: serializer.fromJson<bool>(json['isSynced']),
      isDeleted: serializer.fromJson<bool>(json['isDeleted']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'jumlah': serializer.toJson<double>(jumlah),
      'jumlahBebas': serializer.toJson<double?>(jumlahBebas),
      'tanggal': serializer.toJson<DateTime>(tanggal),
      'catatan': serializer.toJson<String?>(catatan),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
      'isSynced': serializer.toJson<bool>(isSynced),
      'isDeleted': serializer.toJson<bool>(isDeleted),
    };
  }

  GajiTableData copyWith({
    String? id,
    double? jumlah,
    Value<double?> jumlahBebas = const Value.absent(),
    DateTime? tanggal,
    Value<String?> catatan = const Value.absent(),
    DateTime? updatedAt,
    bool? isSynced,
    bool? isDeleted,
  }) => GajiTableData(
    id: id ?? this.id,
    jumlah: jumlah ?? this.jumlah,
    jumlahBebas: jumlahBebas.present ? jumlahBebas.value : this.jumlahBebas,
    tanggal: tanggal ?? this.tanggal,
    catatan: catatan.present ? catatan.value : this.catatan,
    updatedAt: updatedAt ?? this.updatedAt,
    isSynced: isSynced ?? this.isSynced,
    isDeleted: isDeleted ?? this.isDeleted,
  );
  GajiTableData copyWithCompanion(GajiTableCompanion data) {
    return GajiTableData(
      id: data.id.present ? data.id.value : this.id,
      jumlah: data.jumlah.present ? data.jumlah.value : this.jumlah,
      jumlahBebas: data.jumlahBebas.present
          ? data.jumlahBebas.value
          : this.jumlahBebas,
      tanggal: data.tanggal.present ? data.tanggal.value : this.tanggal,
      catatan: data.catatan.present ? data.catatan.value : this.catatan,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      isSynced: data.isSynced.present ? data.isSynced.value : this.isSynced,
      isDeleted: data.isDeleted.present ? data.isDeleted.value : this.isDeleted,
    );
  }

  @override
  String toString() {
    return (StringBuffer('GajiTableData(')
          ..write('id: $id, ')
          ..write('jumlah: $jumlah, ')
          ..write('jumlahBebas: $jumlahBebas, ')
          ..write('tanggal: $tanggal, ')
          ..write('catatan: $catatan, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('isSynced: $isSynced, ')
          ..write('isDeleted: $isDeleted')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    jumlah,
    jumlahBebas,
    tanggal,
    catatan,
    updatedAt,
    isSynced,
    isDeleted,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is GajiTableData &&
          other.id == this.id &&
          other.jumlah == this.jumlah &&
          other.jumlahBebas == this.jumlahBebas &&
          other.tanggal == this.tanggal &&
          other.catatan == this.catatan &&
          other.updatedAt == this.updatedAt &&
          other.isSynced == this.isSynced &&
          other.isDeleted == this.isDeleted);
}

class GajiTableCompanion extends UpdateCompanion<GajiTableData> {
  final Value<String> id;
  final Value<double> jumlah;
  final Value<double?> jumlahBebas;
  final Value<DateTime> tanggal;
  final Value<String?> catatan;
  final Value<DateTime> updatedAt;
  final Value<bool> isSynced;
  final Value<bool> isDeleted;
  final Value<int> rowid;
  const GajiTableCompanion({
    this.id = const Value.absent(),
    this.jumlah = const Value.absent(),
    this.jumlahBebas = const Value.absent(),
    this.tanggal = const Value.absent(),
    this.catatan = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.isSynced = const Value.absent(),
    this.isDeleted = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  GajiTableCompanion.insert({
    required String id,
    required double jumlah,
    this.jumlahBebas = const Value.absent(),
    required DateTime tanggal,
    this.catatan = const Value.absent(),
    required DateTime updatedAt,
    this.isSynced = const Value.absent(),
    this.isDeleted = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       jumlah = Value(jumlah),
       tanggal = Value(tanggal),
       updatedAt = Value(updatedAt);
  static Insertable<GajiTableData> custom({
    Expression<String>? id,
    Expression<double>? jumlah,
    Expression<double>? jumlahBebas,
    Expression<DateTime>? tanggal,
    Expression<String>? catatan,
    Expression<DateTime>? updatedAt,
    Expression<bool>? isSynced,
    Expression<bool>? isDeleted,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (jumlah != null) 'jumlah': jumlah,
      if (jumlahBebas != null) 'jumlah_bebas': jumlahBebas,
      if (tanggal != null) 'tanggal': tanggal,
      if (catatan != null) 'catatan': catatan,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (isSynced != null) 'is_synced': isSynced,
      if (isDeleted != null) 'is_deleted': isDeleted,
      if (rowid != null) 'rowid': rowid,
    });
  }

  GajiTableCompanion copyWith({
    Value<String>? id,
    Value<double>? jumlah,
    Value<double?>? jumlahBebas,
    Value<DateTime>? tanggal,
    Value<String?>? catatan,
    Value<DateTime>? updatedAt,
    Value<bool>? isSynced,
    Value<bool>? isDeleted,
    Value<int>? rowid,
  }) {
    return GajiTableCompanion(
      id: id ?? this.id,
      jumlah: jumlah ?? this.jumlah,
      jumlahBebas: jumlahBebas ?? this.jumlahBebas,
      tanggal: tanggal ?? this.tanggal,
      catatan: catatan ?? this.catatan,
      updatedAt: updatedAt ?? this.updatedAt,
      isSynced: isSynced ?? this.isSynced,
      isDeleted: isDeleted ?? this.isDeleted,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (jumlah.present) {
      map['jumlah'] = Variable<double>(jumlah.value);
    }
    if (jumlahBebas.present) {
      map['jumlah_bebas'] = Variable<double>(jumlahBebas.value);
    }
    if (tanggal.present) {
      map['tanggal'] = Variable<DateTime>(tanggal.value);
    }
    if (catatan.present) {
      map['catatan'] = Variable<String>(catatan.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (isSynced.present) {
      map['is_synced'] = Variable<bool>(isSynced.value);
    }
    if (isDeleted.present) {
      map['is_deleted'] = Variable<bool>(isDeleted.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('GajiTableCompanion(')
          ..write('id: $id, ')
          ..write('jumlah: $jumlah, ')
          ..write('jumlahBebas: $jumlahBebas, ')
          ..write('tanggal: $tanggal, ')
          ..write('catatan: $catatan, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('isSynced: $isSynced, ')
          ..write('isDeleted: $isDeleted, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $PengeluaranTableTable extends PengeluaranTable
    with TableInfo<$PengeluaranTableTable, PengeluaranTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PengeluaranTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _jumlahMeta = const VerificationMeta('jumlah');
  @override
  late final GeneratedColumn<double> jumlah = GeneratedColumn<double>(
    'jumlah',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _kategoriIdMeta = const VerificationMeta(
    'kategoriId',
  );
  @override
  late final GeneratedColumn<String> kategoriId = GeneratedColumn<String>(
    'kategori_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _tanggalMeta = const VerificationMeta(
    'tanggal',
  );
  @override
  late final GeneratedColumn<DateTime> tanggal = GeneratedColumn<DateTime>(
    'tanggal',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _catatanMeta = const VerificationMeta(
    'catatan',
  );
  @override
  late final GeneratedColumn<String> catatan = GeneratedColumn<String>(
    'catatan',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _utangIdMeta = const VerificationMeta(
    'utangId',
  );
  @override
  late final GeneratedColumn<String> utangId = GeneratedColumn<String>(
    'utang_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _isSyncedMeta = const VerificationMeta(
    'isSynced',
  );
  @override
  late final GeneratedColumn<bool> isSynced = GeneratedColumn<bool>(
    'is_synced',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_synced" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _isDeletedMeta = const VerificationMeta(
    'isDeleted',
  );
  @override
  late final GeneratedColumn<bool> isDeleted = GeneratedColumn<bool>(
    'is_deleted',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_deleted" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    jumlah,
    kategoriId,
    tanggal,
    catatan,
    utangId,
    updatedAt,
    isSynced,
    isDeleted,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'pengeluaran_table';
  @override
  VerificationContext validateIntegrity(
    Insertable<PengeluaranTableData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('jumlah')) {
      context.handle(
        _jumlahMeta,
        jumlah.isAcceptableOrUnknown(data['jumlah']!, _jumlahMeta),
      );
    } else if (isInserting) {
      context.missing(_jumlahMeta);
    }
    if (data.containsKey('kategori_id')) {
      context.handle(
        _kategoriIdMeta,
        kategoriId.isAcceptableOrUnknown(data['kategori_id']!, _kategoriIdMeta),
      );
    } else if (isInserting) {
      context.missing(_kategoriIdMeta);
    }
    if (data.containsKey('tanggal')) {
      context.handle(
        _tanggalMeta,
        tanggal.isAcceptableOrUnknown(data['tanggal']!, _tanggalMeta),
      );
    } else if (isInserting) {
      context.missing(_tanggalMeta);
    }
    if (data.containsKey('catatan')) {
      context.handle(
        _catatanMeta,
        catatan.isAcceptableOrUnknown(data['catatan']!, _catatanMeta),
      );
    }
    if (data.containsKey('utang_id')) {
      context.handle(
        _utangIdMeta,
        utangId.isAcceptableOrUnknown(data['utang_id']!, _utangIdMeta),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    if (data.containsKey('is_synced')) {
      context.handle(
        _isSyncedMeta,
        isSynced.isAcceptableOrUnknown(data['is_synced']!, _isSyncedMeta),
      );
    }
    if (data.containsKey('is_deleted')) {
      context.handle(
        _isDeletedMeta,
        isDeleted.isAcceptableOrUnknown(data['is_deleted']!, _isDeletedMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  PengeluaranTableData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return PengeluaranTableData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      jumlah: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}jumlah'],
      )!,
      kategoriId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}kategori_id'],
      )!,
      tanggal: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}tanggal'],
      )!,
      catatan: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}catatan'],
      ),
      utangId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}utang_id'],
      ),
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
      isSynced: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_synced'],
      )!,
      isDeleted: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_deleted'],
      )!,
    );
  }

  @override
  $PengeluaranTableTable createAlias(String alias) {
    return $PengeluaranTableTable(attachedDatabase, alias);
  }
}

class PengeluaranTableData extends DataClass
    implements Insertable<PengeluaranTableData> {
  final String id;
  final double jumlah;
  final String kategoriId;
  final DateTime tanggal;
  final String? catatan;
  final String? utangId;
  final DateTime updatedAt;
  final bool isSynced;
  final bool isDeleted;
  const PengeluaranTableData({
    required this.id,
    required this.jumlah,
    required this.kategoriId,
    required this.tanggal,
    this.catatan,
    this.utangId,
    required this.updatedAt,
    required this.isSynced,
    required this.isDeleted,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['jumlah'] = Variable<double>(jumlah);
    map['kategori_id'] = Variable<String>(kategoriId);
    map['tanggal'] = Variable<DateTime>(tanggal);
    if (!nullToAbsent || catatan != null) {
      map['catatan'] = Variable<String>(catatan);
    }
    if (!nullToAbsent || utangId != null) {
      map['utang_id'] = Variable<String>(utangId);
    }
    map['updated_at'] = Variable<DateTime>(updatedAt);
    map['is_synced'] = Variable<bool>(isSynced);
    map['is_deleted'] = Variable<bool>(isDeleted);
    return map;
  }

  PengeluaranTableCompanion toCompanion(bool nullToAbsent) {
    return PengeluaranTableCompanion(
      id: Value(id),
      jumlah: Value(jumlah),
      kategoriId: Value(kategoriId),
      tanggal: Value(tanggal),
      catatan: catatan == null && nullToAbsent
          ? const Value.absent()
          : Value(catatan),
      utangId: utangId == null && nullToAbsent
          ? const Value.absent()
          : Value(utangId),
      updatedAt: Value(updatedAt),
      isSynced: Value(isSynced),
      isDeleted: Value(isDeleted),
    );
  }

  factory PengeluaranTableData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return PengeluaranTableData(
      id: serializer.fromJson<String>(json['id']),
      jumlah: serializer.fromJson<double>(json['jumlah']),
      kategoriId: serializer.fromJson<String>(json['kategoriId']),
      tanggal: serializer.fromJson<DateTime>(json['tanggal']),
      catatan: serializer.fromJson<String?>(json['catatan']),
      utangId: serializer.fromJson<String?>(json['utangId']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
      isSynced: serializer.fromJson<bool>(json['isSynced']),
      isDeleted: serializer.fromJson<bool>(json['isDeleted']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'jumlah': serializer.toJson<double>(jumlah),
      'kategoriId': serializer.toJson<String>(kategoriId),
      'tanggal': serializer.toJson<DateTime>(tanggal),
      'catatan': serializer.toJson<String?>(catatan),
      'utangId': serializer.toJson<String?>(utangId),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
      'isSynced': serializer.toJson<bool>(isSynced),
      'isDeleted': serializer.toJson<bool>(isDeleted),
    };
  }

  PengeluaranTableData copyWith({
    String? id,
    double? jumlah,
    String? kategoriId,
    DateTime? tanggal,
    Value<String?> catatan = const Value.absent(),
    Value<String?> utangId = const Value.absent(),
    DateTime? updatedAt,
    bool? isSynced,
    bool? isDeleted,
  }) => PengeluaranTableData(
    id: id ?? this.id,
    jumlah: jumlah ?? this.jumlah,
    kategoriId: kategoriId ?? this.kategoriId,
    tanggal: tanggal ?? this.tanggal,
    catatan: catatan.present ? catatan.value : this.catatan,
    utangId: utangId.present ? utangId.value : this.utangId,
    updatedAt: updatedAt ?? this.updatedAt,
    isSynced: isSynced ?? this.isSynced,
    isDeleted: isDeleted ?? this.isDeleted,
  );
  PengeluaranTableData copyWithCompanion(PengeluaranTableCompanion data) {
    return PengeluaranTableData(
      id: data.id.present ? data.id.value : this.id,
      jumlah: data.jumlah.present ? data.jumlah.value : this.jumlah,
      kategoriId: data.kategoriId.present
          ? data.kategoriId.value
          : this.kategoriId,
      tanggal: data.tanggal.present ? data.tanggal.value : this.tanggal,
      catatan: data.catatan.present ? data.catatan.value : this.catatan,
      utangId: data.utangId.present ? data.utangId.value : this.utangId,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      isSynced: data.isSynced.present ? data.isSynced.value : this.isSynced,
      isDeleted: data.isDeleted.present ? data.isDeleted.value : this.isDeleted,
    );
  }

  @override
  String toString() {
    return (StringBuffer('PengeluaranTableData(')
          ..write('id: $id, ')
          ..write('jumlah: $jumlah, ')
          ..write('kategoriId: $kategoriId, ')
          ..write('tanggal: $tanggal, ')
          ..write('catatan: $catatan, ')
          ..write('utangId: $utangId, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('isSynced: $isSynced, ')
          ..write('isDeleted: $isDeleted')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    jumlah,
    kategoriId,
    tanggal,
    catatan,
    utangId,
    updatedAt,
    isSynced,
    isDeleted,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is PengeluaranTableData &&
          other.id == this.id &&
          other.jumlah == this.jumlah &&
          other.kategoriId == this.kategoriId &&
          other.tanggal == this.tanggal &&
          other.catatan == this.catatan &&
          other.utangId == this.utangId &&
          other.updatedAt == this.updatedAt &&
          other.isSynced == this.isSynced &&
          other.isDeleted == this.isDeleted);
}

class PengeluaranTableCompanion extends UpdateCompanion<PengeluaranTableData> {
  final Value<String> id;
  final Value<double> jumlah;
  final Value<String> kategoriId;
  final Value<DateTime> tanggal;
  final Value<String?> catatan;
  final Value<String?> utangId;
  final Value<DateTime> updatedAt;
  final Value<bool> isSynced;
  final Value<bool> isDeleted;
  final Value<int> rowid;
  const PengeluaranTableCompanion({
    this.id = const Value.absent(),
    this.jumlah = const Value.absent(),
    this.kategoriId = const Value.absent(),
    this.tanggal = const Value.absent(),
    this.catatan = const Value.absent(),
    this.utangId = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.isSynced = const Value.absent(),
    this.isDeleted = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  PengeluaranTableCompanion.insert({
    required String id,
    required double jumlah,
    required String kategoriId,
    required DateTime tanggal,
    this.catatan = const Value.absent(),
    this.utangId = const Value.absent(),
    required DateTime updatedAt,
    this.isSynced = const Value.absent(),
    this.isDeleted = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       jumlah = Value(jumlah),
       kategoriId = Value(kategoriId),
       tanggal = Value(tanggal),
       updatedAt = Value(updatedAt);
  static Insertable<PengeluaranTableData> custom({
    Expression<String>? id,
    Expression<double>? jumlah,
    Expression<String>? kategoriId,
    Expression<DateTime>? tanggal,
    Expression<String>? catatan,
    Expression<String>? utangId,
    Expression<DateTime>? updatedAt,
    Expression<bool>? isSynced,
    Expression<bool>? isDeleted,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (jumlah != null) 'jumlah': jumlah,
      if (kategoriId != null) 'kategori_id': kategoriId,
      if (tanggal != null) 'tanggal': tanggal,
      if (catatan != null) 'catatan': catatan,
      if (utangId != null) 'utang_id': utangId,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (isSynced != null) 'is_synced': isSynced,
      if (isDeleted != null) 'is_deleted': isDeleted,
      if (rowid != null) 'rowid': rowid,
    });
  }

  PengeluaranTableCompanion copyWith({
    Value<String>? id,
    Value<double>? jumlah,
    Value<String>? kategoriId,
    Value<DateTime>? tanggal,
    Value<String?>? catatan,
    Value<String?>? utangId,
    Value<DateTime>? updatedAt,
    Value<bool>? isSynced,
    Value<bool>? isDeleted,
    Value<int>? rowid,
  }) {
    return PengeluaranTableCompanion(
      id: id ?? this.id,
      jumlah: jumlah ?? this.jumlah,
      kategoriId: kategoriId ?? this.kategoriId,
      tanggal: tanggal ?? this.tanggal,
      catatan: catatan ?? this.catatan,
      utangId: utangId ?? this.utangId,
      updatedAt: updatedAt ?? this.updatedAt,
      isSynced: isSynced ?? this.isSynced,
      isDeleted: isDeleted ?? this.isDeleted,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (jumlah.present) {
      map['jumlah'] = Variable<double>(jumlah.value);
    }
    if (kategoriId.present) {
      map['kategori_id'] = Variable<String>(kategoriId.value);
    }
    if (tanggal.present) {
      map['tanggal'] = Variable<DateTime>(tanggal.value);
    }
    if (catatan.present) {
      map['catatan'] = Variable<String>(catatan.value);
    }
    if (utangId.present) {
      map['utang_id'] = Variable<String>(utangId.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (isSynced.present) {
      map['is_synced'] = Variable<bool>(isSynced.value);
    }
    if (isDeleted.present) {
      map['is_deleted'] = Variable<bool>(isDeleted.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PengeluaranTableCompanion(')
          ..write('id: $id, ')
          ..write('jumlah: $jumlah, ')
          ..write('kategoriId: $kategoriId, ')
          ..write('tanggal: $tanggal, ')
          ..write('catatan: $catatan, ')
          ..write('utangId: $utangId, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('isSynced: $isSynced, ')
          ..write('isDeleted: $isDeleted, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $UtangTableTable extends UtangTable
    with TableInfo<$UtangTableTable, UtangTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $UtangTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _namaUtangMeta = const VerificationMeta(
    'namaUtang',
  );
  @override
  late final GeneratedColumn<String> namaUtang = GeneratedColumn<String>(
    'nama_utang',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _jumlahTotalMeta = const VerificationMeta(
    'jumlahTotal',
  );
  @override
  late final GeneratedColumn<double> jumlahTotal = GeneratedColumn<double>(
    'jumlah_total',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _jumlahTerbayarMeta = const VerificationMeta(
    'jumlahTerbayar',
  );
  @override
  late final GeneratedColumn<double> jumlahTerbayar = GeneratedColumn<double>(
    'jumlah_terbayar',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
    'status',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _jatuhTempoMeta = const VerificationMeta(
    'jatuhTempo',
  );
  @override
  late final GeneratedColumn<DateTime> jatuhTempo = GeneratedColumn<DateTime>(
    'jatuh_tempo',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _catatanMeta = const VerificationMeta(
    'catatan',
  );
  @override
  late final GeneratedColumn<String> catatan = GeneratedColumn<String>(
    'catatan',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _isSyncedMeta = const VerificationMeta(
    'isSynced',
  );
  @override
  late final GeneratedColumn<bool> isSynced = GeneratedColumn<bool>(
    'is_synced',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_synced" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _isDeletedMeta = const VerificationMeta(
    'isDeleted',
  );
  @override
  late final GeneratedColumn<bool> isDeleted = GeneratedColumn<bool>(
    'is_deleted',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_deleted" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    namaUtang,
    jumlahTotal,
    jumlahTerbayar,
    status,
    jatuhTempo,
    catatan,
    updatedAt,
    isSynced,
    isDeleted,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'utang_table';
  @override
  VerificationContext validateIntegrity(
    Insertable<UtangTableData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('nama_utang')) {
      context.handle(
        _namaUtangMeta,
        namaUtang.isAcceptableOrUnknown(data['nama_utang']!, _namaUtangMeta),
      );
    } else if (isInserting) {
      context.missing(_namaUtangMeta);
    }
    if (data.containsKey('jumlah_total')) {
      context.handle(
        _jumlahTotalMeta,
        jumlahTotal.isAcceptableOrUnknown(
          data['jumlah_total']!,
          _jumlahTotalMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_jumlahTotalMeta);
    }
    if (data.containsKey('jumlah_terbayar')) {
      context.handle(
        _jumlahTerbayarMeta,
        jumlahTerbayar.isAcceptableOrUnknown(
          data['jumlah_terbayar']!,
          _jumlahTerbayarMeta,
        ),
      );
    }
    if (data.containsKey('status')) {
      context.handle(
        _statusMeta,
        status.isAcceptableOrUnknown(data['status']!, _statusMeta),
      );
    } else if (isInserting) {
      context.missing(_statusMeta);
    }
    if (data.containsKey('jatuh_tempo')) {
      context.handle(
        _jatuhTempoMeta,
        jatuhTempo.isAcceptableOrUnknown(data['jatuh_tempo']!, _jatuhTempoMeta),
      );
    }
    if (data.containsKey('catatan')) {
      context.handle(
        _catatanMeta,
        catatan.isAcceptableOrUnknown(data['catatan']!, _catatanMeta),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    if (data.containsKey('is_synced')) {
      context.handle(
        _isSyncedMeta,
        isSynced.isAcceptableOrUnknown(data['is_synced']!, _isSyncedMeta),
      );
    }
    if (data.containsKey('is_deleted')) {
      context.handle(
        _isDeletedMeta,
        isDeleted.isAcceptableOrUnknown(data['is_deleted']!, _isDeletedMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  UtangTableData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return UtangTableData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      namaUtang: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}nama_utang'],
      )!,
      jumlahTotal: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}jumlah_total'],
      )!,
      jumlahTerbayar: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}jumlah_terbayar'],
      )!,
      status: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}status'],
      )!,
      jatuhTempo: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}jatuh_tempo'],
      ),
      catatan: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}catatan'],
      ),
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
      isSynced: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_synced'],
      )!,
      isDeleted: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_deleted'],
      )!,
    );
  }

  @override
  $UtangTableTable createAlias(String alias) {
    return $UtangTableTable(attachedDatabase, alias);
  }
}

class UtangTableData extends DataClass implements Insertable<UtangTableData> {
  final String id;
  final String namaUtang;
  final double jumlahTotal;
  final double jumlahTerbayar;
  final String status;
  final DateTime? jatuhTempo;
  final String? catatan;
  final DateTime updatedAt;
  final bool isSynced;
  final bool isDeleted;
  const UtangTableData({
    required this.id,
    required this.namaUtang,
    required this.jumlahTotal,
    required this.jumlahTerbayar,
    required this.status,
    this.jatuhTempo,
    this.catatan,
    required this.updatedAt,
    required this.isSynced,
    required this.isDeleted,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['nama_utang'] = Variable<String>(namaUtang);
    map['jumlah_total'] = Variable<double>(jumlahTotal);
    map['jumlah_terbayar'] = Variable<double>(jumlahTerbayar);
    map['status'] = Variable<String>(status);
    if (!nullToAbsent || jatuhTempo != null) {
      map['jatuh_tempo'] = Variable<DateTime>(jatuhTempo);
    }
    if (!nullToAbsent || catatan != null) {
      map['catatan'] = Variable<String>(catatan);
    }
    map['updated_at'] = Variable<DateTime>(updatedAt);
    map['is_synced'] = Variable<bool>(isSynced);
    map['is_deleted'] = Variable<bool>(isDeleted);
    return map;
  }

  UtangTableCompanion toCompanion(bool nullToAbsent) {
    return UtangTableCompanion(
      id: Value(id),
      namaUtang: Value(namaUtang),
      jumlahTotal: Value(jumlahTotal),
      jumlahTerbayar: Value(jumlahTerbayar),
      status: Value(status),
      jatuhTempo: jatuhTempo == null && nullToAbsent
          ? const Value.absent()
          : Value(jatuhTempo),
      catatan: catatan == null && nullToAbsent
          ? const Value.absent()
          : Value(catatan),
      updatedAt: Value(updatedAt),
      isSynced: Value(isSynced),
      isDeleted: Value(isDeleted),
    );
  }

  factory UtangTableData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return UtangTableData(
      id: serializer.fromJson<String>(json['id']),
      namaUtang: serializer.fromJson<String>(json['namaUtang']),
      jumlahTotal: serializer.fromJson<double>(json['jumlahTotal']),
      jumlahTerbayar: serializer.fromJson<double>(json['jumlahTerbayar']),
      status: serializer.fromJson<String>(json['status']),
      jatuhTempo: serializer.fromJson<DateTime?>(json['jatuhTempo']),
      catatan: serializer.fromJson<String?>(json['catatan']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
      isSynced: serializer.fromJson<bool>(json['isSynced']),
      isDeleted: serializer.fromJson<bool>(json['isDeleted']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'namaUtang': serializer.toJson<String>(namaUtang),
      'jumlahTotal': serializer.toJson<double>(jumlahTotal),
      'jumlahTerbayar': serializer.toJson<double>(jumlahTerbayar),
      'status': serializer.toJson<String>(status),
      'jatuhTempo': serializer.toJson<DateTime?>(jatuhTempo),
      'catatan': serializer.toJson<String?>(catatan),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
      'isSynced': serializer.toJson<bool>(isSynced),
      'isDeleted': serializer.toJson<bool>(isDeleted),
    };
  }

  UtangTableData copyWith({
    String? id,
    String? namaUtang,
    double? jumlahTotal,
    double? jumlahTerbayar,
    String? status,
    Value<DateTime?> jatuhTempo = const Value.absent(),
    Value<String?> catatan = const Value.absent(),
    DateTime? updatedAt,
    bool? isSynced,
    bool? isDeleted,
  }) => UtangTableData(
    id: id ?? this.id,
    namaUtang: namaUtang ?? this.namaUtang,
    jumlahTotal: jumlahTotal ?? this.jumlahTotal,
    jumlahTerbayar: jumlahTerbayar ?? this.jumlahTerbayar,
    status: status ?? this.status,
    jatuhTempo: jatuhTempo.present ? jatuhTempo.value : this.jatuhTempo,
    catatan: catatan.present ? catatan.value : this.catatan,
    updatedAt: updatedAt ?? this.updatedAt,
    isSynced: isSynced ?? this.isSynced,
    isDeleted: isDeleted ?? this.isDeleted,
  );
  UtangTableData copyWithCompanion(UtangTableCompanion data) {
    return UtangTableData(
      id: data.id.present ? data.id.value : this.id,
      namaUtang: data.namaUtang.present ? data.namaUtang.value : this.namaUtang,
      jumlahTotal: data.jumlahTotal.present
          ? data.jumlahTotal.value
          : this.jumlahTotal,
      jumlahTerbayar: data.jumlahTerbayar.present
          ? data.jumlahTerbayar.value
          : this.jumlahTerbayar,
      status: data.status.present ? data.status.value : this.status,
      jatuhTempo: data.jatuhTempo.present
          ? data.jatuhTempo.value
          : this.jatuhTempo,
      catatan: data.catatan.present ? data.catatan.value : this.catatan,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      isSynced: data.isSynced.present ? data.isSynced.value : this.isSynced,
      isDeleted: data.isDeleted.present ? data.isDeleted.value : this.isDeleted,
    );
  }

  @override
  String toString() {
    return (StringBuffer('UtangTableData(')
          ..write('id: $id, ')
          ..write('namaUtang: $namaUtang, ')
          ..write('jumlahTotal: $jumlahTotal, ')
          ..write('jumlahTerbayar: $jumlahTerbayar, ')
          ..write('status: $status, ')
          ..write('jatuhTempo: $jatuhTempo, ')
          ..write('catatan: $catatan, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('isSynced: $isSynced, ')
          ..write('isDeleted: $isDeleted')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    namaUtang,
    jumlahTotal,
    jumlahTerbayar,
    status,
    jatuhTempo,
    catatan,
    updatedAt,
    isSynced,
    isDeleted,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is UtangTableData &&
          other.id == this.id &&
          other.namaUtang == this.namaUtang &&
          other.jumlahTotal == this.jumlahTotal &&
          other.jumlahTerbayar == this.jumlahTerbayar &&
          other.status == this.status &&
          other.jatuhTempo == this.jatuhTempo &&
          other.catatan == this.catatan &&
          other.updatedAt == this.updatedAt &&
          other.isSynced == this.isSynced &&
          other.isDeleted == this.isDeleted);
}

class UtangTableCompanion extends UpdateCompanion<UtangTableData> {
  final Value<String> id;
  final Value<String> namaUtang;
  final Value<double> jumlahTotal;
  final Value<double> jumlahTerbayar;
  final Value<String> status;
  final Value<DateTime?> jatuhTempo;
  final Value<String?> catatan;
  final Value<DateTime> updatedAt;
  final Value<bool> isSynced;
  final Value<bool> isDeleted;
  final Value<int> rowid;
  const UtangTableCompanion({
    this.id = const Value.absent(),
    this.namaUtang = const Value.absent(),
    this.jumlahTotal = const Value.absent(),
    this.jumlahTerbayar = const Value.absent(),
    this.status = const Value.absent(),
    this.jatuhTempo = const Value.absent(),
    this.catatan = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.isSynced = const Value.absent(),
    this.isDeleted = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  UtangTableCompanion.insert({
    required String id,
    required String namaUtang,
    required double jumlahTotal,
    this.jumlahTerbayar = const Value.absent(),
    required String status,
    this.jatuhTempo = const Value.absent(),
    this.catatan = const Value.absent(),
    required DateTime updatedAt,
    this.isSynced = const Value.absent(),
    this.isDeleted = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       namaUtang = Value(namaUtang),
       jumlahTotal = Value(jumlahTotal),
       status = Value(status),
       updatedAt = Value(updatedAt);
  static Insertable<UtangTableData> custom({
    Expression<String>? id,
    Expression<String>? namaUtang,
    Expression<double>? jumlahTotal,
    Expression<double>? jumlahTerbayar,
    Expression<String>? status,
    Expression<DateTime>? jatuhTempo,
    Expression<String>? catatan,
    Expression<DateTime>? updatedAt,
    Expression<bool>? isSynced,
    Expression<bool>? isDeleted,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (namaUtang != null) 'nama_utang': namaUtang,
      if (jumlahTotal != null) 'jumlah_total': jumlahTotal,
      if (jumlahTerbayar != null) 'jumlah_terbayar': jumlahTerbayar,
      if (status != null) 'status': status,
      if (jatuhTempo != null) 'jatuh_tempo': jatuhTempo,
      if (catatan != null) 'catatan': catatan,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (isSynced != null) 'is_synced': isSynced,
      if (isDeleted != null) 'is_deleted': isDeleted,
      if (rowid != null) 'rowid': rowid,
    });
  }

  UtangTableCompanion copyWith({
    Value<String>? id,
    Value<String>? namaUtang,
    Value<double>? jumlahTotal,
    Value<double>? jumlahTerbayar,
    Value<String>? status,
    Value<DateTime?>? jatuhTempo,
    Value<String?>? catatan,
    Value<DateTime>? updatedAt,
    Value<bool>? isSynced,
    Value<bool>? isDeleted,
    Value<int>? rowid,
  }) {
    return UtangTableCompanion(
      id: id ?? this.id,
      namaUtang: namaUtang ?? this.namaUtang,
      jumlahTotal: jumlahTotal ?? this.jumlahTotal,
      jumlahTerbayar: jumlahTerbayar ?? this.jumlahTerbayar,
      status: status ?? this.status,
      jatuhTempo: jatuhTempo ?? this.jatuhTempo,
      catatan: catatan ?? this.catatan,
      updatedAt: updatedAt ?? this.updatedAt,
      isSynced: isSynced ?? this.isSynced,
      isDeleted: isDeleted ?? this.isDeleted,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (namaUtang.present) {
      map['nama_utang'] = Variable<String>(namaUtang.value);
    }
    if (jumlahTotal.present) {
      map['jumlah_total'] = Variable<double>(jumlahTotal.value);
    }
    if (jumlahTerbayar.present) {
      map['jumlah_terbayar'] = Variable<double>(jumlahTerbayar.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (jatuhTempo.present) {
      map['jatuh_tempo'] = Variable<DateTime>(jatuhTempo.value);
    }
    if (catatan.present) {
      map['catatan'] = Variable<String>(catatan.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (isSynced.present) {
      map['is_synced'] = Variable<bool>(isSynced.value);
    }
    if (isDeleted.present) {
      map['is_deleted'] = Variable<bool>(isDeleted.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('UtangTableCompanion(')
          ..write('id: $id, ')
          ..write('namaUtang: $namaUtang, ')
          ..write('jumlahTotal: $jumlahTotal, ')
          ..write('jumlahTerbayar: $jumlahTerbayar, ')
          ..write('status: $status, ')
          ..write('jatuhTempo: $jatuhTempo, ')
          ..write('catatan: $catatan, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('isSynced: $isSynced, ')
          ..write('isDeleted: $isDeleted, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $KategoriTableTable extends KategoriTable
    with TableInfo<$KategoriTableTable, KategoriTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $KategoriTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _namaMeta = const VerificationMeta('nama');
  @override
  late final GeneratedColumn<String> nama = GeneratedColumn<String>(
    'nama',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _tipeMeta = const VerificationMeta('tipe');
  @override
  late final GeneratedColumn<String> tipe = GeneratedColumn<String>(
    'tipe',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _isSyncedMeta = const VerificationMeta(
    'isSynced',
  );
  @override
  late final GeneratedColumn<bool> isSynced = GeneratedColumn<bool>(
    'is_synced',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_synced" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _isDeletedMeta = const VerificationMeta(
    'isDeleted',
  );
  @override
  late final GeneratedColumn<bool> isDeleted = GeneratedColumn<bool>(
    'is_deleted',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_deleted" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    nama,
    tipe,
    updatedAt,
    isSynced,
    isDeleted,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'kategori_table';
  @override
  VerificationContext validateIntegrity(
    Insertable<KategoriTableData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('nama')) {
      context.handle(
        _namaMeta,
        nama.isAcceptableOrUnknown(data['nama']!, _namaMeta),
      );
    } else if (isInserting) {
      context.missing(_namaMeta);
    }
    if (data.containsKey('tipe')) {
      context.handle(
        _tipeMeta,
        tipe.isAcceptableOrUnknown(data['tipe']!, _tipeMeta),
      );
    } else if (isInserting) {
      context.missing(_tipeMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    if (data.containsKey('is_synced')) {
      context.handle(
        _isSyncedMeta,
        isSynced.isAcceptableOrUnknown(data['is_synced']!, _isSyncedMeta),
      );
    }
    if (data.containsKey('is_deleted')) {
      context.handle(
        _isDeletedMeta,
        isDeleted.isAcceptableOrUnknown(data['is_deleted']!, _isDeletedMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  KategoriTableData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return KategoriTableData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      nama: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}nama'],
      )!,
      tipe: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}tipe'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
      isSynced: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_synced'],
      )!,
      isDeleted: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_deleted'],
      )!,
    );
  }

  @override
  $KategoriTableTable createAlias(String alias) {
    return $KategoriTableTable(attachedDatabase, alias);
  }
}

class KategoriTableData extends DataClass
    implements Insertable<KategoriTableData> {
  final String id;
  final String nama;
  final String tipe;
  final DateTime updatedAt;
  final bool isSynced;
  final bool isDeleted;
  const KategoriTableData({
    required this.id,
    required this.nama,
    required this.tipe,
    required this.updatedAt,
    required this.isSynced,
    required this.isDeleted,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['nama'] = Variable<String>(nama);
    map['tipe'] = Variable<String>(tipe);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    map['is_synced'] = Variable<bool>(isSynced);
    map['is_deleted'] = Variable<bool>(isDeleted);
    return map;
  }

  KategoriTableCompanion toCompanion(bool nullToAbsent) {
    return KategoriTableCompanion(
      id: Value(id),
      nama: Value(nama),
      tipe: Value(tipe),
      updatedAt: Value(updatedAt),
      isSynced: Value(isSynced),
      isDeleted: Value(isDeleted),
    );
  }

  factory KategoriTableData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return KategoriTableData(
      id: serializer.fromJson<String>(json['id']),
      nama: serializer.fromJson<String>(json['nama']),
      tipe: serializer.fromJson<String>(json['tipe']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
      isSynced: serializer.fromJson<bool>(json['isSynced']),
      isDeleted: serializer.fromJson<bool>(json['isDeleted']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'nama': serializer.toJson<String>(nama),
      'tipe': serializer.toJson<String>(tipe),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
      'isSynced': serializer.toJson<bool>(isSynced),
      'isDeleted': serializer.toJson<bool>(isDeleted),
    };
  }

  KategoriTableData copyWith({
    String? id,
    String? nama,
    String? tipe,
    DateTime? updatedAt,
    bool? isSynced,
    bool? isDeleted,
  }) => KategoriTableData(
    id: id ?? this.id,
    nama: nama ?? this.nama,
    tipe: tipe ?? this.tipe,
    updatedAt: updatedAt ?? this.updatedAt,
    isSynced: isSynced ?? this.isSynced,
    isDeleted: isDeleted ?? this.isDeleted,
  );
  KategoriTableData copyWithCompanion(KategoriTableCompanion data) {
    return KategoriTableData(
      id: data.id.present ? data.id.value : this.id,
      nama: data.nama.present ? data.nama.value : this.nama,
      tipe: data.tipe.present ? data.tipe.value : this.tipe,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      isSynced: data.isSynced.present ? data.isSynced.value : this.isSynced,
      isDeleted: data.isDeleted.present ? data.isDeleted.value : this.isDeleted,
    );
  }

  @override
  String toString() {
    return (StringBuffer('KategoriTableData(')
          ..write('id: $id, ')
          ..write('nama: $nama, ')
          ..write('tipe: $tipe, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('isSynced: $isSynced, ')
          ..write('isDeleted: $isDeleted')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, nama, tipe, updatedAt, isSynced, isDeleted);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is KategoriTableData &&
          other.id == this.id &&
          other.nama == this.nama &&
          other.tipe == this.tipe &&
          other.updatedAt == this.updatedAt &&
          other.isSynced == this.isSynced &&
          other.isDeleted == this.isDeleted);
}

class KategoriTableCompanion extends UpdateCompanion<KategoriTableData> {
  final Value<String> id;
  final Value<String> nama;
  final Value<String> tipe;
  final Value<DateTime> updatedAt;
  final Value<bool> isSynced;
  final Value<bool> isDeleted;
  final Value<int> rowid;
  const KategoriTableCompanion({
    this.id = const Value.absent(),
    this.nama = const Value.absent(),
    this.tipe = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.isSynced = const Value.absent(),
    this.isDeleted = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  KategoriTableCompanion.insert({
    required String id,
    required String nama,
    required String tipe,
    required DateTime updatedAt,
    this.isSynced = const Value.absent(),
    this.isDeleted = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       nama = Value(nama),
       tipe = Value(tipe),
       updatedAt = Value(updatedAt);
  static Insertable<KategoriTableData> custom({
    Expression<String>? id,
    Expression<String>? nama,
    Expression<String>? tipe,
    Expression<DateTime>? updatedAt,
    Expression<bool>? isSynced,
    Expression<bool>? isDeleted,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (nama != null) 'nama': nama,
      if (tipe != null) 'tipe': tipe,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (isSynced != null) 'is_synced': isSynced,
      if (isDeleted != null) 'is_deleted': isDeleted,
      if (rowid != null) 'rowid': rowid,
    });
  }

  KategoriTableCompanion copyWith({
    Value<String>? id,
    Value<String>? nama,
    Value<String>? tipe,
    Value<DateTime>? updatedAt,
    Value<bool>? isSynced,
    Value<bool>? isDeleted,
    Value<int>? rowid,
  }) {
    return KategoriTableCompanion(
      id: id ?? this.id,
      nama: nama ?? this.nama,
      tipe: tipe ?? this.tipe,
      updatedAt: updatedAt ?? this.updatedAt,
      isSynced: isSynced ?? this.isSynced,
      isDeleted: isDeleted ?? this.isDeleted,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (nama.present) {
      map['nama'] = Variable<String>(nama.value);
    }
    if (tipe.present) {
      map['tipe'] = Variable<String>(tipe.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (isSynced.present) {
      map['is_synced'] = Variable<bool>(isSynced.value);
    }
    if (isDeleted.present) {
      map['is_deleted'] = Variable<bool>(isDeleted.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('KategoriTableCompanion(')
          ..write('id: $id, ')
          ..write('nama: $nama, ')
          ..write('tipe: $tipe, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('isSynced: $isSynced, ')
          ..write('isDeleted: $isDeleted, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $GajiTableTable gajiTable = $GajiTableTable(this);
  late final $PengeluaranTableTable pengeluaranTable = $PengeluaranTableTable(
    this,
  );
  late final $UtangTableTable utangTable = $UtangTableTable(this);
  late final $KategoriTableTable kategoriTable = $KategoriTableTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    gajiTable,
    pengeluaranTable,
    utangTable,
    kategoriTable,
  ];
}

typedef $$GajiTableTableCreateCompanionBuilder =
    GajiTableCompanion Function({
      required String id,
      required double jumlah,
      Value<double?> jumlahBebas,
      required DateTime tanggal,
      Value<String?> catatan,
      required DateTime updatedAt,
      Value<bool> isSynced,
      Value<bool> isDeleted,
      Value<int> rowid,
    });
typedef $$GajiTableTableUpdateCompanionBuilder =
    GajiTableCompanion Function({
      Value<String> id,
      Value<double> jumlah,
      Value<double?> jumlahBebas,
      Value<DateTime> tanggal,
      Value<String?> catatan,
      Value<DateTime> updatedAt,
      Value<bool> isSynced,
      Value<bool> isDeleted,
      Value<int> rowid,
    });

class $$GajiTableTableFilterComposer
    extends Composer<_$AppDatabase, $GajiTableTable> {
  $$GajiTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get jumlah => $composableBuilder(
    column: $table.jumlah,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get jumlahBebas => $composableBuilder(
    column: $table.jumlahBebas,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get tanggal => $composableBuilder(
    column: $table.tanggal,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get catatan => $composableBuilder(
    column: $table.catatan,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isSynced => $composableBuilder(
    column: $table.isSynced,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isDeleted => $composableBuilder(
    column: $table.isDeleted,
    builder: (column) => ColumnFilters(column),
  );
}

class $$GajiTableTableOrderingComposer
    extends Composer<_$AppDatabase, $GajiTableTable> {
  $$GajiTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get jumlah => $composableBuilder(
    column: $table.jumlah,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get jumlahBebas => $composableBuilder(
    column: $table.jumlahBebas,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get tanggal => $composableBuilder(
    column: $table.tanggal,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get catatan => $composableBuilder(
    column: $table.catatan,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isSynced => $composableBuilder(
    column: $table.isSynced,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isDeleted => $composableBuilder(
    column: $table.isDeleted,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$GajiTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $GajiTableTable> {
  $$GajiTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<double> get jumlah =>
      $composableBuilder(column: $table.jumlah, builder: (column) => column);

  GeneratedColumn<double> get jumlahBebas => $composableBuilder(
    column: $table.jumlahBebas,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get tanggal =>
      $composableBuilder(column: $table.tanggal, builder: (column) => column);

  GeneratedColumn<String> get catatan =>
      $composableBuilder(column: $table.catatan, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<bool> get isSynced =>
      $composableBuilder(column: $table.isSynced, builder: (column) => column);

  GeneratedColumn<bool> get isDeleted =>
      $composableBuilder(column: $table.isDeleted, builder: (column) => column);
}

class $$GajiTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $GajiTableTable,
          GajiTableData,
          $$GajiTableTableFilterComposer,
          $$GajiTableTableOrderingComposer,
          $$GajiTableTableAnnotationComposer,
          $$GajiTableTableCreateCompanionBuilder,
          $$GajiTableTableUpdateCompanionBuilder,
          (
            GajiTableData,
            BaseReferences<_$AppDatabase, $GajiTableTable, GajiTableData>,
          ),
          GajiTableData,
          PrefetchHooks Function()
        > {
  $$GajiTableTableTableManager(_$AppDatabase db, $GajiTableTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$GajiTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$GajiTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$GajiTableTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<double> jumlah = const Value.absent(),
                Value<double?> jumlahBebas = const Value.absent(),
                Value<DateTime> tanggal = const Value.absent(),
                Value<String?> catatan = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<bool> isSynced = const Value.absent(),
                Value<bool> isDeleted = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => GajiTableCompanion(
                id: id,
                jumlah: jumlah,
                jumlahBebas: jumlahBebas,
                tanggal: tanggal,
                catatan: catatan,
                updatedAt: updatedAt,
                isSynced: isSynced,
                isDeleted: isDeleted,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required double jumlah,
                Value<double?> jumlahBebas = const Value.absent(),
                required DateTime tanggal,
                Value<String?> catatan = const Value.absent(),
                required DateTime updatedAt,
                Value<bool> isSynced = const Value.absent(),
                Value<bool> isDeleted = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => GajiTableCompanion.insert(
                id: id,
                jumlah: jumlah,
                jumlahBebas: jumlahBebas,
                tanggal: tanggal,
                catatan: catatan,
                updatedAt: updatedAt,
                isSynced: isSynced,
                isDeleted: isDeleted,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$GajiTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $GajiTableTable,
      GajiTableData,
      $$GajiTableTableFilterComposer,
      $$GajiTableTableOrderingComposer,
      $$GajiTableTableAnnotationComposer,
      $$GajiTableTableCreateCompanionBuilder,
      $$GajiTableTableUpdateCompanionBuilder,
      (
        GajiTableData,
        BaseReferences<_$AppDatabase, $GajiTableTable, GajiTableData>,
      ),
      GajiTableData,
      PrefetchHooks Function()
    >;
typedef $$PengeluaranTableTableCreateCompanionBuilder =
    PengeluaranTableCompanion Function({
      required String id,
      required double jumlah,
      required String kategoriId,
      required DateTime tanggal,
      Value<String?> catatan,
      Value<String?> utangId,
      required DateTime updatedAt,
      Value<bool> isSynced,
      Value<bool> isDeleted,
      Value<int> rowid,
    });
typedef $$PengeluaranTableTableUpdateCompanionBuilder =
    PengeluaranTableCompanion Function({
      Value<String> id,
      Value<double> jumlah,
      Value<String> kategoriId,
      Value<DateTime> tanggal,
      Value<String?> catatan,
      Value<String?> utangId,
      Value<DateTime> updatedAt,
      Value<bool> isSynced,
      Value<bool> isDeleted,
      Value<int> rowid,
    });

class $$PengeluaranTableTableFilterComposer
    extends Composer<_$AppDatabase, $PengeluaranTableTable> {
  $$PengeluaranTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get jumlah => $composableBuilder(
    column: $table.jumlah,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get kategoriId => $composableBuilder(
    column: $table.kategoriId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get tanggal => $composableBuilder(
    column: $table.tanggal,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get catatan => $composableBuilder(
    column: $table.catatan,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get utangId => $composableBuilder(
    column: $table.utangId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isSynced => $composableBuilder(
    column: $table.isSynced,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isDeleted => $composableBuilder(
    column: $table.isDeleted,
    builder: (column) => ColumnFilters(column),
  );
}

class $$PengeluaranTableTableOrderingComposer
    extends Composer<_$AppDatabase, $PengeluaranTableTable> {
  $$PengeluaranTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get jumlah => $composableBuilder(
    column: $table.jumlah,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get kategoriId => $composableBuilder(
    column: $table.kategoriId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get tanggal => $composableBuilder(
    column: $table.tanggal,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get catatan => $composableBuilder(
    column: $table.catatan,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get utangId => $composableBuilder(
    column: $table.utangId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isSynced => $composableBuilder(
    column: $table.isSynced,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isDeleted => $composableBuilder(
    column: $table.isDeleted,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$PengeluaranTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $PengeluaranTableTable> {
  $$PengeluaranTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<double> get jumlah =>
      $composableBuilder(column: $table.jumlah, builder: (column) => column);

  GeneratedColumn<String> get kategoriId => $composableBuilder(
    column: $table.kategoriId,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get tanggal =>
      $composableBuilder(column: $table.tanggal, builder: (column) => column);

  GeneratedColumn<String> get catatan =>
      $composableBuilder(column: $table.catatan, builder: (column) => column);

  GeneratedColumn<String> get utangId =>
      $composableBuilder(column: $table.utangId, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<bool> get isSynced =>
      $composableBuilder(column: $table.isSynced, builder: (column) => column);

  GeneratedColumn<bool> get isDeleted =>
      $composableBuilder(column: $table.isDeleted, builder: (column) => column);
}

class $$PengeluaranTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $PengeluaranTableTable,
          PengeluaranTableData,
          $$PengeluaranTableTableFilterComposer,
          $$PengeluaranTableTableOrderingComposer,
          $$PengeluaranTableTableAnnotationComposer,
          $$PengeluaranTableTableCreateCompanionBuilder,
          $$PengeluaranTableTableUpdateCompanionBuilder,
          (
            PengeluaranTableData,
            BaseReferences<
              _$AppDatabase,
              $PengeluaranTableTable,
              PengeluaranTableData
            >,
          ),
          PengeluaranTableData,
          PrefetchHooks Function()
        > {
  $$PengeluaranTableTableTableManager(
    _$AppDatabase db,
    $PengeluaranTableTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$PengeluaranTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$PengeluaranTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$PengeluaranTableTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<double> jumlah = const Value.absent(),
                Value<String> kategoriId = const Value.absent(),
                Value<DateTime> tanggal = const Value.absent(),
                Value<String?> catatan = const Value.absent(),
                Value<String?> utangId = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<bool> isSynced = const Value.absent(),
                Value<bool> isDeleted = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => PengeluaranTableCompanion(
                id: id,
                jumlah: jumlah,
                kategoriId: kategoriId,
                tanggal: tanggal,
                catatan: catatan,
                utangId: utangId,
                updatedAt: updatedAt,
                isSynced: isSynced,
                isDeleted: isDeleted,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required double jumlah,
                required String kategoriId,
                required DateTime tanggal,
                Value<String?> catatan = const Value.absent(),
                Value<String?> utangId = const Value.absent(),
                required DateTime updatedAt,
                Value<bool> isSynced = const Value.absent(),
                Value<bool> isDeleted = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => PengeluaranTableCompanion.insert(
                id: id,
                jumlah: jumlah,
                kategoriId: kategoriId,
                tanggal: tanggal,
                catatan: catatan,
                utangId: utangId,
                updatedAt: updatedAt,
                isSynced: isSynced,
                isDeleted: isDeleted,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$PengeluaranTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $PengeluaranTableTable,
      PengeluaranTableData,
      $$PengeluaranTableTableFilterComposer,
      $$PengeluaranTableTableOrderingComposer,
      $$PengeluaranTableTableAnnotationComposer,
      $$PengeluaranTableTableCreateCompanionBuilder,
      $$PengeluaranTableTableUpdateCompanionBuilder,
      (
        PengeluaranTableData,
        BaseReferences<
          _$AppDatabase,
          $PengeluaranTableTable,
          PengeluaranTableData
        >,
      ),
      PengeluaranTableData,
      PrefetchHooks Function()
    >;
typedef $$UtangTableTableCreateCompanionBuilder =
    UtangTableCompanion Function({
      required String id,
      required String namaUtang,
      required double jumlahTotal,
      Value<double> jumlahTerbayar,
      required String status,
      Value<DateTime?> jatuhTempo,
      Value<String?> catatan,
      required DateTime updatedAt,
      Value<bool> isSynced,
      Value<bool> isDeleted,
      Value<int> rowid,
    });
typedef $$UtangTableTableUpdateCompanionBuilder =
    UtangTableCompanion Function({
      Value<String> id,
      Value<String> namaUtang,
      Value<double> jumlahTotal,
      Value<double> jumlahTerbayar,
      Value<String> status,
      Value<DateTime?> jatuhTempo,
      Value<String?> catatan,
      Value<DateTime> updatedAt,
      Value<bool> isSynced,
      Value<bool> isDeleted,
      Value<int> rowid,
    });

class $$UtangTableTableFilterComposer
    extends Composer<_$AppDatabase, $UtangTableTable> {
  $$UtangTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get namaUtang => $composableBuilder(
    column: $table.namaUtang,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get jumlahTotal => $composableBuilder(
    column: $table.jumlahTotal,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get jumlahTerbayar => $composableBuilder(
    column: $table.jumlahTerbayar,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get jatuhTempo => $composableBuilder(
    column: $table.jatuhTempo,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get catatan => $composableBuilder(
    column: $table.catatan,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isSynced => $composableBuilder(
    column: $table.isSynced,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isDeleted => $composableBuilder(
    column: $table.isDeleted,
    builder: (column) => ColumnFilters(column),
  );
}

class $$UtangTableTableOrderingComposer
    extends Composer<_$AppDatabase, $UtangTableTable> {
  $$UtangTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get namaUtang => $composableBuilder(
    column: $table.namaUtang,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get jumlahTotal => $composableBuilder(
    column: $table.jumlahTotal,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get jumlahTerbayar => $composableBuilder(
    column: $table.jumlahTerbayar,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get jatuhTempo => $composableBuilder(
    column: $table.jatuhTempo,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get catatan => $composableBuilder(
    column: $table.catatan,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isSynced => $composableBuilder(
    column: $table.isSynced,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isDeleted => $composableBuilder(
    column: $table.isDeleted,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$UtangTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $UtangTableTable> {
  $$UtangTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get namaUtang =>
      $composableBuilder(column: $table.namaUtang, builder: (column) => column);

  GeneratedColumn<double> get jumlahTotal => $composableBuilder(
    column: $table.jumlahTotal,
    builder: (column) => column,
  );

  GeneratedColumn<double> get jumlahTerbayar => $composableBuilder(
    column: $table.jumlahTerbayar,
    builder: (column) => column,
  );

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<DateTime> get jatuhTempo => $composableBuilder(
    column: $table.jatuhTempo,
    builder: (column) => column,
  );

  GeneratedColumn<String> get catatan =>
      $composableBuilder(column: $table.catatan, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<bool> get isSynced =>
      $composableBuilder(column: $table.isSynced, builder: (column) => column);

  GeneratedColumn<bool> get isDeleted =>
      $composableBuilder(column: $table.isDeleted, builder: (column) => column);
}

class $$UtangTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $UtangTableTable,
          UtangTableData,
          $$UtangTableTableFilterComposer,
          $$UtangTableTableOrderingComposer,
          $$UtangTableTableAnnotationComposer,
          $$UtangTableTableCreateCompanionBuilder,
          $$UtangTableTableUpdateCompanionBuilder,
          (
            UtangTableData,
            BaseReferences<_$AppDatabase, $UtangTableTable, UtangTableData>,
          ),
          UtangTableData,
          PrefetchHooks Function()
        > {
  $$UtangTableTableTableManager(_$AppDatabase db, $UtangTableTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$UtangTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$UtangTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$UtangTableTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> namaUtang = const Value.absent(),
                Value<double> jumlahTotal = const Value.absent(),
                Value<double> jumlahTerbayar = const Value.absent(),
                Value<String> status = const Value.absent(),
                Value<DateTime?> jatuhTempo = const Value.absent(),
                Value<String?> catatan = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<bool> isSynced = const Value.absent(),
                Value<bool> isDeleted = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => UtangTableCompanion(
                id: id,
                namaUtang: namaUtang,
                jumlahTotal: jumlahTotal,
                jumlahTerbayar: jumlahTerbayar,
                status: status,
                jatuhTempo: jatuhTempo,
                catatan: catatan,
                updatedAt: updatedAt,
                isSynced: isSynced,
                isDeleted: isDeleted,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String namaUtang,
                required double jumlahTotal,
                Value<double> jumlahTerbayar = const Value.absent(),
                required String status,
                Value<DateTime?> jatuhTempo = const Value.absent(),
                Value<String?> catatan = const Value.absent(),
                required DateTime updatedAt,
                Value<bool> isSynced = const Value.absent(),
                Value<bool> isDeleted = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => UtangTableCompanion.insert(
                id: id,
                namaUtang: namaUtang,
                jumlahTotal: jumlahTotal,
                jumlahTerbayar: jumlahTerbayar,
                status: status,
                jatuhTempo: jatuhTempo,
                catatan: catatan,
                updatedAt: updatedAt,
                isSynced: isSynced,
                isDeleted: isDeleted,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$UtangTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $UtangTableTable,
      UtangTableData,
      $$UtangTableTableFilterComposer,
      $$UtangTableTableOrderingComposer,
      $$UtangTableTableAnnotationComposer,
      $$UtangTableTableCreateCompanionBuilder,
      $$UtangTableTableUpdateCompanionBuilder,
      (
        UtangTableData,
        BaseReferences<_$AppDatabase, $UtangTableTable, UtangTableData>,
      ),
      UtangTableData,
      PrefetchHooks Function()
    >;
typedef $$KategoriTableTableCreateCompanionBuilder =
    KategoriTableCompanion Function({
      required String id,
      required String nama,
      required String tipe,
      required DateTime updatedAt,
      Value<bool> isSynced,
      Value<bool> isDeleted,
      Value<int> rowid,
    });
typedef $$KategoriTableTableUpdateCompanionBuilder =
    KategoriTableCompanion Function({
      Value<String> id,
      Value<String> nama,
      Value<String> tipe,
      Value<DateTime> updatedAt,
      Value<bool> isSynced,
      Value<bool> isDeleted,
      Value<int> rowid,
    });

class $$KategoriTableTableFilterComposer
    extends Composer<_$AppDatabase, $KategoriTableTable> {
  $$KategoriTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get nama => $composableBuilder(
    column: $table.nama,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get tipe => $composableBuilder(
    column: $table.tipe,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isSynced => $composableBuilder(
    column: $table.isSynced,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isDeleted => $composableBuilder(
    column: $table.isDeleted,
    builder: (column) => ColumnFilters(column),
  );
}

class $$KategoriTableTableOrderingComposer
    extends Composer<_$AppDatabase, $KategoriTableTable> {
  $$KategoriTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get nama => $composableBuilder(
    column: $table.nama,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get tipe => $composableBuilder(
    column: $table.tipe,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isSynced => $composableBuilder(
    column: $table.isSynced,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isDeleted => $composableBuilder(
    column: $table.isDeleted,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$KategoriTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $KategoriTableTable> {
  $$KategoriTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get nama =>
      $composableBuilder(column: $table.nama, builder: (column) => column);

  GeneratedColumn<String> get tipe =>
      $composableBuilder(column: $table.tipe, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<bool> get isSynced =>
      $composableBuilder(column: $table.isSynced, builder: (column) => column);

  GeneratedColumn<bool> get isDeleted =>
      $composableBuilder(column: $table.isDeleted, builder: (column) => column);
}

class $$KategoriTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $KategoriTableTable,
          KategoriTableData,
          $$KategoriTableTableFilterComposer,
          $$KategoriTableTableOrderingComposer,
          $$KategoriTableTableAnnotationComposer,
          $$KategoriTableTableCreateCompanionBuilder,
          $$KategoriTableTableUpdateCompanionBuilder,
          (
            KategoriTableData,
            BaseReferences<
              _$AppDatabase,
              $KategoriTableTable,
              KategoriTableData
            >,
          ),
          KategoriTableData,
          PrefetchHooks Function()
        > {
  $$KategoriTableTableTableManager(_$AppDatabase db, $KategoriTableTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$KategoriTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$KategoriTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$KategoriTableTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> nama = const Value.absent(),
                Value<String> tipe = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<bool> isSynced = const Value.absent(),
                Value<bool> isDeleted = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => KategoriTableCompanion(
                id: id,
                nama: nama,
                tipe: tipe,
                updatedAt: updatedAt,
                isSynced: isSynced,
                isDeleted: isDeleted,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String nama,
                required String tipe,
                required DateTime updatedAt,
                Value<bool> isSynced = const Value.absent(),
                Value<bool> isDeleted = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => KategoriTableCompanion.insert(
                id: id,
                nama: nama,
                tipe: tipe,
                updatedAt: updatedAt,
                isSynced: isSynced,
                isDeleted: isDeleted,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$KategoriTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $KategoriTableTable,
      KategoriTableData,
      $$KategoriTableTableFilterComposer,
      $$KategoriTableTableOrderingComposer,
      $$KategoriTableTableAnnotationComposer,
      $$KategoriTableTableCreateCompanionBuilder,
      $$KategoriTableTableUpdateCompanionBuilder,
      (
        KategoriTableData,
        BaseReferences<_$AppDatabase, $KategoriTableTable, KategoriTableData>,
      ),
      KategoriTableData,
      PrefetchHooks Function()
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$GajiTableTableTableManager get gajiTable =>
      $$GajiTableTableTableManager(_db, _db.gajiTable);
  $$PengeluaranTableTableTableManager get pengeluaranTable =>
      $$PengeluaranTableTableTableManager(_db, _db.pengeluaranTable);
  $$UtangTableTableTableManager get utangTable =>
      $$UtangTableTableTableManager(_db, _db.utangTable);
  $$KategoriTableTableTableManager get kategoriTable =>
      $$KategoriTableTableTableManager(_db, _db.kategoriTable);
}
