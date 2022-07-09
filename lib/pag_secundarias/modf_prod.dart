import 'package:flutter/material.dart';
import 'package:gofact/db/sqlite.dart';
import 'package:gofact/models/clases.dart';

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
    _cantidad.text = this.widget.producto.cantidad.toStringAsFixed(0);
    _precio.text = this.widget.producto.total.toStringAsFixed(2);
    super.initState();
  }

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
          title: const Text("Modificar Producto"),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
            child: Column(
              children: [
                TextFormField(
                  maxLength: 20,
                  decoration: const InputDecoration(
                      labelText: 'Producto',
                      labelStyle: TextStyle(color: Colors.white)),
                  style: const TextStyle(color: Colors.white),
                  controller: _producto,
                ),
                TextFormField(
                  maxLength: 3,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                      labelText: 'Cantidad',
                      labelStyle: TextStyle(color: Colors.white)),
                  style: const TextStyle(color: Colors.white),
                  controller: _cantidad,
                ),
                TextFormField(
                  maxLength: 4,
                  keyboardType: TextInputType.number,
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
                  onPressed: () {
                    if (_producto.text != '' &&
                        _cantidad.text != '' &&
                        _precio.text != '') {
                      if (!validar_text(_producto.text)) {
                        SnackBar snack = const SnackBar(
                          content: Text('Error en campo Producto'),
                        );
                        ScaffoldMessenger.of(context).showSnackBar(snack);
                      } else if (!validar_cant(_cantidad.text)) {
                        SnackBar snack = const SnackBar(
                          content: Text('Error en campo Cantidad'),
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
                        DB.db.updateProducto(_lista, _lista.id);
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
    palabra = palabra.trim();
    for (var i = 0; i < palabra.length; i++) {
      if (!texto[i].contains(RegExp(r"[a-záéíóúüñA-ZÑ1-9 ]"))) {
        return false;
      }
    }
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

  bool validar_cant(String texto) {
    String palabra = texto;
    palabra = palabra.trim();
    setState(() {
      _cantidad.text = palabra;
    });
    for (var i = 0; i < palabra.length; i++) {
      if (!palabra[i].contains(RegExp(r"[0-9]"))) {
        return false;
      }
    }
    return true;
  }

  bool validar_precio(String texto) {
    var pos;
    bool punto = false;
    String palabra = texto;
    palabra = palabra.trim();
    setState(() {
      _precio.text = palabra;
    });
    for (var i = 0; i < palabra.length; i++) {
      if (palabra[i] == '.') {
        if (palabra[i] == '.') {
          if (!punto) {
            pos = i;
            punto = true;
          } else {
            return false;
          }
        }
      }
      if (!palabra[i].contains(RegExp(r"[0-9.]"))) {
        return false;
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
}
