import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_gen/gen_l10n/S.dart';
import 'package:flutter_quill/models/documents/document.dart';
import 'package:intl/intl.dart';
import 'package:notebook/bloc/home_bloc.dart';
import 'package:notebook/database/entity/note.dart';

import 'base_screen.dart';
import 'create_note_mobile_sreen.dart';

class HomeMobileScreen extends StatefulWidget {
  HomeMobileScreen({Key? key}) : super(key: key);

  @override
  _HomeMobileScreenState createState() => _HomeMobileScreenState();
}

class _HomeMobileScreenState extends BaseScreen<HomeMobileScreen> {
  //select note ids
  List<String> selectNotes = [];
  final bool isMobile = Platform.isAndroid || Platform.isIOS;

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    context.read<HomeBloc>().add(HomeLoadNote());
    return BlocListener<HomeBloc, HomeState>(
      listener: (context, state) {
        if (state is HomeLoadInProgress) {
          EasyLoading.show(status: "loading");
        } else {
          EasyLoading.dismiss();
        }
      },
      child: BlocBuilder<HomeBloc, HomeState>(
        builder: (context, state) {
          HomeLoadSuccess? homeState;
          List<Note> notes = [];
          if (state is HomeLoadSuccess) {
            homeState = state;
            notes.addAll(state.notes);
          }
          if (state is HomeLoadFailure) {
            EasyLoading.showError(state.error.toString());
          }

          var normalActions = [
            IconButton(
                onPressed: () {
                  Navigator.of(context).pushNamed("/create/note");
                },
                icon: Icon(Icons.add)),
            PopupMenuButton<String>(
              onSelected: (value) {
                print("action select: ${value}");
              },
              itemBuilder: (BuildContext context) {
                return [
                  PopupMenuItem<String>(
                    child: Text("create_encrypted_note"),
                    value: "create_encrypted_note",
                  )
                ];
              },
            )
          ];
          var selectedActions = [
            IconButton(
                onPressed: () {
                  // Navigator.of(context).pushNamed("/create/note");
                  BlocProvider.of<HomeBloc>(context)
                      .add(DeleteNoteEvent(List.from(selectNotes)));
                  setState(() {
                    selectNotes.clear();
                  });
                },
                icon: Icon(Icons.delete)),
          ];
          var listView = ListView.builder(
              shrinkWrap: true,
              itemCount: notes.length,
              itemBuilder: (BuildContext context, int index) {
                var item = notes[index];
                var content = item.content;
                var doc = Document.fromJson(json.decode(content));
                return GestureDetector(
                  onLongPress: () {
                    if (!selectNotes.contains(item.uuid)) {
                      setState(() {
                        selectNotes.add(item.uuid);
                      });
                    }
                  },
                  onTap: () {
                    if (selectNotes.length > 0) {
                      if (selectNotes.contains(item.uuid)) {
                        setState(() {
                          selectNotes.remove(item.uuid);
                        });
                      } else {
                        setState(() {
                          selectNotes.add(item.uuid);
                        });
                      }
                    } else {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => CreateNoteMobileScreen(
                                  note: item,
                                )),
                      );
                    }
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: Card(
                      color: selectNotes.contains(item.uuid)
                          ? Theme.of(context).primaryColor
                          : null,
                      child: Padding(
                        padding:
                            const EdgeInsets.only(left: 10, right: 10, top: 5),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              item.title,
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 18),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 10),
                              child: Text(doc.toPlainText()),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              });
          return Scaffold(
            appBar: AppBar(
              // Here we take the value from the MyHomePage object that was created by
              // the App.build method, and use it to set our appbar title.
              // title: Text(widget.title),
              title: selectNotes.length > 0
                  ? Text('${selectNotes.length} items selected…')
                  : Text(S.of(context)!.app_name),
              actions: selectNotes.length > 0 ? selectedActions : normalActions,
            ),
            drawer: Drawer(
              child: Container(
                color: Theme.of(context).primaryColor,
                child: ListView(
                  children: [
                    DrawerHeader(
                        child: Column(
                      children: [
                        Spacer(),
                        Text("last update"),
                        Text(DateFormat("yyyy-MM-dd HH:mm:ss").format(
                            /*homeSuccessState?.result.data?.time ??*/
                            DateTime.now())),
                        Spacer(),
                        ElevatedButton(
                            onPressed: () {
                              context.read<HomeBloc>().add(HomeLoadNote());
                            },
                            child: Text("Refresh"))
                      ],
                    )),
                    ListTile(
                      title: Text("已加入记事本"),
                    ),
                    ListTile(
                      title: Text("搜索"),
                    ),
                    ListTile(
                      title: Text("设置"),
                    ),
                  ],
                ),
              ),
            ),
            body: listView,
          );
        },
      ),
    );
  }
}
