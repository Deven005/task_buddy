import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../../models/task/task_model.dart';
import '../../service/notification/notification_service.dart';

class DatabaseHelper {
  // Private constructor for singleton
  DatabaseHelper._internal();

  // The singleton instance
  static final DatabaseHelper instance = DatabaseHelper._internal();

  // SQLite Database reference
  static Database? _database;
  final taskTableName = 'tasks';
  late final String path;

  // Getter for database instance
  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  // Initialize the database
  Future<Database> _initDatabase() async {
    path = join(await getDatabasesPath(), 'tasks.db');
    // await deleteDatabaseFile();
    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE tasks(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            title TEXT NOT NULL,
            description TEXT NOT NULL,
            startTime TEXT NOT NULL,
            endTime TEXT NOT NULL,
            priority TEXT NOT NULL,
            isCompleted INTEGER NOT NULL,
            category TEXT,
            tags TEXT,
            notes TEXT,
            createdAt TEXT NOT NULL,
            updatedAt TEXT NOT NULL
          )
        ''');
      },
    );
  }

  // Add a task to the database
  Future<int> addTask(Task task) async {
    final db = await database;
    var newTask = task.toMap();
    newTask.remove('id');
    return await db.insert(
      taskTableName,
      newTask,
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> updateTask(Task task) async {
    final db = await database;
    // Update the given Task.
    await db.update(
      taskTableName,
      task.toMap(),
      // Ensure that the Task has a matching id.
      where: 'id = ?',
      // Pass the task's id as a whereArg to prevent SQL injection.
      whereArgs: [task.id],
    );
  }

  Future<int> deleteTask(int id) async {
    final db = await database;
    return await db.delete(
      taskTableName,
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // Fetch all tasks from the database
  Future<List<Task>> getTasks() async {
    final db = await database;
    final List<Map<String, dynamic>> taskMaps = await db.query(taskTableName);
    return taskMaps.map((map) => Task.fromMap(map)).toList();
  }

  Future<void> deleteDatabaseFile() async {
    final file = File(path);

    if (await file.exists()) {
      await file.delete();
      debugPrint('Database file deleted.');
    } else {
      debugPrint('Database file does not exist.');
    }
  }
}
