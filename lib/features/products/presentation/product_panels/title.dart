part of 'product_panels.dart';

abstract class PanelTitleBase extends ConsumerWidget {
  const PanelTitleBase({
    super.key,
    required this.panel,
    this.onPressed,
    this.translateTitle = false,
  });

  const factory PanelTitleBase.widget({
    Key? key,
    required ProductPanel panel,
    VoidCallback? onPressed,
    bool translateTitle,
  }) = _PanelTitle;

  final ProductPanel panel;
  final VoidCallback? onPressed;
  final bool translateTitle;
}

class _PanelTitle extends PanelTitleBase {
  const _PanelTitle({
    super.key,
    required super.panel,
    super.onPressed,
    super.translateTitle,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(settingsProvider);
    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: 12.0,
        horizontal: 16.0,
      ).copyWith(
        bottom: 6.0,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Flexible(
            child: Text(
              translateTitle
                  ? settings.selectedLocale!.translate(panel.title)
                  : panel.title,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontSize: 20.0,
                fontWeight: FontWeight.w600,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          if (onPressed != null)
            TextButton(
              onPressed: onPressed,
              style: TextButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(6),
                  side: BorderSide(
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
                padding: const EdgeInsets.symmetric(
                  vertical: 6.0,
                  horizontal: 12.0,
                ),
                backgroundColor: Colors.transparent,
                foregroundColor: Theme.of(context).colorScheme.primary,
                textStyle: Theme.of(context).textTheme.labelLarge,
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                visualDensity: VisualDensity.compact,
              ),
              child: Text(
                settings.selectedLocale!.translate('SeeAll'),
              ),
            )
        ],
      ),
    );
  }
}

class PanelTitleShimmer extends ConsumerWidget {
  const PanelTitleShimmer({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(settingsProvider);
    return CustomShimmer(
      child: Padding(
        padding: const EdgeInsets.symmetric(
          vertical: 12.0,
          horizontal: 16.0,
        ).copyWith(
          bottom: 6.0,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SizedBox(
              height: 26,
              width: MediaQuery.of(context).size.width * 0.6,
              child: const ShimmerContainer(),
            ),
            TextButton(
              onPressed: null,
              style: TextButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(6),
                ),
                padding: const EdgeInsets.symmetric(
                  vertical: 6.0,
                  horizontal: 12.0,
                ),
                backgroundColor: Colors.white,
                foregroundColor: const Color(0xFF959495),
                textStyle: Theme.of(context).textTheme.labelLarge,
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                visualDensity: VisualDensity.compact,
              ),
              child: Text(
                settings.selectedLocale!.translate('SeeAll'),
              ),
            )
          ],
        ),
      ),
    );
  }
}
