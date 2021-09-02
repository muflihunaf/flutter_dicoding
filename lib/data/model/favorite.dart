class Favorite {
  Favorite({
    this.id,
    this.name,
    this.description,
    this.city,
    this.pictureId,
    this.rating,
  });

  String? id;
  String? name;
  String? description;
  String? city;

  String? pictureId;

  double? rating;

  Favorite.fromMap(Map<String, dynamic> map) {
    id = map['id'];
    name = map['name'];
    description = map['description'];
    city = map['city'];
    pictureId = map['pictureId'];
    rating = map['rating'];
  }

  Map<String, dynamic> toMap() => {
        "id": id,
        "name": name,
        "description": description,
        "city": city,
        "pictureId": pictureId,
        "rating": rating,
      };
}
