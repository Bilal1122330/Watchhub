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
  final _formKey = GlobalKey<FormState>();

  File? selectedImage;
  Uint8List? webImage;
  Uint8List? memoryImage;

  User? user;
  var productDao = ProductDao();

  bool isProcessing = false;
  bool isChecked = false;


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

  // -- New variables to handle Edit Mode --
  String? existingKey;
  Product? existingProduct;
  bool isEditMode = false;

  @override
  void initState() {
    super.initState();
    user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      Future.delayed(Duration.zero, () {
        if (!mounted) return;
        Navigator.pushReplacementNamed(context, PageRoutes.loginPage);
      });
    }

    loadCategoryList();
    loadStatusList();
  }


  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final args = ModalRoute
        .of(context)
        ?.settings
        .arguments;
    if (args != null && args is Map) {
      existingKey = args["key"] as String?;
      existingProduct = args["product"] as Product?;

      // If we got a product, fill fields for editing
      if (existingProduct != null) {
        isEditMode = true;
        code = existingProduct!.code;
        name = existingProduct!.name;
        desc = existingProduct!.desc;
        price = existingProduct!.price.toString();


        switch (existingProduct!.category) {
          case "Male":
            selectedCategory = 0;
            break;
          case "Female":
            selectedCategory = 1;
            break;
          case "Horror":
            selectedCategory = 2;
            break;
          case "Nature":
            selectedCategory = 3;
            break;
          default:
            selectedCategory = 0;
        }


        switch (existingProduct!.status) {
          case "Available":
            selectedStatus = 0;
            break;
          case "Out of stock":
            selectedStatus = 1;
            break;
          case "Top selling":
            selectedStatus = 2;
            break;
          case "Vendor recommended":
            selectedStatus = 3;
            break;
          default:
            selectedStatus = 0;
        }


        if (kIsWeb) {
          webImage = base64Decode(existingProduct!.imageBase64);
        }

      }
    }
  }


  void loadCategoryList() {
    categoryList = [];
    categoryList.add(const DropdownMenuItem(
      value: 0,
      child: Row(
        children: <Widget>[
          SizedBox(width: 8),
          Icon(Icons.category),
          SizedBox(width: 8),
          Text('Male')
        ],
      ),
    ));
    categoryList.add(const DropdownMenuItem(
      value: 1,
      child: Row(
        children: <Widget>[
          SizedBox(width: 8),
          Icon(Icons.category),
          SizedBox(width: 8),
          Text('Female')
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
          SizedBox(width: 8),
          Icon(Icons.shop),
          SizedBox(width: 8),
          Text('Available')
        ],
      ),
    ));
    statusList.add(const DropdownMenuItem(
      value: 1,
      child: Row(
        children: <Widget>[
          SizedBox(width: 8),
          Icon(Icons.shop),
          SizedBox(width: 8),
          Text('Out of stock')
        ],
      ),
    ));
    statusList.add(const DropdownMenuItem(
      value: 2,
      child: Row(
        children: <Widget>[
          SizedBox(width: 8),
          Icon(Icons.shop),
          SizedBox(width: 8),
          Text('Top selling')
        ],
      ),
    ));
    statusList.add(const DropdownMenuItem(
      value: 3,
      child: Row(
        children: <Widget>[
          SizedBox(width: 8),
          Icon(Icons.shop),
          SizedBox(width: 8),
          Text('Vendor recommended')
        ],
      ),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const AdminCusDrawer(),
      appBar: AppBar(
        title: Text(
          isEditMode ? 'Edit Product' : 'Add Product Page',
          style: Theme
              .of(context)
              .textTheme
              .titleMedium,
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
      videoPath: "assets/media/back_video/watch1.mp4",
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: fillBody(),
      ),
    );
  }

  Widget fillBody() {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: SingleChildScrollView(
        padding: EdgeInsets.only(bottom: MediaQuery
            .of(context)
            .viewInsets
            .bottom),
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
                        const SizedBox(height: 10.0),
                        // Image preview or pick
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
                                    width: 1.5,
                                  ),
                                  borderRadius: BorderRadius.circular(30),
                                  color: Colors.green.withOpacity(0.2),
                                ),
                                child: const Icon(
                                  Icons.camera,
                                  color: Colors.green,
                                ),
                              ),
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
                                  color: Colors.black,
                                  width: 1.5,
                                ),
                                borderRadius: BorderRadius.circular(30),
                                color: Colors.green.withOpacity(0.2),
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(30.0),
                                child: kIsWeb
                                    ? Image.memory(
                                  webImage!,
                                  fit: BoxFit.fill,
                                )
                                    : Image.file(
                                  selectedImage!,
                                  fit: BoxFit.fill,
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),

                        // -- CODE --
                        TextFormField(
                          initialValue: code ?? "",
                          style: Theme
                              .of(context)
                              .textTheme
                              .bodyMedium,
                          maxLength: 6,
                          decoration: const InputDecoration(
                            prefix: Icon(Icons.security_rounded,
                                color: Colors.deepOrange),
                            labelText: "Code",
                            hintText: "Enter Product Code",
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "Value is required";
                            }
                            return null;
                          },
                          onSaved: (value) {
                            setState(() {
                              code = value;
                            });
                          },
                        ),
                        const SizedBox(height: 10),

                        // -- NAME --
                        TextFormField(
                          initialValue: name ?? "",
                          style: Theme
                              .of(context)
                              .textTheme
                              .bodyMedium,
                          maxLength: 20,
                          decoration: const InputDecoration(
                            prefix: Icon(Icons.note, color: Colors.deepOrange),
                            labelText: "Name",
                            hintText: "Enter Product Name",
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "Value is required";
                            }
                            return null;
                          },
                          onSaved: (value) {
                            setState(() {
                              name = value;
                            });
                          },
                        ),
                        const SizedBox(height: 10),

                        // -- DESC --
                        TextFormField(
                          initialValue: desc ?? "",
                          style: Theme
                              .of(context)
                              .textTheme
                              .bodyMedium,
                          maxLength: 50,
                          decoration: const InputDecoration(
                            prefix: Icon(Icons.description,
                                color: Colors.deepOrange),
                            labelText: "Description",
                            hintText: "Enter Descriptions",
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "Value is required";
                            }
                            return null;
                          },
                          onSaved: (value) {
                            setState(() {
                              desc = value;
                            });
                          },
                        ),
                        const SizedBox(height: 10),

                        // -- CATEGORY --
                        DropdownButton<int>(
                          dropdownColor: Colors.green,
                          style: Theme
                              .of(context)
                              .textTheme
                              .bodyMedium,
                          hint: const Text('Select Category'),
                          items: categoryList,
                          value: selectedCategory,
                          onChanged: (value) {
                            setState(() {
                              selectedCategory = value ?? 0;
                            });
                          },
                          isExpanded: true,
                        ),
                        const SizedBox(height: 10),

                        // -- PRICE --
                        TextFormField(
                          initialValue: price ?? "",
                          style: Theme
                              .of(context)
                              .textTheme
                              .bodyMedium,
                          maxLength: 5,
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(
                            prefix: Icon(Icons.price_change,
                                color: Colors.deepOrange),
                            labelText: "Price",
                            hintText: "Enter Price",
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
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
                        const SizedBox(height: 10),

                        // -- STATUS --
                        DropdownButton<int>(
                          dropdownColor: Colors.green,
                          style: Theme
                              .of(context)
                              .textTheme
                              .bodyMedium,
                          hint: const Text('Select Status'),
                          items: statusList,
                          value: selectedStatus,
                          onChanged: (value) {
                            setState(() {
                              selectedStatus = value ?? 0;
                            });
                          },
                          isExpanded: true,
                        ),
                        const SizedBox(height: 10),

                        // -- SAVE / UPDATE BUTTON --
                        !isProcessing
                            ? SizedBox(
                          width: MediaQuery
                              .of(context)
                              .size
                              .width,
                          child: BeveledButton(
                            title: isEditMode ? "Update" : "Save",
                            onTap: onFormSubmit,
                          ),
                        )
                            : const SizedBox(
                          width: 40,
                          child: CircularProgressIndicator(
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

  // Handle image picking
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
        setState(() {
          selectedImage = File(image.path);
        });
      }
    }
  }

  // Modified addData() to handle Update if in Edit Mode
  Future<void> addData() async {
    try {
      // If no image is selected, but we're editing, keep the old image
      String base64image;
      if (kIsWeb) {
        if (webImage == null && isEditMode && existingProduct != null) {
          // Keep the old image
          base64image = existingProduct!.imageBase64;
        } else if (webImage == null && !isEditMode) {
          // No image for new product
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text("Please select an image"),
          ));
          return;
        } else {
          // user picked a new image
          base64image = base64Encode(webImage!);
        }
      } else {
        // Mobile
        if (selectedImage == null && memoryImage == null && !isEditMode) {
          // brand new product, no image
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text("Please select an image"),
          ));
          return;
        } else if (selectedImage == null && isEditMode && existingProduct != null) {
          // Keep old image
          base64image = existingProduct!.imageBase64;
        } else if (selectedImage != null) {
          // user picked a new image
          base64image = base64Encode(selectedImage!.readAsBytesSync());
        } else {
          // fallback if memoryImage was not null (rare scenario)
          base64image = base64Encode(memoryImage!);
        }

      }

      await Future.delayed(const Duration(seconds: 2));
      double parsedPrice = double.parse(price!);

      var product = Product(
        code: code.toString(),
        name: name.toString(),
        desc: desc.toString(),
        category: category.toString(),
        imageBase64: base64image.toString(),
        price: parsedPrice,
        status: status.toString(),
      );

      // -- If in edit mode, update; otherwise, add new
      if (isEditMode && existingKey != null && existingKey!.isNotEmpty) {
        productDao.updateProduct(existingKey!, product);
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          backgroundColor: Colors.green,
          content: Text('Product Updated', style: TextStyle(fontSize: 18)),
        ));
      } else {
        productDao.saveProduct(product);
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          backgroundColor: Colors.green,
          content: Text('Product Added', style: TextStyle(fontSize: 18)),
        ));
      }
      Navigator.pushReplacementNamed(context, "/ProductListScreen");
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        backgroundColor: Colors.red,
        content: Text('Failed to add/update product: $e',
            style: const TextStyle(fontSize: 18)),
      ));
    }
  }

  // Unchanged except for calling addData
  void onFormSubmit() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      log("price is $price");

      // Map dropdown indices to strings
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
      }

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
    }
  }
}
