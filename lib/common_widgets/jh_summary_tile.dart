import 'package:flutter/material.dart';
import 'package:parental_control/common_widgets/jh_progress_bar.dart';
import 'package:parental_control/common_widgets/jh_size_config.dart';
import 'package:parental_control/theme/theme.dart';

import 'jh_display_text.dart';

class JHSummaryTile extends StatelessWidget {
  final String title;
  final String time;
  final double progressValue;
  const JHSummaryTile({
    Key? key,
    required this.title,
    required this.time,
    this.progressValue = 75,
  });

  @override
  Widget build(BuildContext context) {
    JHSizeConfig().init(context);
    return Container(
      margin: EdgeInsets.all(10),
      constraints: BoxConstraints(
        maxHeight: 170,
        minHeight: 150,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(5),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        children: [
          Row(
            children: [
              JHDisplayText(
                text: title,
                style: TextStyle(color: CustomColors.indigoPrimary),
              )
            ],
          ).p16,
          Row(
            children: [
              JHDisplayText(
                text: time,
                fontSize: 25,
                style: TextStyle(color: Colors.black),
              ),
            ],
          ).p4,
          JHCustomProgressBar(progress: progressValue / 100),
        ],
      ),
    );
  }
}
