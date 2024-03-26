import 'package:flutter/material.dart';
import 'package:uni/view/Widgets/print_rectangle.dart';

class PrintRow extends StatelessWidget {
  final String date;
  final String hour;
  final String fileName;
  final String cost;

  PrintRow({Key key,
    @required this.date,
    @required this.hour,
    @required this.fileName,
    @required this.cost})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Container(
          padding: EdgeInsets.only(left: 15.0, right: 5.0),
          margin: EdgeInsets.only(top: 8.0),
          child: IntrinsicHeight(
              child: Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Container(
                      width: MediaQuery.of(context).size.width/3 - 50,
                      alignment: Alignment.center,
                      margin: EdgeInsets.only(top: 20.0, bottom: 20.0),
                      child: Column(children: [
                          PrintRectangle(
                          subject: this.date),
                        PrintRectangle(
                            subject: this.hour),
                      ])),
                  Container(
                      width: MediaQuery.of(context).size.width/3 - 57,
                      alignment: Alignment.center,
                      margin: EdgeInsets.only(top: 20.0, bottom: 20.0),
                      child: PrintRectangle(
                          subject: this.fileName)),
                  Container(
                      width: MediaQuery.of(context).size.width/3 - 75,
                      alignment: Alignment.center,
                      margin: EdgeInsets.only(top: 20.0, bottom: 20.0),
                      child: PrintRectangle(
                          subject: this.cost)),

                ],
              )),
        ));
  }


}