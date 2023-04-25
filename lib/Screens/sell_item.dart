import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cross_file_image/cross_file_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../models/firebaseHelper.dart';
import '../models/productModel.dart';
import '../models/userModel.dart';

class SellItem extends StatefulWidget {
  final User? firebaseUser;

  const SellItem({super.key, this.firebaseUser});

  // final String? uid;

 

  @override
  State<SellItem> createState() => _SellItemState();
}

class _SellItemState extends State<SellItem> {
  TextEditingController description = TextEditingController();
  TextEditingController price = TextEditingController();
  TextEditingController itemName = TextEditingController();
  String? condition = 'used';
  bool clickNew = false;
  bool clickUsed = true;

//image and cloud storage section

  XFile? _image;
  final ImagePicker _picker = ImagePicker();
  String imageUrl = '';

  final List<String> _categoryList = <String>[
    "Mobile",
    "Stationary",
    "Grocery",
    "Vehicle"
  ];
  String _category = 'Mobile';

  final List<String> _location = <String>["Kathmandu", "Lalitpur", "Bhaktapur"];
  String _choosedLocation = 'Kathmandu';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: const Text('Item Details',
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
              )),
          backgroundColor: Colors.white,
          elevation: 0,
          leading: IconButton(
            color: Colors.black,
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          centerTitle: true,
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: 152,
                  width: double.infinity,
                  decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(10)),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              height: 90,
                              width: 95,
                              decoration: BoxDecoration(
                                  color: Colors.grey[400],
                                  borderRadius: BorderRadius.circular(10)),
                              child: _image == null
                                  ? const Icon(Icons.cancel)
                                  : Image(
                                      image: XFileImage(_image!),
                                      height: 300,
                                      width: 300,
                                    ),
                            ),
                            const SizedBox(width: 10),
                            Container(
                              height: 95,
                              width: 95,
                              decoration: BoxDecoration(
                                  color: Colors.grey[400],
                                  borderRadius: BorderRadius.circular(10)),
                              child: IconButton(
                                  onPressed: () {
                                    _showImageSourceDialog();
                                  },
                                  icon: const Icon(Icons.add)),
                            ),
                          ],
                        ),
                        const SizedBox(height: 9),
                        _image == null
                            ? const Text('')
                            : InkWell(
                                onTap: () async {
                                  if (_image == null) return;
                                  //getting reference to storage root
                                  Reference referenceRoot =
                                      FirebaseStorage.instance.ref();
                                  Reference referenceDirImages =
                                      referenceRoot.child('images');

                                  //reference for the images to be stored
                                  String uniqueFileName = DateTime.now()
                                      .millisecondsSinceEpoch
                                      .toString();
                                  Reference referenceImageToUpload =
                                      referenceDirImages.child(uniqueFileName);

                                  //Store the file
                                  try {
                                    await referenceImageToUpload
                                        .putFile(File(_image!.path));

                                    //get the url of the image
                                    imageUrl = await referenceImageToUpload
                                        .getDownloadURL();

                                    //!find out the user model and update the image url
                                    //!in the user model
                                    //!then update the user model in the database
                                  } catch (error) {}
                                },
                                child: const Text('Click here to upload image')),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                const Text('Item name*',
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    )),
                const SizedBox(height: 10),
                Container(
                  height: 50,
                  width: double.infinity,
                  decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(10)),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: TextField(
                      controller: itemName,
                      decoration:
                          const InputDecoration.collapsed(hintText: 'Item name'),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                const Text('Category*',
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    )),
                const SizedBox(height: 10),
                Container(
                  height: 50,
                  width: double.infinity,
                  decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(10)),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton(
                          isExpanded: true,
                          value: _category,
                          items: _categoryList
                              .map((e) => DropdownMenuItem(
                                    value: e,
                                    child: Text(e),
                                  ))
                              .toList(),
                          onChanged: (val) {
                            setState(() {
                              _category = val.toString();
                            });
                          }),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                const Text('Description',
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    )),
                const SizedBox(height: 10),
                Container(
                  height: 95,
                  width: double.infinity,
                  decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(10)),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: TextField(
                      controller: description,
                      decoration:
                          const InputDecoration.collapsed(hintText: 'Description'),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                const Text('Condition*',
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    )),
                const SizedBox(height: 10),
                Row(
                  children: [
                    TextButton(
                        style: ButtonStyle(
                          backgroundColor: (clickNew == false)
                              ? MaterialStateProperty.all(Colors.grey[300])
                              : MaterialStateProperty.all(Colors.green[200]),
                        ),
                        onPressed: () {
                          setState(() {
                            condition = 'New';
                            clickNew = !clickNew;
                            clickUsed = !clickUsed;
                          });
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            'New',
                            style: TextStyle(
                              color: (clickNew == true)
                                  ? Colors.black
                                  : Colors.grey,
                              fontSize: 17,
                            ),
                          ),
                        )),
                    const SizedBox(
                      width: 10,
                    ),
                    TextButton(
                        style: ButtonStyle(
                          backgroundColor: (clickUsed == false)
                              ? MaterialStateProperty.all(Colors.grey[300])
                              : MaterialStateProperty.all(Colors.green[200]),
                        ),
                        onPressed: () {
                          setState(() {
                            clickUsed = !clickUsed;
                            clickNew = !clickNew;
                            condition = 'Used';
                          });
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            'Used',
                            style: TextStyle(
                              color: (clickUsed == false)
                                  ? Colors.grey
                                  : Colors.black,
                              fontSize: 17,
                            ),
                          ),
                        )),
                  ],
                ),
                const SizedBox(height: 16),
                const Text('Price*',
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    )),
                const SizedBox(height: 10),
                Container(
                  height: 50,
                  width: double.infinity,
                  decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(10)),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: TextField(
                      controller: price,
                      decoration: const InputDecoration.collapsed(hintText: 'Price'),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                const Text('Location*',
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    )),
                const SizedBox(height: 10),
                Container(
                  height: 50,
                  width: double.infinity,
                  decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(10)),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton(
                          isExpanded: true,
                          value: _choosedLocation,
                          items: _location
                              .map((e) => DropdownMenuItem(
                                    value: e,
                                    child: Text(e),
                                  ))
                              .toList(),
                          onChanged: (val) {
                            setState(() {
                              _choosedLocation = val.toString();
                            });
                          }),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Container(
                  height: 50,
                  width: double.infinity,
                  decoration: BoxDecoration(
                      color: Colors.amber,
                      borderRadius: BorderRadius.circular(10)),
                  child: TextButton(
                      onPressed: () async {
                        Random random = Random.secure();
                        String? pid = random.nextInt(5000).toString();
                        UserModel? SellerName =
                            await FirebaseHelper.getUserModelById(
                                widget.firebaseUser!.uid);
                        String? uid = widget.firebaseUser?.uid;
                        ProductModel productModel = ProductModel(
                          sellername: SellerName!.fullname,
                          imageurl: imageUrl,
                          itemName: itemName.text.toString(),
                          category: _category,
                          description: description.text.toString(),
                          condition: condition,
                          price: price.text.toString(),
                          location: _choosedLocation,
                          sellerId: widget.firebaseUser?.uid,
                          productId: pid,
                          listedDate: DateTime.now(),
                        );

                        await FirebaseFirestore.instance
                            .collection('products')
                            //.doc(uid)
                            //.collection('Items')
                            .doc(pid)
                            .set(productModel.toMap())
                            .then((value) => 'Product added successfully');
                        print('Item added successfully');
                      },
                      child: const Center(
                          child: Text('Post Now',
                              style: TextStyle(
                                fontSize: 18,
                                color: Colors.black,
                              )))),
                )
              ],
            ),
          ),
        ));
  }

  _showImageSourceDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Select Image Source'),
          content: SingleChildScrollView(
            child: ListBody(
              children: [
                ListTile(
                  leading: const Icon(Icons.camera_alt),
                  title: const Text('Camera'),
                  onTap: () {
                    _openCamera();
                  },
                ),
                const Padding(padding: EdgeInsets.all(8.0)),
                ListTile(
                  leading: const Icon(Icons.photo_library),
                  title: const Text('Gallery'),
                  onTap: () {
                    _openGallery();
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  _openCamera() async {
    XFile? image;
    image = await _picker.pickImage(source: ImageSource.camera);

    setState(() {
      _image = image;
    });
  }

  _openGallery() async {
    XFile? image;
    image = await _picker.pickImage(source: ImageSource.gallery);

    setState(() {
      _image = image;
    });
  }

  _sendImageCloud() async {
    if (_image == null) return;
    //getting reference to storage root
    Reference referenceRoot = FirebaseStorage.instance.ref();
    Reference referenceDirImages = referenceRoot.child('images');

    //reference for the images to be stored
    String uniqueFileName = DateTime.now().millisecondsSinceEpoch.toString();
    Reference referenceImageToUpload = referenceDirImages.child(uniqueFileName);

    //Store the file
    try {
      await referenceImageToUpload.putFile(File(_image!.path));
      imageUrl = await referenceImageToUpload.getDownloadURL();

      //!find out the user model and update the image url
      //!in the user model
      //!then update the user model in the database
    } catch (error) {}
  }
}
