import 'package:flutter/material.dart';
import 'package:uni/model/entities/bank_reference.dart';
import 'package:uni/view/Widgets/bank_ref_rectangle.dart';
import 'package:uni/view/Widgets/small_text.dart';

class BankReferenceRow extends StatelessWidget {
  final String reference;
  final String totalAmount;
  final String entity;
  final String date;

  BankReferenceRow({Key key,
    @required this.reference,
    @required this.totalAmount,
    @required this.entity,
    this.date})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Container(
          padding: EdgeInsets.only(left: 12.0, right: 12),
          margin: EdgeInsets.only(top: 8.0),
          child: IntrinsicHeight(
              child: Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Container(
                      margin: EdgeInsets.only(top: 4.0, bottom: 12.0),
                      child: Stack(children: [
                        Container(
                          //padding: EdgeInsets.only(top: 5.0, bottom: 5.0),
                          alignment: Alignment.bottomLeft,
                          child:
                          SmallText(subject: this.date)
                        ),
                        Container(
                            margin: EdgeInsets.only(top: 20.0, bottom: 38.0),
                            child: Column(
                                mainAxisSize: MainAxisSize.max,
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  ReferenceRectangle(
                                      subject: this.entity)
                                ])),
                      ])),
                  Container(
                      margin: EdgeInsets.only(top: 20.0, bottom: 45.0, right: 20.0),
                      child: ReferenceRectangle(
                          subject: this.reference)),
                  Container(
                      margin: EdgeInsets.only(top: 20.0, bottom: 45.0),
                      child: ReferenceRectangle(
                          subject: this.totalAmount)),

                ],
              )),
        ));
  }


}