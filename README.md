# Tarok program Palčka
Popolnoma odprtokodni program za igranje taroka. Vključuje backend za online igro (s prijatelji, z naključnimi osebami) in frontend (aplikacija, napisana v Flutterju). Oba dela vključujeta podporo in polno integracijo s StockŠkis tarok enginom, ki se prav tako nahaja v tem repozitoriju.

# Vprašanja in odgovori
## Kdaj bo ta program javno dostopen?
Kmalu. Trenutno delam na izboljšavah in upam da ga bom kmalu lahko dokončno izdal. Medtem pa lahko seveda prenesete tudi zgrajene datoteke iz zavihka Actions ali pa preprosto [igrate na spletu](https://palcka.si). Registracije so odprte v vsakem primeru. V vsakem primeru bom naredil objavo na Redditu (verjetno r/Slovenia) ko bo projekt dokončan.

## Zakaj ime Palčka?
- za edine sprejemljive TLD-je sem si zastavil .si, .eu (pogojno) in .org (pogojno)
- sledilo je iskanje domen, ki uporabljajo tarok izrazoslovje:
- pagat.com, pagat.si, pagat.net, pagat.org so registrirane
- valat.si, valat.org, valat.eu so registrirane
- mond.si, mond.org, mond.eu so registrirane. Slednjo so seveda pokradli t.i. "domain hoarderji" oz. "domain parkerji" oz. "domain squatterji". Iskreno gledano, to bi morali prepovedati na vseh TLD-jih, na srečo na .si ni tako razširjeno, mogoče zaradi manjšega trga, mogoče zaradi regulacije ARNES-a
- skis.si, skis.org, skis.eu so registrirane. Slednjo so spet seveda pokradli hoarderji >:).
- tarok.si, tarok.eu, tarok.net, tarok.org so registrirane.
- posledično mi je edina sprejemljiva zadeva v povezavi s tarokom ostala palčka, kar je "ljubkovalno" ime za pagata. Na srečo je bila palcka.si domena prosta.

## Zakaj monorepozitorij?
Tudi meni ni všeč ta koncept, ampak bi rad posodobil vse stvari (Docker kontejnerje, aplikacijo, spletno stran ipd.) ko objavim novo verzijo kode, najsibo to sprememba v StockŠkisu, sprememba v backendu ali sprememba v frontendu.

# Licenca
Vse razen StockŠkisa in StockŠkis CLI-ja je licencirano pod AGPLv3 ali kasnejšo licenco.

StockŠkis CLI in StockŠkis sta licencirana pod GPLv3 ali kasnejšo licenco.
