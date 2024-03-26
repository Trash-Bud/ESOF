
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:uni/model/app_state.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../controller/language/DynamicTranslations.dart';
import '../../model/entities/current_account.dart';
import '../../redux/actions.dart';

class ExpenseFilterForm extends StatefulWidget {
  final CurrentAccount currentAccount;

  ExpenseFilterForm(this.currentAccount);
  @override
  _ExpenseFilterFormState createState() =>
      _ExpenseFilterFormState(this.currentAccount);
}

class _ExpenseFilterFormState extends State<ExpenseFilterForm> {
  final CurrentAccount currentAccount;

  _ExpenseFilterFormState(this.currentAccount);
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(AppLocalizations.of(context).expenses_filter_title),
      actions: [
        TextButton(
            child: Text(AppLocalizations.of(context).cancel), onPressed: () => Navigator.pop(context)),
        ElevatedButton(
            child: Text(AppLocalizations.of(context).confirm),
            onPressed: () {
              StoreProvider.of<AppState>(context).dispatch(
                  SetCurrentAccountAction(this.currentAccount));
              Navigator.pop(context);
            })
      ],
      content: Container(
          height: 300.0,
          width: 200.0,
          child: getExpenseCheckboxes(context)),
    );
  }

  Widget getExpenseCheckboxes(
       BuildContext context) {

    return ListView(
        children: List.generate(currentAccount.expenseFilter.length, (i) {
          final String key = currentAccount.expenseFilter.keys.elementAt(i);
          return CheckboxListTile(
              contentPadding: EdgeInsets.all(0),
              title: Text(
                DynamicTranslations.getFilterTranslation(key,AppLocalizations.of(context).localeName),
                overflow: TextOverflow.ellipsis,
                softWrap: false,
                maxLines: 2,
              ),
              key: Key('ExamCheck' + key),
              value: currentAccount.expenseFilter[key],
              onChanged: (value) {
                setState(() {
                  currentAccount.expenseFilter[key] = value;
                });
              });
        }));
  }
}
