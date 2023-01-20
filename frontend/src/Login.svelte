<script lang="ts">
    import {link, navigate} from "svelte-navigator";
    import {BASE_URL} from "./consts.js";

    let email = "";
    let password = "";
</script>

<div style="display:flex;justify-content:center;align-items:center;">
    <div>
        <h1>Prijava v Tarok portal</h1>
        <div>
            <label for="email">Elektronski naslov:</label>
            <input type="email" id="email" name="email" bind:value={email}>
            <br>
            <label for="email">Geslo:</label>
            <input type="password" id="password" name="password" bind:value={password}>
        </div>
        <p/>
        <button id="login" on:click={async () => {
            let fd = new FormData();
            fd.append("email", email)
            fd.append("pass", password);
            let r = await fetch(`${BASE_URL}/login`, {body: fd, method: "POST"});
            let json = await r.json();
            localStorage.setItem("token", json["token"]);
            localStorage.setItem("name", json["name"]);
            localStorage.setItem("id", json["user_id"]);
            navigate("/")
        }}>Prijava</button>
        <p/>
        Še niste uporabnik? Registrirajte se <a use:link href="/register">tukaj</a>.
    </div>
</div>
