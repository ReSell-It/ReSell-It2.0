import 'package:app_1/Screens/account_setting.dart';
import 'package:app_1/consts/consts.dart';
import 'package:app_1/models/userModel.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../models/ProductDetails.dart';
import '../models/nav.dart';
import '../widgets/tile.dart';
import 'homepage.dart';

class SellerProfile extends StatefulWidget {
  UserModel user;

  SellerProfile({Key? key, required this.user}) : super(key: key);

  @override
  State<SellerProfile> createState() => _SellerProfileState();
}

class _SellerProfileState extends State<SellerProfile> {
  Future<List<Products>>? productsFuture;

  @override
  void initState() {
    super.initState();
    productsFuture = getProducts();
  }

  Future<List<Products>> getProducts() async {
    String? uid = FirebaseAuth.instance.currentUser!.uid;
    List<Products> products = [];
    QuerySnapshot snapshot = await FirebaseFirestore.instance
        .collection('Products')
        .where('ProductSellerID', isEqualTo: widget.user!.uid)
        .get();
    snapshot.docs.forEach((element) {
      products.add(Products.fromMap(element.data() as Map<String, dynamic>));
    });
    return products;
  }

  // late Stream<QuerySnapshot> _stream;
  @override
  Widget build(BuildContext context) {
    String letter = widget.user.fullname!;
    String l = letter[0];
    return Scaffold(
      bottomNavigationBar: BottomAppBar(
        child: NavBar(),
      ),
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('Seller',
            style: TextStyle(
              color: Colors.brown,
              fontWeight: FontWeight.bold,
            )),
        actions: <Widget>[
          IconButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            AccountSetting(user: widget.user)));
              },
              color: kBrown,
              icon: Icon(Icons.settings))
        ],
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: Colors.brown),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(
            children: [
              CircleAvatar(
                radius: 50,
                backgroundColor: Colors.grey,
                child: Text(
                  l,
                  style: TextStyle(
                      // fontWeight: FontWeight.bold,
                      fontSize: 60,
                      color: Colors.white),
                ),
                //child: Icon(Icons.camera_alt, size: 30, color: Colors.white),
              ),
              SizedBox(width: 25),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                // ignore: prefer_const_literals_to_create_immutables
                children: [
                  //Name
                  Text(
                    widget.user.fullname!,
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(
                    height: 12,
                  ),
                  Text(
                    "Email:${widget.user.email!}",
                    style: TextStyle(
                      fontSize: 15,
                    ),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Text(
                    'Address:${widget.user.address!}',
                    style: TextStyle(
                      fontSize: 15,
                    ),
                  ),
                  //Address
                ],
              ),
            ],
          ),
          SizedBox(
            height: 30,
          ),
          const Text(
            "Items",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontStyle: FontStyle.italic,
              fontSize: 22,
              color: kBrown,
            ),
          ),
          ListDisplay(productsFuture),
        ]),
      ),
    );
  }

  FutureBuilder<List<Products>> ListDisplay(total) {
    return FutureBuilder(
      future: total,
      builder: (BuildContext context, AsyncSnapshot<List<Products>> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(),
          );
        } else if (snapshot.hasError) {
          return Center(
            child: Text(snapshot.error.toString()),
          );
        } else {
          List<Products> products = snapshot.data!;
          return Expanded(
            child: SizedBox(
              width: 350,
              child: ListView.builder(
                itemCount: products.length,
                itemBuilder: (BuildContext context, int index) {
                  return Tile(context,
                      product: products[index],
                      user: widget.user,
                      Action: 'Delete');
                },
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
              ),
            ),
          );
        }
      },
    );
  }
}

// class ProductWidget extends StatelessWidget {
//   String image;
//   String title;
//   String condition;
//   String price;
//   String sellername;
//   ProductWidget({
//     required this.condition,
//     required this.image,
//     required this.title,
//     required this.sellername,
//     required this.price,
//     super.key,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//         padding: EdgeInsets.all(12),
//         child: Container(
//           decoration: BoxDecoration(
//               borderRadius: BorderRadius.circular(12), color: Colors.white),
//           child: Row(
//             children: [
//               Container(
//                 height: 160,
//                 width: 200,
//                 child: Image.network(image),
//               ),
//               Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Container(
//                     height: 25,
//                     width: 130,
//                     color: Colors.grey[100],
//                     child: Text(title),
//                   ),
//                   SizedBox(
//                     height: 10,
//                   ),
//                   Container(
//                     height: 15,
//                     width: 90,
//                     color: Colors.grey[200],
//                     child: Text('Price : $price'),
//                   ),
//                   SizedBox(
//                     height: 10,
//                   ),
//                   Container(
//                     height: 20,
//                     width: 100,
//                     decoration: BoxDecoration(
//                         color: Colors.grey[200],
//                         borderRadius: BorderRadius.circular(12)),
//                     child: Text('Condition: $condition'),
//                   ),
//                   SizedBox(
//                     height: 10,
//                   ),
//                   Container(
//                     height: 15,
//                     width: 120,
//                     color: Colors.grey[200],
//                     child: Text('Seller: $sellername'),
//                   ),
//                 ],
//               )
//             ],
//           ),
//         ));
//   }
// }
