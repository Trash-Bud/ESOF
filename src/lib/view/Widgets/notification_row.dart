import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:intl/intl.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:uni/model/utils/document_types_enum.dart';
import 'package:uni/view/Pages/bank_reference_details_view.dart';
import 'package:uni/view/Pages/bank_references_page_view.dart';
import 'package:uni/view/Pages/receipts_page_view.dart';
import 'package:uni/view/Widgets/custom_notification.dart';
import 'package:uni/view/Widgets/expenses_value_date.dart';
import 'package:uni/utils/constants.dart' as Constants;
import '../../model/app_state.dart';
import '../../model/entities/bank_reference.dart';
import '../../model/entities/current_account.dart';
import '../../model/entities/expense.dart';

class NotificationState extends State<NotificationRow>{
  final CustomNotification notification;

  NotificationState({this.notification});



  @override
  Widget build(BuildContext context) {
    final DateFormat formatterDate = DateFormat('yyyy-MM-dd');
    final DateFormat formatterHour = DateFormat('hh:mm');
    final Color textColor = notification.newNotification ? Colors.white : Colors.black;
    return Container(
        padding: EdgeInsets.only(left: 12.0, bottom: 8.0, right: 12.0),
        margin: EdgeInsets.only(top: 8.0),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Row(
              children: <Widget>[
                Container(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                          formatterDate.format(notification.date),
                          style: Theme.of(context).textTheme.headline3.apply(
                                          color: textColor
                                      )
                                  )
                                ]
                    )
                ),
                Spacer(),
                Container(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                          formatterHour.format(notification.date),
                        style: Theme.of(context).textTheme.headline3.apply(
                          color: textColor
                        )
                      )
                    ]
                  )
                )
              ]
            ),
            Text(" "),
            Container(
                margin: EdgeInsets.only(bottom: 10.0),
                child: Text(
                    notification.title,
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.headline3.apply(
                      fontSizeDelta: 2,
                      fontWeightDelta: 1,
                      color: textColor,
                    )
                )
            ),
            Container(
                margin: EdgeInsets.only(bottom: 10.0),
                child: Text(
                  notification.body,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.headline3.apply(
                      fontSizeDelta: 2,
                      color: textColor,
                    fontSizeFactor: 0.8
                  )
                )
            ),
          ]
        )
    );
  }
  
}

class NotificationRow extends StatefulWidget {
  final CustomNotification notification;

  NotificationRow(
    {
      Key key,
      @required this.notification
    }
  ) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return NotificationState(
      notification: notification
    );
  }
  
}