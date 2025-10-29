import 'package:coffee/utils/links.dart';
import 'package:coffee/views/splashScreen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart' show GetMaterialApp;
import 'package:get_storage/get_storage.dart';


Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await GetStorage.init();
  

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Donor App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
       
      ),
      //itialRoute: AppRouting.initialRoute,
     getPages: AppRouting.getPages,
      home: SplashScreen(),
      //home: CategoriesAdmin(),
     // home:ResetRequestPage (),
      debugShowCheckedModeBanner: false,
    );
  }
}
