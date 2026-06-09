import 'package:flutter/material.dart';
import '../theme/app_spacing.dart';
import '../theme/app_text_styles.dart';

class OrchomSearchBar extends StatefulWidget {
  final TextEditingController controller;
  final String hint;
  final ValueChanged<String>? onChanged;
  final VoidCallback? onClear;
  final bool autofocus;

  const OrchomSearchBar({
    super.key,
    required this.controller,
    this.hint = 'Rechercher...',
    this.onChanged,
    this.onClear,
    this.autofocus = false,
  });

  @override
  State<OrchomSearchBar> createState() => _OrchomSearchBarState();
}

class _OrchomSearchBarState extends State<OrchomSearchBar> {
  bool _showClear = false;

  @override
  void initState() {
    super.initState();
    widget.controller.addListener(_onListen);
    _showClear = widget.controller.text.isNotEmpty;
  }

  @override
  void dispose() {
    widget.controller.removeListener(_onListen);
    super.dispose();
  }

  void _onListen() {
    final hasText = widget.controller.text.isNotEmpty;
    if (hasText != _showClear) {
      setState(() => _showClear = hasText);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      decoration: BoxDecoration(
        color: isDark
            ? const Color(0xFF151B32)
            : const Color(0xFFF5F0EB),
        borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
        border: Border.all(
          color: isDark
              ? const Color(0xFF2D3561).withValues(alpha: 0.5)
              : const Color(0xFFD6D3D1).withValues(alpha: 0.5),
        ),
      ),
      child: TextField(
        controller: widget.controller,
        autofocus: widget.autofocus,
        onChanged: widget.onChanged,
        style: AppTextStyles.body.copyWith(
          color: isDark
              ? const Color(0xFFF1F0ED)
              : const Color(0xFF1C1917),
        ),
        decoration: InputDecoration(
          hintText: widget.hint,
          hintStyle: AppTextStyles.body.copyWith(
            color: isDark
                ? const Color(0xFF8B8FA3).withValues(alpha: 0.6)
                : const Color(0xFF78716C).withValues(alpha: 0.6),
          ),
          prefixIcon: Icon(
            Icons.search_rounded,
            color: isDark
                ? const Color(0xFF8B8FA3)
                : const Color(0xFF78716C),
            size: 22,
          ),
          suffixIcon: _showClear
              ? IconButton(
                  icon: Icon(
                    Icons.close_rounded,
                    color: isDark
                        ? const Color(0xFF8B8FA3)
                        : const Color(0xFF78716C),
                    size: 20,
                  ),
                  onPressed: () {
                    widget.controller.clear();
                    widget.onClear?.call();
                  },
                  splashRadius: 18,
                )
              : null,
          border: InputBorder.none,
          enabledBorder: InputBorder.none,
          focusedBorder: InputBorder.none,
          errorBorder: InputBorder.none,
          focusedErrorBorder: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.md,
            vertical: 14,
          ),
          isDense: true,
        ),
        textInputAction: TextInputAction.search,
        textCapitalization: TextCapitalization.sentences,
      ),
    );
  }
}
