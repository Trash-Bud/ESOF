import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../Pages/secondary_page_view.dart';

class DownloadError extends StatefulWidget{
  String exception;
  DownloadError(this.exception);

  @override
  State<StatefulWidget> createState() {
    return DownloadErrorState(exception);
  }

}

class DownloadErrorState extends SecondaryPageViewState{
  String exception;

  DownloadErrorState(this.exception);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(AppLocalizations
                  .of(context)
                  .could_not_download,
                style: Theme
                    .of(context)
                    .textTheme
                    .headline3,
              ),
              Text(" "),
              Text(exception,
                style: Theme
                    .of(context)
                    .textTheme
                    .headline3,
              ),
            ],
          ),
        )
    );
  }
}