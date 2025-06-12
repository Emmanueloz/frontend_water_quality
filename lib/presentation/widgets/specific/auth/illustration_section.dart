import 'package:flutter/material.dart';

class IllustrationSection extends StatelessWidget {
  const IllustrationSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: const BoxDecoration(
        color: Color(0xFFEAEAEA),
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(16),
          bottomRight: Radius.circular(16),
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset('../../../assets/images/agua.png',
              width: 500, height: 500),
          SizedBox(height: 20),
        ],
      ),
    );
  }
}
