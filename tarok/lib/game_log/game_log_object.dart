class GameLogTypes {
  static const int GAME_END = -1;
  static const int GAME_START = 0;
  static const int START_LICITATION = 1;
  static const int USER_LICITATED_SOMETHING = 2;
  static const int LICITATIONS_DONE = 3;
  static const int KING_SELECTION_STARTED = 4;
  static const int KING_SELECTED_KING_SELECTION_ENDED = 5;
  static const int TALON_OPEN = 6;
  static const int TALON_SELECTED = 7;
  static const int CARD_STASHING_STARTED = 8;
  static const int CARD_STASHED = 9;
  static const int CARD_STASHING_DONE = 10;
  static const int TALON_CLOSED = 11;
  static const int PREDICTIONS_STARTED = 12;
  static const int USER_PREDICTED = 13;
  static const int PREDICTIONS_DONE = 14;
  static const int CARD_GAME_STARTED = 15;
  static const int CARD_ROUND_STARTED = 16;
  static const int CARD_DROPPED = 17;
  static const int CARD_ROUND_DONE = 18;
  static const int RESULTS = 19;
}

class GameLog {
  /// [actionType] is one of [GameLogTypes].
  final int actionType;

  /// [userId] is a **unique** identifier of a user, meaning
  /// that no other player in the game can have this identifier
  final String userId;

  /// [userName] is not a unique identifier of a user, therefore
  /// it can be repeated, although it isn't optimal, as that's the name
  /// displayed to the viewer of the game log.
  final String userName;

  /// Is user one of the playing users?
  /// It doesn't matter if the user is secretly playing.
  /// If [userType] is 2 (system), this is always false.
  final bool isPlaying;

  /// [userType] is one of the following:
  /// - 0 = actual user
  /// - 1 = bot
  /// - 2 = system
  final int userType;

  /// [userCards] is used on following [actionType]s:
  /// - 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 16, 17
  final List<String> userCards;

  /// [action] is used on following [actionType]s:
  /// - [GameLogTypes.USER_LICITATED_SOMETHING] = what game has the user licitated
  /// - [GameLogTypes.LICITATIONS_DONE] = the highest licitation
  /// - [GameLogTypes.TALON_OPEN] = how many cards are in each selection
  /// - [GameLogTypes.TALON_SELECTED] = how many cards are in each selection
  /// - [GameLogTypes.CARD_ROUND_STARTED] = round number
  /// - [GameLogTypes.CARD_DROPPED] = round number
  /// - [GameLogTypes.CARD_ROUND_DONE] = round number
  ///
  /// When value is -1, it means it's not applicable
  final int action;

  /// [card] is used on following [actionType]s:
  /// - [GameLogTypes.KING_SELECTED_KING_SELECTION_ENDED] = which king was selected
  /// - [GameLogTypes.TALON_SELECTED] = which talon cards were selected (separated with ;)
  /// - [GameLogTypes.CARD_STASHED] = which card was stashed
  /// - [GameLogTypes.CARD_DROPPED] = which card was dropped
  final String card;

  /// [additionalData] is used on following [actionType]s:
  /// - [GameLogTypes.TALON_OPEN] = what's in the talon (as in cards)
  /// - [GameLogTypes.TALON_SELECTED] = which talon cards were available
  /// - [GameLogTypes.USER_PREDICTED] = what has the user predicted
  final List<String> additionalData;

  final int actionTime;

  GameLog.fromJson(Map<String, dynamic> json)
      : actionType = json['actionType'] as int,
        userId = json['userId'] as String,
        userName = json['userName'] as String,
        isPlaying = json['isPlaying'] as bool,
        userType = json['userType'] as int,
        userCards = List<String>.from(json['userCards'] as List),
        action = json['action'] as int,
        card = json['card'] as String,
        additionalData = List<String>.from(json['additionalData'] as List),
        actionTime = json['actionTime'] as int;

  Map<String, dynamic> toJson() => {
        'actionType': actionType,
        'userId': userId,
        'userName': userName,
        'isPlaying': isPlaying,
        'userType': userType,
        'userCards': userCards,
        'action': action,
        'card': card,
        'additionalData': additionalData,
        'actionTime': actionTime,
      };

  GameLog({
    required this.actionType,
    required this.userId,
    required this.userName,
    required this.isPlaying,
    required this.userType,
    required this.userCards,
    required this.action,
    required this.card,
    required this.additionalData,
    required this.actionTime,
  });
}
