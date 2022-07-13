import 'package:flutter/material.dart';
import 'package:gofact/pages/generar.dart';
import 'package:gofact/pages/ingreso.dart';
import 'package:gofact/pages/inicio.dart';
import 'package:gofact/pages/empresas.dart';
import 'package:gofact/pages/reporte.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Firebase.initializeApp().then((value) {
    runApp(const MyApp());
  });
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      routes: <String, WidgetBuilder>{
        Ingreso.ruta: (BuildContext context) => Ingreso(),
        Inicio.ruta: (BuildContext context) => Inicio(),
        Reporte.ruta: (BuildContext context) => Reporte(),
        Generar.ruta: (BuildContext context) => Generar(),
        Empresas.ruta: (BuildContext context) => Empresas(),
      },
      initialRoute: "/ingreso",
    );
  }
}
