import 'package:bloomix_mobile_app/core/app_colors.dart';
import 'package:bloomix_mobile_app/services/auth_service.dart';
import 'package:bloomix_mobile_app/views/dashboard_screen.dart';
import 'package:bloomix_mobile_app/widgets/custom_text_field.dart';
import 'package:bloomix_mobile_app/widgets/primary_button.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AuthenticationScreen extends StatefulWidget {
  const AuthenticationScreen({super.key});

  @override
  State<AuthenticationScreen> createState() => _AuthenticationScreenState();
}

class _AuthenticationScreenState extends State<AuthenticationScreen> {
  final _authService = AuthService();

  bool _isLoading = false;
  bool isLogin = true;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  Future<void> _submitAuthForm() async {
    if (_emailController.text.trim().isEmpty ||
        _passwordController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please fill in all fields'),
        ),
      );

      return;
    }

    if (!isLogin && _nameController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter your full name'),
        ),
      );

      return;
    }

    if (_passwordController.text.trim().length < 6) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Password must be at least 6 characters',
          ),
        ),
      );

      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      if (isLogin) {
        await _authService.signIn(
          email: _emailController.text.trim(),
          password: _passwordController.text.trim(),
        );
      } else {
        await _authService.registerUser(
          fullName: _nameController.text.trim(),
          email: _emailController.text.trim(),
          password: _passwordController.text.trim(),
        );
      }

      if (!mounted) return;

      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => DashboardScreen(),
        ),
      );
    } catch (error) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(error.toString()),
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }

    if (!mounted) return;

    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Theme.of(context).colorScheme.primary,
                Theme.of(context).colorScheme.secondary,
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        title: Column(
          children: [
            Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Color(0xFF3ca383),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(
                Icons.local_florist_rounded,
                size: 40,
                color: AppColors.white,
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Text(
              'Bloomix',
              style: GoogleFonts.aboreto(
                color: AppColors.white,
                fontSize: 30,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Text(
              'Your personal plant watering tracker.',
              style: TextStyle(
                fontSize: 13,
                color: AppColors.white,
              ),
            ),
          ],
        ),
        centerTitle: true,
        toolbarHeight: 250,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(
              height: 20,
            ),
            Center(
              child: Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: Color.fromARGB(255, 235, 236, 237),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          isLogin = true;
                        });
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: isLogin
                            ? AppColors.primaryGreen
                            : AppColors.lightGreen,

                        foregroundColor: isLogin
                            ? AppColors.white
                            : AppColors.textGrey,

                        elevation: 0,
                      ),

                      child: Text('Sign In'),
                    ),
                    const SizedBox(
                      width: 5,
                    ),
                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          isLogin = false;
                        });
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: !isLogin
                            ? AppColors.primaryGreen
                            : AppColors.lightGreen,

                        foregroundColor: !isLogin
                            ? AppColors.white
                            : AppColors.textGrey,

                        elevation: 0,
                      ),

                      child: Text('Register'),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(
              height: 30,
            ),
            if (!isLogin)
              Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 25),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Full Name',
                        style: TextStyle(
                          fontSize: 15,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  CustomTextField(
                    hintText: 'Your Name',
                    controller: _nameController,
                  ),
                ],
              ),
            const SizedBox(
              height: 20,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Email',
                  style: TextStyle(
                    fontSize: 15,
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 15,
            ),
            CustomTextField(
              hintText: 'you@example.com',
              controller: _emailController,
            ),
            const SizedBox(
              height: 20,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Password',
                  style: TextStyle(
                    fontSize: 15,
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 15,
            ),
            CustomTextField(
              hintText: 'At least 6 characters',
              controller: _passwordController,
              obscureText: true,
            ),
            const SizedBox(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  isLogin
                      ? "Don't have an account? "
                      : "Already have an account? ",

                  style: const TextStyle(
                    color: AppColors.textGrey,
                    fontSize: 15,
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    isLogin
                        ? setState(() {
                            isLogin = false;
                          })
                        : setState(() {
                            isLogin = true;
                          });
                  },
                  child: Text(
                    isLogin ? 'Register' : 'Sign In',
                    style: const TextStyle(
                      color: AppColors.primaryGreen,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 30,
            ),
            _isLoading
                ? const CircularProgressIndicator()
                : PrimaryButton(
                    text: isLogin ? 'Sign in' : 'Create Account',
                    onPressed: _submitAuthForm,
                  ),
            const SizedBox(
              height: 20,
            ),
          ],
        ),
      ),
    );
  }
}
