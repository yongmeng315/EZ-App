import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class NavigationUtils extends ChangeNotifier {
  static bool initialized = false;

  static final List<Map<String, dynamic>> navigationList = [];

  static final Map<String, dynamic> elecBillCalculTab = {
    'Electric Bill Caculation': {
      'route': '/elec_bill_calcul',
      'expandable': 'false',
      'bold_text': ['/elec_bill_calcul'],
      'icon': Icons.electric_meter,
    },
  };

  static initializeNavigationUtils() {
    navigationList.clear();
    navigationList.add(elecBillCalculTab);
    initialized = true;
  }
}
