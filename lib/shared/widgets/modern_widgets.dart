import 'package:flutter/material.dart';
import 'dart:ui';
import 'package:flutter_datetime_picker_plus/flutter_datetime_picker_plus.dart'
    as picker;
import 'package:hackathon_web/core/design/app_spacing.dart';
import 'package:hackathon_web/core/design/app_typography.dart';
import 'package:intl/intl.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../utils/responsive_utils.dart';

// Glass Morphism Container
class GlassContainer extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final double borderRadius;
  final double opacity;
  final Color? color;
  final bool showBorder;

  const GlassContainer({
    super.key,
    required this.child,
    this.padding,
    this.margin,
    this.borderRadius = AppBorderRadius.lg,
    this.opacity = 0.1,
    this.color,
    this.showBorder = true,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(borderRadius),
        border: showBorder
            ? Border.all(color: AppColors.white.withOpacity(0.2), width: 1)
            : null,
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(borderRadius),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Container(
            padding: padding,
            decoration: BoxDecoration(
              color: (color ?? AppColors.white).withOpacity(opacity),
              borderRadius: BorderRadius.circular(borderRadius),
            ),
            child: child,
          ),
        ),
      ),
    );
  }
}

// Modern Button with gradient and animations
class ModernButton extends StatefulWidget {
  final String text;
  final VoidCallback? onPressed;
  final bool isLoading;
  final bool isOutlined;
  final Color? color;
  final Color? textColor;
  final IconData? icon;
  final double? width;
  final double? height;
  final EdgeInsetsGeometry? padding;

  const ModernButton({
    super.key,
    required this.text,
    this.onPressed,
    this.isLoading = false,
    this.isOutlined = false,
    this.color,
    this.textColor,
    this.icon,
    this.width,
    this.height,
    this.padding,
  });

  @override
  State<ModernButton> createState() => _ModernButtonState();
}

class _ModernButtonState extends State<ModernButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _opacityAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 150),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.95,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
    _opacityAnimation = Tween<double>(
      begin: 1.0,
      end: 0.8,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final buttonColor = widget.color ?? AppColors.primary;
    final textColor = widget.textColor ?? AppColors.white;

    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnimation.value,
          child: Opacity(
            opacity: _opacityAnimation.value,
            child: GestureDetector(
              onTapDown: (_) => _controller.forward(),
              onTapUp: (_) => _controller.reverse(),
              onTapCancel: () => _controller.reverse(),
              onTap: widget.onPressed,
              child: Container(
                width: widget.width,
                height: widget.height ?? 48,
                padding: widget.padding ?? AppSpacing.paddingMD,
                decoration: BoxDecoration(
                  gradient: widget.isOutlined
                      ? null
                      : LinearGradient(
                          colors: [buttonColor, buttonColor.withOpacity(0.8)],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                  border: widget.isOutlined
                      ? Border.all(color: buttonColor, width: 2)
                      : null,
                  borderRadius: AppBorderRadius.radiusLG,
                  boxShadow: widget.isOutlined
                      ? null
                      : [
                          BoxShadow(
                            color: buttonColor.withOpacity(0.3),
                            blurRadius: 8,
                            offset: const Offset(0, 4),
                          ),
                        ],
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (widget.isLoading)
                      SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(textColor),
                        ),
                      )
                    else ...[
                      if (widget.icon != null) ...[
                        Icon(widget.icon, color: textColor, size: 20),
                        AppSpacing.horizontalGapSM,
                      ],
                      Text(
                        widget.text,
                        style: AppTypography.buttonMedium.copyWith(
                          color: widget.isOutlined ? buttonColor : textColor,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

// Modern Card with hover effects
class ModernCard extends StatefulWidget {
  final Widget child;
  final VoidCallback? onTap;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final double? elevation;
  final Color? color;
  final bool showHoverEffect;

  const ModernCard({
    super.key,
    required this.child,
    this.onTap,
    this.padding,
    this.margin,
    this.elevation,
    this.color,
    this.showHoverEffect = true,
  });

  @override
  State<ModernCard> createState() => _ModernCardState();
}

class _ModernCardState extends State<ModernCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _elevationAnimation;
  late Animation<double> _scaleAnimation;

  bool _isHovered = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    _elevationAnimation = Tween<double>(
      begin: widget.elevation ?? AppElevation.sm,
      end: (widget.elevation ?? AppElevation.sm) + 4,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 1.02,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnimation.value,
          child: MouseRegion(
            onEnter: (_) {
              if (widget.showHoverEffect) {
                setState(() => _isHovered = true);
                _controller.forward();
              }
            },
            onExit: (_) {
              if (widget.showHoverEffect) {
                setState(() => _isHovered = false);
                _controller.reverse();
              }
            },
            child: Material(
              color: widget.color ?? AppColors.white,
              elevation: _elevationAnimation.value,
              borderRadius: AppBorderRadius.radiusLG,
              shadowColor: AppColors.surfaceLight,
              child: InkWell(
                onTap: widget.onTap,
                borderRadius: AppBorderRadius.radiusLG,
                child: Container(
                  padding: widget.padding ?? AppSpacing.paddingLG,
                  margin: widget.margin,
                  decoration: BoxDecoration(
                    borderRadius: AppBorderRadius.radiusLG,
                    border: Border.all(
                      color: _isHovered
                          ? AppColors.primary.withOpacity(0.2)
                          : AppColors.grey200,
                      width: 1,
                    ),
                  ),
                  child: widget.child,
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

// Modern Text Field with floating label
class ModernTextField extends StatefulWidget {
  final String label;
  final String? hint;
  final String? value;
  final Function(String) onChanged;
  final String? Function(String?)? validator;
  final bool required;
  final int maxLines;
  final TextInputType keyboardType;
  final bool enabled;
  final Widget? suffixIcon;
  final Widget? prefixIcon;
  final bool obscureText;

  const ModernTextField({
    super.key,
    required this.label,
    this.hint,
    this.value,
    required this.onChanged,
    this.validator,
    this.required = false,
    this.maxLines = 1,
    this.keyboardType = TextInputType.text,
    this.enabled = true,
    this.suffixIcon,
    this.prefixIcon,
    this.obscureText = false,
  });

  @override
  State<ModernTextField> createState() => _ModernTextFieldState();
}

class _ModernTextFieldState extends State<ModernTextField>
    with SingleTickerProviderStateMixin {
  late TextEditingController _controller;
  late FocusNode _focusNode;
  late AnimationController _animationController;
  late Animation<Color?> _borderColorAnimation;

  bool _isFocused = false;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.value);
    _focusNode = FocusNode();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    _borderColorAnimation = ColorTween(
      begin: AppColors.grey300,
      end: AppColors.primary,
    ).animate(_animationController);

    _focusNode.addListener(() {
      setState(() => _isFocused = _focusNode.hasFocus);
      if (_focusNode.hasFocus) {
        _animationController.forward();
      } else {
        _animationController.reverse();
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _borderColorAnimation,
      builder: (context, child) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            RichText(
              text: TextSpan(
                text: widget.label,
                style: AppTypography.labelMedium.copyWith(
                  color: _isFocused ? AppColors.primary : AppColors.grey600,
                  fontWeight: FontWeight.w600,
                ),
                children: widget.required
                    ? [
                        TextSpan(
                          text: ' *',
                          style: AppTypography.labelMedium.copyWith(
                            color: AppColors.error,
                          ),
                        ),
                      ]
                    : null,
              ),
            ),
            AppSpacing.verticalGapSM,
            Container(
              decoration: BoxDecoration(
                borderRadius: AppBorderRadius.radiusLG,
                boxShadow: _isFocused
                    ? [
                        BoxShadow(
                          color: AppColors.primary.withOpacity(0.1),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ]
                    : null,
              ),
              child: TextFormField(
                controller: _controller,
                focusNode: _focusNode,
                onChanged: widget.onChanged,
                validator: widget.validator,
                maxLines: widget.maxLines,
                keyboardType: widget.keyboardType,
                enabled: widget.enabled,
                obscureText: widget.obscureText,
                style: AppTypography.bodyMedium,
                decoration: InputDecoration(
                  hintText: widget.hint,
                  suffixIcon: widget.suffixIcon,
                  prefixIcon: widget.prefixIcon,
                  border: OutlineInputBorder(
                    borderRadius: AppBorderRadius.radiusLG,
                    borderSide: BorderSide(color: _borderColorAnimation.value!),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: AppBorderRadius.radiusLG,
                    borderSide: const BorderSide(color: AppColors.grey300),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: AppBorderRadius.radiusLG,
                    borderSide: const BorderSide(
                      color: AppColors.primary,
                      width: 2,
                    ),
                  ),
                  errorBorder: OutlineInputBorder(
                    borderRadius: AppBorderRadius.radiusLG,
                    borderSide: const BorderSide(color: AppColors.error),
                  ),
                  filled: true,
                  fillColor: _isFocused ? AppColors.white : AppColors.grey50,
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

// Modern Dropdown with search
class ModernDropdown extends StatefulWidget {
  final String label;
  final String? value;
  final List<String> items;
  final Function(String?) onChanged;
  final String? Function(String?)? validator;
  final bool required;
  final String? hint;
  final bool searchable;

  const ModernDropdown({
    super.key,
    required this.label,
    this.value,
    required this.items,
    required this.onChanged,
    this.validator,
    this.required = false,
    this.hint,
    this.searchable = false,
  });

  @override
  State<ModernDropdown> createState() => _ModernDropdownState();
}

class _ModernDropdownState extends State<ModernDropdown> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RichText(
          text: TextSpan(
            text: widget.label,
            style: AppTypography.labelMedium.copyWith(
              color: AppColors.grey600,
              fontWeight: FontWeight.w600,
            ),
            children: widget.required
                ? [
                    TextSpan(
                      text: ' *',
                      style: AppTypography.labelMedium.copyWith(
                        color: AppColors.error,
                      ),
                    ),
                  ]
                : null,
          ),
        ),
        AppSpacing.verticalGapSM,
        Container(
          decoration: BoxDecoration(
            borderRadius: AppBorderRadius.radiusLG,
            boxShadow: [
              BoxShadow(
                color: AppColors.grey200,
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: DropdownButtonFormField<String>(
            value: widget.value,
            items: widget.items.map((item) {
              return DropdownMenuItem<String>(
                value: item,
                child: Text(item, style: AppTypography.bodyMedium),
              );
            }).toList(),
            onChanged: widget.onChanged,
            validator: widget.validator,
            decoration: InputDecoration(
              hintText: widget.hint,
              border: OutlineInputBorder(
                borderRadius: AppBorderRadius.radiusLG,
                borderSide: const BorderSide(color: AppColors.grey300),
              ),
              filled: true,
              fillColor: AppColors.white,
            ),
            style: AppTypography.bodyMedium,
            icon: const Icon(Icons.keyboard_arrow_down_rounded),
          ),
        ),
      ],
    );
  }
}

// Status Badge with animated colors
class StatusBadge extends StatelessWidget {
  final String text;
  final String status;
  final bool showDot;

  const StatusBadge({
    super.key,
    required this.text,
    required this.status,
    this.showDot = true,
  });

  @override
  Widget build(BuildContext context) {
    Color backgroundColor;
    Color textColor;

    switch (status.toLowerCase()) {
      case 'active':
      case 'published':
      case 'running':
        backgroundColor = AppColors.success.withOpacity(0.1);
        textColor = AppColors.success;
        break;
      case 'draft':
      case 'pending':
        backgroundColor = AppColors.warning.withOpacity(0.1);
        textColor = AppColors.warning;
        break;
      case 'ended':
      case 'expired':
        backgroundColor = AppColors.grey200;
        textColor = AppColors.grey600;
        break;
      case 'cancelled':
        backgroundColor = AppColors.error.withOpacity(0.1);
        textColor = AppColors.error;
        break;
      default:
        backgroundColor = AppColors.info.withOpacity(0.1);
        textColor = AppColors.info;
    }

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.sm,
        vertical: AppSpacing.xs,
      ),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: AppBorderRadius.radiusFull,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (showDot) ...[
            Container(
              width: 6,
              height: 6,
              decoration: BoxDecoration(
                color: textColor,
                shape: BoxShape.circle,
              ),
            ),
            AppSpacing.horizontalGapXS,
          ],
          Text(
            text,
            style: AppTypography.labelSmall.copyWith(
              color: textColor,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

// Metric Card with animation
class MetricCard extends StatefulWidget {
  final String title;
  final String value;
  final String? subtitle;
  final IconData icon;
  final Color? color;
  final String? trend;
  final bool showTrend;

  const MetricCard({
    super.key,
    required this.title,
    required this.value,
    this.subtitle,
    required this.icon,
    this.color,
    this.trend,
    this.showTrend = false,
  });

  @override
  State<MetricCard> createState() => _MetricCardState();
}

class _MetricCardState extends State<MetricCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _valueAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );
    _valueAnimation = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cardColor = widget.color ?? AppColors.primary;

    return ModernCard(
      padding: AppSpacing.paddingLG,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: AppSpacing.paddingSM,
                decoration: BoxDecoration(
                  color: cardColor.withOpacity(0.1),
                  borderRadius: AppBorderRadius.radiusMD,
                ),
                child: Icon(widget.icon, color: cardColor, size: 24),
              ),
              const Spacer(),
              if (widget.showTrend && widget.trend != null)
                StatusBadge(
                  text: widget.trend!,
                  status: 'active',
                  showDot: false,
                ),
            ],
          ),
          AppSpacing.verticalGapMD,
          AnimatedBuilder(
            animation: _valueAnimation,
            builder: (context, child) {
              return Text(
                widget.value,
                style: AppTypography.h3.copyWith(
                  color: AppColors.grey900,
                  fontWeight: FontWeight.w800,
                ),
              );
            },
          ),
          AppSpacing.verticalGapXS,
          Text(
            widget.title,
            style: AppTypography.bodyMedium.copyWith(color: AppColors.grey600),
          ),
          if (widget.subtitle != null) ...[
            AppSpacing.verticalGapXS,
            Text(
              widget.subtitle!,
              style: AppTypography.labelSmall.copyWith(
                color: AppColors.grey500,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

// Modern Date Time Picker with animations
class ModernDateTimePicker extends StatefulWidget {
  final String label;
  final String? hint;
  final DateTime? value;
  final Function(DateTime?) onChanged;
  final String? Function(DateTime?)? validator;
  final bool required;
  final bool enabled;
  final DateTimePickerMode mode;
  final DateTime? firstDate;
  final DateTime? lastDate;

  const ModernDateTimePicker({
    super.key,
    required this.label,
    this.hint,
    this.value,
    required this.onChanged,
    this.validator,
    this.required = false,
    this.enabled = true,
    this.mode = DateTimePickerMode.dateTime,
    this.firstDate,
    this.lastDate,
  });

  @override
  State<ModernDateTimePicker> createState() => _ModernDateTimePickerState();
}

class _ModernDateTimePickerState extends State<ModernDateTimePicker>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<Color?> _borderColorAnimation;
  late Animation<double> _scaleAnimation;

  bool _isFocused = false;
  String? _errorText;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );

    _borderColorAnimation =
        ColorTween(begin: AppColors.grey300, end: AppColors.primary).animate(
          CurvedAnimation(
            parent: _animationController,
            curve: Curves.easeInOut,
          ),
        );

    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.02).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _validateField() {
    if (widget.validator != null) {
      setState(() {
        _errorText = widget.validator!(widget.value);
      });
    }
  }

  String _formatDateTime(DateTime dateTime) {
    switch (widget.mode) {
      case DateTimePickerMode.date:
        return DateFormat('MMM dd, yyyy').format(dateTime);
      case DateTimePickerMode.time:
        return DateFormat('hh:mm a').format(dateTime);
      case DateTimePickerMode.dateTime:
        return DateFormat('MMM dd, yyyy hh:mm a').format(dateTime);
    }
  }

  void _showDateTimePicker(BuildContext context) {
    setState(() {
      _isFocused = true;
    });
    _animationController.forward();

    switch (widget.mode) {
      case DateTimePickerMode.date:
        _showDatePicker(context);
        break;
      case DateTimePickerMode.time:
        _showTimePicker(context);
        break;
      case DateTimePickerMode.dateTime:
        _showDateTimePickerDialog(context);
        break;
    }
  }

  void _showDatePicker(BuildContext context) {
    picker.DatePicker.showDatePicker(
      context,
      showTitleActions: true,
      minTime: widget.firstDate ?? DateTime(1900),
      maxTime: widget.lastDate ?? DateTime(2100),
      currentTime: widget.value ?? DateTime.now(),
      locale: picker.LocaleType.en,
      theme: picker.DatePickerTheme(
        backgroundColor: AppColors.white,
        headerColor: AppColors.primary,
        titleHeight: 50,
        itemStyle: AppTextStyles.bodyLarge.copyWith(
          color: AppColors.textPrimary,
        ),
        cancelStyle: AppTextStyles.bodyMedium.copyWith(
          color: AppColors.textSecondary,
        ),
        doneStyle: AppTextStyles.bodyMedium.copyWith(
          color: AppColors.white,
          fontWeight: FontWeight.w600,
        ),
      ),
      onConfirm: (date) {
        widget.onChanged(date);
        _validateField();
        setState(() {
          _isFocused = false;
        });
        _animationController.reverse();
      },
      onCancel: () {
        setState(() {
          _isFocused = false;
        });
        _animationController.reverse();
      },
    );
  }

  void _showTimePicker(BuildContext context) {
    picker.DatePicker.showTimePicker(
      context,
      showTitleActions: true,
      currentTime: widget.value ?? DateTime.now(),
      locale: picker.LocaleType.en,
      theme: picker.DatePickerTheme(
        backgroundColor: AppColors.white,
        headerColor: AppColors.primary,
        titleHeight: 50,
        itemStyle: AppTextStyles.bodyLarge.copyWith(
          color: AppColors.textPrimary,
        ),
        cancelStyle: AppTextStyles.bodyMedium.copyWith(
          color: AppColors.textSecondary,
        ),
        doneStyle: AppTextStyles.bodyMedium.copyWith(
          color: AppColors.white,
          fontWeight: FontWeight.w600,
        ),
      ),
      onConfirm: (time) {
        // Combine with existing date or use today's date
        final existingDate = widget.value ?? DateTime.now();
        final newDateTime = DateTime(
          existingDate.year,
          existingDate.month,
          existingDate.day,
          time.hour,
          time.minute,
        );
        widget.onChanged(newDateTime);
        _validateField();
        setState(() {
          _isFocused = false;
        });
        _animationController.reverse();
      },
      onCancel: () {
        setState(() {
          _isFocused = false;
        });
        _animationController.reverse();
      },
    );
  }

  void _showDateTimePickerDialog(BuildContext context) {
    picker.DatePicker.showDateTimePicker(
      context,
      showTitleActions: true,
      minTime: widget.firstDate ?? DateTime(1900),
      maxTime: widget.lastDate ?? DateTime(2100),
      currentTime: widget.value ?? DateTime.now(),
      locale: picker.LocaleType.en,
      theme: picker.DatePickerTheme(
        backgroundColor: AppColors.white,
        headerColor: AppColors.primary,
        titleHeight: 50,
        itemStyle: AppTextStyles.bodyLarge.copyWith(
          color: AppColors.textPrimary,
        ),
        cancelStyle: AppTextStyles.bodyMedium.copyWith(
          color: AppColors.textSecondary,
        ),
        doneStyle: AppTextStyles.bodyMedium.copyWith(
          color: AppColors.white,
          fontWeight: FontWeight.w600,
        ),
      ),
      onConfirm: (dateTime) {
        widget.onChanged(dateTime);
        _validateField();
        setState(() {
          _isFocused = false;
        });
        _animationController.reverse();
      },
      onCancel: () {
        setState(() {
          _isFocused = false;
        });
        _animationController.reverse();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Label
        if (widget.label.isNotEmpty) ...[
          RichText(
            text: TextSpan(
              text: widget.label,
              style: AppTextStyles.labelMedium.copyWith(
                color: isDark
                    ? AppColors.textSecondaryDark
                    : AppColors.textSecondary,
                fontWeight: FontWeight.w500,
              ),
              children: [
                if (widget.required)
                  TextSpan(
                    text: ' *',
                    style: AppTextStyles.labelMedium.copyWith(
                      color: AppColors.error,
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(height: 8),
        ],

        // Date Time Picker Field
        AnimatedBuilder(
          animation: _animationController,
          builder: (context, child) {
            return Transform.scale(
              scale: _scaleAnimation.value,
              child: GestureDetector(
                onTap: widget.enabled
                    ? () => _showDateTimePicker(context)
                    : null,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 16,
                  ),
                  decoration: BoxDecoration(
                    color: widget.enabled
                        ? (isDark
                              ? AppColors.surfaceDark
                              : AppColors.surfaceLight)
                        : AppColors.grey100,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: _errorText != null
                          ? AppColors.error
                          : _borderColorAnimation.value ?? AppColors.grey300,
                      width: _isFocused ? 2 : 1,
                    ),
                    boxShadow: _isFocused
                        ? [
                            BoxShadow(
                              color:
                                  (widget.value != null
                                          ? AppColors.primary
                                          : AppColors.grey400)
                                      .withOpacity(0.1),
                              blurRadius: 8,
                              offset: const Offset(0, 2),
                            ),
                          ]
                        : null,
                  ),
                  child: Row(
                    children: [
                      // Calendar/Clock Icon
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color:
                              (widget.value != null
                                      ? AppColors.primary
                                      : AppColors.grey400)
                                  .withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Icon(
                          widget.mode == DateTimePickerMode.time
                              ? Icons.access_time_rounded
                              : Icons.calendar_today_rounded,
                          color: widget.value != null
                              ? AppColors.primary
                              : AppColors.grey500,
                          size: 20,
                        ),
                      ),
                      const SizedBox(width: 12),

                      // Value or Hint Text
                      Expanded(
                        child: AnimatedDefaultTextStyle(
                          duration: const Duration(milliseconds: 200),
                          style: widget.value != null
                              ? AppTextStyles.bodyMedium.copyWith(
                                  color: isDark
                                      ? AppColors.textDark
                                      : AppColors.textPrimary,
                                  fontWeight: FontWeight.w500,
                                )
                              : AppTextStyles.bodyMedium.copyWith(
                                  color: isDark
                                      ? AppColors.textSecondaryDark
                                      : AppColors.textSecondary,
                                ),
                          child: Text(
                            widget.value != null
                                ? _formatDateTime(widget.value!)
                                : widget.hint ?? 'Select date and time',
                          ),
                        ),
                      ),

                      // Arrow Icon
                      AnimatedRotation(
                        duration: const Duration(milliseconds: 200),
                        turns: _isFocused ? 0.5 : 0,
                        child: Icon(
                          Icons.keyboard_arrow_down_rounded,
                          color: isDark
                              ? AppColors.textSecondaryDark
                              : AppColors.textSecondary,
                          size: 24,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),

        // Error Text
        if (_errorText != null) ...[
          const SizedBox(height: 8),
          Row(
            children: [
              Icon(Icons.error_outline, color: AppColors.error, size: 16),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  _errorText!,
                  style: AppTextStyles.labelSmall.copyWith(
                    color: AppColors.error,
                  ),
                ),
              ),
            ],
          ),
        ],
      ],
    );
  }
}

// Enum for DateTimePicker modes
enum DateTimePickerMode { date, time, dateTime }
