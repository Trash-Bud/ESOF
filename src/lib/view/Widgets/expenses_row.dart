import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:uni/model/utils/document_types_enum.dart';
import 'package:uni/view/Pages/bank_reference_details_view.dart';
import 'package:uni/view/Pages/bank_references_page_view.dart';
import 'package:uni/view/Pages/receipts_page_view.dart';
import 'package:uni/view/Widgets/expenses_value_date.dart';
import 'package:uni/utils/constants.dart' as Constants;
import '../../model/app_state.dart';
import '../../model/entities/bank_reference.dart';
import '../../model/entities/current_account.dart';
import '../../model/entities/expense.dart';

class ExpenseState extends State<ExpensesRow> {
  final Expense expense;
  bool isSelected;
  IconData icon;
  final Function(Expense expense) refresh;

  ExpenseState({this.expense, this.refresh, this.isSelected}) {
    setIcon();
  }

  setIcon() {
    icon = this.expense.paid ? MdiIcons.receipt : MdiIcons.checkboxBlankOutline;
    icon = this.isSelected ? MdiIcons.checkboxMarked : this.icon;
  }

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Container(
      padding: EdgeInsets.only(left: 12.0, bottom: 8.0, right: 12),
      margin: EdgeInsets.only(top: 8.0),
      child: IntrinsicHeight(
          child: Column(
        children: <Widget>[
          Container(
              margin: EdgeInsets.only(top: 4.0),
              child: Container(
                  child: Column(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                    ExpensesValueDate(
                        value: this.expense.amount,
                        interest: this.expense.interest,
                        date: this.expense.limitDate)
                  ]))),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
            Flexible(
                child: Text(this.expense.description,
                    textAlign: TextAlign.left,
                    style: Theme.of(context)
                        .textTheme
                        .headline3
                        .apply(fontSizeDelta: 2))),
            Container(
                margin: EdgeInsets.only(top: 12.0, bottom: 12.0),
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      (this.expense.docType == DocumentT.none)
                          ? Container(
                              padding: EdgeInsets.only(
                                  top: 5.0, bottom: 12.0, left: 15.0 + 30.0),
                            )
                          : IconButton(
                              padding: EdgeInsets.only(
                                  top: 5.0, bottom: 12.0, left: 15.0),
                              alignment: Alignment.topLeft,
                              icon: this.expense.docType == DocumentT.reference
                                  ? ImageIcon(
                                      AssetImage(
                                          'assets/images/multibanco_icon.png'),
                                      size: 30,
                                    )
                                  : Icon(this.icon, size: 30),
                              onPressed: () {
                                if (this.expense.docType ==
                                    DocumentT.referenceRequest) {
                                  setState(() {
                                    if (this.isSelected) {
                                      this.refresh(null);
                                    } else {
                                      this.refresh(this.expense);
                                    }

                                    this.isSelected = !this.isSelected;
                                    setIcon();
                                  });
                                } else if (this.expense.docType ==
                                    DocumentT.reference) {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              GoToBankReferenceDetails(
                                                  expense: this.expense)));
                                } else {
                                  // open the receipt page
                                  log(this.expense.document);
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => ReceiptsView(
                                            expenseDocument:
                                                this.expense.document),
                                      ));
                                }
                              })
                    ]))
          ])
        ],
      )),
    ));
  }
}

class GoToBankReferenceDetails extends StatelessWidget {
  final Expense expense;

  const GoToBankReferenceDetails({Key key, this.expense}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, BankReference>(
      converter: (store) {
        final CurrentAccount currentAccount =
            store.state.content['currentAccount'];
        final List<BankReference> bankReferences =
            currentAccount.bankReferences;
        for (var bankRef in bankReferences) {
          if (bankRef.reference == expense.document) {
            return bankRef;
          }
        }
        return null;
      },
      builder: (context, bankReference) {
        return BankReferenceDetailsPageView(bankReference);
      },
    );
  }
}

class ExpensesRow extends StatefulWidget {
  final Expense expense;
  final bool isSelected;
  final Function(Expense expense) notifyParent;

  ExpensesRow(
      {Key key,
      @required this.expense,
      @required this.notifyParent,
      @required this.isSelected})
      : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return ExpenseState(
        expense: expense, refresh: notifyParent, isSelected: isSelected);
  }
}
