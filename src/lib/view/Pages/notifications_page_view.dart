import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:http/http.dart';

import 'package:open_file/open_file.dart';

import 'package:provider/provider.dart';

import 'package:tuple/tuple.dart';
import 'package:uni/model/entities/current_account.dart';
import 'package:uni/view/Pages/secondary_page_view.dart';
import 'package:uni/view/Widgets/custom_notification.dart';
import 'package:uni/view/Widgets/notification_row.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:uni/view/Widgets/request_dependent_widget_builder.dart';
import 'package:uni/utils/constants.dart' as Constants;
import '../../model/app_state.dart';

import '../../redux/action_creators.dart';

import '../../model/entities/expense.dart';

import '../Widgets/page_title_filter.dart';
import '../Widgets/row_container.dart';
import 'package:timezone/timezone.dart' as tz;

import '../navigation_service.dart';

class NotificationsView extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => NotificationsViewState();
}

/// Tracks the state of home page.
class NotificationsViewState extends SecondaryPageViewState {
  @override
  Widget getBody(BuildContext context) {
    return StoreConnector<AppState, Tuple2< Tuple2<List<CustomNotification>, CurrentAccount>, RequestStatus>>(
      converter: (store) {
        return Tuple2( Tuple2(store.state.content['notifications'],
            store.state.content['currentAccount']),
            store.state.content['notificationsStatus']);
      },
      builder: (context, notifications) {
        final List<Widget> widgets = [];
        widgets.add(
            PageTitleFilter(
                name: AppLocalizations.of(context).notification_title,
                filter: null,
                order: null)
        );
        widgets.add(Text(AppLocalizations.of(context).notification_does_not_exist,
            style: Theme.of(context).textTheme.headline4,
            textAlign: TextAlign.center));
        return RequestDependentWidgetBuilder(context: context,
            status: notifications.item2,
            contentGenerator: generateNotifPage,
            content: notifications.item1,
            contentChecker: notifications.item1.item1 != null && notifications.item1.item2 != null,
            onNullContent: Center(
                child: Scaffold(
                    body: SingleChildScrollView(
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          mainAxisSize: MainAxisSize.min,
                          children: widgets
                      ),
                    )
                )

            )
        );

      }
    );
  }

  Widget generateNotifPage(notifications,context){
    List<CustomNotification> notifs = notifications.item1;
    CurrentAccount currentAccount = notifications.item2;
    List<Expense> expenses = currentAccount.expenses;
    List<Widget> widgets = <Widget>[];

    Duration notificationAntecedence = Duration(days: 30);

    widgets.add(
        PageTitleFilter(
            name: AppLocalizations.of(context).notification_title,
            filter: null,
            order: null)
    );



    if (notifs.isEmpty) {
      widgets.add(Text(AppLocalizations.of(context).notification_does_not_exist));
    } else{
      for(CustomNotification notif in notifs){

        Expense matchingExpense = expenses.firstWhere((element) => element.hashCode == notif.id,
            orElse: () => null);
        if(matchingExpense == null){
          continue;
        }
        var location = tz.getLocation('Europe/London');
        tz.TZDateTime expenseLimitDate = tz.TZDateTime.parse(location, matchingExpense.limitDate);
        tz.TZDateTime expenseNotifDate = expenseLimitDate.subtract(notificationAntecedence);

        expenseNotifDate = expenseNotifDate.isAfter(tz.TZDateTime.now(location))
            ? expenseNotifDate :
        tz.TZDateTime.now(location).add(Duration(seconds: 3));

        log("Scheduling notification for: " + matchingExpense.description
            + " for date: " + expenseLimitDate.subtract(notificationAntecedence).toString() );
        Provider.of<NotificationService>(context, listen:false).getPendingNotificationRequests().then((pendingNotifs) {
          //if this notification isnt already in the pending notifications, schedule it
          if(pendingNotifs.where((element) => element.body == notif.body) == null
              && notif.newNotification){
            Provider.of<NotificationService>(context, listen:false).scheduleNotification(
              notif,
              expenseNotifDate
            );
          }
        });

      }

      widgets.add(notificationListView(context, notifs));
    }

    log(notifs.toString());
    return Scaffold(
        body: SingleChildScrollView(
          child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: widgets
          ),
        )
    );
  }

  Widget notificationListView(context, notifications) {
    return this.createNotificationCard(
        context,
        notifications
    );
  }

  Widget createNotificationCard(context, notifications) {
    return Container(
        margin: EdgeInsets.only(bottom: 8),
        padding: EdgeInsets.all(8),
        child: this.createNotificationCards(context, notifications)
    );
  }

  Widget createNotificationCards(context, notifications) {
    final List<Widget> notificationCards = <Widget>[];
    for (var notification in notifications){
      notificationCards.add(this.createNotificationContext(context, notification));
    }
    return Column(children: notificationCards);
  }

  Widget createNotificationContext(context, notification) {
    return InkWell(
      child: Container(
          margin: EdgeInsets.fromLTRB(12, 20, 12, 0),
          child: RowContainer(
            color: notification.newNotification ? Colors.red : Theme.of(context).backgroundColor,
            child: NotificationRow(notification: notification)
          )
      ),
      onTap: (() => {
        Navigator.push(context,
          MaterialPageRoute(
            builder: (context) => notificationTapHandler(notification)
          )
        )
      }),
    );
  }


  Widget notificationTapHandler(CustomNotification notification) {
    return StoreConnector<AppState, dynamic>(
        converter: (store) {
          final List<CustomNotification> notifications = store.state.content['notifications'];
          for (int i = 0; i < notifications.length; i++){
            if (notifications[i] == notification) {
              notifications[i].newNotification = false;
            }
          }
          Future.delayed(Duration.zero,
                  (){
            StoreProvider.of<AppState>(context).dispatch(
              setLocalNotifications(notifications, Completer())
            );
            if(notification.payload != null && notification.payload.isNotEmpty){
              log(notification.payload);
              if(!(notification.payload[0] == '/')){
                Navigator.of(context).pop();
                Navigator.of(NavigationService.navigatorKey.currentContext).pushNamed('/${Constants.navExpenses}');
              } else {
                OpenFile.open(notification.payload);
                Navigator.of(context).pop();
                Navigator.of(NavigationService.navigatorKey.currentContext).pushNamed('/${Constants.navNotifications}');
              }
            }else{
              Navigator.of(context).pop();
              Navigator.of(NavigationService.navigatorKey.currentContext).pushNamed('/${Constants.navNotifications}');
            }
          });
          return store;
        },
        builder: (context, store) {
          return CircularProgressIndicator();
        });
  }
}