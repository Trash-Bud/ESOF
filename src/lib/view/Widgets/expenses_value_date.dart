import 'package:flutter/material.dart';

class ExpensesValueDate extends StatelessWidget {
  final String value;
  final String date;
  String interest;
  ExpensesValueDate({@required this.value, @required this.date,
    @required this.interest}){
      this.interest = this.interest == '0,00 €' ? '' : " + "  + this.interest;
  }


  @override
  Widget build(BuildContext context) {
    return  Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisSize: MainAxisSize.max,
      children: <Widget>[
        Row(
          children: [Text(this.value,
              style:
              Theme.of(context).textTheme.headline4.apply(fontSizeDelta: -1)),
            Text(this.interest,
                style:
                Theme.of(context).textTheme.headline3.apply(fontSizeDelta: -2))
          ],

        ),
        Text(this.date,
            style:
            Theme.of(context).textTheme.headline4.apply(fontSizeDelta: -1)),
      ],
    );
  }
}
