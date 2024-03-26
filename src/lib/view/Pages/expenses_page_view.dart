import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:provider/provider.dart';
import 'package:tuple/tuple.dart';
import 'package:uni/model/entities/current_account.dart';
import 'package:uni/redux/action_creators.dart';
import 'package:uni/redux/actions.dart';
import 'package:uni/redux/reducers.dart';
import 'package:uni/view/Pages/secondary_page_view.dart';
import 'package:uni/view/Widgets/expense_ref_button.dart';
import 'package:uni/view/Widgets/expenses_filter_menu.dart';
import 'package:uni/view/Widgets/expenses_order_menu.dart';
import 'package:uni/view/Widgets/expenses_row.dart';
import '../../model/app_state.dart';
import '../../model/entities/expense.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../Widgets/DownloadError.dart';
import '../Widgets/custom_notification.dart';
import '../Widgets/page_title_filter.dart';
import 'package:timezone/timezone.dart' as tz;
import '../Widgets/request_dependent_widget_builder.dart';
import '../Widgets/row_container.dart';

class ExpensesView extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => ExpensesViewState();
}

class ExpensesViewState extends SecondaryPageViewState {
  Expense _expensesSelected = null;
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  CurrentAccount currentAccount;

  @override
  Widget getBody(BuildContext context) {
    return StoreConnector<AppState, Tuple2<dynamic,RequestStatus>>(
      converter: (store) {

        currentAccount = store.state.content['currentAccount'];
        final currentAccountStatus = store.state.content['currentAccountStatus'];

        return Tuple2(currentAccount,currentAccountStatus);
      },
      builder: (context, expenses) {
        return RequestDependentWidgetBuilder(context: context,
            status: expenses.item2,
            contentGenerator: getOrderedExpenses,
            content: expenses.item1,
            contentChecker: expenses.item1 != null,
            onNullContent: Center(
                child: Text(AppLocalizations.of(context).expenses_is_empty,
                    style: Theme.of(context).textTheme.headline4,
                    textAlign: TextAlign.center)
            )
        );
      },
    );
  }

  Widget getOrderedExpenses(currentAccount, context){
    return StoreConnector<AppState, List<dynamic>>(
      converter: (store) {
        final List<Expense> expenses = currentAccount.expenses;
        final filterExpense = expenses
            .where((expense) =>
        currentAccount.expenseFilter[expense.type] ||
            (currentAccount.expenseFilter["Despesas não saldadas"] &&
                !expense.paid))
            .toList();

        final orderExpenseBy = store.state.content['orderedExpenses'];

        final orderExpensesCriteria =
        store.state.content['orderedExpensesCriteria'];
        List<Expense> orderedExpenses = List<Expense>.from(filterExpense);

        switch (orderExpenseBy) {
          case 'Data limite de pagamento':
            orderedExpenses.sort((a, b) =>
                (DateTime.tryParse(a.limitDate) == null
                    ? DateTime.parse('0000-01-01')
                    : DateTime.tryParse(a.limitDate))
                    .compareTo(DateTime.tryParse(b.limitDate) == null
                    ? DateTime.parse('0000-01-01')
                    : DateTime.tryParse(b.limitDate)));

            break;
          case 'Juros de mora':
            orderedExpenses.sort((a, b) =>
                (double.parse(a.interest) - double.parse(b.interest)).round());

            break;

          case 'Valor a pagar':
            orderedExpenses.sort((a, b) =>
                (double.parse(a.amount) - double.parse(b.amount)).round());

            break;
        }

        if (orderExpensesCriteria == 'Descendente') {
          orderedExpenses = List.from(orderedExpenses.reversed);
        }


        return orderedExpenses;
      },
      builder: (context, expenses) {
        return  generateExpensesPage(expenses, context);
      },
    );
  }

  Widget generateExpensesPage(expenses, context){

    List<Widget> widgets = <Widget>[];

    widgets.add(PageTitleFilter(
        name: AppLocalizations.of(context).expense,
        filter: ExpensesFilterMenu(currentAccount: currentAccount),
        order: ExpensesOrderMenu()));

    if (expenses.isEmpty){
      widgets.add(Text(AppLocalizations.of(context).expenses_is_empty));
    }else{
      widgets.add(this.createExpensesColumn(context, expenses));
    }

    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: widgets,
        ),
      ),
      bottomNavigationBar: _expensesSelected != null
          ? GenerateReference(_expensesSelected, context)
          : null,
    );
  }

  Widget createExpensesColumn(context, expenses) {
    return this.createExpenseCard(context, expenses);
  }

  Widget createExpenseCard(context, expenses) {
    final keyValue = expenses.map((exam) => exam.toString()).join();
    return Container(
      key: Key(keyValue),
      margin: EdgeInsets.only(bottom: 8),
      padding: EdgeInsets.all(8),
      child: this.createExpensesCards(context, expenses),
    );
  }

  Widget createExpensesCards(context, expenses) {
    final List<Widget> expenseCards = <Widget>[];
    expenseCards.add(ElevatedButton(
        onPressed: () {
          Navigator
              .push(
              context,
              MaterialPageRoute(
                  builder: (context) => PDFDownload()
              ));
        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [Text(AppLocalizations.of(context).declaration_of_payments), Icon(Icons.download)])));

    for (int i = 0; i < expenses.length; i++) {
      expenseCards.add(this.createExpenseContext(context, expenses[i], i));
    }
    return Column(children: expenseCards);
  }

  void refresh( Expense expense) {
      setState(() {
        _expensesSelected = expense;
      });
  }

  Widget createExpenseContext(context, expense, i) {
    final keyValue = '${expense.toString()}-expense' + i.toString();
    log("expense: " + expense.toString());
    log("expense_selected: " + _expensesSelected.toString());
    log((_expensesSelected == expense).toString());
    return Container(
        key: Key(keyValue),
        margin: EdgeInsets.fromLTRB(12, 20, 12, 0),
        child: RowContainer(
            color: Theme.of(context).backgroundColor,
            child: ExpensesRow(
                expense: expense,
                notifyParent: refresh,
                isSelected: _expensesSelected == expense)
        )
    );
  }
}

class PDFDownload extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, dynamic>(
        converter: (store)  async {
          try {
            var filePath = await savePaymentDeclaration(store);
            final List<CustomNotification> notifications = store.state
                .content['notifications'];

            CustomNotification notif = CustomNotification(
                1,
                AppLocalizations.of(context).successful_transfer(
                    AppLocalizations
                        .of(context)
                        .receipt),
                AppLocalizations
                    .of(context)
                    .press_notif,
                filePath,
                true);
            Future.delayed(Duration.zero,
                    () {
                  notifications.add(notif);

                  StoreProvider.of<AppState>(context).dispatch(
                      setLocalNotifications(notifications, Completer()));
                  Provider.of<NotificationService>(context, listen: false)
                      .showNotification(
                      notif
                  );
                  Navigator.of(context).pop();
                });
          }
          catch (e) {
            log(e.toString());
            Navigator.of(context).pop();
            Navigator
                .push(
                context,
                MaterialPageRoute(
                    builder: (context) => DownloadError(e.toString())
                ));
          }
          return store;
        },
        builder: (context, store) {
          return Scaffold(
              body: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(AppLocalizations.of(context).downloading_file,
                      style: Theme
                          .of(context)
                          .textTheme
                          .headline3,
                    ),
                    LinearProgressIndicator(
                      semanticsLabel: 'Downloading file...',
                    ),
                  ],
                ),
              )
          );
        });


  }


}