import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../domain/models/sos_payload.dart';

class SosLocalQueue {
  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('sos_queue.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future _createDB(Database db, int version) async {
    await db.execute('''
CREATE TABLE sos_queue (
  sosId TEXT PRIMARY KEY,
  latitude REAL,
  longitude REAL,
  batteryLevel INTEGER,
  voiceMessagePath TEXT,
  voiceToTextTranscription TEXT,
  status TEXT,
  timestamp TEXT
)
''');
  }

  Future<void> queueSos(SosPayload payload) async {
    final db = await database;
    await db.insert('sos_queue', payload.toMap(), conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<List<SosPayload>> getPendingSos() async {
    final db = await database;
    final result = await db.query('sos_queue', where: 'status = ?', whereArgs: ['PENDING']);
    return result.map((e) => SosPayload.fromMap(e)).toList();
  }

  Future<void> updateSosStatus(String sosId, String status) async {
    final db = await database;
    await db.update('sos_queue', {'status': status}, where: 'sosId = ?', whereArgs: [sosId]);
  }
}
