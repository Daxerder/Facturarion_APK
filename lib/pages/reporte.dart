import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:gofact/funciones/list_view.dart';
import 'ingreso.dart';
import '../models/clases.dart';

class Reporte extends StatefulWidget {
  static const String ruta = "/reporte";
  @override
  State<Reporte> createState() => _Reporte();
}

class _Reporte extends State<Reporte> {
  List _facturas = [];
  List _boletas = [];

  @override
  void initState() {
    /*getfact();
    getbol();*/
    super.initState();
  }

  //coleccion de facturas
  /*Future getfact() async {
    List _facturas = [];
    CollectionReference collectionReference =
        FirebaseFirestore.instance.collection("facturas");

    QuerySnapshot fact =
        await collectionReference.get(); //await porq es un future

    if (fact.docs.length != 0) {
      //docs cantidad de documentos
      for (var doc in fact.docs) {
        _facturas.add(doc.data());
      }
    }
  }*/

  //coleccion de boletas
  /*Future getbol() async {
    List _boletas = [];
    CollectionReference collectionReference =
        FirebaseFirestore.instance.collection("boletas");

    QuerySnapshot bol =
        await collectionReference.get(); //await porq es un future

    if (bol.docs.length != 0) {
      //docs cantidad de documentos
      for (var doc in bol.docs) {
        _boletas.add(doc.data());
      }
    }
  }*/

  String gender = '';
  String _val = '';
  String fob = '';
  List<double> total = [];

  //filtros
  var _listtipo = ['Facturas', 'Boletas', 'Facturas y Boletas'];
  var _listmoneda = ['Soles', 'Dolares', 'Vacio'];
  var parametros = ['', '']; //faltaria añadir fecha, cliente tal vez
  List tipo_mon = []; //Simbolo de soles dolares
  //listafiltrada
  List mostrar = [];

  //variables de Text(mostrar)
  String _tipo = 'Seleccione una Opcion';
  String _moneda = 'Seleccione una Opcion';
  var error = '';

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
        drawer: Drawer(
          child: list_view(context),
        ),
        body: Column(
          children: <Widget>[
            tipo(),
            Text(
              error,
              style: const TextStyle(color: Colors.red, fontSize: 20),
            ),
            moneda(),
            Row(
                /*mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Expanded(
                  child: tipo(),
                ),
                Expanded(
                  child: tipo(),
                ),
                Expanded(
                  child: tipo(),
                ),
              ],*/
                ),
            boton(),
          ],
        ),
      ),
    );
  }

  Widget tipo() {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.fromLTRB(0, 15, 0, 0),
          child: const Text(
            "Tipo de Documentos",
            style: TextStyle(color: Colors.white, fontSize: 20),
            textAlign: TextAlign.left,
          ),
        ),
        Container(
          width: 300,
          padding: const EdgeInsets.fromLTRB(0, 20, 0, 0),
          child: DropdownButton(
            isExpanded: true,
            items: _listtipo.map((String a) {
              return DropdownMenuItem(value: a, child: Text(a));
            }).toList(),
            onChanged: (_value) => {
              setState(() {
                if (_value.toString() != 'Vacio') {
                  _tipo = _value.toString();
                  parametros[0] = _tipo;
                } else {
                  _tipo = 'Seleccione una Opcion';
                  parametros[0] = '';
                }
              }),
            },
            hint: Text(
              _tipo,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 20,
              ),
            ),
          ),
        )
      ],
    );
  }

  Widget moneda() {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.fromLTRB(0, 20, 0, 0),
          child: const Text(
            "Tipo de Moneda",
            style: TextStyle(color: Colors.white, fontSize: 20),
          ),
        ),
        Container(
          padding: const EdgeInsets.fromLTRB(0, 20, 0, 0),
          width: 300,
          child: DropdownButton(
            isExpanded: true, //para que ocupe todo el contenedor
            items: _listmoneda.map((String a) {
              return DropdownMenuItem(value: a, child: Text(a));
            }).toList(),
            onChanged: (_value) => {
              setState(() {
                if (_value.toString() != 'Vacio') {
                  _moneda = _value.toString();
                  parametros[1] = _moneda;
                } else {
                  _moneda = 'Seleccione una Opcion';
                  parametros[1] = '';
                }
              }),
            },
            hint: Text(
              _moneda,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 20,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget boton() {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(vertical: 10),
        minimumSize: const Size(300, 10),
        primary: const Color.fromARGB(255, 26, 37, 55),
      ),
      onPressed: () async {
        gender = '';
        mostrar.clear();
        tipo_mon = [];
        total = [];
        if (parametros[0].toString() != '') {
          error = '';
          //FACTURAS
          if (parametros[0].toString() == 'Facturas') {
            await anadirFact();
          }
          //BOLETAS
          else if (parametros[0].toString() == 'Boletas') {
            await anadirBol();
          } else {
            await anadirBol();
            await anadirFact();
          }

          Navigator.push(context,
              MaterialPageRoute(builder: (context) => Visualizacion()));
        } else {
          error = 'No a seleccion nado ninguna opcion';
        }
      },
      child: const Text("Generar Reporte"),
    );
  }

  Widget Visualizacion() {
    return Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
            image: AssetImage('assets/fondo.jpg'), fit: BoxFit.cover),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          title: const Text("Visualizacion"),
        ),
        body: ListView.builder(
            itemCount: mostrar.length,
            itemBuilder: (context, index) {
              return Container(
                margin: const EdgeInsets.symmetric(vertical: 10),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10)),
                child: ListTile(
                  title: Column(
                    //titulo
                    children: [
                      Container(
                        alignment: Alignment.centerLeft,
                        child: Text(mostrar[index]['empresa']),
                      ),
                      Container(
                        alignment: Alignment.centerLeft,
                        child: Text(mostrar[index]['documento']),
                      ),
                    ],
                  ),
                  subtitle: Text(mostrar[index]['f_emi']), //subtitulo
                  leading: Container(
                    //adelante
                    alignment: Alignment.center,
                    width: 50,
                    child: Text(
                      mostrar[index]['serie'] +
                          '-' +
                          mostrar[index]['correlativo'].toString(),
                    ),
                  ),
                  trailing: Container(
                    alignment: Alignment.center,
                    width: 90,
                    child:
                        Text(tipo_mon[index] + ' ' + total[index].toString()),
                  ), //al final
                ),
              );
            }),
      ),
    );
  }

  //Funciones
  anadirFact() async {
    _facturas.clear();
    CollectionReference collectionReference =
        FirebaseFirestore.instance.collection("facturas");

    QuerySnapshot fact =
        await collectionReference.get(); //await porq es un future

    if (fact.docs.length != 0) {
      //docs cantidad de documentos
      for (var doc in fact.docs) {
        _facturas.add(doc.data());
      }
    }
    if (parametros[1].toString() == '') {
      for (var i = 0; i < _facturas.length; i++) {
        mostrar.add(_facturas[i]);
        total.add(Total(_facturas[i]['productos']));
        if (_facturas[i]['moneda'] == 'Soles') {
          tipo_mon.add('S/.');
        } else if (_facturas[i]['moneda'] == 'Dolares') {
          tipo_mon.add('USD');
        }
      }
    } else if (parametros[1].toString() == 'Soles') {
      for (var i = 0; i < _facturas.length; i++) {
        if (_facturas[i]['moneda'] == 'Soles') {
          mostrar.add(_facturas[i]);
          total.add(Total(_facturas[i]['productos']));
          tipo_mon.add('S/.');
        }
      }
    } else if (parametros[1].toString() == 'Dolares') {
      for (var i = 0; i < _facturas.length; i++) {
        if (_facturas[i]['moneda'] == 'Dolares') {
          mostrar.add(_facturas[i]);
          total.add(Total(_facturas[i]['productos']));
          tipo_mon.add('USD');
        }
      }
    }
  }

  anadirBol() async {
    _boletas.clear();
    CollectionReference collectionReference =
        FirebaseFirestore.instance.collection("boletas");

    QuerySnapshot bol =
        await collectionReference.get(); //await porq es un future

    if (bol.docs.length != 0) {
      //docs cantidad de documentos
      for (var doc in bol.docs) {
        _boletas.add(doc.data());
      }
    }
    if (parametros[1].toString() == '') {
      for (var i = 0; i < _boletas.length; i++) {
        mostrar.add(_boletas[i]);
        total.add(Total(_boletas[i]['productos']));
        if (_boletas[i]['moneda'] == 'Soles') {
          tipo_mon.add('S/.');
        } else if (_boletas[i]['moneda'] == 'Dolares') {
          tipo_mon.add('USD');
        }
      }
    } else if (parametros[1].toString() == 'Soles') {
      for (var i = 0; i < _boletas.length; i++) {
        if (_boletas[i]['moneda'] == 'Soles') {
          mostrar.add(_boletas[i]);
          total.add(Total(_boletas[i]['productos']));
          tipo_mon.add('S/.');
        }
      }
    } else if (parametros[1].toString() == 'Dolares') {
      for (var i = 0; i < _boletas.length; i++) {
        if (_boletas[i]['moneda'] == 'Dolares') {
          mostrar.add(_boletas[i]);
          total.add(Total(_boletas[i]['productos']));
          tipo_mon.add('USD');
        }
      }
    }
  }

  double Total(doc) {
    var suma = 0.00;
    for (var ind = 0; ind < doc.length; ind++) {
      suma += (doc[ind]['total'] * doc[ind]['cantidad']);
    }
    return suma;
  }
}
