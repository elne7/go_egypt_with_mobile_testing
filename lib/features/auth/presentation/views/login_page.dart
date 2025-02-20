import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_egypt_with_firebase/dialog_utils.dart';
import 'package:go_egypt_with_firebase/features/auth/domain/entities/login_entity.dart';
import 'package:go_egypt_with_firebase/features/auth/presentation/auth_bloc/auth_bloc.dart';
import 'package:go_egypt_with_firebase/features/auth/presentation/auth_bloc/auth_event.dart';
import 'package:go_egypt_with_firebase/features/auth/presentation/auth_bloc/auth_state.dart';
import 'package:go_egypt_with_firebase/features/auth/presentation/views/sign_up_page.dart';
import 'package:go_egypt_with_firebase/features/auth/presentation/widgets/auth_text_button.dart';
import 'package:go_egypt_with_firebase/features/auth/presentation/widgets/custom_button.dart';
import 'package:go_egypt_with_firebase/features/auth/presentation/widgets/custom_text_field.dart';
import 'package:go_egypt_with_firebase/features/auth/presentation/widgets/title_text.dart';
import 'package:go_egypt_with_firebase/features/layout/layout_view.dart';
import 'package:go_egypt_with_firebase/generated/l10n.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  String email = '';
  String password = '';
  bool isPassHidden = true;
  late final TextEditingController emailController;
  late final TextEditingController passwordController;
  final GlobalKey<FormState> _loginFormKey = GlobalKey<FormState>();


  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    emailController = TextEditingController();
    passwordController = TextEditingController();
    super.initState();

  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthLoading) {
          DialogUtils.showLoading(context: context);
        } else if (state is AuthAuthenticated) {
          DialogUtils.hideLoading(context);
          DialogUtils.showMessage(
              context: context,
              message: 'Login successful',
              title: 'Log in',
              posMessageName: 'Ok',
              posAction: () {
                Navigator.of(context).pushReplacement(
                    MaterialPageRoute(builder: (context) => LayoutView()));
              });
        } else if (state is AuthError) {
          DialogUtils.hideLoading(context);
          DialogUtils.showMessage(
              context: context,
              message: state.message ?? "",
              title: 'Error',
              posMessageName: 'Ok');
        }
      },
      child: Scaffold(
        body: Center(
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Form(
              key: _loginFormKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  //call "TitleText" to add title "Login"
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15.0),
                    child: TitleText(S.of(context).Login, 40),
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.03,
                  ),
                  //call "CustomTextField" to ask the user to enter his email address and validate his input
                  CustomTextField(
                    controller: emailController,
                    label: S.of(context).email_address,
                    prefix: Icons.email,
                    //use "validator" to check if the user input meets requirements
                    validator: (value) {
                      if (!value!.contains("@")) {
                        return S.of(context).please_enter_a_valid_email;
                      } else {
                        return null;
                      }
                    },
                  ),
                  //call "CustomTextField" to ask the user to enter his password
                  CustomTextField(
                    controller: passwordController,
                    label: S.of(context).password,
                    prefix: Icons.lock,
                    validator: (value) {
                      if (value!.length < 6) {
                        return S
                            .of(context)
                            .password_should_contain_at_least_6_characters;
                      } else {
                        return null;
                      }
                    },
                    isPassword: true,
                    obscureText: isPassHidden,
                    //convert the value of "loginIsPassHidden" variable when pressing the suffix icon to show and hide password
                    onSuffixPressed: () {
                      setState(() {
                        isPassHidden = !isPassHidden;
                      });
                    },
                  ),
                  //call "CustomButton" to add a "login" button
                  CustomButton(
                    onPressed: () {
                      //if the user inputs meet all requirements, navigate to another page
                      if (_loginFormKey.currentState!.validate()) {
                        context.read<AuthBloc>().add(
                          LoginRequested(loginEntity:
                             LoginEntity(email: emailController.text, password: passwordController.text)
                          ),
                        );
                      }
                    },
                    text: S.of(context).Login,
                  ),
                  AuthTextButton(
                    text: "Don't have an account? ",
                    buttonText: "Register",
                    onTap: () {
                      Navigator.pushReplacement(context, MaterialPageRoute(
                        builder: (context) {
                          return SignUpPage();
                        },
                      ));
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
