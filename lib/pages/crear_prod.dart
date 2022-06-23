import 'package:flutter/material.dart';
import 'package:gofact/models/clases.dart';
import 'package:gofact/providers/list_prod.dart';
import 'package:provider/provider.dart';
import 'package:path_provider/path_provider.dart';

class Crear_Producto extends StatefulWidget {
  @override
  State<Crear_Producto> createState() => _Crear_Producto();
}

class _Crear_Producto extends State<Crear_Producto> {
  @override
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
                onPressed: () async {
                  print("entro al pressed");
                  if (_producto.text != '' &&
                      _cantidad.text != '' &&
                      _precio.text != '') {
                    _lista.descripcion = _producto.text;
                    _lista.cantidad = int.parse(_cantidad.text);
                    _lista.total = double.parse(_precio.text);

                    print("entro al if");
                    print(_lista.cantidad);

                    final proListProvider =
                        Provider.of<ProductoProvider>(context, listen: false);
                    final producto = await ProductoProvider()
                        .newProducto(_lista)
                        .then((value) => print(_lista))
                        .catchError((e) => print("error: $e"));
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
