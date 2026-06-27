import 'package:flutter/material.dart';
import 'package:grc/core/constants/app_colors.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart' show SpinKitCircle, SpinKitChasingDots, SpinKitFadingCircle, SpinKitThreeBounce, SpinKitWave, SpinKitDoubleBounce, SpinKitRing, SpinKitPulse;

enum LoadingType {
  fadingCircle,
  threeBounce,
  wave,
  doubleBounce,
  ring,
  circle,
  chasingDots,
  pulse,
}

class AppLoadingIndicator extends StatelessWidget {
  final LoadingType type;
  final Color? color;
  final double? size;

  const AppLoadingIndicator({
    super.key,
    this.type = LoadingType.fadingCircle,
    this.color,
    this.size,
  });

  @override
  Widget build(BuildContext context) {
    final effectiveColor = color ?? AppColors.primary;
    final effectiveSize = size ?? 40.r;

    switch (type) {
      case LoadingType.fadingCircle:
        return SpinKitFadingCircle(color: effectiveColor, size: effectiveSize);
      case LoadingType.threeBounce:
        return SpinKitThreeBounce(color: effectiveColor, size: effectiveSize);
      case LoadingType.wave:
        return SpinKitWave(color: effectiveColor, size: effectiveSize);
      case LoadingType.doubleBounce:
        return SpinKitDoubleBounce(color: effectiveColor, size: effectiveSize);
      case LoadingType.ring:
        return SpinKitRing(color: effectiveColor, size: effectiveSize);
      case LoadingType.circle:
        return SpinKitCircle(color: effectiveColor, size: effectiveSize);
      case LoadingType.chasingDots:
        return SpinKitChasingDots(color: effectiveColor, size: effectiveSize);
      case LoadingType.pulse:
        return SpinKitPulse(color: effectiveColor, size: effectiveSize);
    }
  }
}
