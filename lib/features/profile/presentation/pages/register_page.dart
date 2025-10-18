// register_page.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:lapcraft/features/profile/presentation/cubits/auth_cubit.dart';

import '../../../../core/app_route.dart';
import '../cubits/auth_state.dart';

class RegisterPage extends StatefulWidget {
  final String? returnUrl;

  const RegisterPage({super.key, this.returnUrl});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage>
    with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _phoneController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;

  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 600),
    );

    _scaleAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.elasticOut),
    );

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _register() {
    if (_formKey.currentState!.validate()) {
      context.read<AuthCubit>().register(
          login: _nameController.text.trim(),
          email: _emailController.text.trim(),
          password: _passwordController.text.trim(),
          phone: _phoneController.text.trim());
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return BlocListener<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state is AuthError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: colorScheme.error,
            ),
          );
        } else if (state is AuthAuthenticated) {
          if (widget.returnUrl != null && widget.returnUrl!.isNotEmpty) {
            context.go(widget.returnUrl!);
          } else {
            context.go(Routes.profile.path);
          }
        }
      },
      child: Scaffold(
        body: SafeArea(
          child: SingleChildScrollView(
            child: Container(
              height: MediaQuery.of(context).size.height,
              padding: EdgeInsets.all(24),
              child: Form(
                key: _formKey,
                child: ScaleTransition(
                  scale: _scaleAnimation,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Заголовок
                      _buildHeader(colorScheme),
                      SizedBox(height: 32),

                      // Поля ввода
                      _buildNameField(colorScheme),
                      SizedBox(height: 16),
                      _buildEmailField(colorScheme),
                      SizedBox(height: 16),
                      _buildPhoneField(colorScheme),
                      SizedBox(height: 16),
                      _buildPasswordField(colorScheme),
                      SizedBox(height: 16),
                      _buildConfirmPasswordField(colorScheme),
                      SizedBox(height: 32),

                      // Кнопка регистрации
                      _buildRegisterButton(colorScheme),
                      SizedBox(height: 24),
                      _buildLoginSection(context, colorScheme)
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(ColorScheme colorScheme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Регистрация',
          style: TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.bold,
            color: colorScheme.primary,
          ),
        ),
        SizedBox(height: 8),
        Text(
          'Создайте аккаунт для удобных покупок',
          style: TextStyle(
            fontSize: 16,
            color: colorScheme.onSurface.withOpacity(0.7),
          ),
        ),
      ],
    );
  }

  Widget _buildNameField(ColorScheme colorScheme) {
    return TextFormField(
      controller: _nameController,
      decoration: InputDecoration(
        labelText: 'Имя',
        prefixIcon: Icon(Icons.person, color: colorScheme.primary),
        hintText: 'Введите ваше имя',
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Введите ваше имя';
        }
        return null;
      },
    );
  }

  Widget _buildEmailField(ColorScheme colorScheme) {
    return TextFormField(
      controller: _emailController,
      decoration: InputDecoration(
        labelText: 'Email',
        prefixIcon: Icon(Icons.email, color: colorScheme.primary),
        hintText: 'your@email.com',
      ),
      keyboardType: TextInputType.emailAddress,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Введите email';
        }
        if (!value.contains('@')) {
          return 'Введите корректный email';
        }
        return null;
      },
    );
  }

  Widget _buildPhoneField(ColorScheme colorScheme) {
    return TextFormField(
      controller: _phoneController,
      decoration: InputDecoration(
        labelText: 'Телефон (необязательно)',
        prefixIcon: Icon(Icons.phone, color: colorScheme.primary),
        hintText: '+7 (XXX) XXX-XX-XX',
      ),
      keyboardType: TextInputType.phone,
    );
  }

  Widget _buildPasswordField(ColorScheme colorScheme) {
    return TextFormField(
      controller: _passwordController,
      decoration: InputDecoration(
        labelText: 'Пароль',
        prefixIcon: Icon(Icons.lock, color: colorScheme.primary),
        suffixIcon: IconButton(
          icon: Icon(
            _isPasswordVisible ? Icons.visibility : Icons.visibility_off,
            color: colorScheme.primary,
          ),
          onPressed: () {
            setState(() {
              _isPasswordVisible = !_isPasswordVisible;
            });
          },
        ),
      ),
      obscureText: !_isPasswordVisible,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Введите пароль';
        }
        if (value.length < 6) {
          return 'Пароль должен быть не менее 6 символов';
        }
        return null;
      },
    );
  }

  Widget _buildConfirmPasswordField(ColorScheme colorScheme) {
    return TextFormField(
      controller: _confirmPasswordController,
      decoration: InputDecoration(
        labelText: 'Подтвердите пароль',
        prefixIcon: Icon(Icons.lock_outline, color: colorScheme.primary),
        suffixIcon: IconButton(
          icon: Icon(
            _isConfirmPasswordVisible ? Icons.visibility : Icons.visibility_off,
            color: colorScheme.primary,
          ),
          onPressed: () {
            setState(() {
              _isConfirmPasswordVisible = !_isConfirmPasswordVisible;
            });
          },
        ),
      ),
      obscureText: !_isConfirmPasswordVisible,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Подтвердите пароль';
        }
        if (value != _passwordController.text) {
          return 'Пароли не совпадают';
        }
        return null;
      },
    );
  }

  Widget _buildRegisterButton(ColorScheme colorScheme) {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: ElevatedButton(
        onPressed: _register,
        style: ElevatedButton.styleFrom(
          backgroundColor: colorScheme.secondary,
          foregroundColor: colorScheme.onSecondary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          elevation: 2,
        ),
        child: Text(
          'Зарегистрироваться',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
      ),
    );
  }

  Widget _buildLoginSection(BuildContext context, ColorScheme colorScheme) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'Есть аккаунт? ',
          style: TextStyle(color: colorScheme.onSurface.withOpacity(0.7)),
        ),
        GestureDetector(
          onTap: () =>
              context.go(
                  Routes.login.withQuery('returnUrl', value: widget.returnUrl)),
          child: Text(
            'Войти',
            style: TextStyle(
              color: colorScheme.secondary,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }
}
