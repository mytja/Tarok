<script lang="ts">
    import {link, navigate} from "svelte-navigator";
    import {BASE_URL} from "./consts";

    let email = "";
    let name = "";
    let password = "";
</script>

<div style="display:flex;justify-content:center;align-items:center;">
    <div>
        <h1>Registracija</h1>
        <div>
            <label for="email">Elektronski naslov:</label>
            <input type="email" id="email" name="email" bind:value={email}>
            <br>
            <label for="name">Ime (in priimek):</label>
            <input type="text" id="name" name="name" bind:value={name}>
            <br>
            <label for="password">Geslo:</label>
            <input type="password" id="password" name="password" bind:value={password}>
        </div>
        <p/>
        <button id="login" on:click={() => {
            let fd = new FormData();
            fd.append("email", email)
            fd.append("name", name);
            fd.append("pass", password);
            fetch(`${BASE_URL}/register`, {body: fd, method: "POST"});
            navigate("/login")
        }}>Registracija</button>
        <p/>
        Ste že uporabnik? Prijavite se <a use:link href="/login">tukaj</a>.
    </div>
</div>
