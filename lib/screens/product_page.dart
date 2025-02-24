
import 'dart:developer';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:watch_hub/models/cart.dart';
import 'package:watch_hub/models/product.dart';
import 'package:watch_hub/models/wish.dart';
import 'package:watch_hub/pages/logout_page.dart';
import 'package:watch_hub/routes/app_routes.dart';
import 'package:watch_hub/screens/login_page.dart';
import 'package:watch_hub/services/authenticate.dart';
import 'package:watch_hub/services/cart_dao.dart';
import 'package:watch_hub/services/product_doa.dart';
import 'package:watch_hub/services/wish_dao.dart';
import 'package:watch_hub/widgets/body_landscape.dart';
import 'package:watch_hub/widgets/item_cart_card.dart';
import 'package:watch_hub/widgets/message_box.dart';
import 'package:watch_hub/widgets/user_cus_drawer.dart';
import 'package:watch_hub/widgets/video_template.dart';

class ProductPage extends StatefulWidget {
  const ProductPage({super.key});
  static const routeName = "/ProductPage";

  @override
  State<ProductPage> createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage> {
  String displayName = 'Anonymous';
  bool loginStatus = false;
 // List<Product> productList = [];
  WishDao wishDao = WishDao();
  bool isLoading = false;
  String? uuid;
  int cartItemCount = 0;
  List<Product> products = [];
  Map<Product, int> productQuantities = {};
  final cartDao = CartDao();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    final user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      setState(() {
        displayName = user.displayName.toString();
        loginStatus = true;
        uuid = user.uid.toString();
      });
      final connectedRef = ProductDao().getProductQuery();
      connectedRef.keepSynced(true);
      final connectedCartRef = cartDao.getMessageQuery(uuid.toString());
      connectedCartRef.keepSynced(true);
      loadProductList();

      //getTotalCartItemsCountInitial();
    }else{
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>const LoginPage()));
    }

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: (loginStatus==true)?const UserCusDrawer():null,
      appBar: AppBar(
        title:  Text('Product Page', style: Theme.of(context).textTheme.titleMedium,),
        iconTheme:const IconThemeData(color: Colors.deepOrange),
        actions: [
          CircleAvatar(
            radius: 20,
            backgroundColor: Colors.black,
            child: IconButton(
                icon: const Icon(Icons.add_shopping_cart_outlined),
                onPressed: () {
                  Navigator.pushReplacementNamed(context, PageRoutes.mngCartPage);
                },
                color: cartItemCount > 0 ? Colors.green : Colors.white),
          ),
          const SizedBox(
            width: 5.0,
          ),
          if (cartItemCount > 0)
            Positioned(
                right: 8,
                top: 8,
                child: CircleAvatar(
                  backgroundColor: Colors.red,
                  radius: 12,
                  child: Text(
                    "$cartItemCount",
                  ),
                )),
          const SizedBox(
            width: 5.0,
          ),
          IconButton(
              onPressed: ()async{
                try{
                  await Authentication().signOut();
                  Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>const LogoutPage()));
                }catch(e){
                  //print('Error in navigation');
                  log("Error in navigation: $e");
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
    );
  }

  Widget getBodyPortrait(){
    return VideoTemplate(body: fillBody(), videoPath: "assets/media/back_video/watch1.mp4");
  }

  Widget fillBody() {
    log("Product length is ${products.length}");
    return Container(
      padding: const EdgeInsets.all(10.0),
      // child: getItemCard(product: products[0], onCartTap: (){}, onFavoriteTap: (){})
      child: Container(
        padding: const EdgeInsets.all(10.0),
        child: ListView.builder(
            itemCount: products.length,
            itemBuilder: (context, index) {
              final prd = products[index];
              final quantity = productQuantities[prd] ?? 1;
              return getItemCard(
                product: prd,
                quantity: quantity,
                onCartTap: () => handleCartTap(prd),
                onFavoriteTap: () {
                  Wish wish = Wish(wishName: prd.name,quantity: quantity.toString() );
                  wishDao.saveWish(wish,uuid.toString());
                  messageBox(context: context, title: "Message", message: "${prd.name} added to wish list");
                  },
                onDecreaseTap: () => decrementQuantity(prd),
                onIncreaseTap: () => incrementQuantity(prd),
              );
            }),
      ),
    );
    //return const Center(child: Text('Loading item',style: TextStyle(color: Colors.yellow),),);
  }

  void loadProductList() {
    final productReference = ProductDao().getProductQuery();

    productReference.onValue.listen((DatabaseEvent event) {
      final data = event.snapshot.value as Map<dynamic, dynamic>;

      if (data != null) {
        setState(() {
          products = data.entries.map((product) {
            return Product.fromJson(Map<String, dynamic>.from(product.value));
          }).toList();
          getTotalCartItemsCountInitial();

        });
      } else {
        setState(() {
          isLoading = false; // No items found, stop loading indicator
        });
        // print("No items in the list");
        Future.delayed( Duration.zero, () {
          if(!mounted) return;
          messageBox(context: context, message: "No items in the list",title: "Info");
        });
      }
    }, onError: (error) {
      setState(() {
        setState(() {
          isLoading = false; // No items found, stop loading indicator
        });
        //print("Error in loading product items: $error");
        log("Error in loading product items: $error");
        // Future.delayed( Duration.zero, () {
        //   if(!mounted) return;
        //   messageBox(context: context, message: "Error in loading product items: $error",title: "Error");
        // });
      });
    });
  }

  Future<void> getTotalCartItemsCountInitial() async {
    try {
      final count = await cartDao.getTotalCartItemsCount(uuid.toString());
      setState(() {
        cartItemCount = count;
      });
    } catch (error) {
      print("Error unable get cart item count");
    }
  }

  Future<void> handleCartTap(Product prd) async {
    if (prd.status == "out of stock") {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("product is out of stock")));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("you have selected ${prd.name}")));

      final cart = Cart(
        code: prd.code,
        name: prd.name,
        price: prd.price,
        quantity: productQuantities[prd] ?? 1,
      );

      await cartDao.saveToCart(cart, uuid.toString());
      await getTotalCartItemsCountInitial();
    }
  }

  void incrementQuantity(Product product) {
    setState(() {
      productQuantities[product] = (productQuantities[product] ?? 1) + 1;
    });
  }

  void decrementQuantity(Product product) {
    setState(() {
      if ((productQuantities[product] ?? 1) > 1) {
        productQuantities[product] = (productQuantities[product] ?? 1) - 1;
      }
    });
  }




}
