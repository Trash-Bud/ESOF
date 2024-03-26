import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:uni/model/app_state.dart';
import 'package:uni/model/entities/current_account.dart';
import 'package:uni/view/Widgets/exam_filter_form.dart';
import 'package:uni/view/Widgets/expense_filter_form.dart';

class ExpensesFilterMenu extends StatefulWidget {
  final CurrentAccount currentAccount;

  const ExpensesFilterMenu({Key key, @required this.currentAccount}) :
        super(key: key);
  @override
  _ExpensesFilterMenuState createState() =>
      _ExpensesFilterMenuState(currentAccount);
}

class _ExpensesFilterMenuState extends State<ExpensesFilterMenu> {
  final CurrentAccount currentAccount;

  _ExpensesFilterMenuState(this.currentAccount);

  showAlertDialog(BuildContext context) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          log(currentAccount.expenseFilter.toString());
          return getAlertDialog(context);
        });
  }


  Widget getAlertDialog(BuildContext context) {
    return ExpenseFilterForm(currentAccount);
  }

  @override
  Widget build(BuildContext context) {
    return IconButton(
      key: const Key("Filtro despesas"),
      icon: Icon(Icons.settings),
      onPressed: () {
        showAlertDialog(context);
      },
    );
  }
}
