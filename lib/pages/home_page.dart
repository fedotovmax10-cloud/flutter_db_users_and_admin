import 'package:flutter/material.dart';
import 'package:flutter_worker/model/user.dart';
import 'package:flutter_worker/services/database_service.dart';
import 'package:flutter_worker/style/colors.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final DatabaseService _database = DatabaseService.instance;

  final TextEditingController _descriptionController = TextEditingController();
  late Future<User?> _userFuture;
  late User _routeUser;
  bool _isInitialized = false;

  @override
  void dispose() {
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_isInitialized) {
      _routeUser = ModalRoute.of(context)!.settings.arguments as User;
      _userFuture = _database.getUserByLogin(_routeUser.login);
      _isInitialized = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool showBackButton = _routeUser.isAdmin;

    return Scaffold(
      backgroundColor: colorLightGrey,
      appBar: AppBar(
        backgroundColor: colorBlack,
        elevation: 0,
        automaticallyImplyLeading: false,
        leading: showBackButton
            ? IconButton(
                tooltip: 'Назад',
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: Icon(Icons.arrow_back_ios, color: colorLightGrey),
              )
            : null,
        actions: [
          !showBackButton
              ? IconButton(
                  onPressed: () {
                    showDialog(
                      barrierColor: colorLightGrey.withValues(alpha: 0.4),
                      context: context,
                      builder: (dialogContext) {
                        return AlertDialog(
                          backgroundColor: colorBlack,
                          content: Column(
                            spacing: 16,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                'Вы уверены, что хотите выйти?',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: colorWhite,
                                  fontSize: 28,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  TextButton(
                                    style: TextButton.styleFrom(
                                      backgroundColor: colorWhite,
                                      foregroundColor: colorBlack,
                                    ),
                                    onPressed: () {
                                      if (context.mounted) {
                                        Navigator.pushReplacementNamed(
                                          context,
                                          '/login',
                                        );
                                      }
                                    },
                                    child: const Text('Да'),
                                  ),
                                  TextButton(
                                    style: TextButton.styleFrom(
                                      backgroundColor: colorWhite,
                                      foregroundColor: colorBlack,
                                    ),
                                    onPressed: () {
                                      if (context.mounted) {
                                        Navigator.pop(context);
                                      }
                                    },
                                    child: const Text('Нет'),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        );
                      },
                    );
                  },
                  tooltip: 'Выйти',
                  icon: Icon(Icons.output, color: colorLightGrey, size: 28),
                )
              : const SizedBox(),
          const SizedBox(width: 8),
        ],
      ),
      body: SafeArea(
        child: FutureBuilder<User?>(
          future: _userFuture,
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

            final User user = snapshot.data!;

            return SingleChildScrollView(
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(color: colorLightGrey),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        CircleAvatar(
                          backgroundColor: colorBlack,
                          radius: 60,
                          child: Text(
                            user.login[0].toUpperCase(),
                            style: TextStyle(
                              color: colorWhite,
                              fontSize: 50,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 16),
                          child: IntrinsicWidth(
                            child: Container(
                              padding: EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: colorBlack,
                                borderRadius: BorderRadius.circular(24),
                              ),
                              child: Column(
                                spacing: 6,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    width: double.infinity,
                                    padding: const EdgeInsets.only(bottom: 6),
                                    decoration: const BoxDecoration(
                                      border: Border(
                                        bottom: BorderSide(
                                          color: Colors.white,
                                          width: 1.5,
                                        ),
                                      ),
                                    ),
                                    child: Text(
                                      user.login,
                                      style: TextStyle(
                                        color: colorWhite,
                                        fontSize: 22,
                                      ),
                                    ),
                                  ),
                                  Row(
                                    spacing: 8,
                                    children: [
                                      _buildStatColumn('0', 'Посты'),
                                      _buildStatColumn('0', 'Подписчики'),
                                      _buildStatColumn('0', 'Подписки'),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: Container(
                      padding: const EdgeInsets.all(18),
                      decoration: BoxDecoration(
                        color: colorBlack,
                        borderRadius: BorderRadius.circular(24),
                        boxShadow: [
                          BoxShadow(
                            color: colorBlack.withValues(alpha: 0.1),
                            blurRadius: 10,
                            offset: const Offset(0, 20),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'О себе',
                                style: TextStyle(
                                  color: colorWhite,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              IconButton(
                                onPressed: () {
                                  _descriptionController.text =
                                      user.description ?? '';
                                  showDialog(
                                    barrierColor: colorLightGrey.withValues(
                                      alpha: 0.4,
                                    ),
                                    context: context,
                                    builder: (dialogContext) {
                                      return AlertDialog(
                                        backgroundColor: colorBlack,
                                        content: Column(
                                          spacing: 16,
                                          mainAxisSize: MainAxisSize.min,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.stretch,
                                          children: [
                                            Text(
                                              'О себе',
                                              style: TextStyle(
                                                color: colorWhite,
                                                fontSize: 20,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            TextFormField(
                                              maxLines: 9,
                                              style: TextStyle(
                                                color: colorWhite,
                                              ),
                                              cursorColor: colorWhite,
                                              controller:
                                                  _descriptionController,
                                              decoration: InputDecoration(
                                                enabledBorder:
                                                    OutlineInputBorder(
                                                      borderSide: BorderSide(
                                                        color: colorLightGrey,
                                                        width: 1.5,
                                                      ),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                            16,
                                                          ),
                                                    ),
                                                focusedBorder:
                                                    OutlineInputBorder(
                                                      borderSide: BorderSide(
                                                        color: colorWhite,
                                                        width: 1,
                                                      ),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                            16,
                                                          ),
                                                    ),
                                              ),
                                            ),
                                            TextButton(
                                              style: TextButton.styleFrom(
                                                backgroundColor: colorLightGrey,
                                                foregroundColor: colorBlack,
                                              ),
                                              onPressed: () async {
                                                final String newText =
                                                    _descriptionController.text;
                                                await _database.userUpdate(
                                                  User(
                                                    id: user.id,
                                                    login: user.login,
                                                    password: user.password,
                                                    email: user.email,
                                                    birthday: user.birthday,
                                                    phoneNumber:
                                                        user.phoneNumber,
                                                    description:
                                                        newText.trim().isEmpty
                                                        ? null
                                                        : newText,
                                                    isAdmin: user.isAdmin,
                                                  ),
                                                );
                                                if (dialogContext.mounted) {
                                                  Navigator.pop(dialogContext);
                                                }

                                                if (context.mounted) {
                                                  setState(() {
                                                    _userFuture = _database
                                                        .getUserByLogin(
                                                          user.login,
                                                        );
                                                  });
                                                }
                                              },
                                              child: const Text('Сохранить'),
                                            ),
                                          ],
                                        ),
                                      );
                                    },
                                  );
                                },
                                icon: Icon(
                                  Icons.edit,
                                  color: colorWhite.withValues(alpha: 0.5),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Text(
                            user.description ?? '...',
                            style: TextStyle(
                              color: colorWhite.withValues(alpha: 0.7),
                              fontSize: 15,
                              height: 1.4,
                            ),
                            softWrap: true,
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            child: Divider(
                              color: colorWhite.withValues(alpha: 0.2),
                              height: 1,
                            ),
                          ),
                          Column(
                            spacing: 12,
                            children: [
                              _buildInfoRow('Номер телефона', user.phoneNumber),
                              _buildInfoRow('E-mail', user.email),
                              _buildInfoRow(
                                'Дата рождения',
                                "${user.birthday.day.toString().padLeft(2, '0')}.${user.birthday.month.toString().padLeft(2, '0')}.${user.birthday.year}",
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            color: colorWhite.withValues(alpha: 0.5),
            fontSize: 15,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            color: colorWhite,
            fontSize: 15,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _buildStatColumn(String count, String label) {
    return Column(
      children: [
        Text(
          count,
          style: TextStyle(color: colorWhite, fontWeight: FontWeight.bold),
        ),
        Text(label, style: TextStyle(color: colorWhite, fontSize: 14)),
      ],
    );
  }
}
