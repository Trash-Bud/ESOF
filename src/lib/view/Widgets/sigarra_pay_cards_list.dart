import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:uni/controller/local_storage/app_shared_preferences.dart';
import 'package:uni/model/app_state.dart';
import 'package:uni/model/sigarra_pay_page_model.dart';
import 'package:uni/redux/actions.dart';
import 'package:uni/utils/constants.dart' as Constants;
import 'package:uni/view/Widgets/back_button_exit_wrapper.dart';
import 'package:uni/view/Widgets/expenses_card.dart';
import 'package:uni/view/Widgets/prints_info_card.dart';
import 'package:uni/view/Widgets/printing_quotas_card.dart';
import 'package:uni/view/Widgets/bank_references_card.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';


class SigarraPayCardsList extends StatelessWidget {
  final Map<FAVORITE_SP_WIDGET_TYPE, Function> cardCreators = {
    FAVORITE_SP_WIDGET_TYPE.expenses: (k, em, od) =>
        ExpensesCard.fromEditingInformation(k, em, od),
    FAVORITE_SP_WIDGET_TYPE.prints : (k, em, od) =>
        PrintsCard.fromEditingInformation(k, em, od),
    FAVORITE_SP_WIDGET_TYPE.bankReferences: (k, em, od) =>
        BankReferencesCard.fromEditingInformation(k, em, od),
    FAVORITE_SP_WIDGET_TYPE.printingQuotas: (k, em, od) =>
        PrintingQuotasCard.fromEditingInformation(k, em, od)
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BackButtonExitWrapper(
        context: context,
        child: createScrollableCardView(context),
      ),
      floatingActionButton:
      this.isEditing(context) ? createActionButton(context) : null,
    );
  }

  Widget createActionButton(BuildContext context) {
    return FloatingActionButton(
      onPressed: () => showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
                title: Text(
                    AppLocalizations.of(context).choose_widget),
                content: Container(
                  child: ListView(children: getCardAdders(context)),
                  height: 200.0,
                  width: 100.0,
                ),
                actions: [
                  TextButton(
                      child: Text(AppLocalizations.of(context).cancel),
                      onPressed: () => Navigator.pop(context))
                ]);
          }), //Add FAB functionality here
      tooltip: 'Adicionar widget',
      child: Icon(Icons.add),
    );
  }

  List<Widget> getCardAdders(BuildContext context) {
    final List<Widget> result = [];
    this.cardCreators.forEach((FAVORITE_SP_WIDGET_TYPE key, Function v) {
      if (!StoreProvider.of<AppState>(context)
          .state
          .content['favoriteSPCards']
          .contains(key)) {

        result.add(Container(
          child: ListTile(
            title: Text(
              v(Key(key.index.toString()), false, null).getTitle(context),
              textAlign: TextAlign.center,
            ),
            onTap: () {
              addCardToFavorites(key, context);
              Navigator.pop(context);
            },
          ),
          decoration: BoxDecoration(
              border: Border(
                  bottom: BorderSide(color: Theme.of(context).dividerColor))),
        ));
      }
    });
    if (result.isEmpty) {
      result.add(Text(
          AppLocalizations.of(context).all_widgets_chosen));
    }
    return result;
  }

  Widget createScrollableCardView(BuildContext context) {
    return StoreConnector<AppState, List<FAVORITE_SP_WIDGET_TYPE>>(
        converter: (store) => store.state.content['favoriteSPCards'],
        builder: (context, favoriteWidgets) {
          return Container(
              height: MediaQuery.of(context).size.height,
              child: ReorderableListView(
                onReorder: (oldi, newi) =>
                    this.reorderCard(oldi, newi, favoriteWidgets, context),
                header: this.createTopBar(context),
                children: this
                    .createFavoriteWidgetsFromTypes(favoriteWidgets, context),
                //Cards go here
              ));
        });
  }

  Widget createTopBar(BuildContext context) {
    log(AppLocalizations.of(context).edit);
    return Container(
      padding: EdgeInsets.fromLTRB(20, 20, 20, 5),
      child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        Text(
          Constants.navSigarraPay,
          style:
          Theme.of(context).textTheme.headline6.apply(fontSizeFactor: 1.3),
        ),
        GestureDetector(
            onTap: () => StoreProvider.of<AppState>(context)
                .dispatch(SetSigarraPayPageEditingMode(!this.isEditing(context))),
            child: Text(this.isEditing(context) ? AppLocalizations.of(context).stop_editing : AppLocalizations.of(context).edit,
                style: Theme.of(context).textTheme.caption))
      ]),
    );
  }

  List<Widget> createFavoriteWidgetsFromTypes(
      List<FAVORITE_SP_WIDGET_TYPE> cards, BuildContext context) {
    if (cards == null) return [];

    final List<Widget> result = <Widget>[];
    for (int i = 0; i < cards.length; i++) {
      result.add(this.createFavoriteWidgetFromType(cards[i], i, context));
    }
    return result;
  }

  Widget createFavoriteWidgetFromType(
      FAVORITE_SP_WIDGET_TYPE type, int i, BuildContext context) {

    return this.cardCreators[type](Key(type.name), this.isEditing(context),
            () => removeFromFavorites(i, context));
  }

  void reorderCard(int oldIndex, int newIndex,
      List<FAVORITE_SP_WIDGET_TYPE> favorites, BuildContext context) {
    final FAVORITE_SP_WIDGET_TYPE tmp = favorites[oldIndex];
    favorites.removeAt(oldIndex);
    favorites.insert(oldIndex < newIndex ? newIndex - 1 : newIndex, tmp);
    StoreProvider.of<AppState>(context)
        .dispatch(UpdateFavoriteSPCards(favorites));
    AppSharedPreferences.saveFavoriteSPCards(favorites);
  }

  void removeFromFavorites(int i, BuildContext context) {
    final List<FAVORITE_SP_WIDGET_TYPE> favorites =
    StoreProvider.of<AppState>(context).state.content['favoriteSPCards'];
    favorites.removeAt(i);
    StoreProvider.of<AppState>(context)
        .dispatch(UpdateFavoriteSPCards(favorites));
    AppSharedPreferences.saveFavoriteSPCards(favorites);
  }

  void addCardToFavorites(FAVORITE_SP_WIDGET_TYPE type, BuildContext context) {
    final List<FAVORITE_SP_WIDGET_TYPE> favorites =
    StoreProvider.of<AppState>(context).state.content['favoriteSPCards'];
    if (!favorites.contains(type)) {
      favorites.add(type);
    }
    StoreProvider.of<AppState>(context)
        .dispatch(UpdateFavoriteSPCards(favorites));
    AppSharedPreferences.saveFavoriteSPCards(favorites);
  }

  bool isEditing(context) {
    final bool result = StoreProvider.of<AppState>(context)
        .state
        .content['sigarraPayPageEditingMode'];
    if (result == null) return false;
    return result;
  }
}