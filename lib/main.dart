import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart'; // Import Bloc
import 'package:toropal_clone/app_theme.dart';
import 'package:toropal_clone/bloc/increment_bloc.dart'; // Import Bloc
import 'screens/splash_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => IncrementBloc(),
      child: BlocBuilder<IncrementBloc, IncrementState>(
        buildWhen:
            (previous, current) => previous.themeMode != current.themeMode,
        builder: (context, state) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Increment App (BLoC)',
            theme: AppTheme.lightTheme(),
            darkTheme: AppTheme.darkTheme(),
            themeMode: state.themeMode,
            home: const SplashScreen(),
          );
        },
      ),
    );
  }
}
