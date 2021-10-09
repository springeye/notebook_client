import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_gen/gen_l10n/S.dart';
import 'package:notebook/bloc/login_bloc.dart';

import 'base_screen.dart';

class LoginScreen extends StatefulWidget {
  String? error;
  String? username;
  String? password;

  LoginScreen([this.error, this.username, this.password]);

  @override
  _LoginScreenState createState() =>
      _LoginScreenState(error, username, password);
}

class _LoginScreenState extends BaseScreen<LoginScreen> {
  String? error;
  String? username;
  String? password;
  bool useHttps = false;

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
        appBar: AppBar(
          // Here we take the value from the MyHomePage object that was created by
          // the App.build method, and use it to set our appbar title.
          // title: Text(widget.title),
          title: Text(S.of(context)!.page_title_login),
        ),
        body: Column(
          children: [
            if (this.error != null) Text(this.error!),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
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
                      padding: const EdgeInsets.symmetric(vertical: 0),
                      child: Row(
                        children: [
                          Checkbox(
                              value: useHttps,
                              onChanged: (value) {
                                setState(() {
                                  this.useHttps = value ?? false;
                                });
                              }),
                          Expanded(child: Text("https")),
                          ElevatedButton(
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
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
    ;
  }
}
