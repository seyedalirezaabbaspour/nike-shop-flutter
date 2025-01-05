import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nike/data/repo/auth_repository.dart';
import 'package:nike/data/repo/cart_repository.dart';
import 'package:nike/ui/auth/bloc/auth_bloc.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {

  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);
    const Color onBackground = Colors.white;
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Theme(
        data: themeData.copyWith(
          snackBarTheme: SnackBarThemeData(
            backgroundColor: themeData.colorScheme.primary,
            contentTextStyle: TextStyle(fontFamily: "iranYekan")
          ),
            elevatedButtonTheme: ElevatedButtonThemeData(
                style: ButtonStyle(
                    backgroundColor: WidgetStateProperty.all(onBackground),
                    foregroundColor:
                        WidgetStateProperty.all(themeData.colorScheme.secondary),
                    minimumSize: WidgetStateProperty.all(Size.fromHeight(56)),
                    shape: WidgetStateProperty.all(RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12))))),
            colorScheme: themeData.colorScheme.copyWith(onSurface: onBackground),
            inputDecorationTheme: InputDecorationTheme(
              labelStyle: TextStyle(color: onBackground),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: onBackground, width: 1),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: onBackground, width: 1),
              ),
            )),
        child: Scaffold(
          backgroundColor: themeData.colorScheme.secondary,
          body: BlocProvider<AuthBloc>(
            create: (context) {
              final bloc = AuthBloc(authRepository, cartRepository);
              bloc.stream.forEach((state) {
                if (state is AuthSuccess){
                  Navigator.of(context).pop();
                }else if (state is AuthError){
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(state.exception.message)));
                }
              },);
              bloc.add(AuthStarted());
      
              return bloc;
            },
            child: Padding(
              padding: const EdgeInsets.only(right: 48, left: 48),
              child: BlocBuilder<AuthBloc, AuthState>(
                buildWhen: (previous, current) {
                  return current is AuthLoading || current is AuthInitial || current is AuthError;
                },
                builder: (context, state) {
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Image.asset(
                        "assets/img/nike_logo.png",
                        color: Colors.white,
                        width: 120,
                      ),
                      const SizedBox(
                        height: 24,
                      ),
                      Text(
                        state.isLoginMode ? 'خوش آمدید' : 'ثبت نام',
                        style: TextStyle(color: onBackground, fontSize: 22),
                      ),
                      const SizedBox(
                        height: 16,
                      ),
                      Text(
                          state.isLoginMode
                              ? 'لطفا وارد حساب کاربری خود شوید'
                              : 'ایمیل و رمز عبور خود را تعیین کنید',
                          style: TextStyle(color: onBackground, fontSize: 16)),
                      const SizedBox(
                        height: 24,
                      ),
                       TextField(
                        controller: usernameController,
                        keyboardType: TextInputType.emailAddress,
                        style: TextStyle(color: onBackground),
                        decoration: InputDecoration(label: Text("آدرس ایمیل")),
                      ),
                      const SizedBox(
                        height: 16,
                      ),
                      _PasswordTextField(onBackground: onBackground, controller: passwordController,),
                      const SizedBox(
                        height: 16,
                      ),
                      ElevatedButton(
                          onPressed: () {
                            BlocProvider.of<AuthBloc>(context).add(AuthButtonIsClicked(usernameController.text, passwordController.text));
                          },
                          child: state is AuthLoading?CircularProgressIndicator(): Text(state.isLoginMode ? 'ورود' : 'ثبت نام')),
                      const SizedBox(
                        height: 24,
                      ),
                      GestureDetector(
                        onTap: () {
                          BlocProvider.of<AuthBloc>(context).add(AuthModeChangeIsClicked());
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              state.isLoginMode
                                  ? 'حساب کاربری ندارید ؟'
                                  : 'حساب کاربری دارید؟',
                              style:
                                  TextStyle(color: onBackground.withOpacity(0.7)),
                            ),
                            const SizedBox(
                              width: 8,
                            ),
                            Text(state.isLoginMode ? 'ثبت نام' : 'ورود',
                                style: TextStyle(
                                    color: themeData.colorScheme.primary,
                                    decoration: TextDecoration.underline))
                          ],
                        ),
                      )
                    ],
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _PasswordTextField extends StatefulWidget {
  const _PasswordTextField({
    super.key,
    required this.onBackground, required this.controller,
  });

  final Color onBackground;
  final TextEditingController controller;

  @override
  State<_PasswordTextField> createState() => _PasswordTextFieldState();
}

class _PasswordTextFieldState extends State<_PasswordTextField> {
  bool obsecureText = true;
  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: widget.controller,
      style: TextStyle(color: Colors.white),
      keyboardType: TextInputType.visiblePassword,
      obscureText: obsecureText,
      decoration: InputDecoration(
        label: Text("رمز عبور"),
        suffixIcon: IconButton(
          onPressed: () {
            setState(() {
              obsecureText = !obsecureText;
            });
          },
          icon: Icon(
            obsecureText
                ? Icons.visibility_outlined
                : Icons.visibility_off_outlined,
            color: widget.onBackground.withOpacity(0.7),
          ),
        ),
      ),
    );
  }
}
