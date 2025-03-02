import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:watch_hub/firebase_options.dart';
import 'package:watch_hub/pages/splash_page.dart';
import 'package:watch_hub/routes/app_routes.dart';
import 'package:watch_hub/screens/About_us.dart';
import 'package:watch_hub/screens/add_product_page.dart';
import 'package:watch_hub/screens/admin_home_page.dart';
import 'package:watch_hub/screens/admin_product_page.dart';
import 'package:watch_hub/screens/home_page.dart';
import 'package:watch_hub/screens/login_page.dart';
import 'package:watch_hub/screens/mng_cart_page.dart';
import 'package:watch_hub/screens/order_page.dart';
import 'package:watch_hub/screens/product_page.dart';
import 'package:watch_hub/screens/register_page.dart';
import 'package:watch_hub/screens/wish_list_page.dart';

void main () async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  runApp(const SnapApp());
}

class SnapApp extends StatelessWidget {
  const SnapApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Watch Hub",
      home: const SplashPage(),
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: Colors.grey[900],
        textTheme: const TextTheme(
          titleMedium: TextStyle(fontFamily: "Nunito", color: Color.fromARGB(255, 253, 229, 253)),
          bodyMedium:  TextStyle(fontFamily: "Nunito", color: Color.fromARGB(255, 253, 229, 253)),
          titleLarge:  TextStyle(fontFamily: "Nunito", color: Color.fromARGB(255, 253, 229, 253)),
          bodyLarge:  TextStyle(fontFamily: "Nunito", color: Color.fromARGB(255, 253, 229, 253)),
        ),
          elevatedButtonTheme: ElevatedButtonThemeData(
              style: ButtonStyle(
                foregroundColor:
                WidgetStateProperty.resolveWith<Color>((Set<WidgetState> states) {
                  if (states.contains(WidgetState.pressed)) {
                    return const Color.fromARGB(84, 233, 30, 98);
                  } else if (states.contains(WidgetState.hovered)) {
                    return Colors.black;
                  }
                  return const Color.fromARGB(255, 47, 66, 172); // Defer to the widget's default.
                }),
                backgroundColor:
                WidgetStateProperty.resolveWith<Color>((Set<WidgetState> states) {
                  if (states.contains(WidgetState.pressed)) {
                    return Colors.black;
                  } else if (states.contains(WidgetState.hovered)) {
                    return Colors.white;
                  }
                  return const Color.fromARGB(255, 47, 66, 172); // Defer to the widget's default.
                }),

              )),
          inputDecorationTheme: InputDecorationTheme(
            filled: true,

            fillColor: Colors.black.withOpacity(0.4),
            hintStyle:
            const TextStyle(color: Color.fromARGB(255, 255, 254, 255), fontFamily: "Nunito"),
            border: const OutlineInputBorder(),
            errorStyle:
            const TextStyle(color: Color.fromARGB(255, 255, 255, 255), fontFamily: "Nunito"),
            labelStyle:
            const TextStyle(color: Color.fromARGB(255, 255, 255, 255), fontFamily: "Nunito"),
            counterStyle: const TextStyle(
                color: Color.fromARGB(255, 255, 255, 255), fontSize: 12.0, fontFamily: "Nunito"),
          ),
        appBarTheme: AppBarTheme(
          color: const Color.fromARGB(255, 0, 0, 0),
          titleTextStyle:const TextStyle(fontFamily: "Nunito", color: Color.fromARGB(
              255, 47, 66, 172))
        )
      ),
      routes: {
        PageRoutes.addProductPage:(context)=>const AddProductPage(),
        PageRoutes.loginPage:(context)=>const LoginPage(),
        PageRoutes.wishListPage:(context)=>const WishListPage(),
        PageRoutes.registerPage:(context)=>const RegisterPage(),
        PageRoutes.homePage:(context)=>const HomePage(),
        PageRoutes.adminHomePage:(context)=>const AdminHomePage(),
        PageRoutes.productPage:(context)=>const ProductPage(),
        PageRoutes.mngCartPage:(context)=>const MngCartPage(),
        PageRoutes.mngOrderPage:(context)=> const OrderPage(),
        PageRoutes.aboutus:(context)=> const AboutUsPage(),
        PageRoutes.adminProduct: (context) => const ProductListScreen(),
      },
    );
  }
}
