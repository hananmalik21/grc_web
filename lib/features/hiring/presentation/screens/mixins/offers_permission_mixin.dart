import 'package:grc/core/permissions/perm_keys.dart';
import 'package:grc/core/permissions/permission_service.dart';

mixin OffersPermissionMixin {
  bool get canViewOffers => PermissionService.instance.can(PermKeys.hiringOffersView);

  bool get canCreateOffer => PermissionService.instance.can(PermKeys.hiringOffersCreate);

  bool get canUpdateOffer => PermissionService.instance.can(PermKeys.hiringOffersUpdate);
}
