import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';

import '../../model/app_state.dart';
import '../../model/entities/expense.dart';
import '../../redux/action_creators.dart';
import 'package:uni/utils/constants.dart' as Constants;
import 'package:flutter_gen/gen_l10n/app_localizations.dart';


class GenerateReference extends StatelessWidget {

  final Expense expenseReference;

  GenerateReference(this.expenseReference, BuildContext context);

  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      color: Colors.transparent,
      child: ButtonTheme(
        minWidth: 20,
        height: 10,
        child: ElevatedButton(
          onPressed: () {
            showDialog(context: context,
                builder: (context) => this.chargingCardPopUp(context));
          },
          child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(AppLocalizations.of(context).generate_bank_reference,
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
    return
         AlertDialog(
          contentPadding: EdgeInsets.all(15),
          title: Text(AppLocalizations.of(context).references),
          content:Container(
            height: 100.0,
            child: Column(

              children: [
                Flexible(
                    child: Text(AppLocalizations.of(context).confirm_ref_gen)),
                Text(expenseReference.description),
              ]
          ),
      ),
           actions: [ ElevatedButton(
               onPressed:() {Navigator.of(context).pop();}, child: Text('NO') ),

             ElevatedButton(
                 onPressed:() {
                   Navigator
                       .push(
                       context,
                       MaterialPageRoute(
                           builder: (context) => BankReferenceGenerationExpense(expenseReference.document).generate(context)
                       )
                   );
                   }, child: Text('OK'))],

    );
  }

}

class BankReferenceGenerationExpense {
  final String document;

  BankReferenceGenerationExpense(this.document);

  Widget generate(BuildContext context) {
    return StoreConnector<AppState, int>(
      converter: (store) {
        generateReferenceForExpense(store,document);
        Future.delayed(Duration.zero,
                (){
              Navigator.of(context).pop();
              Navigator.pushNamed(
                  context, '/${Constants.navBankReferences}');
            }
        );
        return 0;
      },
      builder: (context, b) {
        return Container(
            child: CircularProgressIndicator()
        );
      },
    );
  }
}
