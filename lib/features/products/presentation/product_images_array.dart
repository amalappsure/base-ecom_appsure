import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:base_ecom_appsure/features/app_settings/providers/app_config_provider.dart';
import 'package:base_ecom_appsure/features/products/models/product_details/item_image.dart';

class ProductImagesController {
  late GlobalKey Function() getCurrentKey;
}

class ProductImagesArray extends ConsumerStatefulWidget {
  const ProductImagesArray({
    super.key,
    required this.images,
    this.buttons = const [],
    required this.slidIcon,
    this.errorImagePath,
    required this.controller,
    required this.onImageClicked,
    this.onInteractionStart,
    this.onInteractionEnd,
  });

  final List<Widget> buttons;
  final Widget slidIcon;
  final List<ItemImage> images;
  final String? errorImagePath;
  final ProductImagesController controller;
  final ValueChanged<int> onImageClicked;
  final GestureScaleStartCallback? onInteractionStart;
  final GestureScaleEndCallback? onInteractionEnd;

  @override
  ConsumerState<ProductImagesArray> createState() => _ProductImagesArrayState();
}

class _ProductImagesArrayState extends ConsumerState<ProductImagesArray> {
  int _index = 0;

  late List<GlobalKey> _keys;

  GlobalKey getCurrentKey() {
    return _keys[_index];
  }

  AppConfig get appConfig => ref.read(appConfigProvider);

  @override
  void initState() {
    widget.controller.getCurrentKey = getCurrentKey;
    _keys = widget.images.map((e) => GlobalKey()).toList();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        AspectRatio(
          aspectRatio: 1,
          child: GestureDetector(
            onTap: () => widget.onImageClicked(_index),
            behavior: HitTestBehavior.opaque,
            child: Stack(
              children: [
                Positioned.fill(
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      return SizedBox(
                        height: constraints.maxWidth,
                        child: PageView.builder(
                          itemCount: widget.images.length,
                          onPageChanged: (value) => setState(() {
                            _index = value;
                          }),
                          scrollDirection: Axis.horizontal,
                          itemBuilder: (context, index) {
                            return CachedNetworkImage(
                              height: constraints.maxWidth,
                              width: constraints.maxWidth,
                              imageUrl:
                              widget.images[index].imagePathSmall ?? '',
                              errorWidget: (context, url, error) =>
                                  _imageContainer(
                                    context,
                                    widget.errorImagePath != null
                                        ? DecorationImage(
                                        image:
                                        AssetImage(widget.errorImagePath!))
                                        : null,
                                    globalKey: _keys[index],
                                  ),
                              imageBuilder: (context, imageProvider) =>
                                  _imageContainer(
                                    context,
                                    DecorationImage(image: imageProvider),
                                    globalKey: _keys[index],
                                  ),
                              progressIndicatorBuilder:
                                  (context, url, progress) => _imageContainer(
                                context,
                                null,
                              ),
                            );
                          },
                        ),
                      );
                    },
                  ),
                ),
                Positioned(
                  top: 20.0,
                  right: 24.0,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: widget.buttons,
                  ),
                ),
                Positioned(
                  bottom: 35.0,
                  right: 30.0,
                  child: SizedBox(
                    child: widget.slidIcon,
                  )
                )
              ],
            ),
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(
            widget.images.length,
                (index) => Container(
              margin: const EdgeInsets.all(8.0),
              height: 8.0,
              width: 8.0,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: _index == index
                    ? Theme.of(context).colorScheme.primary
                    : Theme.of(context).dividerColor.withOpacity(0.1),
              ),
            ),
          ),
        )
      ],
    );
  }

  Widget _imageContainer(
      BuildContext context,
      DecorationImage? decorationImage, {
        GlobalKey? globalKey,
      }) =>
      InteractiveViewer(
        scaleEnabled: appConfig.enableImageMagnificationInDetailPage,
        panEnabled: appConfig.enableImageMagnificationInDetailPage,
        onInteractionEnd: widget.onInteractionEnd,
        onInteractionStart: widget.onInteractionStart,
        child: Container(
          margin: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(18),
            border: Border.all(
              color: Theme.of(context).dividerColor.withOpacity(0.1),
              width: 1.5,
            ),
          ),
          child: decorationImage != null
              ? Container(
            key: globalKey,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(18),
                image: decorationImage,
              ),
            ),
          )
              : const Center(child: CircularProgressIndicator.adaptive()),
        ),
      );
}
