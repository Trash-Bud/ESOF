// enum should be placed somewhere else?
import 'package:uni/model/entities/bank_reference.dart';
import 'package:uni/model/entities/bus_stop.dart';
import 'package:uni/model/entities/expense.dart';
import 'package:uni/model/entities/print.dart';
import 'package:uni/model/entities/printing_quota.dart';
import 'package:uni/model/entities/session.dart';
import 'package:uni/model/entities/trip.dart';
import 'package:uni/utils/constants.dart' as Constants;

import 'entities/exam.dart';
import 'entities/lecture.dart';
import 'entities/restaurant.dart';

enum RequestStatus { none, busy, failed, successful }

///
class AppState {
  Map content = Map<String, dynamic>();

  Map getInitialContent() {
    return {
      'schedule': <Lecture>[],
      'exams': <Exam>[],
      'restaurants': <Restaurant>[],
      'filteredExam': Map<String, bool>(),
      'filteredExpenses': Map<String, bool>(),
      'orderedExpenses': "Data limite de pagamento",
      'orderedExpensesCriteria': "Ascendente",
      'scheduleStatus': RequestStatus.none,
      'loginStatus': RequestStatus.none,
      'examsStatus': RequestStatus.none,
      'notificationsStatus': RequestStatus.none,
      'selected_page': Constants.navPersonalArea,
      'session': Session(authenticated: false),
      'configuredBusStops': Map<String, BusStopData>(),
      'currentBusTrips': Map<String, List<Trip>>(),
      'busstopStatus': RequestStatus.none,
      'timeStamp': DateTime.now(),
      'currentTime': DateTime.now(),
      'profileStatus': RequestStatus.none,
      'printBalanceStatus': RequestStatus.none,
      'feesStatus': RequestStatus.none,
      'coursesStateStatus': RequestStatus.none,
      'lastUserInfoUpdateTime': null
    };
  }

  AppState(Map content) {
    if (content != null) {
      this.content = content;
    } else {
      this.content = this.getInitialContent();
    }
  }

  AppState cloneAndUpdateValue(key, value) {
    return AppState(Map.from(this.content)..[key] = value);
  }

  AppState getInitialState() {
    return AppState(null);
  }
}
