import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
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
  int userCount = 0;
  int productCount = 0;
  int adminCount = 0;


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

    DatabaseReference usersRef = FirebaseDatabase.instance.ref("users");
    usersRef.onValue.listen((event) {
      if (event.snapshot.value != null) {
        final data = event.snapshot.value as Map<dynamic, dynamic>;
        setState(() {
          userCount = data.length;
        });

        int tempAdminCount = 0;
        int tempUserCount = 0;
        data.forEach((key, value) {
          if (value["type"] == "admin") {
            tempAdminCount++;
          }
          if (value["type"] == "user") {
            tempUserCount++;
          }
        });
        setState(() {
          adminCount = tempAdminCount;
          userCount = tempUserCount;
        });
      } else {
        setState(() {
          userCount = 0;
          adminCount = 0;
        });
      }
    });

    // Listen for changes in "Products" node
    DatabaseReference productsRef = FirebaseDatabase.instance.ref("Products");
    productsRef.onValue.listen((event) {
      if (event.snapshot.value != null) {
        final data = event.snapshot.value as Map<dynamic, dynamic>;
        setState(() {
          productCount = data.length;
        });
      } else {
        setState(() {
          productCount = 0;
        });
      }
    });


  }

  //@override
  // Widget build(BuildContext context) {
  //   return  Scaffold(
  //     drawer:const AdminCusDrawer(),
  //     appBar: AppBar(
  //       title: Text(
  //         'Admin Home - $displayName',
  //         style: Theme.of(context).textTheme.titleMedium,
  //       ),
  //       iconTheme: const IconThemeData(color: Colors.deepOrange),
  //       actions: <Widget>[
  //         (loginStatus == true)
  //             ? IconButton(
  //             onPressed: () {
  //               Authentication().signOut();
  //               Navigator.pushReplacement(
  //                   context,
  //                   MaterialPageRoute(
  //                       builder: (BuildContext) => const LogoutPage()));
  //             },
  //             icon: const Icon(Icons.logout))
  //             : IconButton(
  //             onPressed: () {
  //               // Authentication().signOut();
  //               Navigator.pushReplacement(
  //                   context,
  //                   MaterialPageRoute(
  //                       builder: (BuildContext) => const LoginPage()));
  //             },
  //             icon: const Icon(Icons.login_rounded))
  //       ],
  //
  //     ),
  //     body: OrientationBuilder(builder: (context, orientation) {
  //       if (orientation == Orientation.portrait) {
  //         return const Center(child: Text('Coming Soon'));
  //       } else {
  //         return const BodyLandscape();
  //       }
  //     }),
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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

      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Card(
              child: ListTile(
                leading: const Icon(Icons.person),
                title: const Text("Total Users"),
                trailing: Text("$userCount"),
              ),
            ),
            const SizedBox(height: 8),
            Card(
              child: ListTile(
                leading: const Icon(Icons.shop),
                title: const Text("Total Products"),
                trailing: Text("$productCount"),
              ),
            ),
            const SizedBox(height: 8),
            Card(
              child: ListTile(
                leading: const Icon(Icons.admin_panel_settings),
                title: const Text("Total Admins"),
                trailing: Text("$adminCount"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
