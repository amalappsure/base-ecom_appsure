import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import 'package:base_ecom_appsure/features/products/models/product_details/item_image.dart';

class ProductZoomBS extends StatefulWidget {
  const ProductZoomBS({
    super.key,
    required this.images,
    this.initialIndex = 0,
    this.errorImagePath,
  });

  final List<ItemImage> images;
  final int initialIndex;
  final String? errorImagePath;

  @override
  State<ProductZoomBS> createState() => _ProductZoomBSState();
}

class _ProductZoomBSState extends State<ProductZoomBS> {
  late PageController pageController;
  late int currentPage;
  @override
  void initState() {
    pageController = PageController(initialPage: widget.initialIndex);
    currentPage = widget.initialIndex;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: const BorderRadius.only(
        topLeft: Radius.circular(12),
        topRight: Radius.circular(12),
      ),
      child: SizedBox(
        height: MediaQuery.of(context).size.height * 0.8,
        child: Scaffold(
          body: Stack(
            children: [
              Positioned.fill(
                child: PageView.builder(
                  itemCount: widget.images.length,
                  controller: pageController,
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (context, index) {
                    return CachedNetworkImage(
                      height: MediaQuery.of(context).size.height,
                      width: MediaQuery.of(context).size.width,
                      imageUrl: widget.images[index].imagePathSmall ?? '',
                      errorWidget: (context, url, error) => _imageContainer(
                        context,
                        widget.errorImagePath == null
                            ? null
                            : DecorationImage(
                          image: AssetImage(widget.errorImagePath!),
                        ),
                      ),
                      imageBuilder: (context, imageProvider) =>
                          InteractiveViewer(
                            minScale: 1.0,
                            maxScale: 5.0,
                            child: _imageContainer(
                              context,
                              DecorationImage(image: imageProvider),
                            ),
                          ),
                      progressIndicatorBuilder: (context, url, progress) =>
                          _imageContainer(
                            context,
                            null,
                          ),
                    );
                  },
                  onPageChanged: (value) => setState(() => currentPage = value),
                ),
              ),
              Positioned(
                top: 0,
                right: 0,
                child: IconButton(
                  onPressed: () => Navigator.of(context).pop(),
                  icon: const Icon(Icons.close),
                ),
              )
            ],
          ),
          bottomNavigationBar: SizedBox(
            height: MediaQuery.of(context).size.height * 0.14,
            width: MediaQuery.of(context).size.width,
            child: Theme(
              data: Theme.of(context).copyWith(
                splashColor: Colors.transparent,
                highlightColor: Colors.transparent,
                scrollbarTheme: ScrollbarThemeData(
                  thumbColor: MaterialStatePropertyAll(
                    Theme.of(context).colorScheme.primary,
                  ),
                  trackColor: MaterialStatePropertyAll(
                    Theme.of(context).colorScheme.tertiary,
                  ),
                ),
              ),
              child: Scrollbar(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(8),
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: List.generate(
                      widget.images.length,
                          (index) => GestureDetector(
                        onTap: () {
                          pageController.animateToPage(
                            index,
                            duration: const Duration(milliseconds: 500),
                            curve: Curves.ease,
                          );
                        },
                        child: Container(
                          width: MediaQuery.of(context).size.width * 0.2,
                          margin: const EdgeInsets.symmetric(horizontal: 6),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: (currentPage == index)
                                  ? Theme.of(context).primaryColor
                                  : Theme.of(context)
                                  .dividerColor
                                  .withOpacity(0.3),
                            ),
                            image: DecorationImage(
                              image: CachedNetworkImageProvider(
                                widget.images[index].imagePathSmall ?? '',
                              ),
                              fit: BoxFit.contain,
                            ),
                          ),
                        ),
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

  Container _imageContainer(
      BuildContext context,
      DecorationImage? decorationImage,
      ) =>
      Container(
        margin: const EdgeInsets.all(16),
        child: decorationImage != null
            ? Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(18),
            image: decorationImage,
          ),
        )
            : const Center(child: CircularProgressIndicator.adaptive()),
      );
}
