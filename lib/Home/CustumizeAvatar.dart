import 'package:flutter/material.dart';

import '../screens/chat_screen.dart';

class CustomizeAvatarPage extends StatelessWidget {
  final List<Category> categories = [
    Category('Dev', Icons.code),
    Category('History', Icons.book),
    Category('Health', Icons.monitor_heart),

  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Customize Avatar'),
        leading: IconButton(
          onPressed: (){
            Navigator.pop(context);
          },
          icon: Icon(Icons.arrow_back),
        ),
        actions: [
          CircleAvatar(
              radius: 20,// Circular icon
              backgroundImage: AssetImage('assets/user_profile.jpg') // Replace with user's image URL
          ),
          SizedBox(width: 8,)
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Customize Your Avatar',
              style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
            ),
            Divider(height: 30.0, thickness: 2.0),
            SizedBox(
              width: double.infinity,
              height: 50.0,
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10.0),
                  border: Border.all(color: Colors.grey),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                  child: TextField(
                    //controller: _textFieldController,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: 'Enter Avatar name',
                    ),
                  ),
                ),
              ),
            ),

            SizedBox(height: 20.0),
            SizedBox(
              width: double.infinity,
              height: 50.0,
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10.0),
                  border: Border.all(color: Colors.grey),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                  child: TextField(
                    //: _textFieldController,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: 'Enter Description',
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: 20.0),
            Text(
              'Categories',
              style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10.0),
            Expanded(
              child: GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 10.0,
                  mainAxisSpacing: 10.0,
                  childAspectRatio: 1.0,
                ),
                itemCount: categories.length,
                itemBuilder: (context, index) {
                  return CategoryCard(categories[index]);
                },
              ),
            ),
            SizedBox(height: 10,),
            SizedBox(
              width: double.infinity,
              height: 50.0,
              child: ElevatedButton(
                onPressed: () {
                  //String name = _textFieldController.text;
                  Navigator.push(context, MaterialPageRoute(builder: (conext)=> Chat(name: 'Dev',)));
                },
                child: Text(
                  'Create',
                  style: TextStyle(fontSize: 16.0),
                ),
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class Category {
  final String name;
  final IconData icon;

  Category(this.name, this.icon);
}

class CategoryCard extends StatelessWidget {
  final Category category;

  CategoryCard(this.category);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        onTap: () {
          Navigator.push(context, MaterialPageRoute(builder: (conext)=> Chat(name: category.name,)));
        },
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(category.icon, size: 50.0),
            SizedBox(height: 10.0),
            Text(
              category.name,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16.0),
            ),
          ],
        ),
      ),
    );
  }
}


