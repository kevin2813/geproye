import 'package:flutter/material.dart';
import 'package:pmanager/models/project.dart';
import 'package:pmanager/pages/home.dart';
import 'package:pmanager/pages/members.dart';
import 'package:pmanager/pages/project.dart';
import 'package:pmanager/pages/requirements.dart';

class RouterNavigator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case '/':
        return MaterialPageRoute<HomePage>(
            builder: (context) => const HomePage());
      case '/project':
        {
          final pj = settings.arguments as Project;

          return MaterialPageRoute<ProjectPage>(
              builder: (context) => ProjectPage(project: pj));
        }
      /* case '/activities':
        {
          final pj = settings.arguments as Project;

          return MaterialPageRoute<ProjectPage>(
              builder: (context) => ActivitiesPage(project: pj));
        } */
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
