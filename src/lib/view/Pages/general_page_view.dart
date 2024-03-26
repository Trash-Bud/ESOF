import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:provider/provider.dart';
import 'package:tuple/tuple.dart';
import 'dart:io';

import 'package:uni/controller/load_info.dart';
import 'package:uni/model/app_state.dart';
import 'package:uni/model/profile_page_model.dart';
import 'package:uni/view/Widgets/custom_notification.dart';
import 'package:uni/view/Widgets/navigation_drawer.dart';
import 'package:uni/utils/constants.dart' as Constants;
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../controller/language/l10n/language_change_provider.dart';
import '../Widgets/request_dependent_widget_builder.dart';

/// Manages the  section inside the user's personal area.
abstract class GeneralPageViewState extends State<StatefulWidget> {
  final double borderMargin = 18.0;
  static FileImage decorageImage;

  @override
  Widget build(BuildContext context) {
    return this.getScaffold(context, getBody(context));
  }

  Widget getBody(BuildContext context) {
    return Container();
  }

  /// Returns the current user image.
  ///
  /// If the image is not found / doesn't exist returns a generic placeholder.
  DecorationImage getDecorageImage(File x) {
    final fallbackImage = decorageImage == null
        ? AssetImage('assets/images/profile_placeholder.png')
        : decorageImage;

    final image = (x == null) ? fallbackImage : FileImage(x);
    final result = DecorationImage(fit: BoxFit.cover, image: image);
    if (x != null) {
      decorageImage = image;
    }
    return result;
  }

  Future<DecorationImage> buildDecorageImage(context) async {
    final storedFile =
        await loadProfilePic(StoreProvider.of<AppState>(context));
    return getDecorageImage(storedFile);
  }

  Widget refreshState(BuildContext context, Widget child) {
    return StoreConnector<AppState, VoidCallback>(
      converter: (store) {
        return () => handleRefresh(store);
      },
      builder: (context, refresh) {
        return RefreshIndicator(
            key: GlobalKey<RefreshIndicatorState>(),
            child: child,
            onRefresh: refresh,
            color: Theme.of(context).accentColor);
      },
    );
  }

  Widget getScaffold(BuildContext context, Widget body) {
    return Scaffold(
      appBar: buildAppBar(context),
      drawer: NavigationDrawer(parentContext: context),
      body: this.refreshState(context, body),
    );
  }

  /// Builds the upper bar of the app.
  ///
  /// This method returns an instance of `AppBar` containing the app's logo,
  /// an option button and a button with the user's picture.
  AppBar buildAppBar(BuildContext context) {
    final MediaQueryData queryData = MediaQuery.of(context);

    return AppBar(
      bottom: PreferredSize(
        preferredSize: Size.zero,
        child: Container(
          margin: EdgeInsets.only(left: borderMargin, right: borderMargin),
          color: Theme.of(context).dividerColor,
          height: 1.5,
        ),
      ),
      elevation: 0,
      iconTheme: IconThemeData(color: Theme.of(context).accentColor),
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      titleSpacing: 0.0,
      title: Row(children: <Widget>[
        getNotificationsButton(context),
        ButtonTheme(
            minWidth: 0,
            padding: EdgeInsets.only(left: 0),
            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
            shape: RoundedRectangleBorder(),
            child: TextButton(
              onPressed: () {
                final currentRouteName = ModalRoute.of(context).settings.name;
                if (currentRouteName != Constants.navPersonalArea) {
                  Navigator.pushNamed(context, '/${Constants.navPersonalArea}');
                }
              },
              child: SvgPicture.asset(
                'assets/images/logo_dark.svg',
                height: queryData.size.height / 25,
              ),
            ))
      ]),
      actions: <Widget>[
        getLanguageChangeButton(context),
        getTopRightButton(context),
      ],
    );
  }

  // Gets a round shaped button with the photo of the current user.
  Widget getTopRightButton(BuildContext context) {
    return FutureBuilder(
        future: buildDecorageImage(context),
        builder: (BuildContext context,
            AsyncSnapshot<DecorationImage> decorationImage) {
          return TextButton(
            key: const Key('fotoicon'),
            onPressed: () => {
              Navigator.push(
                  context, MaterialPageRoute(builder: (__) => ProfilePage()))
            },
            child: Container(
                width: 40.0,
                height: 40.0,
                decoration: BoxDecoration(
                    shape: BoxShape.circle, image: decorationImage.data)),
          );
        });
  }

  Widget getLanguageChangeButton(BuildContext context) {
    return TextButton(
        key: const Key('languageicon'),
        onPressed: () => {
              context.read<LanguageChangeProvider>().changeLocale(),
            },
        child: Container(
          width: 40.0,
          height: 40.0,
          child: Image.asset(AppLocalizations.of(context).image),
        ));
  }

  Widget getNotificationsButton(BuildContext context) {
    return StoreConnector<AppState, Tuple2<List<CustomNotification>,RequestStatus>>(converter: (store) {
      final List<CustomNotification> notifications = store.state.content['notifications'];
      log(notifications.toString());
      final  notifications_status = store.state.content['notificationsStatus'];
      return Tuple2(notifications,notifications_status);
    }, builder: (context, notifs) {
      return RequestDependentWidgetBuilder(context: context,
          status: notifs.item2,
          contentGenerator: createButton,
          content: notifs.item1,
          contentChecker: notifs.item1 != null,
          onNullContent: Center(
              child: Icon(MdiIcons.bell)
          )
      );
    });
  }

  Widget createButton(notifications,BuildContext context){
    var has_active_notifs = false;

    for (var notif in notifications){
      if (notif.newNotification){
        has_active_notifs = true;
        break;
      }
    }

    Icon bellIcon = Icon(has_active_notifs ? MdiIcons.bellBadge : MdiIcons.bell);
    return IconButton(
      key: Key("notifications"),
      icon: bellIcon,
      iconSize: 40,
      onPressed: () {
        final currentRouteName = ModalRoute.of(context).settings.name;
        if (currentRouteName != Constants.navNotifications) {
          Navigator.pushNamed(context, '/${Constants.navNotifications}');
        }
      },
    );
  }
}
