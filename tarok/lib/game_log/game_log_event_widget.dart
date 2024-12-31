import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stockskis/stockskis.dart' show GAMES;
import 'package:tarok/game_log/game_log_card_widget.dart';
import 'package:tarok/game_log/game_log_object.dart';

class GameLogEvent extends StatelessWidget {
  const GameLogEvent({
    super.key,
    required this.title,
    required this.subtitle,
    required this.log,
    required this.rightDisplay,
    required this.icon,
    this.showCards = true,
  });

  final String title;
  final String subtitle;
  final GameLog log;
  final int rightDisplay;
  final Icon icon;
  final bool showCards;

  @override
  Widget build(BuildContext context) {
    final fullWidth = MediaQuery.of(context).size.width;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                SizedBox(
                  width: (rightDisplay == 1 || rightDisplay == 3)
                      ? fullWidth * 0.3
                      : (rightDisplay == -1
                          ? fullWidth * 0.6
                          : fullWidth * 0.4),
                  child: ListTile(
                    leading: icon,
                    title: Text(title),
                    subtitle: Text(subtitle),
                    isThreeLine: true,
                  ),
                ),
                const Spacer(),
                if (rightDisplay == 0)
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      GAMES[log.action + 1].name.tr,
                      style: const TextStyle(
                        fontSize: 32,
                      ),
                    ),
                  ),
                if (rightDisplay == 3 || rightDisplay == 4)
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      "round_number"
                          .trParams({"roundNumber": log.action.toString()}),
                      style: const TextStyle(
                        fontSize: 32,
                      ),
                    ),
                  ),
                if (rightDisplay == 1 || rightDisplay == 3)
                  CardWidget(
                    cards: log.additionalData.isEmpty
                        ? [log.card]
                        : log.additionalData,
                  ),
                if (rightDisplay == 2)
                  CardWidget(
                    cards: log.card.split(";"),
                  ),
              ],
            ),
            if (log.userCards.isNotEmpty && showCards)
              const SizedBox(
                height: 10,
              ),
            if (log.userCards.isNotEmpty && showCards)
              CardWidget(cards: log.userCards),
          ],
        ),
      ),
    );
  }
}
