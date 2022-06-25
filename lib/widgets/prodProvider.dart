import 'package:flutter/material.dart';
import 'package:gofact/db/sqlite.dart';
import 'package:provider/provider.dart';
import 'package:gofact/providers/list_prod.dart';

class ProductWidget extends StatelessWidget {
  final String tipo;
  const ProductWidget({required this.tipo});
  @override
  Widget build(BuildContext context) {
    final prodListProvider = Provider.of<ProductoProvider>(context);
    final productos = prodListProvider.productos;
    var cons = productos.length;
    print("prouctos: $cons");
    if (productos.length != 0) {
      return ListView.builder(
        itemCount: productos.length,
        itemBuilder: (_, i) => ListTile(
          onTap: () {
            AlertDialog alerta = AlertDialog(
              title: Row(
                children: [
                  Expanded(
                    child: Text("remover", textAlign: TextAlign.center),
                  ),
                  Expanded(
                    child: Text("modificar", textAlign: TextAlign.center),
                  ),
                ],
              ),
              content: Row(
                children: [
                  Expanded(
                    child: IconButton(
                      color: Colors.red,
                      icon: Icon(Icons.remove_circle),
                      onPressed: () {
                        Provider.of<ProductoProvider>(context)
                            .borrarProductoXID(productos[i].id);
                        Navigator.of(context).pop();
                      },
                    ),
                  ),
                  Expanded(
                    child: IconButton(
                      color: Colors.green,
                      icon: Icon(Icons.change_circle),
                      onPressed: () {
                        /*Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      Modf_Producto(doc_temp)))
                          .then((value) => Navigator.of(context).pop());*/
                      },
                    ),
                  ),
                ],
              ),
            );
            showDialog(
                context: context, builder: (BuildContext context) => alerta);
          },
          title: Container(
            alignment: Alignment.centerLeft,
            child: Text(productos[i].descripcion),
          ),
          leading: Container(
            //adelante
            alignment: Alignment.center,
            width: 50,
            child: Text(productos[i].cantidad.toString()),
          ),
          trailing: Container(
            alignment: Alignment.center,
            width: 90,
            child: Text(tipo +
                ' ' +
                (productos[i].total * productos[i].cantidad).toString()),
          ),
        ),
      );
    } else {
      return Container(
        child: Text(
          "Ingrese Productos",
          //style: TextStyle(color: Colors.white),
          textAlign: TextAlign.center,
        ),
      );
    }
  }
}

/*ListTile(
        onTap: () {
          AlertDialog alerta = AlertDialog(
            title: Row(
              children: [
                Expanded(
                  child: Text("remover", textAlign: TextAlign.center),
                ),
                Expanded(
                  child: Text("modificar", textAlign: TextAlign.center),
                ),
              ],
            ),
            content: Row(
              children: [
                Expanded(
                  child: IconButton(
                    color: Colors.red,
                    icon: Icon(Icons.remove_circle),
                    onPressed: () {
                      delete(doc_temp['id']);
                      Navigator.of(context).pop();
                    },
                  ),
                ),
                Expanded(
                  child: IconButton(
                    color: Colors.green,
                    icon: Icon(Icons.change_circle),
                    onPressed: () {
                      Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      Modf_Producto(doc_temp)))
                          .then((value) => Navigator.of(context).pop());
                    },
                  ),
                ),
              ],
            ),
          );
          showDialog(
              context: context, builder: (BuildContext context) => alerta);
        },
        title: Container(
          alignment: Alignment.centerLeft,
          child: Text(doc_temp['descripcion']),
        ),
        leading: Container(
          //adelante
          alignment: Alignment.center,
          width: 50,
          child: Text(doc_temp['cantidad'].toString()),
        ),
        trailing: Container(
          alignment: Alignment.center,
          width: 90,
          child: Text(_tipomon[1] +
              ' ' +
              (doc_temp['total'] * doc_temp['cantidad']).toString()),
        ),
      ),*/
