import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:tuple/tuple.dart';
import 'package:uni/view/Pages/secondary_page_view.dart';
import '../../model/app_state.dart';
import 'package:uni/view/Widgets/row_container.dart';
import 'package:uni/view/Widgets/print_row.dart';
import '../../model/entities/prints.dart';
import '../../model/entities/print.dart';
import '../Widgets/card_charging_form.dart';
import '../Widgets/page_title_filter.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../Widgets/request_dependent_widget_builder.dart';


class PrintsListPageView extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => PrintsListPageViewState();
}

class PrintsListPageViewState extends SecondaryPageViewState {
  @override
  Widget getBody(BuildContext context) {
    return StoreConnector<AppState, Tuple2<dynamic,RequestStatus>>(
      converter: (store) {
        final Prints prints = store.state.content['prints'];
        final  printsStatus = store.state.content['printsStatus'];
        log(store.state.content['profile'].feesLimit);
        return Tuple2(prints,printsStatus);
      },
      builder: (context, prints) {
        return RequestDependentWidgetBuilder(context: context,
            status: prints.item2,
            contentGenerator: generatePrints,
            content: prints.item1,
            contentChecker: prints.item1 != null,
            onNullContent: Center(
                child: Text(AppLocalizations.of(context).prints_is_empty,
                    style: Theme.of(context).textTheme.headline4,
                    textAlign: TextAlign.center)
            )
        );
      },
    );
  }
  Widget generatePrints(prints, context){
    return PrintsList(prints: prints.prints);
  }
}

class Button extends StatelessWidget {

  final String printBalance;

  Button(this.printBalance, BuildContext context);

  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      color: Colors.transparent,
      child: ButtonTheme(
        minWidth: 20,
        height: 10,
        child: ElevatedButton(
          key: const Key("carregar cartão"),
          onPressed: () {
            showDialog(context: context,
                builder: (context) => this.chargingCardPopUp(context));
          },
          child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text( AppLocalizations.of(context).balance +": " + printBalance + " ",
                  style: TextStyle(fontSize: 20),),
                Icon(
                    Icons.add
                )
              ]),
        ),
      ),
      elevation: 10,
    );
  }

  Widget chargingCardPopUp(context){
    return  AlertDialog(
      contentPadding: EdgeInsets.all(15),
        title: Text(AppLocalizations.of(context).charge_card),
        content: Row(
          children: [
            CardChargingForm()
          ]
        ),

    );
  }

}

class PrintsList extends StatelessWidget {
  final List<Print> prints;

  PrintsList({Key key, @required this.prints})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: ListView(
          children: <Widget>[
            Container(
              child: Column(
                mainAxisSize: MainAxisSize.max,
                children: this.createPrintsColumn(context, prints),
              ),
            ),
          ], ),
        bottomNavigationBar: Container(
          margin: const EdgeInsets.only(
              left: 70.0, bottom: 20.0, right: 70.0),
          child: StoreConnector<AppState, String>(
              converter: (store) => store.state.content['printBalance'],
              builder: (context, printBalance) =>
                  Button(printBalance, context)),
        ),
    );
  }

  List<Widget> createPrintsColumn(context, prints){
    List<Widget> columns = <Widget>[];
    columns.add(
        Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children:[
              PageTitleFilter(
                  name: AppLocalizations.of(context).prints
              ),
              IconButton(
                  padding: EdgeInsets.only(right:20),
                  color: Colors.black87,
                  alignment: Alignment.centerRight,
                  onPressed: () { columns = columns.reversed;},
                  icon: Icon(MdiIcons.clock))
            ]

        ));
    for (int i = 0; i < prints.length; i++) {
      columns.add(this.createPrintCardSpacing(context, [prints[i]], i));
    }
    return columns;
  }

  Widget createPrintCardSpacing(context, prints, key1){
    final keyValue = prints.map((prints) => prints.toString()).join() + key1.toString();
    return Container(
        key: Key(keyValue),
        margin: EdgeInsets.only(bottom: 8),
        padding: EdgeInsets.all(8),
        child: Column(
            children: [
              this.createPrintCard(context, prints),
            ]
        )
    );
  }

  Widget createPrintCard(context, prints){
    final List<Widget> printCards = <Widget>[];
    for (int i = 0; i < prints.length; i++) {
      printCards.add(this.createPrintContext(context, prints[i], i));
    }
    return Column(children: printCards);
  }

  Widget createPrintContext(context, print, key1) {
    final keyValue = '${print.toString()}-print' + key1.toString();
    return InkWell(
        onTap: () {
          showDialog(context: context,
              builder: (context) => this.showDetails(context, print));
          //return this.showDetails(context, print);
        },
        child: Container(
            key: Key(keyValue),
            margin: EdgeInsets.fromLTRB(12, 4, 12, 0),
            child: RowContainer(
                color: Theme.of(context).backgroundColor,
                child: PrintRow(
                    date: print.date,
                    hour: print.hour,
                    fileName: print.fileName,
                    cost: print.cost)
            )
        )
    );
  }

  Widget showDetails(context, print){
    const rowSpacer = TableRow(
        children: [
          SizedBox(
            height: 8,
          ),
          SizedBox(
            height: 8,
          )
        ]);
    return AlertDialog(
      title: Text(AppLocalizations.of(context).printing_details),
      content: Table(
          defaultVerticalAlignment: TableCellVerticalAlignment.top,
          children: [
            TableRow(
                children: [
                  TableCell( child: Text(AppLocalizations.of(context).number_pages)),
                  TableCell( child:
                  Text(print.getNumPages())
                  )]
            ),
            rowSpacer,
            TableRow(
                children: [
                  TableCell( child: Text(AppLocalizations.of(context).cost)),
                  TableCell( child: Text(print.cost))
                ]),
            rowSpacer,
            TableRow(
                children: [
                  TableCell( child: Text(AppLocalizations.of(context).date)),
                  Column(
                      children:[
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text(print.date),
                        ),
                        Align(
                        alignment: Alignment.centerLeft,
                        child: Text(print.hour)
                        )
                      ]
                  )
                ]),
            rowSpacer,
            TableRow(
                children: [
                  TableCell( child: Text(AppLocalizations.of(context).printer)),
                  TableCell( child: Text(print.printer))
                ]),
            rowSpacer,
            TableRow(
                children: [
                  TableCell( child: Text(AppLocalizations.of(context).document_name)),
                  TableCell( child: Text(print.fileName))
                ]),
            rowSpacer,
            TableRow(
                children: [
                  TableCell( child: Text(AppLocalizations.of(context).account)),
                  TableCell( child: Text(print.account))
                ]),
            rowSpacer,
            TableRow(
                children: [
                  TableCell( child: Text(AppLocalizations.of(context).type_paper)),
                  TableCell( child: Text(print.getDetails()))
                ])
          ]),
      actions: [
        ElevatedButton(
            onPressed:() {Navigator.of(context).pop();}, child: Text('OK'))],
    );
  }


}