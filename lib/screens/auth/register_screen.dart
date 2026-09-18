import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../constants/app_spacing.dart';
import '../../providers/auth_provider.dart';
import '../../widgets/app_logo.dart';
import '../../widgets/primary_button.dart';
import 'auth_form_widgets.dart';

class RegisterScreen extends ConsumerStatefulWidget {
  const RegisterScreen({super.key});

  static const String routePath = '/register';

  @override
  ConsumerState<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends ConsumerState<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmController = TextEditingController();
  bool _obscure = true;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    FocusScope.of(context).unfocus();
    if (!(_formKey.currentState?.validate() ?? false)) return;
    await ref
        .read(authControllerProvider.notifier)
        .register(
          email: _emailController.text,
          password: _passwordController.text,
          displayName: _nameController.text,
        );
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authControllerProvider);
    final failure = ref.read(authControllerProvider.notifier).failure;
    final isLoading = authState.isLoading;
    final text = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          tooltip: 'Back',
          onPressed: () => context.pop(),
          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20),
        ),
        shape: const Border(),
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      ),
      body: SafeArea(
        top: false,
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(26, 0, 26, AppSpacing.xxl),
          child: Form(
            key: _formKey,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Align(
                  alignment: Alignment.centerLeft,
                  child: AppLogoBadge(),
                ),
                const SizedBox(height: AppSpacing.sm),
                Text('Create your account', style: text.headlineMedium),
                const SizedBox(height: AppSpacing.sm),
                Text(
                  'Your sessions and progress stay on this device, tied to '
                  'your account.',
                  style: text.bodySmall,
                ),
                const SizedBox(height: AppSpacing.lg),
                LabeledField(
                  label: 'Name',
                  child: TextFormField(
                    controller: _nameController,
                    textCapitalization: TextCapitalization.words,
                    textInputAction: TextInputAction.next,
                    autofillHints: const [AutofillHints.name],
                    enabled: !isLoading,
                    decoration: const InputDecoration(
                      hintText: 'Marc Delaunay',
                      prefixIcon: Icon(Icons.person_outline_rounded, size: 18),
                    ),
                    validator: AuthValidators.name,
                  ),
                ),
                const SizedBox(height: AppSpacing.sm + 2),
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
                      prefixIcon: Icon(Icons.mail_outline_rounded, size: 18),
                    ),
                    validator: AuthValidators.email,
                  ),
                ),
                const SizedBox(height: AppSpacing.sm + 2),
                LabeledField(
                  label: 'Password',
                  child: TextFormField(
                    controller: _passwordController,
                    obscureText: _obscure,
                    textInputAction: TextInputAction.next,
                    autofillHints: const [AutofillHints.newPassword],
                    enabled: !isLoading,
                    decoration: InputDecoration(
                      hintText: 'At least 8 characters',
                      prefixIcon: const Icon(
                        Icons.lock_outline_rounded,
                        size: 18,
                      ),
                      suffixIcon: IconButton(
                        tooltip: _obscure ? 'Show password' : 'Hide password',
                        onPressed: () => setState(() => _obscure = !_obscure),
                        icon: Icon(
                          _obscure
                              ? Icons.visibility_outlined
                              : Icons.visibility_off_outlined,
                          size: 18,
                        ),
                      ),
                    ),
                    validator: (v) => AuthValidators.password(v, strict: true),
                  ),
                ),
                const SizedBox(height: AppSpacing.sm + 2),
                LabeledField(
                  label: 'Confirm password',
                  child: TextFormField(
                    controller: _confirmController,
                    obscureText: _obscure,
                    textInputAction: TextInputAction.done,
                    enabled: !isLoading,
                    onFieldSubmitted: (_) => _submit(),
                    decoration: const InputDecoration(
                      hintText: 'Repeat your password',
                      prefixIcon: Icon(Icons.lock_outline_rounded, size: 18),
                    ),
                    validator: (v) =>
                        AuthValidators.confirm(v, _passwordController.text),
                  ),
                ),
                const SizedBox(height: AppSpacing.lg),
                if (failure != null) ...[
                  AuthErrorBanner(message: failure.message),
                  const SizedBox(height: AppSpacing.md),
                ],
                PrimaryButton(
                  label: 'Create account',
                  onPressed: _submit,
                ),
                const SizedBox(height: AppSpacing.md),
                TextButton(
                  onPressed: isLoading ? null : () => context.pop(),
                  child: const Text('Already have an account? Log in'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
