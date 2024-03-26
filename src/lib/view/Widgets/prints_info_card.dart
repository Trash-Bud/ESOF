import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:tuple/tuple.dart';
import 'package:uni/view/Widgets/print_info_slot.dart';
import 'package:uni/view/Widgets/request_dependent_widget_builder.dart';

import '../../model/app_state.dart';
import '../../model/entities/print.dart';
import '../../model/entities/prints.dart';
import '../../utils/constants.dart' as Constants;
import 'generic_card.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class PrintsCard extends GenericCard {
  PrintsCard({Key key}) : super(key: key);

  PrintsCard.fromEditingInformation(
      Key key, bool editingMode, Function onDelete)
      : super.fromEditingInformation(key, editingMode, onDelete);

  final double borderRadius = 12.0;
  final double leftPadding = 12.0;
  final List<Print> prints =  <Print>[];

  @override
  Widget buildCardContent(BuildContext context) {
    return StoreConnector<AppState, Tuple2<Prints, RequestStatus>>(
        converter: (store) => Tuple2(store.state.content['prints'],
            store.state.content['printsStatus']),
        builder: (context, expensesInfo) {

          return RequestDependentWidgetBuilder(
              context: context,
              status: expensesInfo.item2,
              contentGenerator: generatePrints,
              content: expensesInfo.item1,
              contentChecker:
              expensesInfo.item1 != null,
              onNullContent: Center(
                  child: Text(AppLocalizations.of(context).prints_is_empty,
                      style: Theme.of(context).textTheme.headline4,
                      textAlign: TextAlign.center)));
        });
  }

  Widget generatePrints(prints, context) {
    return Container(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: getPrintsRows(context, prints.prints),
        ));
  }

  List<Widget> getPrintsRows(context, List<Print> prints) {
    final List<Widget> rows = <Widget>[];
    if(prints.isEmpty){
      rows.add( Center(
          child: Text(AppLocalizations.of(context).prints_is_empty,
              style: Theme.of(context).textTheme.headline4,
              textAlign: TextAlign.center)
      )
      );

    }else {
      rows.add(
          Container(
              padding:
              EdgeInsets.only(left: 10.0, right: 10.0),
              child: Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(AppLocalizations.of(context).document, style: Theme
                        .of(context)
                        .textTheme
                        .headline1
                        .apply(fontSizeDelta: -55, fontWeightDelta: -3)),
                    Text(AppLocalizations.of(context).date, style: Theme
                        .of(context)
                        .textTheme
                        .headline1
                        .apply(fontSizeDelta: -55, fontWeightDelta: -3)),
                    Text(AppLocalizations.of(context).credit, style: Theme
                        .of(context)
                        .textTheme
                        .headline1
                        .apply(fontSizeDelta: -55, fontWeightDelta: -3)),
                  ])
          )
      );


      for (int i = 0; rows.length < 3 && i < prints.length; i++) {
        rows.add(this.createRowFromPrint(context, prints[i]));
      }
      if (prints.length > 1) {
        rows.add(Container(
          margin: EdgeInsets.only(right: 80.0, left: 80.0, top: 15, bottom: 7),
          decoration: BoxDecoration(
              border: Border(
                  bottom: BorderSide(
                      width: 1.5, color: Theme
                      .of(context)
                      .dividerColor))),
        ));
      }
    }
    return rows;
  }

  Widget createRowFromPrint(context, Print print) {
    return Container(
        margin: EdgeInsets.only(bottom: 10),
        child: PrintInfoSlot(
            document: print.fileName,
            date: print.date,
            amount: print.cost));

  }

  @override
  String getTitle(BuildContext context) => AppLocalizations.of(context).last_prints;

  @override
  onClick(BuildContext context) =>
      Navigator.pushNamed(context, '/' + Constants.navPrintsList);
}
