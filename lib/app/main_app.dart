import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:note_hub/bloc/auth_bloc/auth_bloc.dart';
import 'package:note_hub/bloc/internet_bloc/internet_bloc.dart';
import 'package:note_hub/bloc/theme_bloc/theme_bloc.dart';
import 'package:note_hub/config/routes_manger/routes_generator.dart';

class MainApp extends StatelessWidget {
  // Make MainApp a singleton class
  const MainApp._init();

  static const MainApp _instance = MainApp._init();

  factory MainApp() => _instance;

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => InternetBloc()..add(InternetInitialEvent()),
        ),
        BlocProvider(
          create: (context) => AuthBloc(),
        ),
        BlocProvider(
          create: (BuildContext context) =>
              ThemeBloc()..add(ThemeInitialEvent()),
        )
        // BlocProvider(create: (context) => NotesBloc()..add(NotesFetched())),
      ],
      child: BlocBuilder<ThemeBloc, ThemeState>(
        builder: (context, state) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Note Hub',
            theme: state.themeData,
            initialRoute: 'splash',
            onGenerateRoute: RoutesGenerator.generateRoute,
          );
        },
      ),
    );
  }
}
