import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:watch_hub/models/user_profile.dart';
import 'package:watch_hub/pages/create_user_detail.dart';
import 'package:watch_hub/routes/app_routes.dart';
import 'package:watch_hub/services/authenticate.dart';
import 'package:watch_hub/services/user_profile_dao.dart';
import 'package:watch_hub/services/validations.dart';
import 'package:watch_hub/widgets/beveled_button.dart';
import 'package:watch_hub/widgets/body_landscape.dart';
import 'package:watch_hub/widgets/message_box.dart';
import 'package:watch_hub/widgets/video_template.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});
  static const routeName = "/LoginPage";

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final textFieldFocusNode = FocusNode();
  final _formKey = GlobalKey<FormState>();
  late bool _obscured;
  bool _isProcessing = false;

  String profileStatus = "de-activate";
  UsersProfile? puser;

  String? email;
  String? password;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _obscured = true;

    final user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      Future.delayed(Duration.zero, () {


        Navigator.pushReplacementNamed(context, PageRoutes.homePage);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Login Page',
          style: Theme.of(context).textTheme.titleMedium,
        ),
        automaticallyImplyLeading: false,
      ),
      body: OrientationBuilder(builder: (context, orientation) {
        if (orientation == Orientation.portrait) {
          return getBoyPortrait();
        } else {
          return const BodyLandscape();
        }
      }),
    );
  }

  Widget getBoyPortrait() {
    return VideoTemplate(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Card(
              elevation: 2,
              color: Colors.black54,
              child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Center(child: fillBody())),
            )
          ],
        ),
      ),
      videoPath: 'assets/media/back_video/videoplayback.mp4',
    );
  }

  Widget fillBody() {
    return SafeArea(
        child: Form(
      key: _formKey,
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            const CircleAvatar(
              backgroundColor: Color.fromARGB(255, 36, 33, 8),
              radius: 80,
              child: CircleAvatar(
                radius: 70,
                backgroundColor: Colors.grey,
                backgroundImage: AssetImage("assets/media/avator/user2.png"),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            TextFormField(
              style: Theme.of(context).textTheme.bodyMedium,
              maxLength: 30,
              keyboardType: TextInputType.emailAddress,
              decoration: const InputDecoration(
                  labelText: "User Email",
                  hintText: "Enter User Email",
                  prefixIcon: Icon(Icons.email, color: Colors.orange)),
              validator: validateEmail,
              onSaved: (value) {
                setState(() {
                  email = value;
                });
              },
            ),
            const SizedBox(
              height: 10,
            ),
            TextFormField(
              obscureText: _obscured,
              maxLength: 8,
              keyboardType: TextInputType.number,
              style: Theme.of(context).textTheme.bodyMedium,
              decoration: InputDecoration(
                labelText: "User Password",
                hintText: "Enter User Password",
                prefixIcon: const Icon(
                  Icons.password,
                  color: Colors.orange,
                ),
                suffixIcon: Padding(
                  padding: const EdgeInsets.fromLTRB(0, 0, 1, 0),
                  child: GestureDetector(
                    onTap: _toggleObscured,
                    child: Icon(
                      _obscured
                          ? Icons.visibility_rounded
                          : Icons.visibility_off_rounded,
                      color: Colors.orange,
                    ),
                  ),
                ),
              ),
              validator: validatePass,
              onSaved: (value) {
                setState(() {
                  password = value;
                });
              },
            ),
            const SizedBox(
              height: 10,
            ),
            !_isProcessing
                ? SizedBox(
                    width: MediaQuery.of(context).size.width,
                    child: BeveledButton(
                      title: "Login",
                      onTap: () async {
                        await loginUser();
                      },
                    ),
                  )
                : SizedBox(
                    width: MediaQuery.of(context).size.width,
                    child: const Center(
                      child: CircularProgressIndicator(
                        strokeWidth: 10,
                        backgroundColor: Colors.greenAccent,
                        valueColor:
                            AlwaysStoppedAnimation<Color>(Colors.yellow),
                      ),
                    ),
                  ),
            const SizedBox(
              height: 10,
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width,
              child: BeveledButton(
                title: "Register",
                onTap: () {
                  Navigator.pushReplacementNamed(
                      context, PageRoutes.registerPage);
                },
              ),
            ),
          ],
        ),
      ),
    ));
  }

  Future<void> loginUser() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      //print("Email: ${email.toString()}, Password: ${password.toString()}");
      log("Email: ${email.toString()}, Password: ${password.toString()}");
      setState(() {
        _isProcessing = true;
      });
      await Authentication()
          .signIn(email: email.toString(), password: password.toString())
          .then((value) async {
        if (value == null) {
          //ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Success")));
          //Navigator.pushReplacementNamed(context, PageRoutes.homePage);
          final user = FirebaseAuth.instance.currentUser;

          String Status = await searchUserByEmail(user!.email.toString());
          setState(() {
            profileStatus = Status;
          });

          if (profileStatus == "registration detail missing") {
            Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: (context) => CreateUserDetail(
                          email: user.email.toString(),
                        )));
          }

          profileVerification(context);
          navigateToHome(context);
        } else {
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text(value)));
        }
      });
      await Future.delayed(const Duration(seconds: 2), () {});
      setState(() {
        _isProcessing = false;
      });
    }
  }

  void _toggleObscured() {
    setState(() {
      _obscured = !_obscured;
      if (textFieldFocusNode.hasPrimaryFocus) {
        return; // If focus is on text field, dont unfocus
      }
      textFieldFocusNode.canRequestFocus =
          false; // Prevents focus if tap on eye
    });
  }

  Future<String> searchUserByEmail(String email) async {
    puser = await UserProfileDao().searchByEmail(email);
    if (puser != null) {
      //print('User found: ${puser?.displayName}, Role: ${puser?.type}');
      log('User found: ${puser?.displayName}, Role: ${puser?.type}');
      //print('User Status ${puser?.status}');
      log('User Status ${puser?.status}');
      return puser!.status; // Profile found
    } else {
      //print('User not found');
      log('User not found');

      return "registration detail missing"; // Profile not found
    }
  }

  void profileVerification(BuildContext context) {
    //print("profile verification $profileStatus");
    log("profile verification $profileStatus");
    if (profileStatus == "de-activated") {
      messageBox(
          context: context,
          title: "failure",
          message: "your profile is de-activated contact admin");
    }
  }

  void navigateToHome(BuildContext context) {
    if (puser != null) {
      String? role = puser?.type;
      //print("role - $role");
      log("role - $role");
      switch (role) {
        case "admin":
          Navigator.pushReplacementNamed(context, PageRoutes.adminHomePage);
          break;
        case "user":
          Navigator.pushReplacementNamed(context, PageRoutes.homePage);
          break;
        default:
      }
    }
  }
}
