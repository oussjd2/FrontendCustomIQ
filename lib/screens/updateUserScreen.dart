import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/user.dart';
import '../controllers/user_controller.dart';

class UpdateUserScreen extends StatefulWidget {
  final User user;

  const UpdateUserScreen({Key? key, required this.user}) : super(key: key);

  @override
  _UpdateUserScreenState createState() => _UpdateUserScreenState();
}

class _UpdateUserScreenState extends State<UpdateUserScreen> {
  final _formKey = GlobalKey<FormState>();
  late String _name, _email, _password;

  @override
  void initState() {
    super.initState();
    _name = widget.user.name;
    _email = widget.user.email;
    _password = '';  // Initialize password as empty for security reasons
  }

  void _updateUser() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      final updatedUser = User(
        id: widget.user.id,
        name: _name,
        userId: widget.user.userId,
        avatarUrl: widget.user.avatarUrl,
        email: _email,
        password: _password,  // Include the password if it's been changed
      );

      // Call the update function from the UserController
      Provider.of<UserController>(context, listen: false)
          .updateUser(widget.user.id, updatedUser)
          .then((_) {
        Navigator.pop(context);  // Pop on successful update
      }).catchError((error) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Error updating user: $error'),
          backgroundColor: Colors.red,
        ));
      });
    }
  }

  void _deleteUser() {
    // Call the delete function from the UserController
    Provider.of<UserController>(context, listen: false)
        .deleteUser(widget.user.id)
        .then((_) {
      Navigator.pop(context);  // Pop on successful deletion
    }).catchError((error) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Error deleting user: $error'),
        backgroundColor: Colors.lightBlue,
      ));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit User'),
        actions: [
          IconButton(
            icon: Icon(Icons.delete),
            onPressed: _deleteUser,
          )
        ],
      ),
      body: Form(
        key: _formKey,
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            children: <Widget>[
              TextFormField(
                initialValue: _name,
                decoration: InputDecoration(labelText: 'Name'),
                validator: (value) => value!.isEmpty ? 'Please enter a name' : null,
                onSaved: (value) => _name = value!,
              ),
              TextFormField(
                initialValue: _email,
                decoration: InputDecoration(labelText: 'Email'),
                validator: (value) => value!.isEmpty ? 'Please enter an email' : null,
                onSaved: (value) => _email = value!,
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Username'),
                initialValue: widget.user.userId,
                enabled: false,
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Avatar URL'),
                initialValue: widget.user.avatarUrl ?? '',
                onChanged: (value) => _password = value,
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Password (change)'),
                validator: (value) => value!.isNotEmpty && value.length < 6 ? 'Password must be at least 6 characters' : null,
                onSaved: (value) => _password = value!,
                obscureText: true,
              ),
              ElevatedButton(
                onPressed: _updateUser,
                child: Text('Update User'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
