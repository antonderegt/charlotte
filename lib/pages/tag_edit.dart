import 'package:flutter/material.dart';

import 'package:scoped_model/scoped_model.dart';

import '../scoped_models/main.dart';

import '../models/budget.dart';

class AmountFieldValidator {
  static String validate(String value) {
    return value.isEmpty || !RegExp(r'^(?:[1-9]\d*|0)?(?:\.\d+)?$').hasMatch(value) ? 'Price is required and it should be a number' : null;
  }
}

class TagEditPage extends StatefulWidget {
  final Budget budget;

  TagEditPage(this.budget);

  @override
  State<StatefulWidget> createState() {
    return _TagEditPageState();
  }
}

class _TagEditPageState extends State<TagEditPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final Map<String, dynamic> _formData = {
    'january': null,
    'february': null,
    'march': null,
    'april': null,
    'may': null,
    'june': null,
    'july': null,
    'august': null,
    'september': null,
    'october': null,
    'november': null,
    'december': null,
  };

  Widget _buildAmountTextField(String budget, String month) {
    return TextFormField(
      decoration: InputDecoration(
        labelText: month,
      ),
      keyboardType: TextInputType.number,
      initialValue: budget == 'null' || budget == null ? '0' : budget,
      validator: AmountFieldValidator.validate,
      onSaved: (String value) {
        _formData[month] = value;
      },
    );
  }

  void _submitForm(Function setBudgetIndex, Function updateBudget,
      String budgetId, String categorie, String tag) {
    if (!_formKey.currentState.validate()) {
      return;
    }
    _formKey.currentState.save();
    setBudgetIndex(widget.budget);
    updateBudget(
      budgetId,
      categorie,
      tag,
      _formData['january'],
      _formData['february'],
      _formData['march'],
      _formData['april'],
      _formData['may'],
      _formData['june'],
      _formData['july'],
      _formData['august'],
      _formData['september'],
      _formData['october'],
      _formData['november'],
      _formData['december'],
    ).then((bool success) {
      if (success) {
        Navigator.pushReplacementNamed(context, '/budget');
      } else {
        showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text('Something went wrong'),
                content: Text('Please try again'),
                actions: <Widget>[
                  FlatButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: Text('Okay'),
                  )
                ],
              );
            });
      }
    });
  }

  Widget _buildPageContent(BuildContext context, Budget budget) {
    final double deviceWidth = MediaQuery.of(context).size.width;
    final double targetWidth = deviceWidth > 550.0 ? 500 : deviceWidth * 0.95;
    final double targetPadding = deviceWidth - targetWidth;

    return GestureDetector(
      onTap: () {
        FocusScope.of(context).requestFocus(FocusNode());
      },
      child: Container(
        width: targetWidth,
        margin: EdgeInsets.all(10.0),
        child: Form(
          key: _formKey,
          child: ListView(
            padding: EdgeInsets.symmetric(horizontal: targetPadding / 4),
            children: <Widget>[
              _buildAmountTextField(budget.january, 'january'),
              _buildAmountTextField(budget.february, 'february'),
              _buildAmountTextField(budget.march, 'march'),
              _buildAmountTextField(budget.april, 'april'),
              _buildAmountTextField(budget.may, 'may'),
              _buildAmountTextField(budget.june, 'june'),
              _buildAmountTextField(budget.july, 'july'),
              _buildAmountTextField(budget.august, 'august'),
              _buildAmountTextField(budget.september, 'september'),
              _buildAmountTextField(budget.october, 'october'),
              _buildAmountTextField(budget.november, 'november'),
              _buildAmountTextField(budget.december, 'december'),
              SizedBox(
                height: 10.0,
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant(
      builder: (BuildContext context, Widget child, MainModel model) {
        return Scaffold(
          appBar: AppBar(
            title: Text(widget.budget.tag),
          ),
          body: model.isLoading
              ? Center(child: CircularProgressIndicator())
              : _buildPageContent(context, widget.budget),
          floatingActionButton: FloatingActionButton(
            child: Icon(Icons.save),
            tooltip: 'Save',
            onPressed: () {
              _submitForm(model.setBudgetIndex, model.updateBudget,
                  widget.budget.id, widget.budget.categorie, widget.budget.tag);
            },
          ),
        );
      },
    );
  }
}
