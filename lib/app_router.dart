import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:pickle_app/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:pickle_app/features/auth/presentation/pages/login_page.dart';
import 'package:pickle_app/features/auth/presentation/pages/register_page.dart';
import 'package:pickle_app/features/home/presentation/pages/home_page.dart';
import 'package:pickle_app/features/venue/domain/usecases/get_venues.dart'
    show GetVenues;
import 'package:pickle_app/features/venue/presentation/bloc/venue_list/venue_bloc.dart';
import 'package:pickle_app/features/venue/presentation/bloc/venue_list/venue_cubit.dart';
import 'package:pickle_app/features/venue/presentation/screens/venues_list_screen.dart';

class AppRouter {
  static final _rootNavigatorKey = GlobalKey<NavigatorState>();

  static final GoRouter router = GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: '/',
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
        path: '/',
        builder: (context, state) => MultiBlocProvider(
          providers: [
            BlocProvider<VenueBloc>(create: (context) => VenueBloc()),
            BlocProvider<VenueListCubit>(
              create: (context) =>
                  VenueListCubit(getVenues: GetIt.instance.get<GetVenues>()),
            ),
          ],
          child: const HomePage(),
        ),
      ),
      GoRoute(
        path: '/venues',
        builder: (context, state) => MultiBlocProvider(
          providers: [
            BlocProvider<VenueBloc>(create: (context) => VenueBloc()),
            BlocProvider<VenueListCubit>(
              create: (context) =>
                  VenueListCubit(getVenues: GetIt.instance.get<GetVenues>()),
            ),
          ],
          child: const VenuesListScreen(),
        ),
      ),
    ],
  );
}
