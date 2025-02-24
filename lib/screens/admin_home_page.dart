import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:watch_hub/pages/logout_page.dart';
import 'package:watch_hub/screens/login_page.dart';
import 'package:watch_hub/services/authenticate.dart';
import 'package:watch_hub/widgets/admin_cus_drawer.dart';
import 'package:watch_hub/widgets/body_landscape.dart';

class AdminHomePage extends StatefulWidget {
  const AdminHomePage({super.key});
  static const routeName = "/AdminHomePage";

  @override
  State<AdminHomePage> createState() => _AdminHomePageState();
}

class _AdminHomePageState extends State<AdminHomePage> {
  String? displayName;
  bool loginStatus = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    final user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      setState(() {
        displayName = user.displayName;
        loginStatus = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      drawer:const AdminCusDrawer(),
      appBar: AppBar(
        title: Text(
          'Admin Home - $displayName',
          style: Theme.of(context).textTheme.titleMedium,
        ),
        iconTheme: const IconThemeData(color: Colors.deepOrange),
        actions: <Widget>[
          (loginStatus == true)
              ? IconButton(
              onPressed: () {
                Authentication().signOut();
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (BuildContext) => const LogoutPage()));
              },
              icon: const Icon(Icons.logout))
              : IconButton(
              onPressed: () {
                // Authentication().signOut();
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (BuildContext) => const LoginPage()));
              },
              icon: const Icon(Icons.login_rounded))
        ],

      ),
      body: OrientationBuilder(builder: (context, orientation) {
        if (orientation == Orientation.portrait) {
          return const Center(child: Text('Coming Soon'));
        } else {
          return const BodyLandscape();
        }
      }),
    );
  }
}
