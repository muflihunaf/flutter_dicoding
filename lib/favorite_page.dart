import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:restaurant_app/common/helper.dart';
import 'package:restaurant_app/data/model/favorite.dart';
import 'package:restaurant_app/provider/restoran_provider.dart';
import 'package:restaurant_app/restaurant_detail_page.dart';

class FavoritePage extends StatelessWidget {
  static const routeName = '/favorite_page';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Favorite"),
      ),
      body: Consumer<RestoranProvider>(
        builder: (context, favorite, _) {
          final _favorites = favorite.favorite;

          return ListView.builder(
            itemCount: _favorites.length,
            itemBuilder: (context, index) {
              final restoran = _favorites[index];
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  (index == 0) ? _header(context) : SizedBox(),
                  _buildRestaurantItem(context, restoran),
                ],
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildRestaurantItem(BuildContext context, Favorite restaurant) {
    return Card(
      elevation: 2,
      child: ListTile(
        onTap: () async {
          await Provider.of<RestoranProvider>(context, listen: false)
              .fetchADetailRestaurant(restaurant.id.toString());
          Navigator.pushNamed(
            context,
            DetailRestaurantPage.routeName,
          );
        },
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        leading: Hero(
          tag: Helper.getPict(restaurant.pictureId.toString()),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.network(
              Helper.getPict(restaurant.pictureId.toString()),
              fit: BoxFit.cover,
              width: 100,
            ),
          ),
        ),
        title: Text(
          restaurant.name.toString(),
          style: Theme.of(context).textTheme.bodyText1,
        ),
        subtitle: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.location_on,
                  size: 10,
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 5.0),
                  child: Text(restaurant.city.toString()),
                ),
              ],
            ),
            Row(
              children: [
                Icon(
                  Icons.star,
                  size: 10,
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 5.0),
                  child: Text(restaurant.rating.toString()),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _header(BuildContext context) {
    return Container(
        margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 25),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Restaurant",
                style: Theme.of(context)
                    .textTheme
                    .headline5!
                    .copyWith(fontSize: 32, fontWeight: FontWeight.w300)),
            Text(
              "Your Favorite Restaurant",
              style: Theme.of(context)
                  .textTheme
                  .bodyText1!
                  .copyWith(fontWeight: FontWeight.bold),
            ),
          ],
        ));
  }
}
