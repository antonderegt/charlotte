import 'package:flutter/material.dart';

import '../widgets/ui_elements/drawer.dart';

class ExpensesPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: SideDrawer('expenses'),
      appBar: AppBar(
        title: Text('Expenses'),
      ),
      body: Center(
        child: Text('EXPENSES'),
      ),
    );
  }
}
