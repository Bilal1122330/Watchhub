import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:watch_hub/models/user_profile.dart';
import 'package:watch_hub/screens/login_page.dart';
import 'package:watch_hub/services/authenticate.dart';
import 'package:watch_hub/services/user_profile_dao.dart';
import 'package:watch_hub/services/validations.dart';
import 'package:watch_hub/widgets/beveled_button.dart';
import 'package:watch_hub/widgets/body_landscape.dart';
import 'package:watch_hub/widgets/video_template.dart';

class CreateUserDetail extends StatefulWidget {
  const CreateUserDetail({super.key, required this.email});
  final String email;

  @override
  State<CreateUserDetail> createState() => _CreateUserDetailState();
}

class _CreateUserDetailState extends State<CreateUserDetail> {
  final _formKey = GlobalKey<FormState>();
  UserProfileDao userProfileDao = UserProfileDao();

  String? displayName;
  String? userAddress;
  String? userMobile;
  int selectedCity = 0;
  String? uuid;

  List<DropdownMenuItem<int>> cityList = [];

  void loadCityList() {
    cityList = [];
    cityList.add(const DropdownMenuItem(
      value: 0,
      child: Row(
        children: <Widget>[
          SizedBox(
            width: 8,
          ),
          Icon(Icons.location_city),
          SizedBox(
            width: 8,
          ),
          Text('Karachi')
        ],
      ),
    ));
    cityList.add(const DropdownMenuItem(
      value: 1,
      child: Row(
        children: <Widget>[
          SizedBox(
            width: 8,
          ),
          Icon(Icons.location_city),
          SizedBox(
            width: 8,
          ),
          Text('Lahore')
        ],
      ),
    ));
    cityList.add(const DropdownMenuItem(
      value: 2,
      child: Row(
        children: <Widget>[
          SizedBox(
            width: 8,
          ),
          Icon(Icons.location_city),
          SizedBox(
            width: 8,
          ),
          Text('Islamabad')
        ],
      ),
    ));
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loadCityList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Create User Profile',
          style: Theme.of(context).textTheme.titleMedium,
        ),
        automaticallyImplyLeading: false,
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
        body: fillBody(), videoPath: "assets/media/back_video/watch1.mp4");
  }

  Widget fillBody() {
    return SafeArea(
        child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: <Widget>[
                Card(
                  elevation: 4,
                  color: Colors.black45,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        children: <Widget>[
                          TextFormField(
                            style: Theme.of(context).textTheme.bodyMedium,
                            maxLength: 20,
                            decoration: const InputDecoration(
                                prefixIcon: Icon(Icons.person),
                                labelText: "Display Name",
                                hintText: "Enter User Name"),
                            keyboardType: TextInputType.text,
                            validator: validateName,
                            onSaved: (value) {
                              setState(() {
                                displayName = value;
                              });
                            },
                          ),
                          TextFormField(
                            style: Theme.of(context).textTheme.bodyMedium,
                            maxLength: 11,
                            decoration: const InputDecoration(
                                prefixIcon: Icon(Icons.mobile_screen_share),
                                labelText: "Mobile No",
                                hintText: "Enter User Mobile No"),
                            keyboardType: TextInputType.number,
                            validator: validateCell,
                            onSaved: (value) {
                              setState(() {
                                userMobile = value;
                              });
                            },
                          ),
                          DropdownButton(
                            dropdownColor: Colors.green,
                            style: Theme.of(context).textTheme.bodyMedium,
                            hint: const Text('Select City'),
                            items: cityList,
                            value: selectedCity,
                            onChanged: (value) {
                              setState(() {
                                selectedCity = int.parse(value.toString());
                              });
                            },
                            isExpanded: true,
                          ),
                          TextFormField(
                            style: Theme.of(context).textTheme.bodyMedium,
                            maxLength: 200,
                            maxLines: 4,
                            decoration: const InputDecoration(
                                prefixIcon: Icon(Icons.location_city),
                                labelText: "Address",
                                hintText: "Enter User Delivery Address"),
                            keyboardType: TextInputType.multiline,
                            validator: validateText,
                            onSaved: (value) {
                              setState(() {
                                userAddress = value;
                              });
                            },
                          ),
                          BeveledButton(
                              title: "Create User",
                              onTap: () {
                                onPressSubmit();
                              }),
                        ],
                      ),
                    ),
                  ),
                )
              ],
            )));
  }

  void onPressSubmit() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      String city = "";
      switch (selectedCity) {
        case 0:
          city = "Karachi";
          break;
        case 1:
          city = "Lahore";
          break;
        case 2:
          city = "Islamabad";
          break;
        default:
      }

      await Future.delayed(const Duration(seconds: 1), () {});

      final user = FirebaseAuth.instance.currentUser;

      if (user != null) {
        user.updateDisplayName(displayName);
      }

      String uuid = user!.uid.toString();

      UsersProfile userProfile = UsersProfile(
          displayName: displayName.toString(),
          uuid: uuid,
          email: widget.email,
          mobile: userMobile.toString(),
          city: city,
          type: 'user',
          status: 'active',
          address: userAddress.toString());

      await userProfileDao.saveUser(userProfile);

      // ScaffoldMessenger.of(context)
      //     .showSnackBar(const SnackBar(content: Text("User Created")));




      await Future.delayed(const Duration(seconds: 1), () {});

      await Authentication().signOut();

      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => const LoginPage()));
    }
  }
}
