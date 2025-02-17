import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/auth_service.dart';
import 'home_screen.dart';
import 'signup_screen.dart';
import 'forget_password_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _passwordVisible = false;
  bool _isLoading = false;
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _login() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    final authService = Provider.of<AuthService>(context, listen: false);
    final result = await authService.login(
      _emailController.text,
      _passwordController.text,
    );

    setState(() => _isLoading = false);

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
      backgroundColor: Colors.white,
      body: FadeTransition(
        opacity: _animationController,
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width * 0.8,
                      height: MediaQuery.of(context).size.height * 0.3,
                      child: Image(
                        image: const AssetImage('assets/logingraphics.jpg'),
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'Sign In',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Welcome back! Please enter your details.',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.black54,
                    ),
                  ),
                  const SizedBox(height: 32),
                  Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        _buildTextField(_emailController, "Email", false, emailValidation: true),
                        const SizedBox(height: 20),
                        _buildTextField(_passwordController, "Password", true, passwordValidation: true),
                      ],
                    ),
                  ),
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: () => Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const ForgotPasswordScreen()),
                      ),
                      child: const Text(
                        'Forgot Password?',
                        style: TextStyle(color: Colors.blueAccent),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  _isLoading
                      ? const Center(child: CircularProgressIndicator())
                      : SizedBox(
                          width: double.infinity,
                          height: 50,
                          child: ElevatedButton(
                            onPressed: _login,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blueAccent,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                              elevation: 4, // Subtle shadow for elevation
                            ),
                            child: const Text('Sign In', style: TextStyle(fontSize: 18, color: Colors.white)),
                          ),
                        ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text("Don't have an account? ", style: TextStyle(color: Colors.black54)),
                      GestureDetector(
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const SignupScreen()),
                        ),
                        child: const Text(
                          'Sign Up',
                          style: TextStyle(color: Colors.blueAccent, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 30),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(
                        onPressed: () {},
                        icon: const Icon(Icons.facebook, color: Colors.blue),
                        iconSize: 36,
                      ),
                      IconButton(
                        onPressed: () {},
                        icon: const Icon(Icons.g_mobiledata, color: Colors.red),
                        iconSize: 36,
                      ),
                      IconButton(
                        onPressed: () {},
                        icon: const Icon(Icons.apple, color: Colors.black),
                        iconSize: 36,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String hintText, bool isPassword,
      {bool emailValidation = false, bool passwordValidation = false}) {
    return TextFormField(
      controller: controller,
      obscureText: isPassword ? !_passwordVisible : false,
      decoration: InputDecoration(
        labelText: hintText,
        labelStyle: const TextStyle(color: Colors.black54),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Color.fromRGBO(68, 138, 255, 1), width: 2),
          borderRadius: BorderRadius.circular(12),
        ),
        suffixIcon: isPassword
            ? IconButton(
                icon: Icon(_passwordVisible ? Icons.visibility : Icons.visibility_off, color: Colors.black54),
                onPressed: () => setState(() => _passwordVisible = !_passwordVisible),
              )
            : null,
      ),
      validator: (value) {
        if (value == null || value.isEmpty) return "This field cannot be empty";

        if (emailValidation && !RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
          return "Enter a valid email";
        }

        if (passwordValidation && value.length < 8) {
          return "Password must be at least 8 characters";
        }

        return null;
      },
    );
  }
}
