import 'package:intl/intl.dart';

class UnitMoney {
  double convertToVND = 23000;
  double convertToEuro = 1.036;
  String convertMoney(double valueMoney, String unitMoney) {
    if (unitMoney == "₫") {
      return NumberFormat("#,###", "en_US").format(double.parse(
          (valueMoney * UnitMoney().convertToVND).toStringAsFixed(2)));
    } else if (unitMoney == "₤") {
      return double.parse(
              (valueMoney * UnitMoney().convertToEuro).toStringAsFixed(2))
          .toString();
    }
    return valueMoney.toString();
  }

  // formatMoney() {
  //   var f = NumberFormat("###.00");

  // }
}
