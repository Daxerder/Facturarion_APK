import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';

class Modf_Empresa extends StatefulWidget {
  final DocumentSnapshot modificar;
  Modf_Empresa(this.modificar);
  @override
  State<Modf_Empresa> createState() => _Modf_Empresa();
}

class _Modf_Empresa extends State<Modf_Empresa> {
  var _documento = TextEditingController();
  var _empresa = TextEditingController();
  var _direccion = TextEditingController();
  @override
  void initState() {
    _documento.text = this.widget.modificar['documento'];
    _empresa.text = this.widget.modificar['empresa'];
    _direccion.text = this.widget.modificar['direccion'];
    super.initState();
  }

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
            enabled: false,
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
                  child: const Text("Modificar"),
                  onPressed: () async {
                    if (_direccion.text != '' && _empresa.text != '') {
                      Direccion = quitar_espacios(_direccion.text);
                      Empresa = quitar_espacios(_empresa.text);
                      registrar();
                      AlertDialog alerta = AlertDialog(
                        title: const Icon(Icons.check),
                        content: Text(
                            'Empresa ${_documento.text} modificada con exito'),
                      );
                      Navigator.of(context).pop();
                      showDialog(
                          context: context,
                          builder: (BuildContext context) => alerta);
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
        FirebaseFirestore.instance.collection("empresas").doc(_documento.text);

    documentReference.update(
      {
        "direccion": Direccion,
        "empresa": Empresa,
      },
    );
  }

  limpiar() async {
    _empresa.text = '';
    _direccion.text = '';
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
