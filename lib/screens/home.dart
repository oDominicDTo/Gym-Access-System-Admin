import 'package:flutter/material.dart';


import '../widget/custom_drawer.dart';



class HomeAdmin extends StatelessWidget {
  TextEditingController _searchController = TextEditingController();


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(70.0),
        child: AppBar(
          backgroundColor: Colors.white,
          elevation: 4,
          titleSpacing: 0,
          title: Row(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 30.0, bottom: 25.0, left: 2.0, right: 2.0),
                child: SizedBox(
                  height: 50,
                  width: 300,
                  child: Image.asset(
                    'assets/images/whole_logo.png',
                    fit: BoxFit.contain,
                  ),
                ),
              ),

            ],
          ),
          actions: [
            Stack(
              children: [
                Container(
                  height: 50,
                  width: 300,
                  margin: EdgeInsets.all(8),
                  child: TextField(
                    controller: _searchController,
                    onChanged: (value) {
                      // Handle the search text changes here
                    },
                    decoration: InputDecoration(
                        hintText: 'Search',
                        hintStyle: TextStyle(fontFamily: 'Poppins'),
                      border: OutlineInputBorder(),
                      prefixIcon: _searchController.text.isNotEmpty
                          ? IconButton(
                        icon: Icon(Icons.clear),
                        onPressed: () {
                          _searchController.clear();
                          // Add logic to clear the search field
                        },
                      )
                          : null,
                    ),
                  ),
                ),
                Positioned(
                  right: 10,
                  top: 5,
                  child: IconButton(
                    icon: Icon(Icons.clear),
                    onPressed: () {
                      _searchController.clear();
                      // Add logic to clear the search field
                    },
                  ),
                ),
              ],
            ),
            // Add New Member Button
            Padding(
              padding: const EdgeInsets.all(8.0),
              child:  ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: Colors.black),
                onPressed: () {


                  // Save logic here
                },
                child: Text(
                  'Add Member',
                  style: TextStyle(fontFamily: 'Poppins', color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
      drawer: CustomDrawer(),
      body: Center(

          child: Text('Renew Subscription'),

      ),
    );
  }
}
