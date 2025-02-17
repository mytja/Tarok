// Tarok Palčka - a simple tarock program.
// Copyright (C) 2023 Mitja Ševerkar
//
// This program is free software: you can redistribute it and/or modify
// it under the terms of the GNU Affero General Public License as published by
// the Free Software Foundation, either version 3 of the License, or any later version.
//
// This program is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
// GNU Affero General Public License for more details.
//
// You should have received a copy of the GNU Affero General Public License
// along with this program. If not, see <https://www.gnu.org/licenses/>.

import 'package:get/get.dart';

class Messages extends Translations {
  @override
  Map<String, Map<String, String>> get keys => {
        "en_US": {
          "login": "Login",
          "email": "Email address",
          "password": "Password",
          "registration": "Registration",
          "guest_access": "Offline with bots",
          "official_discord": "An official Discord server",
          "source_code": "Source code",
          "palcka": "Palčka",
          "profile_name": "Profile name (shown in game)",
          "repeat_password": "Repeat the password",
          "register": "Register",
          "account_login_403": "Trouble logging into your account",
          "account_login_403_desc":
              "Your account wasn't activated yet or the administrator has locked/disabled it.",
          "account_login_202_error": "The account is waiting for activation",
          "account_login_202_error_desc":
              "You should receive an activation email to your specified email address. Had it not been sent, try again later. You may resend activation emails every 5 minutes.",
          "account_login_unknown_error": "Unknown error while logging in",
          "account_login_unknown_error_desc":
              "Please recheck your login credentials. Had you recently sent an activation email, but not received it, you may resend it in 5 minutes.",
          "password_mismatch": "Passwords don't match",
          "ok": "OK",
          "registration_success":
              "Registration was successful. You should receive an e-mail with a registration code to your specified e-mail account. Until you verify your e-mail, you won't be able to log into your account.",
          "refresh_data": "Refresh the data",
          "user_id": "User ID",
          "name": "Name",
          "played_games": "Played online games",
          "role": "Role",
          "account_disabled": "Disabled account",
          "verified_email": "Verified e-mail address",
          "registered_on": "Registered on",
          "change_user_name": "Change user's name",
          "user_current_name": "User's current name is @name.",
          "cancel": "Cancel",
          "change": "Change",
          "admin_to_user": "Demote to user",
          "user_to_admin": "Promote to administrator",
          "settings": "Settings",
          "appearance": "Appearance",
          "dark_mode": "Dark mode",
          "use_dark_mode": "Use dark mode",
          "sound": "Sound",
          "sound_effects": "Sound effects",
          "sound_effects_desc": "Enable sound effects",
          "modifications": "Modifications",
          "modifications_desc":
              "If you're in a need for a challenge, you may modify below options.",
          "stockskis_recommendations": "StockŠkis recommendations",
          "stockskis_recommendations_desc":
              "StockŠkis recommends you games when licitating. If you turn this option off, you won't receive any recommendations.",
          "predicted_mondfang": "Predicted capture of Mond",
          "predicted_mondfang_desc": "Capture of Mond can be predicted.",
          "blind_tarock": "Blind tarock",
          "blind_tarock_desc":
              "You won't be able to see any tricks. Applies only to offline (bot) games.",
          "skisfang": "Capture of Škis",
          "skisfang_desc":
              "-100 for a captured Škis. Applies only to offline (bot) games.",
          "autoconfirm_stash": "Autoconfirm stashed cards",
          "autoconfirm_stash_desc":
              "Autoconfirms stashed cards. Enable this only if you know what you're doing and cannot misclick.",
          "autogreet": "Automatically send a greeting",
          "autogreet_desc":
              "Automatically sends a greeting upon game start and every reconnect.",
          "premove": "Premove",
          "premove_desc": "Premove a card",
          "developer_options": "Developer options",
          "developer_options_desc":
              "These options are mostly meant for use by the developers of Palčka tarock program. Perhaps, some people might take them for fun or as a challenge and that's why they are left here for everyone :). These options only work on local games with bots. Some settings are incompatible between each other.",
          "developer_mode": "Developer mode",
          "developer_mode_desc": "Enables additional developer/debug menus",
          "falsify_game": "Falsify the game",
          "falsify_game_desc":
              "Your hand might contain a bunch of high tarocks. Sounds great for a valat ;).",
          "guaranteed_zaruf": "Guaranteed zaruf",
          "guaranteed_zaruf_desc":
              "How come that all the kings are in talon? What a strange coincidence.",
          "mond_in_talon": "Mond in talon",
          "mond_in_talon_desc": "Here comes one minor problem ...",
          "skis_in_talon": "Škis in talon",
          "skis_in_talon_desc":
              "Perhaps a Škis might (always) be in talon ... I don't know anything about that.",
          "open_games": "Open games",
          "open_games_desc":
              "I may or may not have peeked into others' hands, nothing too serious...",
          "color_valat": "Color valat",
          "color_valat_desc": "Color valat, but just a little bit rigged.",
          "beggar": "Beggar",
          "beggar_desc": "Just the right cards for beggar",
          "autostart_next_game": "Autostart next game",
          "autostart_next_game_desc":
              "If this option is turned off, we can only play a single game...",
          "no_kontra": "No kontra",
          "kontra": "Kontra",
          "rekontra": "Rekontra",
          "subkontra": "Subkontra",
          "mortkontra": "Mortkontra",
          "normal_bots": "Normal bots",
          "advanced_bots": "Advanced bots",
          "beggar_bots": "Beggar bots",
          "klop_bots": "Klop bots",
          "tarock_palcka": "Tarock Palčka",
          "copyright": "Copyright 2023 Mitja Ševerkar",
          "licensed_under": "Licensed under AGPLv3 license.",
          "version": "Version @version",
          "name_change": "Change of name",
          "change_of_name_desc1":
              "Change of name may be made free of charge and is available to everybody.",
          "change_of_name_desc2":
              "In case of an inappropriate name, administrators shall change the name and user's account might get locked after multiple violations.",
          "change_of_name_desc3": "Your current name is: @name",
          "change_of_email": "Change of e-mail address",
          "change_of_email_desc":
              "Due to possible account abuse, we do not offer e-mail address change directly from the application. Please contact the developers at info@palcka.si or on Discord (@mytja).",
          "number_of_played_games": "Number of played games: ",
          "user_profile_registered": "User profile registered on: ",
          "role_in_system": "Role in the system: ",
          "change_of_password": "Change of password",
          "change_of_password_desc1":
              "Pick a strong password. The application will log you out of your account due to security reasons.",
          "change_of_password_desc2":
              "In case nothing happens on click of the Change button, you might have misspelled your old password or new passwords.",
          "old_password": "Old password",
          "new_password": "New password",
          "confirm_new_password": "Confirm new password",
          "home": "Home",
          "friends": "Friends",
          "replays": "Game replays",
          "discord": "Discord server",
          "users": "Users",
          "profile": "User profile",
          "logout": "Logout",
          "my_friends": "My friends",
          "incoming_friend_requests": "Incoming friend requests",
          "outgoing_friend_requests": "Outgoing friend requests",
          "invite": "Invite",
          "add_friend": "Add a friend",
          "player": "Player",
          "new_game": "Create a new game",
          "welcome_message": "Welcome to Palčka tarock program.",
          "using_guest_access": "You're using offline access",
          "games_available": "Games available",
          "with_players": "With players",
          "in_three": "In three",
          "in_four": "In four",
          "chatroom": "Chatroom",
          "with_bots": "With bots",
          "replay_desc": "Here you can enter the URL to a game replay",
          "replay_link": "Replay link",
          "replay": "Game replay",
          "modify_bots": "Modify bots",
          "modify_bots_desc":
              "Here you can edit what kinds of bots you want to play with in your games. The app will randomly pick bots from this list upon entering the game, if there are at least as many players as required for the game.",
          "bot": "Bot",
          "remove": "Remove",
          "bot_name": "Bot name",
          "add_bot": "Add the bot to the list",
          "finish_list_editing": "Finish editing",
          "discord_desc":
              "The official Discord server contains the official forum as well as a community of tarock players.",
          "game": "Game @type",
          "mondfang_radelci": "Radelci on Mond capture",
          "join_game": "Join the game",
          "watch_replay": "Watch the replay",
          "seconds_per_move": "Additional seconds per move",
          "start_time": "Starting time (in seconds)",
          "number_games": "Number of games",
          "private_game": "Private game",
          "friend_handle": "Friend's handle",
          "add": "Add",
          "debugging": "Debugging",
          "first_card": "First card: @card",
          "trick": "Trick: @trick",
          "selected_king": "Selected king: @king",
          "player_with_king": "Player with the king: @player",
          "stashed_cards": "Stashed cards: @stashed",
          "picked_talon": "Picked talon: @talon",
          "reevaluate_cards": "Reevaluate cards",
          "invite_friend": "Invite a friend",
          "invite_friends": "Invite friends",
          "start_game": "Start the game",
          "stashed_tarocks": "Stashed tarocks:",
          "trula": "Trula",
          "kings": "Kings",
          "pagat_ultimo": "Pagat ultimo",
          "king_ultimo": "King ultimo",
          "mondfang": "Capture of Mond",
          "valat": "Valat",
          "show_talon": "Show talon",
          "hide_talon": "Hide talon",
          "predict": "Predict",
          "playing_in": "@player is playing in @color.",
          "piku": "spades",
          "srcu": "hearts",
          "križu": "clubs",
          "kari": "diamonds",
          "zaruf":
              "It looks like a zaruf. If you take the king, you get the remainder of talon and in case of Mond being inside, your mond doesn't get captured.",
          "stashing_cards": "You're currently stashing the following cards.",
          "confirm": "Confirm",
          "change_card_selection": "Change card selection",
          "immediately_onward": "Immediately onwards",
          "prediction": "Prediction",
          "result": "Result",
          "predicted_by": "Predicted by",
          "kontra_by": "Kontra given by",
          "game_simple": "Game",
          "difference": "Difference",
          "total": "Total",
          "num_additional_rounds": "Number of additional rounds",
          "hide_point_count_by_tricks": "Hide point count by tricks",
          "show_point_count_by_tricks": "Show point count by tricks",
          "picked_up_cards": "Picked up cards:",
          "stashed": "Stashed",
          "talon": "Talon",
          "trick_nr": "Trick number @number",
          "točk": "points",
          "točko": "point",
          "točki": "points",
          "točke": "points",
          "trick_is_worth": "Trick is worth @points @ptext.",
          "trick_picked_up_by": "Trick was picked up by @player",
          "close_results": "Close results overview",
          "thanks_game": "Thanks for the game",
          "rating": "Rating",
          "leave_game": "Leave the game",
          "account_confirmed": "User profile has been successfully confirmed.",
          "account_not_confirmed":
              "User profile hasn't been confirmed or is already confirmed.",
          "customize_bots": "Customize bots",
          "language": "Language",
          "onward": "Onward",
          "three": "Three",
          "two": "Two",
          "one": "One",
          "solo_three": "Solo three",
          "solo_two": "Solo two",
          "solo_one": "Solo one",
          "solo_without": "Solo without",
          "open_beggar": "Open beggar",
          "klop": "Klop",
          "password_reset": "Password reset",
          "password_reset_request": "Request a password reset link",
          "password_reset_success": "Password reset",
          "password_reset_success_desc":
              "In case of entering the correct e-mail address, you should've received an e-mail containing the link to reset your password.",
          "password_reset_change_success": "Password reset successful",
          "password_reset_change_success_desc":
              "Your password was successfully changed.",
          "password_reset_change_failure": "Password reset failure",
          "password_reset_change_failure_desc":
              "Your password was NOT successfully changed. Please retry the procedure or contact the developers to check what's going on.",
          "password_reset_procedure":
              "This procedure will sign you out of all your devices",
          "password_reset_change": "Change your password",
          "tos": "Terms of service",
          "other": "Other settings",
          "discord_rpc": "Enable Discord RPC",
          "enable_discord_rpc":
              "Enables Discord Rich Presence. Your in-game status will be shown on your profile.",
          "talon_picked": "Picked talon: @talon",
          "tournaments": "Tournaments",
          "modify_game": "Modify your game",
          "new_tournament": "New tournament",
          "select_start": "Select the start of the tournament",
          "division": "Divison",
          "create_new_tournament": "Create new tournament",
          "start_at": "Start of the tournament",
          "show_participants": "Show registered contestants",
          "edit_rounds": "Edit rounds",
          "edit_tournament": "Edit tournament",
          "invite_tournament_singular":
              "@who is inviting you to the official Palčka tournament ",
          "invite_tournament_dual":
              "@who are inviting you to the official Palčka tournament ",
          "invite_tournament_plural":
              "@who are inviting you to the official Palčka tournament ",
          "tournament_rated":
              "Tournament is@israted counting towards your rating.",
          "not_space": " not",
          "participants": "Participants",
          "participation_id": "Unique identification of participation",
          "rated": "Rated",
          "delta": "Rating delta",
          "points": "In-game points",
          "past_tournaments": "Past tournaments",
          "new_round": "New round",
          "time_per_round": "Time per round",
          "create_new_round": "Create new round",
          "round": "round",
          "person_1": "Person 1",
          "person_2": "Person 2",
          "person_3": "Person 3",
          "person_4": "Person 4",
          "clear_round_cards": "Clean all cards in this round",
          "reshuffle_cards": "Reshuffle cards",
          "rounds": "Rounds",
          "delete_round": "Delete a round",
          "tournament_continue_soon":
              "Tournament is continuing soon. Please, stand by.",
          "tournament_ending":
              "Tournament is ending, the rating is being calculated. The game will end soon, as you'll receive the rating change. Thank you so much for your participation.",
          "handle": "Handle (shown to other people)",
          "tos_text":
              "By registering, you agree to our Terms of Service (you may read using the button below Registration). Should you not create an account, you may use the Offline access.",
          "handle_change": "Change of handle",
          "change_of_handle_desc1":
              "Change of handle is available free of charge.",
          "change_of_handle_desc2":
              "In case of an inappropriate handle, administrators shall change the handle and user's account might get locked after multiple violations.",
          "handle_desc":
              "Handle is unique and identifies you to other users. Allowed are all symbols of the English alphabet, numerals and hyphen (-), dot (.) as well as underscore (_).",
          "change_of_handle_desc4": "Your current handle is: @name",
          "user_current_handle": "User's current handle is @name.",
          "speed": "Speed of bots",
          "all_values_in_seconds": "All values are given in seconds.",
          "next_round_speed": "Delay between rounds",
          "general_bot_delay": "General bot delay",
          "card_cleanup_delay": "Trick cleanup delay",
          "current_rating": "Current player rating: ",
          "edit_testers": "Edit testers",
          "testers": "Testers",
          "invite_tournament_singular_private":
              "@who is inviting you as a tester to the official Palčka tournament ",
          "invite_tournament_dual_private":
              "@who are inviting you as a tester to the official Palčka tournament ",
          "invite_tournament_plural_private":
              "@who are inviting you as a tester to the official Palčka tournament ",
          "invite_tournament_rated_private":
              "Tournament doesn't count towards your rating as a tester. In case you want it to count and you haven't seen the cards, contact the administrator.",
          "start_tournament_testing": "Start tournament testing",
          "tournament_testing_description":
              "Thank you so much for participating in tournament testing. Before you start testing, here are some general instructions.\nYou are testing for @division. division.\nFirst division has the toughest hands, participants have to make tough decisions, which can be risky, and not always rewarding.\nSecond division contains hard hands, it's more appropriate for experienced players, participants have to make tough decisions, which may be very risky, but in most cases rewarding (risky play includes the game of beggar, open beggar, color valat, valat etc.)\nThird division is meant for beginners, commonly there are no tough decisions to be made, hands are often very clear and no risky gameplay should be included most of the time and whenever it is, it's in 90% rewarding.\nFourth division is meant for absolute beginners. Cards are mostly set up that the player has clear decisions to be done between different licitated games, risky gameplay/moves are always rewarded if included.\nIn third and fourth division, we're trying to avoid valat and color valat.\nBy testing the tournament, you give up the participation in the rated tournament (you may still participate as unrated, but consequently won't receive any rating).\nBy clicking the button Start, a new room will be created, available only to you.\nYou may join the game whenever until the virtual (test) tournament ends.\nGame starts within one minute of clicking the Start button.\nEnjoy the testing :).",
          "start": "Start",
          "tournament_testing": "Tournament testing",
          "open_settings": "Open settings",
          "edit_round": "Edit round",
          "cards": "Cards",
          "diamonds": "Diamonds",
          "cards_guide_desc":
              "Below, you can find all the cards. These are sorted by how many cards they beat in-game (king beats the queen, queen beats the knight etc.). In-game worth for kings and trula is 5, 4 for the queens, 3 for the knights, 2 for tje jacks and 1 for all other cards.",
          "guide": "Guide",
          "spades": "Spades",
          "hearts": "Hearts",
          "clubs": "Clubs",
          "tarocks": "Tarocks",
          "tarocks_desc":
              "Tarocks are special cards, which may take over any color. In case more tarocks fall in the same deck, the highest one picks the deck. All tarocks are numbered, except for Škis, which is known also for being a tarock 22, as it beats all other tarocks. All tarocks are named by their numerical value, except for first (Pagat, Palica or Palčka), 21st (Mond) and 22nd (Škis). These three tarocks together represent the trula.",
          "general_card_play_rules": "General card gameplay rules",
          "card_play_rules":
              "In all games, the starting player may start with anything, may that be a tarock or a color. In case of a start with a color, other players must comply and throw the same suit (color). In case the player doesn't have the same suit, a tarock may be thrown. In case the player doesn't have a tarock, any other card can be thrown. Rules are similar if the player starts with a tarock. In case you have a tarock, you need to throw a tarock, else any other card is fine. Use of Pagat (Palčka) in beggar, open beggar and klop is restricted as a last tarock. First deck of the game is started by the mandatory player, if game doesn't suggest otherwise.",
          "licitation": "Licitation",
          "licitation_desc":
              "Every game starts with licitation. In this process, you tell other players what game you want to play, if any. If you haven't received cards appropriate for any of the available games, click onwards. Below are listed all games, from least to most worth (with an exception of klop). In case two players want to play the same game, only the mandatory player has the advantage and can override the game (mandatory player is the last player to licitate). Most games require the active team (person who licitated and teammate if there's one) to pick up at least 36 points. In case of such a game, the difference also counts towards the total sum, which is calculated by the formula (number of picked points of the active team - 35).",
          "three_only_mand": "Three (only the mandatory player)",
          "three_gameplay":
              "In game three, the talon is divided into two smaller decks, each three cards in size. Pick any of the smaller decks and stash three cards. In game with four players, you have the right to pick a teammate. The game is worth 10 points.",
          "two_gameplay":
              "In game two, the talon is divided into three smaller decks, each two cards in size. Pick any of the smaller decks and stash two cards. V igri s štirimi igralci imate pravico do izbire soigralca. The game is worth 20 points.",
          "one_gameplay":
              "In game one, the talon is divided into six smaller decks, each one card in size. Pick any of the smaller decks and stash one card. V igri s štirimi igralci imate pravico do izbire soigralca. The game is worth 30 points.",
          "solo_three_only_four": "Solo three (only in game with four players)",
          "solo_three_gameplay":
              "In game solo three, the talon is divided into two smaller decks, each three cards in size. Pick any of the smaller decks and stash three cards. You do not have the right to pick the teammate. From this game, you may call/predict color valat. The game is worth 40 points.",
          "solo_two_only_four": "Solo two (only in game with four players)",
          "solo_two_gameplay":
              "In game solo two, the talon is divided into three smaller decks, each two cards in size. Pick any of the smaller decks and stash two cards. You do not have the right to pick the teammate. From this game, you may call/predict color valat. The game is worth 50 points.",
          "solo_one_only_four": "Solo one (only in game with four players)",
          "solo_one_gameplay":
              "In game solo one, the talon is divided into six smaller decks, each one card in size. Pick any of the smaller decks and stash one card. You do not have the right to pick the teammate. From this game, you may call/predict color valat. The game is worth 60 points.",
          "beggar_gameplay":
              "In game beggar you do not see the talon up until the game end. There are no predictions, except for kontra. With this game, you predict, that you won't pick up any deck during the duration of the whole game. If you pick a deck, the game ends early with a negative result. First deck of the game is started by you, as the playing player. The game is worth 70 points.",
          "solo_without_gameplay":
              "In game solo without you do not see the talon up until the game end. There are no predictions, except for kontra. With this game, you predict that you'll pick up at least 36 points. The game is worth 80 points, the difference doesn't count towards the game.",
          "open_beggar_gameplay":
              "Open beggar is essentially the same game as beggar with an exception of needing to show all your cards (as the playing player) to opponents during the entire game. First deck of the game is started by you, as the playing player. The game is worth 90 points.",
          "color_valat_only_four":
              "Color valat (only in game with four players)",
          "color_valat_gameplay":
              "In game color valat you do not see the talon up until the game end (except if the valat was called as a prediction from another game). There are no predictions, except for kontra. With this game, you bind yourself to pick up all the decks. As soon as you don't pick one, the game ends early with a negative outcome. All decks are started by you, as the playing player. Talon belongs to you. Color valat also turns around the usual tarock rules as colors are worth more than tarocks (colors pick up tarocks). The game is worth 125 points, the difference doesn't count towards the game.",
          "valat_gameplay":
              "In game valat you do not see the talon up until the game end (except if the valat was called as a prediction from another game). There are no predictions, except for kontra. With this game, you bind yourself to pick up all the decks. As soon as you don't pick one, the game ends early with a negative outcome. All decks are started by you, as the playing player. Talon belongs to you. The game is worth 500 points (if made without a prediction, only 250), the difference doesn't count towards the game.",
          "klop_gameplay":
              "Game klop happens only in case of every player clicking onwards (nobody licitated). In this case, every player is playing for themselves and everybody's ultimate goal is to minimize the number of picked up points. If the player picks up more than 35 points, he is full and his result is -70, everybody else's meanwhile is 0. If a player doesn't pick up a single point, he is said to be empty and therefore his result is +70, meanwhile everybody else's result is 0. If the played game doesn't meet before matched cases, everybody writes as much as they picked up throughout the entire game negatively. In first six decks of the game, the top card from talon is selected and the card is given to the player, who picked up the deck.",
          "stashing": "Stashing",
          "stashing_desc":
              "You may stash any card you are holding, except for trula and kings. Stashed cards automatically belong to you, whilst the remainder of talon belongs to the passive team. In case tarocks are stashed, all the players must see the stashed tarocks. In case of stashing colors, other players should not see the stashed colors.",
          "king_calling": "King calling",
          "king_calling_desc":
              "In game with four players, you have the right to a teammate if you have selected a game, which allows that. Before talon is shown to everybody, the playing player must select a king. The person, holding the selected king is the teammate of the playing player and as such is now part of the active team. Who holds the selected king is not known until the person reveals the king either by playing with the card inside the game or by predicting king ultimo. If you have accidentally called the king which is in talon, this is called \"Zaruf\". In such a case, you are playing alone, but you may take the part of talon containing the selected king, and if brought successfully home, you receive the other part of talon. Should you not select it, it belongs to the opposite team (passive team).",
          "predictions": "Predictions",
          "predictions_desc":
              "Predictions are a highly important part of the game, as they can often massively increase the received points if predicted correctly.",
          "description": "Description",
          "worth": "Worth",
          "trula_desc":
              "By predicting trula, you predict that your team (no matter if active or passive) will at the end of the game have the whole trula (Škis, Mond and Pagat)",
          "kings_desc":
              "By predicting kings, you predict that your team (no matter if active or passive) will at the end of the game have all the kings",
          "king_ultimo_desc":
              "By predicting king ultimo, you commit yourself that the called king will fall in the last deck of the game and will either pick the whole deck by itself or your teammate will pick the deck, containing the selected king. By predicting it, you are now known to belong to the active team. This prediction is only available in games with three players and only to the player who has the selected king.",
          "pagat_ultimo_desc":
              "By predicting pagat ultimo, you commit yourself that the Pagat will fall in the last deck of the game and will pick the whole deck by itself. Pagat ultimo may be predicted only by the person, holding pagat, no matter if belonging to active or passive team.",
          "color_valat_pred_desc":
              "By predicting color valat, you commit yourself that the game will be changed into color valat from one of the solo games. Color valat may be predicted only by the person, who licitated the original game.",
          "valat_pred_desc":
              "By predicting valat, you commit yourself that the game will be changed into valat. Valat may be predicted only by the person, who licitated the original game.",
          "mondfang_desc":
              "Modified game can also contain an option for mondfang. This means that the person, if their Mond is captured shall have the result of -42 for a caught Mond.",
          "kontra_availability": "Kontra available",
          "up_to_mort": "Everything up to mortkontra (16x)",
          "discards_predictions_transforms_into_game":
              "Discards all previous predictions, transforms into a game.",
          "game_can_kontra":
              "Kontra can be given to the game, not to this prediction",
          "mondfang_rule":
              "If you leave Mond inside talon or your Mond is captured, you can get a -21 on the result as part of the Mondfang penalty.",
          "pagat_picks":
              "If the whole trula falls in the same deck, Pagat picks the whole deck.",
          "kontra_desc":
              "Kontra is used when the opposing player thinks that the predictions are unjust (the player can prevent the predictions from happening). Each kontra doubles the total amount of the prediction. When giving kontra to a game, both game and difference are multiplied.",
          "open_guide": "Open the guide",
          "radelci": "Radelci",
          "radelci_desc":
              "Radelci are given to all players whenever a game of at least beggar is played (or klop). Radelci are represented by small circles (✪). Each radelc can double one's points in one of the future games. In case the game difference is positive, it doubles the total sum of the game and deletes itself. In case the game difference is not positive, it doubles the total sum of the game and doesn't delete itself. At the end of entire game, -40 is given for each unused radelc.",
          "quiet_predictions":
              "Players, if not too sure of their chances, may also opt into \"quiet\" predictions, where they don't predict, yet in the end make the predictions. In the case they don't make the prediction, nothing is written, but if they make it, half points of the normal prediction are received. Quiet predictions cannot be predicted.",
          "toggle_red_filter": "Toggle red filter",
          "toggle_red_filter_desc":
              "Toggle red filter above cards. The filter shows the card's validity to play. This setting applies only to the time when it is not your move. Red filter will still be shown when having to play.",
          "api_url": "API URL",
          "api_url_desc":
              "ATTENTION! If not sure, what you're doing, don't change the defaults here. Improper configuration can open the door to attackers, which can afterwards hijack your session token and manage your account. As Palčka is an open-source program, anybody can host the server. In case one would want to play on their server, the API URL may be changed here. The default URL is https://palcka.si/api. Due to the CORS policy, it is possible that URL change might not work.",
          "tournament_statistics": "Tournament statistics",
          "refresh_stats": "Refresh statistics",
          "delete_profile_picture": "Remove profile picture",
          "change_profile_picture": "Change profile picture",
          "previous_game_stats":
              "You've held place number @place out of total places @total. Best player had @bestPoints points.",
          "register_tournament": "Register",
          "unregister_tournament": "Unregister",
          "counterclockwise_gameplay": "Counterclockwise game",
          "counterclockwise_gameplay_desc":
              "The game will be running counterclockwise. You have to restart the game or leave it to apply this change.",
          "reset_websocket": "Reset the WebSocket connection",
          "points_prediction": "@points points",
          "enable_points_tooltip": "Enable point tooltips",
          "enable_points_tooltip_desc":
              "Values of all games will be shown during the licitation process. You will have to restart the game to apply the change.",
          "accessibility": "Accessibility",
          "bot_plays": "Bots 🤖 are playing \"@game\" @times times",
          "player_plays": "Players 👤 are playing \"@game\" @times times",
          "other_players_are_playing":
              "Other players are currently playing following games",
          "show_evaluation": "Show evaluation",
          "show_evaluation_desc":
              "Shows current StockŠkis evaluation in an evaluation bar in offline (bot) games.",
          "show_most_powerful_card": "Show most powerful card",
          "show_most_powerful_card_desc":
              "Marks the currently most powerful card in the round with red.",
          "game_number": "Game #@gameNumber",
          "game_log_beta": "Game log (beta)",
          "game_log": "Game log",
          "game_ended": "Game has ended",
          "game_ended_subtitle": "The system has ended the game.",
          "game_started": "Game has started",
          "game_started_subtitle": "The system has started the game.",
          "licitation_started": "Licitation has started",
          "licitation_started_subtitle": "@player has started with licitation.",
          "user_licitated": "User has licitated",
          "user_licitated_subtitle": "@player has licitated.",
          "licitations_done": "Licitations have come to an end",
          "licitations_done_subtitle": "@player has won licitations.",
          "king_selection_started": "King selection has started",
          "king_selection_started_subtitle": "@player is selecting a king.",
          "king_selection_done": "King was selected",
          "king_selection_done_subtitle":
              "@player has selected a king. King selection has come to an end.",
          "talon_open": "Talon has opened",
          "talon_open_subtitle":
              "Talon has opened for everyone to see. @player is now selecting which part of talon they want.",
          "talon_selected": "Talon was selected",
          "talon_selected_subtitle":
              "@player has selected a part of talon they want. Talon selection has come to an end.",
          "card_stashing_started": "Card stashing has started",
          "card_stashing_started_subtitle":
              "@player is now thinking which card to stash. @player needs to stash @cardAmount card(s).",
          "card_stashed": "Card was stashed",
          "card_stashed_subtitle": "@player has stashed a card.",
          "card_stashing_done": "Card stashing has ended",
          "card_stashing_done_subtitle":
              "Card stashing has come to an end. @player has stashed @cardAmount card(s).",
          "talon_closed": "Talon has closed",
          "talon_closed_subtitle":
              "Talon cannot be seen anymore until the end of the game",
          "predictions_started": "Predictions have started",
          "predictions_started_subtitle":
              "@player is the first person to predict the possible outcomes of the game.",
          "predicted": "Predicted: ",
          "kontra_predicted": "Kontra: ",
          "user_predicted": "User has predicted",
          "user_predicted_subtitle":
              "@player has predicted either nothing or the following.\n@finalNames",
          "predictions_done": "Predictions have ended",
          "predictions_done_subtitle": "Predictions have come to an end",
          "card_game_started": "Card game has started",
          "card_game_started_subtitle": "System has started the card game.",
          "card_round_started": "Card round has started",
          "card_round_started_subtitle": "@player starts the round.",
          "card_dropped": "Card was dropped",
          "system_card_dropped_subtitle":
              "System has dropped this card either due to a zaruf (the user has picked up the deck with called king) or because the game is Klop (everybody went onwards during the licitation).",
          "card_dropped_subtitle": "@player has dropped the card.",
          "card_round_done": "Card round has ended",
          "card_round_done_subtitle":
              "@player has won this round and therefore starts the next round.",
          "game_prediction": "Game",
          "round_number": "Round @roundNumber",
          "save_game_logs": "Save game logs",
          "save_game_logs_desc":
              "If enabled, your offline games with bots will be saved. Games will never leave your device and will be saved locally for you to see later through the Game Log feature. Note that game data can quickly become big and you might need to clean it up at times.",
          "clear_game_logs": "Clear game logs",
        },
        "fr_FR": {
          "login": "Connexion",
          "email": "Adresse mail",
          "password": "Mot de passe",
          "registration": "Inscription",
          "guest_access": "Hors-ligne contre des robots",
          "official_discord": "Serveur Discord officiel",
          "source_code": "Code source",
          "palcka": "Palčka",
          "profile_name": "Nom du profil (montré en jeu)",
          "repeat_password": "Répéter le mot de passe",
          "register": "Inscription",
          "account_login_403": "Problème de connexion au compte",
          "account_login_403_desc":
              "Votre compte n'était pas encore activé ou un administrateur l'a bloqué/désactivé.",
          "account_login_202_error": "Compte en attente d'activation",
          "account_login_202_error_desc":
              "Vous devriez recevoir un mail d'activation à l'adresse mail que vous avez fournie. Si vous ne l'avez pas reçu, réessayez plus tard. Vous pourrez renvoyer des mails d'activation toutes les 5 minutes.",
          "account_login_unknown_error": "Erreur inconnue lors de la connexion",
          "account_login_unknown_error_desc":
              "Merci de revérifier vos identifiants de connexion. Si vous avez récemment fait envoyer un mail d'activation, mais ne l'avez pas reçu, vous pourrez en faire renvoyer un dans 5 minutes. ",
          "password_mismatch": "Les mots de passe ne correspondent pas.",
          "ok": "OK",
          "registration_success":
              "Inscription terminée avec succès.Vous devrez recevoir un mail avec le code d'inscription à l'adresse spécifiée. Vous ne pourrez pas vous connecter avant d'avoir vérifié votre adresse mail par ce biais.",
          "refresh_data": "Rafraîchir les données",
          "user_id": "ID utilisateur",
          "name": "Nom",
          "played_games": "Jeux en ligne joués",
          "role": "Rôle",
          "account_disabled": "Compte désactivé",
          "verified_email": "Adresse mail vérifiée",
          "registered_on": "Inscrit sur",
          "change_user_name": "Change le nom d'utilisateur",
          "user_current_name": "Le nom d'utilisateur actuel est @name.",
          "cancel": "Annuler",
          "change": "Changer",
          "admin_to_user": "Rétrograder en Utilisateur",
          "user_to_admin": "Promouvoir en Admin",
          "settings": "Paramètres",
          "appearance": "Apparence",
          "dark_mode": "Mode sombre",
          "use_dark_mode": "Utiliser mode sombre",
          "sound": "Son",
          "sound_effects": "Effets sonores",
          "sound_effects_desc": "Activer effets sonores",
          "modifications": "Modifications",
          "modifications_desc":
              "Si vous cherchez un défi à la hauteur, modifiez les options ci-dessous.",
          "stockskis_recommendations": "Recommandations StockŠkis",
          "stockskis_recommendations_desc":
              "StockŠkis vous recommande des actions pendant les enchères. Si vous désactivez cette option, vous ne recevrez aucune recommandation.",
          "predicted_mondfang": "Prédiction de Mondfang",
          "predicted_mondfang_desc":
              "Le jeu vous prédira une Mondfang potentielle.",
          "blind_tarock": "Tarock Palčka à l'aveugle",
          "blind_tarock_desc":
              "Vous ne pourrez voir aucun des plis. Ne fonctionne que pour les parties hors-ligne (contre des robots).",
          "skisfang": "Capture du Škis",
          "skisfang_desc":
              "100 points de pénalité pour un Škis capturé. Seulement pour les parties hors-ligne (contre des robots).",
          "autoconfirm_stash": "Confirmation automatique des cartes défaussées",
          "autoconfirm_stash_desc":
              "Confirme automatiquement les cartes à défausser. Ne l'activez que si vous savez parfaitement ce que vous faites et que vous ne pouvez pas cliquer au mauvais endroit.",
          "autogreet": "Envoyer un message de bienvenue automatique",
          "autogreet_desc":
              "Envoye automatiquement un message de bienvenue à chaque début de partie et à chaque reconnection.",
          "premove": "Prédéplacement",
          "premove_desc": "Prédéplacer une carte",
          "developer_options": "Options dévelopeur",
          "developer_options_desc":
              "Ces options ont principalement pour but d'être utilisées par les dévelopeurs de l'appli Palčka, mais peut-être trouverez-vous amusant de les activer pour s'essayer à plus de défis, et c'est pourquoi nous les avons laissées :) Ces options ne marchent que pour les parties hors-ligne (contre des robots). Certaines options sont incompatibles entre elles.",
          "developer_mode": "Mode développeur",
          "developer_mode_desc":
              "Active des menus dévelopeur/debug additionels",
          "falsify_game": "Fausser le jeu",
          "falsify_game_desc":
              "Votre main pourait contenir un grand nombres de hauts tarocks. Utile pour faire un valat :)",
          "guaranteed_zaruf": "Zaruf garanti",
          "guaranteed_zaruf_desc":
              "Comment ce fait-il que les rois soient tous dans le talon ? Quelle étrange coïncidence.",
          "mond_in_talon": "Mond dans le talon",
          "mond_in_talon_desc": "Voilà un petit problème qui se profile…",
          "skis_in_talon": "Škis dans le talon",
          "skis_in_talon_desc":
              "Peut-être y-a-t-il (toujours) un Škis dans le talon… qui sait.",
          "open_games": "Jeu ouvert",
          "open_games_desc":
              "Il se pourrait peut-être que j'ai pu jeter un oeil dans le jeu des autres, mais rien de bien méchant…",
          "color_valat": "Valat couleur",
          "color_valat_desc":
              "Valat couleur, en trichant juste un tout petit peu.",
          "beggar": "Mendiant",
          "beggar_desc": "Juste les bonnes cartes pour un Mendiant.",
          "autostart_next_game": "Commencer automatiquement la partie suivante",
          "autostart_next_game_desc":
              "Si cette option est désactivée, on ne peut jouer qu'une seule partie à la suite…",
          "no_kontra": "Pas de kontra",
          "kontra": "Kontra",
          "rekontra": "Rekontra",
          "subkontra": "Subkontra",
          "mortkontra": "Mortkontra",
          "normal_bots": "Robots normaux",
          "advanced_bots": "Robots avancés",
          "beggar_bots": "Robots mendiants",
          "klop_bots": "Robots klop",
          "tarock_palcka": "Tarock Palčka",
          "copyright": "Copyright 2023 Mitja Ševerkar",
          "licensed_under": "Protégé sous licence AGPLv3.",
          "version": "Version @version",
          "name_change": "Changement de nom",
          "change_of_name_desc1": "Changer de nom peut se faire librement.",
          "change_of_name_desc2":
              "Dans le cas d'un nom inapproprié, les administrateurs pourraient changer ce nom et le compte de cet utilisateur pourra être bloqué après plusieurs violations.",
          "change_of_name_desc3": "Votre nom actuel est : @name",
          "change_of_email": "Changement d'adresse mail",
          "change_of_email_desc":
              "Dû à des risqus d'abus de compte, nous n'autorisons pas le changement d'adresse mail directement depuis l'application. Merci de contacter les dévelopeurs sur info@palcka.si ou sur Discord (@mytja).",
          "number_of_played_games": "Nombre de jeux lancés: ",
          "user_profile_registered": "Utiliser le profil enregistré sur: ",
          "role_in_system": "Role dans le système: ",
          "change_of_password": "Changement de mot de passe",
          "change_of_password_desc1":
              "Choisissez un mot de passe fort.\nL'application vous déconnectera pour des raisons de sécurité.",
          "change_of_password_desc2":
              "Dans le cas ou rien ne se passe après avoir appuyé sur le bouton Changement, c'est peut-être que vous vous êtes trompé dans votre ancien ou nouveau mot de passe",
          "old_password": "Ancien mot de passe",
          "new_password": "Nouveau mot de passe",
          "confirm_new_password": "Confirmez le nouveau mot de passe",
          "home": "Accueil",
          "friends": "Amis",
          "replays": "Rediffusions",
          "discord": "Serveur Discord",
          "users": "Utilisateurs",
          "profile": "Profil d'utilisateur",
          "logout": "Déconnexion",
          "my_friends": "Mes amis",
          "incoming_friend_requests": "Demandes d'ami reçues",
          "outgoing_friend_requests": "Demandes d'ami envoyées",
          "invite": "Inviter",
          "add_friend": "Ajouter un ami",
          "player": "Joueur",
          "new_game": "Créer une nouvelle partie",
          "welcome_message": "Bienvenue dans l'application Palčka tarock.",
          "using_guest_access": "Vous utilisez l'accès hors-ligne",
          "games_available": "Jeux disponibles",
          "with_players": "Avec des joueurs",
          "in_three": "En trois",
          "in_four": "En quatre",
          "chatroom": "Salon de clavardage",
          "with_bots": "Avec des robots",
          "replay_desc":
              "Ici vous pouvez insérez l'URL d'une rediffusion de jeu",
          "replay_link": "Lien de rediffusion",
          "replay": "Rediffusion",
          "modify_bots": "Modifier les robots",
          "modify_bots_desc":
              "Ici vous pouvez modifier le type de robots contre lesquels vous voulez jouer. L'appli choisira aléatoirement parmi les robots de cette liste à chaque début de jeu, si il y a au moins assez de joueurs requis pour démarrer le jeu.",
          "bot": "Robots",
          "remove": "Retirer",
          "bot_name": "Nom de robot",
          "add_bot": "Ajouter le robot à la liste",
          "finish_list_editing": "Terminer les modifications",
          "discord_desc":
              "Le serveur Discord officiel rassemble la communauté des joueurs de tarock sur un forum officiel.",
          "game": "Partie @type",
          "mondfang_radelci": "Radelci donné pour une Mondfang",
          "join_game": "Rejoindre une partie",
          "watch_replay": "Regarder la rediffusion",
          "seconds_per_move": "Secondes additionelles par action",
          "start_time": "Temps avant début (en secondes)",
          "number_games": "Nombre de parties",
          "private_game": "Partie privée",
          "friend_handle": "Identifiant de l'ami",
          "add": "Ajouter",
          "debugging": "Debugging",
          "first_card": "Première carte : @card",
          "trick": "Pli : @trick",
          "selected_king": "Roi sélectionné : @king",
          "player_with_king": "Joueur avec le roi : @player",
          "stashed_cards": "Cartes défaussées : @stashed",
          "picked_talon": "Talon choisi : @talon",
          "reevaluate_cards": "Réévaluer les cartes",
          "invite_friend": "Inviter un ami",
          "invite_friends": "Invite des amis",
          "start_game": "Commencer la partie",
          "stashed_tarocks": "Tarocks en réserve:",
          "trula": "Trula",
          "kings": "Rois",
          "pagat_ultimo": "Pagat Ultimo",
          "king_ultimo": "Roi Ultimo",
          "mondfang": "Mondfang",
          "valat": "Valat",
          "show_talon": "Montrer le talon",
          "hide_talon": "Cacher le talon",
          "predict": "Prédire",
          "playing_in": "@player joue à @color.",
          "piku": "pique",
          "srcu": "cœur",
          "križu": "trèfle",
          "kari": "carreau",
          "zaruf":
              "Il semble que ce soit un Zaruf. Si vous prenez le roi, vous obtiendrez le reste du talon, et si la Mond se trouve à l'intérieur, elle ne pourra être capturé.",
          "stashing_cards": "Les cartes suivantes seront mises à la réserve.",
          "confirm": "Confirmer",
          "change_card_selection": "Changer la sélection de cartes",
          "immediately_onward": "Avancer immédiatement",
          "prediction": "Prédiction",
          "result": "Résultat",
          "predicted_by": "Prédit par",
          "kontra_by": "Kontra donné par",
          "game_simple": "Partie",
          "difference": "Différence",
          "total": "Total",
          "num_additional_rounds": "Nombre de manches additionelles",
          "hide_point_count_by_tricks":
              "Cacher le total des points de chaque pli",
          "show_point_count_by_tricks":
              "Montrer le total des points de chaque pli",
          "picked_up_cards": "Cartes choisies :",
          "stashed": "Réservées",
          "talon": "Talon",
          "trick_nr": "Pli numéro @number",
          "točk": "points",
          "točko": "point",
          "točki": "points",
          "točke": "points",
          "trick_is_worth": "Ce pli vaut @points @ptext.",
          "trick_picked_up_by": "Pli fait par @player",
          "close_results": "Fermer l'aperçu des résultats",
          "thanks_game": "Merci d'avoir joué",
          "rating": "Évaluation",
          "leave_game": "Quitter la partie",
          "account_confirmed": "Profil utilisateur validé avec succès.",
          "account_not_confirmed":
              "profil utilisateur non-validé ou déjà validé.",
          "customize_bots": "Personnaliser les robots",
          "language": "Langue",
          "onward": "Je passe.",
          "three": "Trois",
          "two": "Deux",
          "one": "Un",
          "solo_three": "Solo trois",
          "solo_two": "Solo deux",
          "solo_one": "Solo un",
          "solo_without": "Solo sans",
          "open_beggar": "Mendiant ouvert",
          "klop": "Klop",
          "password_reset": "Réinitialisation du mot de passe",
          "password_reset_request":
              "Demander un lien de réinitialisation du mot de passe",
          "password_reset_success": "Réinitialisation de mot de passe",
          "password_reset_success_desc":
              "Si l'adresse mail renseignée est valide, vous devriez recevoir un coourriel contenant le lien de réinitialisation de votre mot de passe",
          "password_reset_change_success":
              "Mot de passe réinitialiséavec succès",
          "password_reset_change_success_desc":
              "Votre mot de passe a été réinitialisé avec succès.",
          "password_reset_change_failure":
              "Échec lors de la réinitialisation du mot de passe",
          "password_reset_change_failure_desc":
              "Votre mot de passe N'A PAS pu être modifié. Veuillez retenter la procédure ou contacter les dévelopeurs pour vérifier le déroulement de l'opération.",
          "password_reset_procedure":
              "Cette procédure vous déconnectera de tous vos appareils",
          "password_reset_change": "Changer votre mot de passe",
          "tos": "Conditions générales d'utilisation",
          "other": "Autres paramètres",
          "discord_rpc": "Activer Discord RPC",
          "enable_discord_rpc":
              "Active Discord Rich Presence. Votre statut en jeu sera affiché sur votre profil",
          "talon_picked": "Talon choisi : @talon",
          "tournaments": "Tournois",
          "modify_game": "Modifier votre partie",
          "new_tournament": "Nouveau tournoi",
          "select_start": "Sélectionner le début du tournoi",
          "division": "Poule",
          "create_new_tournament": "Créer un nouveau tournoi",
          "start_at": "Début du tournoi",
          "show_participants": "Montrer les participants inscrits",
          "edit_rounds": "Modifier les manches",
          "edit_tournament": "Modifier le tournoi",
          "invite_tournament_singular":
              "@who vous invite au tournoi de Palčka officiel",
          "invite_tournament_dual":
              "@who vous invite au tournoi de Palčka officiel",
          "invite_tournament_plural":
              "@who vous invite au tournoi de Palčka officiel ",
          "tournament_rated":
              "Ce tournoi @israted compte dans votre classement",
          "not_space": " ne",
          "participants": "Participants",
          "participation_id": "Identification unique de la participation",
          "rated": "Classé",
          "delta": "Delta du classement",
          "points": "Points en jeu",
          "past_tournaments": "Tournois précédents",
          "new_round": "Nouvelle manche",
          "time_per_round": "Temps par manche",
          "create_new_round": "Créer une nouvelle manche",
          "round": "manche",
          "person_1": "Personne 1",
          "person_2": "Personne 2",
          "person_3": "Personne 3",
          "person_4": "Personne 4",
          "clear_round_cards": "Effacer toutes les cartes de cette manche",
          "reshuffle_cards": "Remélanger les cartes",
          "rounds": "Manches",
          "delete_round": "Supprimer une manche",
          "tournament_continue_soon":
              "Le tournoi continue bientôt. ymerci de patienter.",
          "tournament_ending":
              "Le tournoi se termine, les points de classement sont en calcul. La partie se terminera bientôt et vous recevrez votre changement de classement. Merci beaucoup pour votre participation.",
          "handle": "Pseudo (montré aux autres joueurs)",
          "tos_text":
              "En vous inscrivant, vous acceptez les Conditions générales d'utilisation (que vous pouvez lire grâce au bouton sous Inscription). Si vous ne voulez pas créer de compte, vous pourrez toujours utiliser l'accès Hors-ligne.",
          "handle_change": "Changement de pseudo",
          "change_of_handle_desc1": "Vous pouvez librement changer de pseudo.",
          "change_of_handle_desc2":
              "Dans le cas d'un pseudo inapproprié, les administrateurs pourraient changer ce nom et le compte de cet utilisateur pourra être bloqué après plusieurs violations.",
          "handle_desc":
              "Un pseudo est unique et vous identifie auprès des autres utilisateurs. Sont autorisés tous les symboles de l'alphabet anglais, les chiffres, les tirets (-), les points (.) et les tirets du bas (_).",
          "change_of_handle_desc4": "Votre pseudo actuel est : @name",
          "user_current_handle": "Le pseudo actuel de l'utilisateur est @name.",
          "speed": "Vitesse des robots",
          "all_values_in_seconds":
              "Toutes les valeurs sont données en secondes",
          "next_round_speed": "Delai entre chaque manche",
          "general_bot_delay": "Délai général des robots",
          "card_cleanup_delay": "Délai avant débarrassage du pli",
          "current_rating": "Classement du joueur actuel : ",
          "edit_testers": "Modifier les testeurs :",
          "testers": "Testeurs",
          "invite_tournament_singular_private":
              "@who vous invite en tant que testeur au tournoi de Palčka officiel",
          "invite_tournament_dual_private":
              "@who vous invite en tant que testeur au tournoi de Palčka officiel",
          "invite_tournament_plural_private":
              "@who vous invite en tant que testeur au tournoi de Palčka officiel",
          "invite_tournament_rated_private":
              "En tant que testeur, ce tournoi ne compte pas dans votre classement. Dans le cas où vous souhaitiez qu'il compte, et vous n'avez pas vu vos cartes, contactez un administrateur.",
          "start_tournament_testing": "Commencer à tester le tournoi",
          "tournament_testing_description":
              "Merci beaucoup pour votre participation dans le test de ce tournoi. Avant de commencer, voici quelques consignes générales.\nVous testez actuellement pour la poule @division. .\nLa première poule aura les plus fortes mains de départ, les participants devront prendre des décisions difficiles, ce qui pourra être risqué, et ne paiera pas toujours.\nLa deuxième poule aura de bonnes mains de départ, ce qui convient mieux aux joueurs expérimentés, les participants devront prendre des décisions difficiles, ce qui pourra être risqué, mais qui dans la plupart des cas paiera (un jeu risqué signifie ici un Mendiant, Mendiant Ouvert, Valat, Valat couleur etc…).\nLa troisième poule s'adresse aux débutants, il n'y a souvent pas de décisions difficiles à prendre, les mains distribuées sont plutôt claires à comprendre, et aucun jeu risqué ne devrait avoir lieu la plupart du temps, et dans le cas ou un tel jeu apparaît, il sera payant dans 90% des cas.\nLa quatrième poule est destinée aux débutants absolus. Les cartes sont distribuées de telle sorte à ce que le joueur sache clairement quoi jouer dans la plupart des enchères annoncées, et si un jeu risqué apparaît, il paiera toujours.\nDans les troisième et quatrième poules, les jeux à Valat et Valat couleur sont évités.\nEn testant ce tournoi, vous abandonnez votre droit à participer au tournoi classé (vous pourrez toujours participer hors-classement, mais ne recevrez en conséquence aucun classement).\nEn cliquant sur le bouton Démarrer, un nouveau salon sera créé, accesible par vous uniquement.\nVous pourrez rejoindre le tournoi quand vous le voudrez avant la fin du tournoi test.\nLa partie commence une minute après avoir cliqué sur le bouton Démarrer.\nBon test :)",
          "start": "Démarrer",
          "tournament_testing": "Test de tournoi",
          "open_settings": "Ouvrir les paramètres",
          "edit_round": "Modifier la manche",
          "cards": "Cartes",
          "diamonds": "Carreau",
          "cards_guide_desc":
              "Vous trouverez ci-dessous toutes les cartes du jeu. Elles sont classées en fonction du nombre de cartes qu'elles peuvent battre (le roi bat la reine, la reine bat le cavalier etc...). En jeu, la valeur des rois et du Trula (les trois bouts) est de 5 points, 4 points pour les reines, 3 pour les cavaliers, 2 pour les valets et 1 pour les autres cartes.",
          "guide": "Guide",
          "spades": "Pique",
          "hearts": "Cœur",
          "clubs": "Trèfle",
          "tarocks": "Tarocks (atouts)",
          "tarocks_desc":
              "Les tarocks (atouts) sont des cartes spéciales, qui peuvent battre n'importe quelle couleur. Dans le cas où plusieurs tarocks tombent au même pli, c'est le plus haut qui l'emporte. Tous les tarocks sont numérotés, excepté pour le Škis (l'Excuse), qu'on considère comme le tarock numéro 22, puisqu'il bat tous les autres tarocks. Tous les tarocks portent le nom de leur valeur, excepté pour le premier qu'on appelle Pagat, Palica or Palčka (le Petit), le 21 qu'on appelle la Mond (la Lune) et le 22 qu'on appelle donc le Škis. Ces trois tarocks représentent ensemble le Trula (les Bouts).",
          "general_card_play_rules": "Règles générales concernant les cartes",
          "card_play_rules":
              "A chaque manche, le joueur qui commence peut jouer n'importe quelle carte, qu'il s'agisse d'un tarock ou d'une couleur. S'il commence avec l'une des 4 couleurs (par exemple, Pique), les autres joueurs doivent suivre avec la même couleur. S'ils n'en ont pas, ils doivent jouer un tarock, et s'il n'ont pas de tarock non plus, jouer n'importe quelle autre carte. Les règles sont similaires lorsque le premier joueur joue un tarock: dans ce cas, vous devez obligatoirement suivre avec un tarock, ou en l'absence de tarock, jouer n'importe quelle autre carte. Dans une manche de Mendiant, Mendiant Ouvert ou Klop (Misère), on ne peut jouer le Pagat (le Petit) que comme son dernier tarock. Le premier pli d'une manche est lancé par le joueur réglementaire, sauf cas exceptionnel.",
          "licitation": "Enchères",
          "licitation_desc":
              "Chaque manche commence par les enchères. A ce moment, vous annoncez aux autres joueurs quel type de contrat vous souhaitez jouer, ou si votre jeu ne vous le permet pas, passez votre tour (dans ce cas cliquez sur \"Je passe.\"). Tous les contrats possibles sont listés ci-dessous, de la plus faible valeur à la plus forte (à l'exception du Klop). Au cas où deux joueurs choisiraient le même type de contrat, seul le joueur réglementaire à la possibilité de surenchérir (le joueur réglementaire étant le dernier à proposer une enchère). La plupart des contrats consistent pour l'équipe active (le joueur qui remporte l'enchère, aidé d'un coéquipier selon le contrat) à récupérer au moins 36 points de plis. Dans ce cas la différence s'ajoute aux points de plis, calculée selon la formule (points de plis de l'équipe active - 35 = différence).",
          "three_only_mand": "Trois (seulement pour le joueur réglementaire)",
          "three_gameplay":
              "Lors d'une manche en Trois, le talon est divisé en deux paquets de 3 cartes. Choisissez l'un de ces paquets puis mettez à l'écart 3 cartes de votre main. Dans une partie 4 joueurs, vous avez le droit à un coéquipier. Cette enchère vaut 10 points.",
          "two_gameplay":
              "Lors d'une manche en Deux, le talon est divisé en trois paquets de 2 cartes. Choisissez l'un de ces paquets puis mettez à l'écart 2 cartes de votre main. Dans une partie 4 joueurs, vous avez le droit à un coéquipier. Cette enchère vaut 20 points.",
          "one_gameplay":
              "Lors d'une manche en Un, le talon est divisé en six paquets d'1 seule carte. Choisissez l'un de ces paquets et mettez à l'écart 1 carte de votre main. Dans une partie 4 joueurs, vous avez le droit à un coéquipier. Cette enchère vaut 30 points.",
          "solo_three_only_four": "Solo trois (4 joueurs seulement)",
          "solo_three_gameplay":
              "Lors d'une manche en Solo trois, le talon est divisé en deux paquets de 3 cartes. Choisissez l'un de ces paquets et mettez à l'écart 3 cartes de votre main. Vous n'avez pas le droit à un coéquipier. Vous pouvez vous-même surenchérir sur un Color Valat. Cette enchère vaut 40 points.",
          "solo_two_only_four": "Solo deux (4 joueurs seulement)",
          "solo_two_gameplay":
              "Lors d'une manche en Solo deux, le talon est divisé en trois paquets de 2 cartes. Choisissez l'un de ces paquets et mettez à l'écart 2 cartes de votre main. Vous n'avez pas le droit à un coéquipier. Vous pouvez vous-même surenchérir sur un Color Valat. Cette enchère vaut 50 points.",
          "solo_one_only_four": "Solo un (4 joueurs seulement)",
          "solo_one_gameplay":
              "Lors d'une manche en Solo un, le talon est divisé en six paquets d'1 seule carte. Choisissez l'un de ces paquets et mettez à l'écart 1 carte de votre main. Vous n'avez pas le droit à un coéquipier. Vous pouvez vous-même surenchérir sur un Color Valat. Cette enchère vaut 60 points.",
          "beggar_gameplay":
              "Avec une enchère de Mendiant, vous ne verrez pas le talon avant la fin de la manche. Aucune prédiction n'est autorisée à l'exception du Kontra. Avec cette enchère, vous faites le pari de ne prendre aucun pli pendant toute la durée de la manche. Cette enchère vaut 80 points, la différence de points en fin de manche n'est pas compatibilisée.",
          "solo_without_gameplay":
              "Avec une enchère à Solo sans, vous ne verrez pas le talon avant la fin de la manche. Aucune prédiction n'est autorisée à l'exception du Kontra. Avec cette enchère, vous faites le pari de prendre au moins 36 points de pli. Cette enchère vaut 80 points, la différence de points en fin de manche n'est pas compatibilisée.",
          "open_beggar_gameplay":
              "Une manche en Mendiant Ouvert se déroule essentiellement de la même manière qu'une manche en Mendiant, à la différence que le joueur qui a fait l'annonce doit montrer la totalité de ses cartes aux autres joueurs, et jouer ainsi toute la durée de la manche. C'est ce même joueur qui doit lancer le premier pli. Cette enchère vaut 90 points",
          "color_valat_only_four": "Valat Couleur (4 joueurs seulement)",
          "color_valat_gameplay":
              "Lors d'un Valat Couleur (Chelem Couleur), vous ne verrez pas le talon avant la fin de la manche (sauf si le Valat est annoncé comme prédiction sur une autre enchère). Aucune prédiction n'est admise, à l'exception du Kontra (Contre). Dans cette manche, vous aurez l'obligation de remporter tous les plis. Dès que vous en ratez un, la manche se termine et vous prenez une pénalité. Vous commencerez tous les plis, en tant que joueur actif. Le talon vous revient. La spécificité du Valat Couleur et qu'il chamboule les règles habituelles du Tarock Palčka, puisque les couleurs deviennent plus puissantes que les tarocks et l'emportent dans un pli qui contient les deux. Cette enchère vaut 125 points, et la différence en fin de manche n'est pas compatibilisée.",
          "valat_gameplay":
              "Lors d'un Valat (Chelem), vous ne verrez pas le talon avant la fin de la manche (sauf si le Valat est annoncé comme prédiction sur une autre enchère). Aucune prédiction n'est admise, à l'exception du Kontra (Contre). Dans cette manche, vous aurez l'obligation de remporter tous les plis. Dès que vous en râtez un, la manche se termine. Vous commencerez tous les plis, en tant que joueur actif. Le talon vous revient. Cette enchère vaut 500 points (250 seulement si réussie sans prédiction), et la différence en fin de manche n'est pas compatibilisée.",
          "klop_gameplay":
              "Une manche de Klop (Misère) a lieu lorsque tous les joueurs annoncent \"Je passe\" (personne n'annonce d'enchère). Dans ce cas, chaque joueur joue pour son compte et leur objectif sera de marquer le moins de points dans le moins de plis possible. Au cours de la manche, si la valeur totale des plis d'un joueur dépasse 35 points, on dit qu'il est \"plein\" : la manche s'arrête instantanément, lui-même prend une pénalité de 70 points tandis que les autres marquent 0 points. En fin de manche, si un joueur n'a pas pris un seul point, on dit qu'il est \"vide\" : il marque 70 points tandis que les autres marquent 0. Si aucun de ces deux cas n'a lieu, chacun prend une pénalité équivalente aux points des plis qu'il a remportés. Lors des 6 premiers plis d'un Klop, on donne la première carte du talon au joueur qui vient de remporter le pli, augmentant le nombre de points du pli.",
          "stashing": "L'écart",
          "stashing_desc":
              "Vous pouvez mettre à l'écart n'importe quelle carte de votre main, à l'exception du Trula (les Bouts) et des rois. Les cartes à l'écart vous reviennent automatiquement à la fin de la manche, tandis que le reste du talon revient à l'équipe passive. Si des tarocks (des atouts) sont mis à l'écart, ils doivent être révélés à tous les joueurs. Si des couleurs sont mises à l'écart, ce n'est pas le cas.",
          "king_calling": "Appel du roi",
          "king_calling_desc":
              "Dans un partie à 4 joueurs, vous avez le droit à un coéquipier si vous remportez l'enchère avec une annonce qui le permet. Avant de révéler le talon, le joueur qui  remporté l'enchère doit appeler un roi. La personne qui détient ce roi devient le coéquipier de ce joueur, et ils forment ensemble l'équipe active. On ne sait pas qui détient le roi appelé avant que celle-ci ne révèle le roi, en le jouant au cours de la manche, ou en faisant une prédiction Roi Ultimo. Si vous avez appelé un roi dans le talon par accident, vous faites Zaruf: dans ce cas, vous jouerez la manche sans coéquipier, mais vous pouvez prendre la part du talon qui contient le roi appelé, et si ce roi fait partie de vos captures en fin de manche vous recevrez le reste du talon. Si vous ne prenez pas la part contenant le roi, elle reviendra à l'équipe adverse; c'est à dire l'équipe passive.",
          "predictions": "Prédictions",
          "predictions_desc":
              "Les prédictions sont une part très importante du jeu, car souvent elles peuvent massivement augmenter les points gagnés si les prédictions sont correctes.\n",
          "description": "Description",
          "worth": "Valeurs",
          "trula_desc":
              "En faisant une prédiction Trula, vous prédisez que votre équipe (qu'elle soit active ou passive) aura capturé le Trula entier avant la fin de la manche (le Škis, la Mond, et le Pagat).",
          "kings_desc":
              "En faisant une prédiction Rois, vous prédisez que votre équipe (qu'elle soit active ou passive) aura capturé tous les rois avant la fin de la manche.",
          "king_ultimo_desc":
              "En faisant une prédiction Roi Ultimo, vous prédisez que le roi appelé sera joué au dernier pli et le remportera, ou sera remporté par votre coéquipier. En conséquence, tout le monde saura que vous appartiendrez à l'équipe active. Cette prédiction n'est possible que lors d'une partie à 3 joueurs, et seule la personne qui détient le roi appelé peut prédire Roi Ultimo.",
          "pagat_ultimo_desc":
              "En faisant une prédiction Pagat Ultimo, vous prédisez que le Pagat sera joué au dernier pli et le remportera. Seule la personne qui détient le Pagat peut prédire Pagat Ultimo, qu'elle fasse partie de l'équipe active ou passive.",
          "color_valat_pred_desc":
              "En faisant une prédiction Valat Couleur, vous transformez la manche actuelle en Valat Couleur. Seule la personne qui a remporté l'enchère (avec une annonce de manche solo) peut prédire Valat Couleur.",
          "valat_pred_desc":
              "En faisant une prédiction Valat, vous transformez la manche actuelle en Valat. Seule la personne qui a remporté l'enchère peut prédire un Valat.",
          "mondfang_desc":
              "Il est possible de jouer une partie personnalisée avec l'option Mondfang (Capture de Lune) activée. Cela signifie qu'au cours d'une manche, une pénalité de 42 points est attribuée à un joueur qui se fait capturer sa Mond (la Lune, atout XXI).",
          "kontra_availability": "Kontra disponible",
          "up_to_mort": "Tout jusqu'au Mortkontra (16x)",
          "discards_predictions_transforms_into_game":
              "Ignore toutes les précédentes prédictions, transforme la manche.",
          "game_can_kontra":
              "Un Kontra peut être annoncé sur l'enchère, mais pas sur cette prédiction.",
          "mondfang_rule":
              "Si vous laissez la Mond (la Lune, atout XXI) dans le talon, ou si votre Mond est capturée, vous prenez 21 points de pénalité selon la règle du Mondfang (Capture de Lune).",
          "pagat_picks":
              "Si le Trula entier (les Bouts) tombe dans le même pli, le Pagat (Petit) remporte le pli.",
          "kontra_desc":
              "Un joueur annonce Kontra (Contre) quand il pense que le joueur adverse ne remplira pas sa prédiction (c'est-à-dire qu'il pense pouvoir empêcher cette prédiction). Chaque Kontra double les points positifs ou négatifs marqués sur une prédiction. Quand on annonce Kontra sur une  enchère, les points d'enchère et de différence positive ou négative sont doublés.",
          "open_guide": "Ouvrir le guide",
          "radelci": "Radelci (roues)",
          "radelci_desc":
              "On octroie un Radelc à chaque joueur chaque fois qu'une manche de Mendiant ou de Klop est jouée. Les Radelci sont représentés par de petites roues étoilées (✪). Chaque Radelc double les points que le joueur marque par la suite. Si les points de différence marqués sont positifs, il double les points de cette manche et disparaît. Si les points de différence marqués sont négatifs, il double les points de cette manche et reste actif. À la fin du jeu, les joueurs perdent 40 points pour chaque Radelc encore actif.",
          "quiet_predictions":
              "Si un joueur n'est pas tout à fait sûr de sa chance, il peut opter pour une prédiction \"silencieuse\" c'est à dire qu'il n'annonce pas sa prédiction en début de manche, mais réussit à en remplir les conditions avant la fin de la manche. S'il rate sa prédiction, rien ne se passe, mais si elle est remplie, la moitié des points d'une prédiction normale lui sont attribués.",
          "toggle_red_filter": "Filtre rouge",
          "toggle_red_filter_desc":
              "Active/désactive le filtre rouge au dessus des cartes. Le filtre montre la validité des cartes à jouer. Ce paramètre ne s'applique que lorsque ce n'est pas votre tour de jouer. Un filtre rouge sera toujours présent lorr de votre tour.",
          "api_url": "URL de l'API",
          "api_url_desc":
              "ATTENTION!\nDans le doute, ne changez pas ici le paramètre par défaut. Une mauvaise configuration laisserait la portes ouvertes aux attaques, qui pourraient voler votre token de session and modifier votre compte. Palčka étant un logiciel open-source, n'importe qui peut héberger un serveur. Si vous souhaitez jouer sur votre propre serveur, c'est ici que l'adresse URL de l'API peut être changée. l'URL par défaut est https:palcka.si/api. En fonction des règles de CORS, il est possible que changer cet URL ne fonctionne pas.",
          "tournament_statistics": "Statistiques de tournoi",
          "refresh_stats": "Rafraîchir les statistiques",
          "delete_profile_picture": "Enlever la photo de profil",
          "change_profile_picture": "Changer la photo de profil",
          "previous_game_stats":
              "Vous êtes arrivé numéro @place sur un total de @total joueurs. Le meilleur joueur a obtenu @bestPoints points.",
          "register_tournament": "S'inscrire",
          "unregister_tournament": "Se désinscrire",
          "counterclockwise_gameplay":
              "Tour en sens inverse des aiguilles d'une montre",
          "counterclockwise_gameplay_desc":
              "Le tour se fera dans le sens inverse des aiguilles d'une montre. Vous devrez redémarrer le jeu pour appliquer ces changements.",
          "reset_websocket": "Remettre à zéro la connection WebSocket",
          "points_prediction": "@points points",
          "enable_points_tooltip": "Activer le rappel des points",
          "enable_points_tooltip_desc":
              "La valeur de chaque pari sera affichée pendant la phase d'enchères. Vous devrez redémarrer le jeu pour appliquer ces changements.",
          "accessibility": "Accessibilité",
          "bot_plays": "Les robots 🤖 jouent \"@game\" @times fois",
          "player_plays": "Les joueurs 👤 jouent \"@game\" @times fois",
          "other_players_are_playing":
              "Les autres joueurs sont actuellement en train de jouer aux jeux suivants",
          "show_evaluation": "Show evaluation",
          "show_evaluation_desc":
              "Shows current StockŠkis evaluation in an evaluation bar in offline (bot) games.",
          "show_most_powerful_card": "Montrer la carte la plus puissante",
          "show_most_powerful_card_desc":
              "Marque en rouge la carte qui est actuellement la plus puissante du pli.",
          "game_number": "Game #@gameNumber",
          "game_log_beta": "Game log (beta)",
          "game_log": "Game log",
          "game_ended": "Game has ended",
          "game_ended_subtitle": "The system has ended the game.",
          "game_started": "Game has started",
          "game_started_subtitle": "The system has started the game.",
          "licitation_started": "Licitation has started",
          "licitation_started_subtitle": "@player has started with licitation.",
          "user_licitated": "User has licitated",
          "user_licitated_subtitle": "@player has licitated.",
          "licitations_done": "Licitations have come to an end",
          "licitations_done_subtitle": "@player has won licitations.",
          "king_selection_started": "King selection has started",
          "king_selection_started_subtitle": "@player is selecting a king.",
          "king_selection_done": "King was selected",
          "king_selection_done_subtitle":
              "@player has selected a king. King selection has come to an end.",
          "talon_open": "Talon has opened",
          "talon_open_subtitle":
              "Talon has opened for everyone to see. @player is now selecting which part of talon they want.",
          "talon_selected": "Talon was selected",
          "talon_selected_subtitle":
              "@player has selected a part of talon they want. Talon selection has come to an end.",
          "card_stashing_started": "Card stashing has started",
          "card_stashing_started_subtitle":
              "@player is now thinking which card to stash. @player needs to stash @cardAmount card(s).",
          "card_stashed": "Card was stashed",
          "card_stashed_subtitle": "@player has stashed a card.",
          "card_stashing_done": "Card stashing has ended",
          "card_stashing_done_subtitle":
              "Card stashing has come to an end. @player has stashed @cardAmount card(s).",
          "talon_closed": "Talon has closed",
          "talon_closed_subtitle":
              "Talon cannot be seen anymore until the end of the game",
          "predictions_started": "Predictions have started",
          "predictions_started_subtitle":
              "@player is the first person to predict the possible outcomes of the game.",
          "predicted": "Predicted: ",
          "kontra_predicted": "Kontra: ",
          "user_predicted": "User has predicted",
          "user_predicted_subtitle":
              "@player has predicted either nothing or the following.\n@finalNames",
          "predictions_done": "Predictions have ended",
          "predictions_done_subtitle": "Predictions have come to an end",
          "card_game_started": "Card game has started",
          "card_game_started_subtitle": "System has started the card game.",
          "card_round_started": "Card round has started",
          "card_round_started_subtitle": "@player starts the round.",
          "card_dropped": "Card was dropped",
          "system_card_dropped_subtitle":
              "System has dropped this card either due to a zaruf (the user has picked up the deck with called king) or because the game is Klop (everybody went onwards during the licitation).",
          "card_dropped_subtitle": "@player has dropped the card.",
          "card_round_done": "Card round has ended",
          "card_round_done_subtitle":
              "@player has won this round and therefore starts the next round.",
          "game_prediction": "Game",
          "round_number": "Round @roundNumber",
          "save_game_logs": "Save game logs",
          "save_game_logs_desc":
              "If enabled, your offline games with bots will be saved. Games will never leave your device and will be saved locally for you to see later through the Game Log feature. Note that game data can quickly become big and you might need to clean it up at times.",
          "clear_game_logs": "Clear game logs",
        },
        "sl_SI": {
          "login": "Prijava",
          "account_login_403": "Težava s prijavo v vaš uporabniški profil",
          "account_login_403_desc":
              "Vaš uporabniški profil ni še bil aktiviran ali pa ga je administrator zaklenil.",
          "account_login_202_error": "Račun čaka na aktivacijo",
          "account_login_202_error_desc":
              "Na vaš elektronski naslov bi moralo biti poslano aktivacijsko elektronsko sporočilo. Če to ni bilo poslano, poskusite znova malo kasneje. Aktivacijska elektronska sporočila lahko ponovno pošljete v roku 5 minut.",
          "account_login_unknown_error": "Neznana napaka pri prijavi",
          "account_login_unknown_error_desc":
              "Prosimo, ponovno preverite prijavne podatke. Če ste nedavno poslali aktivacijsko sporočilo in ga ne dobite, ga lahko ponovno pošljete v roku 5 minut.",
          "registration_success":
              "Registracija je bila uspešna. Na vaš elektronski naslov bi moralo priti sporočilo z registracijsko kodo. Dokler ne aktivirate računa, se ne boste mogli prijaviti",
          "user_id": "Uporabniški ID",
          "developer_options_desc":
              "Te opcije so namenjene predvsem razvijalcem programa Palčka.si. Mogoče so komu v izziv ali pa malo tako za zabavo, tako da jih puščam tukaj na voljo vsem :). Te opcije delujejo samo na lokalnih igrah z boti. Nekatere nastavitve so nekompatibilne med sabo.",
          "falsify_game_desc":
              "V roke dobite kar dosti visokih tarokov. Odlična stvar za valata ;).",
          "guaranteed_zaruf_desc":
              "Le kako so se vsi kralji pojavili v talonu. Čudno naključje.",
          "mond_in_talon_desc":
              "Potem pa pridemo do enega manjšega problemčka ...",
          "skis_in_talon_desc":
              "Mogoče je škis v talonu (vedno) ... Nič ne vem o tem.",
          "open_games_desc":
              "Mogoče sem čisto malo pokukal v karte drugih, nič takega ...",
          "color_valat_desc": "Barvič, samo da drobceno prirejen.",
          "autostart_next_game": "Avtomatično začni naslednjo igro",
          "autostart_next_game_desc":
              "Če je opcija ugasnjena, se bomo lahko šli samo eno igro ...",
          "name_change": "Sprememba imena",
          "change_of_name_desc1":
              "Zamenjava imena je brezplačna in prosto dostopna vsem.",
          "change_of_name_desc2":
              "V primeru neprimernega imena, bodo administratorji spremenili ime, uporabniku pa se lahko po večkratnih kršitvah zakleni uporabniški račun.",
          "change_of_name_desc3": "Vaše trenutno uporabniško ime je: @name",
          "change_of_email": "Zamenjava elektronskega naslova",
          "change_of_email_desc":
              "Zaradi možne zlorabe ne ponujamo menjave elektronskega naslova direktno prek uporabniškega vmesnika. Kontaktirajte razvijalca na info@palcka.si ali na Discordu (@mytja).",
          "number_of_played_games": "Število odigranih iger: ",
          "user_profile_registered": "Uporabniški profil registriran: ",
          "role_in_system": "Vloga v sistemu: ",
          "change_of_password": "Sprememba gesla",
          "change_of_password_desc1":
              "Izberite si dobro geslo. Program vas bo zaradi varnosti izpisal/odjavil po uspešni spremembi gesla.",
          "change_of_password_desc2":
              "V primeru, da se ne zgodi nič po kliku na Spremeni, ste se mogoče zatipkali pri novem ali starem geslu.",
          "my_friends": "Moji prijatelji",
          "incoming_friend_requests": "Prihodne prošnje za prijateljstvo",
          "outgoing_friend_requests": "Odhodne prošnje za prijateljstvo",
          "player": "Igralec",
          "welcome_message": "Dobrodošli v Palčka tarok programu.",
          "replay_desc": "Tukaj lahko vpišete URL do posnetka igre",
          "modify_bots_desc":
              "Tukaj lahko urejate, kakšne bote želite videti v svojih igrah. Program bo ob vstopu v igro avtomatično izbral naključne igralce iz tega seznama, če jih je vsaj toliko, kot zahteva ta igra.",
          "discord_desc":
              "Uradni Discord strežnik vsebuje forum in skupnost igralcev taroka.",
          "seconds_per_move": "Sekund na potezo (pribitek)",
          "start_time": "Začetni čas (sekund)",
          "number_games": "Število iger",
          "private_game": "Zasebna partija",
          "zaruf":
              "Uf, tole pa bo zaruf. Če izbereš kralja in ga uspešno pripelješ čez, dobiš še preostanek talona in v primeru, da je v talonu mond, ne pišeš -21 dol.",
          "stashing_cards": "Trenutno si zalagate naslednje karte.",
          "account_confirmed": "Uporabniški profil je bil uspešno potrjen.",
          "account_not_confirmed": "Uporabniški profil ni bil potrjen",
          //
          "email": "Elektronski naslov",
          "password": "Geslo",
          "registration": "Registracija",
          "guest_access": "Dostop brez povezave z boti",
          "official_discord": "Uradni Discord strežnik",
          "source_code": "Izvorna koda",
          "palcka": "Palčka",
          "profile_name": "Ime profila (prikazano v igri)",
          "repeat_password": "Ponovite geslo",
          "register": "Registracija",
          "password_mismatch": "Gesli se ne ujemata",
          "ok": "OK",
          "refresh_data": "Osveži podatke",
          "name": "Ime",
          "played_games": "Igrane igre",
          "role": "Vloga",
          "account_disabled": "Onemogočen račun",
          "verified_email": "Preverjen elektronski naslov",
          "registered_on": "Čas registracije",
          "change_user_name": "Zamenjaj uporabnikovo ime",
          "user_current_name": "Uporabnikovo trenutno ime je @name.",
          "cancel": "Prekliči",
          "change": "Spremeni",
          "admin_to_user": "Spremeni administratorja v uporabnika",
          "user_to_admin": "Spremeni uporabnika v administratorja",
          "settings": "Nastavitve",
          "appearance": "Izgled",
          "dark_mode": "Temni način",
          "use_dark_mode": "Uporabi temni način",
          "sound": "Zvok",
          "sound_effects": "Zvočni efekti",
          "sound_effects_desc": "Vključi zvočne efekte",
          "modifications": "Modifikacije",
          "modifications_desc":
              "Če potrebujete izziv, si lahko prilagodite spodnje opcije.",
          "stockskis_recommendations": "StockŠkis priporočila",
          "stockskis_recommendations_desc":
              "StockŠkis priporoča igre. Če izključite to opcijo, ne boste več prejemali priporočil.",
          "predicted_mondfang": "Napovedan mondfang",
          "predicted_mondfang_desc": "Mondfang se lahko napove.",
          "blind_tarock": "Slepi tarok",
          "blind_tarock_desc":
              "Ne boste videli štihov. Velja samo za igre z boti.",
          "skisfang": "Škisfang",
          "skisfang_desc": "-100 za ujetega škisa. Velja samo za igre z boti.",
          "autoconfirm_stash": "Avtopotrdi založitev",
          "autoconfirm_stash_desc":
              "Avtopotrdi založitev. Vključite to le če veste kaj delate in se ne morete zaklikati.",
          "autogreet": "Avtomatični lp",
          "autogreet_desc":
              "Pošlje lp na začetku vsake igre in na vsako ponovno priključitev igri.",
          "premove": "Premove",
          "premove_desc": "Premovaj karto",
          "developer_options": "Razvijalske opcije",
          "developer_mode": "Razvijalski način",
          "developer_mode_desc": " Vključi dodatne razvijalske menije",
          "falsify_game": "Priredi igro",
          "guaranteed_zaruf": "Garantiran zaruf",
          "mond_in_talon": "Mond v talonu",
          "skis_in_talon": "Škis v talonu",
          "open_games": "Odprte igre",
          "color_valat": "Barvni valat",
          "beggar": "Berač",
          "beggar_desc": "Ravno prave karte za berača",
          "no_kontra": "Brez kontre",
          "kontra": "Kontra",
          "rekontra": "Rekontra",
          "subkontra": "Subkontra",
          "mortkontra": "Mortkontra",
          "normal_bots": "Normalni boti",
          "advanced_bots": "Napredni boti",
          "beggar_bots": "Berač boti",
          "klop_bots": "Klop boti",
          "tarock_palcka": "Tarok Palčka",
          "copyright": "Copyright 2023 Mitja Ševerkar, vse pravice pridržane",
          "licensed_under": "Licencirano pod AGPLv3 licenco.",
          "version": "Različica @version",
          "old_password": "Staro geslo",
          "new_password": "Novo geslo",
          "confirm_new_password": "Potrdi novo geslo",
          "home": "Domov",
          "friends": "Prijatelji",
          "replays": "Posnetki iger",
          "discord": "Discord strežnik",
          "users": "Uporabniki",
          "profile": "Uporabniški profil",
          "logout": "Odjava",
          "invite": "Povabi",
          "add_friend": "Dodaj prijatelja",
          "new_game": "Ustvari novo igro",
          "using_guest_access": "Uporabljate dostop brez povezave",
          "games_available": "Igre na voljo",
          "with_players": "Z igralci",
          "in_three": "V tri",
          "in_four": "V štiri",
          "chatroom": "Klepetalnica",
          "with_bots": "Z računalniškimi igralci",
          "replay_link": "Povezava do posnetka igre",
          "replay": "Posnetek igre",
          "modify_bots": "Prilagodi računalniške igralce",
          "bot": "Bot",
          "remove": "Odstrani",
          "bot_name": "Ime bota",
          "add_bot": "Dodaj bota na seznam",
          "finish_list_editing": "Končaj z urejanjem",
          "game": "Igra @type",
          "mondfang_radelci": "Radelci na mondfang",
          "join_game": "Pridruži se igri",
          "watch_replay": "Oglej si posnetek igre",
          "friend_handle": "Uporabniško ime prijatelja",
          "add": "Dodaj",
          "debugging": "Razhroščevanje",
          "first_card": "Prva karta: @card",
          "trick": "Štih: @trick",
          "selected_king": "Izbrani kralj: @king",
          "player_with_king": "Igralec s kraljem: @player",
          "stashed_cards": "Založene karte: @stashed",
          "picked_talon": "Izbran talon: @talon",
          "reevaluate_cards": "Ponovno evaluiraj karte",
          "invite_friend": "Povabi prijatelja",
          "invite_friends": "Povabi prijatelje",
          "start_game": "Začni igro",
          "stashed_tarocks": "Založeni taroki:",
          "trula": "Trula",
          "kings": "Kralji",
          "pagat_ultimo": "Pagat ultimo",
          "king_ultimo": "Kralj ultimo",
          "mondfang": "Mondfang",
          "valat": "Valat",
          "show_talon": "Pokaži talon",
          "hide_talon": "Skrij talon",
          "predict": "Napovej",
          "playing_in": "@player igra v @color.",
          "piku": "piku",
          "srcu": "srcu",
          "križu": "križu",
          "kari": "kari",
          "confirm": "Potrdi",
          "change_card_selection": "Spremeni izbiro",
          "immediately_onward": "Takoj naprej",
          "prediction": "Napoved",
          "result": "Rezultat",
          "predicted_by": "Napovedal",
          "kontra_by": "Kontriral",
          "game_simple": "Igra",
          "difference": "Razlika",
          "total": "Skupaj",
          "num_additional_rounds": "Število dodatnih rund",
          "hide_point_count_by_tricks": "Skrij evaluacijo po štihih",
          "show_point_count_by_tricks": "Pokaži evaluacijo po štihih",
          "picked_up_cards": "Pobrane karte:",
          "stashed": "Založeno",
          "talon": "Talon",
          "trick_nr": "@number. štih",
          "točk": "točk",
          "točko": "točko",
          "točki": "točki",
          "točke": "točke",
          "trick_is_worth": "Štih je (zaokroženo) vreden @points @ptext.",
          "trick_picked_up_by": "Štih je pobral @player",
          "close_results": "Zapri vpogled v rezultate",
          "thanks_game": "Hvala za igro",
          "rating": "Rating",
          "leave_game": "Zapusti igro",
          "customize_bots": "Prilagodi računalniške igralce",
          "language": "Jezik",
          "onward": "Naprej",
          "three": "Tri",
          "two": "Dva",
          "one": "Ena",
          "solo_three": "Solo tri",
          "solo_two": "Solo dva",
          "solo_one": "Solo ena",
          "solo_without": "Solo brez",
          "open_beggar": "Odprti berač",
          "klop": "Klop",
          "password_reset": "Ponastavitev gesla",
          "password_reset_request": "Zahtevajte povezavo za ponastavitev gesla",
          "password_reset_success": "Ponastavitev gesla",
          "password_reset_success_desc":
              "V primeru, da ste vpisali pravi elektronski naslov, bi morali prejeti e-pošto s povezavo do strani za resetiranje vašega gesla.",
          "password_reset_change_success":
              "Ponastavitev gesla je bila uspešno izvedena",
          "password_reset_change_success_desc":
              "Vaše geslo je bilo uspešno spremenjeno.",
          "password_reset_change_failure": "Napaka pri ponastavitvi gesla",
          "password_reset_change_failure_desc":
              "Vaše geslo se ni spremenilo. Prosimo, ponovite postopek, ali kontaktirajte razvijalce, da se razčisti o možnih težavah.",
          "password_reset_procedure": "Postopek vas bo izpisal iz vseh naprav",
          "password_reset_change": "Spremenite svoje geslo",
          "tos": "Pogoji uporabe",
          "other": "Ostale nastavitve",
          "discord_rpc": "Vključite Discord RPC",
          "enable_discord_rpc":
              "Vključi Discordovo bogato prisotnost (Rich Presence). Vaš status znotraj igre bo prikazan na vašem Discord profilu.",
          "talon_picked": "Izbran talon: @talon",
          "tournaments": "Turnirji",
          "modify_game": "Prilagodite si igro",
          "new_tournament": "Nov turnir",
          "select_start": "Izberite čas začetka turnirja",
          "division": "Divizija (težavnost)",
          "create_new_tournament": "Ustvari nov turnir",
          "start_at": "Začetek turnirja",
          "show_participants": "Pokaži registrirane udeležence",
          "edit_rounds": "Uredi runde",
          "edit_tournament": "Uredi turnir",
          "invite_tournament_singular":
              "@who vas vabi na uradni Palčka turnir ",
          "invite_tournament_dual": "@who vas vabita na uradni Palčka turnir ",
          "invite_tournament_plural":
              "@who vas vabijo na uradni Palčka turnir ",
          "tournament_rated": "Turnir se@israted šteje k vašemu rejtingu.",
          "not_space": " ne",
          "participants": "Udeleženci",
          "participation_id": "Enolični identifikator udeležbe",
          "rated": "Rejtano",
          "delta": "Elo delta",
          "points": "Točk v igri",
          "past_tournaments": "Pretekli turnirji",
          "new_round": "Nova runda",
          "time_per_round": "Čas na rundo",
          "create_new_round": "Ustvari novo rundo",
          "round": "runda",
          "person_1": "Oseba 1",
          "person_2": "Oseba 2",
          "person_3": "Oseba 3",
          "person_4": "Oseba 4",
          "clear_round_cards": "Počisti vse karte v tej rundi",
          "reshuffle_cards": "Ponovno zmešaj karte",
          "rounds": "Runde",
          "delete_round": "Izbriši rundo",
          "tournament_continue_soon":
              "Turnir se bo nadaljeval kmalu. Prosimo, ostanite.",
          "tournament_ending":
              "Turnir se končuje, rejting se kalkulira. Igra se bo kmalu končala, s tem pa boste tudi prejeli spremembo rejtinga. Hvala za udeležbo.",
          "handle": "Uporabniško ime (prikazano drugim uporabnikom)",
          "tos_text":
              "Z registracijo se strinjate z našimi pogoji uporabe (gumb spodaj za branje le-teh). Če ne želite ustvariti uporabniškega računa, lahko uporabite dostop brez povezave.",
          "handle_change": "Sprememba uporabniškega imena",
          "change_of_handle_desc1":
              "Zamenjava uporabniškega imena je brezplačna in prosto dostopna vsem.",
          "change_of_handle_desc2":
              "V primeru neprimernega uporabniškega imena, bodo administratorji spremenili ime, uporabniku pa se lahko po večkratnih kršitvah zakleni uporabniški račun.",
          "handle_desc":
              "Uporabniško ime je edinstveno in vas identificira pri ostalih uporabnikih. Dovoljeni so vsi znaki angleške abecede, števke in vezaj (-), pika (.) ter podčrtaj (_).",
          "change_of_handle_desc4": "Vaše trenutno uporabniško ime je: @name",
          "user_current_handle":
              "Uporabnikovo trenutno uporabniško ime je @name.",
          "speed": "Hitrost delovanja botov",
          "all_values_in_seconds": "Vse vrednosti so podane v sekundah.",
          "next_round_speed": "Razmik med igrama",
          "general_bot_delay": "Splošen razmik med boti",
          "card_cleanup_delay": "Razmik med brisanjem štiha",
          "current_rating": "Trenutni rating igralca: ",
          "edit_testers": "Uredi testerje",
          "testers": "Testerji",
          "invite_tournament_singular_private":
              "@who vas kot testerja vabi na uradni Palčka turnir ",
          "invite_tournament_dual_private":
              "@who vas kot testerja vabita na uradni Palčka turnir ",
          "invite_tournament_plural_private":
              "@who vas kot testerja vabijo na uradni Palčka turnir ",
          "invite_tournament_rated_private":
              "Turnir se vam kot testerju ne šteje k rejtingu. V primeru, da želite, da se vam in še niste videli kart, kontaktirajte administratorja.",
          "start_tournament_testing": "Začni turnirsko testiranje",
          "tournament_testing_description":
              "Hvala, ker sodelujete v testiranju turnirja. Preden začnete moram podati še nekaj splošnih navodil.\nTestirate za @division. divizijo.\n1. divizija ima najtežje roke, igralci tam sprejemajo najtežje odločitve, ki so lahko zelo riskantne, ne pa nujno nagrajujoče.\n2. divizija ima težke roke, primernejša je za bolj izkušene igralce, igralci sprejemajo težke odločitve, ki so lahko zelo riskantne, a v večini časov nagrajujoče (to vključuje igro berača, odprtega berača, barvnega valata, valata ipd.)\n3. divizija je namenjena predvsem začetnikom, pogosto ni težkih odločitev, karte so dokaj jasne in pogosto ni riskantne igre, kadar pa je, je v 90% časa nagrajujoča.\n4. divizija je namenjena absolutnim začetnikom. Karte so večinoma take, da ima igralec jasne odločitve med igrami, riskantne igre/poteze so vedno nagrajujoče, če so.\nV 3. in 4. diviziji se poskušamo izogniti valatu in barvnemu valatu.\nS tem, ko testirate, se odpoveste vsemu sodelovanju v rejtanem turnirju (še vedno lahko sodelujete nerejtano, a posledično ne boste prejeli rejtinga).\nOb kliku na gumb Začni, se bo ustvarila nova soba, na voljo samo vam.\nIgri se lahko priključite kadarkoli do konca virtualnega (testnega) turnirja.\nIgra se začne v roku ene minute od klika na gumb Začni.\nUživajte v testiranju :).",
          "start": "Začni",
          "tournament_testing": "Turnirsko testiranje",
          "open_settings": "Odpri nastavitve",
          "edit_round": "Uredi rundo",
          "cards": "Karte",
          "diamonds": "Kara",
          "cards_guide_desc":
              "Spodaj lahko vidite karte, uporabljene za tarok. Te so razvrščene od najnižje do najvišje po vsaki vrsti. Vrednost kart v igri je 5 za trulo in kralje, 4 za dame, 3 za kavale, 2 za pobe in 1 za vse ostale karte.",
          "guide": "Vodič",
          "spades": "Pik",
          "hearts": "Src",
          "clubs": "Križ",
          "tarocks": "Taroki",
          "tarocks_desc":
              "Taroki so posebne karte, ki lahko poberejo katerokoli barvo. V primeru, da pade naenkrat več tarokov, najvišji tarok pobere karto. Vsi so označeni s številko, z izjemo škisa, ki velja za tarok 22 in pobere vse. Vsi taroki se poimenujejo po številski vrednosti, razen 1. (pagat, palica ali palčka), 21. (mond) in 22. (škis). Skupaj ti trije taroki sestavljajo trulo.",
          "general_card_play_rules": "Splošna pravila metanja kart",
          "card_play_rules":
              "Pri vseh igrah se lahko začne s čimerkoli, tj. s tarokom ali z barvo. Če igralec začne z barvo, morate nujno dati to isto barvo. Če nimate te barve, vržete taroka. Če pa tudi taroka nimate, vržete poljubno karto. Podobno velja, če igralec začne s tarokom. Če imate taroka, vržete taroka, drugače pa poljubno karto. Metanje palčke pri igri berača, odprtega berača in klopa je omejeno na zadnji tarok. Prvi štih igre začne obvezni igralec, če igra ne predpisuje drugače.",
          "licitation": "Licitatacija igre",
          "licitation_desc":
              "Vsaka igra se začne z licitiranjem. V tem postopku napoveste, katero igro bi radi šli igrat, če bi sploh radi šli kakšno. Če nimate kart za nobeno igro, kliknite pojdite naprej (oz. dalje). Nanizane so vse možne igre, od najmanj vredne do najbolj vredne. V primeru, da želita dva igralca isto igro, ima prednost obvezni (tj. zadnji igralec, ki ima pravico do licitiranja). Pri večini iger zmagate, če s soigralcem (če ga imate) pobereta vsaj 36 točk. V takem primeru se šteje tudi razlika, ki je (število pobranih točk - 35).",
          "three_only_mand": "Tri (samo obvezni)",
          "three_gameplay":
              "V igri tri se bo talon razdelil na dva kupčka po tri karte. Izberete enega od teh kupčkov in si založite tri karte. V igri s štirimi igralci imate pravico do izbire soigralca. Igra je vredna 10 točk.",
          "two_gameplay":
              "V igri dve se bo talon razdelil na tri kupčke po dve karti. Izberete enega od teh kupčkov in si založite dve karti. V igri s štirimi igralci imate pravico do izbire soigralca. Igra je vredna 20 točk.",
          "one_gameplay":
              "V igri ena se bo talon razdelil na šest kupčkov po eno karto. Izberete enega od teh kupčkov in si založite eno karto. V igri s štirimi igralci imate pravico do izbire soigralca. Igra je vredna 30 točk.",
          "solo_three_only_four": "Solo tri (samo v igri s štirimi igralci)",
          "solo_three_gameplay":
              "V igri solo tri se bo talon razdelil na dva kupčka po tri karte. Izberete enega od teh kupčkov in si založite tri karte. Nimate pravice do izbire soigralca. Iz te igre lahko napoveste barvnega valata. Igra je vredna 40 točk.",
          "solo_two_only_four": "Solo dve (samo v igri s štirimi igralci)",
          "solo_two_gameplay":
              "V igri solo dve se bo talon razdelil na tri kupčke po dve karti. Izberete enega od teh kupčkov in si založite dve karte. Nimate pravice do izbire soigralca. Iz te igre lahko napoveste barvnega valata. Igra je vredna 50 točk.",
          "solo_one_only_four": "Solo ena (samo v igri s štirimi igralci)",
          "solo_one_gameplay":
              "V igri solo ena se bo talon razdelil na šest kupčkov po eno karto. Izberete enega od teh kupčkov in si založite eno karto. Nimate pravice do izbire soigralca. Iz te igre lahko napoveste barvnega valata. Igra je vredna 60 točk.",
          "beggar_gameplay":
              "V igri berač ne vidite talona do konca igre, prav tako ni posebnih napovedi. S to igro napoveste, da ne boste pobrali nobene karte čez celoten potek igre. Takoj ko jo, se igra zaključi. Prvi štih začnete vi. Igra je vredna 70 točk.",
          "solo_without_gameplay":
              "V igri solo brez ne vidite talona do konca igre, prav tako ni posebnih napovedi. S to igro napoveste, da boste pobrali več kot 35 točk. Igra je vredna 80 točk, razlika se pri tej igri ne šteje.",
          "open_beggar_gameplay":
              "Odprti berač je igra, ki temelji na istem principu kot berač, s tem da morate nasprotnikom skozi celoten potek igre kazati svoje karte. Prvi štih začnete vi. Igra je vredna 90 točk.",
          "color_valat_only_four":
              "Barvni valat (samo v igri s štirimi igralci)",
          "color_valat_gameplay":
              "V igri barvni valat ne vidite talona (razen v primeru, ko je bil napovedan iz solo igre) do konca igre, prav tako ni posebnih napovedi. S to igro napoveste, da boste pobrali vse karte. Takoj ko ne poberete enega štiha, se igra zaključi. Vse štihe začenjate vi. Talon pripada vam. Poleg tega barvni valat obrne pravila taroka in predpiše, da je barva vredna več od taroka (barva pobere taroka). Igra je vredna 125 točk, razlika se pri tej igri ne šteje.",
          "valat_gameplay":
              "V igri valat ne vidite talona (razen v primeru, ko je bil napovedan iz solo igre) do konca igre, prav tako ni posebnih napovedi. S to igro napoveste, da boste pobrali vse karte. Takoj ko ne poberete enega štiha, se igra zaključi. Vse štihe začenjate vi. Talon pripada vam. Igra je vredna 500 točk (če ga naredite brez napovedi, se šteje samo polovično), razlika se pri tej igri ne šteje.",
          "klop_gameplay":
              "Igra klop se zgodi le v primeru, da grejo igralci naprej/dalje. V tem primeru igra vsak igralec zase in mora pobrati čim manj točk. Če igralec pobere več kot 35 točk je poln in piše -70, vsi ostali igralci pa 0. Če igralec ničesar ne pobere je prazen in piše 70, vsi ostali igralci pa 0. V nasprotnem primeru pišejo igralci tolikor, kolikor so pobrali skozi celotno igro v minus. V prvih šestih štihih se sproti odkriva talon, katerega vrhnja karta je podeljena igralcu, ki je pobral štih.",
          "stashing": "Zalaganje",
          "stashing_desc":
              "Založite si lahko vse karte, katere trenutno držite z izjemo trule in kraljev. Karte, ki si jih založite avtomatično pripadajo vam, preostanek iz talona pa nasprotni ekipi. Če si založite taroke, morajo vsi videti, katere ste si založili. Če si založite barve, teh kart drugi igralci ne smejo videti.",
          "king_calling": "Klicanje kralja",
          "king_calling_desc":
              "V igri s štirimi igralci imate pravico izbrati soigralca, če ste šli igrati igro, ki to dovoli. Preden se odpre talon, izberete enega izmed kraljev. Tisti, ki v roki drži klicanega kralja, je soigralec igralca v aktivni ekipi (v tem primeru vaši ekipi). Kdo ima kralja, se ne ve, dokler se ta igralec ne razkrije z igro ali z napovedjo kralja ultima. Če slučajno kličete kralja, ki je v talonu, ste se \"zarufali\". V takem primeru lahko vzamete delček talona, ki vsebuje porufanega kralja in če ga pripeljete naokoli, dobite tudi drugi del talona. Če ga ne izberete, preostanek talona pripada nasprotni ekipi (pasivni ekipi).",
          "predictions": "Napovedi",
          "predictions_desc":
              "Napovedi so zelo pomemben del igre, saj povečajo težavnost igre in lahko ob pravilni uporabi prinesejo mnogo več točk.",
          "description": "Opis",
          "worth": "Vrednost",
          "trula_desc":
              "Z napovedjo trule napoveste, da bo vaša ekipa (aktivna ali pasivna) na koncu igre imela celotno trulo (škisa, monda in palčko)",
          "kings_desc":
              "Z napovedjo kraljev napoveste, da bo vaša ekipa (aktivna ali pasivna) na koncu igre imela vse kralje",
          "king_ultimo_desc":
              "Z napovedjo kralja ultima se zavezujete, da bo klican kralj padel v zadnjem štihu igre in bo ali ta kralj pobral celoten štih ali pa bo soigralec pobral kralja. S tem se prav tako razkrivate, da imate klicanega kralja in posledično pripadate aktivni ekipi. Ta napoved je na voljo samo v igri s štirimi igralci, kjer je na voljo klicanje kralja. Kralj ultimo lahko napove samo oseba s klicanim kraljem.",
          "pagat_ultimo_desc":
              "Z napovedjo pagat ultima se zavezujete, da bo pagat padel v zadnjem štihu igre in bo pagat pobral celoten štih. Pagat ultimo lahko napove samo oseba s pagatom. Oseba lahko napove pagat ultimo ne glede na to, ali je v aktivni ali pasivni ekipi.",
          "color_valat_pred_desc":
              "Z napovedjo barvnega valata se zavezujete, da spremenite igro v barvnega valata iz ene izmed solo iger. Barvni valat lahko napove samo oseba, ki je licitirala originalno igro.",
          "valat_pred_desc":
              "Z napovedjo valata se zavezujete, da spremenite igro v valata. Valata lahko napove samo oseba, ki je licitirala originalno igro.",
          "mondfang_desc":
              "V modificirani igri se da opaziti tudi napoved mondfanga. To pomeni, da napoveste, da bo oseba, ki ima monda prejela -42 za ujetje monda.",
          "kontra_availability": "Kontra na voljo",
          "up_to_mort": "Vse do mortkontre (16x)",
          "discards_predictions_transforms_into_game":
              "Ne upošteva vseh napovedi, se pretvori v igro.",
          "game_can_kontra": "Igro se lahko kontrira",
          "mondfang_rule":
              "Če v talonu pustite monda ali če vam ga nasprotnik ujame, pišete -21 kot kazen za ujetje monda.",
          "pagat_picks": "Če pade celotna trula v enem štihu, pobere pagat.",
          "kontra_desc":
              "Kontra se uporabi, ko igralec nasprotne ekipe meni, da so napovedi neupravičene (jih lahko prestreže). Vsaka kontra še dodatno podvoji celoten seštevek točk pri napovedi. Pri kontri na igro se kontrirata tako igra kot tudi razlika.",
          "open_guide": "Odpri vodič",
          "radelci": "Radelci",
          "radelci_desc":
              "Radelci so dani vsem igralcem, ko se je igralo vsaj berača (ali klopa). Radelci so zastopani z manjšimi krogci (✪). Vsak radelc lahko podvoji točke igralcem v bodočih igrah. V primeru, da je igra pozitivna, radelc podvoji skupni seštevek igre in se izbriše. V primeru, da igra ni pozitivna, podvoji skupni seštevek igre in se ne izbriše. Na koncu celotne igre se za vsak neporabljen radelc odšteje 40 točk.",
          "quiet_predictions":
              "Če igralci niso dovolj prepričani v možnosti za izvedbe določene napovedi, lahko še vedno delajo t. i. \"tihe\" napovedi, kjer ničesar ne napovejo, a konec koncev še vedno naredijo napoved. V primeru, da ne naredijo tihe napovedi se ničesar ne piše, a če jo naredijo, dobijo polovico točk originalne napovedi. Tihe napovedi ne morejo biti napovedane.",
          "toggle_red_filter": "Preklopi rdeči filter",
          "toggle_red_filter_desc":
              "Izklopi oz. vključi rdeči filter nad kartami, ki prikazuje veljavnost kart. Velja samo za vmesni čas, ko ni vaš čas za igranje.",
          "api_url": "URL naslov API-ja",
          "api_url_desc":
              "POZOR! Če niste prepričani, kaj delate, ne spreminjajte. To lahko odpre možnost za napadalce, ki lahko ukradejo prijavni piškotek, če boste spreminjali to vrednost. Ker je Palčka odprtokoden program lahko kdorkoli gosti strežnik. Če si kdo želi slučajno igrati na lastnem strežniku, lahko tukaj spremeni API naslov, ki je privzeto https://palcka.si/api. Na spletu je možno, da ne deluje zaradi CORS politike.",
          "tournament_statistics": "Turnirska statistika",
          "refresh_stats": "Osveži statistiko",
          "delete_profile_picture": "Izbriši profilno sliko",
          "change_profile_picture": "Spremeni profilno sliko",
          "previous_game_stats":
              "V prejšnji igri ste držali @place. mesto od @total. Najboljši igralec je imel @bestPoints točk.",
          "register_tournament": "Prijavi se",
          "unregister_tournament": "Odjavi se",
          "counterclockwise_gameplay": "Igra v nasprotni smeri urinega kazalca",
          "counterclockwise_gameplay_desc":
              "Igra bo potekala v nasprotni smeri urinega kazalca. Ko to vključite, morate zapustiti igro.",
          "reset_websocket": "Resetiraj WebSocket povezavo",
          "points_prediction": "@points točk",
          "enable_points_tooltip": "Vključi prikaze točk za igre",
          "enable_points_tooltip_desc":
              "Vrednost vseh iger se bo prikazala na zaslonu med igro. Igro boste morali znova zagnati, da se spremembe uveljavijo.",
          "accessibility": "Dostopnost",
          "bot_plays": "Boti 🤖 igrajo \"@game\" @times-krat",
          "player_plays": "Igralci 👤 igrajo \"@game\" @times-krat",
          "other_players_are_playing": "Drugi igralci igrajo naslednje igre",
          "show_evaluation": "Prikaži evaluacijo",
          "show_evaluation_desc":
              "Prikaže trenutno StockŠkis evaluacijo v igrah brez internetne povezave (offline/z boti).",
          "show_most_powerful_card": "Prikaži najbolj močno karto",
          "show_most_powerful_card_desc":
              "Označi trenutno najbolj močno karto v rundi z rdečo.",
          "game_number": "Igra #@gameNumber",
          "game_log_beta": "Zgodovina iger (beta)",
          "game_log": "Zgodovina iger",
          "game_ended": "Igra se je končala",
          "game_ended_subtitle": "Sistem je končal igro.",
          "game_started": "Igra se je začela",
          "game_started_subtitle": "Sistem je začel igro.",
          "licitation_started": "Licitacija se je začela",
          "licitation_started_subtitle":
              "Uporabnik @player je začel z licitacijo.",
          "user_licitated": "Uporabnik je licitiral",
          "user_licitated_subtitle": "Uporabnik @player je licitiral.",
          "licitations_done": "Licitacije so se končale",
          "licitations_done_subtitle":
              "Uporabnik @player je zmagal licitacije.",
          "king_selection_started": "Klicanje kralja se je začelo",
          "king_selection_started_subtitle": "Uporabnik @player kliče kralja.",
          "king_selection_done": "Kralj je bil klican",
          "king_selection_done_subtitle":
              "Uporabnik @player je izbral kralja. Izbira kralja se je s tem končala.",
          "talon_open": "Talon se je odprl",
          "talon_open_subtitle":
              "Talon se je odprl vsem. Uporabnik @player sedaj izbira del talona, ki ga želi.",
          "talon_selected": "Talon je bil izbran",
          "talon_selected_subtitle":
              "Uporabnik @player je izbral del talona, ki ga želi. S tem se je zaključila izbira talona.",
          "card_stashing_started": "Zalaganje kart se je začelo",
          "card_stashing_started_subtitle":
              "Uporabnik @player zdaj razmišlja, katere karte bi založil. Uporabnik @player mora založiti @cardAmount kart.",
          "card_stashed": "Karta je bila založena",
          "card_stashed_subtitle": "Uporabnik @player je založil karte.",
          "card_stashing_done": "Zalaganje kart se je končalo",
          "card_stashing_done_subtitle":
              "Zalaganje kart se je končalo. Uporabnik @player je založil @cardAmount kart.",
          "talon_closed": "Talon se je zaprl",
          "talon_closed_subtitle": "Talona ne more videti nihče do konca igre.",
          "predictions_started": "Napovedi so se začele",
          "predictions_started_subtitle":
              "Uporabnik @player je prva oseba, ki lahko napove potencialne izide igre.",
          "predicted": "Napoved: ",
          "kontra_predicted": "Kontra: ",
          "user_predicted": "Uporabnik se je odločil za napovedi",
          "user_predicted_subtitle":
              "Uporabnik @player se ni odločil za kakršnekoli napovedi ali pa se je odločil za naslednje napovedi.\n@finalNames",
          "predictions_done": "Napovedi so se končale",
          "predictions_done_subtitle":
              "Vsi igralci so napovedali svoje. S tem so se napovedi končale.",
          "card_game_started": "Igra s kartami se je začela",
          "card_game_started_subtitle": "Sistem je začel igro s kartami.",
          "card_round_started": "Runda se je začela",
          "card_round_started_subtitle": "Uporabnik @player začne rundo.",
          "card_dropped": "Karta je padla",
          "system_card_dropped_subtitle":
              "Sistem je vrgel to karto ali zaradi zarufa (uporabnik je pobral štih s klicanim kraljem) ali ker se igra klopa (vsi igralci so klicali dalje/naprej med licitiranjem).",
          "card_dropped_subtitle": "Uporabnik @player je položil karto.",
          "card_round_done": "Runda se je končala",
          "card_round_done_subtitle":
              "Uporabnik @player je zmagal to rundo in zato začne naslednjo rundo.",
          "game_prediction": "Igra",
          "round_number": "Runda @roundNumber",
          "save_game_logs": "Shranjuj zgodovino iger",
          "save_game_logs_desc":
              "Če je to vključeno, bodo vaše igre z boti shranjene. Igre ne bodo nikoli zapustile vaše naprave in bodo shranjene za kasnejši ogled preko funkcije Zgodovina iger. Pazite, ker lahko shranjene igre hitro postanejo velike, zaradi česar jih boste morali občasno počistiti.",
          "clear_game_logs": "Počisti zgodovino lokalnih iger",
        }
      };
}
