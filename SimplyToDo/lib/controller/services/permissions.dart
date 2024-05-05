// import 'package:shared_preferences/shared_preferences.dart';

// class PermissionManager {
//   static const String _askedForPermissionKey = 'notificationPermission';

//   Future<bool> shouldAskForPermission() async {
//     final SharedPreferences prefs = await SharedPreferences.getInstance();
//     return prefs.getBool(_askedForPermissionKey) ?? true;
//   }

//   Future<void> markPermissionAsAsked(bool granted) async {
//     final SharedPreferences prefs = await SharedPreferences.getInstance();
//     await prefs.setBool(_askedForPermissionKey, granted);
//   }
// }
