import 'package:get/get.dart';

class Messages extends Translations {
  @override
  Map<String, Map<String, String>> get keys => {
        'en_US': {
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
          "friend_email": "Friend's e-mail address",
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
              ". Tournament is@israted counting towards your rating.",
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
        },
        'sl_SI': {
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
          "friend_email": "Elektronski naslov prijatelja",
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
          "tournament_rated": ". Turnir se@israted šteje k vašemu rejtingu.",
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
        }
      };
}
