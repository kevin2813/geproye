import 'dart:async';

import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:geproye/util/sb.dart';

final supabase = Supabase.instance.client;

class SplashScreenPage extends StatefulWidget {
  const SplashScreenPage({super.key});

  @override
  _SplashScreenPageState createState() => _SplashScreenPageState();
}

class _SplashScreenPageState extends State<SplashScreenPage> {
  bool _redirecting = false;

  late final StreamSubscription<AuthState> _authStateSubscription;

  @override
  void initState() {
    _authStateSubscription = supabase.auth.onAuthStateChange.listen((data) {
      _redirect();
    });
    _redirect();

    SupabaseService.listen();

    super.initState();
  }

  @override
  void dispose() {
    _authStateSubscription.cancel();
    super.dispose();
  }

  Future<void> _redirect() async {
    await Future.delayed(Duration.zero);
    if (_redirecting || !mounted) {
      return;
    }

    _redirecting = true;
    final session = supabase.auth.currentSession;
    if (session != null) {
      await Navigator.of(context).pushReplacementNamed('/home');
      _redirecting = false;
    } else {
      await Navigator.of(context).pushReplacementNamed('/login');
      _redirecting = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: CircularProgressIndicator()),
    );
  }
}
