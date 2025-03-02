import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:watch_hub/pages/logout_page.dart';
import 'package:watch_hub/services/authenticate.dart';
import '../routes/app_routes.dart';
import 'cust_drawers.dart';

class AdminCusDrawer extends StatefulWidget {
  const AdminCusDrawer({super.key});

  @override
  State<AdminCusDrawer> createState() => _AdminCusDrawerState();
}

class _AdminCusDrawerState extends State<AdminCusDrawer> {

  String? displayName;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    final user = FirebaseAuth.instance.currentUser;

    if(user!=null){
      displayName = user.displayName;
    }

  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Container(
        color: const Color.fromARGB(255, 24, 18, 18),
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            createDrawerHeader(context: context, displayName: "Admin - $displayName" ),
            createDrawerBodyItem(context: context, text: "Admin Home", icon: Icons.home,onTap: ()=>Navigator.pushReplacementNamed(context, PageRoutes.adminHomePage)),
          //  createDrawerBodyItem(context: context, text: "Manage Product", icon: Icons.shop,onTap: ()=>Navigator.pushReplacementNamed(context, PageRoutes.adminProduct)),
            createDrawerBodyItem(context: context, text: "Manage Product", icon: Icons.shop,onTap: ()=>Navigator.pushReplacementNamed(context, PageRoutes.adminProduct)),
            createDrawerBodyItem(context: context, text: "Add Product", icon: Icons.add,onTap: ()=>Navigator.pushReplacementNamed(context, PageRoutes.addProductPage)),
            createDrawerBodyItem(context: context, text: "About Us", icon: Icons.contact_page,onTap: (){}),
            const Divider(color: Colors.redAccent),
            createDrawerBodyItem(context: context, text: "Logout", icon: Icons.logout,onTap: (){
              Authentication().signOut();
              Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const LogoutPage()));
            }),
          ],
        ),
      ),

    );
  }
}


