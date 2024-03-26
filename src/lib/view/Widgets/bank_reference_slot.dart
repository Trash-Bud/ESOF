import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:uni/view/Widgets/print_rectangle.dart';
import 'package:uni/view/Widgets/row_container.dart';

class BankReferenceSlot extends StatelessWidget {
  final String reference;
  final String entity;
  final String date;
  final String amount;

  BankReferenceSlot({
    Key key,
    @required this.reference,
    @required this.entity,
    @required this.date,
    @required this.amount,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RowContainer(
        child: Container(
          padding:
          EdgeInsets.only(top: 10.0, bottom: 10.0, left: 10.0, right:10.0),
          child:
          Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: createExpenseInfo(context)
          ),
        ));
  }

  List<Widget> createExpenseInfo(context) {
    return [
      Container(
          width: MediaQuery.of(context).size.width/4 - 10,
          child: PrintRectangle(
              subject: this.reference, fontSize: -4)),
      Container(
          width: MediaQuery.of(context).size.width/4 - 40,
          child: PrintRectangle(
              subject: this.entity, fontSize: -4)),
      Container(
          width: MediaQuery.of(context).size.width/4 - 35,
          alignment: Alignment.center,
          child: PrintRectangle(
            subject: this.date, fontSize: -5)),
      Container(
          width: MediaQuery.of(context).size.width/4 - 50,
          alignment: Alignment.center,
          child: PrintRectangle(
              subject: this.amount, fontSize: -4)),

    ];
  }

}
