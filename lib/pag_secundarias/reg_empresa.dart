import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class RegistrarEmpresa extends StatefulWidget {
  @override
  State<RegistrarEmpresa> createState() => _RegistrarEmpresa();
}

class _RegistrarEmpresa extends State<RegistrarEmpresa> {
  var _documento = TextEditingController();
  var _empresa = TextEditingController();
  var _direccion = TextEditingController();
  @override
  String Documento = '', Empresa = '', Direccion = '';
  getDocumento(documento) {
    Documento = documento;
  }

  getEmpresa(empresa) {
    Empresa = empresa;
  }

  getDireccion(direccion) {
    Direccion = direccion;
  }

  Future<List> getEmpresas() async {
    List lista = [];
    CollectionReference collectionReference =
        FirebaseFirestore.instance.collection("empresas");

    QuerySnapshot empresas = await collectionReference.get();

    if (empresas.docs.length != 0) {
      for (var doc in empresas.docs) {
        lista.add(doc.data());
      }
    }
    return lista;
  }

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
          title: Text("Registrar Empresa"),
        ),
        body: Container(
          child: Padding(
            padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
            child: SingleChildScrollView(
              child: cuerpo(),
            ),
          ),
        ),
      ),
    );
  }

  Widget cuerpo() {
    return Column(
      children: <Widget>[
        TextFormField(
          controller: _documento,
          keyboardType: TextInputType.number,
          maxLength: 11,
          decoration: const InputDecoration(
              labelText: 'Ruc/Dni', labelStyle: TextStyle(color: Colors.white)),
          style: const TextStyle(color: Colors.white),
          onChanged: (String documento) {
            getDocumento(documento);
          },
        ),
        const SizedBox(
          height: 20,
        ),
        TextFormField(
          controller: _empresa,
          decoration: const InputDecoration(
              labelText: 'Empresa', labelStyle: TextStyle(color: Colors.white)),
          style: const TextStyle(color: Colors.white),
          onChanged: (String empresa) {
            getEmpresa(empresa);
          },
        ),
        const SizedBox(
          height: 20,
        ),
        TextFormField(
          controller: _direccion,
          decoration: const InputDecoration(
              labelText: 'Direccion',
              labelStyle: TextStyle(color: Colors.white)),
          style: const TextStyle(color: Colors.white),
          onChanged: (String direccion) {
            getDireccion(direccion);
          },
        ),
        const SizedBox(
          height: 20,
        ),
        Row(
          children: [
            Expanded(
              child: ElevatedButton(
                child: const Text("Registrar"),
                onPressed: () async {
                  if (Documento != '' && Direccion != '' && Empresa != '') {
                    var doc = Documento[0] + Documento[1];
                    if (Documento.length != 11 && Documento.length != 8) {
                      SnackBar snack = const SnackBar(
                        content: Text('Error en el Ruc/Dni'),
                      );
                      ScaffoldMessenger.of(context).showSnackBar(snack);
                    } else if (Documento.length == 11 &&
                        (doc != '10' && doc != '15' && doc != '20')) {
                      SnackBar snack = const SnackBar(
                        content: Text('Error en el Ruc/Dni'),
                      );
                      ScaffoldMessenger.of(context).showSnackBar(snack);
                    } else if (!validar_doc(Documento)) {
                      SnackBar snack = const SnackBar(
                        content: Text('Error en el Ruc/Dni'),
                      );
                      ScaffoldMessenger.of(context).showSnackBar(snack);
                    } else if (!validar_text(Empresa)) {
                      SnackBar snack = const SnackBar(
                        content: Text('Error en el campo Empresa'),
                      );
                      ScaffoldMessenger.of(context).showSnackBar(snack);
                    } else if (!validar_text(Direccion)) {
                      SnackBar snack = const SnackBar(
                        content: Text('Error en el campo Direccion'),
                      );
                      ScaffoldMessenger.of(context).showSnackBar(snack);
                    } else {
                      List _empresas = await getEmpresas();
                      /*for(var i = 0; i < _empresas.length;i++){}*/
                      print(_empresas);
                      for (var i = 0; i < _empresas.length; i++) {
                        if (_empresas[i]["documento"] == Documento) {
                          AlertDialog alerta = const AlertDialog(
                            title: Text("Empresa ya registrada"),
                          );
                          limpiar();
                          return showDialog(
                              context: context,
                              builder: (BuildContext context) => alerta);
                        }
                      }
                      registrar();
                      AlertDialog alerta = AlertDialog(
                        title: const Icon(Icons.check),
                        content:
                            Text('Empresa $Documento registrada con exito'),
                      );
                      Navigator.of(context).pop();
                      showDialog(
                          context: context,
                          builder: (BuildContext context) => alerta);
                    }
                  } else {
                    SnackBar snack = const SnackBar(
                      content: Text('Rellenar todos los campos'),
                    );
                    ScaffoldMessenger.of(context).showSnackBar(snack);
                  }
                },
              ),
            ),
            const SizedBox(
              width: 20,
            ),
            Expanded(
              child: ElevatedButton(
                child: const Text("Limpiar"),
                onPressed: () {
                  limpiar();
                },
              ),
            )
          ],
        )
      ],
    );
  }

  registrar() async {
    DocumentReference documentReference =
        FirebaseFirestore.instance.collection("empresas").doc(Documento);

    documentReference
        .set(
          {
            "documento": Documento,
            "direccion": Direccion,
            "empresa": Empresa,
          },
          SetOptions(merge: false),
        )
        .catchError((error) => print("Failed to merge data: $error"))
        .whenComplete(() {
          print("Estudiante con nombre $Documento creado");
        });
  }

  limpiar() async {
    _documento.text = '';
    _empresa.text = '';
    _direccion.text = '';
    Documento = '';
    Empresa = '';
    Direccion = '';
  }

  bool validar_text(String texto) {
    String palabra = texto;
    for (var i = 0; i < palabra.length; i++) {
      if (!texto[i].contains(RegExp(r"[a-záéíóúüñA-ZÑ0-9. -]"))) {
        return false;
      }
    }
    return true;
  }

  bool validar_doc(String texto) {
    String palabra = texto;
    for (var i = 0; i < palabra.length; i++) {
      if (!texto[i].contains(RegExp(r"[0-9]"))) {
        return false;
      }
    }
    return true;
  }
}
