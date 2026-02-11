import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../domain/entities/user_profile.dart';
import '../../presentation/auth/bloc/auth_bloc.dart';
import '../../presentation/auth/bloc/auth_state.dart';
import '../../presentation/auth/pages/forgot_password_page.dart';
import '../../presentation/auth/pages/login_page.dart';
import '../../presentation/auth/pages/register_page.dart';
import '../../presentation/profile/pages/edit_profile_page.dart';
import '../../presentation/profile/pages/profile_details_page.dart';
import '../../presentation/profile/pages/profile_page.dart';
import '../../presentation/auth/pages/welcome_page.dart';
import '../../presentation/search/pages/profile_list_page.dart';
import '../../presentation/search/pages/search_page.dart';

class AppRouter {
  final AuthBloc authBloc;

  AppRouter(this.authBloc);

  late final GoRouter router = GoRouter(
    initialLocation: '/',
    debugLogDiagnostics: true,
    refreshListenable: GoRouterRefreshStream(authBloc.stream),
    redirect: (context, state) {
      final authState = authBloc.state;
      final isAuthenticated = authState is AuthAuthenticated;

      final isPublicRoute =
          state.uri.path == '/' ||
          state.uri.path == '/login' ||
          state.uri.path == '/register' ||
          state.uri.path == '/forgot-password';

      if (!isAuthenticated) {
        if (!isPublicRoute) {
          return '/';
        }
      } else {
        if (isPublicRoute) {
          return '/profile';
        }
      }

      return null;
    },
    routes: [
      // Auth Routes
      GoRoute(
        path: '/',
        name: 'welcome',
        builder: (context, state) => const WelcomePage(),
      ),
      GoRoute(
        path: '/login',
        name: 'login',
        builder: (context, state) => const LoginPage(),
      ),
      GoRoute(
        path: '/register',
        name: 'register',
        builder: (context, state) => const RegisterPage(),
      ),
      GoRoute(
        path: '/forgot-password',
        name: 'forgot_password',
        builder: (context, state) => const ForgotPasswordPage(),
      ),

      // Main Routes
      GoRoute(
        path: '/profile',
        name: 'profile',
        builder: (context, state) => const ProfilePage(),
        routes: [
          GoRoute(
            path: 'edit',
            name: 'edit_profile',
            builder: (context, state) {
              final profile = state.extra as UserProfile;
              return EditProfilePage(profile: profile);
            },
          ),
          GoRoute(
            path: 'details',
            name: 'profile_details',
            builder: (context, state) {
              final profile = state.extra as UserProfile;
              return ProfileDetailsPage(profile: profile);
            },
          ),
        ],
      ),
      GoRoute(
        path: '/search',
        name: 'search',
        builder: (context, state) => const SearchPage(),
        routes: [
          GoRoute(
            path: 'results',
            name: 'search_results',
            builder: (context, state) => const ProfileListPage(),
          ),
        ],
      ),
    ],
  );
}

class GoRouterRefreshStream extends ChangeNotifier {
  late final StreamSubscription<dynamic> _subscription;

  GoRouterRefreshStream(Stream<dynamic> stream) {
    notifyListeners();
    _subscription = stream.asBroadcastStream().listen(
      (dynamic _) => notifyListeners(),
    );
  }

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }
}
