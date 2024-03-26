
import 'dart:math';

import 'package:uni/model/entities/bank_reference.dart';

import 'expense.dart';

/// Stores information about the user's profile.
class CurrentAccount {
  List<Expense> expenses = [];
  List<BankReference> bankReferences =[];
  List<String> expenseTypes =  [];
  Map<String, bool> expenseFilter = {};
  CurrentAccount(List<Expense> expenses, List<BankReference> bankReferences,
      List<String> expenseTypes){
    this.expenses = expenses;
    this.bankReferences = bankReferences;
    this.expenseTypes = expenseTypes;
    print(this.expenseTypes);
    expenseFilter = Map.fromIterable(this.expenseTypes,
        value: (type) => true);
  }

  Map<String, bool> getExpenseTypes(){
    return expenseFilter;
  }



  printDebug(){
    for (int i = 0; i < expenses.length; i++){
      expenses[i].printDebug();
    }
    for (int i = 0; i < bankReferences.length; i++){
      bankReferences[i].printDebug();
    }
  }

}
