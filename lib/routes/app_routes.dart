
import 'package:watch_hub/screens/about_us.dart';
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

class PageRoutes{
  static const String loginPage = LoginPage.routeName;
  static const String registerPage = RegisterPage.routeName;
  static const String addProductPage = AddProductPage.routeName;
  static const String wishListPage = WishListPage.routeName;
  static const String homePage = HomePage.routeName;
  static const String adminHomePage = AdminHomePage.routeName;
  static const String productPage = ProductPage.routeName;
  static const String mngCartPage = MngCartPage.routeName;
  static const String mngOrderPage = OrderPage.routeName;
  static const String aboutus= AboutUsPage.routeName;
  static String adminProduct= ProductListScreen.routeName;
}