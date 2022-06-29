import 'package:flutter/material.dart';
import 'package:gofact/db/sqlite.dart';
import 'ingreso.dart';

class Inicio extends StatefulWidget {
  static const String ruta = "/inicio";
  @override
  State<Inicio> createState() => _Inicio();
}

class _Inicio extends State<Inicio> {
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
            child: Text('Pacman 22'),
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
              Navigator.of(context).pushNamed("/inicio");
            });
          },
        ),
        ListTile(
          leading: Icon(Icons.add),
          title: Text("Generar"),
          onTap: () {
            setState(() {
              Navigator.of(context).pushNamed("/generar");
            });
          },
        ),
        ListTile(
          leading: Icon(Icons.book),
          title: Text("Reporte"),
          onTap: () {
            setState(() {
              Navigator.of(context).pushNamed("/reporte");
            });
          },
        ),
        ListTile(
          leading: Icon(Icons.app_registration),
          title: Text("Registrar"),
          onTap: () {
            setState(() {
              Navigator.of(context).pushNamed("/registrar");
            });
          },
        ),
        ListTile(
          leading: Icon(Icons.exit_to_app),
          title: Text("Cerrar Sesion"),
          onTap: () {
            setState(() {
              Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute<Null>(
                      builder: (BuildContext context) => Ingreso()),
                  (route) => false);
            });
          },
        ),
      ],
    );
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
            image: AssetImage('assets/fondo.jpg'), fit: BoxFit.cover),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          title: Text("Inicio"),
        ),
        drawer: Drawer(
          child: lista,
        ),
      ),
    );
  }
}
