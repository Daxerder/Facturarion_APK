import 'dart:io';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:gofact/models/clases.dart';

class DB {
  static Database? _database;
  static final DB db = DB._();

  DB._();

  Future<Database?> get database async {
    if (_database != null) return _database;

    _database = await initDB();
    return _database;
  }

  Future<Database> initDB() async {
    Directory documento = await getApplicationDocumentsDirectory();
    final path = join(documento.path, 'Pro.db');
    print('Dirección de base de datos');
    print(path);

    return await openDatabase(path, version: 1, onOpen: (db) {},
        onCreate: (Database db, int version) async {
      await db.execute(''' CREATE TABLE Productos(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        descripcion TEXT,
        cantidad NUMERIC,
        total NUMERIC
        )''');
    });
  }

  Future<int?> nuevoProductoRaw(Producto producto) async {
    final id = producto.id;
    final descripcion = producto.descripcion;
    final cantidad = producto.cantidad;
    final total = producto.total;
    final db = await database;

    final resp = await db?.rawInsert(
        '''INSERT INTO Productos (descripcion,cantidad,total) VALUES ('$descripcion','$cantidad','$total')''');
    return resp;
  }

  Future<int?> nuevoProducto(Producto producto) async {
    final db = await database;
    final resp = await db?.insert('Productos', producto.toJson());
    return resp;
  }

  Future<Producto?> getProductoId(int id) async {
    final db = await database;
    final resp = await db?.query('Productos', where: 'id=?', whereArgs: [id]);
    return resp!.isNotEmpty ? Producto.fromJson(resp.first) : null;
  }

  Future<List<Producto>?> getTodosProductos() async {
    final db = await database;
    final resp = await db?.query('Productos');

    return resp!.isEmpty ? resp.map((e) => Producto.fromJson(e)).toList() : [];
  }

  Future<int?> updateProducto(Producto producto, id) async {
    final db = await database;
    final resp = await db?.update('Productos', producto.toJson(),
        where: 'id=?', whereArgs: [id]);
    return resp;
  }

  Future<int?> deleteProducto(int id) async {
    final db = await database;
    final resp = await db?.delete('Productos', where: 'id=?', whereArgs: [id]);
    return resp;
  }

  Future<int?> deleteAllProductos() async {
    final db = await database;
    final resp = await db?.rawDelete('''DELETE FROM Productos''');
    return resp;
  }
}
