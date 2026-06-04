import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseInit {
  static Future<void> supabaseInit() async {
    await Supabase.initialize(
        url: "https://nzvficpfrpvghvajtokr.supabase.co",
        publishableKey: "sb_publishable_TXFhLk_aqXC2Q330ih5OsA_RvfTnLAQ");
  }
}
