import 'package:flutter/material.dart';
import 'package:frontend_water_quality/core/enums/screen_size.dart';

class ButtonActions extends StatelessWidget {
  final String title;
  final List<Widget> actions;
  final ScreenSize screenSize;
  const ButtonActions(
      {super.key,
      required this.title,
      required this.actions,
      required this.screenSize});

  @override
  Widget build(BuildContext context) {
    Widget textTitle = Text(
      title,
      style: Theme.of(context)
          .primaryTextTheme
          .bodyLarge
          ?.copyWith(fontWeight: FontWeight.bold),
    );

    if (screenSize == ScreenSize.mobile || screenSize == ScreenSize.tablet) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 10,
        children: [
          textTitle,
          SizedBox(
            width: double.infinity,
            child: Wrap(
              alignment: WrapAlignment.spaceBetween,
              spacing: 2,
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
        textTitle,
        const Spacer(),
        ...actions,
      ],
    );
  }
}
