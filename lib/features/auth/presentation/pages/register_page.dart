import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:pickle_app/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:pickle_app/features/auth/presentation/bloc/auth_state.dart';
import 'package:pickle_app/features/auth/presentation/widgets/registration_form.dart';

class RegisterPage extends StatelessWidget {
  const RegisterPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Create Account'), elevation: 0),
      body: BlocConsumer<AuthBloc, AuthState>(
        listener: (context, state) {
          // Handle navigation on success
          if (state.status == AuthStatus.registrationSuccess) {
            // Show success message before navigation
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Account created successfully!'),
                backgroundColor: Colors.green,
              ),
            );
            // Navigation will be handled by the auth state changes
            context.go('/login');
          }
        },
        builder: (context, state) {
          return SafeArea(
            minimum: const EdgeInsets.all(16.0),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: 24.0),
                  Text(
                    'Join Pickle App',
                    style: Theme.of(context).textTheme.headlineMedium,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8.0),
                  Text(
                    'Create your account to get started',
                    style: Theme.of(context).textTheme.bodyMedium,
                    textAlign: TextAlign.center,
                  ),

                  // Error message display
                  if (state.status == AuthStatus.failure) ...[
                    const SizedBox(height: 24.0),
                    Container(
                      padding: const EdgeInsets.all(12.0),
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.errorContainer,
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      child: SelectableText.rich(
                        TextSpan(
                          text:
                              state.error ??
                              'An error occurred during registration',
                          style: TextStyle(
                            color: Theme.of(
                              context,
                            ).colorScheme.onErrorContainer,
                            fontSize: 14,
                          ),
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],

                  const SizedBox(height: 24.0),

                  // Registration Form
                  RegistrationForm(
                    onRegistrationSuccess: () {
                      // Success handling is done in the BlocListener above
                    },
                  ),

                  const SizedBox(height: 24.0),

                  // Divider
                  const Row(
                    children: [
                      Expanded(child: Divider()),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16.0),
                        child: Text('OR'),
                      ),
                      Expanded(child: Divider()),
                    ],
                  ),

                  const SizedBox(height: 24.0),

                  // Sign In Link
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text('Already have an account?'),
                      TextButton(
                        onPressed: () {
                          context.go('/login');
                        },
                        child: const Text('Sign In'),
                      ),
                    ],
                  ),

                  const SizedBox(height: 16.0),

                  // Social Sign Up Options (Placeholder)
                  // TODO: Implement social sign-up options
                  // const Text(
                  //   'Sign up with',
                  //   textAlign: TextAlign.center,
                  //   style: TextStyle(fontSize: 14),
                  // ),
                  // const SizedBox(height: 16.0),
                  // Row(
                  //   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  //   children: [
                  //     // Google, Apple, etc.
                  //   ],
                  // ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
