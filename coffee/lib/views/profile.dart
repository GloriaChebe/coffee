// import 'package:flutter/material.dart';

// import 'package:get/get.dart';
// import 'package:get/get_connect/http/src/utils/utils.dart';
// import 'package:get/get_core/src/get_main.dart';
// import 'package:http/http.dart' as http;

// UserProfileController userController = Get.put(UserProfileController());

// class ProfileDetailsPage extends StatefulWidget {
//   @override
//   _ProfileDetailsPageState createState() => _ProfileDetailsPageState();
// }

// class _ProfileDetailsPageState extends State<ProfileDetailsPage> {
//   final _formKey = GlobalKey<FormState>();

//   // Initialize user details from storage
//   late String _name;
//   late String _email;
//   late String _phone;

//   // Controllers for editing
//   late TextEditingController _firstNameController;
//   late TextEditingController _lastNameController;
//   late TextEditingController _emailController;
//   late TextEditingController _phoneController;

//   bool _isEditing = false;

//   @override
//   void initState() {
//     super.initState();
//     _name = "${storage.read('firstName') ?? ""} ${storage.read('lastName') ?? ""}".trim();
//     _email = storage.read('email') ?? "";
//     _phone = storage.read('phoneNumber') ?? "";

//     // Initialize separate controllers for first and last names
//     _firstNameController = TextEditingController(text: storage.read('firstName') ?? "");
//     _lastNameController = TextEditingController(text: storage.read('lastName') ?? "");
//     _emailController = TextEditingController(text: _email);
//     _phoneController = TextEditingController(text: _phone);
//   }

//   @override
//   void dispose() {
//     _firstNameController.dispose();
//     _lastNameController.dispose();
//     _emailController.dispose();
//     _phoneController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     userController.fetchUserProfile;
//     return Scaffold(
//       backgroundColor: Colors.grey[50],
//       appBar: AppBar(
//         automaticallyImplyLeading: true,
//         foregroundColor: appwhiteColor,
//         elevation: 0,
//         centerTitle: true,
//         title: Text(
//           'Profile',
//           style: TextStyle(
//             fontWeight: FontWeight.w600,
//             color: Colors.white,
//           ),
//         ),
//         backgroundColor: primaryColor,
//         actions: [
//           if (!_isEditing)
//             IconButton(
//               icon: Icon(Icons.edit_outlined, color: Colors.white),
//               onPressed: () {
//                 setState(() {
//                   _isEditing = true;
//                 });
//               },
//             ),
//         ],
//       ),
//       body: Stack(
//         children: [
//           // Top curved background
//           Container(
//             height: 100,
//             decoration: BoxDecoration(
//               color: primaryColor,
//               borderRadius: BorderRadius.only(
//                 bottomLeft: Radius.circular(30),
//                 bottomRight: Radius.circular(30),
//               ),
//             ),
//           ),

//           // Main content
//           SingleChildScrollView(
//             child: Padding(
//               padding: EdgeInsets.symmetric(horizontal: 20.0),
//               child: Form(
//                 key: _formKey,
//                 child: Column(
//                   children: [
//                     SizedBox(height: 20),

//                     // Profile avatar section with edit button
//                     Stack(
//                       alignment: Alignment.center,
//                       children: [
//                         // Avatar container with shadow
//                         Container(
//                           padding: EdgeInsets.all(4),
//                           decoration: BoxDecoration(
//                             color: Colors.white,
//                             shape: BoxShape.circle,
//                             boxShadow: [
//                               BoxShadow(
//                                 color: Colors.black.withOpacity(0.1),
//                                 spreadRadius: 1,
//                                 blurRadius: 10,
//                               ),
//                             ],
//                           ),
//                           child: CircleAvatar(
//                             radius: 60,
//                             backgroundColor: Colors.indigo[100],
//                             child: Text(
//                               _name.isNotEmpty ? _name[0].toUpperCase() : "",
//                               style: TextStyle(
//                                 fontSize: 50,
//                                 fontWeight: FontWeight.bold,
//                                 color: Colors.indigo[700],
//                               ),
//                             ),
//                           ),
//                         ),

//                         // Edit avatar button
//                         if (_isEditing)
//                           Positioned(
//                             bottom: 0,
//                             right: 0,
//                             child: Container(
//                               padding: EdgeInsets.all(4),
//                               decoration: BoxDecoration(
//                                 color: Colors.indigo[700],
//                                 shape: BoxShape.circle,
//                               ),
//                             ),
//                           ),
//                       ],
//                     ),

//                     SizedBox(height: 20),

//                     // Name display when not editing
//                     if (!_isEditing)
//                       Text(
//                         _name,
//                         style: TextStyle(
//                           fontSize: 22,
//                           fontWeight: FontWeight.bold,
//                           color: primaryColor,
//                         ),
//                       ),

//                     SizedBox(height: 30),

//                     // Profile info card
//                     Container(
//                       decoration: BoxDecoration(
//                         color: Colors.white,
//                         borderRadius: BorderRadius.circular(15),
//                         boxShadow: [
//                           BoxShadow(
//                             color: Colors.grey.withOpacity(0.1),
//                             spreadRadius: 1,
//                             blurRadius: 10,
//                             offset: Offset(0, 3),
//                           ),
//                         ],
//                       ),
//                       child: Padding(
//                         padding: EdgeInsets.all(20),
//                         child: Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             if (_isEditing)
//                               Text(
//                                 "Personal Information",
//                                 style: TextStyle(
//                                   fontSize: 18,
//                                   fontWeight: FontWeight.bold,
//                                   color: Colors.indigo[900],
//                                 ),
//                               ),

//                             if (_isEditing) SizedBox(height: 20),

//                             // First Name and Last Name Fields
//                             _isEditing
//                                 ? Column(
//                                     children: [
//                                       _buildTextField(
//                                         controller: _firstNameController,
//                                         label: 'First Name',
//                                         icon: Icons.person_outline,
//                                         validator: (value) {
//                                           if (value == null || value.isEmpty) {
//                                             return 'Enter first name';
//                                           }
//                                           return null;
//                                         },
//                                       ),
//                                       SizedBox(height: 16),
//                                       _buildTextField(
//                                         controller: _lastNameController,
//                                         label: 'Last Name',
//                                         icon: Icons.person_outline,
//                                         validator: (value) {
//                                           if (value == null || value.isEmpty) {
//                                             return 'Enter last name';
//                                           }
//                                           return null;
//                                         },
//                                       ),
//                                     ],
//                                   )
//                                 : _buildInfoRow(
//                                     icon: Icons.person_outline,
//                                     label: 'Name',
//                                     value: _name,
//                                   ),

//                             SizedBox(height: _isEditing ? 16 : 12),

//                             // Email Field
//                             _isEditing
//                                 ? _buildTextField(
//                                     controller: _emailController,
//                                     label: 'Email Address',
//                                     icon: Icons.email_outlined,
//                                     keyboardType: TextInputType.emailAddress,
//                                     validator: (value) {
//                                       if (value == null || value.isEmpty) {
//                                         return 'Please enter your email';
//                                       }
//                                       if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
//                                         return 'Enter a valid email';
//                                       }
//                                       return null;
//                                     },
//                                   )
//                                 : _buildInfoRow(
//                                     icon: Icons.email_outlined,
//                                     label: 'Email',
//                                     value: _email,
//                                   ),

//                             SizedBox(height: _isEditing ? 16 : 12),

//                             // Phone Field
//                             _isEditing
//                                 ? _buildTextField(
//                                     controller: _phoneController,
//                                     label: 'Phone Number',
//                                     icon: Icons.phone_outlined,
//                                     keyboardType: TextInputType.phone,
//                                     validator: (value) {
//                                       if (value == null || value.isEmpty) {
//                                         return 'Please enter your phone number';
//                                       }
//                                       if (!RegExp(r'^\d{10}$').hasMatch(value)) {
//                                         return 'Enter a valid phone number';
//                                       }
//                                       return null;
//                                     },
//                                   )
//                                 : _buildInfoRow(
//                                     icon: Icons.phone_outlined,
//                                     label: 'Phone',
//                                     value: _phone,
//                                   ),
//                           ],
//                         ),
//                       ),
//                     ),

//                     SizedBox(height: 30),

//                     // Action buttons
//                     if (_isEditing)
//                       Row(
//                         children: [
//                           Expanded(
//                             child: ElevatedButton(
//                               onPressed: () {
//                                 setState(() {
//                                   _isEditing = false;
//                                   _firstNameController.text = storage.read('firstName') ?? "";
//                                   _lastNameController.text = storage.read('lastName') ?? "";
//                                   _emailController.text = _email;
//                                   _phoneController.text = _phone;
//                                 });
//                               },
//                               child: Padding(
//                                 padding: EdgeInsets.symmetric(vertical: 12),
//                                 child: Text(
//                                   'Cancel',
//                                   style: TextStyle(
//                                     fontSize: 16,
//                                     fontWeight: FontWeight.w500,
//                                   ),
//                                 ),
//                               ),
//                               style: ElevatedButton.styleFrom(
//                                 backgroundColor: Colors.grey[300],
//                                 foregroundColor: Colors.grey[800],
//                                 elevation: 0,
//                                 shape: RoundedRectangleBorder(
//                                   borderRadius: BorderRadius.circular(10),
//                                 ),
//                               ),
//                             ),
//                           ),
//                           SizedBox(width: 16),
//                           Expanded(
//                             child: ElevatedButton(
//                               onPressed: () async {
//                                 if (_formKey.currentState!.validate()) {
//                                   // Get first and last name
//                                   final firstName = _firstNameController.text.trim();
//                                   final lastName = _lastNameController.text.trim();

//                                   final success = await updateProfile(
//                                     userID: storage.read('userID') ?? "",
//                                     firstName: firstName,
//                                     lastName: lastName,
//                                     email: _emailController.text.trim(),
//                                     phoneNumber: _phoneController.text.trim(),
//                                   );

//                                   if (success) {
//                                     // Save updated info in local storage
//                                     storage.write('firstName', firstName);
//                                     storage.write('lastName', lastName);
//                                     storage.write('email', _emailController.text.trim());
//                                     storage.write('phoneNumber', _phoneController.text.trim());

//                                     setState(() {
//                                       _name = "$firstName $lastName";
//                                       _email = _emailController.text;
//                                       _phone = _phoneController.text;
//                                       _isEditing = false;
//                                     });

//                                     ScaffoldMessenger.of(context).showSnackBar(
//                                       SnackBar(
//                                         content: Text('Profile updated successfully!'),
//                                         backgroundColor: Colors.green[600],
//                                       ),
//                                     );
//                                   } else {
//                                     ScaffoldMessenger.of(context).showSnackBar(
//                                       SnackBar(
//                                         content: Text('Failed to update profile. Please try again.'),
//                                         backgroundColor: Colors.red[600],
//                                       ),
//                                     );
//                                   }
//                                 }
//                               },
//                               child: Padding(
//                                 padding: EdgeInsets.symmetric(vertical: 12),
//                                 child: Text(
//                                   'Save',
//                                   style: TextStyle(
//                                     fontSize: 16,
//                                     fontWeight: FontWeight.w500,
//                                   ),
//                                 ),
//                               ),
//                               style: ElevatedButton.styleFrom(
//                                 backgroundColor: Colors.indigo[600],
//                                 foregroundColor: Colors.white,
//                                 elevation: 0,
//                                 shape: RoundedRectangleBorder(
//                                   borderRadius: BorderRadius.circular(10),
//                                 ),
//                               ),
//                             ),
//                           ),
//                         ],
//                       ),

//                     SizedBox(height: 30),
//                   ],
//                 ),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   // Helper method to build text fields
//   Widget _buildTextField({
//     required TextEditingController controller,
//     required String label,
//     required IconData icon,
//     TextInputType? keyboardType,
//     String? Function(String?)? validator,
//   }) {
//     return TextFormField(
//       controller: controller,
//       keyboardType: keyboardType,
//       decoration: InputDecoration(
//         labelText: label,
//         labelStyle: TextStyle(
//           color: Colors.grey[700],
//           fontSize: 15,
//         ),
//         prefixIcon: Icon(
//           icon,
//           color: Colors.indigo[400],
//           size: 22,
//         ),
//         enabledBorder: OutlineInputBorder(
//           borderRadius: BorderRadius.circular(12),
//           borderSide: BorderSide(color: Colors.grey.shade300),
//         ),
//         focusedBorder: OutlineInputBorder(
//           borderRadius: BorderRadius.circular(12),
//           borderSide: BorderSide(color: primaryColor),
//         ),
//       ),
//       validator: validator,
//     );
//   }

//   // Helper method to display info rows (non-editable mode)
//   Widget _buildInfoRow({
//     required IconData icon,
//     required String label,
//     required String value,
//   }) {
//     return Padding(
//       padding: EdgeInsets.only(bottom: 16),
//       child: Row(
//         children: [
//           Icon(
//             icon,
//             color: primaryColor,
//             size: 24,
//           ),
//           SizedBox(width: 10),
//           Text(
//             '$label: $value',
//             style: TextStyle(fontSize: 16, color: Colors.grey[700]),
//           ),
//         ],
//       ),
//     );
//   }

//   Future<bool> updateProfile({
//     required String userID,
//     required String firstName,
//     required String lastName,
//     required String email,
//     required String phoneNumber,
//   }) async {
//     final url = 'https://sanerylgloann.co.ke/donorApp/updateProf.php';

//     try {
//       final response = await http.post(Uri.parse(url), body: {
//         'userID': userID,
//         'firstName': firstName,
//         'lastName': lastName,
//         'email': email,
//         'phoneNumber': phoneNumber,
//       });

//       return response.statusCode == 200;
//     } catch (e) {
//       return false;
//     }
//   }
// }
