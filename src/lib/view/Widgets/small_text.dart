import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SmallText extends StatelessWidget {
  final String subject;
  final double borderRadius = 8.0;
  final double sideSizing = 8.0;
  final bool reverseOrder;

  SmallText(
      {Key key, @required this.subject, this.reverseOrder = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: this.createTopRectangle(context),
    );
  }

  Widget createTopRectangle(context) {
    final Text subjectWidget = Text(this.subject,
        style: Theme.of(context).textTheme.headline2.apply(fontSizeDelta: -1));

    return subjectWidget;
  }
}