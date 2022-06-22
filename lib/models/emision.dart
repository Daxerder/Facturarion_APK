import 'package:flutter/material.dart';
import 'package:gofact/models/ingreso.dart';
import 'user.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Emision extends StatefulWidget {
  final FoB comprobante;
  Emision(this.comprobante);
  @override
  State<Emision> createState() => _Emision();
}

class _Emision extends State<Emision> {
  FoB comp = FoB();
  List _productos = [];

  @override
  void initState() {
    comp = this.widget.comprobante;
    getProd();

    print(comp.cliente.documento);
    super.initState();
  }

  void getProd() async {
    CollectionReference collectionReference =
        FirebaseFirestore.instance.collection("temporal");

    QuerySnapshot prod =
        await collectionReference.get(); //await porq es un future

    if (prod.docs.length != 0) {
      //docs cantidad de documentos
      for (var doc in prod.docs) {
        _productos.add(doc.data());
        print(_productos.length);
      }
    }

    for (var i = 0; i < _productos.length; i++) {
      delete(_productos[i]['id']);
    }
    emitir();
  }

  delete(borrar) {
    DocumentReference documentReference = FirebaseFirestore.instance
        .collection("temporal")
        .doc(borrar.toString());
    documentReference
        .delete()
        .then((value) => print("borrado id" + borrar.toString()))
        .catchError((error) => print("Fallo: $error"));
  }

  void emitir() {
    print("emitir");
    print(_productos.length);
    DocumentReference documentReference;
    print(comp.serie);
    if (comp.serie == 'F001') {
      print("entro a facura");
      documentReference = FirebaseFirestore.instance
          .collection("facturas")
          .doc(comp.correlativo.toString());
    } else {
      print("entro a boleta");
      documentReference = FirebaseFirestore.instance
          .collection("boletas")
          .doc(comp.correlativo.toString());
    }
    documentReference
        .set(
          {
            'serie': comp.serie,
            'correlativo': comp.correlativo,
            //'cliente': comp.cliente,
            'empresa': comp.cliente.empresa,
            'documento': comp.cliente.documento,
            'direccion': comp.cliente.direccion,
            'f_emi': comp.f_emi,
            'f_venc': comp.f_venc,
            'productos': _productos,
            'moneda': comp.moneda,
          },
          SetOptions(merge: false),
        )
        .catchError((error) => print("falla $error"))
        .whenComplete(() => print("exito"));
  }

  @override
  Widget build(BuildContext context) {
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
                  MaterialPageRoute(
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
          title: Text("Generar"),
        ),
        drawer: Drawer(
          child: lista,
        ),
        body: Center(
          child: Container(
            height: 250,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Column(
              children: [
                SizedBox(
                  height: 200,
                  width: 200,
                  child: Column(
                    children: [
                      Container(
                        height: 150,
                        child: Icon(
                          Icons.check_circle,
                          color: Colors.green,
                          size: 100,
                        ),
                      ),
                      Container(
                        alignment: Alignment.center,
                        //height: 50,
                        child: Text(
                          "Emitido con Exito",
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ],
                  ),
                ),
                ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pushNamed("/inicio");
                    },
                    child: Text("INICIO"))
              ],
            ),
          ),
        ),
      ),
    );
  }
}
