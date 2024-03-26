import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:uni/view/Pages/secondary_page_view.dart';
import '../../model/app_state.dart';
import '../../model/entities/expense.dart';
import 'package:uni/utils/constants.dart' as Constants;
import '../../model/entities/prints.dart';
import '../../model/entities/current_account.dart';
import '../../model/entities/expense.dart';
import '../../model/entities/prints.dart';
import 'package:uni/view/Pages/general_page_view.dart';
import 'package:uni/view/Widgets/sigarra_pay_cards_list.dart';

class SigarraPayView extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => SigarraPayViewState();
}

class SigarraPayViewState extends GeneralPageViewState {
  @override
  Widget getBody(BuildContext context) {
    return SigarraPayCardsList();
   }
}

