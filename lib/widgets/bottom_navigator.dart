import 'package:flutter/material.dart';
import 'package:notez/pages/pages.dart';
import 'package:notez/providers/notesProvider.dart';
import 'package:provider/provider.dart';
// import 'package:font_awesome_flutter/font_awesome_flutter.dart';
// import 'package:gt_bank_ui/pages/pages.dart';
// import 'package:gt_bank_ui/util/colors.dart';

class BaseScreen extends StatefulWidget {
  @override
  _BaseScreenState createState() => _BaseScreenState();
}

class _BaseScreenState extends State<BaseScreen> {
  @override
  void initState() {
    super.initState();
    Consumer<NotesProvider>(
      builder: (context, noteProvider, child) {
        noteProvider.setPageIndex(0);
        return null;
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      body: Consumer<NotesProvider>(
        builder: (context, notesProvider, child) {
          return PageView(
            controller: notesProvider.pageController,
            onPageChanged: (value) => notesProvider.setPageIndex(value),
            children: [
              Home(),
              SharedNotes(),
              NoteTaking(),
              Labels(),
              Profile(),
            ],
          );
        },
      ),
      floatingActionButton: Consumer<NotesProvider>(
        builder: (context, notesProvider, child) {
          return FloatingActionButton(
            onPressed: () {
              notesProvider.setPageIndex(2);
            },
            backgroundColor: Theme.of(context).primaryColor,
            child: Icon(Icons.edit),
          );
        },
      ),
      bottomNavigationBar: BottomAppBar(
          elevation: 35.0,
          shape: CircularNotchedRectangle(),
          color: Colors.white,
          notchMargin: 6,
          clipBehavior: Clip.antiAlias,
          child: buildBottomNavigationIcons()),
      floatingActionButtonLocation:
          FloatingActionButtonLocation.miniCenterDocked,
    );
  }

  buildBottomNavigationIcons() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 15),
      child: Consumer<NotesProvider>(
        builder: (context, notesProvider, child) {
          return Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Row(
              // children: [
              IconButton(
                icon: Icon(
                  Icons.home_outlined,
                  size: 20.0,
                  color: notesProvider.getPageIndex() == 0
                      ? Theme.of(context).primaryColor
                      : Colors.grey,
                ),
                onPressed: () {
                  notesProvider.setPageIndex(0);
                },
              ),
              // SizedBox(width: 35),
              IconButton(
                icon: Icon(Icons.share,
                    size: 20.0,
                    color: notesProvider.getPageIndex() == 1
                        ? Theme.of(context).primaryColor
                        : Colors.grey),
                onPressed: () {
                  notesProvider.setPageIndex(1);
                  // pageChangeAnimation(notesProvider.getPageIndex());
                },
              ),
              IconButton(
                icon: Icon(
                  Icons.label_outlined,
                  size: 20.0,
                  color: notesProvider.getPageIndex() == 3
                      ? Theme.of(context).primaryColor
                      : Colors.white,
                ),
                onPressed: () {},
              ),
              IconButton(
                icon: Icon(
                  Icons.label_outlined,
                  size: 20.0,
                  color: notesProvider.getPageIndex() == 3
                      ? Theme.of(context).primaryColor
                      : Colors.grey,
                ),
                onPressed: () {
                  notesProvider.setPageIndex(3);
                  // pageChangeAnimation(notesProvider.getPageIndex());
                },
              ),
              IconButton(
                icon: Icon(Icons.person_outline,
                    size: 20.0,
                    color: notesProvider.getPageIndex() == 4
                        ? Theme.of(context).primaryColor
                        : Colors.grey),
                onPressed: () {
                  notesProvider.setPageIndex(4);
                  // pageChangeAnimation(notesProvider.getPageIndex());
                },
              ),
            ],
          );
          // SizedBox(width: 60),
          // Row(
          //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //   children: [
          //     SizedBox(width: 35),
          //   ],
          // ),
          // ],
          // );
        },
      ),
    );
  }
}
