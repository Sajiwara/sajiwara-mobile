import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';
import 'package:sajiwara/screens/menu.dart';
import 'package:sajiwara/screens/register.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage>
    with SingleTickerProviderStateMixin {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  late AnimationController _animationController;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _handleLogin(BuildContext context, CookieRequest request) async {
    setState(() {
      _isLoading = true;
    });

    String username = _usernameController.text;
    String password = _passwordController.text;

    final response = await request.login(
        "https://theresia-tarianingsih-sajiwaraweb.pbp.cs.ui.ac.id/auth/login/",
        // "http://127.0.0.1:8000/auth/login/",
        {
          'username': username,
          'password': password,
        });

    setState(() {
      _isLoading = false;
    });

    if (request.loggedIn) {
      String message = response['message'];
      String uname = response['username'];
      if (context.mounted) {
        Navigator.pushReplacement(
          context,
          PageRouteBuilder(
            pageBuilder: (context, animation, secondaryAnimation) =>
                MyHomePage(),
            transitionsBuilder:
                (context, animation, secondaryAnimation, child) {
              var begin = const Offset(1.0, 0.0);
              var end = Offset.zero;
              var curve = Curves.easeInOutQuart;
              var tween =
                  Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
              return SlideTransition(
                position: animation.drive(tween),
                child: child,
              );
            },
          ),
        );
        ScaffoldMessenger.of(context)
          ..hideCurrentSnackBar()
          ..showSnackBar(
            SnackBar(content: Text("$message Selamat datang, $uname.")),
          );
      }
    } else {
      if (context.mounted) {
        _animationController.forward(from: 0.0);
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Login Gagal'),
            content: Text(response['message']),
            actions: [
              TextButton(
                child: const Text('OK'),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final request = context.watch<CookieRequest>();

    return Scaffold(
      body: Stack(
        children: [
          // Gradient Background
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Colors.deepOrange.shade300,
                  Colors.deepOrange.shade600,
                ],
              ),
            ),
          ),

          Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Card(
                elevation: 12,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.0),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // App Logo or Title
                      Text(
                        'Sajiwara',
                        style: TextStyle(
                          fontSize: 32.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.deepOrange.shade700,
                        ),
                      )
                          .animate()
                          .fadeIn(duration: 500.ms)
                          .slideY(begin: -0.5, end: 0),

                      const SizedBox(height: 30.0),

                      // Username TextField
                      TextField(
                        controller: _usernameController,
                        decoration: InputDecoration(
                          labelText: 'Username',
                          prefixIcon: const Icon(Icons.person,
                              color: Colors.deepOrange),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15.0),
                          ),
                        ),
                      )
                          .animate()
                          .fadeIn(delay: 200.ms)
                          .slideX(begin: -0.1, end: 0),

                      const SizedBox(height: 16.0),

                      // Password TextField
                      TextField(
                        controller: _passwordController,
                        obscureText: true,
                        decoration: InputDecoration(
                          labelText: 'Password',
                          prefixIcon:
                              const Icon(Icons.lock, color: Colors.deepOrange),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15.0),
                          ),
                        ),
                      )
                          .animate()
                          .fadeIn(delay: 400.ms)
                          .slideX(begin: -0.1, end: 0),

                      const SizedBox(height: 24.0),

                      // Login Button with Loading State
                      ElevatedButton(
                        onPressed: _isLoading
                            ? null
                            : () => _handleLogin(context, request),
                        style: ElevatedButton.styleFrom(
                          minimumSize: const Size(double.infinity, 50),
                          backgroundColor: Colors.deepOrange.shade600,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15.0),
                          ),
                        ),
                        child: _isLoading
                            ? const CircularProgressIndicator(
                                color: Colors.white)
                            : const Text('Login',
                                style: TextStyle(color: Colors.white)),
                      )
                          .animate()
                          .fadeIn(delay: 600.ms)
                          .slideY(begin: 0.5, end: 0),

                      const SizedBox(height: 16.0),

                      // Register Link
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const RegisterPage()),
                          );
                        },
                        child: Text(
                          'Don\'t have an account? Register',
                          style: TextStyle(
                            color: Colors.deepOrange.shade700,
                            fontSize: 16.0,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ).animate().fadeIn(delay: 800.ms),
                    ],
                  ),
                ),
              ).animate().scale(duration: 500.ms).fadeIn(),
            ),
          ),
        ],
      ),
    );
  }
}
