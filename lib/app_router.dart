import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:pickle_app/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:pickle_app/features/auth/presentation/pages/login_page.dart';
import 'package:pickle_app/features/auth/presentation/pages/register_page.dart';
import 'package:pickle_app/features/venue/presentation/bloc/venue_list/venue_bloc.dart';
import 'package:pickle_app/features/venue/presentation/screens/venues_list_screen.dart';

class AppRouter {
  static final _rootNavigatorKey = GlobalKey<NavigatorState>();

  static final GoRouter router = GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: '/login',
    routes: [
      GoRoute(
        path: '/login',
        builder: (context, state) => MultiBlocProvider(
          providers: [
            BlocProvider<AuthBloc>(
              // create: (context) => AuthBloc()..add(const AuthCheckRequested()),
              create: (context) => AuthBloc(),
            ),
          ],
          child: const LoginPage(),
        ),
      ),
      GoRoute(
        path: '/register',
        builder: (context, state) => MultiBlocProvider(
          providers: [BlocProvider<AuthBloc>(create: (context) => AuthBloc())],
          child: const RegisterPage(),
        ),
      ),
      GoRoute(
        path: '/venues',
        builder: (context, state) => BlocProvider(
          create: (context) => VenueBloc(),
          child: const VenuesListScreen(),
        ),
      ),
    ],
  );
}
