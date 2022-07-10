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
  @override
  Widget build(BuildContext context) {
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
