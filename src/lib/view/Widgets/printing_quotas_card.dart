import 'package:uni/model/app_state.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutter/material.dart';
import 'package:tuple/tuple.dart';
import 'package:uni/model/entities/printing_quota.dart';
import 'package:uni/view/Widgets/request_dependent_widget_builder.dart';
import 'package:uni/view/Widgets/printing_quota_slot.dart';
import '../../model/entities/prints.dart';
import '../../utils/constants.dart' as Constants;
import 'generic_card.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class PrintingQuotasCard extends GenericCard {
  PrintingQuotasCard({Key key}) : super(key: key);

  PrintingQuotasCard.fromEditingInformation(
      Key key, bool editingMode, Function onDelete)
      : super.fromEditingInformation(key, editingMode, onDelete);

  final double borderRadius = 12.0;
  final double leftPadding = 12.0;
  final List<PrintingQuota> printingQuotas =  <PrintingQuota>[];

  @override
  Widget buildCardContent(BuildContext context) {
    return StoreConnector<AppState, Tuple2<Prints, RequestStatus>>(
        converter: (store) => Tuple2(store.state.content['prints'],
            store.state.content['printsStatus']),
        builder: (context, printingQuotasInfo) {
          return RequestDependentWidgetBuilder(
              context: context,
              status: printingQuotasInfo.item2,
              contentGenerator: generateSchedule,
              content: printingQuotasInfo.item1,
              contentChecker:
              printingQuotasInfo.item1 != null,
              onNullContent: Center(
                  child: Text(AppLocalizations.of(context).printing_quotas_is_empty,
                      style: Theme.of(context).textTheme.headline4,
                      textAlign: TextAlign.center)));
        });
  }

  Widget generateSchedule(prints, context) {
    return Container(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: getPrintingQuotaRows(context, prints.printingQuotas),
        ));
  }

  List<Widget> getPrintingQuotaRows(context, List<PrintingQuota> printingQuotas) {
    final List<Widget> rows = <Widget>[];
    if(printingQuotas.isEmpty){
      rows.add(Center(
          child: Text(AppLocalizations.of(context).printing_quotas_is_empty,
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
                        .apply(fontSizeDelta: -57, fontWeightDelta: -3)),
                    Text(AppLocalizations.of(context).date, style: Theme.of(context)
                        .textTheme
                        .headline1
                        .apply(fontSizeDelta: -57, fontWeightDelta: -3)),
                    Text(AppLocalizations.of(context).credit, style: Theme.of(context)
                        .textTheme
                        .headline1
                        .apply(fontSizeDelta: -57, fontWeightDelta: -3)),
                  ])
          )
      );

      for (int i = 0; rows.length < 3 && i < printingQuotas.length; i++) {
        rows.add(this.createRowFromPrintingQuota(context, printingQuotas[i]));
      }
      if (printingQuotas.length > 1) {
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

  Widget createRowFromPrintingQuota(context, printingQuota) {
    return Container(
        margin: EdgeInsets.only(bottom: 10),
        child: PrintingQuotaSlot(
            description: printingQuota.description,
            amount: printingQuota.credit,
            date: printingQuota.date));

  }

  @override
  String getTitle(BuildContext context) => AppLocalizations.of(context).printing_quotas;

  @override
  onClick(BuildContext context) =>
      Navigator.pushNamed(context, '/' + Constants.navPrintQuotas);
}
