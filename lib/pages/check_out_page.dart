import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:watch_hub/models/order.dart';
import 'package:watch_hub/screens/home_page.dart';
import 'package:watch_hub/screens/login_page.dart';
import 'package:watch_hub/screens/mng_cart_page.dart';
import 'package:watch_hub/services/cart_dao.dart';
import 'package:watch_hub/services/order_dao.dart';
import 'package:watch_hub/widgets/beveled_button.dart';
import 'package:watch_hub/widgets/body_landscape.dart';
import 'package:watch_hub/widgets/video_template.dart';

class CheckOutPage extends StatefulWidget {
  const CheckOutPage({super.key, required this.order});
  final Order order;

  @override
  State<CheckOutPage> createState() => _CheckOutPageState();
}

class _CheckOutPageState extends State<CheckOutPage> {
  String displayName = 'Anonymous';
  bool loginStatus = false;
  OrdersDao ordersDao = OrdersDao();
  CartDao cartDao = CartDao();
  late String uuid;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    final user = FirebaseAuth.instance.currentUser;

    final connectedRef = ordersDao.getMessageQuery();
    connectedRef.keepSynced(true);


    if (user != null) {
      setState(() {
        displayName = user.displayName.toString();
        loginStatus = true;
        uuid = user.uid;
      });
    }else{
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>const LoginPage()));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Check Out",
          style: Theme.of(context).textTheme.titleMedium,
        ),
        automaticallyImplyLeading: false,
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
    return  Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Card(
            color: Colors.green.withOpacity(0.4),
            elevation: 1,
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  const Center(
                    child: Text(
                      'Order Details',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    ),
                  ),
                  const SizedBox(height: 10.0),
                  buildSummaryRow('Name:', widget.order.contactName),
                  buildSummaryRow('Mobile No:', widget.order.mobile),
                  buildSummaryRow('Email Address:', widget.order.email),
                  buildSummaryRow('Address:', widget.order.address),
                  buildSummaryRow('City:', widget.order.city),
                  buildSummaryRow('Order Date:', widget.order.orderDate),
                  buildSummaryRow('Order Amount:',
                      "NFT ${widget.order.amount.toString()}"),
                  const SizedBox(height: 10.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Expanded(
                          flex: 1,
                          child: BeveledButton(
                              title: "OK",
                              onTap: () async {
                                ordersDao.saveOrder(widget.order);
                                await cartDao.deleteAllCartItems(uuid);

                                Future.delayed(Duration.zero, () {
                                  // context can be used here...
                                });

                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      title: const Text("Alert!!"),
                                      content: const Text(
                                          "Your order is placed"),
                                      actions: <Widget>[
                                        TextButton(
                                          child: const Text("OK"),
                                          onPressed: () {
                                            Navigator.pushReplacement(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                    const HomePage()));
                                          },
                                        ),
                                      ],
                                    );
                                  },
                                );
                              })),
                      const SizedBox(
                        width: 10,
                      ),
                      Expanded(
                        flex: 1,
                        child: BeveledButton(
                            title: "Cancel",
                            onTap: () async {
                              Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                      const MngCartPage()));
                            }),
                      )
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      ],
    );
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
                //fontWeight: FontWeight.bold,

                fontSize: 16,
              ),
            ),
          ),
          Flexible(
            child: Text(
              value,
              style: const TextStyle(fontSize: 14),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

}
