import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/material.dart%20';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_svg/svg.dart';
import 'package:avatarmakercopy/screens/PlayerReadyMeScreen.dart';
import 'package:avatarmakercopy/screens/user_list_screen.dart';
import 'package:avatarmakercopy/screens/profile.dart';
import 'package:provider/provider.dart';
import '../avatar_maker_screen.dart';
import '../screens/RegistrationScreen.dart';
import '../screens/login_screen.dart';
import '../screens/onboarding_screen.dart';
import '../services/api_service.dart';
import '../main.dart';
import 'custom_avatar.dart';
import '../screens/DisplayModelScreen.dart';




class HomeInterface extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        primaryColor: Colors.blue,
      ),
      home: MainPage(),
      routes: {
        '/login': (context) => const LoginScreen(),
        '/userList': (context) => const UserListScreen(),
        '/home': (context) => HomeInterface(),
        '/register': (context) => const RegistrationScreen(),
        '/onboarding': (context) => const OnBoarding(),
          // Assuming ProfileScreen is available
        '/playerReadyMe': (context) => PlayerReadyMeScreen(),
        '/avatarmaker': (context) => const AvatarMakerScreen(),
        '/avatarShow': (context) =>  DisplayModelScreen(),
        // Define other routes as needed
      },
    );
  }
}

class MainPage extends StatelessWidget {
  final storage = FlutterSecureStorage();


  Future<Map<String, String>> getUserDetails() async {
    var name = await storage.read(key: 'name') ?? 'No Name';
    var userId = await storage.read(key: 'userId') ?? 'No ID';  // Ensure 'userId' matches the key used in 'authenticateUser'
    return {'name': name, 'userId': userId};
  }


  List<Map<String, dynamic>> exploreList = [
    {
      'icon': Icons.code,
      'name': 'Coding',
      'description': 'Description 1',
    },
    {
      'icon': Icons.translate,
      'name': 'Translater',
      'description': 'Description 2',
    },
    {
      'icon': Icons.monitor_heart,
      'name': 'Health',
      'description': 'Description 2',
    },
    {
      'icon': Icons.music_note,
      'name': 'Music',
      'description': 'Description 2',
    },
    // Add more items as needed
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home Page'),
        actions: [
          CircleAvatar(
              radius: 20,
              backgroundImage: AssetImage('assets/user_profile.jpg')
          ),
          SizedBox(width: 8),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            FutureBuilder<Map<String, String>>(
              future: getUserDetails(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done && snapshot.hasData) {
                  return UserAccountsDrawerHeader(
                    accountName: Text(snapshot.data!['name']!),
                    accountEmail: Text(snapshot.data!['userId']!),
                    decoration: BoxDecoration(
                      color: Colors.blue,
                    ),
                  );
                } else {
                  return DrawerHeader(
                    decoration: BoxDecoration(color: Colors.blue),
                    child: Text('Loading...'),
                  );
                }
              },
            ),
            ListTile(
              leading: Icon(Icons.favorite),
              title: Text('Favorites'),
              onTap: () {
                // Add navigation logic for Favorites
              },
            ),
            ListTile(
              leading: Icon(Icons.gamepad),
              title: Text('Player Ready Me'),
              onTap: () {
                Navigator.of(context).pop(); // Close the drawer
                Navigator.of(context).push(MaterialPageRoute(builder: (context) => PlayerReadyMeScreen()));
              },
            ),
            ListTile(
              leading: Icon(Icons.gamepad),
              title: Text('Small avatar generator (sidegame)'),
              onTap: () {
                Navigator.of(context).pop(); // Close the drawer
                Navigator.of(context).push(MaterialPageRoute(builder: (context) => const AvatarMakerScreen()));
              },
            ),
            ListTile(
              leading: Icon(Icons.gamepad),
              title: Text('3D avatarAssistant / AR)'),
              onTap: () {
                Navigator.of(context).pop(); // Close the drawer
                Navigator.of(context).push(MaterialPageRoute(builder: (context) =>  DisplayModelScreen()));
              },
            ),

            ListTile(
              leading: Icon(Icons.exit_to_app),
              title: Text('Log Out'),
              onTap: () async {
                // Logout logic
                await Provider.of<ApiService>(context, listen: false).logoutUser();
                Navigator.of(context).pushReplacementNamed('/login');
              },
            ),



            // Add more ListTile widgets for additional drawer items
          ],
        ),
      ),

      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(height: 20), // Add some spacing
            Container(

              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Colors.white, Colors.blueAccent], // Adjust colors as needed
                ),
              ),
              child: CircleAvatar(
                radius: 100,
                backgroundColor: Colors.transparent,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Hi Rached',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white
                      ),
                    ),
                    SizedBox(height: 8),
                    TextButton(
                      onPressed: () {
                        _showDialog(context);
                      },
                      child: Text('Tap to chat',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.white,)

                      ),
                    ),
                    SizedBox(height: 8),
                    SvgPicture.asset(
                      'assets/vocal.svg', // Replace this with the path to your .svg file
                      width: 60,
                      height: 60,
                      color: Colors.white,

                    ),
                  ],
                ),
              ),
            ),

            SizedBox(height: 20), // Add some spacing

            Row(

              children: [
                SizedBox(width: 20,),
                Text("Explore", style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold
                ),),
              ],
            ),
            SizedBox(height: 10,),// Add some spacing
            GridView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                childAspectRatio: 0.75,
              ),
              itemCount: exploreList.length, // Adjust as needed
              itemBuilder: (context, index) {
                return SizedBox(
                  height: 200,
                  child: Card(
                    child: ListTile(
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Icon(exploreList[index]['icon'], color: Colors.blue,size: 40,),
                          Text(exploreList[index]['name']),
                          Text(exploreList[index]['description']),

                        ],
                      ),
                      onTap: () {
                        //_showDialog(context);
                      },

                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: 'Search',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.notifications),
            label: 'Notifications',
          ),
        ],
        selectedItemColor: Colors.blue,
        onTap: (int index) {
          // Handle bottom navigation tap
        },
      ),
    );
  }
}
void _showDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('Create An Avatar'),
        content:
          SizedBox(
            height: 120,
            child: Column(

              children: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) =>AvatarMakerScreen()));
                  },
                  child: Text('Custom Avatar '),
                ),
                ElevatedButton(
                  onPressed: () {
                    //Navigator.of(context).pop();
                    Navigator.push(context, MaterialPageRoute(builder: (context) =>AvatarGeneratorPage()));
                  },
                  child: Text('Avatar with AI'),
                ),
              ],
            ),
          )

      );
    },
  );
}
