import 'package:flutter/material.dart';
import 'data/model/restaurant.dart';
import 'ui/add_review_page.dart';
import 'ui/home_page.dart';
import 'ui/restaurant_detail_page.dart';
import 'common/styles.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Restaurant Dimas",
      theme: ThemeData(
          scaffoldBackgroundColor: Colors.white,
          visualDensity: VisualDensity.adaptivePlatformDensity,
          textTheme: textTheme,
          appBarTheme: const AppBarTheme(elevation: 0),
          elevatedButtonTheme: ElevatedButtonThemeData(
              style: ElevatedButton.styleFrom(
                  backgroundColor: secondaryColor,
                  foregroundColor: Colors.white,
                  textStyle: const TextStyle(),
                  shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(0)))))),
      initialRoute: HomePage.routeName,
      routes: {
        HomePage.routeName: ((context) => const HomePage()),
        RestaurantDetailPage.routeName: ((context) => RestaurantDetailPage(
              restaurant:
                  ModalRoute.of(context)?.settings.arguments as Restaurant,
            )),
        AddReviewPage.routeName: ((context) => AddReviewPage(
            restaurantId:
                ModalRoute.of(context)?.settings.arguments as String)),
      },
    );
  }
}
