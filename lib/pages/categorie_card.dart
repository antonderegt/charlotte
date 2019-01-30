import 'package:flutter/material.dart';

import 'package:scoped_model/scoped_model.dart';

import './categorie_details.dart';
import '../scoped_models/main.dart';

class CategorieCard extends StatelessWidget {
  final String categorie;

  CategorieCard(this.categorie);

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant(
        builder: (BuildContext context, Widget child, MainModel model) {
      return Dismissible(
        key: Key(categorie),
        onDismissed: (DismissDirection direction) {
            // if (direction == DismissDirection.endToStart) {
              model.deleteCategorie(categorie).then((_) {
                model.fetchBudgets();
              });
            // }
          },
          background: Container(
            color: Colors.red,
          ),
        child: ListTile(
          leading: Icon(Icons.navigate_next),
          title: Text(categorie),
          onTap: () {
            // model.fetchBudgets();
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (BuildContext context) {
                  return CategorieDetailsPage(categorie);
                },
              ),
            );
          },
        ),
      );
    });
  }
}
