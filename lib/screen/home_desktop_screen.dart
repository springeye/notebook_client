import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_gen/gen_l10n/S.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:notebook/database/entity/note.dart';
import 'package:notebook/database/entity/notebook.dart';
import 'package:notebook/datastore/app_data_store.dart';
import 'package:notebook/editor/ext.dart';
import 'package:notebook/logic/i10n.dart';
import 'package:notebook/logic/note.dart';
import 'package:notebook/logic/notebook.dart';
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
  final TextEditingController _searchController = TextEditingController();
  Color background = const Color.fromARGB(255, 236, 236, 236);
  Color selectBackground = const Color.fromARGB(255, 213, 211, 211);

  @override
  void initState() {
    _searchController.addListener(() {
      var text = _searchController.text;
      print(text);

    });

    super.initState();
  }

  OrderType sort = OrderType.Updated;


  Widget _buildNoteList(BuildContext context,WidgetRef ref, ) {

    List<Note> items=ref.watch(filterdNoteListProvider);
    List<String> selected=ref.watch(selectNoteListProvider);
    Note? showDetail=ref.watch(showDetailProvider);
    NoteListControl control=ref.read(noteListProvider.notifier);
    ShowDetailNote showControl=ref.read(showDetailProvider.notifier);
    SelectNoteList selectControl=ref.read(selectNoteListProvider.notifier);
    FilterNote searchControl=ref.read(filterProvider.notifier);
    Filter orderType=ref.watch(filterProvider);
    if(items.isEmpty){
      showControl.show(null);
    }
    final ScrollController controller = ScrollController();
    return Column(
      children: [
        //top toolbar
        Padding(
          padding: const EdgeInsets.all(12.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                S.of(context)!.total_notes(items.length),
                style: const TextStyle(fontSize: 13),
              ),
              DropdownButton<OrderType>(
                  style: const TextStyle(color: Colors.black, fontSize: 13.0),
                  value: orderType.orderType,
                  onChanged: (OrderType? newValue) {
                    if(newValue!=null) {
                      searchControl.setOrderType(newValue);
                    }
                  },
                  underline: Container(),
                  items: <OrderType>[OrderType.Updated, OrderType.Created]
                      .map((OrderType e) => DropdownMenuItem(
                    child: Text(sort == OrderType.Updated
                        ? S.of(context)!.order_edit_time
                        : S.of(context)!.order_create_time),
                    value: e,
                  ))
                      .toList()),
            ],
          ),
        ),
        const Divider(
          indent: 0.0,
          height: 1.0,
        ),
        //note list
        Expanded(
          child: ListView.separated(
            controller: controller,
            shrinkWrap: true,
            itemCount: items.length,
            itemBuilder: (BuildContext context, int index) {
              Note item = items[index];
              String content = item.content;
              return GestureDetector(
                behavior: HitTestBehavior.opaque,
                onLongPress: () {
                  selectControl.add(item.uuid);
                },
                onTap: () {
                  if (selected.isNotEmpty) {
                    if (selected.contains(item.uuid)) {
                      selectControl.remove(item.uuid);
                    } else {
                      selectControl.add(item.uuid);
                    }
                  } else {
                    showControl.show(item);
                  }
                },
                child: Container(
                  color:
                  showDetail?.uuid == item.uuid || selected.contains(item.uuid) ? background
                      : null,
                  child: Padding(
                    padding: const EdgeInsets.all(10),
                    child: Row(
                      children: [
                        //复选框
                        Container(
                          child: selected.length > 0
                              ? Checkbox(
                            value: selected.contains(item.uuid),
                            onChanged: (bool? value) {
                              if (value == true) {
                                  selectControl.add(item.uuid);
                              } else {
                                selectControl.remove(item.uuid);
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
                                  item.title,
                                  maxLines: 1,
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18),
                                ),
                                Text(item.content,
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
        ),
      ],
    );
  }

  _onTapNoteBook(bool all, String key,WidgetRef ref) {
    print("_onTapNoteBook");
  }

  Widget _buildNoteBookList(BuildContext context,WidgetRef ref) {
    NoteListControl noteControl=ref.read(noteListProvider.notifier);
    NotebookControl noteBookControl=ref.read(nodebookProvider.notifier);
    noteBookControl.load();
    noteControl.load();
    const TextStyle notebookStyle = TextStyle(fontSize: 14);
    Padding createButton = Padding(
      padding: const EdgeInsets.only(top: 10, left: 35, right: 35, bottom: 10),
      child: ElevatedButton.icon(
        icon: const Icon(Icons.add),
        onPressed: () async {
          noteControl.create(S.of(context)!.title_unnamed, "");
          noteControl.load();
        },
        label: Text(S.of(context)!.create_note),
        style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 10),
            shape: const StadiumBorder(),
            elevation: 1,
            primary: Colors.white,
            onPrimary: Colors.black),
      ),
    );
    double offsetX = -15;
    String selectNoteBook = "all";
    bool openAll = true;
    List<NoteBook> notebooks = ref.watch(nodebookProvider) ;
    Locale currentLocale = Localizations.localeOf(context);
    return Container(
      color: background,
      //left folder slide
      child: SizedBox(
        width: 240,
        child: Column(
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
                    leading: const Icon(Icons.note),
                    title: Transform.translate(
                      child: Text(
                        S.of(context)!.all_note,
                        style: notebookStyle,
                      ),
                      offset: Offset(offsetX, 0),
                    ),
                    onTap: () {
                      _onTapNoteBook(false,"all",ref);
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
                      _onTapNoteBook(false, "no_notebook",ref);
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
                    _onTapNoteBook(true, "my" ,ref);
                  },
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 20),
                  child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: openAll ? notebooks.length : 0,
                      itemBuilder: (BuildContext context, int index) {
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
                              _onTapNoteBook(true, notebooks[index].uuid,ref);
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
                      _onTapNoteBook(false, "deleted",ref);
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
                    value: const Locale.fromSubtags(languageCode: "zh"),
                    groupValue: currentLocale,
                    onChanged: (Locale? val) async {
                      if (val != null) {
                        ref.read(i10n.notifier).setLocale(val);
                      }
                    }),
                const Text("简体中文"),
                const Spacer(),
                Radio<Locale>(
                    value: const Locale.fromSubtags(languageCode: "en"),
                    groupValue: currentLocale,
                    onChanged: (Locale? val) async {
                      if (val != null) {
                        ref.read(i10n.notifier).setLocale(val);
                      }
                    }),
                const Text("English"),
              ]),
            )
          ],
        ),
      ),
    );
  }

  _buildToolbar(BuildContext context,WidgetRef ref, ) {
    List<String> selectNotes=ref.watch(selectNoteListProvider);
    var control=ref.read(selectNoteListProvider.notifier);
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
                control.clear();
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
            icon: const Icon(Icons.delete),
            onPressed: () {
              EasyLoading.showToast( "点击删除");
            },
          ),
          SizedBox(
            width: 100,
          ),
        ],
      ),
    );
  }


  _buildTitleBar(BuildContext context,WidgetRef ref, ) {
    List<String> selectNotes=ref.watch(selectNoteListProvider);
    var searchControl=ref.read(filterProvider.notifier);
    return SizedBox(
      height: 50,
      child: selectNotes.length > 0
          ? _buildToolbar(context,ref)
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
                                onSubmitted: (String value) {
                                  searchControl.setKeyword(value);
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

    CreateNoteDesktopScreen editNote = const CreateNoteDesktopScreen();


    return Consumer(
      builder: ( BuildContext context, WidgetRef ref, Widget? child) {
        return Scaffold(
          body: Row(
            children: [
              //分类
              _buildNoteBookList(context,ref),
              VerticalDivider(
                  width: 1.0, indent: 0.0, color: Theme.of(context).dividerColor),
              Expanded(
                child: Column(
                  children: [
                    _buildTitleBar(context,ref),
                    Expanded(
                      child: Row(
                        children: [
                          //note listview
                          SizedBox(
                              width: 300,
                              child: Column(
                                children: [
                                  Expanded(child: _buildNoteList(context,ref)),
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
    );
  }

}
