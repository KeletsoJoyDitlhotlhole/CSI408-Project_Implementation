import 'package:flutter/material.dart';
import 'package:medication_compliance_tool/utils/constants.dart';

class LogoSection extends StatelessWidget {
  const LogoSection({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isSmallScreen = screenWidth < 640;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          'MCT',
          style: AppStyles.logoStyle.copyWith(
            fontSize: isSmallScreen ? 36 : 48,
          ),
        ),
        const SizedBox(height: 10),
        Text(
          'MEDICATION COMPLIANCE TOOL',
          style: AppStyles.appNameStyle.copyWith(
            fontSize: isSmallScreen ? 14 : 16,
          ),
        ),
      ],
    );
  }
}
