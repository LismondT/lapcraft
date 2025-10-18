import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax/iconsax.dart';
import 'package:lapcraft/core/app_route.dart';
import 'package:lapcraft/features/profile/presentation/cubits/auth_cubit.dart';

import '../../domain/entities/user.dart';
import '../cubits/auth_state.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _staggerAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 1000),
    );

    _staggerAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Interval(0.0, 0.6, curve: Curves.easeOut),
      ),
    );

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return BlocListener<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state is AuthUnauthenticated) {
          context.go(Routes.login.path);
        }
      },
      child: BlocBuilder<AuthCubit, AuthState>(
        builder: (context, state) {
          return Scaffold(
            body: switch (state) {
              AuthInitial() => _buildLoading(colorScheme),
              AuthLoading() => _buildLoading(colorScheme),
              AuthAuthenticated(user: final user) => _buildProfile(context, user, colorScheme),
              AuthUnauthenticated() => _buildUnauthenticated(context, colorScheme),
              AuthError(message: final message) => _buildError(context, message, colorScheme),
            }
          );
        },
      ),
    );
  }

  Widget _buildLoading(ColorScheme colorScheme) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(color: colorScheme.primary),
          SizedBox(height: 16),
          Text('Загрузка...', style: TextStyle(color: colorScheme.onSurface)),
        ],
      ),
    );
  }

  Widget _buildError(BuildContext context, String message, ColorScheme colorScheme) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.error, color: colorScheme.error, size: 64),
          SizedBox(height: 16),
          Text('Ошибка', style: TextStyle(fontSize: 20, color: colorScheme.error)),
          SizedBox(height: 8),
          Text(message, textAlign: TextAlign.center),
          SizedBox(height: 24),
          ElevatedButton(
            onPressed: () => context.read<AuthCubit>().checkAuth(),
            child: Text('Попробовать снова'),
          ),
        ],
      ),
    );
  }

  Widget _buildUnauthenticated(BuildContext context, ColorScheme colorScheme) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.pets, color: colorScheme.primary, size: 80),
          SizedBox(height: 24),
          Text(
            'Войдите в аккаунт',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 12),
          Text(
            'Чтобы получить доступ к профилю',
            style: TextStyle(color: colorScheme.onSurface.withOpacity(0.7)),
          ),
          SizedBox(height: 32),
          ElevatedButton(
            onPressed: () => context.push(Routes.login.path),
            style: ElevatedButton.styleFrom(
              backgroundColor: colorScheme.primary,
              foregroundColor: colorScheme.onPrimary,
              padding: EdgeInsets.symmetric(horizontal: 32, vertical: 16),
            ),
            child: Text('Войти'),
          ),
        ],
      ),
    );
  }

  Widget _buildProfile(BuildContext context, User user, ColorScheme colorScheme) {
    return CustomScrollView(
      slivers: [
        SliverAppBar(
          expandedHeight: 200,
          flexibleSpace: FlexibleSpaceBar(
            background: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    colorScheme.primary,
                    colorScheme.secondary,
                  ],
                ),
              ),
              child: AnimatedBuilder(
                animation: _staggerAnimation,
                builder: (context, child) {
                  return Opacity(
                    opacity: _staggerAnimation.value,
                    child: child,
                  );
                },
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircleAvatar(
                      radius: 40,
                      backgroundColor: colorScheme.onPrimary.withOpacity(0.2),
                      child: Icon(
                        Icons.person,
                        size: 40,
                        color: colorScheme.onPrimary,
                      ),
                    ),
                    SizedBox(height: 16),
                    Text(
                      user.name,
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: colorScheme.onPrimary,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      user.email,
                      style: TextStyle(
                        fontSize: 16,
                        color: colorScheme.onPrimary.withOpacity(0.8),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        SliverList(
          delegate: SliverChildListDelegate([
            _buildProfileSection(context, user, colorScheme),
          ]),
        ),
      ],
    );
  }

  Widget _buildProfileSection(BuildContext context, User user, ColorScheme colorScheme) {
    return Padding(
      padding: EdgeInsets.all(16),
      child: Column(
        children: [
          // Информация о пользователе
          _buildInfoCard(context, user, colorScheme),
          SizedBox(height: 16),

          // Адреса
          _buildAddressesCard(user, colorScheme),
          SizedBox(height: 16),

          // Действия
          _buildActionsCard(context, colorScheme),
        ],
      ),
    );
  }

  Widget _buildInfoCard(BuildContext context, User user, ColorScheme colorScheme) {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Информация',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: colorScheme.primary,
              ),
            ),
            SizedBox(height: 16),
            _buildInfoRow(Icons.email, 'Email', user.email, colorScheme),
            if (user.phone != null)
              _buildInfoRow(Icons.phone, 'Телефон', user.phone!, colorScheme),
            _buildInfoRow(Icons.person, 'Имя', user.name, colorScheme),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String title, String value, ColorScheme colorScheme) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Icon(icon, color: colorScheme.primary, size: 20),
          SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: TextStyle(fontSize: 12, color: Colors.grey)),
                SizedBox(height: 2),
                Text(value, style: TextStyle(fontSize: 16)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAddressesCard(User user, ColorScheme colorScheme) {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  'Адреса доставки',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: colorScheme.primary,
                  ),
                ),
                Spacer(),
                IconButton(
                  onPressed: () {/* Добавить адрес */},
                  icon: Icon(Iconsax.add, color: colorScheme.primary),
                ),
              ],
            ),
            SizedBox(height: 8),
            if (user.addresses.isEmpty)
              Padding(
                padding: EdgeInsets.symmetric(vertical: 16),
                child: Text(
                  'Нет сохраненных адресов',
                  style: TextStyle(color: Colors.grey),
                ),
              )
            else
              ...user.addresses.map((address) => Padding(
                padding: EdgeInsets.symmetric(vertical: 8),
                child: Row(
                  children: [
                    Icon(Iconsax.location, color: colorScheme.secondary, size: 16),
                    SizedBox(width: 8),
                    Expanded(child: Text(address)),
                    IconButton(
                      onPressed: () {/* Редактировать адрес */},
                      icon: Icon(Iconsax.edit, size: 16),
                    ),
                  ],
                ),
              )),
          ],
        ),
      ),
    );
  }

  Widget _buildActionsCard(BuildContext context, ColorScheme colorScheme) {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(16),
        child: _buildActionTile(
          Icons.exit_to_app,
          'Выйти',
          colorScheme.error,
              () => _showLogoutDialog(context),
        ),
      ),
    );
  }

  Widget _buildActionTile(IconData icon, String title, Color color, VoidCallback onTap) {
    return ListTile(
      leading: Icon(icon, color: color),
      title: Text(title, style: TextStyle(color: color)),
      trailing: Icon(Icons.arrow_forward_ios, size: 16, color: color),
      onTap: onTap,
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Выход'),
        content: Text('Вы уверены, что хотите выйти?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Отмена'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              context.read<AuthCubit>().logout();
            },
            child: Text('Выйти', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}