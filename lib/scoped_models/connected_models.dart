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

  Future<bool> addCategorie(String categorie) {
    _isLoading = true;
    notifyListeners();
    return http
        .post(
            'https://export-demo.firebaseio.com/budgets/${_userId}/categories.json',
            body: json.encode(categorie))
        .then((http.Response response) {
      _isLoading = true;
      notifyListeners();
      return true;
    }).catchError((Error error) {
      _isLoading = false;
      notifyListeners();
      return false;
    });
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
      tagResponseData.forEach((String name, dynamic tagId) {
        updateBudget(tagId, categorie, tag, '0', '0', '0', '0', '0', '0', '0',
            '0', '0', '0', '0', '0');
      });
      return true;
    }).catchError((Error error) {
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

    //       return _products.indexWhere((Product product) {
    //   return product.id == _selProductId;
    // });

      // final updatedBudget = Budget(
      //     id: selectedProduct.id,
      //     title: title,
      //     description: description,
      //     image: image,
      //     price: price,
      //     userEmail: selectedProduct.userEmail,
      //     userId: selectedProduct.userId);
      // _budgets[selectedProductIndex] = updatedBudget;

      _isLoading = false;
      notifyListeners();
      return true;
    }).catchError((Error error) {
      _isLoading = false;
      notifyListeners();
      return false;
    });
  }

  Future<dynamic> fetchCategories() {
    _isLoading = true;
    notifyListeners();
    return http
        .get(
            'https://export-demo.firebaseio.com/budgets/${_userId}/categories.json')
        .then((http.Response response) {
      final List<String> fetchedCategorieList = [];
      final Map<String, dynamic> categorieListData = json.decode(response.body);
      if (categorieListData == null) {
        _isLoading = false;
        notifyListeners();
        return;
      }
      categorieListData.forEach((String categorieId, dynamic categorieData) {
        final String categorie = categorieData;
        fetchedCategorieList.add(categorie);
      });
      _categories = fetchedCategorieList;
      _isLoading = false;
      print('');
      print('Printing categories');
      print(_categories);
      print('');
      notifyListeners();
    }).catchError((Error error) {
      _isLoading = false;
      notifyListeners();
      return;
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
      });
      _budgets = fetchedBudgetList;
      _isLoading = false;
      print('');
      print('Printing Budgets');
      print(_budgets);
      print('');
      notifyListeners();
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
        .delete('https://export-demo.firebaseio.com/budgets/${_userId}/budgets/${tagId}.json')
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

  Future<bool> deleteCategorie(String categorie) {
    _isLoading = true;
    notifyListeners();
    return http
        .delete('https://export-demo.firebaseio.com/budgets/${_userId}/budgets/${categorie}.json')
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
}

mixin UtilityModel on ConnectedModels {
  bool get isLoading {
    return _isLoading;
  }
}
