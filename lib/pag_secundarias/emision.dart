import 'package:flutter/material.dart';
import 'package:gofact/db/sqlite.dart';
import 'package:gofact/models/pdf_api.dart';
import 'package:gofact/pag_secundarias/downloads.dart';
import 'package:webview_flutter/webview_flutter.dart';
import '../models/clases.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Emision extends StatefulWidget {
  final FoB comprobante;
  final List<Producto> prod;
  Emision(this.comprobante, this.prod);
  @override
  State<Emision> createState() => _Emision();
}

class _Emision extends State<Emision> {
  late WebViewController controller;
  FoB comp = FoB();
  List _productos = [];

  @override
  void initState() {
    comp = this.widget.comprobante;
    //_productos = this.widget.prod;
    arraymap();
    emitir();
    super.initState();
  }

  arraymap() {
    for (var i = 0; i < this.widget.prod.length; i++) {
      Map<String, dynamic> producto = {
        'descripcion': this.widget.prod[i].descripcion,
        'cantidad': this.widget.prod[i].cantidad,
        'total': this.widget.prod[i].total,
      };
      setState(() {
        _productos.add(producto);
      });
    }
  }

  void emitir() async {
    comp.correlativo = await correlativo();
    DocumentReference documentReference;
    if (comp.serie == 'F001') {
      documentReference = FirebaseFirestore.instance
          .collection("facturas")
          .doc(comp.correlativo.toString());
    } else {
      documentReference = FirebaseFirestore.instance
          .collection("boletas")
          .doc(comp.correlativo.toString());
    }
    var arch = await PdfApi.generar(comp, this.widget.prod);
    documentReference.set(
      {
        'serie': comp.serie,
        'correlativo': comp.correlativo,
        //'cliente': comp.cliente,
        'empresa': comp.cliente.empresa,
        'documento': comp.cliente.documento,
        'direccion': comp.cliente.direccion,
        'f_emi': comp.f_emi,
        'f_venc': comp.f_venc,
        //_productos map
        'productos': _productos,
        'moneda': comp.moneda,
        'url': arch.url,
      },
      SetOptions(merge: false),
    ).whenComplete(() async {
      DB.db.deleteAllProductos();
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(
              builder: (BuildContext context) => DescargarPDF(arch.pdf)),
          (route) => false);
      //PdfApi.openFile(arch.pdf);
    });
  }

  Future<int> correlativo() async {
    if (comp.serie == 'F001') {
      CollectionReference facturas =
          FirebaseFirestore.instance.collection("facturas");
      QuerySnapshot fact = await facturas.get();
      return fact.docs.length + 1;
    } else {
      CollectionReference boletas =
          FirebaseFirestore.instance.collection("boletas");
      QuerySnapshot bol = await boletas.get();
      return bol.docs.length + 1;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
            image: AssetImage('assets/fondo.jpg'), fit: BoxFit.cover),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          title: const Text("Generar Documento"),
        ),
        body: Center(
          child: Container(
            height: 200,
            width: 200,
            child: Card(
              color: Colors.white,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const <Widget>[
                  CircularProgressIndicator(),
                  SizedBox(height: 50.0),
                  Text("Emitiendo Documento"),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
