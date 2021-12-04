import 'dart:io';

import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_gen/gen_l10n/S.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:logging/logging.dart';
import 'package:notebook/bloc/locale_bloc.dart';
import 'package:notebook/datastore/app_data_store.dart';
import 'package:notebook/platform/desktop_application.dart';
import 'package:notebook/platform/mobile_application.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

import 'bloc/login_bloc.dart';

class Bootstrap extends StatelessWidget {
  final easyload = EasyLoading.init();

  @override
  Widget build(BuildContext context) {
    var localizationsDelegates = [
      S.delegate,
      GlobalMaterialLocalizations.delegate,
      GlobalWidgetsLocalizations.delegate,
      GlobalCupertinoLocalizations.delegate,
    ];
    return BlocBuilder<LocaleBloc, LocaleState>(
      builder: (context, state) {
        var currentLocale = state is LocaleChangeState
            ? state.locale
            : Locale.fromSubtags(languageCode: "en");
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: ThemeData(primaryColor: Color.fromARGB(255, 236, 236, 236)),
          localizationsDelegates: localizationsDelegates,
          supportedLocales: S.supportedLocales,
          locale: currentLocale,
          home: isMobile ? MobileApplication() : DesktopApplication(),
          builder: (context, child) {
            child = easyload(context, child);
            return child;
          },
        );
      },
    );
  }
}

final bool isMobile = Platform.isAndroid || Platform.isIOS;

void main() {
  Logger.root.level = Level.ALL; // defaults to Level.INFO
  Logger.root.onRecord.listen((record) {
    print('${record.level.name}/${record.time}: ${record.message}');
  });
  launchApp();
}

void launchApp() async {
  var db_path = await databaseFactoryFfi.getDatabasesPath();
  if(kReleaseMode) {
    Directory appDocDir = await getApplicationSupportDirectory();
    db_path = join(appDocDir.path, "databases");
    databaseFactoryFfi.setDatabasesPath(db_path);

  }
  Logger("app").info("database path:  ${db_path}");
  // print(db_path);
  WidgetsFlutterBinding.ensureInitialized();
  var store = AppDataStore.of();
  var readLanguageCode = await store.getString("locale") ?? "en";
  var readUserToken = await store.getString("user_token") ?? "";
  var locale = Locale.fromSubtags(languageCode: readLanguageCode);
  runApp(MultiBlocProvider(
    providers: [
      BlocProvider(
        create: (BuildContext content) => LoginBloc(readUserToken.isEmpty?UnauthenticatedState():AuthenticatedState()),
      ),
      BlocProvider(
        create: (BuildContext content) => LocaleBloc(locale),
      ),
    ],
    child: Bootstrap(),
  ));
  if (!isMobile) {
    doWhenWindowReady(() {
      final win = appWindow;
      final initialSize = Size(1100, 800);
      win.minSize = initialSize;
      win.size = initialSize;
      win.alignment = Alignment.center;
      win.show();
    });
  }
}
