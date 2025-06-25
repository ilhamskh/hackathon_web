import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/design/app_colors.dart';
import '../../../core/design/app_typography.dart';
import '../../../core/design/app_spacing.dart';
import '../../../shared/widgets/modern_widgets.dart';
import '../../../shared/utils/responsive_utils.dart';
import '../cubit/auth_cubit.dart';

class ModernLoginPage extends StatefulWidget {
  const ModernLoginPage({super.key});

  @override
  State<ModernLoginPage> createState() => _ModernLoginPageState();
}

class _ModernLoginPageState extends State<ModernLoginPage>
    with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOut),
    );
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOut),
    );
    
    _animationController.forward();
    
    // Set demo credentials
    _emailController.text = 'admin@hackathon.com';
    _passwordController.text = 'admin123';
  }

  @override
  void dispose() {
    _animationController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _handleLogin() {
    if (_formKey.currentState!.validate()) {
      // For demo purposes, we'll simulate a successful login
      context.read<AuthCubit>().login(
        _emailController.text,
        _passwordController.text,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = ResponsiveUtils.isMobile(context);
    
    return Scaffold(
      backgroundColor: AppColors.gray50,
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
            colors: [
              AppColors.primary,
              AppColors.primaryLight,
              AppColors.secondary,
            ],
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            padding: AppSpacing.paddingLG,
            child: FadeTransition(
              opacity: _fadeAnimation,
              child: SlideTransition(
                position: _slideAnimation,
                child: Container(
                  width: isMobile ? double.infinity : 500,
                  constraints: const BoxConstraints(maxWidth: 500),
                  child: GlassContainer(
                    padding: AppSpacing.paddingXXL,
                    opacity: 0.95,
                    child: Form(
                      key: _formKey,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          // Logo and Title
                          _buildHeader(),
                          AppSpacing.verticalGapXL,
                          AppSpacing.verticalGapXL,
                          
                          // Demo Credentials Info
                          _buildDemoInfo(),
                          AppSpacing.verticalGapXL,
                          
                          // Login Form
                          _buildLoginForm(),
                          AppSpacing.verticalGapXL,
                          
                          // Login Button
                          _buildLoginButton(),
                          AppSpacing.verticalGapLG,
                          
                          // Additional Links
                          _buildAdditionalLinks(),
                        ],
                      ),
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

  Widget _buildHeader() {
    return Column(
      children: [
        Container(
          width: 80,
          height: 80,
          decoration: const BoxDecoration(
            gradient: AppColors.primaryGradient,
            shape: BoxShape.circle,
          ),
          child: const Icon(
            Icons.rocket_launch_rounded,
            color: AppColors.white,
            size: 40,
          ),
        ),
        AppSpacing.verticalGapLG,
        Text(
          'Hackathon Admin',
          style: AppTypography.h3.copyWith(
            color: AppColors.gray900,
            fontWeight: FontWeight.w800,
          ),
        ),
        AppSpacing.verticalGapSM,
        Text(
          'Welcome back! Please sign in to your account.',
          style: AppTypography.bodyLarge.copyWith(
            color: AppColors.gray600,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildDemoInfo() {
    return Container(
      padding: AppSpacing.paddingMD,
      decoration: BoxDecoration(
        color: AppColors.info.withOpacity(0.1),
        borderRadius: AppBorderRadius.radiusLG,
        border: Border.all(
          color: AppColors.info.withOpacity(0.2),
        ),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Icon(
                Icons.info_outline_rounded,
                color: AppColors.info,
                size: 20,
              ),
              AppSpacing.horizontalGapSM,
              Text(
                'Demo Credentials',
                style: AppTypography.labelMedium.copyWith(
                  color: AppColors.info,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          AppSpacing.verticalGapSM,
          Text(
            'Email: admin@hackathon.com\nPassword: admin123',
            style: AppTypography.bodySmall.copyWith(
              color: AppColors.gray700,
              fontFamily: 'monospace',
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildLoginForm() {
    return Column(
      children: [
        ModernTextField(
          label: 'Email Address',
          hint: 'Enter your email',
          value: _emailController.text,
          onChanged: (value) => _emailController.text = value,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter your email';
            }
            if (!value.contains('@')) {
              return 'Please enter a valid email';
            }
            return null;
          },
          keyboardType: TextInputType.emailAddress,
          prefixIcon: const Icon(Icons.email_outlined),
          required: true,
        ),
        AppSpacing.verticalGapLG,
        ModernTextField(
          label: 'Password',
          hint: 'Enter your password',
          value: _passwordController.text,
          onChanged: (value) => _passwordController.text = value,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter your password';
            }
            if (value.length < 6) {
              return 'Password must be at least 6 characters';
            }
            return null;
          },
          obscureText: true,
          prefixIcon: const Icon(Icons.lock_outlined),
          required: true,
        ),
      ],
    );
  }

  Widget _buildLoginButton() {
    return BlocConsumer<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state is AuthError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: AppColors.error,
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                borderRadius: AppBorderRadius.radiusLG,
              ),
            ),
          );
        }
      },
      builder: (context, state) {
        return Column(
          children: [
            SizedBox(
              width: double.infinity,
              child: ModernButton(
                text: 'Sign In',
                onPressed: state is AuthLoading ? null : _handleLogin,
                isLoading: state is AuthLoading,
                icon: Icons.login_rounded,
              ),
            ),
            AppSpacing.verticalGapMD,
            Row(
              children: [
                Checkbox(
                  value: true,
                  onChanged: (value) {},
                  shape: RoundedRectangleBorder(
                    borderRadius: AppBorderRadius.radiusSM,
                  ),
                ),
                AppSpacing.horizontalGapSM,
                Text(
                  'Remember me',
                  style: AppTypography.bodyMedium.copyWith(
                    color: AppColors.gray600,
                  ),
                ),
                const Spacer(),
                TextButton(
                  onPressed: () {
                    // Handle forgot password
                  },
                  child: Text(
                    'Forgot Password?',
                    style: AppTypography.bodyMedium.copyWith(
                      color: AppColors.primary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );
  }

  Widget _buildAdditionalLinks() {
    return Column(
      children: [
        Row(
          children: [
            Expanded(child: Divider(color: AppColors.gray300)),
            Padding(
              padding: AppSpacing.horizontalMD,
              child: Text(
                'or',
                style: AppTypography.bodyMedium.copyWith(
                  color: AppColors.gray500,
                ),
              ),
            ),
            Expanded(child: Divider(color: AppColors.gray300)),
          ],
        ),
        AppSpacing.verticalGapLG,
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _buildSocialButton(
              icon: Icons.g_mobiledata_rounded,
              label: 'Google',
              onPressed: () {
                // Demo login with Google
                context.read<AuthCubit>().login('demo@google.com', 'demo123');
              },
            ),
            _buildSocialButton(
              icon: Icons.facebook_rounded,
              label: 'Facebook',
              onPressed: () {
                // Demo login with Facebook
                context.read<AuthCubit>().login('demo@facebook.com', 'demo123');
              },
            ),
            _buildSocialButton(
              icon: Icons.school_rounded,
              label: 'GitHub',
              onPressed: () {
                // Demo login with GitHub
                context.read<AuthCubit>().login('demo@github.com', 'demo123');
              },
            ),
          ],
        ),
        AppSpacing.verticalGapLG,
        RichText(
          text: TextSpan(
            text: "Don't have an account? ",
            style: AppTypography.bodyMedium.copyWith(
              color: AppColors.gray600,
            ),
            children: [
              WidgetSpan(
                child: GestureDetector(
                  onTap: () {
                    // Navigate to sign up
                  },
                  child: Text(
                    'Sign up here',
                    style: AppTypography.bodyMedium.copyWith(
                      color: AppColors.primary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSocialButton({
    required IconData icon,
    required String label,
    required VoidCallback onPressed,
  }) {
    return ModernButton(
      text: label,
      icon: icon,
      onPressed: onPressed,
      isOutlined: true,
      width: 100,
    );
  }
}
