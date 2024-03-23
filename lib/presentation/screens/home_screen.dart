import 'package:cached_network_image/cached_network_image.dart';
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart';
import 'package:note_hub/bloc/auth_bloc/auth_bloc.dart';
import 'package:note_hub/bloc/internet_bloc/internet_bloc.dart';
import 'package:note_hub/config/constants/assets_constants.dart';
import 'package:note_hub/presentation/widgets/notes_grid.dart';
import 'package:note_hub/utils/shared_methods.dart';

import '../../bloc/notes_bloc/notes_bloc.dart';
import '../../config/routes_manger/routes.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  late AnimationController _fabAnimationController;

  late Animation<Offset> _fabAnimation;

  @override
  void initState() {
    _fabAnimationHandler();
    super.initState();
  }

  void _fabAnimationHandler() {
    _fabAnimationController = AnimationController(vsync: this);
    _fabAnimationController.duration = const Duration(milliseconds: 1000);

    _fabAnimation =
        Tween<Offset>(begin: const Offset(2, 0), end: const Offset(0, 0))
            .animate(_fabAnimationController);
    _fabAnimationController.forward();
    _fabAnimationController.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _fabAnimationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthBloc, AuthState>(
      listener: (context, state) {
        context.read<NotesBloc>().add(NotesFetched());
      },
      listenWhen: (prevState, currState) {
        return (prevState.state == UserAuthState.authenticated &&
                currState.state == UserAuthState.unauthenticated) ||
            (prevState.state == UserAuthState.unauthenticated &&
                currState.state == UserAuthState.authenticated);
      },
      builder: (context, authState) {
        return BlocConsumer<InternetBloc, InternetState>(
          listener: (context, state) {
            if (state is InternetNotConnectedState) {
              ScaffoldMessenger.of(context)
                  .showSnackBar(defaultSnackBar(state.message));
            }
          },
          builder: (BuildContext context, InternetState state) => Scaffold(
            appBar: _buildAppBar(authState),
            body: BlocConsumer<NotesBloc, NotesState>(
              builder: (context, state) {
                return _buildHomeScreen();
              },
              listener: (BuildContext context, NotesState state) {},
            ),
            floatingActionButton: _addNoteFloatingActionButton(context),
            floatingActionButtonAnimator: FloatingActionButtonAnimator.scaling,
            floatingActionButtonLocation:
                FloatingActionButtonLocation.endDocked,
            extendBody: true,
            bottomNavigationBar: BottomAppBar(
              shape: const CircularNotchedRectangle(),
              height: 60,
              child: Row(
                children: [
                  const Spacer(flex: 1),
                  IconButton(
                      onPressed: () {
                        Navigator.pushNamed(context, Routes.searchRoute);
                      },
                      icon: const Icon(Icons.search)),
                  const Spacer(flex: 1),
                  IconButton(
                    onPressed: () {
                      Navigator.pushNamed(context, Routes.savedNotesRoute);
                    },
                    icon: const Icon(Icons.book),
                  ),
                  const Spacer(flex: 3),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  SlideTransition _addNoteFloatingActionButton(BuildContext context) {
    return SlideTransition(
      position: _fabAnimation,
      child: InkWell(
        borderRadius: BorderRadius.circular(50),
        onTap: () {
          Navigator.pushNamed(context, '/create_note').then((isChangeOccurred) {
            if (isChangeOccurred != null && isChangeOccurred as bool) {
              if (context.mounted) {
                context.read<NotesBloc>().add(NotesFetched());
              }
            }
          });
        },
        child: Lottie.asset('assets/animations/addButtonAnimation.json',
            fit: BoxFit.cover, width: 85, height: 85),
      ),
    );
  }

  Widget _buildHomeScreen() {
    return const NotesGrid();
  }

  AppBar _buildAppBar(AuthState state) {
    return AppBar(
      title: const Text(
        "Notes",
        style: TextStyle(fontWeight: FontWeight.w600, fontSize: 25),
      ),
      actions: [
        GestureDetector(
          // borderRadius: BorderRadius.circular(20.0),
          onTap: () {
            Navigator.pushNamed(context, Routes.profileRoute);
          },
          child: Hero(
            tag: 'user_image',
            child: Container(
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
              ),
              clipBehavior: Clip.antiAliasWithSaveLayer,
              child: ConditionalBuilder(
                condition: state.state == UserAuthState.authenticated,
                builder: (BuildContext context) => CachedNetworkImage(
                  imageUrl: state.user!.userProfile.image,
                  width: 45,
                  height: 45,
                  errorWidget: (context, e, error) => defaultImage(),
                ),
                fallback: (BuildContext context) => ConditionalBuilder(
                  condition: state.state == UserAuthState.unauthenticated,
                  builder: (BuildContext context) => Image.asset(
                    defaultProfileImagePath,
                    width: 45,
                    height: 45,
                    errorBuilder: (context, e, error) => Container(
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                        ),
                        padding: const EdgeInsets.all(8.0),
                        child: const Icon(Icons.person)),
                  ),
                  fallback: (BuildContext context) =>
                      Lottie.asset('assets/animations/loading_animation.json'),
                ),
              ),
            ),
          ),
        ),
        const SizedBox(width: 10),
      ],
    );
  }
}
