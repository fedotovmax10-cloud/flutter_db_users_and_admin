import 'package:flutter/material.dart';
import 'package:flutter_worker/model/user.dart';
import 'package:flutter_worker/services/database_service.dart';
import 'package:flutter_worker/style/colors.dart';

class RegisterHomePage extends StatefulWidget {
  const RegisterHomePage({super.key});

  @override
  State<RegisterHomePage> createState() => _RegisterHomePageState();
}

class _RegisterHomePageState extends State<RegisterHomePage> {
  final DatabaseService _database = DatabaseService.instance;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _loginController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _passwordConfirmController =
      TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();
  final TextEditingController _birthdayController = TextEditingController();

  bool _hidePass = false;
  bool _hidePassConfirm = false;
  DateTime? _selectedDate;

  final _loginFocus = FocusNode();
  final _passwordFocus = FocusNode();
  final _passwordConfrimFocus = FocusNode();
  final _emailFocus = FocusNode();
  final _phoneFocus = FocusNode();
  final _birthdayFocus = FocusNode();

  @override
  void dispose() {
    _loginController.dispose();
    _passwordController.dispose();
    _passwordConfirmController.dispose();
    _emailController.dispose();
    _phoneNumberController.dispose();
    _birthdayController.dispose();

    _loginFocus.dispose();
    _passwordFocus.dispose();
    _passwordConfrimFocus.dispose();
    _emailFocus.dispose();
    _phoneFocus.dispose();
    _birthdayFocus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();

        final login = _loginController.text;
        final pass = _passwordController.text;
        final passConfirm = _passwordConfirmController.text;
        final email = _emailController.text;
        final phone = _phoneNumberController.text;
        final birthday = _birthdayController.text;

        _formKey.currentState?.reset();

        _loginController.text = login;
        _passwordController.text = pass;
        _passwordConfirmController.text = passConfirm;
        _emailController.text = email;
        _phoneNumberController.text = phone;
        _birthdayController.text = birthday;
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
                    'Регистрация',
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
                      validator: _loginValidator,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 32),
                    child: myTextFormField(
                      controller: _passwordController,
                      label: 'Пароль',
                      curFocus: _passwordFocus,
                      nexFocus: _passwordConfrimFocus,
                      isPasswordField: true,
                      isObscure: !_hidePass,
                      onVisibilityToggle: () {
                        setState(() {
                          _hidePass = !_hidePass;
                        });
                      },
                      validator: _passwordValidator,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: 16,
                      horizontal: 32,
                    ),
                    child: myTextFormField(
                      controller: _passwordConfirmController,
                      label: 'Подтвердите пароль',
                      curFocus: _passwordConfrimFocus,
                      nexFocus: _emailFocus,
                      isPasswordField: true,
                      isObscure: !_hidePassConfirm,
                      onVisibilityToggle: () {
                        setState(() {
                          _hidePassConfirm = !_hidePassConfirm;
                        });
                      },
                      validator: _passwordConfirmValidator,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 32),
                    child: myTextFormField(
                      controller: _emailController,
                      label: 'Е-mail',
                      curFocus: _emailFocus,
                      nexFocus: _phoneFocus,
                      validator: _emailValidator,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: 16,
                      horizontal: 32,
                    ),
                    child: myTextFormField(
                      controller: _phoneNumberController,
                      label: 'Номер телефона',
                      curFocus: _phoneFocus,
                      nexFocus: _birthdayFocus,
                      validator: _phoneNumberValidator,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 32),
                    child: myTextFormField(
                      isBirthdayField: true,
                      controller: _birthdayController,
                      label: 'Дата рождения',
                      curFocus: _birthdayFocus,
                      validator: _loginValidator,
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
                          Navigator.pop(context);
                        },
                        child: const Text('Войти'),
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
                      textStyle: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    onPressed: () async {
                      if (!_formKey.currentState!.validate()) {
                        return;
                      }

                      if (_selectedDate == null) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Center(
                              child: Text('Пожалуйста, выберите дату рождения'),
                            ),
                          ),
                        );
                        return;
                      }

                      final String newLogin = _loginController.text.trim();
                      final User? user = await _database.getUserByLogin(
                        newLogin,
                      );

                      if (user != null) {
                        if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              backgroundColor: colorBlack,
                              content: Center(
                                child: Text(
                                  'Пользователь с таким логином уже существует',
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

                      if (context.mounted) {
                        await _database.addUser(
                          User(
                            login: newLogin,
                            password: _passwordController.text,
                            email: _emailController.text.trim(),
                            birthday: _selectedDate!,
                            phoneNumber: _phoneNumberController.text.trim(),
                          ),
                        );
                        Navigator.pop(context);
                      }
                    },
                    child: Text('Зарегистрироваться'),
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
    bool isBirthdayField = false,
    bool isObscure = false,
    VoidCallback? onVisibilityToggle,
    required Function(String? value) validator,
  }) {
    return TextFormField(
      autofocus: !isPasswordField ? true : false,
      focusNode: curFocus,
      obscureText: isObscure,
      controller: controller,
      readOnly: isBirthdayField,
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
            : isBirthdayField
            ? IconButton(
                onPressed: () => _pickDate(context),
                icon: Icon(Icons.calendar_today, color: colorLightGrey),
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
      onTap: isBirthdayField ? () => _pickDate(context) : null,
      onFieldSubmitted: (value) {
        if (nexFocus != null) {
          focusCnahge(context, curFocus, nexFocus);
        }
      },
      validator: (value) => validator(value),
    );
  }

  Future<void> _pickDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now().subtract(const Duration(days: 6570)),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );

    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
        _birthdayController.text = "${picked.toLocal()}".split(' ')[0];
      });
    }
  }

  String? _loginValidator(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Это поле обязательно';
    }
    return null;
  }

  String? _passwordValidator(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Это поле обязательно';
    } else if (value != _passwordConfirmController.text) {
      return 'Пароли не совпадают';
    }
    return null;
  }

  String? _passwordConfirmValidator(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Это поле обязательно';
    } else if (value != _passwordController.text) {
      return 'Пароли не совпадают';
    }
    return null;
  }

  String? _emailValidator(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Это поле обязательно';
    }

    final regEmailExp = RegExp(
      r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+",
    );

    if (!regEmailExp.hasMatch(value)) {
      return 'Неправильная эл. почта';
    }

    return null;
  }

  String? _phoneNumberValidator(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Это поле обязательно';
    }

    final regPhoneExp = RegExp(r'^\+?[0-9]{11}$');

    if (!regPhoneExp.hasMatch(value)) {
      return 'Неверный формат';
    }

    return null;
  }
}
