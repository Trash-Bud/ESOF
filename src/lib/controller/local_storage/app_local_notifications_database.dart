import 'dart:async';
import 'dart:developer';
import 'package:uni/controller/local_storage/app_database.dart';
import 'package:sqflite/sqflite.dart';

import '../../model/entities/expense.dart';
import '../../view/Widgets/custom_notification.dart';

/// Manages the app's CurrentAccount database.
///
/// This database stores information about the user's exams.
/// See the [CustomNotification] class to see what data is stored in this database.
class AppLocalNotificationsDatabase extends AppDatabase {

  AppLocalNotificationsDatabase()
      : super('local_notifications.db', [
    '''CREATE TABLE notifications(id TEXT, title TEXT, body TEXT, payload TEXT,
          date TEXT, newNotification TEXT)
          ''',
  ]);

  /// Replaces all of the data in this database with [notifications].
  saveNotifications(List<CustomNotification> notifications) async {
    await deleteNotifications();
    await _insertNotifications(notifications);
  }

  /// Returns a list containing all of the exams stored in this database.
  Future<List<CustomNotification>> notifications() async {
    // Get a reference to the database
    final Database db = await this.getDatabase();

    // Query the table for All The Dogs.
    final List<Map<String, dynamic>> maps = await db.query('notifications');

    // Convert the List<Map<String, dynamic> into a List<Dog>.
    return List.generate(maps.length, (i) {
      return CustomNotification.sec(
          maps[i]['title'],
          maps[i]['body'],
          maps[i]['payload'],
          maps[i]['date'],
          maps[i]['newNotification'],
          maps[i]['id']
        );
    });
  }


  /// Adds all items from [notifications] to this database.
  ///
  /// If a row with the same data is present, it will be replaced.
  Future<void> _insertNotifications(List<CustomNotification> notifications) async {
    try{
      log(notifications.toString());
      for(CustomNotification notif in notifications) {
        await insertInDatabase(
          'notifications',
          notif.toMap(),
          conflictAlgorithm: ConflictAlgorithm.replace,
        );
      }
    }
    catch (e){
      log("bad_insert");
      log(e.toString());
    }


  }

  /// Deletes all of the data stored in this database.
  Future<void> deleteNotifications() async {
    final Database db = await this.getDatabase();

    await db.delete('notifications');

  }
}
