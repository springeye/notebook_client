import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_gen/gen_l10n/S.dart';
import 'package:notebook/bloc/locale_bloc.dart';
import 'package:notebook/bloc/login_bloc.dart';
import 'package:notebook/datastore/app_data_store.dart';

import 'base_screen.dart';

class LoginDesktopScreen extends StatefulWidget {
  String? error;
  String? username;
  String? password;

  LoginDesktopScreen([this.error, this.username, this.password]);

  @override
  _LoginScreenState createState() =>
      _LoginScreenState(error, username, password);
}

class _LoginScreenState extends BaseScreen<LoginDesktopScreen> {
  String? error;
  String? username;
  String? password;

  _LoginScreenState([this.error, this.username, this.password]);

  final TextEditingController _nameController = new TextEditingController();
  final TextEditingController _passwordController = new TextEditingController();

  @override
  void initState() {
    super.initState();

    if (username != null) {
      _nameController.text = username!;
    }
    if (password != null) {
      _passwordController.text = password!;
    }
  }

  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {

    return BlocListener<LoginBloc, LoginState>(
      listener: (context, state) {
        if (state is AuthErrorState) {
          EasyLoading.showError(state.error);
        } else if (state is LoadingState) {
          EasyLoading.show(
              status: S.of(context)!.loading,
              maskType: EasyLoadingMaskType.black);
        } else {
          EasyLoading.dismiss();
        }
      },
      child: Scaffold(
        body: Stack(
          children: [
            Center(
              child: SizedBox(
                width: 300,
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      TextFormField(
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return S.of(context)!.error_input_username;
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                          hintText: S.of(context)!.hint_input_username,
                        ),
                        controller: _nameController,
                      ),
                      TextFormField(
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return S.of(context)!.error_input_password;
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                            hintText: S.of(context)!.hint_input_password),
                        controller: _passwordController,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 30),
                        child: ElevatedButton(
                          style: ButtonStyle(
                            padding: MaterialStateProperty.all<EdgeInsets>(
                                EdgeInsets.symmetric(vertical: 15, horizontal: 60)),
                          ),
                          onPressed: () async {
                            if (_formKey.currentState!.validate()) {
                              BlocProvider.of<LoginBloc>(context)
                                  .add(LoginRequestEvent(
                                _nameController.text,
                                _passwordController.text,
                              ));
                            }
                          },
                          child: Text(S.of(context)!.login),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Positioned.fill(
              left: 20,
              bottom: 15,
              child: Align(
                child: InkWell(
                  onTap: (){
                    showLanguageDialog(context);
                  },
                  child:  Icon(Icons.language),
                ),
                alignment: Alignment.bottomLeft,
              ),
            ),
          ],
        ),
      ),
    );
    ;
  }
  showLanguageDialog(BuildContext context){
    // var readLang=AppDataStore.of().getString("locale")??"en";
    showDialog(context: context, builder: (BuildContext context){
      return SimpleDialog(
        title: Text(S.of(context)!.select_language),
        children: <Widget>[
          SimpleDialogOption(
            onPressed: () async {
              await AppDataStore.of().setString("locale", "zh");
              BlocProvider.of<LocaleBloc>(context).add(LocaleChangeEvent(Locale.fromSubtags(languageCode: "zh")));
              Navigator.pop(context);
            },
            child: const Text('简体中文'),
          ),
          SimpleDialogOption(
            onPressed: () async {
              await AppDataStore.of().setString("locale", "en");
              BlocProvider.of<LocaleBloc>(context).add(LocaleChangeEvent(Locale.fromSubtags(languageCode: "en")));
              Navigator.pop(context);
            },
            child: const Text('English'),
          ),
        ],
      );
    });
  }
}
