import 'package:flutter/material.dart';
import 'package:gofact/pages/ingreso.dart';

Widget list_view(context) {
  return ListView(
    children: [
      const DrawerHeader(
        decoration: BoxDecoration(
            image: DecorationImage(
          fit: BoxFit.cover,
          image: AssetImage('assets/chanchito.jpeg'),
        )
            //color: Colors.transparent,
            ),
        child: Center(
          child: Text(
            'GO FACT',
            style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
          ),
        ),
      ),
      ListTile(
        leading: const Icon(Icons.home),
        title: const Text("Inicio"),
        onTap: () {
          Navigator.of(context)
              .pushNamedAndRemoveUntil("/inicio", (route) => false);
        },
      ),
      ListTile(
        leading: const Icon(Icons.app_registration),
        title: const Text("Registrar Empresa"),
        onTap: () {
          Navigator.of(context)
              .pushNamedAndRemoveUntil("/registrar", (route) => false);
        },
      ),
      ListTile(
        leading: const Icon(Icons.add),
        title: const Text("Generar Documento"),
        onTap: () {
          Navigator.of(context)
              .pushNamedAndRemoveUntil("/generar", (route) => false);
        },
      ),
      ListTile(
        leading: const Icon(Icons.book),
        title: const Text("Reporte de Ventas"),
        onTap: () {
          Navigator.of(context)
              .pushNamedAndRemoveUntil("/reporte", (route) => false);
        },
      ),
      ListTile(
        leading: const Icon(Icons.exit_to_app),
        title: const Text("Cerrar Sesion"),
        onTap: () {
          Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(builder: (BuildContext context) => Ingreso()),
              (route) => false);
        },
      ),
    ],
  );
}
