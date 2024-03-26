import 'dart:convert';
import 'dart:developer';

import 'package:uni/model/entities/bank_reference.dart';
import 'package:uni/model/entities/current_account.dart';
import 'package:uni/model/entities/expense.dart';
import 'package:http/http.dart' as http;
import 'package:html/parser.dart' show parse;
import 'package:html/dom.dart';
import 'dart:async';

import '../../model/utils/document_types_enum.dart';

/// Parses information about the user's exams.
class ParserCurrentAccount {

  /// Extracts a list of exams from an HTTP [response].
  Future<CurrentAccount> parseCurrentAccount(http.Response response) async {
    final document = parse(response.body);

    final List<String> categories = getCategories(document);
    final List<Expense> expenses = getExpenses(categories, document);
    final List<BankReference> bankReferences = getBankReferences(document);
    final CurrentAccount currentAccount = CurrentAccount(expenses, bankReferences, categories);

    return currentAccount;
  }

  Future<CurrentAccount> parseCurrentAccount2(http.Response response, CurrentAccount curentAccount) async {
    log(curentAccount.expenses.toString());
    final DateTime now =  DateTime.now();
    final DateTime date = DateTime(now.year, now.month, now.day);
    List<dynamic> doc = jsonDecode(response.body);
    List<String> e1 = [];
    List<String> r1 = [];
    doc.forEach((element) {
      List<dynamic> transaction = element['movimentos'];
      transaction.forEach((element) {

        if(element['referencia'] != null && element['saldado'] == false){
          if(element['motivo'].toString() != "Prazo excedido"){
            e1.add("\n"+element['descricao']+"\n");
            r1.add(element['referencia']);
          }
        }
      });
    });
    log(e1.toString());
    for (int e = 0; e < e1.length; e++){
      for(int i = 0; i < curentAccount.expenses.length; i++){
        if(curentAccount.expenses[i].description == e1[e]){
          if(curentAccount.expenses[i].type == 'Serviços') {
            if(DateTime.parse(curentAccount.expenses[i].limitDate).isAfter(date) || DateTime.parse(curentAccount.expenses[i].limitDate).isAtSameMomentAs(date)) {
              curentAccount.expenses[i].setDocument(r1[e]);
              curentAccount.expenses[i].setDocType(DocumentT.reference);
            }
          }
        }
      }
    }
    log(curentAccount.expenses.toString());
    return curentAccount;
  }
}

  List<String> getCategories(Document document){
    final List<String> categories = [];
    final Element table = document.getElementById('GPAG_CCORRENTE_GERAL_CONTA_CORRENTE_VIEW');
    final Element ul = table.querySelector('ul');
    ul.querySelectorAll('li').forEach((Element category) {
      categories.add(category.text);
    });

    categories.removeLast(); //the last item of the tab in sigarra is the general extract so we don't neet anything from there
    return categories;
  }

  List<Expense> getExpenses(List<String> categories, Document document){
    final List<Expense> expenses = [];
    try{
      for(int i = 1; i < categories.length; i++) {
        final Element tempTable = document.getElementById('tab$i');
        String lastClass = '';
        String currentClass = '';

        tempTable.querySelectorAll('tr').forEach((Element exp) {
          currentClass = exp.className;
          if (currentClass != '') {
            if (lastClass == '')
              lastClass = '?'; //random character to avoid crashing in the next if
            if (lastClass.codeUnitAt(0) != currentClass.codeUnitAt(0)) {
              lastClass = exp.className;
              final Expense expense = createExpense(exp, categories, i);
              expenses.add(expense);
            } else {
              exp.querySelectorAll('td.l').forEach((Element tp) {
                final List<Element> elms = tp.getElementsByTagName('a');
                String link;
                if (elms.isNotEmpty) {
                  link = elms[0].attributes['href'];
                  expenses[expenses.length - 1].setDocument(link);
                  expenses[expenses.length - 1].setDocType(DocumentT.receiptRequest);
                  expenses[expenses.length - 1].setPaid(true);
                }
              });
            }
          }
        });
      }

      final Element tempTable = document.getElementById('tab0');
      tempTable.querySelectorAll('tr').forEach((Element exp) {
        int i = 0;
        int f;
        exp.querySelectorAll('td').forEach((Element e1) {
          if(i == 2){
            for (int l= 0;l < expenses.length; l++){
              var devidedName = e1.text.split(' - ');
              if(devidedName.length == 3){
                String shortName = devidedName[2];
                if(expenses[l].description == ("\n" + shortName + "\n")){
                  f = l;
                  break;
                }
              }
              else{
                if(expenses[l].description == e1.text){
                  f = l;
                  break;
                }
              }
            }
          }
          i++;
        });
        log( "Expense: "  + f.toString());
        exp.querySelectorAll('td.l.a').forEach((Element tp) {
          final List<Element> elms = tp.getElementsByTagName('a');
          String link;
          if (elms.isNotEmpty) {
            link = elms[0].attributes['href'];
            expenses[f].setDocument(link);
            expenses[f].setDocType(DocumentT.referenceRequest);
          }
        });
      });
      log(expenses.toString());
    }catch(e){
      log(e.toString());
    }

    return expenses;
  }

  List<BankReference> getBankReferences(Document document){
    final List<Element> list = document.getElementsByClassName('dadossz');
    log(list.toString());
    if(list.isEmpty) return [];

    final Element table = list[0];
    final List<BankReference> bankReferences = [];
    String oldClassName = ' ';
    List<String> refList = [];
    table.querySelectorAll('tr').forEach((element) {
      log(element.className);
      if (element.className != ''){
        if (element.className.codeUnitAt(0) != oldClassName.codeUnitAt(0) && oldClassName != ' '){
          BankReference br = addBankReferences(refList);
          bankReferences.add(br);
          refList = [];
        }

        element.querySelectorAll('td').forEach((element1) {
          refList.add(element1.text);
        });
        oldClassName = element.className;
      }
    });
    if (refList != []){
      BankReference br = addBankReferences(refList);
      bankReferences.add(br);
    }
    return bankReferences;
  }

  BankReference addBankReferences(List <String> refList){
    log(refList.toString());
    List<String> expenseNames = [refList[0]];
    List<String> expenseAmounts = [refList[1]];
    if (refList.length > 5){
      for (int a = 6; a<refList.length; a++){
        if (a%2 == 0) {
          expenseNames.add(refList[a]);
        }
        else {
          expenseAmounts.add(refList[a]);
        }
      }
    }
    BankReference br = BankReference(expenseNames, expenseAmounts, refList[2], refList[3], refList[4], refList[5]);
    return br;
  }

  Expense createExpense(Element exp, List<String> categories, int index){

    final List<String> expenseData = [];
    exp.querySelectorAll('td.t').forEach((Element tp) {
      expenseData.add(tp.text);
    });
    exp.querySelectorAll('td.data').forEach((Element tp) {
      expenseData.add(tp.text);
    });
    exp.querySelectorAll('td.n').forEach((Element tp) {
      expenseData.add(tp.text);
    });


    if(expenseData.length == 10){
      if(expenseData[9] == ''){
        expenseData[9] = "0,00 €";
      }
      final Expense expense = Expense(expenseData[1],expenseData[0],categories[index],expenseData[4],expenseData[5],expenseData[6],expenseData[2], expenseData[9]);
      if (expenseData[6] == '0,00 €'){
        expense.setPaid(true);
      }
      return expense;
    }
    else{
      if(expenseData[8] == ''){
        expenseData[8] = "0,00 €";
      }
      final Expense expense = Expense(expenseData[0],'none',categories[index],expenseData[3],expenseData[4],expenseData[5],expenseData[1], expenseData[8]);
      if (expenseData[5] == '0,00 €'){
        expense.setPaid(true);
      }
      return expense;
    }

  }
