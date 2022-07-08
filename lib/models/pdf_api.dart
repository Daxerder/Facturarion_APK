import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:gofact/models/clases.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/widgets.dart';

class User {
  final String name;
  final int age;

  const User({required this.name, required this.age});
}

/*List<Producto> prod = [
  Producto(cantidad: 1, descripcion: "descripcion", total: 2),
  Producto(cantidad: 2, descripcion: "descripcion1", total: 20.0)
];*/

double calcular_total(List<Producto> lista) {
  double numero = 0.00;
  for (var i = 0; i < lista.length; i++) {
    numero += lista[i].total * lista[i].cantidad;
  }
  return numero;
}

double calcular_base(double numero) {
  return numero / 1.18;
}

double calcular_igv(double numero) {
  return numero * 0.18;
}

String tipo_mon(String moneda) {
  if (moneda == 'Soles') {
    return "S/.";
  } else {
    return '\$';
  }
}

class PdfApi {
  static Future<Archivo> generar(
      FoB comprobante, List<Producto> productos) async {
    final pdf = Document();
    //documento producto
    double total = calcular_total(productos);
    double base = calcular_base(total);
    double igv = calcular_igv(base);

    String moneda = tipo_mon(comprobante.moneda);

    pdf.addPage(
      MultiPage(
        margin: const EdgeInsets.all(20),
        build: (context) => <Widget>[
          Container(
            decoration: const BoxDecoration(
              border: Border(
                top: BorderSide(width: 1),
                bottom: BorderSide(width: 1),
                right: BorderSide(width: 1),
                left: BorderSide(width: 1),
              ),
            ),
            child: Column(
              children: <Widget>[
                //primer Row Cambiar numero de factura o boleta
                Container(
                  margin: const EdgeInsets.only(
                    top: 10,
                    bottom: 5,
                    right: 10,
                    left: 10,
                  ),
                  padding: const EdgeInsets.only(bottom: 5),
                  decoration: const BoxDecoration(
                    border: Border(
                      bottom: BorderSide(width: 1),
                    ),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          children: [
                            Align(
                              alignment: Alignment.centerLeft,
                              child: Text("GO-FACT"),
                            ),
                            Align(
                              alignment: Alignment.centerLeft,
                              child: Text("GO-FACT"),
                            ),
                            Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                  "AV SANTIAGO DE SURCO N° 4717, SANTIAGO DE SURCO 15039"),
                            ),
                            Align(
                              alignment: Alignment.centerLeft,
                              child: Text("LIMA-LIMA"),
                            ),
                          ],
                        ),
                      ),
                      //SizedBox(width: 10),
                      Align(
                        alignment: Alignment.centerRight,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 25, vertical: 10),
                          decoration: const BoxDecoration(
                            border: Border(
                              top: BorderSide(width: 2),
                              bottom: BorderSide(width: 2),
                              right: BorderSide(width: 2),
                              left: BorderSide(width: 2),
                            ),
                          ),
                          child: Column(
                            children: [
                              (comprobante.serie == 'F001')
                                  ? Text("FACTURA ELECTRONICA")
                                  : Text("BOLETA ELECTRONICA"),
                              Text("RUC: 20725191109"),
                              Text(comprobante.serie +
                                  '-' +
                                  comprobante.correlativo.toString()),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                //Segundo Row fecha de emision y datos de factura
                Container(
                  margin: const EdgeInsets.only(
                    //top: 10,
                    //bottom: 5,
                    //right: 10,
                    left: 10,
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(children: [
                          //Fecha de Emision
                          Row(children: [
                            Expanded(
                              child: Align(
                                alignment: Alignment.centerLeft,
                                child: Text("Fecha de Emisión"),
                              ),
                            ),
                            Text(":"),
                            Expanded(
                              child: Text(comprobante.f_emi),
                            ),
                          ]),
                          //Fecha de Vencimiento
                          Row(children: [
                            Expanded(
                              child: Align(
                                alignment: Alignment.centerLeft,
                                child: Text("Fecha de Vencimiento"),
                              ),
                            ),
                            Text(":"),
                            Expanded(
                              child: Text(comprobante.f_venc),
                            ),
                          ]),
                          //Empresa Nombre cliente
                          Row(children: [
                            Expanded(
                              child: Align(
                                alignment: Alignment.centerLeft,
                                child: Text("Señor(es)"),
                              ),
                            ),
                            Text(":"),
                            Expanded(
                              child: Text(
                                  comprobante.cliente.empresa.toUpperCase()),
                            ),
                          ]),
                          //Ruc Cliente
                          Row(children: [
                            Expanded(
                              child: Align(
                                alignment: Alignment.centerLeft,
                                child: (comprobante.serie == 'F001')
                                    ? Text("Ruc")
                                    : Text("RUC/DNI"),
                              ),
                            ),
                            Text(":"),
                            Expanded(
                              child: Text(comprobante.cliente.documento),
                            ),
                          ]),
                          //Direccion del receptor
                          Row(children: [
                            Expanded(
                              child: Align(
                                alignment: Alignment.centerLeft,
                                child: Text("Dirección del Cliente"),
                              ),
                            ),
                            Text(":"),
                            Expanded(
                              child: Text(comprobante.cliente.direccion),
                            ),
                          ]),
                          //Tipo de Moneda
                          Row(children: [
                            Expanded(
                              child: Align(
                                alignment: Alignment.centerLeft,
                                child: Text("Tipo de Moneda"),
                              ),
                            ),
                            Text(":"),
                            Expanded(
                              child: Text(comprobante.moneda),
                            ),
                          ]),
                          //Observacion
                          Row(children: [
                            Expanded(
                              child: Align(
                                alignment: Alignment.centerLeft,
                                child: Text("Observación"),
                              ),
                            ),
                            Text(":"),
                            Expanded(
                              child: Text(""),
                            ),
                          ]),
                        ]),
                      ),
                      Expanded(
                        child: Align(
                          alignment: Alignment.topCenter,
                          child: Text("Forma de Pago: Contado"),
                        ),
                      ),
                    ],
                  ),
                ),
                //Productos
                Container(
                  decoration: const BoxDecoration(
                    border: Border(
                      left: BorderSide(width: 1),
                      top: BorderSide(width: 1),
                      right: BorderSide(width: 1),
                      bottom: BorderSide(width: 1),
                    ),
                  ),
                  margin: const EdgeInsets.only(
                    top: 5,
                    bottom: 5,
                    right: 5,
                    left: 5,
                  ),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Container(
                              decoration: const BoxDecoration(
                                  border: Border(bottom: BorderSide(width: 1))),
                              margin:
                                  const EdgeInsets.only(left: 5, right: 2.5),
                              child:
                                  Text("Cantidad", textAlign: TextAlign.center),
                            ),
                          ),
                          Expanded(
                            child: Container(
                              decoration: const BoxDecoration(
                                  border: Border(bottom: BorderSide(width: 1))),
                              margin: const EdgeInsets.only(right: 2.5),
                              child: Text("Unidad Medida",
                                  textAlign: TextAlign.center),
                            ),
                          ),
                          Expanded(
                            flex: 2,
                            child: Container(
                              decoration: const BoxDecoration(
                                  border: Border(bottom: BorderSide(width: 1))),
                              margin: const EdgeInsets.only(right: 2.5),
                              child: Text("Descripcion"),
                            ),
                          ),
                          Expanded(
                            child: Container(
                              decoration: const BoxDecoration(
                                  border: Border(bottom: BorderSide(width: 1))),
                              margin: const EdgeInsets.only(right: 2.5),
                              child: Text("Valor Unitario",
                                  textAlign: TextAlign.center),
                            ),
                          ),
                          Expanded(
                            child: Container(
                              decoration: const BoxDecoration(
                                  border: Border(bottom: BorderSide(width: 1))),
                              margin: const EdgeInsets.only(right: 5),
                              child:
                                  Text("ICBPER", textAlign: TextAlign.center),
                            ),
                          ),
                        ],
                      ),
                      //Detalles de productos
                      ListView.builder(
                        //shrinkWrap: true,
                        itemCount: productos.length,
                        itemBuilder: (context, index) {
                          Producto prod = productos[index];
                          return Row(
                            children: [
                              Expanded(
                                child: Container(
                                  margin: const EdgeInsets.only(
                                      left: 5, right: 2.5),
                                  child: Text("${prod.cantidad}",
                                      textAlign: TextAlign.right),
                                ),
                              ),
                              Expanded(
                                child: Container(
                                  margin: const EdgeInsets.only(right: 2.5),
                                  child: Text("UNIDAD",
                                      textAlign: TextAlign.center),
                                ),
                              ),
                              Expanded(
                                flex: 2,
                                child: Container(
                                  margin: const EdgeInsets.only(right: 2.5),
                                  child: Text(prod.descripcion),
                                ),
                              ),
                              Expanded(
                                child: Container(
                                  margin: const EdgeInsets.only(right: 2.5),
                                  //"${prod.cantidad * prod.total}"
                                  child: Text(prod.total.toStringAsFixed(2),
                                      textAlign: TextAlign.right),
                                ),
                              ),
                              Expanded(
                                child: Container(
                                  margin: const EdgeInsets.only(right: 5),
                                  child:
                                      Text("0.00", textAlign: TextAlign.right),
                                ),
                              ),
                            ],
                          );
                        },
                      ),
                    ],
                  ),
                ),
                //Cuerpo valor de adquisiciones
                Row(
                  children: [
                    //Izquierda
                    Expanded(
                      child: Container(
                        margin: const EdgeInsets.only(left: 10),
                        child: Column(
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  flex: 2,
                                  child: Text(
                                      "Valor de Venta de Operaciones Gratuitas",
                                      style: const TextStyle(fontSize: 9.5)),
                                ),
                                SizedBox(width: 1),
                                Text(":"),
                                SizedBox(width: 1),
                                Expanded(
                                  child: Container(
                                    padding: const EdgeInsets.only(left: 2.5),
                                    decoration: const BoxDecoration(
                                      border: Border(
                                        left: BorderSide(width: 1),
                                        top: BorderSide(width: 1),
                                        right: BorderSide(width: 1),
                                        bottom: BorderSide(width: 1),
                                      ),
                                    ),
                                    child: Text("S/.0.00"),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 25),
                            Text("SON: "),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(width: 3),
                    //Derecha
                    Expanded(
                      child: Container(
                        margin: const EdgeInsets.only(right: 10, bottom: 10),
                        padding:
                            const EdgeInsets.only(top: 5, bottom: 5, right: 5),
                        decoration: const BoxDecoration(
                          border: Border(
                            left: BorderSide(width: 1),
                            top: BorderSide(width: 1),
                            right: BorderSide(width: 1),
                            bottom: BorderSide(width: 1),
                          ),
                        ),
                        child: Column(
                          children: [
                            //SUBTOTAL
                            Row(
                              children: [
                                Expanded(
                                    child: Text("SubTotal Ventas",
                                        textAlign: TextAlign.right)),
                                SizedBox(width: 1),
                                Text(":"),
                                SizedBox(width: 1),
                                Expanded(
                                    child: Container(
                                        padding:
                                            const EdgeInsets.only(right: 2.5),
                                        decoration: const BoxDecoration(
                                          border: Border(
                                            left: BorderSide(width: 1),
                                            top: BorderSide(width: 1),
                                            right: BorderSide(width: 1),
                                            bottom: BorderSide(width: 1),
                                          ),
                                        ),
                                        child: Text(
                                            moneda +
                                                ' ' +
                                                base.toStringAsFixed(2),
                                            textAlign: TextAlign.right))),
                              ],
                            ),
                            SizedBox(height: 3),
                            //Valor Venta
                            Row(
                              children: [
                                Expanded(
                                    child: Text("Valor Venta",
                                        textAlign: TextAlign.right)),
                                SizedBox(width: 1),
                                Text(":"),
                                SizedBox(width: 1),
                                Expanded(
                                    child: Container(
                                        padding:
                                            const EdgeInsets.only(right: 2.5),
                                        decoration: const BoxDecoration(
                                          border: Border(
                                            left: BorderSide(width: 1),
                                            top: BorderSide(width: 1),
                                            right: BorderSide(width: 1),
                                            bottom: BorderSide(width: 1),
                                          ),
                                        ),
                                        child: Text(
                                            moneda +
                                                ' ' +
                                                base.toStringAsFixed(2),
                                            textAlign: TextAlign.right))),
                              ],
                            ),
                            SizedBox(height: 3),
                            //DESCUENTOS
                            Row(
                              children: [
                                Expanded(
                                    child: Text("Descuentos",
                                        textAlign: TextAlign.right)),
                                SizedBox(width: 1),
                                Text(":"),
                                SizedBox(width: 1),
                                Expanded(
                                    child: Container(
                                        padding:
                                            const EdgeInsets.only(right: 2.5),
                                        decoration: const BoxDecoration(
                                          border: Border(
                                            left: BorderSide(width: 1),
                                            top: BorderSide(width: 1),
                                            right: BorderSide(width: 1),
                                            bottom: BorderSide(width: 1),
                                          ),
                                        ),
                                        child: Text("$moneda 0.00",
                                            textAlign: TextAlign.right))),
                              ],
                            ),
                            SizedBox(height: 3),
                            //IGV
                            Row(
                              children: [
                                Expanded(
                                    child: Text("IGV",
                                        textAlign: TextAlign.right)),
                                SizedBox(width: 1),
                                Text(":"),
                                SizedBox(width: 1),
                                Expanded(
                                    child: Container(
                                        padding:
                                            const EdgeInsets.only(right: 2.5),
                                        decoration: const BoxDecoration(
                                          border: Border(
                                            left: BorderSide(width: 1),
                                            top: BorderSide(width: 1),
                                            right: BorderSide(width: 1),
                                            bottom: BorderSide(width: 1),
                                          ),
                                        ),
                                        child: Text(
                                            moneda +
                                                ' ' +
                                                igv.toStringAsFixed(2),
                                            textAlign: TextAlign.right))),
                              ],
                            ),
                            SizedBox(height: 3),
                            //ICBPER
                            Row(
                              children: [
                                Expanded(
                                    child: Text("ICBPER",
                                        textAlign: TextAlign.right)),
                                SizedBox(width: 1),
                                Text(":"),
                                SizedBox(width: 1),
                                Expanded(
                                    child: Container(
                                        padding:
                                            const EdgeInsets.only(right: 2.5),
                                        decoration: const BoxDecoration(
                                          border: Border(
                                            left: BorderSide(width: 1),
                                            top: BorderSide(width: 1),
                                            right: BorderSide(width: 1),
                                            bottom: BorderSide(width: 1),
                                          ),
                                        ),
                                        child: Text("$moneda 0.00",
                                            textAlign: TextAlign.right))),
                              ],
                            ),
                            SizedBox(height: 3),
                            //TOTAL
                            Row(
                              children: [
                                Expanded(
                                    child: Text("Importe Total",
                                        textAlign: TextAlign.right)),
                                SizedBox(width: 1),
                                Text(":"),
                                SizedBox(width: 1),
                                Expanded(
                                    child: Container(
                                        padding:
                                            const EdgeInsets.only(right: 2.5),
                                        decoration: const BoxDecoration(
                                          border: Border(
                                            left: BorderSide(width: 1),
                                            top: BorderSide(width: 1),
                                            right: BorderSide(width: 1),
                                            bottom: BorderSide(width: 1),
                                          ),
                                        ),
                                        child: Text(
                                            moneda +
                                                ' ' +
                                                total.toStringAsFixed(2),
                                            textAlign: TextAlign.right))),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                //Text("2"),
              ],
            ),
          ),
        ],
      ),
    );

    //return saveDocument(name: 'ejemplo2.pdf', pdf: pdf);
    String url = await uploadFile(
        pdf: pdf,
        nombre: comprobante.serie + '-' + comprobante.correlativo.toString());
    File file = await saveDocument(
        name: comprobante.serie + '-' + comprobante.correlativo.toString(),
        pdf: pdf);
    Archivo archivo = Archivo(url, file);
    return archivo;
  }

  static Future<String> uploadFile(
      {required Document pdf, required String nombre}) async {
    final bytes = await pdf.save();
    //guardamos en cache temporal
    final dir = await getTemporaryDirectory();
    final file = File('${dir.path}/$nombre.pdf');

    final ref = FirebaseStorage.instance.ref().child('$nombre.pdf');

    UploadTask uploadTask = ref.putFile(await file.writeAsBytes(bytes));

    final snapshot = await uploadTask.whenComplete(() {});

    final urlDownload = await snapshot.ref.getDownloadURL();

    print("Donwload Link: $urlDownload");
    return urlDownload;
  }

  static Future<File> saveDocument({
    required String name,
    required Document pdf,
  }) async {
    final bytes = await pdf.save();

    final dir = await getTemporaryDirectory();
    final file = File('${dir.path}/$name.pdf');

    await file.writeAsBytes(bytes);

    return file;
  }

  static Future openFile(File file) async {
    final url = file.path;
    await OpenFile.open(url);
  }
}
