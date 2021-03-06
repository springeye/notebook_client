import 'dart:io';
import 'dart:ui';

import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:bitsdojo_window_platform_interface/window.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_gen/gen_l10n/S.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logging/logging.dart';
import 'package:notebook/datastore/app_data_store.dart';
import 'package:notebook/logging.dart' as logging;
import 'package:notebook/logic/note.dart';
import 'package:notebook/platform/desktop_application.dart';
import 'package:notebook/platform/mobile_application.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

import 'logic/i10n.dart';

class Bootstrap extends StatelessWidget {
  final TransitionBuilder easyload = EasyLoading.init();
  final Locale? locale;

  Bootstrap(this.locale, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<LocalizationsDelegate<Object>> localizationsDelegates = [
      S.delegate,
      GlobalMaterialLocalizations.delegate,
      GlobalWidgetsLocalizations.delegate,
      GlobalCupertinoLocalizations.delegate,
    ];
    return MaterialApp(
      scrollBehavior: const MaterialScrollBehavior().copyWith(
        dragDevices: {
          PointerDeviceKind.mouse,
          PointerDeviceKind.touch,
          PointerDeviceKind.stylus,
          PointerDeviceKind.unknown
        },
      ),
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primaryColor: const Color.fromARGB(255, 236, 236, 236)),
      localizationsDelegates: localizationsDelegates,
      supportedLocales: S.supportedLocales,
      locale: locale,
      home: isMobile ? MobileApplication() : const DesktopApplication(),
      builder: (BuildContext context, Widget? child) {
        child = easyload(context, child);
        return child;
      },
    );
  }
}

final bool isMobile = Platform.isAndroid || Platform.isIOS;

void main() {
  Logger.root.level = Level.ALL; // defaults to Level.INFO
  Logger.root.onRecord.listen((LogRecord record) {
    if (kDebugMode) {
      print('${record.level.name}/${record.time}: ${record.message}');
    }
  });
  launchApp();
}



void launchApp() async {
  String dbPath = await databaseFactoryFfi.getDatabasesPath();
  if (kReleaseMode) {
    Directory appDocDir = await getApplicationSupportDirectory();
    dbPath = join(appDocDir.path, "databases");
    databaseFactoryFfi.setDatabasesPath(dbPath);
  }
  logging.appLog.info("database path:  ${dbPath}");
  WidgetsFlutterBinding.ensureInitialized();
  AppDataStore store = AppDataStore.of();
  String readUserToken = await store.getString("user_token") ?? "";
  runApp(ProviderScope(child: Consumer(builder: (context, ref, child) {
    Locale? watch = ref.watch(i10n);
    //check store lang on app launcher
    store.getString("lang").then((String? value){
      if(value!=null) {
        ref.read(i10n.notifier).setLocale(Locale.fromSubtags(languageCode: value));
      }
    });
    ref.read(noteListProvider.notifier).clear();
    return Bootstrap(watch);
  })));
  if (!isMobile) {
    doWhenWindowReady(() {
      final DesktopWindow win = appWindow;
      const Size initialSize = Size(1100, 800);
      win.minSize = initialSize;
      win.size = initialSize;
      win.alignment = Alignment.center;
      win.show();
    });
  }
}
