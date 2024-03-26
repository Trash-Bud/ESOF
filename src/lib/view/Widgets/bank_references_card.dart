import 'package:uni/model/app_state.dart';
import 'package:uni/model/entities/bank_reference.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutter/material.dart';
import 'package:tuple/tuple.dart';
import 'package:uni/model/entities/current_account.dart';
import 'package:uni/view/Widgets/request_dependent_widget_builder.dart';
import 'package:uni/view/Widgets/bank_reference_slot.dart';
import '../../utils/constants.dart' as Constants;
import 'generic_card.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class BankReferencesCard extends GenericCard {
  BankReferencesCard({Key key}) : super(key: key);

  BankReferencesCard.fromEditingInformation(
      Key key, bool editingMode, Function onDelete)
      : super.fromEditingInformation(key, editingMode, onDelete);

  final double borderRadius = 12.0;
  final double leftPadding = 12.0;
  final List<BankReference> bankReferences =  <BankReference>[];

  @override
  Widget buildCardContent(BuildContext context) {
    return StoreConnector<AppState, Tuple2<CurrentAccount, RequestStatus>>(
        converter: (store) => Tuple2(store.state.content['currentAccount'],
            store.state.content['currentAccountStatus']),
        builder: (context, bankReferencesInfo) {
          return RequestDependentWidgetBuilder(
              context: context,
              status: bankReferencesInfo.item2,
              contentGenerator: generateSchedule,
              content: bankReferencesInfo.item1,
              contentChecker:
              bankReferencesInfo.item1 != null,
              onNullContent: Center(
                  child: Text(AppLocalizations.of(context).bank_references_is_empty,
                      style: Theme.of(context).textTheme.headline4,
                      textAlign: TextAlign.center)));
        });
  }

  Widget generateSchedule(currAccount, context) {
    return Container(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: getBankReferenceRows(context, currAccount.bankReferences),
        ));
  }

  List<Widget> getBankReferenceRows(context, List<BankReference> bankReferences) {
    final List<Widget> rows = <Widget>[];
    if(bankReferences.isEmpty){
      rows.add(Center(
          child: Text(AppLocalizations.of(context).bank_references_is_empty,
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
                    Text( AppLocalizations.of(context).reference, style: Theme.of(context)
                        .textTheme
                        .headline1
                        .apply(fontSizeDelta: -57, fontWeightDelta: -3)),
                    Text( AppLocalizations.of(context).entity, style: Theme.of(context)
                        .textTheme
                        .headline1
                        .apply(fontSizeDelta: -57, fontWeightDelta: -3)),
                    Text( AppLocalizations.of(context).date, style: Theme.of(context)
                        .textTheme
                        .headline1
                        .apply(fontSizeDelta: -57, fontWeightDelta: -3)),
                    Text( AppLocalizations.of(context).amount, style: Theme.of(context)
                        .textTheme
                        .headline1
                        .apply(fontSizeDelta: -57, fontWeightDelta: -3)),
                  ])
          )
      );

      for (int i = 0; rows.length < 3 && i < bankReferences.length; i++) {
        rows.add(this.createRowFromBankReference(context, bankReferences[i]));
      }
      if (bankReferences.length > 1) {
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

  Widget createRowFromBankReference(context, bankReference) {
    return Container(
        margin: EdgeInsets.only(bottom: 10),
        child: BankReferenceSlot(
            reference: bankReference.reference,
            entity: bankReference.entity,
            date: bankReference.date,
            amount: bankReference.totalAmount));

  }

  @override
  String getTitle(BuildContext context) =>  AppLocalizations.of(context).bank_references;

  @override
  onClick(BuildContext context) =>
      Navigator.pushNamed(context, '/' + Constants.navBankReferences);
}
