import 'package:flutter/material.dart';

import 'package:scoped_model/scoped_model.dart';

import './tag_edit.dart';
import '../scoped_models/main.dart';
import '../models/budget.dart';

class TagCard extends StatelessWidget {
  final Budget budget;

  TagCard(this.budget);

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant(
      builder: (BuildContext context, Widget child, MainModel model) {
        return Dismissible(
          key: Key(budget.categorie),
          onDismissed: (DismissDirection direction) {
            // if (direction == DismissDirection.endToStart) {
              model.deleteTag(budget.id).then((_) {
                model.fetchBudgets();
              });
            // }
          },
          background: Container(
            color: Colors.red,
          ),
          child: ListTile(
            leading: Icon(Icons.navigate_next),
            title: Text(budget.tag),
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (BuildContext context) {
                    return TagEditPage(budget);
                  },
                ),
              );
            },
          ),
        );
      },
    );
  }
}
