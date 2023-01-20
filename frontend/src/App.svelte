<script lang="ts">
  import {Router, Route} from "svelte-navigator";
  import Game from "./Game.svelte";
  import Login from "./Login.svelte";
  import Dashboard from "./Dashboard.svelte";
  import Registration from "./Registration.svelte";
</script>

<Router>
  <div>
    <Route path="/game/:id" let:params>
      <Game id={params.id}/>
    </Route>
    <Route path="/register" component="{Registration}" />
    <Route path="/login" component="{Login}" />
    <Route path="/" component="{Dashboard}" />
  </div>
</Router>
