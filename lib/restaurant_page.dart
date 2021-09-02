import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:restaurant_app/common/helper.dart';

import 'package:restaurant_app/provider/restoran_provider.dart';
import 'package:restaurant_app/restaurant_detail_page.dart';
import 'package:restaurant_app/serach_page.dart';

import 'data/model/restoran.dart';

class RestaurantListPage extends StatelessWidget {
  static const routeName = '/restaurant_list';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Restaurant List"),
        actions: [
          GestureDetector(
            onTap: () {
              Navigator.pushNamed(context, SearchPage.routeName);
            },
            child: Container(
                margin: EdgeInsets.only(right: 30), child: Icon(Icons.search)),
          ),
        ],
      ),
      body: Consumer<RestoranProvider>(builder: (context, restoran, _) {
        if (ResultState.HasData == restoran.state) {
          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _header(context),
                ...restoran.result!.restaurants!
                    .map((e) => _buildRestaurantItem(context, e))
              ],
            ),
          );
        } else {
          if (ResultState.Loading == restoran.state) {
            return Center(
              child: CircularProgressIndicator(
                color: Colors.blue,
              ),
            );
          } else {
            return Center(
              child: Text(restoran.message),
            );
          }
        }
      }),
    );
  }

  Widget _buildRestaurantItem(
      BuildContext context, RestaurantElement restaurant) {
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
              "Recommendation Restaurant For you",
              style: Theme.of(context)
                  .textTheme
                  .bodyText1!
                  .copyWith(fontWeight: FontWeight.bold),
            ),
          ],
        ));
  }
}
