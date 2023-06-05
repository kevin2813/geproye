import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:geproye/router_generator.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:geproye/util/sb.dart';
//import 'package:geproye/util/chat.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  await dotenv.load();
  
  await Supabase.initialize(
    url: dotenv.env['SUPABASE_API_URL']!,
    anonKey: dotenv.env['SUPABASE_API_KEY']!,
  );

  //Chat.init();

  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    initialRoute: '/',
    onGenerateRoute: RouterNavigator.generateRoute,
    navigatorKey: SupabaseService.navKey,
  ));
}
