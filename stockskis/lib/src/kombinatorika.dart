// moje iskreno subjektivno mnenje je, da 3! = 6 ni tako veliko število, posledično si lahko privoščimo malo
// podle rekurzije
import 'package:stockskis/stockskis.dart';

double evaluacijaIzSkupka(List<int> skupek, int zaloziti) {
  var sum = skupek.fold(0, (p, c) => p + c);
  if (sum == zaloziti) {
    return skupek.length.toDouble();
  } else if (sum > zaloziti) {
    return (sum - zaloziti) / skupek.last + skupek.length - 1;
  } else {
    return -1;
  }
}

List<int> rekurzivnaKombinatorika(
  List<int> steviloBarv,
  List<int> skupek,
  int zaloziti,
) {
  var sum = skupek.fold(0, (p, c) => p + c);
  if (sum >= zaloziti) return skupek;

  List<int> novSkupek = [...skupek];
  for (int i = 0; i < steviloBarv.length; i++) {
    int steviloBarve = steviloBarv[i];
    if (steviloBarve == 0) continue;

    List<int> sb = [...steviloBarv];
    sb.removeAt(i);
    List<int> s = [...skupek];
    s.add(steviloBarve);

    s = rekurzivnaKombinatorika(sb, s, zaloziti);

    var sum = s.fold(0, (p, c) => p + c);

    debugPrint(
        "$s $sum $zaloziti ${evaluacijaIzSkupka(s, zaloziti)} $novSkupek");

    // če je sum == tistemu, kolikor moramo založiti, potem smo prišli na plodna tla, si lahko na čist način založimo s.length števila barv.
    // če je sum > tistemu, kolikor smo morali založiti, potem nismo natančno založili, ena barva overflowa, zato jo tudi odštejemo iz tega izračuna.
    // hkrati pa moramo spet upoštevati, da četudi lahko založimo 2, bo še vedno bolje če založimo 1+2, z overflowom barve v 2.
    if (evaluacijaIzSkupka(s, zaloziti) >
        evaluacijaIzSkupka(novSkupek, zaloziti)) {
      novSkupek = s;
    }
  }

  return novSkupek;
}
