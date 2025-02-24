import 'dart:developer';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:watch_hub/models/cart.dart';
import 'package:watch_hub/models/order.dart';
import 'package:watch_hub/pages/logout_page.dart';
import 'package:watch_hub/screens/login_page.dart';
import 'package:watch_hub/services/authenticate.dart';
import 'package:watch_hub/services/order_dao.dart';
import 'package:watch_hub/widgets/body_landscape.dart';
import 'package:watch_hub/widgets/user_cus_drawer.dart';
import 'package:watch_hub/widgets/video_template.dart';

class OrderPage extends StatefulWidget {
  const OrderPage({super.key});
  static const String routeName = '/OrderPage';

  @override
  State<OrderPage> createState() => _OrderPageState();
}

class _OrderPageState extends State<OrderPage> {
  String displayName = 'Anonymous';
  bool loginStatus = false;
  late String uuid;
  OrdersDao ordersDao = OrdersDao();
  List<Order> orders = [];
  bool isLoading = true;

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
        uuid = user.uid;
        fetchAndSortOrders(); // Fetch and sort orders when the user is authenticated
      });
    }else{
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>const LoginPage()));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: (loginStatus==true)?const UserCusDrawer():null,
      appBar: AppBar(
        title:  Text('Order List', style: Theme.of(context).textTheme.titleMedium,),
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
          return getBodyPortrait();
        } else {
          return const BodyLandscape();
        }
      }),
    );
  }
  Widget getBodyPortrait(){
    return VideoTemplate(body: fillBody(), videoPath: "assets/media/back_video/watch1.mp4");
  }

  Widget fillBody() {
    return isLoading
        ? const Center(child: CircularProgressIndicator())
        : orders.isEmpty
        ? const Center(child: Text('No orders available.'))
        : ListView.builder(
      itemCount: orders.length,
      itemBuilder: (context, index) {
        Order order = orders[index];

        return Container(
          margin: const EdgeInsets.symmetric(
              vertical: 5, horizontal: 10),
          decoration: BoxDecoration(
            color: Colors.orange.withOpacity(0.4), // White background for ListTile
            borderRadius: BorderRadius.circular(8.0),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.5),
                spreadRadius: 1,
                blurRadius: 3,
                offset: const Offset(
                    0, 1), // changes position of shadow
              ),
            ],
          ),
          child: ListTile(
            title: Text(order.contactName,
                style: Theme.of(context).textTheme.titleLarge),
            subtitle: Text(
                'Order Date: ${order.orderDate}\nAmount: NFT ${order.amount}',
                style: Theme.of(context).textTheme.bodyMedium),
            trailing: Text(order.status,
                style: Theme.of(context).textTheme.bodyMedium),
            onTap: () {
              showOrderDetails(order);
            },
          ),
        );
      },
    );
  }

  Future<void> fetchAndSortOrders() async {
    if (uuid != null) {
      try {
        List<Order> fetchedOrders = await ordersDao.fetchOrdersByUuid(uuid!);
        // Sort orders by `orderDate` in descending order
        fetchedOrders
            .sort((a, b) => b.orderDateTime.compareTo(a.orderDateTime));
        setState(() {
          orders = fetchedOrders;
          isLoading = false;
        });
      } catch (e) {
        // Handle any errors that occur during fetching
        log('Error fetching orders: $e');
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  Future<dynamic> showOrderDetails(Order order) {
    return showDialog(
      useSafeArea: false,
      context: context,
      builder: (context) => Scaffold(
        appBar: AppBar(
          title: const Text('Order Details',),
          actions: <Widget>[
            IconButton(
              icon: const Icon(Icons.close),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        ),
        body: SingleChildScrollView(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Card(
                color: Colors.orange.withOpacity(0.4),
                elevation: 1,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text('Contact Name: ${order.contactName}',
                              style: Theme.of(context).textTheme.bodyLarge),
                          Text('Address: ${order.address}',
                              style: Theme.of(context).textTheme.bodyMedium),
                          Text('Mobile: ${order.mobile}',
                              style: Theme.of(context).textTheme.bodyMedium),
                          Text('City: ${order.city}',
                              style: Theme.of(context).textTheme.bodyMedium),
                          Text('Email: ${order.email}',
                              style: Theme.of(context).textTheme.bodyMedium),
                          Text('Order Date: ${order.orderDate}',
                              style: Theme.of(context).textTheme.bodyMedium),
                          Text('Amount: NFT ${order.amount}',
                              style: Theme.of(context).textTheme.bodyMedium),
                          Text('Status: ${order.status}',
                              style: Theme.of(context).textTheme.bodyMedium),
                          Text('Comments: ${order.comments}',
                              style: Theme.of(context).textTheme.bodyMedium),
                          const SizedBox(
                              height:
                              16), // Add some space before the order details
                          Text('Order Details:',
                              style: Theme.of(context).textTheme.titleLarge),
                          const SizedBox(height: 8),
                          SizedBox(
                            height: 300, // Adjust the height as needed
                            child: ListView.builder(
                              itemCount: order.orderDetail.length,
                              itemBuilder: (context, index) {
                                Cart cartItem = order.orderDetail[index];
                                return ListTile(
                                  title: Text(cartItem.name,
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyLarge),
                                  subtitle: Text(
                                      'Quantity: ${cartItem.quantity} x NFT ${cartItem.price}',
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyMedium),
                                  trailing: Text(
                                      'Total: NFT ${cartItem.quantity * cartItem.price}',
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyMedium),
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

}

