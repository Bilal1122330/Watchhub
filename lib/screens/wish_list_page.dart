
import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
import 'package:watch_hub/models/wish.dart';
import 'package:watch_hub/pages/logout_page.dart';
import 'package:watch_hub/services/authenticate.dart';
import 'package:watch_hub/services/wish_dao.dart';
import 'package:watch_hub/widgets/admin_cus_drawer.dart';
import 'package:watch_hub/widgets/body_landscape.dart';
import 'package:watch_hub/widgets/user_cus_drawer.dart';
import 'package:watch_hub/widgets/video_template.dart';


class WishListPage extends StatefulWidget {
  const WishListPage({super.key});
  static const routeName = "/WishListPage";

  @override
  State<WishListPage> createState() => _WishListPageState();
}

class _WishListPageState extends State<WishListPage> {


  String displayName = "Anonymous";
  bool loginStatus = false;
  String uuid="";
  //database connectivity
  final Future<FirebaseApp> _furture = Firebase.initializeApp();
  WishDao wishDao = WishDao();

  var wishNameCntrl = TextEditingController();
  var quantityCntrl = TextEditingController();

  String? productName;
  String? quantity;
  String? key;
  String editData = "insert";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    final user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      setState(() {
        displayName = user.displayName.toString();
        loginStatus = true;
        uuid = user.uid;
      });
    }
    final connectRef = wishDao.getWishListQuery(uuid);
    connectRef.keepSynced(true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: (loginStatus==true)?const UserCusDrawer():null,
      appBar: AppBar(
        title:  Text('Manage Wish List', style: Theme.of(context).textTheme.titleMedium,),
        iconTheme:const IconThemeData(color: Colors.deepOrange),
        actions: [
          IconButton(
              onPressed: ()async{
                try{
                  await Authentication().signOut();
                  Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>const LogoutPage()));
                }catch(e){
                  //print('Error in navigation');
                  log('Error in navigation');
                }
              }, icon: const Icon(Icons.logout,)
          )
        ],
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

  Widget fillBody(){
    return Padding(
      padding:const EdgeInsets.all(10),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Card(
            elevation: 2,
            color: Colors.black54,
            child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Center(child: FutureBuilder(
                    future: _furture,
                    builder: (context,snapshopt){
                      if(snapshopt.hasError){
                        return Text(snapshopt.error.toString());
                      }
                      return Column(
                        children: [
                          TextField(
                            controller: wishNameCntrl,
                            style: Theme.of(context).textTheme.bodyMedium,
                            decoration: const InputDecoration(
                                hintText: "Enter Product Name"
                            ),
                          ),
                          const SizedBox(height:  10,),
                          TextField(
                            controller: quantityCntrl,
                            style: Theme.of(context).textTheme.bodyMedium,
                            decoration: const InputDecoration(
                                hintText: "Enter Product quantity"
                            ),
                          ),
                          const SizedBox(height:  10,),
                          SizedBox(
                              width: double.infinity,
                              child: ElevatedButton(onPressed: _saveData, child: const Text('Save Record'))),
                          const SizedBox(height:  10,),

                        ],
                      );
                    }

                ))),
          ),
          _getWishList()
        ],
      ),
    );
  }

  void _saveData(){
    String wishName = wishNameCntrl.text;
    String quantity = quantityCntrl.text;

    Wish wish = Wish(wishName: wishName,quantity: quantity );

    switch(editData){
      case "insert":
        wishDao.saveWish(wish,uuid);
        break;
      case "update":
        wishDao.updateWish(wish,uuid ,key.toString());

        break;
    }
    
    wishNameCntrl.clear();
    quantityCntrl.clear();
    setState(() {
      editData = "insert";
      key = "";
    });

  }

  Widget _getWishList(){
    return Expanded(child: FirebaseAnimatedList(
        query: wishDao.getWishListQuery(uuid),
        itemBuilder: (context,snapshot, animation,index){
          final json = snapshot.value as Map<dynamic,dynamic>;
          final wish = Wish.formJson(json);
          return Card(
            color: Colors.black.withOpacity(0.5),
            child: ListTile(
              title: Text("Wish Name: ${wish.wishName}", style: Theme.of(context).textTheme.titleMedium,),
              subtitle: Text("Quantity: ${wish.quantity}",style: Theme.of(context).textTheme.bodyMedium,),
              trailing: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(onPressed: (){
                  // String key = snapshot.key.toString();

                   setState(() {
                     wishNameCntrl.text = wish.wishName;
                     quantityCntrl.text = wish.quantity;
                     editData ="update";
                     key =  snapshot.key;
                   });
                   //_saveData();
                  }, icon: const Icon(Icons.edit, color: Colors.yellow)),
                  IconButton(onPressed: (){
                    String key = snapshot.key.toString();
                    deleteWish(key);
                  }, icon: const Icon(Icons.delete, color: Colors.yellow)),
                ],
              ),
            ),
          );
        })

    );

  }

  void updateWish(String key, Wish wish){
    wishDao.updateWish(wish, uuid,key);
  }

  void deleteWish(String key){
    wishDao.deleteWish(uuid,key);
  }
}
