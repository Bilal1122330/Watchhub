import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:watch_hub/models/product.dart';
import 'package:watch_hub/pages/logout_page.dart';
import 'package:watch_hub/routes/app_routes.dart';

import 'package:watch_hub/services/authenticate.dart';
import 'package:watch_hub/services/product_doa.dart';
import 'package:watch_hub/widgets/admin_cus_drawer.dart';
import 'package:watch_hub/widgets/beveled_button.dart';
import 'package:watch_hub/widgets/body_landscape.dart';
import 'package:watch_hub/widgets/video_template.dart';
import 'dart:convert';
import 'dart:io';

import 'package:image_picker/image_picker.dart';

class AddProductPage extends StatefulWidget {
  const AddProductPage({super.key});
  static const routeName = "/AddProductPage";

  @override
  State<AddProductPage> createState() => _AddProductPageState();
}

class _AddProductPageState extends State<AddProductPage> {
  final ImagePicker imagePicker = ImagePicker();

  File? selectedImage;
  Uint8List? webImage;

  User? user;

  var productDao = ProductDao();

  bool isChecked = false;
  bool isProcessing = false;
  final _formKey = GlobalKey<FormState>();

  int selectedStatus = 0;
  int selectedCategory = 0;

  String? code;
  String? name;
  String? desc;
  String? category;
  String? status;
  String? price;

  List<DropdownMenuItem<int>> categoryList = [];
  List<DropdownMenuItem<int>> statusList = [];

  void loadCategoryList() {
    categoryList = [];
    categoryList.add(const DropdownMenuItem(
      value: 0,
      child: Row(
        children: <Widget>[
          SizedBox(
            width: 8,
          ),
          Icon(Icons.category),
          SizedBox(
            width: 8,
          ),
          Text('Male')
        ],
      ),
    ));
    categoryList.add(const DropdownMenuItem(
      value: 1,
      child: Row(
        children: <Widget>[
          SizedBox(
            width: 8,
          ),
          Icon(Icons.category),
          SizedBox(
            width: 8,
          ),
          Text('Female')
        ],
      ),
    ));
    categoryList.add(const DropdownMenuItem(
      value: 2,
      child: Row(
        children: <Widget>[
          SizedBox(
            width: 8,
          ),
          Icon(Icons.category),
          SizedBox(
            width: 8,
          ),
          Text('Horror')
        ],
      ),
    ));
    categoryList.add(const DropdownMenuItem(
      value: 3,
      child: Row(
        children: <Widget>[
          SizedBox(
            width: 8,
          ),
          Icon(Icons.category),
          SizedBox(
            width: 8,
          ),
          Text('Nature')
        ],
      ),
    ));
  }

  void loadStatusList() {
    statusList = [];
    statusList.add(const DropdownMenuItem(
      value: 0,
      child: Row(
        children: <Widget>[
          SizedBox(
            width: 8,
          ),
          Icon(Icons.shop),
          SizedBox(
            width: 8,
          ),
          Text('Available')
        ],
      ),
    ));
    statusList.add(const DropdownMenuItem(
      value: 1,
      child: Row(
        children: <Widget>[
          SizedBox(
            width: 8,
          ),
          Icon(Icons.shop),
          SizedBox(
            width: 8,
          ),
          Text('Out of stock')
        ],
      ),
    ));
    statusList.add(const DropdownMenuItem(
      value: 2,
      child: Row(
        children: <Widget>[
          SizedBox(
            width: 8,
          ),
          Icon(Icons.shop),
          SizedBox(
            width: 8,
          ),
          Text('Top selling')
        ],
      ),
    ));
    statusList.add(const DropdownMenuItem(
      value: 3,
      child: Row(
        children: <Widget>[
          SizedBox(
            width: 8,
          ),
          Icon(Icons.shop),
          SizedBox(
            width: 8,
          ),
          Text('Vendor recommended')
        ],
      ),
    ));
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      Future.delayed(Duration.zero, () {
       // Navigator.pushReplacementNamed(context, PageRoutes.loginPage);
        if(!mounted) return false;
        Navigator.pushReplacementNamed(context, PageRoutes.loginPage);
      });
    }
    loadCategoryList();
    loadStatusList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const AdminCusDrawer(),
      appBar: AppBar(
        title: Text(
          'Add Product Page',
          style: Theme.of(context).textTheme.titleMedium,
        ),
        iconTheme: const IconThemeData(color: Colors.deepOrange),
        actions: <Widget>[
          IconButton(
              onPressed: () {
                Authentication().signOut();
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (BuildContext) => const LogoutPage()));
              },
              icon: const Icon(Icons.exit_to_app))
        ],
      ),
      body: OrientationBuilder(builder: (context, orientation) {
        if (orientation == Orientation.portrait) {
          return getBodyPortrait();
        } else {
          return const BodyLandscape();
        }
      }),
    );
  }

  Widget getBodyPortrait() {
    return VideoTemplate(
        body: Padding(
          padding: const EdgeInsets.all(10),
          child: fillBody(),
        ),
        videoPath: "assets/media/back_video/watch1.mp4");
  }

  Widget fillBody() {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: SingleChildScrollView(
        padding:
            EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        child: Column(
          children: <Widget>[
            Card(
              elevation: 10,
              color: Colors.black.withOpacity(0.2),
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: SingleChildScrollView(
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: <Widget>[
                        const SizedBox(
                          height: 10.0,
                        ),
                        selectedImage == null && webImage == null
                            ? GestureDetector(
                                onTap: getImage,
                                child: Center(
                                  child: Material(
                                    elevation: 10.0,
                                    borderRadius: BorderRadius.circular(20.0),
                                    child: Container(
                                        height: 220,
                                        width: 220,
                                        decoration: BoxDecoration(
                                            border: Border.all(
                                                color: Colors.black,
                                                width: 1.5),
                                            borderRadius:
                                                BorderRadius.circular(30),
                                            color:
                                                Colors.green.withOpacity(0.2)),
                                        child: const Icon(
                                          Icons.camera,
                                          color: Colors.green,
                                        )),
                                  ),
                                ),
                              )
                            : Center(
                                child: Material(
                                  elevation: 10.0,
                                  borderRadius: BorderRadius.circular(20.0),
                                  child: Container(
                                    height: 220,
                                    width: 220,
                                    decoration: BoxDecoration(
                                        border: Border.all(
                                            color: Colors.black, width: 1.5),
                                        borderRadius: BorderRadius.circular(30),
                                        color: Colors.green.withOpacity(0.2)),
                                    child: ClipRRect(
                                        borderRadius:
                                            BorderRadius.circular(30.0),
                                        child: kIsWeb
                                            ? Image.memory(
                                                webImage!,
                                                fit: BoxFit.fill,
                                              )
                                            : Image.file(
                                                selectedImage!,
                                                fit: BoxFit.fill,
                                              )),
                                  ),
                                ),
                              ),
                        const SizedBox(
                          height: 10,
                        ),
                        TextFormField(
                          style: Theme.of(context).textTheme.bodyMedium,
                          maxLength: 6,
                          decoration: const InputDecoration(
                              prefix: Icon(
                                Icons.security_rounded,
                                color: Colors.deepOrange,
                              ),
                              labelText: "Code",
                              hintText: "Enter Product Code"),
                          validator: (value) {
                            if (value!.isEmpty) {
                              return "value is required";
                            }
                            return null;
                          },
                          onSaved: (value) {
                            setState(() {
                              code = value;
                            });
                          },
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        TextFormField(
                          style: Theme.of(context).textTheme.bodyMedium,
                          maxLength: 20,
                          decoration: const InputDecoration(
                              prefix: Icon(
                                Icons.note,
                                color: Colors.deepOrange,
                              ),
                              labelText: "Name",
                              hintText: "Enter Product Name"),
                          validator: (value) {
                            if (value!.isEmpty) {
                              return "value is required";
                            }
                            return null;
                          },
                          onSaved: (value) {
                            setState(() {
                              name = value;
                            });
                          },
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        TextFormField(
                          style: Theme.of(context).textTheme.bodyMedium,
                          maxLength: 50,
                          decoration: const InputDecoration(
                              prefix: Icon(Icons.description,
                                  color: Colors.deepOrange),
                              labelText: "Description",
                              hintText: "Enter Descriptions"),
                          validator: (value) {
                            if (value!.isEmpty) {
                              return "value is required";
                            }
                            return null;
                          },
                          onSaved: (value) {
                            setState(() {
                              desc = value;
                            });
                          },
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        DropdownButton(
                          dropdownColor: Colors.green,
                          style: Theme.of(context).textTheme.bodyMedium,
                          hint: const Text('Select Category'),
                          items: categoryList,
                          value: selectedCategory,
                          onChanged: (value) {
                            setState(() {
                              selectedCategory = int.parse(value.toString());
                            });
                          },
                          isExpanded: true,
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        TextFormField(
                          style: Theme.of(context).textTheme.bodyMedium,
                          maxLength: 5,
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(
                              prefix: Icon(Icons.price_change,
                                  color: Colors.deepOrange),
                              labelText: "Price",
                              hintText: "Enter Price"),
                          validator: (value) {
                            if (value!.isEmpty) {
                              return "Price is required";
                            } else if (double.tryParse(value) == null) {
                              return "Invalid price";
                            }
                            return null;
                          },
                          onSaved: (value) {
                            setState(() {
                              price = value;
                            });
                          },
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        DropdownButton(
                          dropdownColor: Colors.green,
                          style: Theme.of(context).textTheme.bodyMedium,
                          hint: const Text('Select Status'),
                          items: statusList,
                          value: selectedStatus,
                          onChanged: (value) {
                            setState(() {
                              selectedStatus = int.parse(value.toString());
                            });
                          },
                          isExpanded: true,
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        !isProcessing
                            ? SizedBox(
                                width: MediaQuery.of(context).size.width,
                                child: BeveledButton(
                                    title: "Save", onTap: onFormSubmit),
                              )
                            : const SizedBox(
                                width: 40,
                                child:  CircularProgressIndicator(
                                  strokeWidth: 10,
                                  backgroundColor: Colors.greenAccent,
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                      Colors.yellowAccent),
                                ),
                              )
                      ],
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Future<void> getImage() async {
    if (kIsWeb) {
      final image = await imagePicker.pickImage(source: ImageSource.gallery);

      if (image != null) {
        final imageBytes = await image.readAsBytes();
        setState(() {
          webImage = imageBytes;
        });
      }
    } else {
      final image = await imagePicker.pickImage(source: ImageSource.gallery);
      if (image != null) {
        selectedImage = File(image.path);
      }
    }
  }

  Future<void> addData() async {
    try {
      if ((kIsWeb && webImage == null) || (!kIsWeb && selectedImage == null)) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            backgroundColor: Colors.red,
            content: Text('Please Select image',
                style:  TextStyle(fontSize: 18))));
        return;
      }

      String base64image;
      if (kIsWeb) {
        base64image = base64Encode(webImage!);
      } else {
        base64image = base64Encode(selectedImage!.readAsBytesSync());
      }

      await Future.delayed(const Duration(seconds: 2));
      double parsedPrice = double.parse(price!);
      var product = Product(
          code: code.toString(),
          name: name.toString(),
          desc: desc.toString(),
          category: category.toString(),
          imageBase64: base64image.toString(),
          price: parsedPrice, // Safely parse price
          status: status.toString());

      productDao.saveProduct(product);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          backgroundColor: Colors.red,
          content: Text('Failed to add product: $e',
              style: const TextStyle(fontSize: 18))));
    }
  }

  void onFormSubmit() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      double parsedPrice = double.parse(price!);
      //print("price is $parsedPrice");
      log("price is $parsedPrice");
      setState(() {
        status = null;
        category = null;

        switch (selectedStatus) {
          case 0:
            status = "Available";
            break;
          case 1:
            status = "Out of stock";
            break;
          case 2:
            status = "Top selling";
            break;
          case 3:
            status = "Vendor recommended";
            break;
        }

        switch (selectedCategory) {
          case 0:
            category = "Male";
            break;
          case 1:
            category = "Female";
            break;
          case 2:
            category = "Horror";
            break;
          case 3:
            category = "Nature";
            break;
        }
      });

      setState(() {
        isProcessing = true;
      });
      await Future.delayed(const Duration(seconds: 2));
      addData().then((_) {
        setState(() {
          isProcessing = false;
        });
      }).catchError((error) {
        setState(() {
          isProcessing = false;
        });
      });

      setState(() {
        isProcessing = true;
      });
    }
  }
}
