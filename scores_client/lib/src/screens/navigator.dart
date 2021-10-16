import 'package:flutter/material.dart';

import '../auth.dart';
import '../routing.dart';
import '../widgets/fade_transition_page.dart';
import 'scaffold.dart';
import 'sign_in.dart';

class ScoresNavigator extends StatefulWidget {
  final GlobalKey<NavigatorState> navigatorKey;

  const ScoresNavigator({
    required this.navigatorKey,
    Key? key,
  }) : super(key: key);

  @override
  _ScoresNavigatorState createState() => _ScoresNavigatorState();
}

class _ScoresNavigatorState extends State<ScoresNavigator> {
  final _signInKey = const ValueKey('Sign in');
  final _scaffoldKey = const ValueKey<String>('App scaffold');
  final _bookDetailsKey = const ValueKey<String>('Book details screen');
  final _authorDetailsKey = const ValueKey<String>('Author details screen');

  @override
  Widget build(BuildContext context) {
    final routeState = RouteStateScope.of(context);
    final authState = ScoresAuthScope.of(context);
    final pathTemplate = routeState.route.pathTemplate;

    return Navigator(
      key: widget.navigatorKey,
      onPopPage: (route, dynamic result) {
        // When a page that is stacked on top of the scaffold is popped, display
        // the /books or /authors tab in BookstoreScaffold.
        if (route.settings is Page &&
            (route.settings as Page).key == _bookDetailsKey) {
          routeState.go('/books/popular');
        }

        if (route.settings is Page &&
            (route.settings as Page).key == _authorDetailsKey) {
          routeState.go('/authors');
        }

        return route.didPop(result);
      },
      pages: [
        if (routeState.route.pathTemplate == '/signin')
          // Display the sign in screen.
          FadeTransitionPage<void>(
            key: _signInKey,
            child: SignInScreen(
              onSignIn: (credentials) async {
                var signedIn = await authState.signIn(
                    credentials.username, credentials.password);
                if (signedIn) {
                  routeState.go('/dashboard');
                }
              },
            ),
          )
        else ...[
          // Display the app
          FadeTransitionPage<void>(
              key: _scaffoldKey, child: const ScoresScaffold()),
          // Add an additional page to the stack if the user is viewing a book
          // or an author
          /**if (selectedBook != null)
            MaterialPage<void>(
              key: _bookDetailsKey,
              child: BookDetailsScreen(
                book: selectedBook,
              ),
            )
          else if (selectedAuthor != null)
            MaterialPage<void>(
              key: _authorDetailsKey,
              child: AuthorDetailsScreen(
                author: selectedAuthor,
              ),
            ),**/
        ],
      ],
    );
  }
}
