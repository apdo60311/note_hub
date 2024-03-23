import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:note_hub/bloc/log_out_bloc/logout_bloc.dart';
import 'package:note_hub/bloc/login_bloc/login_bloc.dart';
import 'package:note_hub/bloc/note_bloc/note_bloc.dart';
import 'package:note_hub/bloc/notes_bloc/notes_bloc.dart';
import 'package:note_hub/bloc/register_bloc/register_bloc.dart';
import 'package:note_hub/bloc/saved_notes_bloc/saved_notes_bloc.dart';
import 'package:note_hub/bloc/search_bloc/search_bloc.dart';
import 'package:note_hub/config/routes_manger/routes.dart';
import 'package:note_hub/config/routes_manger/routes_transition.dart';
import 'package:note_hub/data/models/note/note.dart';
import 'package:note_hub/data/repositories/notes_repos/online_notes_repo.dart';
import 'package:note_hub/presentation/screens/error_screen.dart';
import 'package:note_hub/presentation/screens/home_screen.dart';
import 'package:note_hub/presentation/screens/login_screen.dart';
import 'package:note_hub/presentation/screens/note_screen.dart';
import 'package:note_hub/presentation/screens/register_screen.dart';
import 'package:note_hub/presentation/screens/saved_notes_screen.dart';
import 'package:note_hub/presentation/screens/search_screen.dart';
import 'package:note_hub/presentation/screens/splash_screen.dart';
import 'package:note_hub/presentation/screens/user_screen.dart';

class RoutesGenerator {
  static final _noteBloc = NoteBloc(OnlineNotesRepository());
  static final _notesBloc = NotesBloc(OnlineNotesRepository())
    ..add(NotesFetched());

  // static final _authBloc = AuthBloc()..add(AuthPrepare());
  static final _logoutBloc = LogoutBloc();

  static Route<dynamic> generateRoute(RouteSettings settings) {
    // Getting arguments passed in while calling Navigator.pushNamed
    final args = settings.arguments;

    switch (settings.name) {
      case Routes.splashRoute:
        return AnimatedTransitionRoute(page: const SplashScreen());
      case Routes.initialRoute:
        return AnimatedTransitionRoute(
            page: BlocProvider.value(
          value: _noteBloc,
          child:
              BlocProvider.value(value: _notesBloc, child: const HomeScreen()),
        ));
      case Routes.createNote:
        return AnimatedTransitionRoute(
            page: BlocProvider.value(
          value: _noteBloc,
          child: NoteScreen(),
        ));
      case Routes.noteRoute:
        return AnimatedTransitionRoute(
            page: BlocProvider.value(
          value: _noteBloc,
          child: NoteScreen(
            note: args as Note,
          ),
        ));
      case Routes.profileRoute:
        return AnimatedTransitionRoute(
            page: MultiBlocProvider(
          providers: [
            BlocProvider.value(
              value: _logoutBloc,
            ),
          ],
          child: const ProfileScreen(),
        ));
      case Routes.loginRoute:
        return AnimatedTransitionRoute(
            page: BlocProvider(
          create: (context) => LoginBloc(),
          child: const LoginScreen(),
        ));
      case Routes.registerRoute:
        return AnimatedTransitionRoute(
            page: BlocProvider(
          create: (context) => RegisterBloc(),
          child: const RegisterScreen(),
        ));
      case Routes.searchRoute:
        return AnimatedTransitionRoute(
            page: BlocProvider(
          create: (context) => SearchBloc(OnlineNotesRepository()),
          child: const SearchScreen(),
        ));
      case Routes.savedNotesRoute:
        return AnimatedTransitionRoute(
            page: BlocProvider(
          create: (context) => SavedNotesBloc(OnlineNotesRepository()),
          child: const SavedNotesScreen(),
        ));
      default:
        return _errorRoute(args.toString());
    }
  }

  static Route<dynamic> _errorRoute(String message) {
    return MaterialPageRoute(builder: (_) {
      return ErrorScreen(
        message: message,
      );
    });
  }
}
