import 'package:flutter/material.dart';
import 'package:gofact/models/user.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Crear_Producto extends StatefulWidget {
  final int contador;
  Crear_Producto(this.contador);
  @override
  State<Crear_Producto> createState() => _Crear_Producto();
}

class _Crear_Producto extends State<Crear_Producto> {
  @override
  var cont;
  void initState() {
    cont = this.widget.contador;
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
          title: Text("Reportes"),
        ),
        body: Padding(
          padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
          child: Column(
            children: [
              TextFormField(
                autofocus: true,
                decoration: InputDecoration(
                    labelText: 'Producto',
                    labelStyle: TextStyle(color: Colors.white)),
                style: TextStyle(color: Colors.white),
                controller: _producto,
              ),
              TextFormField(
                autofocus: true,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                    labelText: 'Cantidad',
                    labelStyle: TextStyle(color: Colors.white)),
                style: TextStyle(color: Colors.white),
                controller: _cantidad,
              ),
              TextFormField(
                autofocus: true,
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
                    cont++;
                    print(cont);

                    Navigator.of(context).pop(cont);
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
    DocumentReference documentReference =
        FirebaseFirestore.instance.collection("temporal").doc(cont.toString());

    documentReference
        .set(
          {
            "id": cont,
            "cantidad": temporal.cantidad,
            "descripcion": temporal.descripcion,
            "total": temporal.total
          },
          SetOptions(merge: false),
        )
        .catchError((error) => print("falla $error"))
        .whenComplete(() => print("exito"));
  }
}
