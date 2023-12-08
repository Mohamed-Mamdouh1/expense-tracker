import 'package:expense_tracker/model/expense.dart';
import 'package:flutter/material.dart';
class ExpensesItem extends StatelessWidget {
  const ExpensesItem(this.expense,{Key? key}) : super(key: key);
final Expense expense;


  @override
  Widget build(BuildContext context) {
    return Card(

      child:Padding(
        padding: const EdgeInsets.symmetric(vertical:16,horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
          Text(expense.title,style:  Theme.of(context).textTheme.titleLarge),
          Row(children: [
            Text('${expense.price.toStringAsFixed(2)}LE'),
            const Spacer(),
            Row(
              children: [
                Icon(categoryIcon[expense.category]),
                SizedBox(width: 8,),
                Text(expense.formattedDate),
              ],
            )
          ],)
        ],),
      ),);
  }
}
