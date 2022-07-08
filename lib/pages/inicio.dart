import 'package:flutter/material.dart';
import 'package:gofact/db/sqlite.dart';
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

    ListView lista = ListView(
      children: [
        const DrawerHeader(
          decoration: BoxDecoration(
            color: Colors.transparent,
          ),
          child: Center(
            child: Text('Facturacion Electronica'),
          ),
        ),
        /*AboutListTile(
          child: Text("facturacion"),
          applicationIcon: Icon(Icons.favorite),
          applicationVersion: "v 10.1",
          applicationName: "Demo Drawer",
          icon: Icon(Icons.info),
        ),*/
        ListTile(
          leading: const Icon(Icons.home),
          title: const Text("Inicio"),
          onTap: () {
            setState(() {
              Navigator.of(context)
                  .pushNamedAndRemoveUntil("/inicio", (route) => false);
            });
          },
        ),
        ListTile(
          leading: const Icon(Icons.add),
          title: const Text("Generar"),
          onTap: () {
            setState(() {
              Navigator.of(context)
                  .pushNamedAndRemoveUntil("/generar", (route) => false);
            });
          },
        ),
        ListTile(
          leading: const Icon(Icons.book),
          title: const Text("Reporte"),
          onTap: () {
            setState(() {
              Navigator.of(context)
                  .pushNamedAndRemoveUntil("/reporte", (route) => false);
            });
          },
        ),
        ListTile(
          leading: const Icon(Icons.app_registration),
          title: const Text("Registrar Empresa"),
          onTap: () {
            setState(() {
              Navigator.of(context)
                  .pushNamedAndRemoveUntil("/registrar", (route) => false);
            });
          },
        ),
        ListTile(
          leading: const Icon(Icons.exit_to_app),
          title: const Text("Cerrar Sesion"),
          onTap: () {
            setState(() {
              Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(
                      builder: (BuildContext context) => Ingreso()),
                  (route) => false);
            });
          },
        ),
      ],
    );
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
          child: lista,
        ),
      ),
    );
  }
}
