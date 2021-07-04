import 'package:sqflite/sqflite.dart';
import 'database_connection.dart';

class Repository {
  DatabaseConnection _databaseConnection;

  Repository() {
    _databaseConnection = DatabaseConnection();
  }

  static Database _database;

  Future<Database> get database async {
    if (_database != null) return _database;
    _database = await _databaseConnection.setDatabase();
    return _database;
  }

  insertData(table, data) async {
    var connection = await database;
    return await connection.insert(table, data);
  }

  readData(table) async {
    var connection = await database;
    return await connection.query(table);
  }

  readDatById(table, fieldName, itemId) async {
    var connection = await database;
    return await connection
        .query(table, where: '$fieldName=?', whereArgs: [itemId]);
  }

  update(table, fieldName, data) async {
    var connection = await database;
    return await connection.update(table, data,
        where: '$fieldName=?', whereArgs: [data[fieldName]]);
  }

  deleteDatById(table, fieldName, itemId) async {
    var connection = await database;
    return await connection
        .rawDelete("DELETE FROM $table WHERE $fieldName= $itemId");
  }

  readDataByColumnName(table, column, columnValue) async {
    var connection = await database;
    return await connection
        .query(table, where: '$column=?', whereArgs: [columnValue]);
  }
}
