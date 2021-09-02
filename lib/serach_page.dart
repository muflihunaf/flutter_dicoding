import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:restaurant_app/data/model/restaurant_search.dart';
import 'package:restaurant_app/provider/restoran_provider.dart';
import 'package:restaurant_app/restaurant_detail_page.dart';

import 'common/helper.dart';

class SearchPage extends StatefulWidget {
  static const routeName = '/serach_page';

  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  TextEditingController _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Provider.of<RestoranProvider>(context, listen: false)
            .fetchAllRestaurant();
        Navigator.pop(context);
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text("Search Restaurant"),
        ),
        body: Consumer<RestoranProvider>(builder: (context, restoran, _) {
          if (ResultState.Found == restoran.state) {
            return SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _header(context),
                  ...restoran.resultSearch!.restaurants!
                      .map((e) => _buildRestaurantItem(context, e))
                ],
              ),
            );
          } else {
            if (ResultState.NotFound == restoran.state) {
              return Center(
                child: Column(
                  children: [
                    _header(context),
                    Text(restoran.message),
                  ],
                ),
              );
            } else if (ResultState.Loading == restoran.state) {
              return Center(
                child: CircularProgressIndicator(
                  color: Colors.blue,
                ),
              );
            } else {
              return Center(
                child: Column(
                  children: [
                    _header(context),
                    Text(restoran.message),
                  ],
                ),
              );
            }
          }
        }),
      ),
    );
  }

  Widget _buildRestaurantItem(BuildContext context, Restaurant restaurant) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 10),
      child: Card(
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
            Text("Search",
                style: Theme.of(context)
                    .textTheme
                    .headline5!
                    .copyWith(fontSize: 28, fontWeight: FontWeight.w300)),
            Container(
                margin: EdgeInsets.symmetric(horizontal: 10, vertical: 12),
                color: Colors.white,
                child: TextFormField(
                  controller: _controller,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderSide: BorderSide(width: 1, color: Colors.white),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    suffixIcon: Icon(Icons.search_outlined),
                  ),
                  onEditingComplete: () {
                    Provider.of<RestoranProvider>(context, listen: false)
                        .searchRestaurant(_controller.text.toString());
                    print(_controller.text);
                  },
                )),
          ],
        ));
  }
}
