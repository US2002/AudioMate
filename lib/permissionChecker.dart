import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';

class permissionChecker extends StatefulWidget {
  const permissionChecker({super.key});

  @override
  State<permissionChecker> createState() => permissionCheckerState();
}

class permissionCheckerState extends State<permissionChecker> {
  @override
  void initState() {
    super.initState();
    _checkPermissionsAndNavigate();
  }

  Future<void> _checkPermissionsAndNavigate() async {
    final prefs = await SharedPreferences.getInstance();
    final isFirstTime = prefs.getBool('isFirstTime') ?? true;

    if (isFirstTime) {
      final status = await Permission.microphone.request();
      if (status == PermissionStatus.granted) {
        await prefs.setBool('isFirstTime', false);
        _navigateToHome();
      } else {
        // Optional: Redirect to a permission page if permission is denied.
        // For now, it will exit the app.
        // Navigator.pushReplacementNamed(context, '/permission');
        // Or simply exit the app:
        Navigator.of(context).pop();
      }
    } else {
      _navigateToHome();
    }
  }

  void _navigateToHome() {
    Navigator.pushReplacementNamed(context, '/home');
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: CircularProgressIndicator()),
    );
  }
}
