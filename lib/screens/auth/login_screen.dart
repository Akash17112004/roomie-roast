// ================================
// LOGIN SCREEN PREMIUM UI
// lib/screens/auth/login_screen.dart
// ================================

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() =>
      _LoginScreenState();
}

class _LoginScreenState
    extends State<LoginScreen> {
  final email =
      TextEditingController();

  final password =
      TextEditingController();

  bool hidePassword = true;

  @override
  Widget build(BuildContext context) {
    final auth =
        Provider.of<AuthProvider>(
      context,
    );

    return Scaffold(
      body: Container(
        decoration:
            const BoxDecoration(
          gradient:
              LinearGradient(
            colors: [
              Color(0xff7b61ff),
              Color(0xff9d50ff),
              Color(0xff6a11cb),
            ],
            begin:
                Alignment.topLeft,
            end: Alignment
                .bottomRight,
          ),
        ),
        child: Center(
          child:
              SingleChildScrollView(
            padding:
                const EdgeInsets.all(
                    20),
            child: Container(
              padding:
                  const EdgeInsets.all(
                      22),
              decoration:
                  BoxDecoration(
                color: Colors.white
                    .withOpacity(
                        0.12),
                borderRadius:
                    BorderRadius
                        .circular(
                            28),
                border: Border.all(
                  color: Colors
                      .white24,
                ),
              ),
              child: Column(
                children: [
                  const Icon(
                    Icons.home_work,
                    size: 72,
                    color:
                        Colors.white,
                  ),

                  const SizedBox(
                      height: 12),

                  const Text(
                    "Roomie Roast",
                    style:
                        TextStyle(
                      color: Colors
                          .white,
                      fontSize: 28,
                      fontWeight:
                          FontWeight
                              .bold,
                    ),
                  ),

                  const SizedBox(
                      height: 8),

                  const Text(
                    "Welcome back to the chaos 🏠",
                    style:
                        TextStyle(
                      color: Colors
                          .white70,
                    ),
                  ),

                  const SizedBox(
                      height: 28),

                  TextField(
                    controller:
                        email,
                    style:
                        const TextStyle(
                      color: Colors
                          .white,
                    ),
                    decoration:
                        input(
                      "Email",
                      Icons.email,
                    ),
                  ),

                  const SizedBox(
                      height: 16),

                  TextField(
                    controller:
                        password,
                    obscureText:
                        hidePassword,
                    style:
                        const TextStyle(
                      color: Colors
                          .white,
                    ),
                    decoration:
                        input(
                      "Password",
                      Icons.lock,
                    ).copyWith(
                      suffixIcon:
                          IconButton(
                        icon: Icon(
                          hidePassword
                              ? Icons
                                  .visibility_off
                              : Icons
                                  .visibility,
                          color: Colors
                              .white70,
                        ),
                        onPressed:
                            () {
                          setState(
                              () {
                            hidePassword =
                                !hidePassword;
                          });
                        },
                      ),
                    ),
                  ),

                  const SizedBox(
                      height: 22),

                  SizedBox(
                    width: double
                        .infinity,
                    height: 54,
                    child:
                        ElevatedButton(
                      style:
                          ElevatedButton.styleFrom(
                        backgroundColor:
                            Colors.white,
                        foregroundColor:
                            const Color(
                                0xff7b61ff),
                        shape:
                            RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(
                                  16),
                        ),
                      ),
                      onPressed:
                          () async {
                        final msg =
                            await auth
                                .login(
                          email: email
                              .text
                              .trim(),
                          password:
                              password
                                  .text
                                  .trim(),
                        );

                        if (!mounted)
                          return;

                        if (msg ==
                            null) {
                          Navigator.pushReplacementNamed(
                              context,
                              '/room-setup');
                        } else {
                          ScaffoldMessenger.of(
                                  context)
                              .showSnackBar(
                            SnackBar(
                              content:
                                  Text(
                                      msg),
                            ),
                          );
                        }
                      },
                      child: auth
                              .isLoading
                          ? const CircularProgressIndicator()
                          : const Text(
                              "Login",
                              style:
                                  TextStyle(
                                fontWeight:
                                    FontWeight.bold,
                              ),
                            ),
                    ),
                  ),

                  const SizedBox(
                      height: 12),

                  TextButton(
                    onPressed: () {
                      Navigator.pushNamed(
                          context,
                          '/signup');
                    },
                    child:
                        const Text(
                      "Create Account",
                      style:
                          TextStyle(
                        color: Colors
                            .white,
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  InputDecoration input(
    String hint,
    IconData icon,
  ) {
    return InputDecoration(
      hintText: hint,
      hintStyle:
          const TextStyle(
        color: Colors.white70,
      ),
      prefixIcon:
          Icon(icon,
              color:
                  Colors.white),
      filled: true,
      fillColor:
          Colors.white12,
      border:
          OutlineInputBorder(
        borderRadius:
            BorderRadius
                .circular(16),
        borderSide:
            BorderSide.none,
      ),
    );
  }
}