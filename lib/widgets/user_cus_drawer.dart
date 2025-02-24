import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:watch_hub/pages/logout_page.dart';
import 'package:watch_hub/services/authenticate.dart';
import 'package:watch_hub/widgets/cust_drawers.dart';
import '../routes/app_routes.dart';

class UserCusDrawer extends StatefulWidget {
  const UserCusDrawer({super.key});

  @override
  State<UserCusDrawer> createState() => _UserCusDrawerState();
}

class _UserCusDrawerState extends State<UserCusDrawer> {
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
        color: const Color.fromARGB(255, 23, 15, 15),
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            createDrawerHeader(context: context, displayName: "User - $displayName" ),
            createDrawerBodyItem(context: context, text: "Home Page", icon: Icons.home,onTap: ()=>Navigator.pushReplacementNamed(context, PageRoutes.homePage)),
            createDrawerBodyItem(context: context, text: "All Products", icon: Icons.production_quantity_limits_outlined,onTap: ()=>Navigator.pushReplacementNamed(context, PageRoutes.productPage)),
            createDrawerBodyItem(context: context, text: "Manage Cart", icon: Icons.shop,onTap: ()=>Navigator.pushReplacementNamed(context, PageRoutes.mngCartPage)),
            createDrawerBodyItem(context: context, text: "My Order", icon: Icons.shopify,onTap: ()=>Navigator.pushReplacementNamed(context, PageRoutes.mngOrderPage)),
            createDrawerBodyItem(context: context, text: "Wish List", icon: Icons.account_tree_outlined,onTap: ()=>Navigator.pushReplacementNamed(context, PageRoutes.wishListPage)),
            createDrawerBodyItem(context: context, text: "About Us", icon: Icons.contact_page,onTap: ()=>Navigator.pushReplacementNamed(context, PageRoutes.aboutus)),
            const Divider(color: Colors.lightBlueAccent),
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



