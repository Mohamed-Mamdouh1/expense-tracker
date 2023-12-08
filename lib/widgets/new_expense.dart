import 'package:expense_tracker/model/expense.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class NewExpense extends StatefulWidget {
  NewExpense({Key? key, required this.onSelectedExpense}) : super(key: key);

  void Function(Expense expense) onSelectedExpense;

  @override
  State<NewExpense> createState() => _NewExpenseState();
}

class _NewExpenseState extends State<NewExpense> {
  final _titleController = TextEditingController();
  final _amountController = TextEditingController();
  DateTime? selectedDate;
  Category selectedCategory = Category.leisure;
  @override
  void dispose() {
    _titleController.dispose();
    _amountController.dispose();
    super.dispose();
  }

  void _datePicker() async {
    var now = DateTime.now();
    var firstDate = DateTime(now.year - 4, now.month - 4, now.day - 4);
    var lastDate = DateTime(
      now.year + 4,
    );
    var pickedDate = await showDatePicker(
        context: context,
        initialDate: now,
        firstDate: firstDate,
        lastDate: lastDate,
        builder: (context, child) {
          return Theme(
              data: Theme.of(context).copyWith(
                colorScheme: const ColorScheme(
                    brightness: Brightness.light,
                    primary: Colors.deepPurple,
                    onPrimary: Colors.white,
                    secondary: Colors.black,
                    onSecondary: Colors.black,
                    surface: Colors.black,
                    onSurface: Colors.black,
                    onBackground: Colors.black,
                    background: Colors.black,
                    error: Colors.red,
                    onError: Colors.red),
              ),
              child: child!);
        });
    if (pickedDate == null) {
      return;
    }
    setState(() {
      selectedDate = pickedDate;
    });
  }

  void _savedExpense() {
    var doubleAmount = double.tryParse(_amountController.text);
    final amountIsInvalid = doubleAmount == null || doubleAmount <= 0;
    if (_titleController.text.isEmpty ||
        amountIsInvalid ||
        selectedDate == null) {
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
              Text(
                "Invalid input",
                style: TextStyle(color: Colors.red),
              ),
              Icon(
                Icons.error,
                color: Colors.red,
              ),
            ],
          ),
          content: const Text(
              "Please make sure a valid title, amount, date and category was entered"),
          actions: [
            TextButton(
                onPressed: () {
                  Navigator.pop(ctx);
                },
                child: Text(
                  "Okay",
                  style: TextStyle(color: Colors.deepPurpleAccent),
                ))
          ],
        ),
      );

      return;
    }



    widget.onSelectedExpense(Expense(
      title: _titleController.text,
      price: doubleAmount,
      date: selectedDate!,
      category: selectedCategory,
    ));
    Navigator.pop(context);
    _titleController.clear();
    _amountController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constrains) {
      double width = constrains.maxWidth;
      double height = constrains.maxHeight;
      return SizedBox(
        height: double.infinity,
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(
              8.0,
              40,
              8,
              8,
            ),
            child: Column(
              children: [
                if (width > height)
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _titleController,
                          maxLength: 50,
                          keyboardType: TextInputType.text,
                          decoration: const InputDecoration(
                            counter: SizedBox.shrink(),
                            label: Text("Title"),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Expanded(
                        child: TextField(
                          controller: _amountController,
                          keyboardType: TextInputType.number,
                          inputFormatters: <TextInputFormatter>[
                            FilteringTextInputFormatter.digitsOnly
                          ],
                          decoration: const InputDecoration(
                            prefixText: " LE ",
                            label: Text("Amount"),
                          ),
                        ),
                      ),
                    ],
                  )
                else
                  TextField(
                    controller: _titleController,
                    maxLength: 50,
                    keyboardType: TextInputType.text,
                    decoration: const InputDecoration(
                      label: Text("Title"),
                    ),
                  ),
                if (width > height)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      DropdownButton(
                          value: selectedCategory,
                          items: Category.values
                              .map((category) => DropdownMenuItem(
                                  value: category,
                                  child: Text(category.name.toUpperCase())))
                              .toList(),
                          onChanged: (value) {
                            // if(value==null){
                            //   return;
                            // }
                            setState(() {
                              selectedCategory = value as Category;
                            });
                          }),
                      Row(
                        children: [
                          Text(selectedDate == null
                              ? "Selected Date"
                              : formatter.format(selectedDate!)),
                          IconButton(
                              onPressed: _datePicker,
                              icon: const Icon(Icons.calendar_month)),
                        ],
                      )
                    ],
                  )
                else
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _amountController,
                          keyboardType: TextInputType.number,
                          inputFormatters: <TextInputFormatter>[
                            FilteringTextInputFormatter.digitsOnly
                          ],
                          decoration: const InputDecoration(
                            prefixText: " LE ",
                            label: Text("Amount"),
                          ),
                        ),
                      ),
                      const SizedBox(
                        width: 12,
                      ),
                      Row(
                        children: [
                          Text(selectedDate == null
                              ? "Selected Date"
                              : formatter.format(selectedDate!)),
                          IconButton(
                              onPressed: _datePicker,
                              icon: const Icon(Icons.calendar_month)),
                        ],
                      )
                    ],
                  ),
                if (width > height)
                  Row(
                    children: [
                      Spacer(),
                      ElevatedButton(
                          onPressed: _savedExpense,
                          child: const Text(
                            "Save Expense",
                            style: TextStyle(color: Colors.deepPurpleAccent),
                          )),
                      TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: const Text(
                            "Cancel",
                            style: TextStyle(color: Colors.redAccent),
                          ))
                    ],
                  )
                else
                  Row(
                    children: [
                      DropdownButton(
                          value: selectedCategory,
                          items: Category.values
                              .map((category) => DropdownMenuItem(
                                  value: category,
                                  child: Text(category.name.toUpperCase())))
                              .toList(),
                          onChanged: (value) {
                            // if(value==null){
                            //   return;
                            // }
                            setState(() {
                              selectedCategory = value as Category;
                            });
                          }),
                      Spacer(),
                      ElevatedButton(
                          onPressed: _savedExpense,
                          child: const Text(
                            "Save Expense",
                            style: TextStyle(color: Colors.deepPurpleAccent),
                          )),
                      TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: const Text(
                            "Cancel",
                            style: TextStyle(color: Colors.redAccent),
                          ))
                    ],
                  ),
              ],
            ),
          ),
        ),
      );
    });
  }
}
