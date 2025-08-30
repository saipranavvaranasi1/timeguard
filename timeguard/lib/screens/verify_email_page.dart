import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dashboard_page.dart';

class VerifyEmailPage extends StatefulWidget {
  const VerifyEmailPage({super.key});

  @override
  State<VerifyEmailPage> createState() => _VerifyEmailPageState();
}

class _VerifyEmailPageState extends State<VerifyEmailPage> {
  final auth = FirebaseAuth.instance;
  bool isSending = false;
  bool isVerified = false;

  void checkEmailVerified() async {
    await auth.currentUser!.reload();
    setState(() {
      isVerified = auth.currentUser!.emailVerified;
    });
    if (isVerified) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const DashboardPage()),
      );
    }
  }

  void resendVerification() async {
    setState(() => isSending = true);
    await auth.currentUser!.sendEmailVerification();
    setState(() => isSending = false);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Verification email sent')),
    );
  }

  @override
  void initState() {
    super.initState();
    checkEmailVerified();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                  colors: [Color(0xFF0D0D0D), Color(0xFF050505)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight),
            ),
          ),
          Center(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(30),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
                child: Container(
                  padding: const EdgeInsets.all(24),
                  width: 350,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.05),
                    borderRadius: BorderRadius.circular(30),
                    border: Border.all(
                      color: const Color(0xFF00FFF7).withOpacity(0.5),
                      width: 2,
                    ),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text(
                        'Verify Your Email',
                        style: TextStyle(
                          color: Color(0xFF00FFF7),
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          shadows: [
                            Shadow(color: Color(0xFF00FFF7), blurRadius: 15)
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: resendVerification,
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 50, vertical: 15),
                          backgroundColor: Colors.transparent,
                          shadowColor: Colors.transparent,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                          side:
                              const BorderSide(color: Color(0xFF00FFF7), width: 2),
                        ),
                        child: isSending
                            ? const CircularProgressIndicator(
                                color: Color(0xFF00FFF7))
                            : const Text(
                                'Resend Verification Email',
                                style: TextStyle(
                                  color: Color(0xFF00FFF7),
                                  fontWeight: FontWeight.bold,
                                  shadows: [
                                    Shadow(
                                        color: Color(0xFF00FFF7), blurRadius: 15)
                                  ],
                                ),
                              ),
                      ),
                      const SizedBox(height: 20),
                      _neonButton('I have verified', checkEmailVerified),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _neonButton(String text, VoidCallback onPressed) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
        backgroundColor: Colors.transparent,
        shadowColor: Colors.transparent,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
        side: const BorderSide(color: Color(0xFFFF00FF), width: 2),
      ),
      child: Text(
        text,
        style: const TextStyle(
          color: Color(0xFFFF00FF),
          fontWeight: FontWeight.bold,
          shadows: [Shadow(color: Color(0xFFFF00FF), blurRadius: 15)],
        ),
      ),
    );
  }
}
