import 'package:flutter/material.dart';
import 'package:gofact/models/pdf_api.dart';
import 'package:gofact/pages/ingreso.dart';
import 'dart:io';

class DescargarPDF extends StatefulWidget {
  final File file;
  DescargarPDF(this.file);

  @override
  State<DescargarPDF> createState() => _DescargarPDFState();
}

class _DescargarPDFState extends State<DescargarPDF> {
  void initState() {}

  @override
  Widget build(BuildContext context) {
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
        appBar: AppBar(title: const Center(child: Text("Documento Emitido"))),
        body: Center(
          child: IntrinsicHeight(
            child: Container(
              //height: double.infinity,
              //constraints: const BoxConstraints(maxHeight: double.infinity),
              margin: const EdgeInsets.symmetric(horizontal: 50),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                children: [
                  Container(
                    height: 150,
                    child: const Icon(
                      Icons.check_circle,
                      color: Colors.green,
                      size: 100,
                    ),
                  ),
                  Container(
                    alignment: Alignment.center,
                    //height: 50,
                    child: const Text(
                      "Emitido con Exito",
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      Expanded(
                        child: MaterialButton(
                            /*shape:const  RoundedRectangleBorder(
                            borderRadius: BorderRadius.only(
                                bottomRight: Radius.circular(30)),
                          ),*/
                            color: Colors.green,
                            onPressed: () {
                              PdfApi.openFile(this.widget.file);
                            },
                            child: const Text("Visualizar")),
                      ),
                      Expanded(
                        child: MaterialButton(
                            color: Colors.blue,
                            onPressed: () {
                              Navigator.of(context).pushNamedAndRemoveUntil(
                                  "/inicio", (route) => false);
                            },
                            child: const Text("INICIO")),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
