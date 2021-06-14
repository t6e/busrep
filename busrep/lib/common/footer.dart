import 'package:flutter/material.dart';

import 'package:busrep/components/view.dart';
import 'package:busrep/components/notice.dart';

class Footer extends StatefulWidget {
  const Footer({Key key}) : super(key: key);

  @override
  _Footer createState() => _Footer();
}

class _Footer extends State<Footer> {
  int _selectedIndex = 0;
  final _bottomNavigationBarItems = <BottomNavigationBarItem>[];

  static const _footerIcons = [
    Icons.home,
    Icons.notifications,
  ];

  var _mainBody = [View(), Notice()];

  @override
  void initState() {
    super.initState();
    _bottomNavigationBarItems.add(_updateActiveState(0));
    for (var i = 1; i < _footerIcons.length; i++) {
      _bottomNavigationBarItems.add(_updateDeactiveState(i));
    }
  }

  BottomNavigationBarItem _updateActiveState(int index) {
    return BottomNavigationBarItem(
        icon: Icon(
          _footerIcons[index],
          color: Colors.black87,
        ),
        label: "");
  }

  BottomNavigationBarItem _updateDeactiveState(int index) {
    return BottomNavigationBarItem(
        icon: Icon(
          _footerIcons[index],
          color: Colors.black26,
        ),
        label: "");
  }

  void _onItemTapped(int index) {
    setState(() {
      _bottomNavigationBarItems[_selectedIndex] =
          _updateDeactiveState(_selectedIndex);
      _bottomNavigationBarItems[index] = _updateActiveState(index);
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: _mainBody.elementAt(_selectedIndex),
        bottomNavigationBar: BottomNavigationBar(
          items: _bottomNavigationBarItems,
          type: BottomNavigationBarType.fixed,
          currentIndex: _selectedIndex,
          onTap: _onItemTapped,
        ));
  }
}
