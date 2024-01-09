import 'package:flutter/material.dart';

class HugeSpacer extends StatelessWidget {
  const HugeSpacer({super.key});

  @override
  Widget build(BuildContext context) {
    if (MediaQuery.of(context).size.height >= 500) {
      return const SizedBox();
    }
    return SizedBox(
      height: MediaQuery.of(context).size.height / 3,
    );
  }
}
