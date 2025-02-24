import 'dart:developer';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:watch_hub/models/product.dart';
import 'package:watch_hub/pages/logout_page.dart';
import 'package:watch_hub/routes/app_routes.dart';
import 'package:watch_hub/screens/login_page.dart';
import 'package:watch_hub/services/authenticate.dart';
import 'package:watch_hub/services/product_doa.dart';
import 'package:watch_hub/widgets/body_landscape.dart';
import 'package:watch_hub/widgets/message_box.dart';
import 'package:watch_hub/widgets/product_cards.dart';
import 'package:watch_hub/widgets/user_cus_drawer.dart';
import 'package:watch_hub/widgets/video_template.dart';
import 'package:carousel_slider/carousel_slider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});
  static const routeName = "/HomePage";

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String displayName = "Anonymous";
  bool loginStatus = false;
  List<Product> productList = [];
  List<Product> venderRecomended = [];
  List<Product> topSelling = [];
  bool isLoading = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    final user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      setState(() {
        displayName = user.displayName.toString();
        loginStatus = true;
      });
    }

    final connectedRef = ProductDao().getProductQuery();
    connectedRef.keepSynced(true);
    loadProductList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: (loginStatus==true)?const UserCusDrawer():null,
      appBar: AppBar(
        title: Text(
          'Home - $displayName',
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
        automaticallyImplyLeading: (loginStatus==true)?true:false,
      ),
      body: OrientationBuilder(builder: (context, orientation) {
        if (orientation == Orientation.portrait) {
          return getBodyPortrait();
        } else {
          return const BodyLandscape();
        }
      }),
      floatingActionButton: FloatingActionButton(onPressed: (){
        if(loginStatus==false){
          Navigator.pushReplacementNamed(context, PageRoutes.loginPage);
        }else{
          Navigator.pushReplacementNamed(context, PageRoutes.productPage);
        }
      }, child:const Icon(Icons.add_shopping_cart,color: Colors.orange,),),
    );
  }

  Widget getBodyPortrait() {
    return VideoTemplate(
      body: Center(
        child: isLoading
            ? const Center(
                child: SizedBox(
                  width: 100,
                  height: 100,
                  child: CircularProgressIndicator(
                    strokeWidth: 10,
                    backgroundColor: Colors.greenAccent,
                    valueColor:
                        AlwaysStoppedAnimation<Color>(Colors.yellowAccent),
                  ),
                ),
              )
            : fillBody(context),
      ),
      videoPath: 'assets/media/back_video/watch1.mp4',
    );
  }

  Widget fillBody(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(10.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Card(
            margin: const EdgeInsets.all(10),
            color: Colors.black45,
            elevation: 10,
            child: sectionTitle(context, "Vendor's Recommended"),
          ),
          carouselSection(venderRecomended),
          Card(
            margin: const EdgeInsets.all(10),
            color: Colors.black45,
            elevation: 10,
            child: sectionTitle(context, "Product List"),
          ),
          Card(
            margin: const EdgeInsets.all(10),
            color: Colors.black12,
            elevation: 10,
            child: listSection(productList),
          ),
          Card(
            margin: const EdgeInsets.all(10),
            color: Colors.black45,
            elevation: 10,
            child: sectionTitle(context, "Top Selling"),
          ),
          carouselSection(topSelling),
        ],
      ),
    );
  }

  void loadProductList() {
    final productReference = ProductDao().getProductQuery();

    productReference.onValue.listen((DatabaseEvent event) {
      final data = event.snapshot.value as Map<dynamic, dynamic>;

      if (data != null) {
        setState(() {
          productList = data.entries.map((product) {
            return Product.fromJson(Map<String, dynamic>.from(product.value));
          }).toList();
          filterVendorRecommendedProducts();
          filterTopSellingProducts();
          //print("The total nos of product items in list: ${productList.length}");
          log('The total nos of product items in list: ${productList.length}');
         // print("The total nos of vendor recommended items: ${venderRecomended.length}");
          log('The total nos of vendor recommended items: ${venderRecomended.length}');
          //print("The total nos of top selling items: ${topSelling.length}");
          log('The total nos of top selling items: ${topSelling.length}');
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

  void filterVendorRecommendedProducts() {
    venderRecomended = productList
        .where((product) => product.status.endsWith("Vendor recommended"))
        .toList();
    print("item vendor recommend ${venderRecomended.length}");
  }

  void filterTopSellingProducts() {
    topSelling =
        productList.where((product) => product.status == "Top selling").toList();
  }

  Widget sectionTitle(BuildContext context, String title) {
    return Container(
      width: MediaQuery.of(context).size.width,
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: Text(
        title,
        style: Theme.of(context).textTheme.titleMedium,
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget listSection(List<Product> products) {
    return Container(
      height: 350.0, // Adjust height as needed
      child: ListView.builder(
        // physics: const NeverScrollableScrollPhysics(), // Prevents scrolling inside the list view
        itemCount: products.length,
        itemBuilder: (context, index) {
          final product = products[index];
          return getItemCardSimple(product: product, context: context);
        },
      ),
    );
  }

  Widget carouselSection(List<Product> products) {
    return CarouselSlider(
      items: products.map((prd) => getItemCardCar(product: prd)).toList(),
      options: CarouselOptions(
        height: 170.0,
        enlargeCenterPage: false,
        autoPlay: true,
        autoPlayCurve: Curves.fastOutSlowIn,
        enableInfiniteScroll: true,
        autoPlayAnimationDuration: const Duration(milliseconds: 800),
        viewportFraction: 0.4,
      ),
    );
  }
}
