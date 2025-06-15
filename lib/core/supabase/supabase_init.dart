import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseInit {
  static Future<void> supabaseInit() async {
    await Supabase.initialize(
        url: "https://brqjvmfmchyelexiinvw.supabase.co",
        anonKey:
            "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImJycWp2bWZtY2h5ZWxleGlpbnZ3Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3NDk4NjQxMzksImV4cCI6MjA2NTQ0MDEzOX0.LGIwF48jKnw8kFZA2NsJgj3ldi1WRb4sG5h7KZJavEg");
  }
}
