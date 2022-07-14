String num_letras(double numero) {
  String mostrar = "";
  int millones = calc_mill(numero);
  int miles = calc_miles((numero - millones));
  int centenas = (numero - miles - millones).toInt();
  int decimal = ((numero - (miles + centenas + millones)) * 100).round();

  if (millones > 999999) {
    mostrar += millonesimas(millones);
  }
  if (miles > 999) {
    mostrar += milesimas(miles);
  }
  if (centenas > 99) {
    mostrar += cent(centenas);
  } else if (centenas > 9) {
    mostrar += decenas(centenas);
  } else {
    mostrar += unidades(centenas);
  }
  if (decimal > 9) {
    mostrar += 'y ' + decimal.toString() + '/100';
  } else {
    mostrar += 'y 0' + decimal.toString() + '/100';
  }
  return mostrar;
}

int calc_mill(double cant) {
  int calcular = (cant / 1000000).toInt();
  calcular = calcular * 1000000;
  return calcular;
}

int calc_miles(double cant) {
  int calcular = (cant / 1000).toInt();
  calcular = calcular * 1000;
  return calcular;
}

String millonesimas(int cant) {
  int calcular = (cant / 1000000).toInt();
  String letras = "";
  if (calcular < 10) {
    if (calcular == 1) {
      letras = "Un Millon ";
      return letras;
    } else {
      letras = unidades(calcular);
    }
  } else if (calcular < 100) {
    letras = decenas(calcular);
  } else {
    var resta = calcular % 100;

    if (resta > 9) {
      letras = letras + cent(calcular);
    } else if (resta > 1) {
      letras = letras + cent(calcular);
      letras = letras + unidades(resta);
    } else if (resta != 0) {
      letras = "Ciento Un ";
    } else {
      letras = "Cien ";
    }
  }

  letras = letras + "Millones ";
  return letras;
}

String milesimas(int cant) {
  int calcular = (cant / 1000).toInt();
  String letras = "";
  if (calcular < 10) {
    if (calcular == 1) {
      letras = "";
    } else {
      letras = unidades(calcular);
    }
  } else if (calcular < 100) {
    letras = decenas(calcular);
  } else {
    var resta = calcular % 100; //101  1

    if (resta > 9) {
      letras = letras + cent(calcular);
    } else if (resta > 1) {
      letras = letras + cent(calcular);
      letras = letras + unidades(resta);
    } else if (resta != 0) {
      letras = "Ciento Un ";
    } else {
      letras = "Cien ";
    }
  }

  letras = letras + "Mil ";
  return letras;
}

String cent(int cant) {
  int calcular = (cant / 100).toInt();
  String letras = "";
  int resta = (cant - (calcular * 100)).toInt();
  switch (calcular) {
    case 1:
      if (resta > 0) {
        letras = "Ciento " + decenas(resta);
      } else {
        letras = "Cien ";
      }
      break;
    case 2:
      letras = "Doscientos ";
      if (resta > 0) {
        letras = letras + decenas(resta);
      }
      break;
    case 3:
      letras = "Trescientos ";
      if (resta > 0) {
        letras = letras + decenas(resta);
      }
      break;
    case 4:
      letras = "Cuatrocientos ";
      if (resta > 0) {
        letras = letras + decenas(resta);
      }
      break;
    case 5:
      letras = "Quinientos ";
      if (resta > 0) {
        letras = letras + decenas(resta);
      }
      break;
    case 6:
      letras = "Seiscientos ";
      if (resta > 0) {
        letras = letras + decenas(resta);
      }
      break;
    case 7:
      letras = "Setecientos ";
      if (resta > 0) {
        letras = letras + decenas(resta);
      }
      break;
    case 8:
      letras = "Ochocientos ";
      if (resta > 0) {
        letras = letras + decenas(resta);
      }
      break;
    case 9:
      letras = "Novecientos ";
      if (resta > 0) {
        letras = letras + decenas(resta);
      }
      break;
  }
  return letras;
}

String decenas(int cant) {
  int calcular = (cant / 10).toInt();
  String letras = "";
  int resta = (cant - (calcular * 10)).toInt();
  switch (calcular) {
    case 1:
      if (resta > 0) {
        letras = unidad1(resta);
      } else {
        letras = "Diez ";
      }
      break;
    case 2:
      if (resta > 0) {
        letras = "Veinti";
        letras = letras + unidades(resta).toLowerCase();
      } else {
        letras = "Veinte ";
      }
      break;
    case 3:
      letras = "Treinta ";
      if (resta > 0) {
        letras = letras + "y " + unidades(resta);
      }
      break;
    case 4:
      letras = "Cuarenta ";
      if (resta > 0) {
        letras = letras + "y " + unidades(resta);
      }
      break;
    case 5:
      letras = "Cincuenta ";
      if (resta > 0) {
        letras = letras + "y " + unidades(resta);
      }
      break;
    case 6:
      letras = "Sesenta ";
      if (resta > 0) {
        letras = letras + "y " + unidades(resta);
      }
      break;
    case 7:
      letras = "Setenta ";
      if (resta > 0) {
        letras = letras + "y " + unidades(resta);
      }
      break;
    case 8:
      letras = "Ochenta ";
      if (resta > 0) {
        letras = letras + "y " + unidades(resta);
      }
      break;
    case 9:
      letras = "Noventa ";
      if (resta > 0) {
        letras = letras + "y " + unidades(resta);
      }
      break;
  }
  return letras;
}

String unidad1(int cant) {
  String letras = "";
  switch (cant) {
    case 1:
      letras = "Once ";
      break;
    case 2:
      letras = "Doce ";
      break;
    case 3:
      letras = "Trece ";
      break;
    case 4:
      letras = "Catorce ";
      break;
    case 5:
      letras = "Quince ";
      break;
    case 6:
      letras = "Dieciseis ";
      break;
    case 7:
      letras = "Diecisiete ";
      break;
    case 8:
      letras = "Dieciocho ";
      break;
    case 9:
      letras = "Diecinueve ";
      break;
  }
  return letras;
}

String unidades(int cant) {
  String letras = "";
  switch (cant) {
    case 1:
      letras = "Un ";
      break;
    case 2:
      letras = "Dos ";
      break;
    case 3:
      letras = "Tres ";
      break;
    case 4:
      letras = "Cuatro ";
      break;
    case 5:
      letras = "Cinco ";
      break;
    case 6:
      letras = "Seis ";
      break;
    case 7:
      letras = "Siete ";
      break;
    case 8:
      letras = "Ocho ";
      break;
    case 9:
      letras = "Nueve ";
      break;
  }
  return letras;
}
