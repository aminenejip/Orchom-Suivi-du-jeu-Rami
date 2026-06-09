import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_spacing.dart';
import '../theme/app_text_styles.dart';

class OrchomLoading extends StatelessWidget {
  final String? message;
  final double size;

  const OrchomLoading({
    super.key,
    this.message,
    this.size = 32,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: size,
            height: size,
            child: CircularProgressIndicator(
              strokeWidth: 3,
              color: isDark ? AppColors.primaryDark : AppColors.primary,
              strokeCap: StrokeCap.round,
            ),
          ),
          if (message != null) ...[
            const SizedBox(height: AppSpacing.md),
            Text(
              message!,
              style: AppTextStyles.bodySm.copyWith(
                color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ],
      ),
    );
  }
}

class OrchomSkeletonLoader extends StatefulWidget {
  final double width;
  final double height;
  final double borderRadius;

  const OrchomSkeletonLoader({
    super.key,
    this.width = double.infinity,
    required this.height,
    this.borderRadius = AppSpacing.radiusSm,
  });

  @override
  State<OrchomSkeletonLoader> createState() => _OrchomSkeletonLoaderState();
}

class _OrchomSkeletonLoaderState extends State<OrchomSkeletonLoader>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    )..repeat(reverse: true);
    _animation = Tween<double>(begin: 0.3, end: 0.7).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return AnimatedBuilder(
      animation: _animation,
      builder: (context, _) => Container(
        width: widget.width,
        height: widget.height,
        decoration: BoxDecoration(
          color: (isDark ? AppColors.shimmerBaseDark : AppColors.shimmerBaseLight)
              .withValues(alpha: _animation.value),
          borderRadius: BorderRadius.circular(widget.borderRadius),
        ),
      ),
    );
  }
}

class OrchomSkeletonCard extends StatefulWidget {
  final int lines;

  const OrchomSkeletonCard({super.key, this.lines = 3});

  @override
  State<OrchomSkeletonCard> createState() => _OrchomSkeletonCardState();
}

class _OrchomSkeletonCardState extends State<OrchomSkeletonCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    )..repeat(reverse: true);
    _animation = Tween<double>(begin: 0.3, end: 0.7).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return AnimatedBuilder(
      animation: _animation,
      builder: (context, _) {
        final color = (isDark ? AppColors.shimmerBaseDark : AppColors.shimmerBaseLight)
            .withValues(alpha: _animation.value);

        return Card(
          color: isDark ? AppColors.darkCard : AppColors.lightCard,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
            side: BorderSide(
              color: isDark ? AppColors.darkOutline.withValues(alpha: 0.3) : AppColors.lightOutline.withValues(alpha: 0.3),
            ),
          ),
          margin: const EdgeInsets.symmetric(
            horizontal: AppSpacing.md,
            vertical: AppSpacing.xs,
          ),
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.md),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _line(width: 120, height: 16, color: color),
                const SizedBox(height: AppSpacing.md),
                for (int i = 0; i < widget.lines; i++) ...[
                  _line(
                    width: i == widget.lines - 1 ? 180 : double.infinity,
                    height: 12,
                    color: color,
                  ),
                  if (i < widget.lines - 1) const SizedBox(height: AppSpacing.sm),
                ],
                const SizedBox(height: AppSpacing.md),
                _line(width: double.infinity, height: 48, color: color, radius: 12),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _line({
    required double width,
    required double height,
    required Color color,
    double radius = 4,
  }) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(radius),
      ),
    );
  }
}
