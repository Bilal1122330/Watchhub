import 'package:flutter/material.dart';
import 'package:watch_hub/routes/app_routes.dart';
import 'package:watch_hub/widgets/beveled_button.dart';
import 'package:watch_hub/widgets/video_template.dart';


class LogoutPage extends StatefulWidget {
  const LogoutPage({super.key});

  @override
  State<LogoutPage> createState() => _LogoutPageState();
}

class _LogoutPageState extends State<LogoutPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title:  Text('Logout',style: Theme.of(context).textTheme.titleMedium,),
        automaticallyImplyLeading: false,

      ),
      body:OrientationBuilder(builder: (context,orientation){
        if(orientation==Orientation.portrait){
          return VideoTemplate(body: fillBody(), videoPath: "assets/media/back_video/watch1.mp4");
        }else{
          return fillBody();
        }
      }),
    );

  }

  Widget fillBody(){
    return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Card(
              color: Colors.orange.withOpacity(0.7),
              elevation: 10,
              margin: const EdgeInsets.all(10),
              child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: Column(
                    children: <Widget>[
                      const Text('Logout Successfully'),
                      const SizedBox(
                        height: 50,
                      ),
                      BeveledButton(title: "Login Again", onTap: (){
                        Future.delayed(Duration.zero,(){
                          Navigator.pushReplacementNamed(context, PageRoutes.loginPage);
                        });
                      })
                    ],
                  )
              ),
            ),
          ],
        ));
  }
}
