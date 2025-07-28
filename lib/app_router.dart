import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:get_it/get_it.dart';
import 'package:pickle_app/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:pickle_app/features/auth/presentation/bloc/auth_event.dart';
import 'package:pickle_app/features/auth/presentation/pages/login_page.dart';
import 'package:pickle_app/features/venue/presentation/bloc/venue_bloc.dart';
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
              create: (context) => AuthBloc()..add(const AuthCheckRequested()),
            ),
          ],
          child: const LoginPage(),
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
