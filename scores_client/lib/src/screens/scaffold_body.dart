import 'package:flutter/material.dart';

import '../routing.dart';
import '../widgets/fade_transition_page.dart';

class ScoresScaffoldBody extends StatelessWidget {
  static GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  const ScoresScaffoldBody({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var currentRoute = RouteStateScope.of(context).route;

    // A nested Router isn't necessary because the back button behavior doesn't
    // need to be customized.
    return Navigator(
      key: navigatorKey,
      onPopPage: (route, dynamic result) => route.didPop(result),
      pages: [
        if (currentRoute.pathTemplate.startsWith('/dashboard') ||
            currentRoute.pathTemplate == "/")
          const FadeTransitionPage<void>(
            key: ValueKey('dashboard'),
            child: Text("Dashboard"),
          )
        else if (currentRoute.pathTemplate.startsWith('/participants'))
          const FadeTransitionPage<void>(
            key: ValueKey('participants'),
            child: Text("Participants"),
          )
        else if (currentRoute.pathTemplate.startsWith('/groups'))
          const FadeTransitionPage<void>(
            key: ValueKey('groups'),
            child: Text("Groups"),
          )
        else if (currentRoute.pathTemplate.startsWith('/disciplines'))
          const FadeTransitionPage<void>(
            key: ValueKey('disciplines'),
            child: Text("Disciplines"),
          )
        else if (currentRoute.pathTemplate.startsWith('/settings'))
          const FadeTransitionPage<void>(
            key: ValueKey('settings'),
            child: Text("Settings"),
          )

        // Avoid building a Navigator with an empty `pages` list when the
        // RouteState is set to an unexpected path, such as /signin.
        //
        // Since RouteStateScope is an InheritedNotifier, any change to the
        // route will result in a call to this build method, even though this
        // widget isn't built when those routes are active.
        else
          FadeTransitionPage<void>(
            key: const ValueKey('empty'),
            child: Container(),
          ),
      ],
    );
  }
}
