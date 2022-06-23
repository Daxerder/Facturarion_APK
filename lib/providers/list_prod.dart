import 'package:flutter/material.dart';
import 'package:gofact/models/clases.dart';
import 'package:gofact/db/sqlite.dart';

class ProductoProvider extends ChangeNotifier {
  List<Producto> productos = [];

  Future<Producto> newProducto(Producto valor) async {
    final producto = new Producto(
        cantidad: valor.cantidad,
        descripcion: valor.descripcion,
        total: valor.total);
    final id = await DB.db.nuevoProducto(producto);
    producto.id = id!;
    this.productos.add(producto);
    notifyListeners();
    return producto;
  }

  cargarProductos() async {
    final productos = await DB.db.getTodosProductos();
    this.productos = [...?productos];
    notifyListeners();
  }

  borrarTodosProductos() async {
    await DB.db.deleteAllProductos();
    this.productos = [];
    notifyListeners();
  }

  borrarProductoXID(int id) async {
    await DB.db.deleteProducto(id);
    notifyListeners();
  }
}
