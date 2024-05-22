import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get_it/get_it.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:base_ecom_appsure/app_config/config.dart';
import 'package:base_ecom_appsure/features/app_settings/providers/app_config_provider.dart';
import 'package:base_ecom_appsure/foundation/utils.dart';

class WhatsAppLauncher extends ConsumerWidget {
  const WhatsAppLauncher({
    super.key,
    required this.itemName,
    required this.urlName,
    required this.unitId,
    this.size = 24.0,
  });

  final String itemName;
  final String urlName;
  final int unitId;
  final double size;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final appConfig = ref.read(appConfigProvider);
    if (!appConfig.enableWhatsappEnquiryItem) return const SizedBox.shrink();
    return GestureDetector(
      onTap: () {
        final rot = rot13(
          base64Encode(utf8.encode(json.encode({'keyword': unitId}))),
        );

        final number = appConfig.whatsappEnquiryNumber;

        final waUrl = GetIt.I.get<Config>().whatsappMessageUrl;

        final url =
            'https://wa.me/$number?text=I am interested on $itemName $waUrl/$urlName?enc=$rot';
        final uri = Uri.parse(url);

        launchUrl(uri);
      },
      child: SizedBox.square(
        dimension: size,
        child: SvgPicture.asset(
          'assets/svgs/whatsapp.svg',
          height: size,
          width: size,
          package: 'base_ecom_appsure',
        ),
      ),
    );
  }
}
