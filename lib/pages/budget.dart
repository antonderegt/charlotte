import 'package:flutter/material.dart';

import 'package:scoped_model/scoped_model.dart';

import '../widgets/ui_elements/drawer.dart';
import '../scoped_models/main.dart';
import './categorie_card.dart';

class BudgetPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _BudgetPageState();
  }
}

class _BudgetPageState extends State<BudgetPage> {
  final newCategorie = TextEditingController();
  final newTag = TextEditingController();

  Widget _buildCategorieList(List<String> categories, MainModel model) {
    Widget categorieCards;
    if (categories.length > 0 && !model.isLoading) {
      categorieCards = ListView.builder(
        itemBuilder: (BuildContext context, int index) =>
            CategorieCard(categories[index]),
        itemCount: categories.length,
      );
    } else if (model.isLoading) {
      categorieCards = Center(child: CircularProgressIndicator());
    } else {
      categorieCards =
          Center(child: Text('No categories found, please add some.'));
    }
    return categorieCards;
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<MainModel>(
        builder: (BuildContext context, Widget child, MainModel model) {
      return Scaffold(
        drawer: SideDrawer('budget'),
        appBar: AppBar(
          title: Text('Budget'),
        ),
        body: _buildCategorieList(model.categories, model),
        floatingActionButton: FloatingActionButton(
          key: Key('addCategorie'),
          child: Icon(Icons.add),
          tooltip: 'New categorie',
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
                            padding: EdgeInsets.all(10.0),
                            child: Text(
                              'Enter a new categorie name',
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.all(10.0),
                            child: TextField(controller: newCategorie),
                          ),
                          SizedBox(
                            height: 10.0,
                          ),
                          Container(
                            padding: EdgeInsets.all(10.0),
                            child: Text(
                              'Enter a new tag name',
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.all(10.0),
                            child: TextField(controller: newTag),
                          ),
                        ],
                      ),
                      floatingActionButton: FloatingActionButton(
                        key: Key('saveNewCategorie'),
                        child: Icon(Icons.save),
                        onPressed: () {
                          bool duplicate = false;
                          model.categories.forEach((cat) {
                            if (cat == newCategorie.text) {
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
                                          Text('You already have a categorie called: ${newCategorie.text}.'),
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
                            Navigator.of(context).pop();
                            model
                                .addTag(newCategorie.text, newTag.text)
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
    });
  }
}
