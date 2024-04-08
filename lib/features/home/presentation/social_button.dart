import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class SocialButton extends StatelessWidget {
  const SocialButton({
    super.key,
    required this.url,
    required this.child,
  });

  final String url;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      style: IconButton.styleFrom(
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        padding: EdgeInsets.zero,
        visualDensity: VisualDensity.compact,
      ),
      onPressed: () => launchUrl(Uri.parse(url)),
      icon: child,
    );
  }
}
