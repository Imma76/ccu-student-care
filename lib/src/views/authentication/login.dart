import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:student_care/src/controller/auth_controller.dart';
import 'package:student_care/src/provider/all_provider.dart';
import 'package:student_care/src/utils/loader.dart';
import 'package:student_care/src/views/authentication/register.dart';

import '../../theme/app_theme.dart';

class Login extends ConsumerWidget {
  const Login({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    AuthController authController = ref.watch(authProvider);
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Image.asset(
                    'assets/logo.png',
                    height: 100,
                    width: 100,
                  ),
                  const Gap(20),
                  Text(
                    'Sign in',
                    style: GoogleFonts.poppins(
                        fontSize: 20, fontWeight: FontWeight.w500),
                  )
                ],
              ),
            ),
            const Text('Email'),
            const Gap(5),
            SizedBox(
              height: 60,
              child: TextFormField(
                cursorColor: AppTheme.primary,
                controller: authController.emailController,
                decoration: const InputDecoration(
                    enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: AppTheme.white2)),
                    focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: AppTheme.white2))),
              ),
            ),
            const Gap(10),
            const Text('Password'),
            const Gap(5),
            SizedBox(
              height: 60,
              child: TextFormField(
                cursorColor: AppTheme.primary,
                controller: authController.passwordController,
                decoration: const InputDecoration(
                    enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: AppTheme.white2)),
                    focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: AppTheme.white2))),
              ),
            ),
            const Gap(20),
            GestureDetector(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const Register()));
                },
                child: Center(
                  child: RichText(
                    text: TextSpan(
                      children: <TextSpan>[
                        TextSpan(
                            text: 'Don\'t have an account?',
                            style: GoogleFonts.dmSans(
                                fontSize: 16,
                                color: AppTheme.black3,
                                fontWeight: FontWeight.w400)),
                        TextSpan(
                            text: ' Sign up',
                            style: GoogleFonts.poppins(
                                fontSize: 16,
                                color: AppTheme.primary,
                                fontWeight: FontWeight.w400)),
                      ],
                    ),
                  ),
                )),
            const Gap(70),
            authController.load
                ? const Indicator2()
                : ElevatedButton(
                    onPressed: () async {
                      await authController.signIn();
                    },
                    style: ElevatedButton.styleFrom(
                        primary: AppTheme.primary,
                        minimumSize: const Size(382, 58),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10))),
                    child: Text(
                      'Sign in',
                      style: GoogleFonts.poppins(
                          color: AppTheme.white,
                          fontSize: 22,
                          fontWeight: FontWeight.w700),
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}
