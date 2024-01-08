import 'package:flutter/material.dart';

class AdminNameProvider extends InheritedWidget {
  final String adminName;

  const AdminNameProvider({
    required this.adminName,
    required Widget child,
    Key? key,
  }) : super(key: key, child: child);

  static AdminNameProvider? of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<AdminNameProvider>();
  }

  @override
  bool updateShouldNotify(covariant AdminNameProvider oldWidget) {
    return adminName != oldWidget.adminName;
  }
}
