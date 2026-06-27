import 'package:grc/features/employee_self_service/presentation/widgets/ess_icon_detail_line.dart';
import 'package:grc/features/employee_self_service/presentation/widgets/ess_surface_card.dart';
import 'package:grc/gen/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

class ContactDetailsCard extends StatelessWidget {
  final String emailAddress;
  final String mobileNumber;
  final String residentialAddress;

  const ContactDetailsCard({
    super.key,
    required this.emailAddress,
    required this.mobileNumber,
    required this.residentialAddress,
  });

  @override
  Widget build(BuildContext context) {
    return EssSurfaceCard(
      title: 'Contact Details',
      titleIconPath: Assets.icons.employeeManagement.mail.path,
      child: Column(
        children: [
          EssIconDetailLine(
            iconPath: Assets.icons.employeeManagement.mail.path,
            label: 'Email Address',
            value: emailAddress,
          ),
          Gap(14.h),
          EssIconDetailLine(
            iconPath: Assets.icons.leaveManagement.phone.path,
            label: 'Mobile Number',
            value: mobileNumber,
          ),
          Gap(14.h),
          EssIconDetailLine(
            iconPath: Assets.icons.locationSectionIcon.path,
            label: 'Residential Address',
            value: residentialAddress,
          ),
        ],
      ),
    );
  }
}
