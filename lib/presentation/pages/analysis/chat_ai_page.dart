import 'package:flutter/material.dart';
import 'package:frontend_water_quality/domain/models/analysis/average.dart';
import 'package:frontend_water_quality/presentation/widgets/common/atoms/base_container.dart';

class ChatAiPage extends StatelessWidget {
  final Average? average;
  const ChatAiPage({super.key, required this.average});

  @override
  Widget build(BuildContext context) {
    return BaseContainer(
      width: double.infinity,
      height: double.infinity,
      padding: EdgeInsets.all(10),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Spacer(),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            spacing: 10,
            children: [
              Expanded(
                child: TextField(
                  decoration: InputDecoration(
                    hintText: "Pregunta tus dudas",
                  ),
                ),
              ),
              IconButton(
                onPressed: () {},
                icon: Icon(Icons.send),
              ),
            ],
          )
        ],
      ),
    );
  }
}
