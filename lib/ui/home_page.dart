import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:provider/provider.dart';
import '/common/styles.dart';
import '/data/api/api_service.dart';
import '/data/model/restaurant.dart';
import '/provider/restaurant_provider.dart';
import '/ui/restaurant_detail_page.dart';
import '/util/enums.dart';
import '/widget/error_text.dart';

class HomePage extends StatefulWidget {
  static const routeName = "/restaurant_list_page";

  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String _searchText = "";
  Timer? _debounce;

  void _onSearchChanged(String query, RestaurantProvider provider) {
    if (_debounce?.isActive ?? false) {
      _debounce?.cancel();
    }
    _debounce = Timer(const Duration(milliseconds: 500), () {
      if (query.isEmpty) {
        provider.fetchAllRestaurant();
      } else if (_searchText != query) {
        _searchText = query;
        provider.searchRestaurant(_searchText);
      }
    });
  }

  @override
  void dispose() {
    _debounce?.cancel();
    super.dispose();
  }

  Widget _header(BuildContext context, RestaurantProvider provider) {
    return Container(
      decoration: const BoxDecoration(
          color: primaryColor,
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(15))),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(
                height: 24,
              ),
              const Text(
                "Discover",
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w400,
                    color: Colors.white),
              ),
              const Text(
                "Dimas Restaurant",
                style: TextStyle(
                    fontSize: 49,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
              ),
              const SizedBox(
                height: 8,
              ),
              Container(
                padding: const EdgeInsets.all(5),
                decoration: BoxDecoration(
                    color: primaryLightColor,
                    borderRadius: BorderRadius.circular(15)),
                child: TextField(
                  onChanged: (text) => _onSearchChanged(text, provider),
                  textAlignVertical: TextAlignVertical.center,
                  style:
                      Theme.of(context).textTheme.bodyText2?.merge(textWhite),
                  decoration: const InputDecoration(
                      border: InputBorder.none,
                      prefixIcon: Icon(
                        Icons.search,
                        color: Colors.white,
                      ),
                      hintText: "Search.....",
                      hintStyle: TextStyle(color: Colors.white, fontSize: 15)),
                ),
              ),
              const SizedBox(
                height: 8,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _restaurantGrid(BuildContext context, RestaurantProvider state) {
    switch (state.state) {
      case ResultState.loading:
        return const Center(child: CircularProgressIndicator());
      case ResultState.hasData:
        {
          var restaurants = state.result;

          return GridView.count(
            crossAxisCount: 2,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            crossAxisSpacing: 16.0,
            mainAxisSpacing: 16.0,
            children: List.generate(restaurants!.length,
                (index) => _restaurantItem(context, restaurants[index]!)),
          );
        }
      case ResultState.noData:
      case ResultState.error:
        return ErrorText(errorMessage: state.message);
      default:
        return const Center(child: Text(''));
    }
  }

  Widget _restaurantItem(BuildContext context, Restaurant restaurant) {
    double starSize = MediaQuery.of(context).size.width * 0.03;

    return InkWell(
      borderRadius: const BorderRadius.all(Radius.circular(15)),
      onTap: () => Navigator.pushNamed(context, RestaurantDetailPage.routeName,
          arguments: restaurant),
      child: ClipRRect(
        borderRadius: const BorderRadius.all(Radius.circular(15)),
        child: GridTile(
          header: GridTileBar(
            leading: const CircleAvatar(
              radius: 16,
              backgroundColor: primaryLightColor,
              child: Icon(
                Icons.restaurant_menu,
                color: primaryColor,
              ),
            ),
            title: Text(restaurant.name,
                style:
                    Theme.of(context).textTheme.bodyMedium?.merge(textWhite)),
            subtitle: Text(restaurant.city ?? "-",
                style: Theme.of(context).textTheme.bodySmall?.merge(textWhite)),
          ),
          footer: GridTileBar(
            title: RatingBar.builder(
              initialRating: restaurant.rating ?? 0,
              ignoreGestures: true,
              minRating: 1,
              direction: Axis.horizontal,
              allowHalfRating: true,
              itemCount: 5,
              itemSize: starSize,
              itemPadding: const EdgeInsets.symmetric(horizontal: 1.0),
              itemBuilder: (context, _) => const Icon(
                Icons.star,
                color: secondaryLightColor,
              ),
              onRatingUpdate: (rating) {},
            ),
          ),
          child: Hero(
            tag: restaurant.id,
            child: Stack(children: [
              Positioned.fill(
                child: Image.network(
                  ApiServiceHttpClient()
                      .picture(restaurant.pictureId!, PictureSize.small),
                  fit: BoxFit.cover,
                ),
              ),
              Container(
                color: Colors.black.withOpacity(0.6),
              )
            ]),
          ),
        ),
      ),
    );
  }

  Widget _android(BuildContext context) {
    return Scaffold(
      backgroundColor: primaryLightColor,
      body: ChangeNotifierProvider<RestaurantProvider>(
        create: (context) => RestaurantProvider(api: ApiServiceHttpClient()),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Consumer<RestaurantProvider>(
                builder: ((context, provider, _) =>
                    _header(context, provider))),
            Consumer<RestaurantProvider>(
                builder: ((context, state, _) =>
                    Expanded(child: _restaurantGrid(context, state)))),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return _android(context);
  }
}
