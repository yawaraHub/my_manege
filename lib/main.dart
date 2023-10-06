import 'package:flutter/material.dart';
import 'package:my_manege/app/category/sc_category.dart';
import 'package:my_manege/app/report/report_sc.dart';
import 'package:my_manege/app/schedule/sc_schedule/sc_schedule.dart';
import 'package:my_manege/app/setting/setting_sc.dart';
import 'package:my_manege/app/task/task_sc.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'My Manege',
      home: HomePage(
        selectedIndex: 0,
      ),
    );
  }
}

class HomePage extends StatefulWidget {
  final int selectedIndex;
  const HomePage({super.key, required this.selectedIndex});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;
  List<Widget> _pages = [
    Schedule(),
    Task(),
    Report(),
    Category(),
    Setting(),
  ];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _selectedIndex = widget.selectedIndex;
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        // 画面を戻ることを防ぎます
        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: const Text('My Manege'),
        ),
        body: Stack(
          children: _pages
              .asMap()
              .map((index, page) {
                return MapEntry(
                  index,
                  Offstage(
                    offstage: index != _selectedIndex,
                    child: page,
                  ),
                );
              })
              .values
              .toList(),
        ),
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _selectedIndex,
          onTap: _onItemTapped,
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.schedule),
              activeIcon: Icon(Icons.schedule),
              label: 'Schedule',
              tooltip: "This is a Home Schedule",
              backgroundColor: Colors.blue,
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.task),
              activeIcon: Icon(Icons.task),
              label: 'Task',
              tooltip: "This is a Task Page",
              backgroundColor: Colors.blue,
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.signal_cellular_alt),
              activeIcon: Icon(Icons.signal_cellular_alt),
              label: 'Report',
              tooltip: "This is a Report Page",
              backgroundColor: Colors.blue,
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.label),
              activeIcon: Icon(Icons.label),
              label: 'Category',
              tooltip: "This is a Category Page",
              backgroundColor: Colors.blue,
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.settings),
              activeIcon: Icon(Icons.settings),
              label: 'Settings',
              tooltip: "This is a Settings Page",
              backgroundColor: Colors.blue,
            ),
          ],
        ),
      ),
    );
  }
}
