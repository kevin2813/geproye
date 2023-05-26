import 'dart:async';

import 'package:flutter/material.dart';
import 'package:geproye/models/iteration.dart';
import 'package:geproye/models/project.dart';
import 'package:geproye/pages/home.dart';
import 'package:geproye/pages/iteration.dart';
import 'package:geproye/pages/members.dart';
import 'package:geproye/pages/project.dart';
import 'package:geproye/pages/requirements.dart';
import 'package:geproye/pages/splash_screen.dart';
import 'package:geproye/pages/login.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

final supabase = Supabase.instance.client;


class RouterNavigator {

  static Route<dynamic> generateRoute(RouteSettings settings) {
/*     final Session? session = supabase.auth.currentSession;

    if (session == null) {
      return MaterialPageRoute<SplashScreenPage>(
         builder: (context) => const SplashScreenPage());
    } */

    switch (settings.name) {
      case '/':
        return MaterialPageRoute<SplashScreenPage>(
            builder: (context) => const SplashScreenPage());
      case '/login':
        return MaterialPageRoute<LoginPage>(
            builder: (context) => const LoginPage());
      case '/home':
        return MaterialPageRoute<HomePage>(
            builder: (context) => const HomePage());
      case '/project':
        {
          final pj = settings.arguments as Project;

          return MaterialPageRoute<ProjectPage>(
              builder: (context) => ProjectPage(project: pj));
        }
      case '/requirements':
        {
          final pj = settings.arguments as Project;

          return MaterialPageRoute<ProjectPage>(
              builder: (context) => RequirementsPage(project: pj));
        }
      case '/members':
        {
          final pj = settings.arguments as Project;

          return MaterialPageRoute<ProjectPage>(
              builder: (context) => MembersPage(project: pj));
        }
      default:
        return MaterialPageRoute<HomePage>(
            builder: (context) => const HomePage());
    }
  }
}
