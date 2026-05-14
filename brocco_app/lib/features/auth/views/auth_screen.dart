import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:brocco_app/l10n/generated/app_localizations.dart';
import '../../../core/theme/app_colors.dart';
import '../../../shared/widgets/buttons/primary_button.dart';
import '../viewmodels/auth_viewmodel.dart';
import 'widgets/auth_divider.dart';
import 'widgets/auth_text_field.dart';
import 'widgets/social_sign_in_button.dart';

class AuthScreen extends ConsumerStatefulWidget {
  const AuthScreen({super.key});

  @override
  ConsumerState<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends ConsumerState<AuthScreen>
    with SingleTickerProviderStateMixin {
  bool _isLogin = true;
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  late final AnimationController _fadeCtrl;
  late final Animation<double> _fadeAnim;

  @override
  void initState() {
    super.initState();
    _fadeCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _fadeAnim = CurvedAnimation(parent: _fadeCtrl, curve: Curves.easeInOut);
    _fadeCtrl.forward();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _fadeCtrl.dispose();
    super.dispose();
  }

  void _switchMode() {
    _fadeCtrl.reverse().then((_) {
      setState(() => _isLogin = !_isLogin);
      _fadeCtrl.forward();
    });
  }

  Future<void> _handleEmailAction() async {
    if (!_formKey.currentState!.validate()) return;
    final vm = ref.read(authViewModelProvider.notifier);

    FocusScope.of(context).unfocus();

    if (_isLogin) {
      await vm.signInWithEmail(
        _emailController.text.trim(),
        _passwordController.text,
      );
    } else {
      await vm.signUpWithEmail(
        _emailController.text.trim(),
        _passwordController.text,
      );
    }
  }

  Future<void> _handleGoogleSignIn() async {
    await ref.read(authViewModelProvider.notifier).signInWithGoogle();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    ref.listen<AsyncValue<AuthState>>(authViewModelProvider, (previous, next) {
      if (next.isLoading) return;

      final state = next.valueOrNull;

      if (state != null && state.status == AuthStatus.error) {
        final wasLoading = previous?.isLoading ?? false;
        final wasNotError = previous?.valueOrNull?.status != AuthStatus.error;

        if (wasLoading || wasNotError) {
          ScaffoldMessenger.of(context).clearSnackBars();

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                state.errorMessage ?? l10n.loginFailed,
                style: const TextStyle(
                  color: AppColors.errorRed,
                  fontWeight: FontWeight.w700,
                ),
              ),
              backgroundColor: AppColors.errorBackground,
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              duration: const Duration(seconds: 2),
            ),
          );
        }
      }
    });

    final authAsync = ref.watch(authViewModelProvider);
    final isLoading = authAsync.isLoading;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 28.0, vertical: 24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 24),

              Center(
                child: Column(
                  children: [
                    Container(
                      width: 72,
                      height: 72,
                      decoration: BoxDecoration(
                        color: AppColors.primaryText,
                        borderRadius: BorderRadius.circular(22),
                      ),
                      child: const Center(
                        child: Icon(
                          Icons.eco_rounded,
                          size: 38,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'Brocco',
                      style: TextStyle(
                        color: AppColors.primaryText,
                        fontSize: 34,
                        fontWeight: FontWeight.w900,
                        letterSpacing: -1,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      l10n.yourKitchenAssistant,
                      style: const TextStyle(
                        color: AppColors.greyText,
                        fontSize: 15,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 48),

              FadeTransition(
                opacity: _fadeAnim,
                child: Text(
                  _isLogin ? l10n.login : l10n.createAccount,
                  style: const TextStyle(
                    color: AppColors.primaryText,
                    fontSize: 28,
                    fontWeight: FontWeight.w900,
                    height: 1.2,
                  ),
                ),
              ),
              const SizedBox(height: 28),

              SocialSignInButton(
                isLoading: isLoading,
                onPressed: isLoading ? null : _handleGoogleSignIn,
              ),
              const SizedBox(height: 24),

              const AuthDivider(),
              const SizedBox(height: 24),

              FadeTransition(
                opacity: _fadeAnim,
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      AuthTextField(
                        key: const Key('auth_email_field'),
                        label: l10n.email,
                        controller: _emailController,
                        keyboardType: TextInputType.emailAddress,
                        validator: (v) {
                          if (v == null || v.isEmpty) return l10n.email;
                          if (!v.contains('@')) return l10n.invalidEmail;
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      AuthTextField(
                        key: const Key('auth_password_field'),
                        label: l10n.password,
                        controller: _passwordController,
                        isPassword: true,
                        validator: (v) {
                          if (v == null || v.length < 6)
                            return l10n.passwordTooShort;
                          return null;
                        },
                      ),
                      if (!_isLogin) ...[
                        const SizedBox(height: 16),
                        AuthTextField(
                          key: const Key('auth_confirm_password_field'),
                          label: l10n.repeatPassword,
                          controller: _confirmPasswordController,
                          isPassword: true,
                          validator: (v) {
                            if (v == null || v.isEmpty) {
                              return l10n.repeatPassword;
                            }
                            if (v != _passwordController.text) {
                              return l10n.passwordsDoNotMatch;
                            }
                            return null;
                          },
                        ),
                      ],
                      if (_isLogin) ...[
                        const SizedBox(height: 8),
                        Align(
                          alignment: Alignment.centerRight,
                          child: TextButton(
                            onPressed: () {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(l10n.featureInPreparation),
                                ),
                              );
                            },
                            style: TextButton.styleFrom(
                              foregroundColor: AppColors.greyText,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 4,
                              ),
                              minimumSize: Size.zero,
                              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                            ),
                            child: Text(
                              l10n.forgotPassword,
                              style: const TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 28),

              PrimaryButton(
                key: const Key('auth_primary_button'),
                text: _isLogin ? l10n.login : l10n.register,
                onPressed: isLoading ? null : _handleEmailAction,
              ),

              const SizedBox(height: 20),

              Center(
                child: GestureDetector(
                  key: const Key('auth_toggle_mode'),
                  onTap: isLoading ? null : _switchMode,
                  child: RichText(
                    text: TextSpan(
                      style: const TextStyle(
                        fontSize: 14,
                        color: AppColors.greyText,
                      ),
                      children: [
                        TextSpan(
                          text: _isLogin
                              ? l10n.noAccountYet
                              : l10n.alreadyHaveAccount,
                        ),
                        TextSpan(
                          text: _isLogin ? l10n.register : l10n.login,
                          style: const TextStyle(
                            color: AppColors.primaryText,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}
