import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:gofact/models/clases.dart';
import 'package:gofact/db/sqlite.dart';
import 'package:gofact/pages/modf_prod.dart';
import 'ingreso.dart';
import 'crear_prod.dart';
import 'emision.dart';

class Generar extends StatefulWidget {
  static const String ruta = "/generar";
  @override
  State<Generar> createState() => _Generar();
}

class _Generar extends State<Generar> {
  @override
  String f_emi = "";
  List<Producto> _productos = [];
  void initState() {
    DB.db.deleteAllProductos();
    //_loadProd();
    hoy();
    super.initState();
  }

  hoy() {
    var emi = new DateTime.now().toString().substring(0, 10);
    String ano = emi.substring(0, 4),
        mes = emi.substring(5, 7),
        dia = emi.substring(8, 10);
    f_emi = dia + '/' + mes + '/' + ano;
  }

  _loadProd() async {
    List<Producto> lista = await DB.db.getTodosProductos();
    setState(() {
      _productos = lista;
    });
  }

  FoB comprobante = FoB();

  List<String> _listmon = ['Soles', 'Dolares'];
  List<String> _tipomon = ['Moneda', '']; //soles, S/.--Dolar, USD
  List<String> _listtipo = ['Factura', 'Boleta'];
  List<String> list_descp = [];

  var documento = TextEditingController(),
      direccion = TextEditingController(),
      empresa = TextEditingController(),
      emision = TextEditingController(),
      vencimiento = TextEditingController(),
      _producto = TextEditingController(),
      _cantidad = TextEditingController(),
      _precio = TextEditingController();
  var error = "";
  var _contador = 1;
  var tipo = '<Comprobante>';
  int actualpaso = 0;
  var _mod_desc = '';

  List<Step> mispasos() => [
        Step(
          isActive: actualpaso >= 0,
          state: actualpaso > 0 ? StepState.complete : StepState.indexed,
          title: Text(""),
          content: pag1(),
        ),
        Step(
          isActive: actualpaso >= 1,
          state: actualpaso > 1 ? StepState.complete : StepState.indexed,
          title: Text(""),
          content: pag2(),
        ),
        Step(
          isActive: actualpaso >= 2,
          state: actualpaso > 2 ? StepState.complete : StepState.indexed,
          title: Text(""),
          content: pag3(),
        ),
      ];
  @override
  Widget build(BuildContext context) {
    ListView lista = ListView(
      children: [
        const DrawerHeader(
          decoration: BoxDecoration(
            color: Colors.transparent,
          ),
          child: Center(
            child: Text('Pacman 22'),
          ),
        ),
        /*AboutListTile(
          child: Text("facturacion"),
          applicationIcon: Icon(Icons.favorite),
          applicationVersion: "v 10.1",
          applicationName: "Demo Drawer",
          icon: Icon(Icons.info),
        ),*/
        ListTile(
          leading: const Icon(Icons.home),
          title: const Text("Inicio"),
          onTap: () {
            setState(() {
              Navigator.of(context).pushNamed("/inicio");
            });
          },
        ),
        ListTile(
          leading: Icon(Icons.add),
          title: Text("Generar"),
          onTap: () {
            setState(() {
              Navigator.of(context).pushNamed("/generar");
            });
          },
        ),
        ListTile(
          leading: Icon(Icons.book),
          title: Text("Reporte"),
          onTap: () {
            setState(() {
              Navigator.of(context).pushNamed("/reporte");
            });
          },
        ),
        ListTile(
          leading: Icon(Icons.app_registration),
          title: Text("Registrar"),
          onTap: () {
            setState(() {
              Navigator.of(context).pushNamed("/registrar");
            });
          },
        ),
        ListTile(
          leading: Icon(Icons.exit_to_app),
          title: Text("Cerrar Sesion"),
          onTap: () {
            setState(() {
              Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(
                      builder: (BuildContext context) => Ingreso()),
                  (route) => false);
            });
          },
        ),
      ],
    );
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
            image: AssetImage('assets/fondo.jpg'), fit: BoxFit.cover),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          title: Text("Generar"),
        ),
        drawer: Drawer(
          child: lista,
        ),
        body: cuerpo(),
      ),
    );
  }

  Widget cuerpo() {
    return Theme(
      data: ThemeData(canvasColor: Colors.transparent),
      child: Stepper(
        currentStep: actualpaso,
        steps: mispasos(),
        type: StepperType.horizontal,
        onStepContinue: () {
          setState(() {
            if (actualpaso < mispasos().length - 1) {
              print(empresa.text);
              switch (actualpaso) {
                case 0:
                  if (empresa.text != '') {
                    if (tipo == 'Factura') {
                      comprobante.serie = 'F001';
                    } else {
                      comprobante.serie = 'B001';
                    }
                    comprobante.cliente.documento = documento.text;
                    comprobante.cliente.direccion = direccion.text;
                    comprobante.cliente.empresa = empresa.text;
                    actualpaso++;
                  } else {
                    SnackBar snack = SnackBar(
                      content: Text('Validar Documento'),
                    );
                    ScaffoldMessenger.of(context).showSnackBar(snack);
                  }
                  break;
                case 1:
                  if (_tipomon[0] != 'Moneda') {
                    comprobante.f_emi = emision.text;
                    comprobante.f_venc = vencimiento.text;
                    comprobante.moneda = _tipomon[0];
                    actualpaso++;
                  } else {
                    SnackBar snack = SnackBar(
                      content: Text('Elegir tipo de Moneda'),
                    );
                    ScaffoldMessenger.of(context).showSnackBar(snack);
                  }
                  break;
                case 2:
              }
              print(actualpaso);
              emision.text = f_emi;
              //documento.text = 'as'; para cambiar valor de text
            } else {
              print("ultimo step");
            }
          });
        },
        onStepCancel: () {
          setState(() {
            if (actualpaso > 0) {
              actualpaso--;
            }
          });
          print("Mi paso actual es " + actualpaso.toString());
        },
        controlsBuilder: (context, details) {
          //condicional para validar ultimo step
          return Container(
            child: Row(
              children: [
                if (actualpaso != mispasos().length - 1)
                  Expanded(
                    child: ElevatedButton(
                      child: Text('Siguiente'),
                      onPressed: details.onStepContinue,
                    ),
                  ),
                if (actualpaso == mispasos().length - 1)
                  Expanded(
                    child: ElevatedButton(
                      child: Text('Emitir'),
                      onPressed: () {
                        if (_productos.isNotEmpty) {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      Emision(comprobante, _productos)));
                        } else {
                          print("ingresar Producto");
                        }

                        //print(comprobante.productos[1].total);
                        //print(contador);
                        //delete_temp();
                      },
                    ),
                  ),
                SizedBox(
                  width: 10,
                ),
                if (actualpaso != 0)
                  Expanded(
                    child: ElevatedButton(
                      child: Text('Atras'),
                      onPressed: details.onStepCancel,
                    ),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget pag1() {
    return Column(
      children: <Widget>[
        DropdownButton(
          //borderRadius: BorderRadius.circular(20),
          iconEnabledColor: Colors.white,
          dropdownColor: Colors.white,
          isExpanded: true,
          items: _listtipo.map((String a) {
            return DropdownMenuItem(
              value: a,
              child: Text(a),
            );
          }).toList(),
          onChanged: (_value) => {
            setState(() {
              tipo = _value.toString();
            }),
          },
          hint: Text(
            tipo,
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
            ),
          ),
        ),
        TextFormField(
          controller: documento,
          decoration: InputDecoration(
              labelText: 'Documento',
              labelStyle: TextStyle(color: Colors.white)),
          style: TextStyle(color: Colors.white),
        ),
        ElevatedButton(
            child: Text("Validar"),
            onPressed: () {
              setState(() {
                validar();
              });
            }),
        TextFormField(
          enabled: false, //para que no se modifique el text
          controller: direccion,
          decoration: InputDecoration(
              labelText: 'Direccion',
              labelStyle: TextStyle(color: Colors.white)),
          style: TextStyle(color: Colors.white),
        ),
        TextFormField(
          enabled: false, //para que no se modifique el text
          controller: empresa,
          decoration: InputDecoration(
              labelText: 'Empresa', labelStyle: TextStyle(color: Colors.white)),
          style: TextStyle(color: Colors.white),
        )
      ],
    );
  }

  Widget pag2() {
    return Column(
      children: <Widget>[
        TextFormField(
          enabled: false,
          controller: emision,
          decoration: InputDecoration(
              labelText: 'Fecha de Emision',
              labelStyle: TextStyle(color: Colors.white)),
          style: TextStyle(color: Colors.white),
        ),
        TextFormField(
          controller: vencimiento,
          decoration: InputDecoration(
              labelText: 'Fecha de Vencimiento',
              labelStyle: TextStyle(color: Colors.white)),
          style: TextStyle(color: Colors.white),
        ),
        DropdownButton(
          iconEnabledColor: Colors.white,
          dropdownColor: Colors.white,
          isExpanded: true,
          items: _listmon.map((String a) {
            return DropdownMenuItem(
              value: a,
              child: Text(a),
              alignment: AlignmentDirectional.center,
            );
          }).toList(),
          onChanged: (_value) => {
            setState(() {
              _tipomon[0] = _value.toString();
              if (_tipomon[0] == 'Soles') {
                _tipomon[1] = 'S/.';
              } else {
                _tipomon[1] = 'USD';
              }
            }),
          },
          hint: Text(
            _tipomon[0],
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
            ),
          ),
        ),
      ],
    );
  }

  Widget pag3() {
    return Column(
      children: [
        Text(
          "Productos",
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
          ),
        ),
        SizedBox(
          height: 10,
        ),
        Container(
          height: 40,
          alignment: Alignment.center,
          //decoration: BoxDecoration(
          //color: Colors.white, borderRadius: BorderRadius.circular(10)),
          child: Row(
            children: [
              Container(
                //adelante
                alignment: Alignment.center,
                width: 80,
                child: Text(
                  'Cantidad',
                  style: TextStyle(fontSize: 16, color: Colors.white),
                ),
              ),
              Expanded(
                child: Container(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Descripcion',
                    style: TextStyle(fontSize: 16, color: Colors.white),
                  ),
                ),
              ),
              Container(
                alignment: Alignment.centerLeft,
                width: 90,
                child: Text(
                  "Total",
                  style: TextStyle(fontSize: 16, color: Colors.white),
                ),
              ),
            ],
          ),
        ),
        Container(
          margin: EdgeInsets.symmetric(vertical: 10),
          alignment: Alignment.center,
          decoration: BoxDecoration(
              color: Colors.white, borderRadius: BorderRadius.circular(10)),
          child: ProductWidget(),
        ),
        //tipo: _tipomon[1],
        Row(
          children: [
            Expanded(
              child: IconButton(
                iconSize: 40,
                color: Colors.white,
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => Crear_Producto())).then(
                    (value) => setState(() {
                      _loadProd();
                    }),
                  );
                },
                icon: Icon(Icons.add_circle),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget ProductWidget() {
    if (_productos.isNotEmpty) {
      return ListView.builder(
        shrinkWrap: true,
        itemCount: _productos.length,
        itemBuilder: (BuildContext context, int index) {
          Producto prod = _productos[index];
          print("productos: $prod");
          return ListTile(
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
                          DB.db.deleteProducto(prod.id).then((value) {
                            _loadProd();
                            Navigator.of(context).pop();
                          });
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
                                      Modf_Producto(prod))).then((value) {
                            _loadProd();
                            Navigator.of(context).pop();
                          });
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
              child: Text(prod.descripcion),
            ),
            leading: Container(
              //adelante
              alignment: Alignment.center,
              width: 50,
              child: Text(prod.cantidad.toString()),
            ),
            trailing: Container(
              alignment: Alignment.center,
              width: 90,
              child: Text(
                  _tipomon[1] + ' ' + (prod.total * prod.cantidad).toString()),
            ),
          );
        },
      );
    } else {
      return SizedBox(
        height: 50,
        child: Align(
          alignment: Alignment.center,
          child: Text("Ingresar Productos"),
        ),
      );
    }
  }

  delete(borrar) {
    DocumentReference documentReference = FirebaseFirestore.instance
        .collection("temporal")
        .doc(borrar.toString());
    documentReference
        .delete()
        .then((value) => print("borrado id" + borrar.toString()))
        .catchError((error) => print("Fallo: $error"));
  }

  validar() {
    AlertDialog alerta;
    FirebaseFirestore.instance
        .collection('empresas')
        .doc(documento.text)
        .get()
        .then((DocumentSnapshot documentSnapshot) {
      if (documentSnapshot.exists) {
        Map<String, dynamic> data =
            documentSnapshot.data() as Map<String, dynamic>;
        direccion.text = data['direccion'];
        empresa.text = data['empresa'];
        error = '';
      } else {
        direccion.text = '';
        empresa.text = '';
        if (documento.text.length == 11) {
          alerta = AlertDialog(
            title: Text('Error'),
            content: Text('documento no registrado'),
          );
        } else if (documento.text.length == 8) {
          alerta = AlertDialog(
            title: Text('Error'),
            content: Text('Dni no registrado'),
          );
        } else {
          alerta = AlertDialog(
            title: Text('Error'),
            content: Text('Documento Invalido'),
          );
        }
        showDialog(context: context, builder: (BuildContext context) => alerta);
      }
    });
  }
}
