import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:base_ecom_appsure/features/app_settings/providers/app_config_provider.dart';
import 'package:base_ecom_appsure/features/home/providers/home_provider.dart';
import 'package:base_ecom_appsure/foundation/refresh_controller.dart';
import 'package:base_ecom_appsure/themes/shadows.dart';
import 'package:base_ecom_appsure/widgets/responsive_builder.dart';
import 'package:base_ecom_appsure/widgets/shimmer.dart';

typedef OnBannerTap = void Function(String? value, String? type);

abstract class BannersBase extends ConsumerStatefulWidget {
  const BannersBase({
    super.key,
    required this.refreshController,
    this.errorImage,
    required this.onBannerTap,
  });

  const factory BannersBase.widget({
    required RefreshController refreshController,
    DecorationImage? errorImage,
    required OnBannerTap onBannerTap,
  }) = _Banners;

  final RefreshController refreshController;
  final DecorationImage? errorImage;
  final OnBannerTap onBannerTap;

  @override
  BannersBaseState<BannersBase> createState();
}

abstract class BannersBaseState<T extends BannersBase>
    extends ConsumerState<T> {
  void refresh();
}

class _Banners extends BannersBase {
  const _Banners({
    required super.refreshController,
    super.errorImage,
    required super.onBannerTap,
  });

  @override
  BannersBaseState<_Banners> createState() => _BannersState();
}

class _BannersState extends BannersBaseState<_Banners> {
  final _carouselController = CarouselController();
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback(
          (timeStamp) => refresh(),
    );
    widget.refreshController.refresh = refresh;
    super.initState();
  }

  @override
  void refresh() => ref.read(homeProvider).getBanners();

  @override
  Widget build(BuildContext context) {
    final banners = ref.watch(bannersProvider);
    final isRtl = Directionality.of(context) == TextDirection.rtl;
    return banners.when(
      onLoading: () => CarouselSlider(
        items: List.generate(
          1,
              (index) => CustomShimmer(child: Container(color: Colors.white)),
        ),
        options: _options(context),
      ),
      onSuccess: (data) {
        if (data.isEmpty) {
          return const SizedBox.shrink();
        }
        return DecoratedBox(
          decoration: BoxDecoration(
            boxShadow: ref.read(appConfigProvider).enableBannerShading
                ? [shadow2]
                : [],
          ),
          child: Stack(
            children: [
              CarouselSlider(
                carouselController: _carouselController,
                items: data
                    .map(
                      (e) => GestureDetector(
                    onTap: () =>
                        widget.onBannerTap(e.linkToValue, e.linkToType),
                    child: CachedNetworkImage(
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height * 0.25,
                      imageUrl: Responsive.valueWhen(
                        context: context,
                        mobile: e.imagePath1,
                        desktop: e.imagePath,
                      ),
                      imageBuilder: (context, imageProvider) => _container(
                        DecorationImage(
                          image: imageProvider,
                          fit: BoxFit.cover,
                        ),
                      ),
                      errorWidget: (context, url, error) => _container(
                        widget.errorImage,
                      ),
                    ),
                  ),
                )
                    .toList(),
                options: _options(context),
              ),
              Positioned(
                top: 0,
                bottom: 0,
                left: isRtl ? null : 4,
                right: isRtl ? 4 : null,
                child: Center(
                  child: IconButton(
                    onPressed: () => _carouselController.previousPage(),
                    icon: Icon(
                      Icons.arrow_back_ios_rounded,
                      size: 24,
                      color: Colors.white.withOpacity(0.8),
                    ),
                  ),
                ),
              ),
              Positioned(
                top: 0,
                bottom: 0,
                right: isRtl ? null : 4,
                left: isRtl ? 4 : null,
                child: Center(
                  child: IconButton(
                    onPressed: () => _carouselController.nextPage(),
                    icon: Icon(
                      Icons.arrow_forward_ios_rounded,
                      size: 24,
                      color: Colors.white.withOpacity(0.8),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
      onError: (error) => const SizedBox.shrink(),
    );
  }

  CarouselOptions _options(BuildContext context) {
    return CarouselOptions(
      autoPlay: true,
      aspectRatio: Responsive.valueWhen(
        context: context,
        mobile: 1061 / 300,
        desktop: 1601 / 350,
      ),
      viewportFraction: 1,
    );
  }

  Container _container(DecorationImage? image) => Container(
    foregroundDecoration: const BoxDecoration(
      gradient: LinearGradient(
        begin: Alignment.centerLeft,
        end: Alignment.centerRight,
        colors: [
          Color(0x33000000),
          Color(0x0D000000),
          Color(0x0D000000),
          Color(0x33000000),
        ],
      ),
    ),
    decoration: BoxDecoration(
      image: image,
    ),
  );
}
