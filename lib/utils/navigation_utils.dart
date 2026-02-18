import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class NavigationUtils extends ChangeNotifier {
  static bool initialized = false;

  static final List<Map<String, dynamic>> navigationList = [];

  static final Map<String, dynamic> elecBillCalculTab = {
    'Electric Bill Caculator': {
      'route': '/elec_bill_calcul',
      'expandable': 'false',
      'bold_text': ['/elec_bill_calcul'],
      'icon': Icons.electric_meter,
    },
  };

  static final Map<String, dynamic> toDoListTab = {
    'To Do List': {
      'route': '/to_do_list',
      'expandable': 'false',
      'bold_text': ['/to_do_list'],
      'icon': Icons.task,
    },
  };

  static final Map<String, dynamic> invoiceGenerationTab = {
    'Invoice Generation': {
      'route': '/invoice_generation',
      'expandable': 'false',
      'bold_text': ['/invoice_generation'],
      'icon': Icons.receipt_long,
    },
  };

  static initializeNavigationUtils() {
    navigationList.clear();
    navigationList.add(elecBillCalculTab);
    navigationList.add(toDoListTab);
    navigationList.add(invoiceGenerationTab);
    initialized = true;
  }
}
