import 'package:supabase_flutter/supabase_flutter.dart' as supabase;

class SupabaseClient {
  static late final supabase.SupabaseClient _client;
  static late final supabase.GoTrueClient _auth;

  static supabase.SupabaseClient get client => _client;
  static supabase.GoTrueClient get auth => _auth;

  /// Initialize the Supabase client with the provided URL and anon key
  ///
  /// This should be called during app startup, before any other Supabase operations
  static Future<void> initialize({
    required String supabaseUrl,
    required String supabaseAnonKey,
  }) async {
    try {
      // Initialize the Supabase client
      await supabase.Supabase.initialize(
        url: supabaseUrl,
        anonKey: supabaseAnonKey,
      );

      // Get the client instances
      _client = supabase.Supabase.instance.client;
      _auth = _client.auth;

      print('✅ [Supabase] Client initialized successfully');
      print('🔗 [Supabase] URL: $supabaseUrl');
    } catch (e) {
      print('❌ [Supabase] Failed to initialize client: $e');
      rethrow;
    }
  }

  /// Get the current user's session
  static supabase.Session? get currentSession => _auth.currentSession;

  /// Get the current user
  static supabase.User? get currentUser => _auth.currentUser;

  /// Check if there's an active session
  static bool get isSignedIn => currentSession != null;

  /// Sign out the current user
  static Future<void> signOut() async {
    await _auth.signOut();
  }

  // Prevent instantiation
  SupabaseClient._();
}
