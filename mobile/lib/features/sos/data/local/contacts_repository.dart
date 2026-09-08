import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../domain/models/emergency_contact.dart';

class ContactsRepository {
  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('contacts.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);
    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future _createDB(Database db, int version) async {
    await db.execute('''
CREATE TABLE contacts (
  id TEXT PRIMARY KEY,
  name TEXT,
  phone_number TEXT,
  relationship TEXT,
  priority INTEGER
)
''');
  }

  Future<void> addContact(EmergencyContact contact) async {
    final db = await database;
    await db.insert('contacts', contact.toMap(), conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<List<EmergencyContact>> getContacts() async {
    final db = await database;
    final result = await db.query('contacts', orderBy: 'priority DESC');
    return result.map((e) => EmergencyContact.fromMap(e)).toList();
  }

  Future<void> deleteContact(String id) async {
    final db = await database;
    await db.delete('contacts', where: 'id = ?', whereArgs: [id]);
  }
}
