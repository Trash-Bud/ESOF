
import 'dart:developer';
import 'dart:io';

import 'package:flutter/widgets.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_native_timezone/flutter_native_timezone.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:uni/utils/constants.dart' as Constants;
import 'package:uni/view/navigation_service.dart';

import '../../model/entities/expense.dart';
import 'package:http/http.dart' as http;

class CustomNotification{
  int id;
  final String title;
  final String body;
  final String payload;
  DateTime date;
  bool newNotification;

  CustomNotification(this.id, this.title, this.body, this.payload, this.newNotification,
      ){
    this.date = DateTime.now();
  }

  CustomNotification.sec( this.title, this.body, this.payload,
      date, newNotification, id){
    this.id = int.parse(id);
    this.date = DateTime.parse(date);
    this.newNotification = (newNotification == "true");
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id.toString(),
      'title': title,
      'body': body,
      'payload': payload,
      'date': date.toString(),
      'newNotification': newNotification.toString(),

    };
  }
}

class NotificationService{
  static final FlutterLocalNotificationsPlugin
  localNotificationsPlugin = FlutterLocalNotificationsPlugin();

  static Future _notificationDetails() async{
    final largeIconPath = await Utils.downloadFile("https://play-lh.googleusercontent.com"
        "/947VgiC4ySPiJtqMxhTDP7XuZs4UTWDtVYBsergfzM4XTbLA7mS4Xrh2lksZ28bm4nrQ=w240-h480-rw",
        'largeIcon');

    AndroidNotificationDetails androidDetails = const AndroidNotificationDetails(
        'download_file',
        'Download',
        channelDescription: 'This is for downloaded files',
        importance: Importance.max,
        priority: Priority.max,

    );

    IOSNotificationDetails iosDetails = const IOSNotificationDetails(
    );

    return NotificationDetails(
        android:  androidDetails,
        iOS: iosDetails
    );
  }


  NotificationService(){
    _setupNotifications();
  }

  _setupNotifications() async{
    await _setupTimeZone();
    await _initializeNotifications();
  }

  Future<void> _setupTimeZone() async{
    tz.initializeTimeZones();
    final String timeZoneName = await FlutterNativeTimezone.getLocalTimezone();
    tz.setLocalLocation(tz.getLocation(timeZoneName));
  }

  _initializeNotifications() async{
    const android = AndroidInitializationSettings('@mipmap/ic_launcher');
    await localNotificationsPlugin.initialize(
      const InitializationSettings(
        android: android
      ),
      onSelectNotification: _onSelectedNotification,
    );
  }

  _onSelectedNotification(String payload){
    if(payload != null && payload.isNotEmpty){
      if(!payload.startsWith('/')){
        Navigator.of(NavigationService.navigatorKey.currentContext).pushNamed('/${Constants.navNotifications}');
      } else {
        OpenFile.open(payload);
      }
    }
  }

  Future showNotification(CustomNotification notification) async{
    localNotificationsPlugin.show(
        notification.id,
        notification.title,
        notification.body,
         await _notificationDetails(),
      payload: notification.payload
    );
  }

  static void cancelAllNotifs() => localNotificationsPlugin.cancelAll();

  Future<List<PendingNotificationRequest>> getPendingNotificationRequests() async {
    return await localNotificationsPlugin.pendingNotificationRequests();
  }
  Future scheduleNotification(CustomNotification notification, tz.TZDateTime time) async{
    localNotificationsPlugin.zonedSchedule(
    notification.id, notification.title,
        notification.body,
        time,
      await _notificationDetails(),
        uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
        androidAllowWhileIdle: true);

  }

  checkForNotifications() async {
    final details = await localNotificationsPlugin.getNotificationAppLaunchDetails();
    if(details != null && details.didNotificationLaunchApp){
      _onSelectedNotification(details.payload);
    }
  }

}

class Utils {
  static Future<String> downloadFile(String url,
      String fileName) async{
    final directory = await getApplicationDocumentsDirectory();
    final filePath = '${directory.path}/$fileName';
    final response = await http.get(Uri.parse(url));
    final file = File(filePath);

    await file.writeAsBytes(response.bodyBytes);
    return filePath;
  }
}