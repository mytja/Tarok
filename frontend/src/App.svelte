<script lang="ts">
  const PEOPLE = ["Oseba 1", "Oseba 2", "Oseba 3", "Oseba 4"];
  const POINTS = [
    [
      {name: "Oseba 1", playing: true, bidding: true, difference: 30},
      {name: "Oseba 2", playing: true, bidding: false, difference: 30},
      {name: "Oseba 3", playing: false, bidding: false, difference: 0},
      {name: "Oseba 4", playing: false, bidding: false, difference: 0},
    ]
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
</script>

<main>
  <div class="bottom-bar">
    {#each CARDS as card, i}
      <div class="card" style="z-index: {i}; left: {i*-20}px; background-image: url('/tarok{card.file}.webp')">
        <div class="disabled"/>
      </div>
    {/each}
  </div>
  <div class="right-bar">
    <table>
      <tr>
        {#each PEOPLE as humanBeing}
          <th>{humanBeing}</th>
        {/each}
      </tr>
      {#each POINTS as game}
        <tr>
          {#each PEOPLE as humanBeing}
            {#each game as human}
              {#if human.name === humanBeing && human.playing}
                {#if human.playing}
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

<style>
  .card {
    display: inline-block;
    rotate: 5.342deg;
    height: 200px;
    width: 113.5px;
    background-size: 113.5px 200px;
    position: relative;
    border-left: 10;
    border: solid #FFF176;
    border-width: 5px;
    border-radius: 3px;
    padding: 0;
  }

  .card:hover {
    transform: scale(1.35);
  }

  .disabled {
    background-color: rgba(0, 0, 0, 0.5);
    width: 100%;
    height: 100%;
  }

  .bottom-bar {
    position: absolute;
    bottom: 50px;
    left: 50px;
  }

  .right-bar {
    position: absolute;
    right: 0;
    top: 0;
  }

  .negative {
    color: red;
  }

  .positive {
    color: green;
  }
</style>
