

import 'package:expense_tracker/main.dart';
import 'package:expense_tracker/model/boxes.dart';
import 'package:expense_tracker/shared_preferences/sharedpreferences.dart';
import 'package:expense_tracker/widgets/chart/chart.dart';
import 'package:expense_tracker/widgets/expenses_list/expenses_list.dart';
import 'package:flutter/material.dart';

import '../model/expense.dart';
import 'new_expense.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Expenses extends StatefulWidget {
  Expenses({Key? key, required this.toggleTheme, required this.isDarkMode})
      : super(key: key);
  Function() toggleTheme;
  bool isDarkMode ;



  @override
  State<Expenses> createState() => _ExpensesState();
}

class _ExpensesState extends State<Expenses> {

  final List<Expense> _registeredExpenses = [
    Expense(
        title: "Web Course",
        price: 45.35,
        date: DateTime.now(),
        category: Category.work),
    Expense(
        title: "Cinema",
        price: 19.35,
        date: DateTime.now(),
        category: Category.leisure),
  ];
  void _openAddExpensesOverlay() {
    showModalBottomSheet(

        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        context: context,
        builder: (ctx) {
          return Container(
              decoration: BoxDecoration(
                color: Theme.of(context).scaffoldBackgroundColor,
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(20),
                  topLeft: Radius.circular(20),
                ),
              ),
              child: NewExpense(
                onSelectedExpense: (Expense expense) {
                  _addExpense(expense);

                },
              ));
        });
  }

  void _addExpense(Expense expense) {
    setState(() {
      _registeredExpenses.add(expense);
    });
  }

  void _deleteExpense(Expense expense) {
    final expenseIndex = _registeredExpenses.indexOf(expense);
    setState(() {
      _registeredExpenses.remove(expense);
    });
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text("Delete Expense"),
      duration: Duration(seconds: 4),
      action: SnackBarAction(
        label: "Undo",
        onPressed: () {
          setState(() {
            _registeredExpenses.insert(expenseIndex, expense);
          });
        },
      ),
    ));
  }

  @override
  void initState() {



    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    Widget mainContent = widget.isDarkMode == false
        ? Center(
            child: Column(
            children: [
              Image.asset(
                "asset/vector.jpg",
                width: 300,
              ),
              Text("NO Expense here please add more!"),
            ],
          ))
        : Center(
            child: Column(
            children: [
              Image.asset(
                "asset/vector3.jpg",
                width: 300,
              ),
              Text("NO Expense here please add more!"),
            ],
          ));
    if (_registeredExpenses.isNotEmpty) {
      mainContent = ExpensesList(
        expense: _registeredExpenses,
        onDeleteItem: _deleteExpense,
      );
    }
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            icon: const Icon(
              Icons.add,
            ),
            onPressed: _openAddExpensesOverlay,
          ),
          IconButton(
              onPressed: () {
                widget.toggleTheme();
               print(widget.isDarkMode);
              },
              icon: widget.isDarkMode == false
                  ? const Icon(Icons.dark_mode_rounded)
                  : const Icon(Icons.light_mode_rounded))
        ],
        title: Text(
          "Flutter Expense Tracker",
          style: TextStyle(fontSize: 24),
        ),
      ),
      body: width < height
          ? Column(
              children: [
                Chart(expenses: _registeredExpenses),
                Expanded(child: mainContent),
              ],
            )
          : Row(
              children: [
                Expanded(child: Chart(expenses: _registeredExpenses)),
                Expanded(child: mainContent),
              ],
            ),
    );
  }
}
