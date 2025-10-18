import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:lapcraft/core/app_route.dart';
import 'package:lapcraft/features/profile/presentation/cubits/auth_cubit.dart';

import '../cubits/auth_state.dart';

class LoginPage extends StatefulWidget {
  final String? returnUrl;

  const LoginPage({super.key, this.returnUrl});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage>
    with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  bool _isPasswordVisible = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 800),
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeIn),
    );

    _slideAnimation = Tween<Offset>(
      begin: Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOut,
    ));

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _login() {
    if (_formKey.currentState!.validate()) {
      context.read<AuthCubit>().login(
            _emailController.text.trim(),
            _passwordController.text,
          );
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
                child: SlideTransition(
                  position: _slideAnimation,
                  child: FadeTransition(
                    opacity: _fadeAnimation,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Заголовок
                        _buildHeader(colorScheme),
                        SizedBox(height: 48),

                        // Поля ввода
                        _buildEmailField(colorScheme),
                        SizedBox(height: 16),
                        _buildPasswordField(colorScheme),
                        SizedBox(height: 24),

                        // Кнопка входа
                        _buildLoginButton(colorScheme),
                        SizedBox(height: 24),

                        // Регистрация
                        _buildRegisterSection(context, colorScheme),
                      ],
                    ),
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
        // IconButton(
        //   onPressed: () => Navigator.pop(context),
        //   icon: Icon(Icons.arrow_back, color: colorScheme.onSurface),
        // ),
        SizedBox(height: 16),
        Text(
          'Вход в аккаунт',
          style: TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.bold,
            color: colorScheme.primary,
          ),
        ),
        SizedBox(height: 8),
        Text(
          'Добро пожаловать в наш зоомагазин!',
          style: TextStyle(
            fontSize: 16,
            color: colorScheme.onSurface.withOpacity(0.7),
          ),
        ),
      ],
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

  Widget _buildLoginButton(ColorScheme colorScheme) {
    return BlocBuilder<AuthCubit, AuthState>(
      builder: (context, state) {
        final isLoading = state is AuthLoading;

        return AnimatedContainer(
          duration: Duration(milliseconds: 300),
          width: double.infinity,
          height: 56,
          child: ElevatedButton(
            onPressed: isLoading ? null : _login,
            style: ElevatedButton.styleFrom(
              backgroundColor: colorScheme.primary,
              foregroundColor: colorScheme.onPrimary,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              elevation: 2,
            ),
            child: isLoading
                ? SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation(colorScheme.onPrimary),
                    ),
                  )
                : Text(
                    'Войти',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  ),
          ),
        );
      },
    );
  }

  Widget _buildRegisterSection(BuildContext context, ColorScheme colorScheme) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'Нет аккаунта? ',
          style: TextStyle(color: colorScheme.onSurface.withOpacity(0.7)),
        ),
        GestureDetector(
          onTap: () => context.go(Routes.register.withQuery('returnUrl', value: widget.returnUrl)),
          child: Text(
            'Зарегистрироваться',
            style: TextStyle(
              color: colorScheme.secondary,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildAnimalPawsDecoration(ColorScheme colorScheme) {
    return Center(
      child: Wrap(
        spacing: 12,
        children: List.generate(4, (index) {
          return AnimatedContainer(
            duration: Duration(milliseconds: 400 + index * 100),
            curve: Curves.easeInOut,
            child: Icon(
              Icons.pets,
              color: colorScheme.primary.withOpacity(0.3),
              size: 24,
            ),
          );
        }),
      ),
    );
  }
}
