import 'package:flutter/material.dart';
import 'dart:ui';

Widget createDrawerHeader({
  required BuildContext context,
  String? displayName,
}) {
  return SizedBox(
    height: 250,
    child: DrawerHeader(
      margin: EdgeInsets.zero,
      padding: EdgeInsets.zero,
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage("assets/media/avator/watchpic1.jpg"),
          fit: BoxFit.cover,
        ),
      ),
      child: Stack(
        children: [
          // Glassmorphism Effect
          BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
            child: Container(
              color: Colors.black.withOpacity(0.2),
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Center(
                child: Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.pinkAccent.withOpacity(0.8),
                        blurRadius: 25,
                        spreadRadius: 5,
                      ),
                    ],
                  ),
                  child: const CircleAvatar(
                    backgroundColor: Color.fromARGB(0, 62, 8, 8),
                    radius: 70,
                    child: CircleAvatar(
                      radius: 60,
                      backgroundImage: AssetImage("assets/media/avator/user2.png"),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Text(
                displayName ?? "Guest User",
                textAlign: TextAlign.center,
                style: Theme.of(context)
                    .textTheme
                    .titleMedium
                    ?.copyWith(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 22),
              ),
              const SizedBox(height: 10),
            ],
          ),
        ],
      ),
    ),
  );
}

Widget createDrawerBodyItem({
  required BuildContext context,
  required String text,
  required GestureTapCallback onTap,
  required IconData icon,
}) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
    child: Container(
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.3),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: const Color.fromARGB(255, 92, 77, 77).withOpacity(0.5),
            blurRadius: 15,
            spreadRadius: 2,
          ),
        ],
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        leading: Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: Colors.pinkAccent.withOpacity(0.7),
                blurRadius: 15,
                spreadRadius: 5,
              ),
            ],
          ),
          child: Icon(
            icon,
            color: Colors.cyanAccent,
            size: 30,
          ),
        ),
        title: Text(
          text,
          style: Theme.of(context)
              .textTheme
              .titleMedium
              ?.copyWith(color: Colors.white, fontWeight: FontWeight.w600),
        ),
        onTap: onTap,
      ),
    ),
  );
}

class CustomDrawer extends StatelessWidget {
  final String? displayName;

  const CustomDrawer({Key? key, this.displayName}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Colors.black,
              Colors.deepPurple.shade900,
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            createDrawerHeader(context: context, displayName: displayName),
            createDrawerBodyItem(
              context: context,
              text: 'Home',
              icon: Icons.home,
              onTap: () {
                Navigator.pop(context);
              },
            ),
            createDrawerBodyItem(
              context: context,
              text: 'Profile',
              icon: Icons.person,
              onTap: () {
                Navigator.pop(context);
              },
            ),
            createDrawerBodyItem(
              context: context,
              text: 'Settings',
              icon: Icons.settings,
              onTap: () {
                Navigator.pop(context);
              },
            ),
            createDrawerBodyItem(
              context: context,
              text: 'Logout',
              icon: Icons.logout,
              onTap: () {
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }
}

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Drawer Demo',
      theme: ThemeData(
        brightness: Brightness.light,
        primarySwatch: Colors.pink,
        textTheme: const TextTheme(
          titleMedium: TextStyle(fontSize: 18, color: Colors.white),
        ),
      ),
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Beautiful Drawer UI'),
        ),
        drawer: const CustomDrawer(displayName: "John Doe"),
        body: const Center(
          child: Text(
            'Swipe from the left edge to see the Drawer!',
            style: TextStyle(fontSize: 20),
          ),
        ),
      ),
    );
  }
}
