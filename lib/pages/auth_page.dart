import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:test_firebase_chat_app2/app_state.dart';
import 'package:test_firebase_chat_app2/utils/utils.dart';

final _formKey = GlobalKey<FormState>();

class AuthPage extends StatefulWidget {
  const AuthPage({super.key});

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  final usernameFieldController = TextEditingController();
  final emailFieldController = TextEditingController();

  final pwdFieldController = TextEditingController();

  bool _isLogin = true;
  // bool _isLoading = false;
  @override
  void dispose() {
    // TODO: implement dispose
    usernameFieldController.dispose();
    emailFieldController.dispose();
    pwdFieldController.dispose();
    super.dispose();
  }

  void handleLogin() async {
    if (_formKey.currentState!.validate()) {
      if (_isLogin) {
        signUserIn();
      } else {
        signUserUp();
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Invalid Input"),
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  void signUserIn() async {
    User? currentUser;

    // showDialog(
    //   context: context,
    //   builder: (context) => const Center(
    //     child: CircularProgressIndicator(),
    //   ),
    // );

    try {
      var auth = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailFieldController.text.trim(),
        password: pwdFieldController.text.trim(),
      );

      currentUser = auth.user;
      if (currentUser != null) {
        addToPreferences(currentUser);
      }
      // popLoadingCircle();
    } on FirebaseAuthException catch (e) {
      // popLoadingCircle();

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Error occurred: ${e.code}"),
          duration: const Duration(seconds: 2),
        ),
      );
    }
  }

  void addToPreferences(User user) async {
    sharedPreferences = await SharedPreferences.getInstance();
    var userInfo = await FirebaseFirestore.instance
        .collection("users")
        .doc(user.uid)
        .get();
    await sharedPreferences!.setString("uid", user.uid);
    await sharedPreferences!
        .setString("username", userInfo.data()!["username"]);
  }

  void signUserUp() async {
    // setState(() {
    //   _isLoading = true;
    // });
    // showDialog(
    //   context: context,
    //   builder: (context) => const Center(
    //     child: CircularProgressIndicator(),
    //   ),
    // );
    User? currentUser;

    await FirebaseAuth.instance
        .createUserWithEmailAndPassword(
            email: emailFieldController.text.trim(),
            password: pwdFieldController.text.trim())
        .then(
      (auth) {
        currentUser = auth.user;
      },
    ).catchError(
      (error) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Error occurred: $error"),
            duration: const Duration(seconds: 2),
          ),
        );
      },
    );

    if (currentUser != null) {
      saveUserInformation(currentUser!);
      // await currentUser?.sendEmailVerification();
    }
  }

  void popLoadingCircle() => context.pop();

  void saveUserInformation(User currentUser) async {
    // Save info to firestore
    FirebaseFirestore.instance.collection("users").doc(currentUser.uid).set({
      "uid": currentUser.uid,
      "email": currentUser.email,
      "username": usernameFieldController.text.trim(),
    });
    // save info locally
    sharedPreferences = await SharedPreferences.getInstance();
    await sharedPreferences!.setString("uid", currentUser.uid);
    await sharedPreferences!
        .setString("uid", usernameFieldController.text.trim());
    goToHomePage();
  }

  void goToHomePage() => GoRouter.of(context).go('/');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Center(
            child: Column(
              children: [
                addHeight(40),
                _isLogin
                    ? const Text("Welcome Back", style: TextStyle(fontSize: 28))
                    : const Text("New? Sign In Below",
                        style: TextStyle(fontSize: 28)),
                addHeight(40),
                Container(
                  decoration: ShapeDecoration(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    color: Colors.grey.shade300,
                  ),
                  padding: const EdgeInsets.all(26),
                  width: 300,
                  // height: 200,
                  child: Form(
                    // autovalidateMode: AutovalidateMode.onUserInteraction,
                    key: _formKey,
                    child: Column(
                      children: [
                        // Username field
                        !_isLogin
                            ? ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: TextFormField(
                                  validator: (value) {
                                    if (value!.isEmpty) {
                                      return "Username must not be empty";
                                    }
                                    if (value.length < 3) {
                                      return "User too short";
                                    }
                                    return null;
                                  },
                                  textInputAction: TextInputAction.next,
                                  controller: usernameFieldController,
                                  decoration: const InputDecoration(
                                      label: Text("Username"),
                                      border: InputBorder.none,
                                      filled: true,
                                      fillColor: Colors.white),
                                ),
                              )
                            : const SizedBox(
                                height: 0,
                              ),
                        addHeight(20),
                        // Email field
                        ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: TextFormField(
                            validator: (value) =>
                                EmailValidator.validate(value!)
                                    ? null
                                    : "Please enter a valid email",
                            textInputAction: TextInputAction.next,
                            controller: emailFieldController,
                            decoration: const InputDecoration(
                                label: Text("Email Address"),
                                border: InputBorder.none,
                                filled: true,
                                fillColor: Colors.white),
                          ),
                        ),
                        addHeight(20),
                        // Password field
                        ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: TextFormField(
                            validator: (value) {
                              if (value!.isEmpty) {
                                return "Password must not be empty";
                              }
                              if (value.length < 8) {
                                return "Password too short";
                              }
                              if (value.length > 64) {
                                return "Password too long";
                              }
                              return null;
                            },
                            textInputAction: TextInputAction.done,
                            controller: pwdFieldController,
                            decoration: const InputDecoration(
                                label: Text("Password"),
                                border: InputBorder.none,
                                filled: true,
                                fillColor: Colors.white),
                          ),
                        ),
                        addHeight(20),
                        ElevatedButton(
                          onPressed: handleLogin,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 12, horizontal: 18),
                            child: Text(
                              _isLogin ? "LOGIN" : "SIGN UP",
                              style: const TextStyle(
                                fontSize: 16,
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 2,
                              ),
                            ),
                          ),
                        ),
                        addHeight(20),

                        GestureDetector(
                          onTap: () {
                            setState(() {
                              _isLogin = !_isLogin;
                            });
                            emailFieldController.clear();
                            pwdFieldController.clear();
                          },
                          child: RichText(
                            text: TextSpan(
                              style: const TextStyle(
                                fontSize: 16,
                                color: Colors.black87,
                              ),
                              text: _isLogin
                                  ? "Have an account? "
                                  : "Dont have an account? ",
                              children: [
                                TextSpan(
                                  text: _isLogin ? "Sign Up" : "Login",
                                  style: const TextStyle(
                                    decoration: TextDecoration.underline,
                                    color: Colors.black54,
                                  ),
                                )
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
