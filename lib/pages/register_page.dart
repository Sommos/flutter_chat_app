import "package:provider/provider.dart";
import "package:flutter/material.dart";

import "../components/my_button.dart";
import "../components/my_text_field.dart";
import "../services/auth/auth_service.dart";

class RegisterPage extends StatefulWidget {
  final void Function()? onTap;

  const RegisterPage({
    super.key,
    required this.onTap,
  });

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  void register() async {
    if(passwordController.text != confirmPasswordController.text) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Passwords do not match!"),
        ),
      );
      return;
    }

    final authService = Provider.of<AuthService>(context, listen: false);
    
    try {
      await authService.signUpWithEmailAndPassword(
        emailController.text, 
        passwordController.text,
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.toString()),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.message,
                  size: 150.0,
                  color: Colors.grey[800],
                ),

                const SizedBox(height: 50.0),
          
                Text(
                  "Let's create an account for you!",
                  style: TextStyle(
                    fontSize: 16.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey[800],
                  ),
                ),

                const SizedBox(height: 25.0),
          
                MyTextField(
                  controller: emailController, 
                  hintText: "Email", 
                  obscureText: false
                ),

                const SizedBox(height: 10.0),
          
                MyTextField(
                  controller: passwordController, 
                  hintText: "Password", 
                  obscureText: true
                ),

                const SizedBox(height: 10.0),
          
                MyTextField(
                  controller: confirmPasswordController, 
                  hintText: "Confirm Password", 
                  obscureText: true
                ),

                const SizedBox(height: 25.0),

                MyButton(onTap: register, text: "Register"),

                const SizedBox(height: 25.0),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("Already a member?"),
                    const SizedBox(width: 4.0),
                    GestureDetector(
                      onTap: widget.onTap,
                      child: const Text(
                        "Login now!",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}