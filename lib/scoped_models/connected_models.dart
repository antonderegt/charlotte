import 'dart:convert';
// import 'dart:async';

import 'package:scoped_model/scoped_model.dart';
import 'package:http/http.dart' as http;

import '../models/budget.dart';

mixin ConnectedModels on Model {
  List<Budget> _budgets = [];
  List<String> _categories = [];
  List<String> _tags = [];
  bool _isLoading = false;
  final _userId = 'userid_test';
  int _budgetIndex;
}

mixin BudgetsModel on ConnectedModels {
  List<Budget> get allBudgets {
    return List.from(_budgets);
  }

  List<String> get categories {
    return List.from(_categories);
  }

  List<String> get tags {
    return List.from(_tags);
  }

  Future<bool> addTag(String categorie, String tag) {
    final Map<String, dynamic> updateData = {
      'categorie': categorie,
      'tag': tag,
    };
    _isLoading = true;
    notifyListeners();
    return http
        .post(
            'https://export-demo.firebaseio.com/budgets/${_userId}/budgets.json',
            body: json.encode(updateData))
        .then((http.Response response) {
      final Map<String, dynamic> tagResponseData = json.decode(response.body);
      tagResponseData.forEach((String name, dynamic budgetId) {
        updateBudget(budgetId, categorie, tag, '10', '0', '0', '0', '0', '0',
            '0', '0', '0', '0', '0', '0');
      });

      print('Adding tag');
      return true;
    }).catchError((Error error) {
      print('');
      print('Error:');
      print(error);
      print('');
      _isLoading = false;
      notifyListeners();
      return false;
    });
  }

  Future<bool> updateBudget(
      String budgetId,
      String categorie,
      String tag,
      String january,
      String february,
      String march,
      String april,
      String may,
      String june,
      String july,
      String august,
      String september,
      String october,
      String november,
      String december) {
    _isLoading = true;
    notifyListeners();
    final Map<String, dynamic> updateData = {
      'categorie': categorie,
      'tag': tag,
      'january': january,
      'february': february,
      'march': march,
      'april': april,
      'may': may,
      'june': june,
      'july': july,
      'august': august,
      'september': september,
      'october': october,
      'november': november,
      'december': december,
    };
    return http
        .put(
            'https://export-demo.firebaseio.com/budgets/${_userId}/budgets/${budgetId}.json',
            body: json.encode(updateData))
        .then((http.Response response) {
      final Budget updatedBudget = Budget(
        id: budgetId,
        categorie: categorie,
        tag: tag,
        january: january,
        february: february,
        march: march,
        april: april,
        may: may,
        june: june,
        july: july,
        august: august,
        september: september,
        october: october,
        november: november,
        december: december,
      );

      if (_budgetIndex == null) {
        _budgetIndex = _budgets.length;
      }

      _budgets[_budgetIndex] = updatedBudget;
      _budgetIndex = null;
      _isLoading = false;
      notifyListeners();
      return true;
    }).catchError((Error error) {
      print('');
      print('Error:');
      print(error);
      print('');
      _isLoading = false;
      notifyListeners();
      return false;
    });
  }

  Future<dynamic> fetchBudgets() {
    _isLoading = true;
    notifyListeners();
    return http
        .get(
            'https://export-demo.firebaseio.com/budgets/${_userId}/budgets.json')
        .then((http.Response response) {
      final List<Budget> fetchedBudgetList = [];
      final List<String> fetchedCategorieList = [];
      final List<String> filteredCategories = [];
      final List<String> fetchedTagList = [];
      final Map<String, dynamic> budgetListData = json.decode(response.body);
      if (budgetListData == null) {
        _isLoading = false;
        notifyListeners();
        return;
      }
      budgetListData.forEach((String budgetId, dynamic budgetData) {
        final Budget _newBudget = Budget(
          id: budgetId,
          tag: budgetData['tag'],
          categorie: budgetData['categorie'],
          january: budgetData['january'].toString(),
          february: budgetData['february'].toString(),
          march: budgetData['march'].toString(),
          april: budgetData['april'].toString(),
          may: budgetData['may'].toString(),
          june: budgetData['june'].toString(),
          july: budgetData['july'].toString(),
          august: budgetData['august'].toString(),
          september: budgetData['september'].toString(),
          october: budgetData['october'].toString(),
          november: budgetData['november'].toString(),
          december: budgetData['december'].toString(),
        );
        fetchedBudgetList.add(_newBudget);
        fetchedCategorieList.add(_newBudget.categorie);

        fetchedCategorieList.forEach((cat) {
          if (filteredCategories.indexOf(cat) == -1) {
            filteredCategories.add(cat);
          }
        });
        fetchedTagList.add(_newBudget.tag);
      });
      _budgets = fetchedBudgetList;
      _categories = filteredCategories;
      _tags = fetchedTagList;
      _isLoading = false;
      print('');
      print('Adding Budgets');
      print('');
      notifyListeners();
      return;
    }).catchError((Error error) {
      print('');
      print('Printing Error');
      print(error);
      print('');
      _isLoading = false;
      notifyListeners();
      return;
    });
  }

  Future<bool> deleteTag(String tagId) {
    _isLoading = true;
    notifyListeners();
    return http
        .delete(
            'https://export-demo.firebaseio.com/budgets/${_userId}/budgets/${tagId}.json')
        .then((http.Response response) {
      _isLoading = false;
      notifyListeners();
      return true;
    }).catchError((Error error) {
      _isLoading = false;
      notifyListeners();
      return false;
    });
  }

  Future<bool> deleteCategorie(String categorieName) {
    _isLoading = true;
    notifyListeners();
    _budgets.forEach((budget) {
      if (budget.categorie == categorieName) {
        deleteTag(budget.id);
        _isLoading = false;
        notifyListeners();
      }
    });
    Future<bool> onSuccess = Future.value(true);
    return onSuccess;
  }

  void setBudgetIndex(Budget budget) {
    _budgetIndex = _budgets.indexOf(budget);
  }
}

mixin UtilityModel on ConnectedModels {
  bool get isLoading {
    return _isLoading;
  }
}
