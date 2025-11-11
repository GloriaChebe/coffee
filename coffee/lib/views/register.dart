import 'dart:convert';
import 'package:coffee/configs/constants.dart';
import 'package:coffee/views/login.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class RegistrationPage extends StatefulWidget {
  const RegistrationPage({super.key});

  @override
  State<RegistrationPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegistrationPage> {
  final _formKey = GlobalKey<FormState>();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _obscurePassword = true;
  bool _isLoading = false;

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _submit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    final uri = Uri.parse('https://sanerylgloann.co.ke/coffeeInn/createUsers.php');

    final body = {
      'firstName': _firstNameController.text.trim(),
      'lastName': _lastNameController.text.trim(),
      'email': _emailController.text.trim(),
      'phoneNo': _phoneController.text.trim(),
      'password': _passwordController.text,
    };

    try {
      final response = await http.post(uri, body: body).timeout(const Duration(seconds: 15));
      setState(() => _isLoading = false);

     if (response.statusCode == 200) {
  final data = jsonDecode(response.body);
  final msg = data['message'] ?? response.body;

  // Properly handle int/string from backend
  final successRaw = data['success'];
  final ok = successRaw == 1 || successRaw == '1' || data['status'] == 'ok';

  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg.toString())));

  if (ok) {
    // Navigate to login page
    Get.offAll(() => const LoginPage());
  }
  return;
}


      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed: ${response.statusCode} ${response.reasonPhrase}')),
      );
    } catch (e) {
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: ${e.toString()}')),
      );
    }
  }

  InputDecoration _inputDecoration({required String label, IconData? icon}) {
    return InputDecoration(
      labelText: label,
      prefixIcon: icon != null ? Icon(icon) : null,
      filled: true,
      fillColor: Colors.white.withOpacity(0.9),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12.0)),
      contentPadding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 16.0),
    );
  }

  @override
  Widget build(BuildContext context) {
    final mq = MediaQuery.of(context);
    final isWide = mq.size.width > 600;

    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text('Create account'),
        centerTitle: true,
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF6F4E37), Color(0xFFB07C5A)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
            child: ConstrainedBox(
              constraints: BoxConstraints(maxWidth: isWide ? 700 : 500),
              child: Card(
                elevation: 20,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                color: Colors.white.withOpacity(0.95),
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Row(
                          children: [
                            Container(
                              height: 64,
                              width: 64,
                              decoration: BoxDecoration(
                                color: primaryColor.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: const Icon(Icons.local_cafe, size: 36, color: primaryColor),
                            ),
                            const SizedBox(width: 12),
                            const Expanded(
                              child: Text(
                                'Sign Up for CoffeeApp',
                                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 18),

                        // Names fields
                        isWide
                            ? Row(
                                children: [
                                  Expanded(
                                    child: TextFormField(
                                      controller: _firstNameController,
                                      decoration: _inputDecoration(label: 'First Name', icon: Icons.person),
                                      validator: (value) {
                                        if (value == null || value.isEmpty) return 'Please enter your first name';
                                        return null;
                                      },
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: TextFormField(
                                      controller: _lastNameController,
                                      decoration: _inputDecoration(label: 'Last Name', icon: Icons.person_outline),
                                      validator: (value) {
                                        if (value == null || value.isEmpty) return 'Please enter your last name';
                                        return null;
                                      },
                                    ),
                                  ),
                                ],
                              )
                            : Column(
                                children: [
                                  TextFormField(
                                    controller: _firstNameController,
                                    decoration: _inputDecoration(label: 'First Name', icon: Icons.person),
                                    validator: (value) {
                                      if (value == null || value.isEmpty) return 'Please enter your first name';
                                      return null;
                                    },
                                  ),
                                  const SizedBox(height: 12),
                                  TextFormField(
                                    controller: _lastNameController,
                                    decoration: _inputDecoration(label: 'Last Name', icon: Icons.person_outline),
                                    validator: (value) {
                                      if (value == null || value.isEmpty) return 'Please enter your last name';
                                      return null;
                                    },
                                  ),
                                ],
                              ),
                        const SizedBox(height: 12),

                        TextFormField(
                          controller: _emailController,
                          decoration: _inputDecoration(label: 'Email', icon: Icons.email),
                          keyboardType: TextInputType.emailAddress,
                          validator: (value) {
                            if (value == null || value.isEmpty) return 'Please enter your email';
                            if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value))
                              return 'Please enter a valid email';
                            return null;
                          },
                        ),
                        const SizedBox(height: 12),

                        TextFormField(
                          controller: _phoneController,
                          decoration: _inputDecoration(label: 'Phone Number', icon: Icons.phone),
                          keyboardType: TextInputType.phone,
                          validator: (value) {
                            if (value == null || value.isEmpty) return 'Please enter your phone number';
                            return null;
                          },
                        ),
                        const SizedBox(height: 12),

                        TextFormField(
                          controller: _passwordController,
                          decoration: _inputDecoration(label: 'Password', icon: Icons.lock).copyWith(
                            suffixIcon: IconButton(
                              icon: Icon(_obscurePassword ? Icons.visibility_off : Icons.visibility),
                              onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
                            ),
                          ),
                          obscureText: _obscurePassword,
                          validator: (value) {
                            if (value == null || value.isEmpty) return 'Please enter a password';
                            if (value.length < 6) return 'Password must be at least 6 characters';
                            return null;
                          },
                        ),
                        const SizedBox(height: 8),

                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: _isLoading ? null : _submit,
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                              backgroundColor: Colors.brown.shade700,
                              elevation: 6,
                            ),
                            child: _isLoading
                                ? const SizedBox(
                                    height: 18,
                                    width: 18,
                                    child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                                  )
                                : const Text(
                                    'Create account',
                                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.white),
                                  ),
                          ),
                        ),
                        const SizedBox(height: 12),

                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text('Already have an account?'),
                            TextButton(
                              onPressed: () {
                                Get.to(() => const LoginPage());
                              },
                              child: Text(
                                'Sign in',
                                style: TextStyle(color: secondaryColor.withOpacity(0.9)),
                              ),
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
