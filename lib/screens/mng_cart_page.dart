
import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
import 'package:watch_hub/models/cart.dart';
import 'package:watch_hub/models/order.dart';
import 'package:watch_hub/models/user_profile.dart';
import 'package:watch_hub/pages/check_out_page.dart';
import 'package:watch_hub/pages/logout_page.dart';
import 'package:watch_hub/screens/login_page.dart';
import 'package:watch_hub/services/authenticate.dart';
import 'package:watch_hub/services/cart_dao.dart';
import 'package:watch_hub/services/user_profile_dao.dart';
import 'package:watch_hub/widgets/beveled_button.dart';
import 'package:watch_hub/widgets/body_landscape.dart';
import 'package:watch_hub/widgets/user_cus_drawer.dart';
import 'package:watch_hub/widgets/video_template.dart';

class MngCartPage extends StatefulWidget {
  const MngCartPage({super.key});
  static const routeName = "/MngCartPage";

  @override
  State<MngCartPage> createState() => _MngCartPageState();
}

class _MngCartPageState extends State<MngCartPage> {
  String displayName = 'Anonymous';
  bool loginStatus = false;
  late String uuid;
  UsersProfile? userProfile;
  double totalOrderPrice = 0.0;
  final Future<FirebaseApp> _future = Firebase.initializeApp();
  CartDao cartDao = CartDao();
  final userProfileDao = UserProfileDao();
  List<Cart> cartItems = [];

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
    }else{
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>const LoginPage()));
    }
    final connectedCartRef = cartDao.getMessageQuery(uuid);
    connectedCartRef.keepSynced(true);
    final connectedUserProfRef = userProfileDao.getMessageQuery(uuid);
    connectedUserProfRef.keepSynced(true);
    loadCartItems();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: (loginStatus==true)?const UserCusDrawer():null,
      appBar: AppBar(
        title:  Text('Manage Cart', style: Theme.of(context).textTheme.titleMedium,),
        iconTheme:const IconThemeData(color: Colors.deepOrange),
        actions: [
          IconButton(
              onPressed: ()async{
                try{
                  final navigator = Navigator.of(context);
                  await Authentication().signOut();
                  navigator.pushReplacement(
                      MaterialPageRoute(builder: (context) => const LogoutPage()),);
                }catch(e){
                  //print('Error in navigation');
                  log('Error in navigation');
                }
              }, icon: const Icon(Icons.logout,)
          )
        ],
      ),
      body: OrientationBuilder(builder: (context, orientation){
        if(orientation == Orientation.portrait){
          return getBodyPortrait();
        }else{
          return const BodyLandscape();
        }
      }),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: Colors.blueGrey,
        onPressed: () {
          placeOrder();
        },
        label: Text(
          'Check Out',
          style: Theme.of(context).textTheme.titleMedium,
        ),
      ),

    );
  }

  Widget getBodyPortrait(){
    return VideoTemplate(body: fillBody(), videoPath: "assets/media/back_video/videoplayback.mp4");
  }

  Widget fillBody() {
    return Column(
      children: [
        const SizedBox(
          height: 10,
        ),
        Container(
          height: MediaQuery.of(context).size.height * 0.3,
          padding: const EdgeInsets.all(5.0),
          child: FutureBuilder(
            future: _future,
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return Text(snapshot.error.toString());
              } else {
                return FirebaseAnimatedList(
                  query: userProfileDao.getMessageQuery(uuid),
                  itemBuilder: (context, snapshot, animation, index) {
                    final json = snapshot.value as Map<dynamic, dynamic>;
                    userProfile = UsersProfile.fromJson(json);
                    return Card(
                      color:  Color(0xFF003C40).withOpacity(0.3),
                      elevation: 1,
                      child: Padding(
                        padding: const EdgeInsets.all(10),
                        child: userProfile == null
                            ? const Center(child: CircularProgressIndicator())
                            : Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            const Center(
                              child: Text(
                                'User Details',
                                style: TextStyle(
                                  //fontWeight: FontWeight.bold,
                                  fontSize: 20,
                                ),
                              ),
                            ),
                            const SizedBox(height: 10.0),
                            buildSummaryRow(
                                'Name:', userProfile!.displayName),
                            buildSummaryRow(
                                'Mobile No:', userProfile!.mobile),
                            buildSummaryRow(
                                'Email Address:', userProfile!.email),
                            buildSummaryRow(
                                'Address:', userProfile!.address),
                            buildSummaryRow('City:', userProfile!.city),
                            const SizedBox(height: 10.0),
                          ],
                        ),
                      ),
                    );
                  },
                );
              }
            },
          ),
        ),
        Flexible(
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: FutureBuilder(
              future: _future,
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Text(snapshot.error.toString());
                } else {
                  return FirebaseAnimatedList(
                      query: cartDao.getMessageQuery(uuid),
                      itemBuilder: (context, snapshot, animated, index) {
                        var json = snapshot.value as Map<dynamic, dynamic>;
                        String cartKey = snapshot.key.toString();
                        Cart cart = Cart.fromJson(json);

                        //var f = NumberFormat("###.0#", "en_US");
                        return Card(
                          elevation: 10.0,
                          color:  Color(0xFF003C40).withOpacity(0.3),
                          margin: const EdgeInsets.fromLTRB(16, 16, 16, 0),
                          child: Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                const SizedBox(
                                  height: 5,
                                ),
                                buildSummaryRow("Product Code", cart.code),
                                const SizedBox(
                                  height: 5,
                                ),
                                buildSummaryRow("Product Name", cart.name),
                                const SizedBox(
                                  height: 5,
                                ),
                                buildSummaryRow("Product Price", "NFT: ${cart.price}"),
                                const SizedBox(
                                  height: 5,
                                ),
                                buildSummaryRow("Product Quantity", "${cart.quantity}"),
                                const SizedBox(
                                  height: 5,
                                ),
                                Row(
                                  mainAxisAlignment:
                                  MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    const Text(
                                      "Total",
                                      style: TextStyle(
                                        //fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                      ),
                                    ),
                                    Text(
                                      "NFT ${cart.price * cart.quantity}",
                                      style: const TextStyle(
                                       // fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 5.0),
                                SizedBox(
                                  width: MediaQuery.of(context).size.width,
                                  child: BeveledButton(
                                      title: 'Delete',
                                      onTap: () {
                                        removeCartItem(cartKey, cart);
                                      }),
                                )
                              ],
                            ),
                          ),
                        );
                      });
                }
              },
            ),
          ),
        ),
      ],
    );
  }

  void placeOrder() {
    loadCartItems();
    if (cartItems.isEmpty) {
      // Show an alert dialog if the cart is empty
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text("Cart is empty"),
            content: const Text(
                "Please add items to your cart before placing an order."),
            actions: <Widget>[
              TextButton(
                child: const Text("OK"),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
      return; // Exit the method if the cart is empty
    }

    Order order = Order(
      uuid: uuid.toString(),
      contactName: userProfile!.displayName,
      address: userProfile!.address,
      mobile: userProfile!.mobile,
      city: userProfile!.city,
      email: userProfile!.email,
      orderDate: DateTime.now().toLocal().toString(),
      orderDetail: cartItems,
      amount: totalOrderPrice,
      status: "pending",
      comments: "order is pending, need approval",
    );

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => CheckOutPage(
          order: order,
        ),
      ),
    );
  }

  void loadCartItems() {
    final cartRef = cartDao.getMessageQuery(uuid);

    cartRef.onValue.listen((DatabaseEvent event) {
      final data = event.snapshot.value as Map<dynamic, dynamic>?;

      if (data != null) {
        setState(() {
          cartItems = data.entries.map((e) {
            return Cart.fromJson(Map<String, dynamic>.from(e.value));
          }).toList();

          totalOrderPrice = cartItems.fold(
              0.0, (sum, item) => sum + (item.price * item.quantity));
          print("Loaded cart items: $cartItems");
          print("Total order price: $totalOrderPrice");
        });
      } else {
        print("No items in the cart");
      }
    }, onError: (error) {
      print("Error loading cart items: $error");
    });
  }

  void removeCartItem(String cartKey, Cart cart) {
    cartDao.deleteCart(cartKey, uuid).then((_) {
      Navigator.pushReplacement(context,
          MaterialPageRoute(builder: (BuildContext context) => super.widget));
      ;
    }).catchError((error) {
      print("Error removing item: $error");
    });
  }

  Widget buildSummaryRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Flexible(
            child: Text(
              label,
              style: const TextStyle(
               // fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ),
          Flexible(
            child: Text(
              value,
              style: const TextStyle(fontSize: 16),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
