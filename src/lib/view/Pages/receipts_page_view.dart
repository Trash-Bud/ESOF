import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:uni/view/Pages/secondary_page_view.dart';
import '../../model/app_state.dart';
import '../../redux/action_creators.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';

import '../Widgets/DownloadError.dart';
import '../Widgets/custom_notification.dart';

class ReceiptsView extends StatefulWidget{
  final String expenseDocument;
  ReceiptsView(
      {Key key,
        @required this.expenseDocument,
      }
      )
      : super(key: key);
  @override
  State<ReceiptsView> createState() => _PDFViewState(document: this.expenseDocument);
}

class _PDFViewState extends State<ReceiptsView> {

  String _localPDF = null;
  String document;
  _PDFViewState({this.document});

  @override
  void initState(){
    super.initState();

  }

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, dynamic>(
        converter: (store)  {
      if(_localPDF == null){
        getReceipt(store, document).then((value){
          setState(() {
            _localPDF = value;
            log("oi demos setState " + _localPDF);
            Future.delayed(Duration.zero,
                    (){
                  Navigator.of(context).pop();
                  Navigator
                      .push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => PDFScreen(path: _localPDF, document: document)
                      )
                  );
                }
            );
          });
        }
        );
      }
      return store;
    },
    builder: (context, store) {
      return  Container(
          color: Colors.white,
          padding: EdgeInsets.only(left: 100.0, top: 200.0, right: 100.0, bottom: 200.0),
          child: CircularProgressIndicator(strokeWidth: 10,) );

    }

    );
  }


}


class PDFScreen extends StatefulWidget {
  final String path;
  final String document;

  PDFScreen({Key key, this.path, this.document}) : super(key: key);

  _PDFScreenState createState() => _PDFScreenState(document);
}

class _PDFScreenState extends State<PDFScreen> with WidgetsBindingObserver {
  final Completer<PDFViewController> _controller =
  Completer<PDFViewController>();
  int pages = 0;
  int currentPage = 0;
  bool isReady = false;
  String errorMessage = '';
  final String document;

  _PDFScreenState(this.document);

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        shadowColor: Colors.white,
        toolbarHeight: 80.0,
        elevation: 0,
        title: Text(AppLocalizations.of(context).receipt,
        style: Theme.of(context).textTheme.headline6.apply(fontSizeDelta: 7)),
        actions: <Widget>[
          IconButton(
            padding: EdgeInsets.only(right: 40.0),
            icon: Icon(MdiIcons.trayArrowDown, color: Colors.black, size: 35.0),
            onPressed: () {
              Navigator.of(context).pop();
              Navigator
                  .push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => PDFDownload(document)
                  ));
            },
          ),
        ],
      ),
      body: Stack(
        children: <Widget>[
          PDFView(
            filePath: widget.path,
            enableSwipe: true,
            swipeHorizontal: true,
            autoSpacing: false,
            pageFling: true,
            pageSnap: true,
            defaultPage: currentPage,
            fitPolicy: FitPolicy.BOTH,
            preventLinkNavigation:
            false, // if set to true the link is handled in flutter
            onRender: (_pages) {
              setState(() {
                pages = _pages;
                isReady = true;
              });
            },
            onError: (error) {
              setState(() {
                errorMessage = error.toString();
              });
              print(error.toString());
            },
            onPageError: (page, error) {
              setState(() {
                errorMessage = '$page: ${error.toString()}';
              });
              print('$page: ${error.toString()}');
            },
            onViewCreated: (PDFViewController pdfViewController) {
              _controller.complete(pdfViewController);
            },
            onLinkHandler: (String uri) {
              print('goto uri: $uri');
            },
            onPageChanged: (int page, int total) {
              print('page change: $page/$total');
              setState(() {
                currentPage = page;
              });
            },
          ),
          errorMessage.isEmpty
              ? !isReady
              ? Center(
            child: CircularProgressIndicator(),
          )
              : Container()
              : Center(
            child: Text(errorMessage),
          )
        ],
      ),
    );
  }
}


class PDFDownload extends StatelessWidget {
  final String document;
  PDFDownload(this.document);

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, dynamic>(
        converter: (store) async {
          try {
            var filePath = await saveReceipt(store, document);
            final List<CustomNotification> notifications = store.state
                .content['notifications'];

            CustomNotification notif = CustomNotification(
                1,
                AppLocalizations.of(context).successful_transfer(
                    AppLocalizations
                        .of(context)
                        .receipt),
                AppLocalizations
                    .of(context)
                    .press_notif,
                filePath,
                true);
            Future.delayed(Duration.zero,
                    () {
                  notifications.add(notif);

                  StoreProvider.of<AppState>(context).dispatch(
                      setLocalNotifications(notifications, Completer()));
                  Provider.of<NotificationService>(context, listen: false)
                      .showNotification(
                      notif
                  );
                  Navigator.of(context).pop();
                });
          }
          catch (e) {
            Navigator.of(context).pop();
            Navigator
                .push(
                context,
                MaterialPageRoute(
                    builder: (context) => DownloadError(e.toString())
                ));
          }
          return store;
        },
        builder: (context, store) {
          return Scaffold(
              body: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(AppLocalizations
                        .of(context).downloading_file,
                      style: Theme
                          .of(context)
                          .textTheme
                          .headline3,
                    ),
                    LinearProgressIndicator(
                      semanticsLabel: 'Downloading file...',
                    ),
                  ],
                ),
              )
          );
        });
  }

}

