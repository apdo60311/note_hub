import 'package:cached_network_image/cached_network_image.dart';
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:lottie/lottie.dart';
import 'package:note_hub/bloc/auth_bloc/auth_bloc.dart';
import 'package:note_hub/bloc/log_out_bloc/logout_bloc.dart';
import 'package:note_hub/bloc/theme_bloc/theme_bloc.dart';
import 'package:note_hub/config/routes_manger/routes.dart';
import 'package:note_hub/config/themes/app_themes.dart';
import 'package:note_hub/data/models/user/user_model.dart';
import 'package:note_hub/utils/media_query_extension.dart';
import 'package:note_hub/utils/shared_methods.dart';

import '../widgets/auth_buttons_column.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;

  @override
  void initState() {
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );

    Tween<double> bouncingAnimationTween = Tween(begin: 1.0, end: 0.0);

    bouncingAnimationTween.animate(
      CurvedAnimation(parent: _animationController, curve: Curves.bounceIn),
    );

    _animationController.forward();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeBloc, ThemeState>(
      builder: (context, state) {
        return Scaffold(
          body: Container(
            decoration: BoxDecoration(
              gradient: (state.themeData == lightThemeData)
                  ? scooterGradientColor()
                  : darkGradientColor(),
            ),
            padding: const EdgeInsets.only(top: 8.0),
            child: BlocListener<LogoutBloc, LogoutState>(
              listener: (context, state) {},
              child: BlocConsumer<AuthBloc, AuthState>(
                listener: (context, state) {},
                builder: (context, state) {
                  return Scaffold(
                    appBar: AppBar(
                      backgroundColor: Colors.transparent,
                      leading: leadingProfileIcon(),
                      actions: [
                        state.state == UserAuthState.authenticated
                            ? IconButton(
                                onPressed: () {
                                  context
                                      .read<LogoutBloc>()
                                      .add(LogoutRequested());
                                },
                                icon: const Icon(
                                  Icons.logout_outlined,
                                  color: Colors.white,
                                ))
                            : const SizedBox(),
                      ],
                    ),
                    body: Center(
                      child: SingleChildScrollView(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 50),
                          child: Stack(
                            clipBehavior: Clip.none,
                            children: [
                              shallawerGlassEffect(context),
                              widerGlassEffect(context),
                              AnimatedBuilder(
                                animation: _animationController,
                                builder: (BuildContext context, Widget? child) {
                                  return Transform.translate(
                                    offset: Offset(
                                        0,
                                        200 *
                                            (-_animationController.value + 1)),
                                    child: ConditionalBuilder(
                                      condition: state.state ==
                                          UserAuthState.authenticated,
                                      builder: (BuildContext context) =>
                                          UserDetailsWidget(
                                        userProfile: state.user!.userProfile,
                                        notesCount:
                                            state.user!.userProfile.notesCount,
                                      ),
                                      fallback: (BuildContext context) =>
                                          AuthButtonsColumn(
                                        onLoginClicked: () {
                                          Navigator.pushNamed(
                                              context, Routes.loginRoute);
                                        },
                                        onSignupClicked: () {
                                          Navigator.pushNamed(
                                              context, Routes.registerRoute);
                                        },
                                      ),
                                    ),
                                  );
                                },
                              ),
                              userImage(state),
                            ],
                          ),
                        ),
                      ),
                    ),
                    backgroundColor: Colors.transparent,
                  );
                },
              ),
            ),
          ),
        );
      },
    );
  }

  Padding leadingProfileIcon() {
    return Padding(
      padding: const EdgeInsets.only(left: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Profile',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
          Container(
            width: 20.0,
            height: 2.0,
            color: Colors.white,
          )
        ],
      ),
    );
  }

  Positioned shallawerGlassEffect(BuildContext context) {
    return Positioned(
      top: -15,
      left: 0,
      right: 0,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15.0),
        child: SizedBox(
          width: context.screenWith,
          height: 100,
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(15.0),
            ),
            width: double.infinity,
            height: 100,
          ),
        ),
      ),
    );
  }

  Positioned widerGlassEffect(BuildContext context) {
    return Positioned(
      top: -30,
      left: 0,
      right: 0,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 25.0),
        child: SizedBox(
          width: context.screenWith,
          height: 100,
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.1),
              borderRadius: BorderRadius.circular(15.0),
            ),
            width: double.infinity,
            height: 100,
          ),
        ),
      ),
    );
  }

  Positioned userImage(state) {
    return Positioned(
      top: -45,
      left: 0,
      right: 0,
      child: SizedBox(
        width: 100,
        height: 100,
        child: Hero(
          tag: 'user_image',
          child: Container(
            width: double.infinity,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
            ),
            clipBehavior: Clip.antiAliasWithSaveLayer,
            child: ConditionalBuilder(
              condition: state.state == UserAuthState.authenticated,
              builder: (BuildContext context) => CachedNetworkImage(
                imageUrl: state.user.userProfile.image,
                width: 100,
                height: 100,
                errorWidget: (context, e, error) => defaultImage(),
              ),
              fallback: (BuildContext context) => defaultImage(),
            ),
          ),
        ),
      ),
    );
  }

  LinearGradient scooterGradientColor() {
    return LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          HexColor("#36d1dc"),
          HexColor("#5b86e5"),
        ]);
  }
}

LinearGradient darkGradientColor() {
  return LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [Colors.black87, Colors.grey.shade900, Colors.black87]);
}

class UserDetailsWidget extends StatefulWidget {
  const UserDetailsWidget({
    super.key,
    required this.userProfile,
    required this.notesCount,
  });

  final UserProfile userProfile;
  final int notesCount;

  @override
  State<UserDetailsWidget> createState() => _UserDetailsWidgetState();
}

class _UserDetailsWidgetState extends State<UserDetailsWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _themeSwitchingAnimationController;
  bool isDark = false;

  @override
  void initState() {
    super.initState();
    _themeSwitchingAnimationController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 1500))
      ..addListener(() {
        setState(() {});
      });
    isDark = context.read<ThemeBloc>().state.themeData == darkThemeData;
    if (isDark) {
      _themeSwitchingAnimationController.forward();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10.0),
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        borderRadius: BorderRadius.circular(15.0),
      ),
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 35.0),
          const SizedBox(height: 15),
          Text(
            widget.userProfile.name,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            widget.userProfile.email,
            style: const TextStyle(
              fontSize: 13,
            ),
          ),
          const SizedBox(height: 15),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Column(
                children: [
                  const Icon(Icons.note),
                  Text(
                    widget.userProfile.notesCount.toString(),
                    style: TextStyle(
                        color: Theme.of(context).textTheme.bodySmall!.color,
                        fontWeight: FontWeight.bold),
                  )
                ],
              ),
              const SizedBox(
                width: 20,
              ),
              Column(
                children: [
                  const Icon(Icons.book),
                  Text(
                    widget.userProfile.pinnedNotesCount.toString(),
                    style: TextStyle(
                        color: Theme.of(context).textTheme.bodySmall!.color,
                        fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 15),
          ListTile(
            onTap: () {
              if (_themeSwitchingAnimationController.status ==
                  AnimationStatus.forward) {
                _themeSwitchingAnimationController.reverse();
              } else {
                _themeSwitchingAnimationController.forward();
              }
              _changeTheme(context);
            },
            title: const Text("Change Theme"),
            leading: Lottie.asset(
                'assets/animations/theme_change_animation.json',
                fit: BoxFit.fitHeight,
                repeat: false,
                controller: _themeSwitchingAnimationController),
          ),
          ListTile(
            onTap: () {
              showLicensePage(context: context);
            },
            title: const Text("License"),
            leading: const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Icon(Icons.local_police_outlined),
            ),
          ),
          ListTile(
            onTap: () {
              showAboutDialog(
                context: context,
                applicationLegalese: "Developed by Abdelrhman Moataz",
              );
            },
            title: const Text("About"),
            leading: const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              child: Icon(Icons.info_outline),
            ),
          ),
        ],
      ),
    );
  }

  void _changeTheme(BuildContext context) {
    ThemeBloc themeBloc = BlocProvider.of<ThemeBloc>(context);

    if (themeBloc.state.themeData == lightThemeData) {
      themeBloc.add(const ThemeChangeEvent(themeState: ThemeType.dark));
    } else {
      themeBloc.add(const ThemeChangeEvent(themeState: ThemeType.light));
    }
  }
}
