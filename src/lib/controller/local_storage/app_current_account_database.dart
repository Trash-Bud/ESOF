import 'dart:async';
import 'package:uni/controller/local_storage/app_database.dart';
import 'package:uni/model/entities/bank_reference.dart';
import 'package:uni/model/entities/current_account.dart';
import 'package:sqflite/sqflite.dart';

import '../../model/entities/expense.dart';

/// Manages the app's CurrentAccount database.
///
/// This database stores information about the user's exams.
/// See the [CurrentAccount] class to see what data is stored in this database.
class AppCurrentAccountDatabase extends AppDatabase {
  AppCurrentAccountDatabase()
      : super('current_account.db', [
    '''CREATE TABLE expenses(description TEXT, course TEXT, paid BOOL, type TEXT,
          date DATE, limitDate DATE, amount TEXT, status TEXT, document TEXT, interest TEXT, docType TEXT)
          ''',
    '''CREATE TABLE bank_references(description TEXT, amounts TEXT, entity TEXT, reference TEXT, totalAmount TEXT,
          date DATE)
          ''',
        '''CREATE TABLE expense_types(description TEXT)
          '''
  ]);

  /// Replaces all of the data in this database with [expenses].
  saveNewCurrentAccount(CurrentAccount currentAccount) async {
    await deleteCurrentAccount();
    await _insertCurrentAccount(currentAccount);
  }

  /// Returns a list containing all of the exams stored in this database.
  Future<List<Expense>> expenses() async {
    // Get a reference to the database
    final Database db = await this.getDatabase();

    // Query the table for All The Dogs.
    final List<Map<String, dynamic>> maps = await db.query('expenses');

    // Convert the List<Map<String, dynamic> into a List<Dog>.
    return List.generate(maps.length, (i) {
      return Expense.sec(
          maps[i]['description'],
          maps[i]['course'],
          maps[i]['paid'],
          maps[i]['type'],
          maps[i]['date'],
          maps[i]['limitDate'],
          maps[i]['amount'],
          maps[i]['status'],
          maps[i]['document'],
          maps[i]['interest'],
          maps[i]['docType']);
    });
  }

  Future<List<String>> expenseTypes() async {
    // Get a reference to the database
    final Database db = await this.getDatabase();

    // Query the table for expense_types.
    final List<Map<String, dynamic>> maps = await db.query('expense_types');

    // Convert the List<Map<String, dynamic> into a List<Dog>.
    return List.generate(maps.length, (i) {
      return maps[i]['description'];

    });
  }

  /// Returns a list containing all of the exams stored in this database.
  Future<List<BankReference>> bankReferences() async {
    // Get a reference to the database
    final Database db = await this.getDatabase();

    // Query the table for All The Dogs.
    final List<Map<String, dynamic>> maps = await db.query('bank_references');

    // Convert the List<Map<String, dynamic> into a List<Dog>.
    return List.generate(maps.length, (i) {
      return BankReference(
          maps[i]['description'],
          maps[i]['amounts'],
          maps[i]['date'],
          maps[i]['entity'],
          maps[i]['reference'],
          maps[i]['totalAmount'],);
    });
  }

  /// Adds all items from [currentAccount] to this database.
  ///
  /// If a row with the same data is present, it will be replaced.
  Future<void> _insertCurrentAccount(CurrentAccount currentAccount) async {
    for(Expense expense in currentAccount.expenses) {
      await insertInDatabase(
        'expenses',
        expense.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    }
    for(BankReference bankRef in currentAccount.bankReferences) {
      await insertInDatabase(
        'bank_references',
        bankRef.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    }
    for(String expenseType in currentAccount.expenseTypes) {
      await insertInDatabase(
        'expense_types',
        {'description': expenseType},
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    }
  }

  /// Deletes all of the data stored in this database.
  Future<void> deleteCurrentAccount() async {
    final Database db = await this.getDatabase();

    await db.delete('expenses');
    await db.delete('expense_types');
    await db.delete('bank_references');
  }
}
