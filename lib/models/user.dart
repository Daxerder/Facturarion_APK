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
  int id = 0;
  double total = 0.00;
  int cantidad = 0;
  String descripcion = '';

  //Producto(this.total, this.cantidad, this.descripcion);

  /*Producto() {
    total = 0.00;
    cantidad = 0;
    descripcion = '';
  }*/
}

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
  List<Producto> productos = [];
  String moneda = '';

  FoB() {
    serie = '';
    correlativo = 0;
    cliente = Empresa();
    f_emi = '';
    f_venc = '';
    productos = [];
    moneda = '';
  }
}
