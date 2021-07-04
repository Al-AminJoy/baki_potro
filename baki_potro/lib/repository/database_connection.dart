import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseConnection {
  setDatabase() async {
    var directory = await getApplicationDocumentsDirectory();
    var path = join(directory.path, 'db.todoList');
    var database =
        await openDatabase(path, version: 1, onCreate: _onCreatingDatabase);
    return database;
  }

  _onCreatingDatabase(Database database, int version) async {
    await database
        .execute("CREATE TABLE categories(id INTEGER PRIMARY KEY, name TEXT)");
    await database.execute(
        "CREATE TABLE suppliers(supplier_id INTEGER PRIMARY KEY, supplier_name TEXT, supplier_number TEXT, supplier_location TEXT)");
    await database.execute(
        "CREATE TABLE customers(customer_id INTEGER PRIMARY KEY, customer_name TEXT, customer_number TEXT, customer_location TEXT)");
    await database.execute(
        "CREATE TABLE products(product_id INTEGER PRIMARY KEY, product_name TEXT, price REAL, quantity REAL, category TEXT)");
    await database.execute(
        "CREATE TABLE sells(sell_id INTEGER PRIMARY KEY, customer_name TEXT, amount REAL, bill_type INTEGER,date TEXT, customer_id INTEGER, description TEXT, category TEXT)");
    await database.execute(
        "CREATE TABLE buys(buy_id INTEGER PRIMARY KEY, supplier_name TEXT, amount REAL, bill_type INTEGER,date TEXT, supplier_id INTEGER, description TEXT, category TEXT)");
  }
}
