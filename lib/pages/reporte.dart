import 'package:flutter/material.dart';
import 'package:gofact/funciones/filtros.dart';
import 'package:gofact/funciones/list_view.dart';
import 'package:url_launcher/url_launcher.dart';

class Reporte extends StatefulWidget {
  static const String ruta = "/reporte";
  @override
  State<Reporte> createState() => _Reporte();
}

class _Reporte extends State<Reporte> {
  @override
  String gender = '';
  String _val = '';
  String fob = '';

  //filtros
  final _listtipo = ['Facturas', 'Boletas', 'Facturas y Boletas'];
  final _listmoneda = ['Todas', 'Soles', 'Dolares'];
  final _listMeses = [
    'Todos los Meses',
    'Enero',
    'Febrero',
    'Marzo',
    'Abril',
    'Mayo',
    'Junio',
    'Julio',
    'Agosto',
    'Septiembre',
    'Noviembre',
    'Diciembre'
  ];
  var parametros = ['', '', '']; //faltaria añadir fecha, cliente tal vez

  //listafiltrada
  List mostrar = [];

  //variables de Text(mostrar)
  String _tipo = 'Seleccione una Opcion';
  String _moneda = 'Todas';
  String _mes = 'Todos los Meses';
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
        body: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              tipo(),
              Text(
                error,
                style: const TextStyle(color: Colors.red, fontSize: 20),
              ),
              moneda(),
              meses(),
              boton(),
            ],
          ),
        ),
      ),
    );
  }

  Widget tipo() {
    return Column(
      children: [
        const Padding(
          padding: EdgeInsets.only(left: 30, right: 30, top: 20),
          child: Text(
            "Tipo de Documentos",
            style: TextStyle(color: Colors.white, fontSize: 20),
            textAlign: TextAlign.left,
          ),
        ),
        Padding(
          padding:
              const EdgeInsets.only(left: 30, right: 30, bottom: 0, top: 20),
          child: DropdownButton(
            isDense: true,
            isExpanded: true,
            items: _listtipo.map((String a) {
              return DropdownMenuItem(value: a, child: Text(a));
            }).toList(),
            onChanged: (_value) => {
              setState(() {
                if (_value.toString() != 'Vacio') {
                  _tipo = _value.toString();
                  parametros[0] = _tipo;
                  error = '';
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
        const Padding(
          padding: EdgeInsets.only(left: 30, right: 30, top: 10),
          child: Text(
            "Tipo de Moneda",
            style: TextStyle(color: Colors.white, fontSize: 20),
          ),
        ),
        Container(
          padding: const EdgeInsets.only(left: 30, right: 30, top: 20),
          child: DropdownButton(
            isDense: true,
            isExpanded: true, //para que ocupe todo el contenedor
            items: _listmoneda.map((String a) {
              return DropdownMenuItem(
                value: a,
                child: Text(a),
              );
            }).toList(),
            onChanged: (_value) => {
              setState(() {
                if (_value.toString() != 'Todas') {
                  _moneda = _value.toString();
                  parametros[1] = _moneda;
                } else {
                  _moneda = 'Todas';
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

  Widget meses() {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.fromLTRB(0, 20, 0, 0),
          child: const Text(
            "Mes",
            style: TextStyle(color: Colors.white, fontSize: 20),
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 30),
          child: DropdownButton(
            //isDense: true,
            isExpanded: true, //para que ocupe todo el contenedor
            items: _listMeses.map((String a) {
              return DropdownMenuItem(
                value: a,
                child: Text(a),
              );
            }).toList(),
            onChanged: (_value) => {
              setState(() {
                if (_value.toString() != 'Todos los Meses') {
                  _mes = _value.toString();
                  parametros[2] = _mes;
                } else {
                  _mes = 'Todos los Meses';
                  parametros[2] = '';
                }
              }),
            },
            hint: Text(
              ((parametros[2] != '') ? ("$_mes 2022") : _mes),
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
        AlertDialog alerta = const AlertDialog(
            backgroundColor: Colors.transparent,
            content: Center(
              child: CircularProgressIndicator(),
            ));
        showDialog(context: context, builder: (BuildContext context) => alerta);
        gender = '';
        mostrar.clear();
        if (parametros[0] != '') {
          error = '';
          //FACTURAS
          if (parametros[0] == 'Facturas') {
            mostrar = await anadirFact();
          }
          //BOLETAS
          else if (parametros[0] == 'Boletas') {
            mostrar = await anadirBol();
          } else {
            mostrar += await anadirBol();
            mostrar += await anadirFact();
          }
          //Tipo de moneda
          if (parametros[1] != '') {
            mostrar = filtro_mon(mostrar, parametros[1]);
          }
          //meses
          if (parametros[2] != '') {
            mostrar = filtro_mes(mostrar, parametros[2]);
          }
          Navigator.push(context,
                  MaterialPageRoute(builder: (context) => Visualizacion()))
              .then((value) => Navigator.of(context).pop());
        } else {
          setState(() {
            error = 'No a seleccion nado ninguna opcion';
          });
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
              var total = Total(mostrar[index]['productos']);
              String tipo = '';
              if (mostrar[index]['moneda'] == 'Soles') {
                tipo = 'S/.';
              } else {
                tipo = '\$';
              }
              return Container(
                margin: const EdgeInsets.symmetric(vertical: 10),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10)),
                child: ListTile(
                  onTap: () {
                    AlertDialog alerta = AlertDialog(
                      /* Icon(
                        iconSize: 50,
                        color: Colors.green,
                        icon:*/

                      content: Column(
                        mainAxisSize: MainAxisSize.min,
                        //mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            mostrar[index]['serie'] +
                                '-' +
                                mostrar[index]['correlativo'].toString(),
                            textAlign: TextAlign.center,
                            style: const TextStyle(fontSize: 20),
                          ),
                          IconButton(
                            onPressed: () {
                              String link = mostrar[index]['url'] + '.pdf';
                              launchUrl(Uri.parse(link),
                                  mode:
                                      LaunchMode.externalNonBrowserApplication);
                            },
                            icon: const Icon(Icons.download),
                            iconSize: 80,
                            color: Colors.green,
                          ),
                          const Text(
                            "Descargar",
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 15),
                          ),
                        ],
                      ),
                    );
                    showDialog(
                        context: context,
                        builder: (BuildContext context) => alerta);
                  },
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
                    child: Text('$tipo ${total.toStringAsFixed(2)}'),
                  ), //al final
                ),
              );
            }),
      ),
    );
  }
}
