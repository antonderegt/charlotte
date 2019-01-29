import 'package:flutter/material.dart';

import 'package:scoped_model/scoped_model.dart';

import './pages/budget.dart';
import './pages/expenses.dart';
import './widgets/ui_elements/drawer.dart';
import './scoped_models/main.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final MainModel model = MainModel();
    return ScopedModel<MainModel>(
        model: model,
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Charlotte',
          theme: ThemeData(
            primarySwatch: Colors.blue,
          ),
          routes: {
            '/': (BuildContext context) => HomePage(title: 'Charlotte'),
            '/budget': (BuildContext context) => BudgetPage(),
            '/expenses': (BuildContext context) => ExpensesPage(),
          },
        ));
  }
}

class HomePage extends StatefulWidget {
  HomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: SideDrawer(null),
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'You have pushed the button this many times:',
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.display1,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ),
    );
  }
}
