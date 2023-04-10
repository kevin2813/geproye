import 'package:flutter/material.dart';
import 'package:pmanager/router_generator.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: 'https://eaitbimlcshobgdjzttc.supabase.co',
    anonKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImVhaXRiaW1sY3Nob2JnZGp6dHRjIiwicm9sZSI6ImFub24iLCJpYXQiOjE2Nzk5NjExNTksImV4cCI6MTk5NTUzNzE1OX0.rk_9XJgZ1x3oaEfKJs8pmb3tnlrMxByFDfG8EGUMXOI',
  );

  runApp(const MaterialApp(
    debugShowCheckedModeBanner: false,
    initialRoute: '/',
    onGenerateRoute: RouterNavigator.generateRoute,
  ));
}
