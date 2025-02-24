import 'package:flutter/material.dart';
Widget createDrawerHeader({
  required BuildContext context, String? displayName
}){
  return SizedBox(
    height: 250,
    child: DrawerHeader(
      margin: EdgeInsets.zero,
      padding: EdgeInsets.zero,
      decoration: const BoxDecoration(
          image: DecorationImage(image: AssetImage("assets/media/avator/watchpic2.jpg"),
              fit: BoxFit.fill
          )
      ), child: Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.end,
      children: <Widget>[
        const CircleAvatar(
          backgroundColor: Colors.orange,
          radius: 70,
          child: CircleAvatar(
            radius: 60,
            backgroundImage: AssetImage("assets/media/avator/watchpic1.jpg"),
          ),
        ),
        const SizedBox(height: 10,),
        Container(
          padding: const EdgeInsets.all(10),
          color: Colors.black45,
          child: Text( displayName!,style: Theme.of(context).textTheme.titleMedium,),
        ),
        const SizedBox(height: 10,),
      ],
    ),
    ),
  );
}

Widget createDrawerBodyItem({
  required BuildContext context,
  required text,
  required GestureTapCallback onTap,
  required IconData icon
}){
  return Card(
    color: Colors.green,
    child: ListTile(
      title: Row(
        children: [
          Icon(icon, color: Colors.yellow,),
          Padding(padding: const EdgeInsets.only(left: 80.0),
            child: Text(text, style: Theme.of(context).textTheme.titleMedium,),
          )
        ],
      ),
      onTap: onTap,
    ),
  );
}