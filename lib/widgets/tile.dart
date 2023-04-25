// ignore_for_file: non_constant_identifier_names, prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:app_1/Screens/itemview.dart';
import 'package:app_1/models/ProductDetails.dart';
import 'package:app_1/models/chatRoomModel.dart';
import 'package:app_1/models/firebaseHelper.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../Screens/chatRoom.dart';
import '../models/userModel.dart';

//TODO:Provide Context as to use Navigation

//Tile that is Shown in The Homepage
//Takes in instance of Prdouct Details as an argument
//Navigates to Product Details Page
Tile(context,
    {required Products product, required user, required String? Action}) {
  String NAME = product.ProductName!;
  String PRICE = product.ProductPrice!;
  String targetUser = product.ProductSellerID!;
  String DESCRIPTION = product.ProductDescription!.length > 20
      ? '${product.ProductDescription!.substring(0, 20)}...'
      : product.ProductDescription!;
  String? IMAGE = product.ProductImage;
  return Padding(
    padding: EdgeInsets.all(7),
    child: InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) =>
                  ItemView(product: product, performThis: Action)),
        );
      },
      child: Container(
        decoration: BoxDecoration(
            color: Color.fromARGB(255, 249, 254, 249),
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Color.fromARGB(255, 178, 178, 178),
                blurRadius: 3,
                offset: Offset(0, 7),
              ),
            ]),
        height: 196,
        width: 350,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            //Image
            SizedBox(
              height: 155,
              width: 160,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(32),
                child: Image.network(
                  IMAGE!,
                  scale: 1,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            //Information
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                //Name
                Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: SizedBox(
                    child: Text(
                      NAME,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Color.fromARGB(255, 4, 9, 35),
                      ),
                    ),
                  ),
                ),

                //Description
                SizedBox(
                  height: 60,
                  width: 150,
                  child: Text(
                    DESCRIPTION,
                  ),
                ),
                //Price
                Text(
                  'Nrs.$PRICE',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                //Call Buttons
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    CircleAvatar(
                      maxRadius: 15,
                      child: IconButton(
                        onPressed: () async {
                          UserCredential? credential;
                          User firebaseUser = credential!.user!;
                          //TODO::FROM HERE
                          UserModel? targetUserModel =
                              await FirebaseHelper.getUserModelById(targetUser);
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) {
                              return ChatPage(
                                // chatRoom: widget.chatRoomModel,
                                firebaseUser: firebaseUser,
                                userModel: user,
                                targetUser: targetUserModel!,
                                chatRoom: ChatRoomModel(
                                  chatRoomId: '12345678',
                                  participants: {
                                    user.uid!: 'fyughsDAJKFWHEGJDSBADJF',
                                    targetUserModel.uid!:
                                        'wZt6BsjNEASPmb78Gd1gX2b23JE2'
                                  },
                                  lastMessage: 'Hello',
                                ),
                              );
                            }),
                          );
                          print('MESSAGE');
                        },
                        icon: Icon(
                          Icons.message,
                          size: 15,
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 20,
                    ),
                    CircleAvatar(
                      maxRadius: 15,
                      child: IconButton(
                        onPressed: () {
                          print('FAVOURITE');
                        },
                        icon: Icon(
                          Icons.favorite,
                          size: 15,
                        ),
                      ),
                    ),
                  ],
                )
              ],
            )
          ],
        ),
      ),
    ),
  );
}
