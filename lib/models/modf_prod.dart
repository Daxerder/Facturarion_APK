import 'package:flutter/material.dart';
import 'package:gofact/models/user.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Modf_Producto extends StatefulWidget {
  final documento;
  Modf_Producto(this.documento);
  @override
  State<Modf_Producto> createState() => _Modf_Producto();
}

class _Modf_Producto extends State<Modf_Producto> {
  @override
  var doc;
  void initState() {
    doc = this.widget.documento;
    _producto.text = doc['descripcion'];
    _cantidad.text = doc['cantidad'].toString();
    _precio.text = doc['total'].toString();
    super.initState();
  }

  Producto _lista = Producto();

  var _producto = TextEditingController(),
      _cantidad = TextEditingController(),
      _precio = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
            image: AssetImage('assets/fondo.jpg'), fit: BoxFit.cover),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          title: Text("Modificar"),
        ),
        body: Padding(
          padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
          child: Column(
            children: [
              TextFormField(
                decoration: InputDecoration(
                    labelText: 'Producto',
                    labelStyle: TextStyle(color: Colors.white)),
                style: TextStyle(color: Colors.white),
                controller: _producto,
              ),
              TextFormField(
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                    labelText: 'Cantidad',
                    labelStyle: TextStyle(color: Colors.white)),
                style: TextStyle(color: Colors.white),
                controller: _cantidad,
              ),
              TextFormField(
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                    labelText: 'Precio',
                    labelStyle: TextStyle(color: Colors.white)),
                style: TextStyle(color: Colors.white),
                controller: _precio,
              ),
              TextButton(
                child: Text(
                  "Registrar Compra",
                  style: TextStyle(color: Colors.white),
                ),
                style: TextButton.styleFrom(backgroundColor: Colors.blue),
                onPressed: () {
                  if (_producto.text != '' &&
                      _cantidad.text != '' &&
                      _precio.text != '') {
                    _lista.descripcion = _producto.text;
                    _lista.cantidad = int.parse(_cantidad.text);
                    _lista.total = double.parse(_precio.text);
                    temporal(_lista);

                    Navigator.of(context).pop();
                  } else {
                    SnackBar snack = SnackBar(
                      content: Text('Rellenar todos los campos'),
                    );
                    ScaffoldMessenger.of(context).showSnackBar(snack);
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  temporal(Producto temporal) {
    DocumentReference documentReference = FirebaseFirestore.instance
        .collection("temporal")
        .doc(doc['id'].toString());

    documentReference
        .update(
          {
            "id": doc['id'],
            "cantidad": temporal.cantidad,
            "descripcion": temporal.descripcion,
            "total": temporal.total
          },
        )
        .then((value) => print("Modificado"))
        .catchError((error) => print("fallo la modificacion: $error"));
  }
}
