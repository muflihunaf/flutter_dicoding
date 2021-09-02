import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:restaurant_app/data/api/api_test.dart';
import 'package:restaurant_app/data/model/restoran_detail.dart';

import 'detail_test.mocks.dart';

// Generate a MockClient using the Mockito package.
// Create new instances of this class in each test.
@GenerateMocks([http.Client])
void main() {
  group('fetch Detail', () {
    test('fetch Detail', () async {
      final client = MockClient();

      // Use Mockito to return a successful response when it calls the
      // provided http.Client.
      when(client.get(Uri.parse(
              'https://restaurant-api.dicoding.dev/detail/rqdv5juczeskfw1e867')))
          .thenAnswer((_) async => http.Response(''' {
    "error": false,
    "message": "success",
    "restaurant": {
        "id": "rqdv5juczeskfw1e867",
        "name": "Melting Pot",
        "description": "Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Aenean commodo ligula eget dolor. Aenean massa. Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus. Donec quam felis, ultricies nec, pellentesque eu, pretium quis, sem. Nulla consequat massa quis enim. Donec pede justo, fringilla vel, aliquet nec, vulputate eget, arcu. In enim justo, rhoncus ut, imperdiet a, venenatis vitae, justo. Nullam dictum felis eu pede mollis pretium. Integer tincidunt. Cras dapibus. Vivamus elementum semper nisi. Aenean vulputate eleifend tellus. Aenean leo ligula, porttitor eu, consequat vitae, eleifend ac, enim. Aliquam lorem ante, dapibus in, viverra quis, feugiat a, tellus. Phasellus viverra nulla ut metus varius laoreet.",
        "city": "Medan",
        "address": "Jln. Pandeglang no 19",
        "pictureId": "14",
        "categories": [
            {
                "name": "Italia"
            },
            {
                "name": "Modern"
            }
        ],
        "menus": {
            "foods": [
                {
                    "name": "Paket rosemary"
                },
                {
                    "name": "Toastie salmon"
                },
                {
                    "name": "Bebek crepes"
                },
                {
                    "name": "Salad lengkeng"
                }
            ],
            "drinks": [
                {
                    "name": "Es krim"
                },
                {
                    "name": "Sirup"
                },
                {
                    "name": "Jus apel"
                },
                {
                    "name": "Jus jeruk"
                },
                {
                    "name": "Coklat panas"
                },
                {
                    "name": "Air"
                },
                {
                    "name": "Es kopi"
                },
                {
                    "name": "Jus alpukat"
                },
                {
                    "name": "Jus mangga"
                },
                {
                    "name": "Teh manis"
                },
                {
                    "name": "Kopi espresso"
                },
                {
                    "name": "Minuman soda"
                },
                {
                    "name": "Jus tomat"
                }
            ]
        },
        "rating": 4.2,
        "customerReviews": [
            {
                "name": "Ahmad",
                "review": "Tidak rekomendasi untuk pelajar!",
                "date": "13 November 2019"
            },
            {
                "name": "nyoba",
                "review": "Isi Content test e2e",
                "date": "2 September 2021"
            },
            {
                "name": "nyoba juga",
                "review": "a",
                "date": "2 September 2021"
            },
            {
                "name": "s",
                "review": "s",
                "date": "2 September 2021"
            },
            {
                "name": "sa",
                "review": "s",
                "date": "2 September 2021"
            },
            {
                "name": "ae",
                "review": "a",
                "date": "2 September 2021"
            },
            {
                "name": "dia",
                "review": "ec",
                "date": "2 September 2021"
            },
            {
                "name": "123",
                "review": "12",
                "date": "2 September 2021"
            },
            {
                "name": "yeay",
                "review": "test",
                "date": "2 September 2021"
            },
            {
                "name": "test",
                "review": "yeay",
                "date": "2 September 2021"
            }
        ]
    }
} ''', 200));

      expect(await TestApi.detailRestoran("rqdv5juczeskfw1e867", client),
          isA<RestaurantDetail>());
    });

    test('Jika Gagal', () {
      final client = MockClient();
      when(client
              .get(Uri.parse('https://restaurant-api.dicoding.dev/detail/1')))
          .thenAnswer((_) async => http.Response(''' {
    "error": true,
    "message": "not found",
    "restaurant": null
}''', 400));

      expect(TestApi.detailRestoran("1", client), throwsException);
    });
  });
}
