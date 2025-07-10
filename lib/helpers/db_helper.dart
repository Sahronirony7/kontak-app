import 'dart:async';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/contact.dart';

class DBHelper {
  static final DBHelper _instance = DBHelper._internal();
  factory DBHelper() => _instance;

  DBHelper._internal();

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await _initDB();
    return _database!;
  }

  Future<Database> _initDB() async {
    var dbPath = await getDatabasesPath();
    var path = join(dbPath, 'contacts.db');
    return await openDatabase(path, version: 1, onCreate: _createDb);
  }

  void _createDb(Database db, int version) async {
    await db.execute('''
      CREATE TABLE contacts (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        firstName TEXT,
        lastName TEXT,
        phoneNumber TEXT,
        email TEXT,
        address TEXT,
        photo TEXT
      )
    ''');
  }

  Future<List<Contact>> getContacts() async {
    final db = await database;
    var result = await db.query('contacts');
    return result.map((e) => Contact.fromMap(e)).toList();
  }

  Future<void> insertContact(Contact contact) async {
    final db = await database;
    await db.insert('contacts', contact.toMap());
  }

  Future<void> updateContact(Contact contact) async {
    final db = await database;
    await db.update(
      'contacts',
      contact.toMap(),
      where: 'id = ?',
      whereArgs: [contact.id],
    );
  }

  Future<void> deleteContact(int id) async {
    final db = await database;
    await db.delete('contacts', where: 'id = ?', whereArgs: [id]);
  }
}
