import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:watch_hub/pages/create_user_detail.dart';
import 'package:watch_hub/routes/app_routes.dart';
import 'package:watch_hub/services/authenticate.dart';
import 'package:watch_hub/services/validations.dart';
import 'package:watch_hub/widgets/beveled_button.dart';
import 'package:watch_hub/widgets/body_landscape.dart';
import 'package:watch_hub/widgets/video_template.dart';


class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});
  static const routeName = "/RegisterPage";

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final textFieldFocusNode = FocusNode();
  final _formKey = GlobalKey<FormState>();
  late bool _obscured;
  bool _isProcessing = false;

  String? email;
  String? password;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _obscured = true;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
        title: Text(
        'Register Page',
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
    return VideoTemplate(body: fillBody(),videoPath: 'assets/media/back_video/videoplayback.mp4',);
  }

  Widget fillBody() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Card(
            elevation: 2,
            color: Color(0xFF003C40).withOpacity(0.3),
            child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Center(child: SafeArea(
                    child: Form(
                      key: _formKey,
                      child: Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Column(
                          mainAxisSize: MainAxisSize.max,
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: <Widget>[
                            const CircleAvatar(
                              backgroundColor: Colors.yellow,
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
                                prefixIcon:const Icon(
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
                                title: "Register User",
                                onTap: ()async{
                                  await registerUser();
                                },
                              ),
                            ) : SizedBox(
                              width: MediaQuery.of(context).size.width,
                              child: const Center(
                                child:  CircularProgressIndicator(
                                  strokeWidth: 10,
                                  backgroundColor: Colors.greenAccent,
                                  valueColor: AlwaysStoppedAnimation<Color>(Colors.yellow),
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            SizedBox(
                              width: MediaQuery.of(context).size.width,
                              child: BeveledButton(
                                title: "Login User",
                                onTap: () {
                                  Navigator.pushReplacementNamed(context, PageRoutes.loginPage);
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    )))),
          )
        ],
      ),
    );
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

  Future<void> registerUser() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      //print("Email: ${email.toString()}, Password: ${password.toString()}");
      log("Email: ${email.toString()}, Password: ${password.toString()}");
      setState(() {
        _isProcessing = true;
      });
      await Authentication()
          .signUp(email: email.toString(), password: password.toString())
          .then((value) {
        if (value == null) {
          //ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Success")));
          //Navigator.pushReplacementNamed(context, PageRoutes.loginPage);
          Navigator.pushReplacement(context, MaterialPageRoute(builder:(context) =>  CreateUserDetail(email:email.toString() ,),));
        } else {
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text(value)));
        }
      });
      await Future.delayed(const Duration(seconds: 2),(){});
      setState(() {
        _isProcessing = false;
      });
    }
  }
}
