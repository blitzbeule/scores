import 'package:flutter/material.dart';
import 'package:adaptive_navigation/adaptive_navigation.dart';

import 'package:scores_client/src/routing/route_state.dart';

import 'scaffold_body.dart';

class ScoresScaffold extends StatefulWidget {
  const ScoresScaffold({Key? key}) : super(key: key);

  @override
  _ScoresScaffoldState createState() => _ScoresScaffoldState();
}

class _ScoresScaffoldState extends State<ScoresScaffold> {
  bool _expandedDrawer = true;
  String _appBarTitle = "";

  @override
  void didChangeDependencies() {
    _appBarTitle = _getSelectedTitle(
        _getSelectedIndex(RouteStateScope.of(context).route.pathTemplate));
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    final routeState = RouteStateScope.of(context);
    final selectedIndex = _getSelectedIndex(routeState.route.pathTemplate);

    return Scaffold(
      appBar: AdaptiveAppBar(
        title: Text(_appBarTitle),
        leading: IconButton(
          icon: const Icon(Icons.menu),
          onPressed: () {
            if (_expandedDrawer) {
              setState(() {
                _expandedDrawer = false;
              });
            } else {
              setState(() {
                _expandedDrawer = true;
              });
            }
          },
        ),
      ),
      body: AdaptiveNavigationScaffold(
        selectedIndex: selectedIndex,
        body: const ScoresScaffoldBody(),
        onDestinationSelected: (idx) {
          if (idx == 0) routeState.go('/dashboard');
          if (idx == 1) routeState.go('/participants');
          if (idx == 2) routeState.go('/groups');
          if (idx == 3) routeState.go('/disciplines');
          if (idx == 4) routeState.go('/settings');

          setState(() {
            _appBarTitle = _getSelectedTitle(idx);
          });
        },
        navigationTypeResolver: (context) {
          if (MediaQuery.of(context).size.width > 600) {
            if (_expandedDrawer) {
              return NavigationType.permanentDrawer;
            } else {
              return NavigationType.rail;
            }
          } else {
            return NavigationType.bottom;
          }
        },
        destinations: const [
          AdaptiveScaffoldDestination(
              title: 'Dashboard', icon: Icons.dashboard),
          AdaptiveScaffoldDestination(
              title: 'Participants', icon: Icons.people_alt),
          AdaptiveScaffoldDestination(title: 'Groups', icon: Icons.groups),
          AdaptiveScaffoldDestination(
              title: 'Disciplines', icon: Icons.category),
          AdaptiveScaffoldDestination(title: 'Settings', icon: Icons.settings)
        ],
      ),
    );
  }

  int _getSelectedIndex(String pathTemplate) {
    if (pathTemplate == '/dashboard') return 0;
    if (pathTemplate == '/participants') return 1;
    if (pathTemplate == '/groups') return 2;
    if (pathTemplate == '/disciplines') return 3;
    if (pathTemplate == '/settings') return 4;
    return 0;
  }

  String _getSelectedTitle(int index) {
    if (index == 0) return "Dashboard";
    if (index == 1) return "Participants";
    if (index == 2) return "Groups";
    if (index == 3) return "Disciplines";
    if (index == 4) return "Settings";
    return "";
  }
}
