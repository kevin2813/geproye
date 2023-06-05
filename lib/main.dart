import 'package:flutter/material.dart';
import 'package:geproye/router_generator.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:geproye/util/sb.dart';
//import 'package:geproye/util/chat.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  await Supabase.initialize(
    url: const String.fromEnvironment('SUPABASE_API_URL')!,
    anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InZvc3lybHBnd2FwcXNueW9zZnZqIiwicm9sZSI6ImFub24iLCJpYXQiOjE2ODM4NjYxNjAsImV4cCI6MTk5OTQ0MjE2MH0.mgidX1Jyu96r4ngL_x20MFhOMMI5MALX_78DJTEFzMg',
  );

  //Chat.init();

  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    initialRoute: '/',
    onGenerateRoute: RouterNavigator.generateRoute,
    navigatorKey: SupabaseService.navKey,
  ));
}
