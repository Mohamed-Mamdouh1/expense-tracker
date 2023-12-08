import 'package:expense_tracker/main.dart';
import 'package:expense_tracker/widgets/expenses_list/expenses_item.dart';
import 'package:flutter/material.dart';

import '../../model/expense.dart';

class ExpensesList extends StatelessWidget {
  const ExpensesList({Key? key, required this.expense,required this.onDeleteItem}) : super(key: key);
  final List<Expense> expense;
  final void Function(Expense expense) onDeleteItem;
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: expense.length,
      itemBuilder: (context, index) {
        return  Dismissible(
          background:Container(
            alignment: Alignment.centerLeft,
            color: Theme.of(context).appBarTheme.backgroundColor,
             ),
            onDismissed: (direction){
              onDeleteItem(expense[index]);
            },
            key: ValueKey(expense[index]),
            child: ExpensesItem(expense[index]));
      },
    );
  }
}
