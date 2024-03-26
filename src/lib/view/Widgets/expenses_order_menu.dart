import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:uni/model/app_state.dart';
import 'package:uni/view/Widgets/expenses_order_form.dart';

// ignore: must_be_immutable
class ExpensesOrderMenu extends StatefulWidget {
  @override
  _ExpensesOrderMenuState createState() => _ExpensesOrderMenuState();
}

class _ExpensesOrderMenuState extends State<ExpensesOrderMenu> {
  showAlertDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StoreConnector<AppState, List<dynamic>>(
            converter: (store) =>
              [store.state.content['orderedExpenses'], store.state.content['orderedExpensesCriteria']]
            ,
            builder: (context, orderedExpenses) {
              return getAlertDialog(orderedExpenses[0], orderedExpenses[1], context);
            });
      },
    );
  }

  Widget getAlertDialog(String orderedExpenses, String orderedExpensesCriteria, BuildContext context) {
    return ExpenseOrderForm(orderedExpenses, orderedExpensesCriteria);
  }

  @override
  Widget build(BuildContext context) {
    return IconButton(
      key :const Key("Ordenação despesas"),
      icon: Icon(Icons.unfold_more),
      onPressed: () {
        showAlertDialog(context);
      },
    );
  }
}
