import 'package:eduction_app/core/common/app/providers/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../src/auth/domain/entites/local_user.dart';

extension ContextExt on BuildContext {
  ThemeData get theme => Theme.of(this);
  // instead of Theme.of(context) -> context.theme

  MediaQueryData get mediaQuery => MediaQuery.of(this);

  Size get size => mediaQuery.size;
  double get width => size.width;
  double get height => size.height;

  UserProvider get userProvider => read<UserProvider>();
  LocalUser? get currentUser => userProvider.user;
}
