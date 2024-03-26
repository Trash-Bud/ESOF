import 'dart:async';
import 'package:uni/controller/local_storage/app_database.dart';
import 'package:sqflite/sqflite.dart';
import 'package:uni/model/entities/printing_quota.dart';

import '../../model/entities/print.dart';
import '../../model/entities/prints.dart';

/// Manages the app's CurrentAccount database.
///
/// This database stores information about the user's exams.
/// See the [Prints] class to see what data is stored in this database.
class AppPrintsDatabase extends AppDatabase {
  AppPrintsDatabase()
      : super('prints.db', [
    '''CREATE TABLE printing_quota(description TEXT, date DATE, hour TEXT, credit TEXT, iva TEXT,
          account TEXT)
          ''',
    '''CREATE TABLE print(fileName TEXT, date DATE, hour TEXT, printer TEXT, cost TEXT,
          account TEXT, details TEXT)
          '''
  ]);

  /// Replaces all of the data in this database with [prints].
  saveNewPrints(Prints print) async {
    await deletePrints();
    await _insertPrints(print);
  }

  /// Returns a list containing all of the printing quotas stored in this database.
  Future<List<PrintingQuota>> printingQuota() async {
    // Get a reference to the database
    final Database db = await this.getDatabase();

    // Query the table for All The Dogs.
    final List<Map<String, dynamic>> maps = await db.query('printing_quota');

    // Convert the List<Map<String, dynamic> into a List<Dog>.
    return List.generate(maps.length, (i) {
      return PrintingQuota.sec(
          maps[i]['date'],
          maps[i]['hour'],
          maps[i]['description'],
          maps[i]['credit'],
          maps[i]['iva'],
          maps[i]['account'],);
    });
  }

  Future<List<Print>> print() async {
    // Get a reference to the database
    final Database db = await this.getDatabase();

    // Query the table for All The Dogs.
    final List<Map<String, dynamic>> maps = await db.query('print');

    // Convert the List<Map<String, dynamic> into a List<Dog>.
    return List.generate(maps.length, (i) {
      return Print.sec(
        maps[i]['fileName'],
        maps[i]['date'],
        maps[i]['hour'],
        maps[i]['printer'],
        maps[i]['cost'],
        maps[i]['account'],
        maps[i]['details']);
    });
  }

  /// Adds all items from [Prints] to this database.
  ///
  /// If a row with the same data is present, it will be replaced.
  Future<void> _insertPrints(Prints print) async {
    for(PrintingQuota quota in print.printingQuotas) {
      await insertInDatabase(
        'printing_quota',
        quota.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    }
    for(Print p in print.prints) {
      await insertInDatabase(
        'print',
        p.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    }
  }

  /// Deletes all of the data stored in this database.
  Future<void> deletePrints() async {
    final Database db = await this.getDatabase();

    await db.delete('printing_quota');
    await db.delete('print');

  }
}
