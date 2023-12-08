import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import 'package:intl/intl.dart';
import "package:hive/hive.dart";
part 'expense.g.dart';

const uuid = Uuid();

enum Category { food, travel, leisure, work }

const categoryIcon = {
  Category.food: Icons.lunch_dining,
  Category.travel: Icons.flight_takeoff,
  Category.leisure: Icons.movie,
  Category.work: Icons.work,
};
final formatter = DateFormat.yMd();
@HiveType(typeId: 1)
class Expense {
  Expense({
    required this.title,
    required this.price,
    required this.date,
    required this.category,
  }) : id = uuid.v4();

  @HiveField(0)
  final String title;

  @HiveField(1)
  final String id;

  @HiveField(2)
  final double price;

  @HiveField(3)
  final DateTime date;

  @HiveField(4)
  final Category category;

  String get formattedDate {
    return formatter.format(date);
  }
}

class ExpenseBucket {
  ExpenseBucket({required this.category, required this.expenses});
  ExpenseBucket.forCategory(List<Expense> allExpenses, this.category)
      : expenses = allExpenses
            .where((expense) => expense.category == category)
            .toList();
  Category category;
  List<Expense> expenses;
  double get totalExpenses {
    double sum = 0;
    for (final expense in expenses) {
      sum += expense.price;
    }

    return sum;
  }
}
