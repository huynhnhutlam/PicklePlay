import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:pickle_app/app_router.dart';
import 'package:pickle_app/core/di/injection.dart';
import 'package:pickle_app/core/network/supabase_client.dart';
import 'package:pickle_app/firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  configureDependencies();
  try {
    // Load environment variables
    print('Loading environment variables...');
    await dotenv.load(fileName: ".env");

    final supabaseUrl = dotenv.env['SUPABASE_URL'] ?? '';
    final supabaseAnonKey = dotenv.env['SUPABASE_ANON_KEY'] ?? '';

    print('Supabase URL: $supabaseUrl');
    print(
      'Supabase Anon Key: ${supabaseAnonKey.isNotEmpty ? '***${supabaseAnonKey.substring(supabaseAnonKey.length - 4)}' : 'NOT FOUND'}',
    );

    if (supabaseUrl.isEmpty || supabaseAnonKey.isEmpty) {
      throw Exception('Missing Supabase configuration in .env file');
    }

    // Initialize Supabase client
    await SupabaseClient.initialize(
      supabaseUrl: supabaseUrl,
      supabaseAnonKey: supabaseAnonKey,
    );
  } catch (e, stackTrace) {
    print('❌ Error initializing app: $e');
    print('📜 Stack trace: $stackTrace');
    rethrow;
  }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Pickle App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
        useMaterial3: true,
      ),
      routerConfig: AppRouter.router,
      debugShowCheckedModeBanner: false,
    );
  }
}
