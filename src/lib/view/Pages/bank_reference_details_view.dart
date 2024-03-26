

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:uni/model/entities/bank_reference.dart';
import 'package:uni/view/Pages/secondary_page_view.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../Widgets/page_title_filter.dart';

class BankReferenceDetailsPageView extends StatefulWidget {
  final BankReference bankReference;

  BankReferenceDetailsPageView(this.bankReference);

  @override
  State<StatefulWidget> createState() => BankReferenceDetailsPageViewState(bankReference);
}

class BankReferenceDetailsPageViewState extends SecondaryPageViewState{
  final BankReference bankReference;

  BankReferenceDetailsPageViewState(this.bankReference);

  Widget getBody(BuildContext context) {
    return BankReferenceDetails(bankReference);
  }
}

class BankReferenceDetails extends StatelessWidget{

  final BankReference bankReference;

  BankReferenceDetails(this.bankReference);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.fromLTRB(0, 0, 0, 30),
        child: Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: this.createBankReferenceDetailsColumn(context, bankReference),
    ));
  }

  List<Widget> createBankReferenceDetailsColumn(context, BankReference bankReference){
    List<Widget> columns = [];
    columns.add(PageTitleFilter(
        name: AppLocalizations.of(context).bank_references
    ));

    columns.add(Container(
      margin: EdgeInsets.all(20),
        child:Image(
          height: 250,
        image: AssetImage('assets/images/multibanco_icon.png', )
    )));
    columns.add(info(context, AppLocalizations.of(context).entity,bankReference.entity));
    columns.add(info(context, AppLocalizations.of(context).reference,bankReference.reference));
    columns.add(info(context, AppLocalizations.of(context).amount,bankReference.totalAmount));
    columns.add(info(context, AppLocalizations.of(context).valid_until,bankReference.date));

    columns.add(Text(AppLocalizations.of(context).details, style:
    Theme.of(context).textTheme.headline6.apply(fontSizeDelta: 7),));

    columns.add(Container(
      margin: EdgeInsets.fromLTRB(0, 15, 0, 0),
      width: 370,
        child:Table(

      defaultVerticalAlignment: TableCellVerticalAlignment.middle,
      children: this.getDetails(context, bankReference),
    )));

    return columns;
  }

  Widget info(context, String name, String info){
    return Column(
      children:[
      Text(name, style:
      Theme.of(context).textTheme.headline6.apply(fontSizeDelta: 7),),
      Container(
        margin: EdgeInsets.all(10),
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(10)),
          border: Border.all(color: Theme.of(context).colorScheme.primary, width: 2),
        ),
        child: Text(info, style: TextStyle(fontSize: 20)),
      ),],
    );
  }

  List<TableRow> getDetails(context, BankReference bankReference) {
    List<TableRow> tableRows = [];
    const rowSpacer = TableRow(
        children: [
          SizedBox(
            height: 8,
          ),
          SizedBox(
            height: 8,
          )
        ]);

    tableRows.add(TableRow(
        children: [
          TableCell(
              child: Center(
                  child:Text(AppLocalizations.of(context).description, style: Theme.of(context)
                      .textTheme
                      .headline5
                      .apply(fontSizeDelta: 4)))
          ),
          TableCell(
              child: Center( child:Text(AppLocalizations.of(context).amount, style: Theme.of(context)
                  .textTheme
                  .headline5
                  .apply(fontSizeDelta: 4)))),
        ],),
    );

    tableRows.add(rowSpacer);

    for(int i = 0; i < bankReference.description.length; i++){
      tableRows.add(TableRow(
          children: [
            TableCell(child: Center( child: Text(bankReference.description[i], style: Theme.of(context)
                .textTheme
                .headline6
                .apply(fontSizeDelta: 4),textAlign: TextAlign.center))),
            TableCell(child: Center( child:Text(bankReference.amounts[i], style: Theme.of(context)
                .textTheme
                .headline6
                .apply(fontSizeDelta: 4),textAlign: TextAlign.center))),
          ]));
      tableRows.add(rowSpacer);
    }

    return tableRows;
  }

}