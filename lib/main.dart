import 'package:flutter/material.dart';
import 'package:gofact/pages/generar.dart';
import 'package:gofact/pages/ingreso.dart';
import 'package:gofact/pages/inicio.dart';
import 'package:gofact/pages/reg_empresa.dart';
import 'package:gofact/pages/reporte.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:gofact/providers/list_prod.dart';
import 'package:provider/provider.dart';
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
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => new ProductoProvider()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        routes: <String, WidgetBuilder>{
          Ingreso.ruta: (BuildContext context) => Ingreso(),
          Inicio.ruta: (BuildContext context) => Inicio(),
          Reporte.ruta: (BuildContext context) => Reporte(),
          Generar.ruta: (BuildContext context) => Generar(),
          Registrar.ruta: (BuildContext context) => Registrar(),
          //Visualizacion.ruta: (BuildContext context) => Visualizacion(),
        },
        initialRoute: "/ingreso",
      ),
    );
  }
}
