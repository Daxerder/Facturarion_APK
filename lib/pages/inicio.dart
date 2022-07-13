import 'package:flutter/material.dart';
import 'package:gofact/db/sqlite.dart';
import 'package:gofact/funciones/list_view.dart';
import 'package:gofact/models/clases.dart';

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
    //DB.db.database;
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
        body: Column(children: [
          const SizedBox(height: 50),
          Center(
            //padding: EdgeInsets.symmetric(horizontal: 50, vertical: 20),
            child: Container(
              height: 300,
              width: 300,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  image: const DecorationImage(
                    fit: BoxFit.cover,
                    image: AssetImage('assets/chanchito.jpeg'),
                  )), /*child: const Text("")*/
            ),
          ),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 50, horizontal: 20),
            child: Text(
              "App que facilita la emision de comprobantes de pagos electronicos",
              style: TextStyle(color: Colors.white, fontSize: 20),
              textAlign: TextAlign.center,
            ),
          ),
        ]),
      ),
    );
  }
}
