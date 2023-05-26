
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseService {
  static final GlobalKey<NavigatorState> navKey = GlobalKey<NavigatorState>();
  static late final SupabaseClient supabase;
  static late final StreamSubscription<AuthState> _authStateSubscription;
  static void listen() {
    supabase = Supabase.instance.client;
    _authStateSubscription = supabase.auth.onAuthStateChange.listen((data) {
      if(data.event == AuthChangeEvent.signedOut){
        Navigator.of(navKey.currentState!.context).pushReplacementNamed('/');
      }
    });
  }
}