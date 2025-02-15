import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/auth_service.dart';
import 'home_screen.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({Key? key}) : super(key: key);

  @override
  _SignupScreenState createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _isLoading = false;
  bool _passwordVisible = false;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _signup() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
    });

    final authService = Provider.of<AuthService>(context, listen: false);
    final result = await authService.signup(
      _nameController.text,
      _emailController.text,
      _phoneController.text,
      _passwordController.text,
    );

    setState(() {
      _isLoading = false;
    });

    if (result == "success") {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const HomeScreen()),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(result), backgroundColor: Colors.red),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: MediaQuery.of(context).size.height - 
                          MediaQuery.of(context).padding.top - 
                          MediaQuery.of(context).padding.bottom,
              ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.favorite, color: Color(0xFF4CAF50), size: 80),
                            const SizedBox(height: 20),
                            const Text(
                              'Create Account',
                                style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
                            ),
                              const SizedBox(height: 40),
                              _buildTextField(_nameController, "Full Name", false),
                              const SizedBox(height: 20),
                              _buildTextField(_emailController, "Email", false, emailValidation: true),
                              const SizedBox(height: 20),
                              _buildTextField(_phoneController, "Phone Number", false),
                              const SizedBox(height: 20),
                              _buildTextField(_passwordController, "Password", true, passwordValidation: true),
                              const SizedBox(height: 20),
                              _buildTextField(_confirmPasswordController, "Confirm Password", true, confirmPassword: true),
                              const SizedBox(height: 30),
                              _isLoading
                              ? const CircularProgressIndicator()
                              : ElevatedButton(
                                  onPressed: _signup,
                                  style: _buttonStyle(),
                                  child: const Text('Sign Up', style: TextStyle(fontSize: 18)),
                                ),
                                const SizedBox(height: 20),
                              TextButton(
                                onPressed: () => Navigator.pop(context),
                                child: const Text('Already have an account? Sign In'),
                              ),
                          ],
                        ),
                    ),
                ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String hintText, bool isPassword,
      {bool emailValidation = false, bool passwordValidation = false, bool confirmPassword = false}) {
    return TextFormField(
      controller: controller,
      obscureText: isPassword ? !_passwordVisible : false,
      decoration: InputDecoration(
        hintText: hintText,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        suffixIcon: isPassword
            ? IconButton(
                icon: Icon(_passwordVisible ? Icons.visibility : Icons.visibility_off),
                onPressed: () => setState(() => _passwordVisible = !_passwordVisible),
              )
            : null,
      ),
      validator: (value) {
        if (value == null || value.isEmpty) return "This field cannot be empty";

        if (emailValidation && !RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
          return "Enter a valid email";
        }

        if (passwordValidation && !RegExp(r'^(?=.*[A-Za-z])(?=.*\d)(?=.*[@$!%*?&])[A-Za-z\d@$!%*?&]{8,}$').hasMatch(value)) {
          return "Password must be at least 8 characters, include a number";
        }

        if (confirmPassword && value != _passwordController.text) {
          return "Passwords do not match";
        }

        return null;
      },
    );
  }

  ButtonStyle _buttonStyle() {
    return ElevatedButton.styleFrom(
      backgroundColor: const Color(0xFF4CAF50),
      minimumSize: const Size(double.infinity, 50),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
    );
  }
}
