import 'dart:async';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:uni/model/app_state.dart';
import 'package:uni/redux/action_creators.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../../controller/language/DynamicTranslations.dart';
import '../../model/entities/expense.dart';

class ExpenseOrderForm extends StatefulWidget {
  final String expensesOrder;
  final String expensesOrderCriteria;
  ExpenseOrderForm(this.expensesOrder, this.expensesOrderCriteria);
  @override
  _ExpenseOrderFormState createState() => _ExpenseOrderFormState(expensesOrder, expensesOrderCriteria);
}

class _ExpenseOrderFormState extends State<ExpenseOrderForm> {
  String _expenseOrder;
  String _expenseOrderCriteria;
  _ExpenseOrderFormState(String examsOrder, String expenseOrderCriteria){
    _expenseOrder = examsOrder;
    _expenseOrderCriteria = expenseOrderCriteria;
  }
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(AppLocalizations.of(context).sort_by),
      actions: [
        ElevatedButton(
            key: const Key("confirmar ordenação despesa"),
            child: Text(AppLocalizations.of(context).apply),
            onPressed: () {
              StoreProvider.of<AppState>(context).dispatch(
                  setOrderedExpenses(_expenseOrder, Completer()));
              StoreProvider.of<AppState>(context).dispatch(
                  setOrderedExpensesCriteria(_expenseOrderCriteria, Completer()));
              Navigator.pop(context);
            })
      ],
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            height: 175.0,
          width: 200.0,
          child:  buildRadioButtons(context, Expense.getOrderedExpenseTypes()))
          ,
          Divider(
            color: Colors.black,

          ),
          Container(
              height: 100.0,
              width: 200.0,
              child:  buildRadioButtonsCriteria(context,  ["Ascendente", "Descendente"]))
          ,
        ]
      )
    );
  }
  Widget buildRadioButtons(BuildContext context, List<String> orderedTypes){
    return ListView(
        children: List.generate(orderedTypes.length, (i) {
          final String key = orderedTypes.elementAt(i);
          return RadioListTile(
            contentPadding: EdgeInsets.all(0),
            title: Text(
              DynamicTranslations.getOrderTranslation(key,AppLocalizations.of(context).localeName),
              overflow: TextOverflow.ellipsis,
              softWrap: false,
              maxLines: 2,
            ),
            key: Key(key),
            value: orderedTypes.elementAt(i),
            onChanged: (String value) {
              setState(() {
                _expenseOrder = value;
              });

            },
            groupValue: _expenseOrder,
          );
        }));
  }

  Widget buildRadioButtonsCriteria(BuildContext context,
      List<String> orderedTypesCriterion){
    return ListView(
        children: List.generate(orderedTypesCriterion.length, (i) {
          final String key = orderedTypesCriterion.elementAt(i);
          return RadioListTile(
            contentPadding: EdgeInsets.all(0),
            title: Text(
              key,
              overflow: TextOverflow.ellipsis,
              softWrap: false,
              maxLines: 2,
            ),
            key: Key('ExpenseOrderCriteriaCheck' + key),
            value: orderedTypesCriterion.elementAt(i),
            onChanged: (String value) {
              setState(() {
                _expenseOrderCriteria = value;
              });

            },
            groupValue: _expenseOrderCriteria,
          );
        }));
  }
}
