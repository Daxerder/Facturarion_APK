import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';

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
    return SingleChildScrollView(
      child: Column(
        children: <Widget>[
          TextFormField(
            controller: _documento,
            keyboardType: TextInputType.number,
            maxLength: 11,
            inputFormatters: [
              FilteringTextInputFormatter.allow(RegExp("[0-9]")),
            ],
            decoration: const InputDecoration(
                labelText: 'Ruc/Dni',
                labelStyle: TextStyle(color: Colors.white)),
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
            maxLength: 30,
            inputFormatters: [
              FilteringTextInputFormatter.allow(RegExp("[a-zA-Z0-9 .-]")),
            ],
            decoration: const InputDecoration(
                labelText: 'Empresa',
                labelStyle: TextStyle(color: Colors.white)),
            style: const TextStyle(color: Colors.white),
            onChanged: (String empresa) {
              getEmpresa(empresa);
              _empresa.value = TextEditingValue(
                  text: empresa.toUpperCase(), selection: _empresa.selection);
            },
          ),
          const SizedBox(
            height: 20,
          ),
          TextFormField(
            controller: _direccion,
            maxLength: 30,
            inputFormatters: [
              FilteringTextInputFormatter.allow(RegExp("[a-zA-Z0-9 .-]")),
            ],
            decoration: const InputDecoration(
                labelText: 'Direccion',
                labelStyle: TextStyle(color: Colors.white)),
            style: const TextStyle(color: Colors.white),
            onChanged: (String direccion) {
              getDireccion(direccion);
              _direccion.value = TextEditingValue(
                  text: direccion.toUpperCase(),
                  selection: _direccion.selection);
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
                      } else {
                        Direccion = quitar_espacios(Direccion);
                        Empresa = quitar_espacios(Empresa);
                        List _empresas = await getEmpresas();
                        /*for(var i = 0; i < _empresas.length;i++){}*/
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
      ),
    );
  }

  registrar() async {
    DocumentReference documentReference =
        FirebaseFirestore.instance.collection("empresas").doc(Documento);

    documentReference.set(
      {
        "documento": Documento,
        "direccion": Direccion,
        "empresa": Empresa,
      },
      SetOptions(merge: false),
    )
        /*.catchError((error) => print("Failed to merge data: $error"))
        .whenComplete(() {
          print("Estudiante con nombre $Documento creado");
        })*/
        ;
  }

  limpiar() async {
    _documento.text = '';
    _empresa.text = '';
    _direccion.text = '';
    Documento = '';
    Empresa = '';
    Direccion = '';
  }

  String quitar_espacios(String palabra) {
    String nueva = '';
    palabra = palabra.trim();
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
    return nueva;
  }
}
