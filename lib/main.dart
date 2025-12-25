import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'bloc/rolefit_bloc.dart';
import 'screens/home_screen.dart';

void main() {
  runApp(const RoleFitApp());
}

class RoleFitApp extends StatelessWidget {
  const RoleFitApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'RoleFit',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: BlocProvider(
        create: (context) => RoleFitBloc(),
        child: const HomeScreen(),
      ),
    );
  }
}
