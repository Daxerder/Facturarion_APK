import 'package:flutter/material.dart';
import 'package:gofact/db/sqlite.dart';
import 'package:gofact/funciones/list_view.dart';
import 'package:gofact/models/clases.dart';
import 'package:gofact/models/pdf_api.dart';
import 'package:gofact/pages/emision.dart';
import 'ingreso.dart';

class Inicio extends StatefulWidget {
  static const String ruta = "/inicio";
  @override
  State<Inicio> createState() => _Inicio();
}

class _Inicio extends State<Inicio> {
  FoB comprobante = FoB();
  List<Producto> _productos = [];
  @override
  Widget build(BuildContext context) {
    DB.db.database;
    //DB.db.getTodosProductos().then(print);

    return Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
            image: AssetImage('assets/fondo.jpg'), fit: BoxFit.cover),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          title: const Text("Inicio"),
        ),
        drawer: Drawer(
          child: list_view(context),
        ),
      ),
    );
  }
}
