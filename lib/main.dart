import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'rounded_button.dart';
import 'home.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Pusher',
      home: Login(), // This login Page
    );
  }
}

// Login Page Starts Here
class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  String userName = 'Me'; // Username is Initialised
  final userNameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              textAlign: TextAlign.center,
              controller: userNameController,
              onChanged: (value) {
                userName = value;
              },
              decoration: const InputDecoration(
                hintText: 'Type Username',
                contentPadding:
                    EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(32.0)),
                ),
              ),
            ),
            RoundedButton(
                colour: Colors.lightBlueAccent,
                buttonTitle: 'Login',
                onPress: () {
                  if (kDebugMode) {
                    print('Username: $userName');
                  }
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => Home(username: userName)),
                    // username is sent to Wallet Home Page
                  );
                  userNameController.clear();
                }),
          ],
        ),
      ),
    );
  }
}
