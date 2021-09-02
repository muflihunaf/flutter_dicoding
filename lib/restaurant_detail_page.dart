import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:restaurant_app/common/helper.dart';
import 'package:restaurant_app/data/model/favorite.dart';
import 'package:restaurant_app/data/model/restoran_detail.dart';
import 'package:restaurant_app/provider/restoran_provider.dart';

class DetailRestaurantPage extends StatefulWidget {
  static const routeName = '/detail_restaurant';

  @override
  _DetailRestaurantPageState createState() => _DetailRestaurantPageState();
}

class _DetailRestaurantPageState extends State<DetailRestaurantPage> {
  var isFavorite;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Detail Restoran"),
      ),
      body: Consumer<RestoranProvider>(
        builder: (context, detail, _) {
          isFavorite = detail.favor;
          if (detail.state == ResultState.HasData) {
            return Container(
              child: CustomScrollView(
                slivers: [
                  SliverList(
                    delegate: SliverChildListDelegate(
                      [
                        _header(Helper.getPict(detail
                            .restaurantDetail!.restaurant!.pictureId
                            .toString())),
                      ],
                    ),
                  ),
                  SliverToBoxAdapter(
                    child: _body(context, detail.restaurantDetail!.restaurant!,
                        detail.favor!),
                  ),
                  SliverToBoxAdapter(
                    child: Container(
                      margin: EdgeInsets.only(left: 15),
                      child: Text(
                        "Makanan",
                        style: Theme.of(context).textTheme.headline6,
                      ),
                    ),
                  ),
                  SliverGrid.count(
                    children: detail.restaurantDetail!.restaurant!.menus!.foods!
                        .map((e) => _cardItem(context, e.name!, 'Makanan'))
                        .toList(),
                    crossAxisCount: 3,
                  ),
                  SliverToBoxAdapter(
                    child: Container(
                      margin: EdgeInsets.only(left: 15, top: 10),
                      child: Text(
                        "Minuman",
                        style: Theme.of(context).textTheme.headline6,
                      ),
                    ),
                  ),
                  SliverGrid.count(
                    crossAxisCount: 3,
                    children: detail.restaurantDetail!.restaurant!.menus!.foods!
                        .map((e) => _cardItem(context, e.name!, 'Minuman'))
                        .toList(),
                  ),
                  SliverToBoxAdapter(
                    child: Container(
                      margin: EdgeInsets.only(left: 15),
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Review",
                              style: Theme.of(context).textTheme.headline6,
                            ),
                            SizedBox(
                              height: 10,
                            )
                          ]),
                    ),
                  ),
                  SliverGrid.count(
                    crossAxisCount: 1,
                    childAspectRatio: 1.5,
                    children: detail
                        .restaurantDetail!.restaurant!.customerReviews!
                        .map((e) => _cardView(context, e))
                        .toList(),
                  ),
                ],
              ),
            );
          } else {
            return Center(
              child: CircularProgressIndicator(
                color: Colors.blue,
              ),
            );
          }
        },
      ),
    );
  }

  Widget _header(String picture) {
    return Hero(
      tag: picture,
      child: ClipRRect(
        borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(20), bottomRight: Radius.circular(20)),
        child: Image.network(picture),
      ),
    );
  }

  Widget _body(BuildContext context, Restaurant restaurantElement,
      List<String> isFavorite) {
    return Padding(
      padding: EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                restaurantElement.name.toString(),
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 24,
                ),
              ),
              (!isFavorite.contains(restaurantElement.id))
                  ? GestureDetector(
                      onTap: () {
                        final _favorite = Favorite(
                          id: restaurantElement.id,
                          name: restaurantElement.name,
                          description: restaurantElement.description,
                          city: restaurantElement.city,
                          pictureId: restaurantElement.pictureId,
                          rating: restaurantElement.rating,
                        );
                        Provider.of<RestoranProvider>(context, listen: false)
                            .addFavorite(_favorite);
                      },
                      child: Icon(
                        Icons.favorite,
                        color: Colors.black,
                      ))
                  : GestureDetector(
                      onTap: () {
                        Provider.of<RestoranProvider>(context, listen: false)
                            .deleteFavorite(restaurantElement.id!);
                      },
                      child: Icon(Icons.favorite, color: Colors.yellow)),
            ],
          ),
          Row(
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 3.0),
                child: Icon(
                  Icons.location_on,
                  size: 10,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 5.0),
                child: Text(restaurantElement.city.toString()),
              ),
            ],
          ),
          Divider(
            color: Colors.grey,
          ),
          Text(
            restaurantElement.description.toString(),
            style: Theme.of(context).textTheme.caption,
          ),
          SizedBox(
            height: 10,
          ),
          Divider(
            color: Colors.grey,
          ),
        ],
      ),
    );
  }

  Widget _cardItem(BuildContext context, String name, String type) {
    return Card(
      elevation: 2,
      child: Container(
        height: 100.0,
        margin: EdgeInsets.all(8),
        padding: EdgeInsets.only(left: 3, top: 5),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
        ),
        alignment: Alignment.bottomLeft,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Expanded(
              child: Image.network(
                (type == 'Makanan')
                    ? 'https://images.unsplash.com/photo-1504674900247-0877df9cc836?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=750&q=80'
                    : 'https://images.unsplash.com/photo-1496318447583-f524534e9ce1?ixid=MnwxMjA3fDB8MHxzZWFyY2h8MjR8fGRyaW5rfGVufDB8fDB8fA%3D%3D&ixlib=rb-1.2.1&auto=format&fit=crop&w=500&q=60',
                fit: BoxFit.cover,
              ),
            ),
            Text(
              name,
              style: Theme.of(context).textTheme.subtitle1,
            ),
            SizedBox(
              height: 5,
            ),
            Text(
              'Rp.12.500',
              style: Theme.of(context).textTheme.caption,
            ),
          ],
        ),
      ),
    );
  }

  Widget _cardView(BuildContext context, CustomerReview reviews) {
    return Container(
      child: Card(
        margin: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        elevation: 2,
        child: Container(
          margin: EdgeInsets.all(8),
          padding: EdgeInsets.only(left: 3, top: 5),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Center(
                child: CircleAvatar(
                  radius: 25,
                  child: Icon(
                    Icons.person_outline,
                  ),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Flexible(
                    child: Text(
                      reviews.name!,
                      style: Theme.of(context).textTheme.subtitle1,
                      overflow: TextOverflow.visible,
                      maxLines: 1,
                    ),
                  ),
                  Flexible(
                    child: Text(
                      reviews.date!,
                      style: Theme.of(context).textTheme.subtitle2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 5,
              ),
              Text(
                reviews.review!,
                style: Theme.of(context).textTheme.caption,
                overflow: TextOverflow.ellipsis,
                maxLines: 7,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
