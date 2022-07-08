import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
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
    ListView lista = ListView(
      children: [
        const DrawerHeader(
          decoration: BoxDecoration(
            color: Colors.transparent,
          ),
          child: Center(
            child: Text('Facturacion Electronica'),
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
              Navigator.of(context)
                  .pushNamedAndRemoveUntil("/inicio", (route) => false);
            });
          },
        ),
        ListTile(
          leading: const Icon(Icons.add),
          title: const Text("Generar"),
          onTap: () {
            setState(() {
              Navigator.of(context)
                  .pushNamedAndRemoveUntil("/generar", (route) => false);
            });
          },
        ),
        ListTile(
          leading: const Icon(Icons.book),
          title: const Text("Reporte"),
          onTap: () {
            setState(() {
              Navigator.of(context)
                  .pushNamedAndRemoveUntil("/reporte", (route) => false);
            });
          },
        ),
        ListTile(
          leading: const Icon(Icons.app_registration),
          title: const Text("Registrar Empresa"),
          onTap: () {
            setState(() {
              Navigator.of(context)
                  .pushNamedAndRemoveUntil("/registrar", (route) => false);
            });
          },
        ),
        ListTile(
          leading: const Icon(Icons.exit_to_app),
          title: const Text("Cerrar Sesion"),
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
          child: lista,
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
                        /*Expanded(
                          child: IconButton(
                            color: Colors.green,
                            icon: const Icon(Icons.change_circle),
                            onPressed: () {},
                          ),
                        ),*/
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
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text("Ruc:              ${empresa['documento']}"),
                    ),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text("Empresa:      ${empresa['empresa']}"),
                    ),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text("Direccion:     ${empresa['direccion']}"),
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
    documentReference
        .delete()
        .then((value) => print("borrado id" + documento.toString()))
        .catchError((error) => print("Fallo: $error"));
  }
}
