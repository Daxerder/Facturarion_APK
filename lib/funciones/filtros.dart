import 'package:cloud_firestore/cloud_firestore.dart';

Future<List> anadirFact() async {
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
  return _facturas;
}

Future<List> anadirBol() async {
  List _boletas = [];
  CollectionReference collectionReference =
      FirebaseFirestore.instance.collection("boletas");

  QuerySnapshot bol = await collectionReference.get(); //await porq es un future

  if (bol.docs.length != 0) {
    //docs cantidad de documentos
    for (var doc in bol.docs) {
      _boletas.add(doc.data());
    }
  }

  return _boletas;
}

List<dynamic> filtro_mon(List<dynamic> lista, String moneda) {
  List nueva_list = [];
  for (var i = 0; i < lista.length; i++) {
    if (lista[i]['moneda'] == moneda) {
      nueva_list.add(lista[i]);
    }
  }
  return nueva_list;
}

List<dynamic> filtro_mes(List<dynamic> lista, String filtro) {
  List nueva_list = [];
  switch (filtro) {
    case 'Enero':
      filtro = '01';
      break;
    case 'Febrero':
      filtro = '02';
      break;
    case 'Marzo':
      filtro = '03';
      break;
    case 'Abril':
      filtro = '04';
      break;
    case 'Mayo':
      filtro = '05';
      break;
    case 'Junio':
      filtro = '06';
      break;
    case 'Julio':
      filtro = '07';
      break;
    case 'Agosto':
      filtro = '08';
      break;
    case 'Setiembre':
      filtro = '09';
      break;
    case 'Octubre':
      filtro = '10';
      break;
    case 'Noviembre':
      filtro = '11';
      break;
    case 'Diciembre':
      filtro = '12';
      break;
  }
  for (var i = 0; i < lista.length; i++) {
    String mes_lista = lista[i]['f_emi'][3] + lista[i]['f_emi'][4];
    if (mes_lista == filtro) {
      nueva_list.add(lista[i]);
    }
  }
  //26/06/1999  3 4
  return nueva_list;
}

double Total(doc) {
  var suma = 0.00;
  for (var ind = 0; ind < doc.length; ind++) {
    suma += (doc[ind]['total'] * doc[ind]['cantidad']);
  }
  return suma;
}
