import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:tuple/tuple.dart';
import 'package:uni/model/entities/bank_reference.dart';
import 'package:uni/model/entities/current_account.dart';
import 'package:uni/view/Pages/secondary_page_view.dart';
import '../../model/app_state.dart';
import 'package:uni/view/Widgets/row_container.dart';
import 'package:uni/view/Widgets/bank_ref_row.dart';
import '../Widgets/page_title_filter.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../Widgets/request_dependent_widget_builder.dart';
import 'bank_reference_details_view.dart';

class BankReferencesPageView extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => BankReferencesPageViewState();
}

class BankReferencesPageViewState extends SecondaryPageViewState {
  @override
  Widget getBody(BuildContext context) {
    return StoreConnector<AppState, Tuple2<dynamic,RequestStatus>>(
      converter: (store) {
        final CurrentAccount currentAccount = store.state.content['currentAccount'];
        final currentAccountStatus = store.state.content['currentAccountStatus'];
        return Tuple2(currentAccount, currentAccountStatus);
      },
      builder: (context, bankreferences) {
        return RequestDependentWidgetBuilder(context: context,
            status: bankreferences.item2,
            contentGenerator: generateBankReferences,
            content: bankreferences.item1,
            contentChecker: bankreferences.item1 != null,
            onNullContent: Center(
                child: Text(AppLocalizations.of(context).bank_references_is_empty,
                    style: Theme.of(context).textTheme.headline4,
                    textAlign: TextAlign.center)
            )
        );
      },
    );
  }
  Widget generateBankReferences(bankReferences, context){
    return BankReferencesList(bankreferences: bankReferences.bankReferences);
  }
}

class BankReferencesList extends StatelessWidget {
  final List<BankReference> bankreferences;

  BankReferencesList({Key key, @required this.bankreferences})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: <Widget>[
        Container(
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: this.createBankReferencesColumn(context, bankreferences),
          ),
        )
      ],
    );
  }

  List<Widget> createBankReferencesColumn(context, bankReferences){
    List<Widget> columns = <Widget>[];
    columns.add(
        Row(
            children:[
              PageTitleFilter(
                  name: AppLocalizations.of(context).bank_references
              ),
              IconButton(
                  padding: EdgeInsets.only(top: 5.0, bottom: 12.0),
                  color: Colors.black87,
                  alignment: Alignment.centerRight,
                  onPressed: () { columns = columns.reversed;},
                  icon: Icon(MdiIcons.clock))
            ]

        ));
    columns.add(
      Container(
          margin: EdgeInsets.fromLTRB(25, 20, 25, 0),
          padding: EdgeInsets.only(top: 3, bottom: 3, left: 3, right: 3),
          alignment: Alignment.center,
          child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(AppLocalizations.of(context).entity,
                    style: Theme.of(context)
                        .textTheme
                        .headline6
                        .apply(fontSizeDelta: 4)),
                Text(AppLocalizations.of(context).reference,
                    style: Theme.of(context)
                        .textTheme
                        .headline6
                        .apply(fontSizeDelta: 4)),
                Text(AppLocalizations.of(context).amount,
                    style: Theme.of(context)
                        .textTheme
                        .headline6
                        .apply(fontSizeDelta: 4))
              ])
      ),
    );
    for (int i = 0; i < bankReferences.length; i++) {
      columns.add(this.createRefCardSpacing(context, [bankReferences[i]],i));
    }
    return columns;
  }

  Widget createRefCardSpacing(context, bankReferences,i){
    final keyValue = bankReferences.map((bankReferences) => bankReferences.toString()).join() + i.toString();
    return Container(
        key: Key(keyValue),
        margin: EdgeInsets.only(bottom: 8),
        padding: EdgeInsets.all(8),
        child: Column(
            children: [
              this.createRefCard(context, bankReferences),
            ]
        )
    );
  }

  Widget createRefCard(context, bankReferences){
    final List<Widget> referenceCards = <Widget>[];
    for (int i = 0; i < bankReferences.length; i++) {
      referenceCards.add(this.createBankRefContext(context, bankReferences[i],i));
    }
    return Column(children: referenceCards);
  }

  Widget createBankRefContext(context, bankReference,i) {
    final keyValue = '${bankReference.toString()}-bankreference'+ i.toString();
    return InkWell(
      key: Key("bankRef " + i.toString()),
        onTap: () {
      showDialog(context: context,
          builder: (context) => BankReferenceDetailsPageView(bankReference));
          },
        child: Container(
        key: Key(keyValue),
        margin: EdgeInsets.fromLTRB(12, 4, 12, 0),
        child: RowContainer(
            color: Theme.of(context).backgroundColor,
            child: BankReferenceRow(
                reference: bankReference.reference,
                totalAmount: bankReference.totalAmount,
                entity: bankReference.entity,
                date: bankReference.date))),
    );
  }



}