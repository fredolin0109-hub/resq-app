import 'package:flutter/material.dart';

/// Controller coordinating bottom navigation tabs, quick action routing, and UI events.
class RescueDashboardController extends ChangeNotifier {
  int _currentTabIndex = 0;

  int get currentTabIndex => _currentTabIndex;

  void selectTab(int index) {
    if (_currentTabIndex != index) {
      _currentTabIndex = index;
      notifyListeners();
    }
  }

  void navigateTo(BuildContext context, String routeName, {Widget? placeholder}) {
    if (placeholder != null) {
      Navigator.of(context).push(
        MaterialPageRoute(
          settings: RouteSettings(name: routeName),
          builder: (context) => placeholder,
        ),
      );
    } else {
      Navigator.of(context).pushNamed(routeName);
    }
  }
}
