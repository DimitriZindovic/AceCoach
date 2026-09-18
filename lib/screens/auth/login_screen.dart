import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../constants/app_colors.dart';
import '../../constants/app_spacing.dart';
import '../../providers/auth_provider.dart';
import '../../widgets/primary_button.dart';
import 'auth_form_widgets.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  static const String routePath = '/login';

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    FocusScope.of(context).unfocus();
    if (!(_formKey.currentState?.validate() ?? false)) return;
    await ref
        .read(authControllerProvider.notifier)
        .signIn(
          email: _emailController.text,
          password: _passwordController.text,
        );
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authControllerProvider);
    final failure = ref.read(authControllerProvider.notifier).failure;
    final isLoading = authState.isLoading;
    final text = Theme.of(context).textTheme;

    return Scaffold(
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(
                26,
                AppSpacing.xl,
                26,
                AppSpacing.lg,
              ),
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: constraints.maxHeight - 36,
                ),
                child: IntrinsicHeight(
                  child: Form(
                    key: _formKey,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Image.asset(
                            'assets/icons/logo_badge.png',
                            width: 48,
                            height: 48,
                          ),
                        ),
                        const SizedBox(height: AppSpacing.sm),
                        Text('Welcome back', style: text.headlineMedium),
                        const SizedBox(height: AppSpacing.sm),
                        Text(
                          'Pick up your training plan where you left off.',
                          style: text.bodySmall,
                        ),
                        const SizedBox(height: AppSpacing.lg),
                        LabeledField(
                          label: 'Email',
                          child: TextFormField(
                            controller: _emailController,
                            keyboardType: TextInputType.emailAddress,
                            textInputAction: TextInputAction.next,
                            autofillHints: const [AutofillHints.email],
                            autocorrect: false,
                            enabled: !isLoading,
                            decoration: const InputDecoration(
                              hintText: 'you@example.com',
                              prefixIcon: Icon(
                                Icons.mail_outline_rounded,
                                size: 18,
                              ),
                            ),
                            validator: AuthValidators.email,
                          ),
                        ),
                        const SizedBox(height: AppSpacing.sm + 2),
                        LabeledField(
                          label: 'Password',
                          child: TextFormField(
                            controller: _passwordController,
                            obscureText: _obscurePassword,
                            textInputAction: TextInputAction.done,
                            autofillHints: const [AutofillHints.password],
                            enabled: !isLoading,
                            onFieldSubmitted: (_) => _submit(),
                            decoration: InputDecoration(
                              hintText: '••••••••',
                              prefixIcon: const Icon(
                                Icons.lock_outline_rounded,
                                size: 18,
                              ),
                              suffixIcon: IconButton(
                                tooltip: _obscurePassword
                                    ? 'Show password'
                                    : 'Hide password',
                                onPressed: () => setState(
                                  () => _obscurePassword = !_obscurePassword,
                                ),
                                icon: Icon(
                                  _obscurePassword
                                      ? Icons.visibility_outlined
                                      : Icons.visibility_off_outlined,
                                  size: 18,
                                ),
                              ),
                            ),
                            validator: AuthValidators.password,
                          ),
                        ),
                        Align(
                          alignment: Alignment.centerRight,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: AppSpacing.md,
                              vertical: AppSpacing.md,
                            ),
                            child: Text(
                              'Forgot password?',
                              style: Theme.of(context).textTheme.labelMedium
                                  ?.copyWith(color: AppColors.primaryDark),
                            ),
                          ),
                        ),
                        if (failure != null) ...[
                          AuthErrorBanner(message: failure.message),
                          const SizedBox(height: AppSpacing.md),
                        ] else
                          const SizedBox(height: AppSpacing.xs),
                        PrimaryButton(
                          label: 'Log in',
                          onPressed: _submit,
                        ),
                        const Spacer(),
                        const SizedBox(height: AppSpacing.lg),
                        Text(
                          'By continuing you accept our Terms & Privacy Policy',
                          textAlign: TextAlign.center,
                          style: text.labelSmall?.copyWith(
                            fontWeight: FontWeight.w400,
                            color: AppColors.textTertiary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
