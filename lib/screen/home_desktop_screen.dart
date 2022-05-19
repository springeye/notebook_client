import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/S.dart';
import 'package:intl/intl.dart';
import 'package:notebook/bloc/home_bloc.dart';
import 'package:notebook/bloc/locale_bloc.dart';
import 'package:notebook/database/entity/note.dart';
import 'package:notebook/database/entity/notebook.dart';
import 'package:notebook/datastore/app_data_store.dart';
import 'package:notebook/model/order_type.dart';
import 'package:super_editor/super_editor.dart';

import 'base_screen.dart';
import 'create_note_desktop_sreen.dart';

class HomeDesktopScreen extends StatefulWidget {
  const HomeDesktopScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends BaseScreen<HomeDesktopScreen> {
  //select note ids
  List<String> selectNotes = [];
  TextEditingController _searchController = TextEditingController();
  Color background = Color.fromARGB(255, 236, 236, 236);
  Color selectBackground = Color.fromARGB(255, 213, 211, 211);

  void initState() {
    _searchController.addListener(() {
      setState(() {
        search = _searchController.text;
      });
    });

    super.initState();
  }

  OrderType sort = OrderType.Updated;

  Widget _buildNoteList(BuildContext context) {
    List<Note> notes = [];
    int currentIndex = -1;
    return BlocBuilder<HomeBloc, HomeState>(
      buildWhen: (p, c) {
        return c is HomeLoadSuccess || c is ShowNoteState;
      },
      builder: (builder, state) {
        if (state is HomeLoadSuccess) {
          notes.clear();
          notes.addAll(state.notes);
          sort = state.sort;
        }
        if (state is ShowNoteState) {
          currentIndex = state.index;
        }
        if (search != null && search!.isNotEmpty) {
          notes = notes.where((element) {
            return element.title.contains(search!) ||
                element.content.contains(search!);
          }).toList();
        }
        if (state is HomeLoadSuccess) {
          var bloc = BlocProvider.of<HomeBloc>(context);
          if (notes.length > 0) {
            bloc.add(ShowNoteEvent(0, notes[0]));
          } else {
            bloc.add(ShowNoteEvent(-1,
                Note.newEmpty()));
          }
        }
        return Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    S.of(context)!.total_notes(notes.length),
                    style: TextStyle(fontSize: 13),
                  ),
                  DropdownButton(
                      style: TextStyle(color: Colors.black, fontSize: 13.0),
                      value: sort,
                      onChanged: (newValue) {
                        setState(() {
                          selectNotes.clear();
                        });
                        BlocProvider.of<HomeBloc>(context)
                            .add(HomeLoadNote(order: OrderType.Created));
                      },
                      underline: Container(),
                      items: <OrderType>[OrderType.Updated, OrderType.Created]
                          .map((e) => DropdownMenuItem(
                                child: Text(sort == OrderType.Updated
                                    ? S.of(context)!.order_edit_time
                                    : S.of(context)!.order_create_time),
                                value: e,
                              ))
                          .toList()),
                ],
              ),
            ),
            Divider(
              indent: 0.0,
              height: 1.0,
            ),
            ListView.separated(
              shrinkWrap: true,
              itemCount: notes.length,
              itemBuilder: (BuildContext context, int index) {
                var item = notes[index];
                var content = item.content;
                return GestureDetector(
                  behavior: HitTestBehavior.opaque,
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
                      var bloc = BlocProvider.of<HomeBloc>(context);
                      bloc.add(ShowNoteEvent(index, item));
                    }
                  },
                  child: Container(
                    color:
                        currentIndex == index || selectNotes.contains(item.uuid)
                            ? background
                            : null,
                    child: Padding(
                      padding: const EdgeInsets.all(10),
                      child: Row(
                        children: [
                          //复选框
                          Container(
                            child: selectNotes.length > 0
                                ? Checkbox(
                                    value: selectNotes.contains(item.uuid),
                                    onChanged: (bool? value) {
                                      if (value == true) {
                                        setState(() {
                                          selectNotes.add(item.uuid);
                                        });
                                      } else {
                                        setState(() {
                                          selectNotes.remove(item.uuid);
                                        });
                                      }
                                    },
                                  )
                                : null,
                          ),
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.only(left: 5),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "${item.title}",
                                    maxLines: 1,
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18),
                                  ),
                                  Text("aaaa",
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis),
                                  Text(DateFormat("yyyy-MM-dd HH:mm:ss").format(
                                      sort == OrderType.Created
                                          ? item.createdTime
                                          : item.updatedTime))
                                ],
                              ),
                            ),
                          ),
                          Image.asset(item.synced?"assets/icon/icon_sync_ok.png":"assets/icon/icon_sync_no.png",width: 15,height: 15,)
                        ],
                      ),
                    ),
                  ),
                );
              },
              separatorBuilder: (BuildContext context, int index) {
                return Divider(
                  indent: 0.0,
                  thickness: 0.0,
                  height: 1.0,
                );
              },
            ),
          ],
        );
        ;
      },
    );
  }

  _onTapNoteBook(bool all, String key) {
    BlocProvider.of<HomeBloc>(context).add(ShowNoteBookEvent(key, all));
  }

  Widget _buildNoteBookList(BuildContext context) {
    final TextStyle notebookStyle = TextStyle(fontSize: 14);
    var createButton = Padding(
      padding: const EdgeInsets.only(top: 10, left: 35, right: 35, bottom: 10),
      child: ElevatedButton.icon(
        icon: Icon(Icons.add),
        onPressed: () {
          // Navigator.of(context).pushNamed("/create/note");
          BlocProvider.of<HomeBloc>(context).add(CreateNoteEvent(
              S.of(context)!.title_unnamed,
              json.encode("aaaa")));
        },
        label: Text(S.of(context)!.create_note),
        style: ElevatedButton.styleFrom(
            padding: EdgeInsets.symmetric(vertical: 12, horizontal: 10),
            shape: StadiumBorder(),
            elevation: 1,
            primary: Colors.white,
            onPrimary: Colors.black),
      ),
    );
    double offsetX = -15;
    String selectNoteBook = "all";
    bool openAll = true;
    List<NoteBook> notebooks = [];
    Locale currentLocale = Localizations.localeOf(context);
    return Container(
      color: background,
      child: SizedBox(
        width: 240,
        child: BlocBuilder<HomeBloc, HomeState>(
          buildWhen: (p, c) {
            return c is ShowNoteBookState || c is HomeLoadNoteBookSuccess;
          },
          builder: (context, state) {
            if (state is ShowNoteBookState) {
              selectNoteBook = state.key;
              openAll = state.openNotebook;
            }
            if (state is HomeLoadNoteBookSuccess) {
              notebooks.clear();
              notebooks.addAll(state.notebooks);
            }
            var local = "zh";
            double size = 40;
            return Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ListView(
                  shrinkWrap: true,
                  children: [
                    createButton,
                    Container(
                      color: selectNoteBook == "all" ? selectBackground : null,
                      child: ListTile(
                        enableFeedback: false,
                        hoverColor: Colors.red,
                        selected: selectNoteBook == "all",
                        leading: Icon(Icons.note),
                        title: Transform.translate(
                          child: Text(
                            S.of(context)!.all_note,
                            style: notebookStyle,
                          ),
                          offset: Offset(offsetX, 0),
                        ),
                        onTap: () {
                          _onTapNoteBook(false, "all");
                        },
                      ),
                    ),
                    Container(
                      color: selectNoteBook == "no_notebook"
                          ? selectBackground
                          : null,
                      child: ListTile(
                        selected: selectNoteBook == "no_notebook",
                        leading: Icon(Icons.category),
                        title: Transform.translate(
                          child: Text(
                            S.of(context)!.unclassified_note,
                            style: notebookStyle,
                          ),
                          offset: Offset(offsetX, 0),
                        ),
                        onTap: () {
                          _onTapNoteBook(false, "no_notebook");
                        },
                      ),
                    ),
                    ListTile(
                      leading: Icon(openAll ? Icons.folder_open : Icons.folder),
                      title: Transform.translate(
                        child: Text(
                          S.of(context)!.my_folder,
                          style: notebookStyle,
                        ),
                        offset: Offset(offsetX, 0),
                      ),
                      onTap: () {
                        _onTapNoteBook(true, "my");
                      },
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 20),
                      child: ListView.builder(
                          shrinkWrap: true,
                          itemCount: openAll ? notebooks.length : 0,
                          itemBuilder: (context, index) {
                            return Container(
                              color: selectNoteBook == notebooks[index].id
                                  ? selectBackground
                                  : null,
                              child: ListTile(
                                selected: selectNoteBook == notebooks[index].id,
                                leading: Icon(Icons.note),
                                title: Transform.translate(
                                  child: Text(
                                    notebooks[index].title,
                                    style: notebookStyle,
                                  ),
                                  offset: Offset(offsetX, 0),
                                ),
                                onTap: () {
                                  _onTapNoteBook(true, notebooks[index].id);
                                },
                              ),
                            );
                          }),
                    ),
                    Container(
                      color:
                          selectNoteBook == "deleted" ? selectBackground : null,
                      child: ListTile(
                        selected: selectNoteBook == "deleted",
                        leading: Icon(Icons.archive),
                        title: Transform.translate(
                          child: Text(
                            S.of(context)!.recycle_bin,
                            style: notebookStyle,
                          ),
                          offset: Offset(offsetX, 0),
                        ),
                        onTap: () {
                          _onTapNoteBook(false, "deleted");
                        },
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 8, horizontal: 25),
                  child: Row(children: [
                    Radio<Locale>(
                        value: Locale.fromSubtags(languageCode: "zh"),
                        groupValue: currentLocale,
                        onChanged: (val) async {
                          if (val != null) {
                            BlocProvider.of<LocaleBloc>(context)
                                .add(LocaleChangeEvent(val));
                            await AppDataStore.of()
                                .setString("locale", val.languageCode);
                          }
                        }),
                    Text("简体中文"),
                    Spacer(),
                    Radio<Locale>(
                        value: Locale.fromSubtags(languageCode: "en"),
                        groupValue: currentLocale,
                        onChanged: (val) async {
                          if (val != null) {
                            BlocProvider.of<LocaleBloc>(context)
                                .add(LocaleChangeEvent(val));
                            await AppDataStore.of()
                                .setString("locale", val.languageCode);
                          }
                        }),
                    Text("English"),
                  ]),
                )
              ],
            );
          },
        ),
      ),
    );
  }

  _buildToolbar(BuildContext context) {
    return Container(
      color: Theme.of(context).primaryColor,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            width: 40,
          ),
          IconButton(
            icon: Icon(Icons.close),
            color: Colors.white,
            onPressed: () {
              setState(() {
                selectNotes.clear();
              });
            },
          ),
          SizedBox(
            width: 15,
          ),
          Text(
            "已选择${selectNotes.length}个笔记",
            style: TextStyle(color: Colors.white, fontSize: 20),
          ),
          Spacer(),
          Icon(
            Icons.move_to_inbox,
            color: Colors.white,
          ),
          SizedBox(
            width: 40,
          ),
          IconButton(
            color: Colors.white,
            icon: Icon(Icons.delete),
            onPressed: () {
              BlocProvider.of<HomeBloc>(context)
                  .add(DeleteNoteEvent(List.from(selectNotes)));
              setState(() {
                selectNotes.clear();
              });
            },
          ),
          SizedBox(
            width: 100,
          ),
        ],
      ),
    );
  }

  String? search;

  _buildTitleBar(BuildContext context) {
    return SizedBox(
      height: 50,
      child: selectNotes.length > 0
          ? _buildToolbar(context)
          : Container(
              child: Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      padding:
                          EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                      decoration: BoxDecoration(
                          color: background,
                          borderRadius: BorderRadius.all(Radius.circular(5))),
                      child: Row(
                        children: [
                          Icon(Icons.search),
                          SizedBox(
                              width: 200,
                              child: TextField(
                                textInputAction: TextInputAction.search,
                                onSubmitted: (value) {
                                  setState(() {
                                    search = value;
                                  });
                                },
                                controller: _searchController,
                                scrollPadding: EdgeInsets.zero,
                                decoration: InputDecoration(
                                  hintText: S.of(context)!.search_note,
                                  hintStyle: TextStyle(fontSize: 15),
                                  border: InputBorder.none,
                                  contentPadding: EdgeInsets.zero,
                                  isDense: true,
                                ),
                              )),
                        ],
                      ),
                    ),
                  ),
                  Spacer()
                ],
              ),
            ),
    );
  }

  @override
  Widget build(BuildContext context) {
    var read = context.read<HomeBloc>();
    read.add(HomeLoadNoteBook());
    read.add(HomeLoadNote());
    var editNote = CreateNoteDesktopScreen();
    checkLocale(context);
    return Scaffold(
      body: Row(
        children: [
          //分类
          _buildNoteBookList(context),
          VerticalDivider(
              width: 1.0, indent: 0.0, color: Theme.of(context).dividerColor),
          Expanded(
            child: Column(
              children: [
                _buildTitleBar(context),
                Expanded(
                  child: Row(
                    children: [
                      SizedBox(
                          width: 300,
                          child: Column(
                            children: [
                              Expanded(child: _buildNoteList(context)),
                            ],
                          )),
                      VerticalDivider(
                          width: 1.0,
                          indent: 0.0,
                          color: Theme.of(context).dividerColor),
                      Expanded(child: editNote)
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void checkLocale(BuildContext context) async {
    var l = await AppDataStore.of().getString("locale");
    BlocProvider.of<LocaleBloc>(context)
        .add(LocaleChangeEvent(Locale.fromSubtags(languageCode: l ?? "en")));
  }
}
