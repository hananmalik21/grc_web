import 'package:grc/core/network/api_config.dart';
import 'package:grc/core/network/api_endpoints.dart';
import 'package:grc/core/services/toast_service.dart';
import 'package:grc/core/services/url_launch_service.dart';
import 'package:grc/features/hiring/domain/models/offer.dart';
import 'package:flutter/widgets.dart';

String jobOfferPdfUrl(String offerGuid) {
  final base = ApiConfig.baseUrl.endsWith('/')
      ? ApiConfig.baseUrl.substring(0, ApiConfig.baseUrl.length - 1)
      : ApiConfig.baseUrl;
  return '$base${ApiEndpoints.recJobOfferPdf(offerGuid)}';
}

Future<void> openJobOfferPdf(BuildContext context, Offer offer) async {
  final offerGuid = offer.offerGuid.trim();
  if (offerGuid.isEmpty) {
    ToastService.error(context, 'Offer identifier is missing');
    return;
  }

  final launched = await UrlLaunchService.launchInNewTab(jobOfferPdfUrl(offerGuid));
  if (!launched && context.mounted) {
    ToastService.error(context, 'Unable to open offer PDF.');
  }
}
