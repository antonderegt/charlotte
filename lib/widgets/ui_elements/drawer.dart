import 'package:flutter/material.dart';

import 'package:scoped_model/scoped_model.dart';

import '../../scoped_models/main.dart';

class SideDrawer extends StatelessWidget {
  final String _selected;

  SideDrawer(this._selected);

  Widget _buildSideDrawer(BuildContext context) {
    return ScopedModelDescendant<MainModel>(
      builder: (BuildContext context, Widget child, MainModel model) {
        return Drawer(
          child: Column(
            children: <Widget>[
              AppBar(automaticallyImplyLeading: false, title: Text('Menu')),
              ListTile(
                leading: Icon(Icons.pie_chart_outlined),
                title: Text(
                  'Budget',
                  style: _selected == 'budget'
                      ? TextStyle(color: Colors.grey)
                      : TextStyle(color: Colors.black),
                ),
                onTap: () {
                  model.fetchCategories();
                  // .then((_) {
                    Navigator.pushReplacementNamed(context, '/budget');
                  // });
                },
              ),
              ListTile(
                leading: Icon(Icons.zoom_out_map),
                title: Text(
                  'Track Expenses',
                  style: _selected == 'expenses'
                      ? TextStyle(color: Colors.grey)
                      : TextStyle(color: Colors.black),
                ),
                onTap: () =>
                    Navigator.pushReplacementNamed(context, '/expenses'),
              ),
              ListTile(
                leading: Icon(Icons.show_chart),
                title: Text(
                  'Networth',
                  style: _selected == 'networth'
                      ? TextStyle(color: Colors.grey)
                      : TextStyle(color: Colors.black),
                ),
                onTap: () =>
                    Navigator.pushReplacementNamed(context, '/networth'),
              ),
              ListTile(
                leading: Icon(Icons.fast_forward),
                title: Text(
                  'Advice',
                  style: _selected == 'advice'
                      ? TextStyle(color: Colors.grey)
                      : TextStyle(color: Colors.black),
                ),
                onTap: () => Navigator.pushReplacementNamed(context, '/advice'),
              )
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return _buildSideDrawer(context);
  }
}
