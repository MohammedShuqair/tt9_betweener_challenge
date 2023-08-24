import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:tt9_betweener_challenge/assets.dart';
import 'package:tt9_betweener_challenge/controllers/api_helper.dart';
import 'package:tt9_betweener_challenge/core/util/api_response.dart';
import 'package:tt9_betweener_challenge/features/auth/model/user.dart';
import 'package:tt9_betweener_challenge/features/auth/provider/auth_provider.dart';
import 'package:tt9_betweener_challenge/views/main_app_view.dart';
import 'package:tt9_betweener_challenge/views/register_view.dart';
import 'package:tt9_betweener_challenge/views/widgets/alert.dart';
import 'package:tt9_betweener_challenge/views/widgets/custom_text_form_field.dart';
import 'package:tt9_betweener_challenge/views/widgets/primary_outlined_button_widget.dart';
import 'package:tt9_betweener_challenge/views/widgets/secondary_button_widget.dart';

import '../controllers/shared_helper.dart';
import '../core/util/shared_mrthodes.dart';
import 'widgets/google_button_widget.dart';

class LoginView extends StatefulWidget {
  static String id = '/loginView';

  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  late TextEditingController emailController;
  late TextEditingController passwordController;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    emailController = TextEditingController();
    passwordController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32.0),
          child: SizedBox(
            height: MediaQuery.of(context).size.height,
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  const Spacer(),
                  SizedBox(
                      height: MediaQuery.of(context).size.height / 5,
                      child: Hero(
                          tag: 'authImage',
                          child: SvgPicture.asset(AssetsData.authImage))),
                  const Spacer(),
                  CustomTextFormField(
                    controller: emailController,
                    hint: 'example@gmail.com',
                    keyboardType: TextInputType.emailAddress,
                    autofillHints: const [AutofillHints.email],
                    label: 'Email',
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'please enter the email';
                      } else if (!EmailValidator.validate(value)) {
                        return 'please enter a valid email';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(
                    height: 14,
                  ),
                  CustomTextFormField(
                    controller: passwordController,
                    hint: 'Enter password',
                    label: 'password',
                    autofillHints: const [AutofillHints.password],
                    password: true,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'please enter the password';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(
                    height: 24,
                  ),
                  Consumer<AuthProvider>(
                    builder: (context, provider, child) {
                      return SecondaryButtonWidget(
                          onTap: () async {
                            if (_formKey.currentState!.validate()) {
                              await provider.loginUser(emailController.text,
                                  passwordController.text);
                              if (mounted) {
                                handelResponseStatus(
                                    provider.loginResponse.status, context,
                                    message: provider.loginResponse.message,
                                    onComplete: () async {
                                  User? user = provider.loginResponse.data;
                                  if (user != null) {
                                    SharedHelper shared = SharedHelper();
                                    shared.setToken(user.token!);
                                    await shared.setUser(userToJson(user));
                                    if (mounted) {
                                      Navigator.pushReplacementNamed(
                                          context, MainAppView.id);
                                    }
                                  }
                                });
                              }

                              //     .then((user) async {
                              //   SharedHelper shared = SharedHelper();
                              //   shared.setToken(user.token!);
                              //   await shared.setUser(userToJson(user));
                              //   if (mounted) {
                              //     Navigator.pushReplacementNamed(
                              //         context, MainAppView.id);
                              //   }
                              // }).catchError((e) {
                              //   showAlert(context,
                              //       message:
                              //           'please check internet connection ');
                              // });
                            }
                          },
                          text: 'LOGIN');
                    },
                  ),
                  const SizedBox(
                    height: 24,
                  ),
                  PrimaryOutlinedButtonWidget(
                      onTap: () {
                        Navigator.pushNamed(context, RegisterView.id);
                      },
                      text: 'REGISTER'),
                  const SizedBox(
                    height: 12,
                  ),
                  Text(
                    '-  or  -',
                    style: TextStyle(
                        color: Colors.grey.shade500,
                        fontSize: 18,
                        fontWeight: FontWeight.w300),
                  ),
                  const SizedBox(
                    height: 12,
                  ),
                  GoogleButtonWidget(onTap: () {}),
                  const Spacer(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
