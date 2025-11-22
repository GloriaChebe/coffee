import 'package:cached_network_image/cached_network_image.dart';
import 'package:coffee/configs/constants.dart';
import 'package:coffee/controller/itemController.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:io';
import 'package:image_picker/image_picker.dart';


   final ItemController itemController = Get.put(ItemController());
    final TextEditingController priceController = TextEditingController();
    
    File? selectedImage;
    final TextEditingController nameController = TextEditingController();
    final TextEditingController amountController = TextEditingController();

class CategoriesAdmin extends StatefulWidget {
  @override
  _CategoriesAdminState createState() => _CategoriesAdminState();
}

class _CategoriesAdminState extends State<CategoriesAdmin> {
 
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        automaticallyImplyLeading: true,
        foregroundColor: appwhiteColor,
        title: Center(
          child: Text(
            'Manage Items',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
          ),
        ),
        backgroundColor: primaryColor,
      ),
      body: Column(
        children: [
        
         

          // Header Section
          Padding(
            padding: EdgeInsets.fromLTRB(16, 8, 16, 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Obx(() => Text(
                      itemController.selectedCategory.value == 'All'
                          ? 'All Items'
                          : '${itemController.selectedCategory.value} Items',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    )),
                SizedBox(width: 16),
              

                Container(
                  width: MediaQuery.of(context).size.width * 0.5,
                  child: TextField(
                    onChanged: (value) {
                      itemController.searchItems(value);
                    },
                    decoration: InputDecoration(
                      hintText: 'Search...',
                      prefixIcon: Icon(Icons.search),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide.none,
                      ),
                      filled: true,
                      contentPadding: EdgeInsets.symmetric(vertical: 0, horizontal: 20),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Items Grid
          Expanded(
            child: _ItemGrid(itemController: itemController),
          ),
        ],
      ),
      
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          print('clicked'); 
          _showAddItemDialog(context); // Call the dialog method
        },
        backgroundColor: primaryColor,
        child: Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  
  void _showAddItemDialog(BuildContext context) {
    
  

    Future<void> _pickImage() async {
      final picker = ImagePicker();
      final pickedFile = await picker.pickImage(source: ImageSource.gallery);

      if (pickedFile != null) {
        setState(() {
          selectedImage = File(pickedFile.path);
        });
      }
    }

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: Text('Add New Item'),
              content: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    
                    TextField(
  controller: nameController,
  decoration: InputDecoration(
    labelText: 'Name',
    border: OutlineInputBorder(),
  ),
  inputFormatters: [
    FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z\s]')),
  ],
),

                  
                    
                    SizedBox(height: 16),
                    TextField(
  controller: priceController,
  decoration: InputDecoration(
    labelText: 'Price',
    border: OutlineInputBorder(),
  ),
  inputFormatters: [
    FilteringTextInputFormatter.allow(RegExp(r'[0-9]'))
,
  ],
),
                   
                    SizedBox(height: 16),
                    // Image picker section
                    Row(
                      children: [
                        // Image display container
                        Expanded(
                          child: Container(
                            height: 100,
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: selectedImage != null
                                ? ClipRRect(
                                    borderRadius: BorderRadius.circular(8),
                                    child: Image.file(
                                      selectedImage!,
                                      fit: BoxFit.cover,
                                    ),
                                  )
                                : Center(
                                    child: Text(
                                      'No image selected',
                                      style: TextStyle(color: Colors.grey),
                                    ),
                                  ),
                          ),
                        ),
                        SizedBox(width: 8),

                        // Upload button
                        ElevatedButton(
                          onPressed: () async {
                            await _pickImage();
                            setState(() {});
                          },
                          child: Text('Select image',style: TextStyle(color: appwhiteColor,fontSize: 12),),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: primaryColor,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    nameController.clear(); // Clear the name field
                    selectedImage = null; // Clear the selected image
                     // Clear the form fields
                    Navigator.of(context).pop(); // Close the dialog
                  },
                  child: Text('Cancel'),
                ),
                ElevatedButton(
                  onPressed: () {
  if (nameController.text.isEmpty) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Name is required!'),
        backgroundColor: Colors.red,
      ),
    );
    return;
  }

 

  if (selectedImage == null) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Please select an image!'),
        backgroundColor: Colors.red,
      ),
    );
    return;
  }

  addItems(context);
  Navigator.of(context).pop();
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text('Added successfully!'),
      duration: Duration(seconds: 1),
      backgroundColor: secondaryColor,
    ),
  );
},

                  child: Text(
                    'Add',
                    style: TextStyle(color: appwhiteColor),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryColor,
                    foregroundColor: appwhiteColor,
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }
  
 Future<void> addItems(context) async {
    if (selectedImage == null) {
      print("No image selected.");
      return;
    }

    final url = Uri.parse(
      'https://sanerylgloann.co.ke/coffeeInn/createItems.php',
    ); // Update with your API endpoint

    var request = http.MultipartRequest("POST", url);

    
    request.fields['name'] = nameController.text;
    request.fields['price'] = priceController.text;
     //request.fields['amount'] = amountController.text;

    // Attach image file
    var imageFile = await http.MultipartFile.fromPath(
      'image',
      selectedImage!.path,
    );
    request.files.add(imageFile);

    // Send request
    var response = await request.send();

    if (response.statusCode == 200) {
      print("Response: ${await response.stream.bytesToString()}");
      print("Item added successfully");
      await itemController.fetchDonationItems();
     // Navigator.of(context).pop(); // Close the popup
    } else {
      print("Failed to add item");
    }
  }
}





// Items Grid Widget
class _ItemGrid extends StatelessWidget {
  final ItemController itemController;

  _ItemGrid({required this.itemController});

  @override
  Widget build(BuildContext context) {
    return Obx(() => GridView.builder(
          padding: EdgeInsets.all(16),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 0.71,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
          ),
          itemCount: itemController.filteredItems.length,
          itemBuilder: (context, index) {
            var item = itemController.filteredItems[index];
            return _ItemCard(item: item);
          },
        ));
  }
}

// Item Card Widget
class _ItemCard extends StatelessWidget {
  final dynamic item;

  _ItemCard({required this.item});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Item image
          AspectRatio(
            aspectRatio: 1.2,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.grey.shade200,
                image: DecorationImage(
                  image: CachedNetworkImageProvider('https://sanerylgloann.co.ke/coffeeInn/coffees/' + item.image),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),

          // Item details
          Expanded(
            child: Padding(
              padding: EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    item.name,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 8),
                  
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () async {
                            http.Response response = await http.post(
                              Uri.parse('https://sanerylgloann.co.ke/coffeeInn/deleteItem.php'),
                              body: {
                                'itemID': item.itemsID,
                              },
                            );
                            if (response.statusCode == 200) {
                              // Handle successful deletion
                              print('Item deleted successfully');
                              itemController.fetchDonationItems();
                              Get.snackbar("Success", "Item deleted successfully");
                            } else {
                              // Handle error
                              print('Failed to delete item');
                              Get.snackbar("Error", "Failed to delete item");
                            }
                          },
                          child: Text(
                            'Delete',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: primaryColor,
                            padding: EdgeInsets.symmetric(vertical: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: 8), 
                      
                    
                       
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// Custom search delegate
class ItemSearchDelegate extends SearchDelegate<String> {
  final ItemController itemController;

  ItemSearchDelegate(this.itemController);

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.arrow_back),
      onPressed: () {
        close(context, '');
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    // Implement search results
    return _buildSearchResults();
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    // Implement search suggestions
    return _buildSearchResults();
  }

  Widget _buildSearchResults() {
    final results = itemController.items
        .where((item) => item.name.toLowerCase().contains(query.toLowerCase()))
        .toList();

    return ListView.builder(
      itemCount: results.length,
      itemBuilder: (context, index) {
        final item = results[index];
        return ListTile(
          leading: Container(
            width: 50,
            height: 50,
            color: Colors.grey.shade200,
            child: Center(
              child: Icon(Icons.image, color: Colors.grey),
            ),
          ),
          title: Text(item.name),
          subtitle: Text(item.price),
          onTap: () {
            // Handle item selection
            close(context, item.name);
          },
        );
      },
    );
  }



 
}