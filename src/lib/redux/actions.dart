
import 'package:uni/model/app_state.dart';
import 'package:uni/model/entities/course_unit.dart';
import 'package:uni/model/entities/exam.dart';
import 'package:uni/model/entities/lecture.dart';
import 'package:uni/model/entities/profile.dart';
import 'package:uni/model/entities/restaurant.dart';
import 'package:uni/model/entities/session.dart';
import 'package:uni/model/entities/trip.dart';
import 'package:uni/model/entities/current_account.dart';
import 'package:uni/model/home_page_model.dart';
import 'package:uni/model/sigarra_pay_page_model.dart';
import 'package:uni/view/Widgets/custom_notification.dart';
import '../model/entities/bus_stop.dart';

import '../model/entities/prints.dart';

class SaveLoginDataAction {
  Session session;
  SaveLoginDataAction(this.session);
}

class SetLoginStatusAction {
  RequestStatus status;
  SetLoginStatusAction(this.status);
}

class SetExamsAction {
  List<Exam> exams;
  SetExamsAction(this.exams);
}

class SetCurrentAccountAction {
  CurrentAccount currentAccount;
  SetCurrentAccountAction(CurrentAccount currentAccount){
    this.currentAccount = currentAccount;
  }
}

class SetNotificationsAction {
  List<CustomNotification> notifications;
  SetNotificationsAction(List<CustomNotification> notifications){
    this.notifications = notifications;
  }
}

class SetPrintsAction {
  Prints print;
  SetPrintsAction(Prints print){
    this.print = print;
  }
}

class SetExamsStatusAction {
  RequestStatus status;
  SetExamsStatusAction(this.status);
}

class SetCurrentAccountStatusAction {
  RequestStatus status;
  SetCurrentAccountStatusAction(this.status);
}

class SetNotificationsStatusAction {
  RequestStatus status;
  SetNotificationsStatusAction(this.status);
}

class SetPrintsStatusAction {
  RequestStatus status;
  SetPrintsStatusAction(this.status);
}

class SetRestaurantsAction {
  List<Restaurant> restaurants;
  SetRestaurantsAction(this.restaurants);
}

class SetRestaurantsStatusAction {
  RequestStatus status;
  SetRestaurantsStatusAction(this.status);
}

class SetScheduleAction {
  List<Lecture> lectures;
  SetScheduleAction(this.lectures);
}

class SetScheduleStatusAction {
  RequestStatus status;
  SetScheduleStatusAction(this.status);
}


class SetInitialStoreStateAction {
  SetInitialStoreStateAction();
}

class SaveProfileAction {
  Profile profile;
  SaveProfileAction(this.profile);
}

class SaveProfileStatusAction {
  RequestStatus status;
  SaveProfileStatusAction(this.status);
}

class SaveUcsAction {
  List<CourseUnit> ucs;
  SaveUcsAction(this.ucs);
}

class SetPrintBalanceAction {
  String printBalance;
  SetPrintBalanceAction(this.printBalance);
}

class SetPrintBalanceStatusAction {
  RequestStatus status;
  SetPrintBalanceStatusAction(this.status);
}

class SetFeesBalanceAction {
  String feesBalance;
  SetFeesBalanceAction(this.feesBalance);
}

class SetFeesLimitAction {
  String feesLimit;
  SetFeesLimitAction(this.feesLimit);
}

class SetFeesStatusAction {
  RequestStatus status;
  SetFeesStatusAction(this.status);
}

class SetCoursesStatesAction {
  Map<String, String> coursesStates;
  SetCoursesStatesAction(this.coursesStates);
}

class SetBusTripsAction {
  Map<String, List<Trip>> trips;
  SetBusTripsAction(this.trips);
}

class SetBusStopsAction {
  Map<String, BusStopData> busStops;
  SetBusStopsAction(this.busStops);
}

class SetBusTripsStatusAction {
  RequestStatus status;
  SetBusTripsStatusAction(this.status);
}

class SetBusStopTimeStampAction {
  DateTime timeStamp;
  SetBusStopTimeStampAction(this.timeStamp);
}

class SetCurrentTimeAction {
  DateTime currentTime;
  SetCurrentTimeAction(this.currentTime);
}

class UpdateFavoriteCards {
  List<FAVORITE_WIDGET_TYPE> favoriteCards;
  UpdateFavoriteCards(this.favoriteCards);
}

class UpdateFavoriteSPCards {
  List<FAVORITE_SP_WIDGET_TYPE> favoriteSPCards;
  UpdateFavoriteSPCards(this.favoriteSPCards);
}

class SetCoursesStatesStatusAction {
  RequestStatus status;
  SetCoursesStatesStatusAction(this.status);
}

class SetPrintRefreshTimeAction {
  String time;
  SetPrintRefreshTimeAction(this.time);
}

class SetFeesRefreshTimeAction {
  String time;
  SetFeesRefreshTimeAction(this.time);
}

class SetHomePageEditingMode {
  bool state;
  SetHomePageEditingMode(this.state);
}

class SetSigarraPayPageEditingMode {
  bool state;
  SetSigarraPayPageEditingMode(this.state);
}

class SetLastUserInfoUpdateTime {
  DateTime currentTime;
  SetLastUserInfoUpdateTime(this.currentTime);
}

class SetExamFilter {
  Map<String, bool> filteredExams;
  SetExamFilter(this.filteredExams);
}

class SetExpensesFilter {
  Map<String, bool> filteredExpenses;
  SetExpensesFilter(this.filteredExpenses);
}

class SetExpensesOrder{
  String orderedExams;
  SetExpensesOrder(this.orderedExams);
}

class SetExpensesOrderCriteria{
  String orderedExpensesCriteria;
  SetExpensesOrderCriteria(this.orderedExpensesCriteria);
}

class SetUserFaculties {
  List<String> faculties;
  SetUserFaculties(this.faculties);
}
