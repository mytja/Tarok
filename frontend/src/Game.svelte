<script lang="ts">
    import {onMount, to_number} from "svelte/internal";
    import {Websocket} from "./ws.js";
    import {navigate} from "svelte-navigator";
    import {Card, Licitiranje, LoginInfo, Message, Send} from "./messages";

    let POINTS = [
        /*[
            {id: "", name: "/", playing: true, bidding: true, difference: 30},
            {id: "", name: "/", playing: true, bidding: false, difference: 30},
            {id: "", name: "/", playing: false, bidding: false, difference: 0},
            {id: "", name: "/", playing: false, bidding: false, difference: 0},
        ]*/
    ];
    const CARDS = [
        {file: "/kara/1", worth: 1, worthOver: 4, alt: "1 kara"},
        {file: "/kara/2", worth: 1, worthOver: 3, alt: "2 kara"},
        {file: "/kara/3", worth: 1, worthOver: 2, alt: "3 kara"},
        {file: "/kara/4", worth: 1, worthOver: 1, alt: "4 kara"},
        {file: "/kara/pob", worth: 2, worthOver: 5, alt: "Kara pob"},
        {file: "/kara/kaval", worth: 3, worthOver: 6, alt: "Kara kaval"},
        {file: "/kara/dama", worth: 4, worthOver: 7, alt: "Kara dama"},
        {file: "/kara/kralj", worth: 5, worthOver: 8, alt: "Kara kralj"},

        {file: "/kriz/7", worth: 1, worthOver: 1, alt: "7 križ"},
        {file: "/kriz/8", worth: 1, worthOver: 2, alt: "8 križ"},
        {file: "/kriz/9", worth: 1, worthOver: 3, alt: "9 križ"},
        {file: "/kriz/10", worth: 1, worthOver: 4, alt: "10 križ"},
        {file: "/kriz/pob", worth: 2, worthOver: 5, alt: "Križ pob"},
        {file: "/kriz/kaval", worth: 3, worthOver: 6, alt: "Križ kaval"},
        {file: "/kriz/dama", worth: 4, worthOver: 7, alt: "Križ dama"},
        {file: "/kriz/kralj", worth: 5, worthOver: 8, alt: "Križ kralj"},

        {file: "/pik/7", worth: 1, worthOver: 1, alt: "7 pik"},
        {file: "/pik/8", worth: 1, worthOver: 2, alt: "8 pik"},
        {file: "/pik/9", worth: 1, worthOver: 3, alt: "9 pik"},
        {file: "/pik/10", worth: 1, worthOver: 4, alt: "10 pik"},
        {file: "/pik/pob", worth: 2, worthOver: 5, alt: "Pik pob"},
        {file: "/pik/kaval", worth: 3, worthOver: 6, alt: "Pik kaval"},
        {file: "/pik/dama", worth: 4, worthOver: 7, alt: "Pik dama"},
        {file: "/pik/kralj", worth: 5, worthOver: 8, alt: "Pik kralj"},

        {file: "/src/1", worth: 1, worthOver: 4, alt: "1 src"},
        {file: "/src/2", worth: 1, worthOver: 3, alt: "2 src"},
        {file: "/src/3", worth: 1, worthOver: 2, alt: "3 src"},
        {file: "/src/4", worth: 1, worthOver: 1, alt: "4 src"},
        {file: "/src/pob", worth: 2, worthOver: 5, alt: "Src pob"},
        {file: "/src/kaval", worth: 3, worthOver: 6, alt: "Src kaval"},
        {file: "/src/dama", worth: 4, worthOver: 7, alt: "Src dama"},
        {file: "/src/kralj", worth: 5, worthOver: 8, alt: "Src kralj"},

        {file: "/taroki/pagat", worth: 5, worthOver: 11, alt: "Pagat"},
        {file: "/taroki/2", worth: 1, worthOver: 12, alt: "2"},
        {file: "/taroki/3", worth: 1, worthOver: 13, alt: "3"},
        {file: "/taroki/4", worth: 1, worthOver: 14, alt: "4"},
        {file: "/taroki/5", worth: 1, worthOver: 15, alt: "5"},
        {file: "/taroki/6", worth: 1, worthOver: 16, alt: "6"},
        {file: "/taroki/7", worth: 1, worthOver: 17, alt: "7"},
        {file: "/taroki/8", worth: 1, worthOver: 18, alt: "8"},
        {file: "/taroki/9", worth: 1, worthOver: 19, alt: "9"},
        {file: "/taroki/10", worth: 1, worthOver: 20, alt: "10"},
        {file: "/taroki/11", worth: 5, worthOver: 21, alt: "11"},
        {file: "/taroki/12", worth: 1, worthOver: 22, alt: "12"},
        {file: "/taroki/13", worth: 1, worthOver: 23, alt: "13"},
        {file: "/taroki/14", worth: 1, worthOver: 24, alt: "14"},
        {file: "/taroki/15", worth: 1, worthOver: 25, alt: "15"},
        {file: "/taroki/16", worth: 1, worthOver: 26, alt: "16"},
        {file: "/taroki/17", worth: 1, worthOver: 27, alt: "17"},
        {file: "/taroki/18", worth: 1, worthOver: 28, alt: "18"},
        {file: "/taroki/19", worth: 1, worthOver: 29, alt: "19"},
        {file: "/taroki/20", worth: 1, worthOver: 30, alt: "20"},
        {file: "/taroki/mond", worth: 5, worthOver: 31, alt: "Mond"},
        {file: "/taroki/skis", worth: 5, worthOver: 32, alt: "Škis"},
    ];

    const GAMES = [
        {id: -1, name: "Naprej", plays_three: true},
        {id: 0, name: "Tri", plays_three: true},
        {id: 1, name: "Dva", plays_three: true},
        {id: 2, name: "Ena", plays_three: true},
        {id: 3, name: "Solo tri", plays_three: false},
        {id: 4, name: "Solo dva", plays_three: false},
        {id: 5, name: "Solo ena", plays_three: false},
        {id: 6, name: "Berač", plays_three: true},
        {id: 7, name: "Solo brez", plays_three: true},
        {id: 8, name: "Odprti berač", plays_three: true},
        {id: 9, name: "Barvni valat", plays_three: true},
        {id: 10, name: "Valat", plays_three: true},
    ]

    let myCards = [];
    export let id;

    function sortCards(cards) {
        let sorted = {"piki": [], "kare": [], "krizi": [], "srci": [], "taroki": []};
        for (let i in cards) {
            let card = cards[i];
            let type = "taroki";
            if (card.file.includes("src")) type = "srci";
            if (card.file.includes("pik")) type = "piki";
            if (card.file.includes("kriz")) type = "krizi";
            if (card.file.includes("kara")) type = "kare";
            sorted[type].push(card);
        }
        console.log(sorted)
        const sortFunc = (a,b) => a.worthOver - b.worthOver;
        sorted["piki"].sort(sortFunc);
        sorted["kare"].sort(sortFunc);
        sorted["krizi"].sort(sortFunc);
        sorted["srci"].sort(sortFunc);
        sorted["taroki"].sort(sortFunc);
        myCards = [...sorted["piki"], ...sorted["kare"], ...sorted["krizi"], ...sorted["srci"], ...sorted["taroki"]];
        console.log(myCards)
    }

    function licitiranje(tip: number) {
        socket.sendMessage(new Message({game_id: id, licitiranje: new Licitiranje({type: tip})}))
    }

    function putCard(id: string) {
        if (!putCardDown) return;
        let cards = [];
        for (let i in myCards) {
            if (myCards[i].file !== id) cards.push(myCards[i]);
        }
        myCards = cards;
        socket.sendMessage(new Message({game_id: id, card: new Card({id: id, send: new Send()})}))
        putCardDown = false;
    }

    let putCardDown = false;

    function handleMessage(msg) {
        if (msg.has_card) {
            const card = msg.card;
            if (card.has_receive) {
                const id = card.id;
                console.log(card, id);
                for (let c in CARDS) {
                    if (CARDS[c].file === id) {
                        myCards.push(CARDS[c])
                        break;
                    }
                }
                myCards = myCards;
                sortCards(myCards);
            } else if (card.has_request) {
                licitirajRN = false;
                licitiraj = false;
                putCardDown = true;
            } else if (card.has_send) {
                const id = card.id;
                const player_id = msg.player_id;
                console.log(id, player_id);
                for (let i in CARDS) {
                    if (id !== CARDS[i].file) continue;
                    for (let n in players) {
                        const player = players[n];
                        if (player.id !== player_id) continue;
                        stih.push({card: CARDS[i], position: to_number(n)});
                        console.log("found", stih);
                        stih = stih;
                        return;
                    }
                }
            }
        }
        if (msg.has_connection) {
            //console.log("conn", msg);
            const username = msg.username;
            const id = msg.player_id;
            const connection = msg.connection;
            if (connection.has_join) {
                players.push({id: id, username: username, licitiranje: -2});
                players = players;
            } else {
                let newPlayers = [];
                for (let i in players) {
                    if (players[i].id !== id) {
                        newPlayers.push(players[i]);
                    }
                }
                players = newPlayers;
            }
            console.log(players)
        }
        if (msg.has_game_start) {
            const game = msg.game_start;
            licitiraj = true;
            let newPlayers = [];
            for (let i in game.user) {
                const user = game.user[i];
                console.log(user);
                newPlayers.push({id: user.id, username: user.name, licitiranje: -2, position: user.position});
            }
            for (let i = 0; i < newPlayers.length; i++) {
                const player = newPlayers[0];
                if (player.id === localStorage.getItem("id")) break;
                newPlayers.shift()
                newPlayers.push(player)
            }
            players = newPlayers;
            hasStarted = true;
        }
        if (msg.has_login_request) {
            socket.sendMessage(new Message({username: "", player_id: "", game_id: id, login_info: new LoginInfo({token: localStorage.getItem("token")})}))
        }
        if (msg.has_licitiranje_start) {
            licitirajRN = true;
        }
        if (msg.has_licitiranje) {
            const userId = msg.player_id;
            const licitiranje = msg.licitiranje;
            const type = licitiranje.type;
            currentGames = [];
            for (let i in GAMES) {
                if (GAMES[i].id === -1 || GAMES[i].id > type) {
                    currentGames.push(GAMES[i]);
                }
            }
            if (userId === localStorage.getItem("id")) {
                licitirajRN = false;
            }
            console.log(msg)
            console.log(players);
            for (let i in players) {
                let player = players[i];
                if (player.id === userId) {
                    console.log("found", userId);
                    players[i].licitiranje = type;
                    break;
                }
            }
            console.log(players);
        }
        if (msg.has_clear_desk) {
            stih = [];
        }
        if (msg.has_results) {
            console.log("results");
            let t = [];
            const results = msg.results;
            const players = results.user;
            for (let i in players) {
                const player = players[i];
                let points = player.points;
                t.push({id: player.user.id, name: player.user.name, playing: player.playing, bidding: player.playing, difference: points});
            }
            POINTS.push(t);
            POINTS = POINTS;
            console.log(POINTS);
        }
    }

    let currentGames = [...GAMES];
    let players = [{id: localStorage.getItem("id"), username: localStorage.getItem("name"), licitiranje: -2}];

    let stih = [];

    let socket;
    let hasStarted = false;
    let licitiraj = false;
    let licitirajRN = false;

    onMount(async () => {
        socket = new Websocket(id, handleMessage);
    })
</script>

<main>
    <div class="bottom-bar">
        {#each myCards as card, i}
            <div class="card" style="z-index: {i}; left: {i*-20}px; rotate: {Math.random()+5}deg;" on:click={() => {
                putCard(card.file);
            }}>
                <img class="{putCardDown ? '' : 'disabled'} card-simple" src="/tarok{card.file}.webp" alt={card.alt}>
            </div>
        {/each}
    </div>
    <div class="deck">
        {#each stih as karta, i}
            <img
                    src="/tarok{karta.card.file}.webp"
                    alt={karta.card.alt}
                    class="deck-card {karta.position === 0 ? 'top' : karta.position === 1 ? 'right rotate' : karta.position === 2 ? 'bottom' : 'left rotate'}"
                    style="z-index: {i};"
            >
        {/each}
    </div>
    {#each players as player, i}
        {#if player.id !== localStorage.getItem("id")}
            {#if i === 1}
                <div class="left absolute">
                    <h3>{player.username}</h3>
                </div>
            {/if}
            {#if i === 2}
                <div class="top absolute">
                    <h3>{player.username}</h3>
                </div>
            {/if}
            {#if i === 3}
                <div class="right absolute">
                    <h3>{player.username}</h3>
                </div>
            {/if}
        {/if}
    {/each}
    <div class="top left absolute">
        {#if !hasStarted}
            <button on:click={async () => {
                socket.close();
                navigate("/");
            }}>Zapusti igro</button>
        {/if}
        {#if licitiraj}
            <div class="paper">
                <table>
                    <tr>
                        {#each players as humanBeing}
                            <th>{humanBeing.username}</th>
                        {/each}
                    </tr>
                    <tr>
                        {#each players as humanBeing}
                            {#if humanBeing.licitiranje > -2}
                                <td>{GAMES[humanBeing.licitiranje+1].name}</td>
                            {:else}
                                <td/>
                            {/if}
                        {/each}
                    </tr>
                </table>
                {#if licitirajRN}
                    {#each currentGames as game}
                        <button on:click={() => licitiranje(game.id)}>{game.name}</button>
                    {/each}
                {/if}
            </div>
        {/if}
    </div>
    <div class="right-bar">
        <table>
            <tr>
                {#each players as humanBeing}
                    <th>{humanBeing.username}</th>
                {/each}
            </tr>
            {#each POINTS as game}
                <tr>
                    {#each players as humanBeing}
                        {#each game as human}
                            {#if human.id === humanBeing.id}
                                {#if human.difference !== 0 || (human.playing && human.playing)}
                                    <td class="{human.difference > 0 ? 'positive' : 'negative'}">{human.difference}</td>
                                {:else}
                                    <td/>
                                {/if}
                            {/if}
                        {/each}
                    {/each}
                </tr>
            {/each}
        </table>
    </div>
</main>

