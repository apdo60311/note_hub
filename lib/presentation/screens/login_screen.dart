import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:note_hub/bloc/login_bloc/login_bloc.dart';
import 'package:note_hub/config/routes_manger/routes.dart';
import 'package:note_hub/utils/shared_methods.dart';

import '../widgets/default_rounded_button.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
    with TickerProviderStateMixin {
  late GlobalKey<FormState> _formKey;

  late TextEditingController _usernameController;
  late TextEditingController _passwordController;

  bool _isPasswordInVisible = true;

  @override
  void initState() {
    _formKey = GlobalKey<FormState>();
    _usernameController = TextEditingController();
    _passwordController = TextEditingController();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: BlocConsumer<LoginBloc, LoginState>(
        listener: (context, state) {
          if (state is LoginFaliure) {
            ScaffoldMessenger.of(context)
                .showSnackBar(defaultSnackBar(state.message));
          } else if (state is LoginSuccesful) {
            Navigator.pushReplacementNamed(context, Routes.profileRoute);
          }
        },
        builder: (context, state) {
          return Padding(
            padding: const EdgeInsets.all(30),
            child: Center(
              child: SingleChildScrollView(
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      Image.asset('assets/images/authImage.png'),
                      const SizedBox(
                        height: 25,
                      ),
                      TextFormField(
                        controller: _usernameController,
                        keyboardType: TextInputType.emailAddress,
                        decoration: const InputDecoration(
                          labelText: 'Email Address',
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(Icons.email_outlined),
                        ),
                        validator: (value) {
                          if (RegExp(
                                  r'\b[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+.[A-Z|a-z]{2,}\b')
                              .hasMatch(value ?? '')) {
                            return null;
                          } else {
                            return 'wrong email format';
                          }
                        },
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      TextFormField(
                        controller: _passwordController,
                        keyboardType: TextInputType.visiblePassword,
                        obscureText: _isPasswordInVisible,
                        decoration: InputDecoration(
                          labelText: 'Password',
                          border: const OutlineInputBorder(),
                          prefixIcon: const Icon(Icons.lock_outline),
                          suffixIcon: IconButton(
                            onPressed: () {
                              setState(() {
                                _isPasswordInVisible = !_isPasswordInVisible;
                              });
                            },
                            icon: Icon((_isPasswordInVisible)
                                ? Icons.remove_red_eye_outlined
                                : Icons.visibility_off_outlined),
                          ),
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          TextButton(
                            onPressed: () {
                              log('Forgotted Password!');
                            },
                            child: Text(
                              'Forgot Password?',
                              style: TextStyle(
                                color: Colors.black.withOpacity(0.4),
                                fontSize: 12.0,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      DefaultRoundedButton(
                        label: 'Login',
                        onClick: () {
                          _onLoginButtonClicked(context, state);
                        },
                      ),
                      const SizedBox(
                        height: 30,
                      ),
                      const Divider(
                        color: Colors.black,
                        height: 30,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            '''Don't have an account? ''',
                            style: TextStyle(
                              color: Colors.black.withOpacity(0.5),
                              fontSize: 16.0,
                            ),
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.pushReplacementNamed(
                                  context, Routes.registerRoute);
                            },
                            child: const Text('Register Now'),
                          )
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  void _onLoginButtonClicked(BuildContext context, LoginState state) {
    if (_formKey.currentState!.validate()) {
      context.read<LoginBloc>().add(LoginRequested(
          username: _usernameController.text,
          password: _passwordController.text));
    }
  }
}
