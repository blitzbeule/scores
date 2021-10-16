import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';

class ScoresAuth extends ChangeNotifier {
  bool _signedIn = false;

  bool get signedIn => _signedIn;

  Future<void> signOut() async {
    await Future<void>.delayed(const Duration(milliseconds: 200));
    //TODO Sign out.

    _signedIn = false;
    notifyListeners();
  }

  Future<bool> signIn(String username, String password) async {
    await Future<void>.delayed(const Duration(milliseconds: 200));

    //TODO Do real Sign in. Allow not any password.
    _signedIn = true;
    notifyListeners();
    return _signedIn;
  }

  @override
  bool operator ==(Object other) =>
      other is ScoresAuth && other._signedIn == _signedIn;

  @override
  int get hashCode => _signedIn.hashCode;
}

class ScoresAuthScope extends InheritedNotifier<ScoresAuth> {
  const ScoresAuthScope({
    required ScoresAuth notifier,
    required Widget child,
    Key? key,
  }) : super(key: key, notifier: notifier, child: child);

  static ScoresAuth of(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<ScoresAuthScope>()!.notifier!;
}
