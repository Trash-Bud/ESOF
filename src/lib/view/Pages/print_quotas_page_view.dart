import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:tuple/tuple.dart';
import 'package:uni/model/entities/printing_quota.dart';
import 'package:uni/view/Pages/secondary_page_view.dart';
import '../../model/app_state.dart';
import 'package:uni/view/Widgets/row_container.dart';
import 'package:uni/view/Widgets/quota_row.dart';
import '../../model/entities/prints.dart';
import '../../model/entities/printing_quota.dart';
import '../Widgets/page_title_filter.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../Widgets/request_dependent_widget_builder.dart';

class PrintQuotasPageView extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => PrintQuotasPageViewState();
}

class PrintQuotasPageViewState extends SecondaryPageViewState {
  @override
  Widget getBody(BuildContext context) {
    return StoreConnector<AppState, Tuple2<dynamic,RequestStatus>>(
      converter: (store) {
        final Prints prints = store.state.content['prints'];
        final printsStatus = store.state.content['printsStatus'];
        return Tuple2(prints,printsStatus);
      },
      builder: (context, quotas) {
        return RequestDependentWidgetBuilder(context: context,
            status: quotas.item2,
            contentGenerator: generatePrintingQuotas,
            content: quotas.item1,
            contentChecker: quotas.item1 != null,
            onNullContent: Center(
                child: Text(AppLocalizations.of(context).printing_quotas_is_empty,
                    style: Theme.of(context).textTheme.headline4,
                    textAlign: TextAlign.center)
            )
        );
      },
    );
  }

  Widget generatePrintingQuotas(quotas, context){
    return PrintQuotasList(quotas: quotas.printingQuotas);
  }
}

class PrintQuotasList extends StatelessWidget {
  final List<PrintingQuota> quotas;

  PrintQuotasList({Key key, @required this.quotas})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: <Widget>[
        Container(
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: this.createQuotasColumn(context, quotas),
          ),
        )
      ],
    );
  }

  List<Widget> createQuotasColumn(context, quotas){
    List<Widget> columns = <Widget>[];
    columns.add(
          PageTitleFilter(
              name: AppLocalizations.of(context).printing_quotas_page_title
          )
      );

    for (int i = 0; i < quotas.length; i++) {
      columns.add(this.createQuotaCardSpacing(context, [quotas[i]]));
    }
    return columns;
  }

  Widget createQuotaCardSpacing(context, quotas){
    final keyValue = quotas.map((quotas) => quotas.toString()).join();
    return Container(
        key: Key(keyValue),
        margin: EdgeInsets.only(bottom: 8),
        padding: EdgeInsets.all(8),
        child: Column(
            children: [
              this.createQuotaCard(context, quotas),
            ]
        )
    );
  }

  Widget createQuotaCard(context, quotas){
    final List<Widget> quotaCards = <Widget>[];
    for (int i = 0; i < quotas.length; i++) {
      quotaCards.add(this.createQuotaContext(context, quotas[i],i));
    }
    return Column(children: quotaCards);
  }

  Widget createQuotaContext(context, quota,i) {
    final keyValue = '${quota.toString()}-quota'+i.toString();
    return Container(
            key: Key(keyValue),
            margin: EdgeInsets.fromLTRB(12, 4, 12, 0),
            child: RowContainer(
                color: Theme.of(context).backgroundColor,
                child: QuotaRow(
                    date: quota.date,
                    description: quota.description,
                    hour: quota.hour,
                    account: quota.account,
                    credit: quota.credit,
                    iva: quota.iva)
            )
        );
  }

}
