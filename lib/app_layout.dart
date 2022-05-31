import 'package:flutter/material.dart';
import 'package:flutter_expense_manager/classes/navigation_item.dart';
import 'package:flutter_expense_manager/pages/home_page.dart';
import 'package:flutter_expense_manager/pages/more_page.dart';
import 'package:flutter_expense_manager/pages/statement_page.dart';

class AppLayout extends StatefulWidget {
  const AppLayout({Key? key}) : super(key: key);

  @override
  State<AppLayout> createState() => _AppLayoutState();
}

class _AppLayoutState extends State<AppLayout> {
  int _currentPageIndex = 0;

  final List<NavigationItem> _navigationItems = const [
    NavigationItem(
      label: 'Home',
      icon: Icon(Icons.home_outlined),
      child: HomePage(),
    ),
    NavigationItem(
      label: 'Statements',
      icon: Icon(Icons.list_alt),
      child: StatementPage(),
    ),
    NavigationItem(
      label: 'More',
      icon: Icon(Icons.more_horiz),
      child: MorePage(),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Divider(
            height: 0,
          ),
          BottomNavigationBar(
            currentIndex: _currentPageIndex,
            type: BottomNavigationBarType.fixed,
            items: [
              ..._navigationItems.map(
                (e) => BottomNavigationBarItem(icon: e.icon, label: e.label),
              ),
            ],
            onTap: (index) => setState(() {
              _currentPageIndex = index;
            }),
          ),
        ],
      ),
      body: _navigationItems.elementAt(_currentPageIndex).child,
    );
  }
}
