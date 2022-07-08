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
      decoration: const BoxDecoration(
        image: DecorationImage(
            image: AssetImage('assets/fondo.jpg'), fit: BoxFit.cover),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          title: const Text("Reportes"),
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
                  decoration: const InputDecoration(
                      labelText: 'Producto',
                      labelStyle: TextStyle(color: Colors.white)),
                  style: TextStyle(color: Colors.white),
                  controller: _producto,
                  validator: (value) {
                    String text = value.toString();
                    //print(text.contains(RegExp(r"[a-z]"), 1));
                  },
                ),
                TextFormField(
                  autofocus: true,
                  keyboardType: TextInputType.number,
                  maxLength: 3,
                  decoration: const InputDecoration(
                      labelText: 'Cantidad',
                      labelStyle: TextStyle(color: Colors.white)),
                  style: const TextStyle(color: Colors.white),
                  controller: _cantidad,
                ),
                TextFormField(
                  autofocus: true,
                  keyboardType: TextInputType.number,
                  maxLength: 6,
                  decoration: const InputDecoration(
                      labelText: 'Precio',
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
                    //print(validar_precio(_precio.text));
                    //print(texto.contains(RegExp(r"[a-z]")));
                    //print("entro al pressed");
                    if (_producto.text != '' &&
                        _cantidad.text != '' &&
                        _precio.text != '') {
                      ////////////////
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

                        /*print("entro al if");
                        print(_lista.cantidad);*/

                        final proListProvider = Provider.of<ProductoProvider>(
                            context,
                            listen: false);
                        final producto = await ProductoProvider()
                            .newProducto(_lista)
                            .then((value) => print(_lista))
                            .catchError((e) => print("error: $e"));
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
    for (var i = 0; i < palabra.length; i++) {
      if (!texto[i].contains(RegExp(r"[a-záéíóúüñA-ZÑ0-9 ]"))) {
        return false;
      }
    }
    /*palabra = palabra.replaceAll(
        "\\s{2,}", " "); //reemplaza 2 espacios o mas en blanco por 1 solo*/
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
    for (var i = 0; i < palabra.length; i++) {
      if (!texto[i].contains(RegExp(r"[0-9]"))) {
        return false;
      }
    }

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
      if (!texto[i].contains(RegExp(r"[0-9.]"))) {
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
