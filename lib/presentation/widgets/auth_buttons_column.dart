import 'package:flutter/material.dart';

class AuthButtonsColumn extends StatelessWidget {
  const AuthButtonsColumn({
    super.key,
    required this.onLoginClicked,
    required this.onSignupClicked,
  });

  final Function() onLoginClicked;
  final Function() onSignupClicked;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15.0),
      ),
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 35.0),
          const SizedBox(height: 15),
          const Text("Hello There!"),
          const SizedBox(height: 15),
          Row(
            children: [
              Expanded(
                child: FilledButton(
                  onPressed: onLoginClicked,
                  child: const Text('Login'),
                ),
              ),
              const SizedBox(width: 15.0),
              Expanded(
                child: FilledButton(
                  onPressed: onSignupClicked,
                  child: const Text('Register'),
                ),
              ),
            ],
          ),
          const SizedBox(height: 15),
        ],
      ),
    );
  }
}
