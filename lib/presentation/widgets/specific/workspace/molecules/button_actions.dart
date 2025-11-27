import 'package:flutter/material.dart';
import 'package:frontend_water_quality/core/enums/screen_size.dart';

class ButtonActions extends StatelessWidget {
  final Widget title;
  final List<Widget> actions;
  final ScreenSize screenSize;
  const ButtonActions(
      {super.key,
      required this.title,
      required this.actions,
      required this.screenSize});

  @override
  Widget build(BuildContext context) {
    if (screenSize == ScreenSize.mobile || screenSize == ScreenSize.tablet) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 10,
        children: [
          title,
          SizedBox(
            width: double.infinity,
            child: Wrap(
              alignment: WrapAlignment.end,
              crossAxisAlignment: WrapCrossAlignment.center,
              spacing: 5,
              runSpacing: 10,
              children: actions,
            ),
          ),
        ],
      );
    }

    return Row(
      spacing: 10,
      children: [
        title,
        const Spacer(),
        ...actions,
      ],
    );
  }
}
