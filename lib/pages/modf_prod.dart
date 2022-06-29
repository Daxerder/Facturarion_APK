import 'package:flutter/material.dart';
import 'package:gofact/db/sqlite.dart';
import 'package:gofact/models/clases.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Modf_Producto extends StatefulWidget {
  final Producto producto;
  Modf_Producto(this.producto);
  @override
  State<Modf_Producto> createState() => _Modf_Producto();
}

class _Modf_Producto extends State<Modf_Producto> {
  Producto _lista = Producto();
  @override
  void initState() {
    _lista.id = this.widget.producto.id;
    _producto.text = this.widget.producto.descripcion;
    _cantidad.text = this.widget.producto.cantidad.toString();
    _precio.text = this.widget.producto.total.toString();
    super.initState();
  }

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
                    _lista.cantidad = double.parse(_cantidad.text);
                    _lista.total = double.parse(_precio.text);
                    DB.db.updateProducto(_lista, _lista.id);
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
}
