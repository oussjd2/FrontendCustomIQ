import 'package:avatarmakercopy/screens/updateUserScreen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../controllers/user_controller.dart';
import '../models/user.dart';
import '../services/api_service.dart';
import 'avatar_maker_screen.dart'; // Example import, ensure you include your actual imports
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class UserListScreen extends StatefulWidget {
  const UserListScreen({Key? key}) : super(key: key);

  @override
  _UserListScreenState createState() => _UserListScreenState();
}

class _UserListScreenState extends State<UserListScreen> {
  final FlutterSecureStorage _storage = const FlutterSecureStorage();
  String _userName = '';
  String _name = '';
  bool _showUserList = true;

  @override
  void initState() {
    super.initState();
    _loadUserInfo();
  }

  void _loadUserInfo() async {
    String userName = await _storage.read(key: 'userName') ?? 'No Username';
    String name = await _storage.read(key: 'name') ?? 'No Name';
    print("Loaded user name: $userName and name: $name"); // Add this to check what is loaded
    setState(() {
      _userName = userName;
      _name = name;
    });
  }


  void _toggleUserList() {
    setState(() {
      _showUserList = !_showUserList;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('User List'),
        actions: [
          IconButton(
            icon: Icon(_showUserList ? Icons.visibility_off : Icons.visibility),
            onPressed: _toggleUserList,
          ),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          children: <Widget>[
            UserAccountsDrawerHeader(
              accountName: Text(_name),
              accountEmail: Text(_userName),
              currentAccountPicture: CircleAvatar(
                backgroundColor: Colors.blueAccent,
                child: Text(_name.isNotEmpty ? _name[0] : 'A'),
              ),
            ),
            ListTile(
              title: Text('Home'),
              leading: Icon(Icons.home),
              onTap: () {},
            ),
            ListTile(
              title: Text('Log out'),
              leading: Icon(Icons.exit_to_app),
              onTap: () {
                // Assuming logoutUser() is a method in your ApiService
                Provider.of<ApiService>(context, listen: false).logoutUser();
                Navigator.of(context).pushReplacementNamed('/login');
              },
            ),
          ],
        ),
      ),
      body: _showUserList ? Consumer<ApiService>(
        builder: (context, api, child) {
          return FutureBuilder<List<User>>(
            future: api.fetchUsers(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return CircularProgressIndicator();
              } else if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}');
              } else {
                var users = snapshot.data ?? [];
                return ListView.builder(
                  itemCount: users.length,
                  itemBuilder: (context, index) {
                    User user = users[index];
                    return ListTile(
                      title: Text('Name: ${user.name}'),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Username: ${user.userId}'),
                          Text('Email: ${user.email}'),
                          // Add any additional user details here
                        ],
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: Icon(Icons.edit),
                            onPressed: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => UpdateUserScreen(user: user),
                              ));
                            },
                          ),
                          IconButton(
                            icon: Icon(Icons.delete),
                            onPressed: () {
                              showDialog(
                                context: context,
                                builder: (ctx) => AlertDialog(
                                  title: Text("Confirm"),
                                  content: Text("Are you sure you want to delete this user?"),
                                  actions: [
                                    TextButton(
                                      onPressed: () async {
                                        await Provider.of<UserController>(context, listen: false).deleteUser(user.id);
                                        Navigator.pop(ctx);
                                      },
                                      child: Text("Delete"),
                                    ),
                                    TextButton(
                                      onPressed: () => Navigator.pop(ctx),
                                      child: Text("Cancel"),
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    );
                  },
                );

              }
            },
          );
        },
      ) : Center(child: Text("User list hidden")),
    );
  }
}
