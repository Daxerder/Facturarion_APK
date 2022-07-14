import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gofact/db/sqlite.dart';
import 'package:gofact/models/clases.dart';

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
      decoration: const BoxDecoration(
        image: DecorationImage(
            image: AssetImage('assets/fondo.jpg'), fit: BoxFit.cover),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          title: const Text("Ingresar Producto"),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
            child: Column(
              children: [
                TextFormField(
                  autofocus: true,
                  keyboardType: TextInputType.text,
                  maxLength: 20,
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp("[a-zA-Z0-9 .]")),
                  ],
                  decoration: const InputDecoration(
                      labelText: 'Producto',
                      labelStyle: TextStyle(color: Colors.white)),
                  style: const TextStyle(color: Colors.white),
                  controller: _producto,
                  onChanged: (value) {
                    _producto.value = TextEditingValue(
                        text: value.toUpperCase(),
                        selection: _producto.selection);
                  },
                ),
                TextFormField(
                  autofocus: true,
                  keyboardType: TextInputType.number,
                  maxLength: 3,
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp("[0-9]")),
                  ],
                  decoration: const InputDecoration(
                      labelText: 'Cantidad',
                      labelStyle: TextStyle(color: Colors.white)),
                  style: const TextStyle(color: Colors.white),
                  controller: _cantidad,
                ),
                TextFormField(
                  autofocus: true,
                  keyboardType: TextInputType.number,
                  maxLength: 5,
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp("[0-9.]")),
                  ],
                  decoration: const InputDecoration(
                      labelText: 'Precio Unitario',
                      labelStyle: TextStyle(color: Colors.white)),
                  style: const TextStyle(color: Colors.white),
                  controller: _precio,
                ),
                TextButton(
                  child: const Text(
                    "Registrar Compra",
                    style: TextStyle(color: Colors.white),
                  ),
                  style: TextButton.styleFrom(backgroundColor: Colors.blue),
                  onPressed: () async {
                    if (_producto.text != '' &&
                        _cantidad.text != '' &&
                        _precio.text != '') {
                      if (!validar_text(_producto.text)) {
                        SnackBar snack = const SnackBar(
                          content: Text('Error en campo Producto'),
                        );
                        ScaffoldMessenger.of(context).showSnackBar(snack);
                      } else if (!validar_precio(_precio.text)) {
                        SnackBar snack = const SnackBar(
                          content: Text('Error en campo Precio'),
                        );
                        ScaffoldMessenger.of(context).showSnackBar(snack);
                      } else {
                        _lista.descripcion = _producto.text;
                        _lista.cantidad = double.parse(_cantidad.text);
                        _lista.total = double.parse(_precio.text);
                        await DB.db.nuevoProducto(_lista);
                        Navigator.of(context).pop();
                      }
                    } else {
                      SnackBar snack = const SnackBar(
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
      ),
    );
  }

  bool validar_text(String texto) {
    String palabra = texto;
    String nueva = '';
    palabra = palabra.trim(); //reemplaza al incio y al final los espacios

    //reemplaza 2 espacios o mas en blanco por 1 solo
    for (var i = 0; i < palabra.length; i++) {
      if (palabra[i] != ' ') {
        nueva = nueva + palabra[i];
        //si la sig posicion es menor a la long total de la palabra te aumenta 1
        //espacio
        if (i + 1 < palabra.length) {
          if (palabra[i + 1] == ' ') {
            nueva = nueva + ' ';
          }
        }
      }
    }
    setState(() {
      _producto.text = nueva;
    });
    return true;
  }

  bool validar_precio(String texto) {
    var pos;
    bool punto = false;
    String palabra = texto;
    for (var i = 0; i < palabra.length; i++) {
      if (texto[i] == '.') {
        if (!punto) {
          pos = i;
          punto = true;
        } else {
          return false;
        }
      }
    }
    if (pos == 0) {
      setState(() {
        _precio.text = '0' + texto;
      });
    }
    //redondear
    double num = double.parse(_precio.text);
    setState(() {
      _precio.text = num.toStringAsFixed(2);
    });
    return true;
  }

  /* String funcion(valor) {
    String nuevo = valor.toString().toUpperCase();
    return nuevo;
  }*/
}
