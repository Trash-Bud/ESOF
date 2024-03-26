import 'package:uni/model/app_state.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutter/material.dart';
import 'package:tuple/tuple.dart';
import 'package:uni/model/entities/current_account.dart';
import 'package:uni/view/Widgets/request_dependent_widget_builder.dart';
import 'package:uni/view/Widgets/expense_slot.dart';

import '../../model/entities/expense.dart';
import '../../utils/constants.dart' as Constants;
import 'generic_card.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ExpensesCard extends GenericCard {
  ExpensesCard({Key key}) : super(key: key);

  ExpensesCard.fromEditingInformation(
      Key key, bool editingMode, Function onDelete)
      : super.fromEditingInformation(key, editingMode, onDelete);

  final double borderRadius = 12.0;
  final double leftPadding = 12.0;
  final List<Expense> expenses =  <Expense>[];

  @override
  Widget buildCardContent(BuildContext context) {
    return StoreConnector<AppState, Tuple2<CurrentAccount, RequestStatus>>(
        converter: (store) => Tuple2(store.state.content['currentAccount'],
            store.state.content['currentAccountStatus']),
        builder: (context, expensesInfo) {
          return RequestDependentWidgetBuilder(
              context: context,
              status: expensesInfo.item2,
              contentGenerator: generateSchedule,
              content: expensesInfo.item1,
              contentChecker:
              expensesInfo.item1 != null,
              onNullContent: Center(
                  child: Text(AppLocalizations.of(context).expenses_is_empty,
                      style: Theme.of(context).textTheme.headline4,
                      textAlign: TextAlign.center)));
        });
  }

  Widget generateSchedule(currAccount, context) {
    return Container(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: getExpenseRows(context, currAccount.expenses),
        ));
  }

  List<Widget> getExpenseRows(context, List<Expense> expenses) {
    final List<Widget> rows = <Widget>[];
    if(expenses.isEmpty){
      rows.add(Center(
          child: Text(AppLocalizations.of(context).expenses_is_empty,
              style: Theme.of(context).textTheme.headline4,
              textAlign: TextAlign.center)));
    }else{
      rows.add(
          Container(
              padding:
              EdgeInsets.only(left: 10.0, right:10.0),
              child: Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(AppLocalizations.of(context).description, style: Theme.of(context)
                        .textTheme
                        .headline1
                        .apply(fontSizeDelta: -55, fontWeightDelta: -3)),
                    Text(AppLocalizations.of(context).date, style: Theme.of(context)
                        .textTheme
                        .headline1
                        .apply(fontSizeDelta: -55, fontWeightDelta: -3)),
                    Text(AppLocalizations.of(context).credit, style: Theme.of(context)
                        .textTheme
                        .headline1
                        .apply(fontSizeDelta: -55, fontWeightDelta: -3)),
                  ])
          )
      );

      for (int i = 0; rows.length < 3 && i < expenses.length; i++) {
        if (expenses[i].paid)
          rows.add(this.createRowFromExpense(context, expenses[i]));
      }
      if (expenses.length > 1) {
        rows.add(Container(
          margin: EdgeInsets.only(right: 80.0, left: 80.0, top: 15, bottom: 7),
          decoration: BoxDecoration(
              border: Border(
                  bottom: BorderSide(
                      width: 1.5, color: Theme.of(context).dividerColor))),
        ));
      }
    }

    return rows;
  }

  Widget createRowFromExpense(context, expense) {
    return Container(
        margin: EdgeInsets.only(bottom: 10),
        child: ExpenseSlot(
            description: expense.description,
            date: expense.date,
            amount: expense.amount));

  }

  @override
  String getTitle(BuildContext context) => AppLocalizations.of(context).last_movements;

  @override
  onClick(BuildContext context) =>
      Navigator.pushNamed(context, '/' + Constants.navExpenses);
}
