import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:notebook/datastore/app_data_store.dart';
import 'package:notebook/logging.dart';

class I10n extends StateNotifier<Locale>{
  I10n(Locale locale) : super(locale);
  Future<void> setLocale(Locale locale) async {
    if(state!=locale) {
      appLog.fine("set language: ${locale.languageCode}");
      state = locale;
      await AppDataStore.of().setString("lang", locale.languageCode);
    }
  }
}
StateNotifierProvider<I10n, Locale?> i10n = StateNotifierProvider.family<I10n, Locale?,Locale>((StateNotifierProviderRef<I10n, Locale?> ref,Locale local) => I10n(local))(const Locale.fromSubtags(languageCode: "en"));
