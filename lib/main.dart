import 'package:flutter/material.dart';
import 'package:gofact/models/generar.dart';
import 'package:gofact/models/ingreso.dart';
import 'package:gofact/models/inicio.dart';
import 'package:gofact/models/reg_empresa.dart';
import 'package:gofact/models/reporte.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
//import 'package:flutter_app_certus/bd/mongodb.dart';
//import 'package:flutter_app_certus/models/visualizacion.dart';

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
      routes: <String, WidgetBuilder>{
        Ingreso.ruta: (BuildContext context) => Ingreso(),
        Inicio.ruta: (BuildContext context) => Inicio(),
        Reporte.ruta: (BuildContext context) => Reporte(),
        Generar.ruta: (BuildContext context) => Generar(),
        Registrar.ruta: (BuildContext context) => Registrar(),
        //Visualizacion.ruta: (BuildContext context) => Visualizacion(),
      },
      initialRoute: "/ingreso",
    );
  }
}
