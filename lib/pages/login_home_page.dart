import 'package:flutter/material.dart';
import 'package:flutter_worker/model/user.dart';
import 'package:flutter_worker/services/database_service.dart';
import 'package:flutter_worker/style/colors.dart';

class LoginHomePage extends StatefulWidget {
  const LoginHomePage({super.key});

  @override
  State<LoginHomePage> createState() => _LoginHomePageState();
}

class _LoginHomePageState extends State<LoginHomePage> {
  final DatabaseService _database = DatabaseService.instance;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _loginController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool _hidePass = false;

  final _loginFocus = FocusNode();
  final _passwordFocus = FocusNode();

  @override
  void dispose() {
    _loginController.dispose();
    _passwordController.dispose();
    _loginFocus.dispose();
    _passwordFocus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
        final login = _loginController.text;
        final pass = _passwordController.text;

        _formKey.currentState?.reset();

        _loginController.text = login;
        _passwordController.text = pass;
      },
      child: Scaffold(
        backgroundColor: colorGrey,
        body: SafeArea(
          child: SizedBox.expand(
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    'Авторизация',
                    style: TextStyle(
                      color: colorLightGrey,
                      fontSize: 38,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: 16.0,
                      horizontal: 32,
                    ),
                    child: myTextFormField(
                      controller: _loginController,
                      label: 'Логин',
                      curFocus: _loginFocus,
                      nexFocus: _passwordFocus,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 32),
                    child: myTextFormField(
                      controller: _passwordController,
                      label: 'Пароль',
                      curFocus: _passwordFocus,
                      isPasswordField: true,
                      isObscure: !_hidePass,
                      onVisibilityToggle: () {
                        setState(() {
                          _hidePass = !_hidePass;
                        });
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 32.0),
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        style: TextButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                            vertical: 4,
                            horizontal: 4,
                          ),
                          minimumSize: Size.zero,
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          foregroundColor: colorWhite,
                          splashFactory: InkRipple.splashFactory,
                        ),
                        onPressed: () {
                          Navigator.pushNamed(context, '/register');
                        },
                        child: const Text('Регистрация'),
                      ),
                    ),
                  ),
                  const SizedBox(height: 38),
                  TextButton(
                    style: TextButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                        vertical: 8,
                        horizontal: 32,
                      ),
                      backgroundColor: colorWhite,
                      foregroundColor: colorBlack,
                      textStyle: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        final String inputLogin = _loginController.text.trim();
                        final String inputPassword = _passwordController.text;

                        final User? user = await _database.getUserByLogin(
                          inputLogin,
                        );

                        if (user == null) {
                          if (context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                backgroundColor: colorBlack,
                                content: Center(
                                  child: Text(
                                    'Пользователя с таким логином не существует',
                                    style: TextStyle(
                                      color: colorWhite,
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                            );
                          }
                          return;
                        }

                        if (user.password != inputPassword) {
                          if (context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                backgroundColor: colorBlack,
                                content: Center(
                                  child: Text(
                                    'Неверный пароль, попробуйте ещё раз',
                                    style: TextStyle(
                                      color: colorWhite,
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                            );
                            return;
                          }
                        }

                        if (context.mounted) {
                          Navigator.pushReplacementNamed(
                            context,
                            !user.isAdmin ? '/home_page' : '/admin_page',
                            arguments: user,
                          );
                        }
                      }
                    },
                    child: Text('Войти'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void focusCnahge(
    BuildContext context,
    FocusNode currentFocus,
    FocusNode nextFocus,
  ) {
    currentFocus.unfocus();
    FocusScope.of(context).requestFocus(nextFocus);
  }

  TextFormField myTextFormField({
    required FocusNode curFocus,
    FocusNode? nexFocus,
    required TextEditingController controller,
    required String label,
    bool isPasswordField = false,
    bool isObscure = false,
    VoidCallback? onVisibilityToggle,
  }) {
    return TextFormField(
      autofocus: !isPasswordField ? true : false,
      focusNode: curFocus,
      obscureText: isObscure,
      controller: controller,
      style: TextStyle(color: colorWhite),
      cursorColor: colorWhite,
      decoration: InputDecoration(
        suffixIcon: isPasswordField
            ? IconButton(
                onPressed: onVisibilityToggle,
                icon: Icon(
                  isObscure ? Icons.visibility_off : Icons.visibility,
                  color: colorLightGrey,
                ),
              )
            : null,
        label: Text('$label:'),
        labelStyle: TextStyle(color: colorWhite, fontWeight: FontWeight.bold),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: colorLightGrey, width: 1.5),
          borderRadius: BorderRadius.circular(16),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: colorWhite, width: 1),
          borderRadius: BorderRadius.circular(16),
        ),
        errorBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.redAccent.shade700, width: 1.5),
          borderRadius: BorderRadius.circular(16),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.redAccent.shade700, width: 1),
          borderRadius: BorderRadius.circular(16),
        ),
        errorStyle: const TextStyle(color: Colors.redAccent),
      ),
      onFieldSubmitted: (value) {
        if (!isPasswordField) {
          focusCnahge(context, curFocus, nexFocus!);
        }
      },
      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          return 'Это поле обязательно';
        }
        return null;
      },
    );
  }
}
