import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:gofact/funciones/list_view.dart';
import 'package:gofact/models/clases.dart';
import 'package:gofact/pag_secundarias/modf_empresa.dart';
import 'package:gofact/pag_secundarias/reg_empresa.dart';
import 'ingreso.dart';

class Empresas extends StatefulWidget {
  static const String ruta = "/registrar";
  @override
  State<Empresas> createState() => _Empresas();
}

class _Empresas extends State<Empresas> {
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
          title: Text("Empresas"),
          actions: [
            IconButton(
              icon: const Icon(Icons.add),
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => RegistrarEmpresa()));
              },
            ),
          ],
        ),
        drawer: Drawer(
          child: list_view(context),
        ),
        body: Container(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
            child: cuerpo(),
          ),
        ),
      ),
    );
  }

  Widget cuerpo() {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection("empresas").snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasData) {
          return ListView.builder(
            shrinkWrap: true,
            itemBuilder: (context, index) {
              DocumentSnapshot empresa = snapshot.data!.docs[index];
              return GestureDetector(
                onTap: () {
                  AlertDialog alerta = AlertDialog(
                    title: Row(
                      children: const <Widget>[
                        Expanded(
                          child: Text("Remover", textAlign: TextAlign.center),
                        ),
                        /*Expanded(
                          child: Text("Modificar", textAlign: TextAlign.center),
                        ),*/
                      ],
                    ),
                    content: Row(
                      children: [
                        Expanded(
                          child: IconButton(
                            color: Colors.red,
                            icon: const Icon(Icons.remove_circle),
                            onPressed: () {
                              delete(empresa['documento']);
                              Navigator.of(context).pop();
                            },
                          ),
                        ),
                        Expanded(
                          child: IconButton(
                              color: Colors.green,
                              icon: const Icon(Icons.change_circle),
                              onPressed: () {
                                Navigator.of(context).pop();
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            Modf_Empresa(empresa)));
                              }),
                        ),
                      ],
                    ),
                  );
                  showDialog(
                      context: context,
                      builder: (BuildContext context) => alerta);
                },
                child: Container(
                  margin:
                      const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                  padding:
                      const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Column(children: [
                    Row(
                      children: <Widget>[
                        const Expanded(
                          child: Text("Ruc:"),
                        ),
                        Expanded(
                          flex: 3,
                          child: Text(empresa['documento']),
                        ),
                      ],
                    ),
                    Row(
                      children: <Widget>[
                        const Expanded(
                          child: Text("Empresa:"),
                        ),
                        Expanded(
                          flex: 3,
                          child: Text(empresa['empresa']),
                        ),
                      ],
                    ),
                    Row(
                      children: <Widget>[
                        const Expanded(
                          child: Text("Direccion:"),
                        ),
                        Expanded(
                          flex: 3,
                          child: Text(empresa['direccion']),
                        ),
                      ],
                    ),
                  ]),
                ),
              );
            },
            itemCount: snapshot.data!.docs.length,
          );
        } else {
          return const CircularProgressIndicator();
        }
      },
    );
  }

  delete(documento) {
    DocumentReference documentReference = FirebaseFirestore.instance
        .collection("empresas")
        .doc(documento.toString());
    documentReference.delete()
        /*.then((value) => print("borrado id" + documento.toString()))
        .catchError((error) => print("Fallo: $error"))*/
        ;
  }
}
