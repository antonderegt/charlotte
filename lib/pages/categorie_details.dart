import 'package:flutter/material.dart';

import 'package:scoped_model/scoped_model.dart';

import '../scoped_models/main.dart';
import './tag_card.dart';

import '../models/budget.dart';

class CategorieDetailsPage extends StatefulWidget {
  final String categorie;

  CategorieDetailsPage(this.categorie);

  @override
  State<StatefulWidget> createState() {
    return _CategorieDetailsPageState();
  }
}

class _CategorieDetailsPageState extends State<CategorieDetailsPage> {
  final newTag = TextEditingController();

  List<Budget> _getBudgetsForCategorie(
      String categorieFilter, List<Budget> budgets) {
    List<Budget> budgetsForCategorie = [];
    budgets.forEach((budget) {
      if (budget.categorie == categorieFilter) {
        budgetsForCategorie.add(budget);
      }
    });
    return budgetsForCategorie;
  }

  Widget _buildCategorieList(
      List<Budget> allBudgets, MainModel model, String categorie) {
    List<Budget> budgets = _getBudgetsForCategorie(categorie, allBudgets);
    Widget categorieCards;
    if (budgets.length > 0 && !model.isLoading) {
      categorieCards = ListView.builder(
        itemBuilder: (BuildContext context, int index) =>
            TagCard(budgets[index]),
        itemCount: budgets.length,
      );
    } else if (model.isLoading) {
      categorieCards = Center(child: CircularProgressIndicator());
    } else {
      categorieCards = Center(child: Text('No tags found, please add some.'));
    }
    return categorieCards;
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant(
      builder: (BuildContext context, Widget child, MainModel model) {
        return Scaffold(
          appBar: AppBar(
            title: Text(widget.categorie),
          ),
          body: _buildCategorieList(model.allBudgets, model, widget.categorie),
          floatingActionButton: FloatingActionButton(
            child: Icon(Icons.add),
            onPressed: () {
              showModalBottomSheet(
                  context: context,
                  builder: (context) {
                    return SizedBox(
                      height: 300.0,
                      child: Scaffold(
                        body: Column(
                          children: <Widget>[
                            Container(
                              padding: EdgeInsets.all(30.0),
                              child: Text(
                                'Enter a new tag name',
                              ),
                            ),
                            SizedBox(
                              height: 10.0,
                            ),
                            Container(
                              padding: EdgeInsets.all(30.0),
                              child: TextField(controller: newTag),
                            ),
                          ],
                        ),
                        floatingActionButton: FloatingActionButton(
                          child: Icon(Icons.save),
                          onPressed: () {
                            bool duplicate = false;
                            model.tags.forEach((tag) {
                              if (tag == newTag.text) {
                                duplicate = true;
                                return;
                              }
                            });
                            if (duplicate) {
                              showDialog(
                                  context: context,
                                  builder: (context) {
                                    return AlertDialog(
                                      title: Text('Duplicate'),
                                      content: SingleChildScrollView(
                                        child: ListBody(
                                          children: <Widget>[
                                            Text(
                                                'You already have a categorie called: ${newTag.text}.'),
                                          ],
                                        ),
                                      ),
                                      actions: <Widget>[
                                        FlatButton(
                                          child: Text('Okay'),
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                          },
                                        ),
                                      ],
                                    );
                                  });
                            } else {
                              print('adding tag');
                              Navigator.of(context).pop();
                              model
                                  .addTag(widget.categorie, newTag.text)
                                  .then((_) => model.fetchBudgets());
                            }
                          },
                        ),
                      ),
                    );
                  });
            },
          ),
        );
      },
    );
  }
}
