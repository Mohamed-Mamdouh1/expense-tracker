import 'package:expense_tracker/shared_preferences/sharedpreferences.dart';
import 'package:expense_tracker/widgets/expenses.dart';
import 'package:flutter/material.dart';
import"package:hive_flutter/hive_flutter.dart";

import 'model/boxes.dart';
import 'model/expense.dart';
var kColorScheme =
    ColorScheme.fromSeed(seedColor: const Color.fromARGB(255, 96, 59, 181));
var kDarkColorScheme = ColorScheme.fromSeed(
    brightness: Brightness.dark,
    seedColor: const Color.fromARGB(255, 5, 99, 125));

void main() async{
  await Hive.initFlutter();
  Hive.registerAdapter(ExpenseAdapter());
  boxExpense = await Hive.openBox<Expense>('expenseBox');
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool isDarkMode=false;
  Future<void> loadAppMode() async {
    // Retrieve the app mode
    bool savedMode = await AppPreferences.getAppMode();
    setState(() {

      isDarkMode = savedMode;
      print(isDarkMode);
    });
  }
  @override
  void initState() {
    loadAppMode();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      darkTheme: ThemeData(
        useMaterial3: true,
        colorScheme: kDarkColorScheme,
        cardTheme: const CardTheme().copyWith(
            color: kDarkColorScheme.secondaryContainer,
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8)),
      ),
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: kColorScheme,
        appBarTheme: const AppBarTheme().copyWith(
          backgroundColor: kColorScheme.onPrimaryContainer,
          foregroundColor: kColorScheme.primaryContainer,
        ),
        cardTheme: const CardTheme().copyWith(
            color: kColorScheme.secondaryContainer,
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8)),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            primary: kColorScheme.primaryContainer,
          ),
        ),
        textTheme: ThemeData().textTheme.copyWith(
              titleLarge: TextStyle(
                color: kColorScheme.onSecondaryContainer,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
      ),
      themeMode: isDarkMode?ThemeMode.dark:ThemeMode.light,
      home: Expenses(
        toggleTheme: toggleTheme,
        isDarkMode: isDarkMode,
      ),
    );
  }



  void toggleTheme()async {
    setState(() {
     isDarkMode=!isDarkMode;

    });
    await AppPreferences.saveAppMode(isDarkMode);
  }
}
