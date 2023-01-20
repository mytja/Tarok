<script>
    import {onMount} from "svelte/internal";
    import {BASE_URL} from "./consts.ts";

    export let navigate;
    export let location;

    let popup = false;

    async function getGames() {
        let fd = new FormData();
        fd.append("token", localStorage.getItem("token"))
        let r = await fetch(`${BASE_URL}/games`, {body: fd, method: "POST"});
        games = await r.json();
    }

    onMount(async () => {
        const token = localStorage.getItem("token");
        console.log(token)
        if (token === undefined || token === null || token === "") {
            console.log("navigating to login")
            navigate("/login");
            return;
        }
        await getGames();
    })

    let games = [];
</script>

<div class="absolute left top">
    <button on:click={() => popup = true}>Nova igra</button>
    <button on:click={async () => await getGames()}>Osveži igre</button>
    {#each games as game}
        <h4 on:click={() => navigate(`/game/${game}`)}>{game}</h4>
    {/each}
</div>
{#if popup}
    <div class="absolute center">
        <div class="paper">
            <div class="top right">
                <span class="material-icons" on:click={() => popup = false}>close</span>
            </div>
            <div class="break"></div>
            <div class="bottom">
                <button on:click={async () => {
                    let fd = new FormData();
                    fd.append("token", localStorage.getItem("token"))
                    let r = await fetch(`${BASE_URL}/game/new/3`, {body: fd, method: "POST"});
                    let response = await r.text()
                    navigate(`/game/${response}`);
                }}>V tri</button>
                <div class="break"></div>
                <button on:click={async () => {
                    let fd = new FormData();
                    fd.append("token", localStorage.getItem("token"))
                    let r = await fetch(`${BASE_URL}/game/new/4`, {body: fd, method: "POST"});
                    let response = await r.text()
                    navigate(`/game/${response}`);
                }}>V štiri</button>
            </div>
        </div>
    </div>
{/if}
