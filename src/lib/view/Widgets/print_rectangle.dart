import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class PrintRectangle extends StatelessWidget {
  final String subject;
  final double fontSize;
  final double borderRadius = 8.0;
  final double sideSizing = 5.0;
  final bool reverseOrder;

  PrintRectangle(
      {Key key, @required this.subject, this.fontSize = -1,  this.reverseOrder = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      child: Row(
        children: [this.createTopRectangle(context)],
      ),
    );
  }

  Widget createTopRectangle(context) {
    final Flexible subjectWidget =
    Flexible (
        child: Text(this.subject,
            style: Theme.of(context).textTheme.
            headline2.apply(fontSizeDelta: this.fontSize)
        )
    );

    return subjectWidget;
  }
}