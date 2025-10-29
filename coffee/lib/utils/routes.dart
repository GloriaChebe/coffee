

import 'package:coffee/views/aboutUs.dart';
import 'package:coffee/views/login.dart';
import 'package:coffee/views/register.dart';
import 'package:coffee/views/splashScreen.dart';
import 'package:get/get.dart';

class Pages {
  static const String splash = '/splash';
  static const String signUp = '/signUp';
  static const String login = '/login';
  static const String homepage = '/homepage';
  static const String contactUs='/contactUs';
   static const String about = '/about';
  // static const String status = '/status';
  // static const String profile = '/profile';
  // static const String admin = '/admin';
  // static const String manageUsers = '/manageUsers';
  // static const String manageDonations= '/manageDonations';
  // static const String manageWallet= '/manageWallet';

  // static const String contactUs= '/contactUs';
  // static const String categoriesAdmin= '/categoriesAdmin';
  // static const String profileDetails= '/profileDetails';
  

  static final routes = [
    GetPage(name: splash, page: () => SplashScreen()),
    GetPage(name: signUp, page: () => RegistrationPage()),
     GetPage(name: login, page: () => LoginPage()),
    //  GetPage(name: homepage, page: () => HomePage()),
      //GetPage(name: contactUs, page: () => ContactUsPage()),
     GetPage(name: about, page: () => AboutUsPage()),
    //  GetPage(name: status, page: () => Statuspage()),
    //  GetPage(name: profile, page: () => ProfilePage()),
    //  GetPage(name: admin, page: () => AdminPage()),
    //  GetPage(name: manageDonations, page: () => ManageDonationsPage()),
    //  GetPage(name: manageUsers, page: () => ManageUsersPage()),
    //  GetPage(name: manageWallet, page: () => ManageWalletPage()),
    
    //  GetPage(name: contactUs, page: () => ContactUsPage()),
    //  GetPage(name: categoriesAdmin, page: () => CategoriesAdmin()),
    //   GetPage(name: profileDetails, page: () => ProfileDetailsPage()),
   
    
  ];
}
