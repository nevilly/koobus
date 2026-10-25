// RoleHome — "mlango" unaompeleka mtumiaji ukurasa unaofaa kwa role.
//
// Hii ni sehemu moja pekee inayoamua nyumbani ni ipi. Kama tutaongeza
// matron/school_admin baadaye, tunabadilisha hapa tu — splash na login
// zinabaki zikimwita RoleHome.

import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import 'package:koobus/controllers/auth_controller.dart';
import 'package:koobus/features/auth/screens/unsupported_role_screen.dart';
import 'package:koobus/features/driver/screens/driver_shell.dart';
import 'package:koobus/features/parent/screens/parent_shell.dart';
import 'package:koobus/models/user_model.dart';

class RoleHome extends StatelessWidget {
  const RoleHome({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthController>();

    switch (auth.role) {
      case UserRole.parent:
        return const ParentShell();
      case UserRole.driver:
        return const DriverShell();
      case UserRole.matron:
      case UserRole.schoolAdmin:
      case UserRole.superAdmin:
      case UserRole.unknown:
        return const UnsupportedRoleScreen();
    }
  }
}
