import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:intl/intl.dart';
import 'package:uni/utils/constants.dart' as Constants;

import '../../model/app_state.dart';
import '../../redux/action_creators.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
// Define a custom Form widget.
class CardChargingForm extends StatefulWidget {

  @override
  CardChargingFormState createState() {
    return CardChargingFormState();
  }
}

class CurrencyInputFormatter extends TextInputFormatter {
  CurrencyInputFormatter({this.maxDigits});
  final int maxDigits;

  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {

    if (newValue.selection.baseOffset == 0) {
      return newValue;
    }

    if (maxDigits != null && newValue.selection.baseOffset > maxDigits) {
      return oldValue;
    }

    double value = double.parse(newValue.text);
    final formatter = new NumberFormat("#,##0.00", "pt_BR");
    String newText = "€ " + formatter.format(value / 100);
    return newValue.copyWith(
        text: newText,
        selection: new TextSelection.collapsed(offset: newText.length));
  }
}

// Define a corresponding State class.
// This class holds data related to the form.
class CardChargingFormState extends State<CardChargingForm> {
  // Create a global key that uniquely identifies the Form widget
  // and allows validation of the form.
  //
  // Note: This is a `GlobalKey<FormState>`,
  // not a GlobalKey<MyCustomFormState>.
  final _formKey = GlobalKey<FormState>();
  String amount;

  @override
  Widget build(BuildContext context) {
    // Build a Form widget using the _formKey created above.
    return Container(
      margin: EdgeInsets.fromLTRB(5, 10, 5, 0),
        height: 150,
        width: 260,
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,

            children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(AppLocalizations.of(context).amount + ": "),
                        Container(
                          width: 150,
                            child: TextFormField(
                                keyboardType: TextInputType.number,
                                inputFormatters: <TextInputFormatter>[
                                  FilteringTextInputFormatter.digitsOnly,
                                  CurrencyInputFormatter()
                                ],
                                initialValue: '€ 0,00',
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(),
                                  ),
                                onSaved: (String value){
                                  var a = value.substring(2,value.length);
                                  var b = a.replaceAll(".", "");
                                  amount = b;
                                },
                            validator: (value) {
                              if (value == null || value.isEmpty || value == "€ 0,00") {
                                return AppLocalizations.of(context).valid_amount;
                              }
                              var a = value.substring(2,value.length);
                              var b =  a.replaceAll(".", "");
                              var c = a.replaceAll(",", ".");
                              double value1 = double.parse(c);
                              if(value1 < 1.0){
                                return AppLocalizations.of(context).value_over_1;
                              }
                              return null;
                            },
                          ),
                        )
                      ]
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [ElevatedButton(
                    onPressed:() {
                      if (_formKey.currentState.validate()) {
                        _formKey.currentState.save();
                        log(amount);
                        Navigator
                            .push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => BankReferenceGeneration(amount).generate(context)
                            )
                        );

                      }
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(AppLocalizations.of(context).generate_bank_reference + " ", style: TextStyle(fontSize: 15),
                        ),
                        Icon(
                            Icons.add
                        )
                      ]
                    ),
                  ),
                      ElevatedButton(
                        onPressed:() {Navigator.of(context).pop();}, child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(AppLocalizations.of(context).back,
                              style: TextStyle(fontSize: 15),
                            ),
                            Icon(
                                Icons.keyboard_return
                            )
                          ]
                      ),)
                ],
              ),
            ],
          ),
        )
    );
  }
}

class BankReferenceGeneration {
  final String amount;

  BankReferenceGeneration(this.amount);

  Widget generate(BuildContext context) {
    return StoreConnector<AppState, int>(
      converter: (store) {
        generateReference(store,amount);
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
