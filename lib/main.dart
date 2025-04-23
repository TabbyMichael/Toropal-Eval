import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart'; // Import Bloc
import 'package:toropal_clone/app_theme.dart';
import 'package:toropal_clone/bloc/increment_bloc.dart'; // Import Bloc
import 'screens/splash_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  // Remove ProviderScope
  runApp(const MyApp());
}

// Change from ConsumerWidget to StatelessWidget
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Remove isDarkMode logic from Riverpod

    // Wrap with BlocProvider
    return BlocProvider(
      create: (context) => IncrementBloc(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Increment App (BLoC)', // Update title
        theme: AppTheme.lightTheme(),
        darkTheme: AppTheme.darkTheme(),
        // Use system theme mode or a fixed one if needed
        themeMode: ThemeMode.system, // Or ThemeMode.light / ThemeMode.dark
        home: const SplashScreen(),
      ),
    );
  }
}
