// ================================
// SIGNUP SCREEN PREMIUM UI
// lib/screens/auth/signup_screen.dart
// ================================

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';

class SignupScreen
    extends StatefulWidget {
  const SignupScreen(
      {super.key});

  @override
  State<SignupScreen>
      createState() =>
          _SignupScreenState();
}

class _SignupScreenState
    extends State<
        SignupScreen> {
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
              Color(0xff00c896),
              Color(0xff00b4d8),
              Color(0xff0077b6),
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
              ),
              child: Column(
                children: [
                  const Icon(
                    Icons.person_add,
                    size: 72,
                    color:
                        Colors.white,
                  ),

                  const SizedBox(
                      height: 12),

                  const Text(
                    "Create Account",
                    style:
                        TextStyle(
                      fontSize: 28,
                      color: Colors
                          .white,
                      fontWeight:
                          FontWeight
                              .bold,
                    ),
                  ),

                  const SizedBox(
                      height: 24),

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
                                0xff00c896),
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
                                .signUp(
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
                              "Sign Up",
                              style:
                                  TextStyle(
                                fontWeight:
                                    FontWeight.bold,
                              ),
                            ),
                    ),
                  ),

                  const SizedBox(
                      height: 10),

                  TextButton(
                    onPressed: () {
                      Navigator.pop(
                          context);
                    },
                    child:
                        const Text(
                      "Already have account?",
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