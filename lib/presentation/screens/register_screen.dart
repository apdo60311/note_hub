import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:note_hub/bloc/register_bloc/register_bloc.dart';
import 'package:note_hub/config/routes_manger/routes.dart';
import 'package:note_hub/presentation/screens/image_picker.dart';
import 'package:note_hub/utils/image_picker.dart';
import 'package:note_hub/utils/shared_methods.dart';

import '../../data/models/user/user_model.dart';
import '../widgets/default_rounded_button.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  State<RegisterScreen> createState() => RegisterScreenState();
}

class RegisterScreenState extends State<RegisterScreen>
    with TickerProviderStateMixin {
  late GlobalKey<FormState> _formKey;

  late TextEditingController _nameController;
  late TextEditingController _emailController;
  late TextEditingController _passwordController;

  final ImagePickerHandler _imagePickerHandler = ImagePickerHandler();

  bool _isPasswordInVisible = true;

  @override
  void initState() {
    _formKey = GlobalKey<FormState>();
    _nameController = TextEditingController();
    _emailController = TextEditingController();
    _passwordController = TextEditingController();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: BlocConsumer<RegisterBloc, RegisterState>(
        listener: (context, state) {
          if (state is RegisterFailure) {
            ScaffoldMessenger.of(context)
                .showSnackBar(defaultSnackBar(state.message));
          } else if (state is RegisterSuccessful) {
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
                      StatefulBuilder(builder: (BuildContext context,
                          void Function(void Function()) setState) {
                        return InkWell(
                          onTap: () {
                            showModalBottomSheet(
                              context: context,
                              builder: (BuildContext context) =>
                                  ImagePickerMethodScreen(
                                imagePickerHandler: _imagePickerHandler,
                              ),
                            ).whenComplete(() => setState(() {}));
                          },
                          child: ConditionalBuilder(
                            condition: _imagePickerHandler.pickedFiles.isEmpty,
                            builder: (BuildContext context) => Container(
                                decoration: BoxDecoration(
                                  color: Theme.of(context).primaryColorLight,
                                  shape: BoxShape.circle,
                                ),
                                child: _personIcon(context)),
                            fallback: (BuildContext context) => Container(
                              width: 120,
                              height: 120,
                              clipBehavior: Clip.hardEdge,
                              decoration:
                                  const BoxDecoration(shape: BoxShape.circle),
                              child: Image.file(
                                  _imagePickerHandler.pickedFiles.first),
                            ),
                          ),
                        );
                      }),
                      const SizedBox(
                        height: 25,
                      ),
                      TextFormField(
                        controller: _nameController,
                        keyboardType: TextInputType.emailAddress,
                        decoration: const InputDecoration(
                          labelText: 'Name ',
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(Icons.email_outlined),
                        ),
                        validator: (value) {
                          if (value!.length > 3) {
                            return null;
                          } else {
                            return 'wrong email format';
                          }
                        },
                      ),
                      const SizedBox(
                        height: 25,
                      ),
                      TextFormField(
                        controller: _emailController,
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
                      const SizedBox(
                        height: 15,
                      ),
                      DefaultRoundedButton(
                        label: 'Sign up',
                        onClick: () {
                          _onRegisterButtonClicked(context, state);
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
                            '''Registered Already? ''',
                            style: TextStyle(
                              color: Colors.black.withOpacity(0.5),
                              fontSize: 16.0,
                            ),
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.pushReplacementNamed(
                                  context, Routes.loginRoute);
                            },
                            child: const Text('Login'),
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

  Container _personIcon(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).primaryColorLight,
        shape: BoxShape.circle,
      ),
      padding: const EdgeInsets.all(25.0),
      child: const Icon(
        Icons.person,
        size: 45,
        color: Colors.black54,
      ),
    );
  }

  void _onRegisterButtonClicked(BuildContext context, RegisterState state) {
    if (_formKey.currentState!.validate()) {
      context.read<RegisterBloc>().add(
            RegisterRequested(
              user: User(
                id: '0',
                name: _nameController.text,
                email: _emailController.text,
                image: '',
                notesCount: 0,
                pinnedNotesCount: 0,
              ),
              password: _passwordController.text,
              imageFile: (_imagePickerHandler.pickedFiles.isNotEmpty)
                  ? _imagePickerHandler.pickedFiles.first
                  : null,
            ),
          );
    }
  }
}
