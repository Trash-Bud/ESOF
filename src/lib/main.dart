import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:provider/provider.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
import 'package:sentry/sentry.dart';
import 'package:redux/redux.dart';
import 'package:uni/controller/middleware.dart';
import 'package:uni/model/app_state.dart';
import 'package:uni/redux/actions.dart';
import 'package:uni/redux/reducers.dart';
import 'package:uni/utils/constants.dart' as Constants;
import 'package:uni/view/Pages/about_page_view.dart';
import 'package:uni/view/Pages/bug_report_page_view.dart';
import 'package:uni/view/Pages/bus_stop_next_arrivals_page.dart';
import 'package:uni/view/Pages/exams_page_view.dart';
import 'package:uni/view/Pages/home_page_view.dart';
import 'package:uni/view/Pages/bank_references_page_view.dart';
import 'package:uni/view/Pages/notifications_page_view.dart';
import 'package:uni/view/Pages/prints_list_page_view.dart';
import 'package:uni/view/Pages/print_quotas_page_view.dart';
import 'package:uni/view/Pages/logout_route.dart';
import 'package:uni/view/Pages/receipts_page_view.dart';
import 'package:uni/view/Pages/sigarra_pay_view.dart';
import 'package:uni/view/Pages/splash_page_view.dart';
import 'package:uni/view/Pages/expenses_page_view.dart';
import 'package:uni/view/Widgets/custom_notification.dart';
import 'package:uni/view/Widgets/page_transition.dart';
import 'package:uni/view/navigation_service.dart';
import 'package:uni/view/theme.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;
import 'controller/language/l10n/l10n.dart';
import 'controller/language/l10n/language_change_provider.dart';
import 'controller/on_start_up.dart';
import 'model/entities/expense.dart';
import 'model/schedule_page_model.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'package:timezone/timezone.dart' as tz;

/// Stores the state of the app
final Store<AppState> state = Store<AppState>(appReducers,
    /* Function defined in the reducers file */
    initialState: AppState(null),
    middleware: [generalMiddleware]);

SentryEvent beforeSend(SentryEvent event) {
  return event.level == SentryLevel.info ? event : null;
}

Future<void> main() async {
  OnStartUp.onStart(state);
  tz.initializeTimeZones();
  var locations = tz.timeZoneDatabase.locations;
  await SentryFlutter.init(
    (options) {
      options.dsn =
          'https://a2661645df1c4992b24161010c5e0ecb@o553498.ingest.sentry.io/5680848';
    },
    appRunner: () => {
    runApp(MultiProvider(
        providers: [
          Provider<NotificationService>(create: (context) => NotificationService()),
          ChangeNotifierProvider<LanguageChangeProvider>(
              create: (context) => LanguageChangeProvider())
        ],
        child:MyApp()
      )
    )
    },
  );
}

/// Manages the state of the app
/// 
/// This class is necessary to track the app's state for
/// the current execution
class MyApp extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return MyAppState(
        state: Store<AppState>(appReducers,
            /* Function defined in the reducers file */
            initialState: AppState(null),
            middleware: [generalMiddleware]));
  }
}

/// Manages the app depending on its current state
class MyAppState extends State<MyApp> {
  MyAppState({@required this.state}) {}

  final Store<AppState> state;

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
    return StoreProvider(
      store: state,
      child: MaterialApp(
          title: 'uni',
          theme: applicationLightTheme,
          home: SplashScreen(),
          navigatorKey: NavigationService.navigatorKey,
          supportedLocales: L10n.all,
          localizationsDelegates: const [
            // delegate from flutter_localization
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
            // delegate from localization package.
            AppLocalizations.delegate,
          ],
          locale: Locale('en'),
          /*locale: Provider.of<LanguageChangeProvider>(context, listen: true)
              .getCurrentLocale(), */
          // ignore: missing_return
          onGenerateRoute: (RouteSettings settings) {
            switch (settings.name) {
              case '/' + Constants.navPersonalArea:
                return PageTransition.makePageTransition(
                    page: HomePageView(), settings: settings);
              case '/' + Constants.navSchedule:
                return PageTransition.makePageTransition(
                    page: SchedulePage(), settings: settings);
              case '/' + Constants.navExams:
                return PageTransition.makePageTransition(
                    page: ExamsPageView(), settings: settings);
              case '/' + Constants.navStops:
                return PageTransition.makePageTransition(
                    page: BusStopNextArrivalsPage(), settings: settings);
              case '/' + Constants.navAbout:
                return PageTransition.makePageTransition(
                    page: AboutPageView(), settings: settings);
              case '/' + Constants.navSigarraPay:
                return PageTransition.makePageTransition(
                    page: SigarraPayView(), settings: settings);
              case '/' + Constants.navNotifications:
                return PageTransition.makePageTransition(
                    page: NotificationsView(), settings: settings);
              case '/' + Constants.navExpenses:
                return PageTransition.makePageTransition(
                    page: ExpensesView(), settings: settings);
              case '/' + Constants.navBankReferences:
                return PageTransition.makePageTransition(
                    page: BankReferencesPageView(), settings: settings);
              case '/' + Constants.navPrintsList:
                return PageTransition.makePageTransition(
                    page: PrintsListPageView(), settings: settings);
              case '/' + Constants.navPrintQuotas:
                return PageTransition.makePageTransition(
                    page: PrintQuotasPageView(), settings: settings);
              case '/' + Constants.navBugReport:
                return PageTransition.makePageTransition(
                    page: BugReportPageView(),
                    settings: settings,
                    maintainState: false
                );
              case '/' + Constants.navLogOut:
                return LogoutRoute.buildLogoutRoute();

            }
          }),
    );
  }
  
  
  
  @override
  void initState() {
    super.initState();
    Timer.periodic(Duration(seconds: 60),
        (Timer t) => state.dispatch(SetCurrentTimeAction(DateTime.now())));

   
    checkNotifications();
  }

  checkNotifications() async{
    await Provider.of<NotificationService>(context, listen:false).checkForNotifications();
  }
}
