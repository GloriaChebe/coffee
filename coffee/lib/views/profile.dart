import 'package:coffee/controller/profileController.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:coffee/configs/constants.dart';
import 'package:get_storage/get_storage.dart';

final storage = GetStorage();

UserProfileController userController = Get.put(UserProfileController());

class ProfileDetailsPage extends StatefulWidget {
  @override
  _ProfileDetailsPageState createState() => _ProfileDetailsPageState();
}

class _ProfileDetailsPageState extends State<ProfileDetailsPage> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _firstNameController;
  late TextEditingController _lastNameController;
  late TextEditingController _emailController;
  late TextEditingController _phoneController;

  bool _isEditing = false;

  @override
  void initState() {
    super.initState();
    _firstNameController = TextEditingController(text: storage.read('firstName')?.toString() ?? '');
    _lastNameController = TextEditingController(text: storage.read('lastName')?.toString() ?? '');
    _emailController = TextEditingController(text: storage.read('email')?.toString() ?? '');
    _phoneController = TextEditingController(text: storage.read('phoneNo')?.toString() ?? '');
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final _name = "${_firstNameController.text} ${_lastNameController.text}".trim();

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        automaticallyImplyLeading: true,
        foregroundColor: appwhiteColor,
        elevation: 0,
        centerTitle: true,
        title: Text('Profile', style: TextStyle(fontWeight: FontWeight.w600)),
        backgroundColor: primaryColor,
        actions: [
          if (!_isEditing)
            IconButton(
              icon: Icon(Icons.edit_outlined, color: Colors.white),
              onPressed: () => setState(() => _isEditing = true),
            ),
        ],
      ),
      body: Stack(
        children: [
          Container(
            height: 100,
            decoration: BoxDecoration(
              color: primaryColor,
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(30),
                bottomRight: Radius.circular(30),
              ),
            ),
          ),
          SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  // Profile Avatar
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      Container(
                        padding: EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              spreadRadius: 1,
                              blurRadius: 10,
                            ),
                          ],
                        ),
                        child: CircleAvatar(
                          radius: 60,
                          backgroundColor: Colors.indigo[100],
                          child: Text(
                            _name.isNotEmpty ? _name[0].toUpperCase() : "",
                            style: TextStyle(
                              fontSize: 50,
                              fontWeight: FontWeight.bold,
                              color: Colors.indigo[700],
                            ),
                          ),
                        ),
                      ),
                      if (_isEditing)
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: Container(
                            padding: EdgeInsets.all(4),
                            decoration: BoxDecoration(
                              color: Colors.indigo[700],
                              shape: BoxShape.circle,
                            ),
                            child: Icon(Icons.edit, color: Colors.white, size: 18),
                          ),
                        ),
                    ],
                  ),
                  SizedBox(height: 20),
                  if (!_isEditing)
                    Text(_name, style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: primaryColor)),
                  SizedBox(height: 30),

                  // Info Card
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(15),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.1),
                          spreadRadius: 1,
                          blurRadius: 10,
                          offset: Offset(0, 3),
                        ),
                      ],
                    ),
                    padding: EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (_isEditing)
                          Text(
                            "Personal Information",
                            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.indigo[900]),
                          ),
                        if (_isEditing) SizedBox(height: 20),
                        _isEditing
                            ? Column(
                                children: [
                                  _buildTextField(controller: _firstNameController, label: 'First Name', icon: Icons.person_outline),
                                  SizedBox(height: 16),
                                  _buildTextField(controller: _lastNameController, label: 'Last Name', icon: Icons.person_outline),
                                  SizedBox(height: 16),
                                  _buildTextField(
                                      controller: _emailController,
                                      label: 'Email',
                                      icon: Icons.email_outlined,
                                      keyboardType: TextInputType.emailAddress),
                                  SizedBox(height: 16),
                                  _buildTextField(
                                      controller: _phoneController,
                                      label: 'Phone Number',
                                      icon: Icons.phone_outlined,
                                      keyboardType: TextInputType.phone),
                                ],
                              )
                            : Column(
                                children: [
                                  _buildInfoRow(icon: Icons.person_outline, label: 'Name', value: _name),
                                  _buildInfoRow(icon: Icons.email_outlined, label: 'Email', value: _emailController.text),
                                  _buildInfoRow(icon: Icons.phone_outlined, label: 'Phone', value: _phoneController.text),
                                ],
                              ),
                      ],
                    ),
                  ),
                  SizedBox(height: 30),

                  // Action Buttons
                  if (_isEditing)
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () {
                              setState(() {
                                _isEditing = false;
                                _firstNameController.text = storage.read('firstName')?.toString() ?? '';
                                _lastNameController.text = storage.read('lastName')?.toString() ?? '';
                                _emailController.text = storage.read('email')?.toString() ?? '';
                                _phoneController.text = storage.read('phoneNo')?.toString() ?? '';
                              });
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.grey[300],
                              foregroundColor: Colors.grey[800],
                              elevation: 0,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                            ),
                            child: Padding(
                              padding: EdgeInsets.symmetric(vertical: 12),
                              child: Text('Cancel', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
                            ),
                          ),
                        ),
                        SizedBox(width: 16),
                        Expanded(
                          child: ElevatedButton(
                            onPressed: _saveProfile,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.indigo[600],
                              foregroundColor: Colors.white,
                              elevation: 0,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                            ),
                            child: Padding(
                              padding: EdgeInsets.symmetric(vertical: 12),
                              child: Text('Save', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
                            ),
                          ),
                        ),
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

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    TextInputType? keyboardType,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      validator: (value) => value == null || value.isEmpty ? 'Field required' : null,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(color: Colors.grey[700], fontSize: 15),
        prefixIcon: Icon(icon, color: Colors.indigo[400], size: 22),
        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: Colors.grey.shade300)),
        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: primaryColor)),
      ),
    );
  }

  Widget _buildInfoRow({required IconData icon, required String label, required String value}) {
    return Padding(
      padding: EdgeInsets.only(bottom: 16),
      child: Row(
        children: [
          Icon(icon, color: primaryColor, size: 24),
          SizedBox(width: 10),
          Text('$label: $value', style: TextStyle(fontSize: 16, color: Colors.grey[700])),
        ],
      ),
    );
  }

  void _saveProfile() async {
    if (_formKey.currentState!.validate()) {
      final firstName = _firstNameController.text.trim();
      final lastName = _lastNameController.text.trim();
      final email = _emailController.text.trim();
      final phoneNo = _phoneController.text.trim();

      final userID = storage.read('userID')?.toString() ?? '';

      final success = await updateProfile(
        userID: userID,
        firstName: firstName,
        lastName: lastName,
        email: email,
        phoneNo: phoneNo,
      );

      if (success) {
        storage.write('firstName', firstName);
        storage.write('lastName', lastName);
        storage.write('email', email);
        storage.write('phoneNo', phoneNo);

        setState(() => _isEditing = false);

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Profile updated successfully!'), backgroundColor: Colors.green[600]),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to update profile. Try again.'), backgroundColor: Colors.red[600]),
        );
      }
    }
  }

  Future<bool> updateProfile({
    required String userID,
    required String firstName,
    required String lastName,
    required String email,
    required String phoneNo,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('https://sanerylgloann.co.ke/coffeeInn/updateProfile.php'),
        body: {
          'userID': userID,
          'firstName': firstName,
          'lastName': lastName,
          'email': email,
          'phoneNo': phoneNo,
        },
      );
      print(response.body);
      return response.statusCode == 200;
    } catch (e) {
      return false;
    }
  }
}
