import 'dart:convert';
import 'package:meta/meta.dart';

Producto productoFromJson(String str) => Producto.fromJson(json.decode(str));
String productoToJson(Producto data) => json.encode(data.toJson());

class User {
  String user = '';
  String password = '';

  User(this.user, this.password);
}

class Empresa {
  String direccion = '';
  String documento = '';
  String empresa = '';

  Empresa() {
    direccion = '';
    documento = '';
    empresa = '';
  }
}

class Producto {
  int id;
  double total;
  double cantidad;
  String descripcion;

  Producto({
    this.id = 0,
    @required this.cantidad = 0,
    @required this.descripcion = '',
    @required this.total = 0.0,
  });

  factory Producto.fromJson(Map<String, dynamic> json) => Producto(
        id: json['id'],
        cantidad: json['cantidad'],
        descripcion: json['descripcion'],
        total: json['total'],
      );

  Map<String, dynamic> toJson() => {
        "cantidad": cantidad,
        "descripcion": descripcion,
        "total": total,
      };
}

//falta implementar
class Form_pago {
  String forma = '';
  int cuotas = 0;
  List<String> fechas = [];
}

class FoB {
  String serie = '';
  int correlativo = 0;
  Empresa cliente = Empresa();
  String f_emi = '';
  String f_venc = '';
  //List<Producto> productos = [];
  String moneda = '';

  FoB() {
    serie = '';
    correlativo = 0;
    cliente = Empresa();
    f_emi = '';
    f_venc = '';
    //productos = [];
    moneda = '';
  }
}
