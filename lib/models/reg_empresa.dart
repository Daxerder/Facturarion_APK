import 'dart:convert';
import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:gofact/models/user.dart';
import 'ingreso.dart';

class Registrar extends StatefulWidget {
  static const String ruta = "/registrar";
  @override
  State<Registrar> createState() => _Registrar();
}

class _Registrar extends State<Registrar> {
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
          title: Text("Registrar Empresa"),
        ),
        drawer: Drawer(
          child: lista,
        ),
        body: Container(
          child: Padding(
            padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
            child: cuerpo(),
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
          decoration: InputDecoration(
              labelText: 'Ruc/Dni', labelStyle: TextStyle(color: Colors.white)),
          style: TextStyle(color: Colors.white),
          onChanged: (String documento) {
            getDocumento(documento);
          },
        ),
        SizedBox(
          height: 20,
        ),
        TextFormField(
          controller: _empresa,
          decoration: InputDecoration(
              labelText: 'Empresa', labelStyle: TextStyle(color: Colors.white)),
          style: TextStyle(color: Colors.white),
          onChanged: (String empresa) {
            getEmpresa(empresa);
          },
        ),
        SizedBox(
          height: 20,
        ),
        TextFormField(
          controller: _direccion,
          decoration: InputDecoration(
              labelText: 'Direccion',
              labelStyle: TextStyle(color: Colors.white)),
          style: TextStyle(color: Colors.white),
          onChanged: (String direccion) {
            getDireccion(direccion);
          },
        ),
        SizedBox(
          height: 20,
        ),
        Row(
          children: [
            Expanded(
              child: ElevatedButton(
                child: Text("Registrar"),
                onPressed: () {
                  registrar();
                  AlertDialog alerta = AlertDialog(
                    title: Icon(Icons.check),
                    content: Text('Empresa $Documento registrada con exito'),
                  );
                  showDialog(
                      context: context,
                      builder: (BuildContext context) => alerta);
                  limpiar();
                },
              ),
            ),
            SizedBox(
              width: 20,
            ),
            Expanded(
              child: ElevatedButton(
                child: Text("Limpiar"),
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

  registrar() {
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

  limpiar() {
    _documento.text = '';
    _empresa.text = '';
    _direccion.text = '';
  }
}
