import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:uni/view/Widgets/print_rectangle.dart';
import 'package:uni/view/Widgets/row_container.dart';

class PrintInfoSlot extends StatelessWidget {
  final String document;
  final String date;
  final String amount;

  PrintInfoSlot({
    Key key,
    @required this.document,
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
          width: MediaQuery.of(context).size.width/3 - 10,
          child: PrintRectangle(
              subject: this.document, fontSize: -4)),
      Container(
          width: MediaQuery.of(context).size.width/3 - 40,
          alignment: Alignment.center,
          child: PrintRectangle(
              subject: this.date, fontSize: -3)),
      Container(
          width: MediaQuery.of(context).size.width/3 - 80,
          alignment: Alignment.center,
          child: PrintRectangle(
            subject: this.amount, fontSize: -2,)),
    ];
  }

}
