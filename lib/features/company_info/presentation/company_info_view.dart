import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:webview_flutter/webview_flutter.dart';

import 'package:base_ecom_appsure/features/app_settings/providers/settings_provider.dart';
import 'package:base_ecom_appsure/features/company_info/models/company_info.dart';
import 'package:base_ecom_appsure/features/company_info/providers/company_info_provider.dart';

import 'package:base_ecom_appsure/widgets/custom_app_bar.dart';

class CompanyInfoView extends ConsumerStatefulWidget {
  const CompanyInfoView({
    super.key,
    required this.type,
    required this.appBarBuilder,
  });
  final InfoType type;
  final CustomAppBarBuilder appBarBuilder;

  @override
  ConsumerState<CompanyInfoView> createState() => _ConpanyInfoViewState();
}

class _ConpanyInfoViewState extends ConsumerState<CompanyInfoView> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback(
          (timeStamp) => getInfo(widget.type),
    );
    super.initState();
  }

  void getInfo(InfoType type) => ref.read(companyInfoProvider.notifier).getInfo(
    type,
  );

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(companyInfoProvider);

    ref.listen(settingsProvider, (prev, nex) {
      getInfo(widget.type);
    });

    return state.when<Widget>(
      onLoading: () => const Scaffold(
        body: Center(
          child: CircularProgressIndicator.adaptive(),
        ),
      ),
      onSuccess: (data) {
        if ((data.content ?? '').isEmpty) {
          return Scaffold(
            appBar: widget.appBarBuilder(
              data.title ?? '',
              false,
            ),
            body: const SizedBox.shrink(),
          );
        }

        final controller = WebViewController(
          onPermissionRequest: (request) {
            request.grant();
          },
        )..loadHtmlString(data.content ?? '');
        return Scaffold(
          appBar: widget.appBarBuilder(
            data.title ?? '',
            false,
          ),
          body: Padding(
            padding: const EdgeInsets.all(16),
            child: WebViewWidget(
              controller: controller,
            ),
          ),
        );
      },
      onError: (error) => const SizedBox.shrink(),
    );
  }
}
