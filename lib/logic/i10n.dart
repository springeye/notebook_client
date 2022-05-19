import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:notebook/datastore/app_data_store.dart';

class I10n extends StateNotifier<Locale?>{
  I10n() : super(null);
  Future<void> setLocale(Locale? locale) async {
    state=locale;
    await AppDataStore.of().setString("lang",locale?.languageCode);
  }
  Future<void> storeLocale() async {
    String? l= await AppDataStore.of().getString("lang",defaultValue: "en");
    if(l!=state?.languageCode){
      if(l==null){
        state=null;
      }else{
        state=Locale.fromSubtags(languageCode: l);
      }
    }
  }
}
StateNotifierProvider<I10n, Locale?> i10n = StateNotifierProvider<I10n, Locale?>(
        (StateNotifierProviderRef<I10n, Locale?> ref) => I10n());
