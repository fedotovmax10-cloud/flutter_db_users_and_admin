import 'package:flutter/material.dart';
import 'package:flutter_worker/model/user.dart';
import 'package:flutter_worker/services/database_service.dart';
import 'package:flutter_worker/style/colors.dart';

class AdminPage extends StatefulWidget {
  const AdminPage({super.key});

  @override
  State<AdminPage> createState() => _AdminPageState();
}

class _AdminPageState extends State<AdminPage> {
  final DatabaseService _database = DatabaseService.instance;
  DateTime? selectedDate;

  @override
  Widget build(BuildContext context) {
    final User _thisUser = ModalRoute.of(context)!.settings.arguments as User;
    return Scaffold(
      backgroundColor: colorBlack,
      appBar: AppBar(backgroundColor: colorBlack, elevation: 0),
      body: SafeArea(
        child: FutureBuilder<List<User>>(
          future: _database.getUsers(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(color: colorBlack),
              );
            }

            if (snapshot.hasError || !snapshot.hasData) {
              return Center(
                child: Column(
                  spacing: 4,
                  children: [
                    Icon(Icons.error, color: colorBlack),
                    Text(
                      'Произошла ошибка!',
                      style: TextStyle(fontSize: 28, color: colorBlack),
                    ),
                  ],
                ),
              );
            }

            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                final user = snapshot.data![index];
                final String formattedDate =
                    "${user.birthday.day.toString().padLeft(2, '0')}.${user.birthday.month.toString().padLeft(2, '0')}.${user.birthday.year}";
                return GestureDetector(
                  onLongPress: () {
                    _thisUser.login != user.login
                        ? showDialog(
                            barrierColor: colorLightGrey.withValues(alpha: 0.4),
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                backgroundColor: colorBlack,
                                icon: Icon(
                                  Icons.warning_amber_rounded,
                                  color: colorWhite,
                                  size: 40,
                                ),
                                title: const Text('Удаление записи'),
                                titleTextStyle: TextStyle(
                                  color: colorWhite,
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                ),
                                content: Text(
                                  'Вы действительно хотите удалить пользователя ${user.login} из базы данных?',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: colorWhite,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                actionsAlignment: MainAxisAlignment.spaceEvenly,
                                actionsPadding: const EdgeInsets.only(
                                  bottom: 16,
                                  left: 8,
                                  right: 8,
                                ),
                                actions: [
                                  TextButton(
                                    style: TextButton.styleFrom(
                                      fixedSize: const Size(110, 40),
                                      backgroundColor: colorGrey,
                                      foregroundColor: colorBlack,
                                      textStyle: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 15,
                                      ),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                    ),
                                    onPressed: () => Navigator.pop(context),
                                    child: const Text('Отмена'),
                                  ),
                                  TextButton(
                                    style: TextButton.styleFrom(
                                      fixedSize: const Size(110, 40),
                                      backgroundColor: Colors.red[700],
                                      foregroundColor: colorWhite,
                                      textStyle: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 15,
                                      ),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                    ),
                                    onPressed: () async {
                                      await _database.userDelete(user.id!);

                                      if (context.mounted) {
                                        Navigator.pop(context);
                                        setState(() {});
                                      }
                                    },
                                    child: const Text('Удалить'),
                                  ),
                                ],
                              );
                            },
                          )
                        : null;
                  },
                  onTap: () {
                    _thisUser.login != user.login
                        ? showDialog(
                            barrierColor: colorLightGrey.withValues(alpha: 0.4),
                            context: context,
                            builder: (dialogContext) {
                              return AlertDialog(
                                contentPadding: const EdgeInsets.all(32),
                                backgroundColor: colorBlack,
                                content: Column(
                                  spacing: 16,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Container(
                                      width: double.infinity,
                                      padding: const EdgeInsets.symmetric(
                                        vertical: 4,
                                      ),
                                      decoration: BoxDecoration(
                                        color: colorGrey.withValues(alpha: 0.6),
                                        borderRadius: BorderRadius.circular(16),
                                      ),
                                      child: Text(
                                        textAlign: TextAlign.center,
                                        user.login,
                                        style: TextStyle(
                                          color: colorLightGrey,
                                          fontWeight: FontWeight.w700,
                                          fontSize: 24,
                                        ),
                                      ),
                                    ),
                                    Container(
                                      padding: const EdgeInsets.all(12),
                                      decoration: BoxDecoration(
                                        color: colorGrey.withValues(alpha: 0.6),
                                        borderRadius: BorderRadius.circular(16),
                                      ),
                                      child: Column(
                                        children: [
                                          _infoRow('id', user.id.toString()),
                                          _infoRow('Логин', user.login),
                                          _infoRow('E-mail', user.email),
                                          _infoRow(
                                            'Номер телефона',
                                            user.phoneNumber,
                                          ),
                                          _infoRow(
                                            'Дата рождения',
                                            formattedDate,
                                          ),
                                          _infoRow('Пароль', user.password),
                                          _infoRow(
                                            'Права администратора',
                                            user.isAdmin ? 'да' : 'нет',
                                          ),
                                          _infoRow(
                                            'Описание',
                                            user.description ?? '...',
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                          )
                        : Navigator.pushNamed(
                            context,
                            '/home_page',
                            arguments: _thisUser
                          );
                  },
                  child: Card(
                    elevation: 2.5,
                    shadowColor: colorWhite,
                    margin: const EdgeInsets.all(8),
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: colorLightGrey,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            spacing: 8,
                            children: [
                              CircleAvatar(
                                backgroundColor: colorBlack,
                                foregroundColor: colorLightGrey,
                                child: const Icon(Icons.person),
                              ),
                              Text(
                                user.login,
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),

                          IconButton(
                            color: colorGrey,
                            onPressed: () {
                              showDialog(
                                barrierColor: colorLightGrey.withValues(
                                  alpha: 0.4,
                                ),
                                context: context,
                                builder: (dialogContext) {
                                  selectedDate = user.birthday;
                                  final GlobalKey<FormState> editFormKey =
                                      GlobalKey<FormState>();
                                  final TextEditingController
                                  editLoginController = TextEditingController(
                                    text: user.login,
                                  );
                                  final TextEditingController
                                  editEmailController = TextEditingController(
                                    text: user.email,
                                  );
                                  final TextEditingController
                                  editPhoneNumberController =
                                      TextEditingController(
                                        text: user.phoneNumber,
                                      );
                                  final TextEditingController
                                  editBirthdayController =
                                      TextEditingController(
                                        text: formattedDate,
                                      );
                                  final TextEditingController
                                  editPasswordController =
                                      TextEditingController(
                                        text: user.password,
                                      );
                                  return StatefulBuilder(
                                    builder: (BuildContext context, setDialogState) {
                                      return AlertDialog(
                                        title: Text(
                                          user.login,
                                          style: TextStyle(
                                            color: colorLightGrey,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                        contentPadding: const EdgeInsets.all(
                                          26,
                                        ),
                                        backgroundColor: colorBlack,
                                        content: Form(
                                          key: editFormKey,
                                          child: Column(
                                            spacing: 16,
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              myTextFormField(
                                                label: 'Логин',
                                                controller: editLoginController,
                                                icon: Icons.person,
                                              ),
                                              myTextFormField(
                                                label: 'E-mail',
                                                controller: editEmailController,
                                                icon: Icons.mail,
                                              ),
                                              myTextFormField(
                                                label: 'Номер телефона',
                                                controller:
                                                    editPhoneNumberController,
                                                icon: Icons.phone,
                                              ),
                                              TextFormField(
                                                readOnly: true,
                                                style: TextStyle(
                                                  color: colorWhite,
                                                ),
                                                controller:
                                                    editBirthdayController,
                                                cursorColor: colorWhite,
                                                decoration: InputDecoration(
                                                  labelText: 'Дата рождения',
                                                  labelStyle: TextStyle(
                                                    color: colorLightGrey,
                                                  ),
                                                  enabledBorder:
                                                      OutlineInputBorder(
                                                        borderSide: BorderSide(
                                                          color: colorLightGrey,
                                                        ),
                                                        borderRadius:
                                                            BorderRadius.circular(
                                                              16,
                                                            ),
                                                      ),
                                                  focusedBorder:
                                                      OutlineInputBorder(
                                                        borderSide: BorderSide(
                                                          color: colorLightGrey
                                                              .withValues(
                                                                alpha: 0.9,
                                                              ),
                                                        ),
                                                        borderRadius:
                                                            BorderRadius.circular(
                                                              16,
                                                            ),
                                                      ),
                                                  icon: Container(
                                                    padding:
                                                        const EdgeInsets.symmetric(
                                                          vertical: 6,
                                                          horizontal: 6,
                                                        ),
                                                    decoration: BoxDecoration(
                                                      color: colorGrey,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                            20,
                                                          ),
                                                    ),
                                                    child: Icon(
                                                      Icons.date_range_outlined,
                                                      color: colorBlack,
                                                    ),
                                                  ),
                                                ),
                                                validator: (value) {
                                                  if (value == null ||
                                                      value.trim().isEmpty) {
                                                    return 'Ошибка валидации';
                                                  }
                                                  return null;
                                                },
                                                onTap: () => selectDate(
                                                  context,
                                                  editBirthdayController,
                                                  setDialogState,
                                                ),
                                              ),
                                              myTextFormField(
                                                label: 'Пароль',
                                                controller:
                                                    editPasswordController,
                                                icon: Icons.password,
                                              ),
                                              TextButton(
                                                style: TextButton.styleFrom(
                                                  backgroundColor:
                                                      colorLightGrey,
                                                  foregroundColor: colorBlack,
                                                ),
                                                onPressed: () async {
                                                  if (editFormKey.currentState!
                                                      .validate()) {
                                                    await _database.userUpdate(
                                                      User(
                                                        id: user.id,
                                                        login:
                                                            editLoginController
                                                                .text,
                                                        password:
                                                            editPasswordController
                                                                .text,
                                                        email:
                                                            editEmailController
                                                                .text,
                                                        birthday: selectedDate ?? user.birthday,
                                                        phoneNumber:
                                                            editPhoneNumberController
                                                                .text,
                                                        description:
                                                            user.description,
                                                        isAdmin: user.isAdmin,
                                                      ),
                                                    );
                                                  }

                                                  if (context.mounted) {
                                                    Navigator.pop(context);
                                                    setState(() {});
                                                  }
                                                },
                                                child: Text(
                                                  'Сохранить изменения',
                                                  style: TextStyle(
                                                    fontSize: 16,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      );
                                    },
                                  );
                                },
                              ).then((_) {
                                selectedDate = null;
                              });
                            },
                            icon: const Icon(Icons.edit),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }

  Widget _infoRow(String label, String value) {
    return Row(
      spacing: 4,
      children: [
        Text(
          '$label:',
          style: TextStyle(
            color: colorWhite.withValues(alpha: 0.8),
            fontSize: 16,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            color: colorWhite,
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  TextFormField myTextFormField({
    required String label,
    required TextEditingController controller,
    required IconData? icon,
  }) {
    return TextFormField(
      style: TextStyle(color: colorWhite),
      controller: controller,
      cursorColor: colorWhite,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(color: colorLightGrey),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: colorLightGrey),
          borderRadius: BorderRadius.circular(16),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: colorLightGrey.withValues(alpha: 0.9)),
          borderRadius: BorderRadius.circular(16),
        ),
        icon: Container(
          padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 6),
          decoration: BoxDecoration(
            color: colorGrey,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Icon(icon, color: colorBlack),
        ),
      ),
      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          return 'Ошибка валидации';
        }
        return null;
      },
    );
  }

  Future<void> selectDate(
    BuildContext context,
    TextEditingController birthdayController,
    StateSetter setDialogState,
  ) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime(2000),
      firstDate: DateTime(1900),
      lastDate: DateTime(2026),
    );
    if (picked != null && picked != selectedDate) {
      setDialogState(() {
        selectedDate = picked;
        birthdayController.text =
            "${picked.day.toString().padLeft(2, '0')}.${picked.month.toString().padLeft(2, '0')}.${picked.year}";
      });
    }
  }
}
