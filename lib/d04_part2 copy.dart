void main() {
  final DateTime start = DateTime.now();
  List<String> lines = input.split('\n');
  final result = findMatches(searchedWord, lines);
  print(result);
  final DateTime end = DateTime.now();
  print('Duration: ${end.difference(start).inMilliseconds}ms');
}

// gehe den input zeilenweise durch
// suche in jeder zeile nach dem ersten buchstaben von searched
// wenn gefunden, suche nach dem nächsten buchstaben von searched in alle richtungen
// nach vorn, hinten, oben, unten, und diagonal (8 richtungen)
// tu das solange bis alle buchstaben von searched gefunden wurden oder keine weiteren buchstaben gefunden werden können
// wenn alle buchstaben gefunden wurden, erhöhe den counter
// gehe zur nächsten zeile
// wenn alle zeilen durchsucht wurden, gib den counter zurück
int findMatches(String searchedWord, List<String> riddle) {
  int count = 0;
  Map<(int, int), int> indicesOfA = {};
  for (int i = 0; i < riddle.length; i++) {
    for (int j = 0; j < riddle[i].length; j++) {
      if (riddle[i][j] == searchedWord[0]) {
        // search in all directions
        for (final direction in directions.keys) {
          final nextDirection = directions[direction]!;
          final nextX = i + nextDirection[0];
          final nextY = j + nextDirection[1];
          if (nextX >= 0 && nextX < riddle.length && nextY >= 0 && nextY < riddle[nextX].length) {
            if (searchNextLettersInDirection(nextX, nextY, direction, searchedWord, 1, riddle)) {
              count++;

              final newCoordinate = (nextX, nextY);
              // print(riddle[nextX][nextY]);

              (int, int)? found;
              for (int k = 0; k < indicesOfA.length; k++) {
                final key = indicesOfA.keys.elementAt(k);
                if (key == newCoordinate) {
                  found = key;
                  break;
                }
              }
              if (found != null) {
                indicesOfA[found] = indicesOfA[found]! + 1;
              } else {
                indicesOfA[newCoordinate] = 1;
              }

              // for (int k = 0; k < indicesOfA.length; k++) {
              //   final key = indicesOfA.keys.elementAt(k);
              //   // print(key);
              //   if (key[0] == newCoordinate[0] && key[1] == newCoordinate[1]) {
              //     indicesOfA[newCoordinate] = indicesOfA[newCoordinate]! + 1;
              //   } else {
              //     indicesOfA[newCoordinate] = 1;
              //   }
              // }
            }
          }
        }
      }
    }
  }
  // print(indicesOfA);

  // itarate over all values in indicesOfA and count all which are exactly 2
  int countX = 0;
  for (int i = 0; i < indicesOfA.length; i++) {
    final key = indicesOfA.keys.elementAt(i);
    final val = indicesOfA[key];
    if (val == 2) {
      countX++;
    }
  }
  print('countX $countX');
  return count;
}

// comare two maps<int, int> if they are equal
bool compareMaps(Map<int, int> map1, Map<int, int> map2) {
  if (map1.length != map2.length) {
    return false;
  }
  for (int i = 0; i < map1.length; i++) {
    final key1 = map1.keys.elementAt(i);
    final key2 = map2.keys.elementAt(i);
    if (key1 != key2) {
      return false;
    }
    final val1 = map1.values.elementAt(i);
    final val2 = map2.values.elementAt(i);
    if (val1 != val2) {
      return false;
    }
  }
  return true;
}

Map<String, List<int>> directions = {
  'upLeft': [-1, -1],
  'upRight': [-1, 1],
  'downLeft': [1, -1],
  'downRight': [1, 1]
};

// find next letter in range
// x=0, y=5, direction=right,searchedWord='XMAS',indexSearchedWord=1, riddle = ...
bool searchNextLettersInDirection(int x, int y, String direction, String searchedWord, int indexSearchedWord, List<String> riddle) {
  if (indexSearchedWord == searchedWord.length - 1 && riddle[x][y] == searchedWord[indexSearchedWord]) {
    // print('found word $searchedWord at $x, $y in direction $direction');
    return true;
  } else if (riddle[x][y] == searchedWord[indexSearchedWord]) {
    final nextDirection = directions[direction];

    final nextX = x + nextDirection![0];
    final nextY = y + nextDirection[1];
    if (nextX >= 0 && nextX < riddle.length && nextY >= 0 && nextY < riddle[nextX].length) {
      return searchNextLettersInDirection(nextX, nextY, direction, searchedWord, indexSearchedWord + 1, riddle);
    }
  }
  return false;
}

final searchedWord = 'MAS';
final input = '''
SSSMMSAMXSSSSSSMSSSSMAMSMMSMSMXSASMMMMAMXAXMAXXSSMSSSMSMMSXMAXXMAXSAMXMXMAXXMAAMMMMMAASXMSAMXMASMMSMSMSXXMSMSXAXMSMMSXASXSMMSMMXMMMMXMXAMMSX
XAAAASMSAAAASAAASAAXSAAAMMXAAAASAMXAMMSSSSSMXSAXSAAAASMAAXASMSMAMXAMASXMMSMSMMXSMAASAMXAXXXMAMXSXMSMSASMXAAAMMMAMXAASMXSAAMASASAMSAMAMXMSAMS
MSMMMSAMMMMMMSMMMMMMSMSMSAASMXMMAMSXSAAAXAAAAMAMMMMSMMXMMSXMAAAAXMXSAAAMAXXAAAASXSMXMASMMMSSSMAXAXSAMAMAMSMSMAMSMMMMMAXMMMMXSAMAMSASMSAAMXMA
XAAMXMAMXXAAMASXXXXAXMXXAAMXSAXMAMAAMMMXMSMMMMMMXMXMASXMMXMMSMSMSMAXMAMMASMSMMXSAMMSMAAXAAAAAMSSSMMAMMMAMXAMMXMAAAAAXSMMSXMMMXMXMSAMAMMMMAXM
MXMAXMAMMMSXSASMMAMMSMSAMMMASXMSXMMSMAMSXAXXAAAAASXAXAAAASAAXXXAXMASXSXAXXAAXXAMASAAMSMSXMMSXMAMASMMMAMAMMSMMXSSMMXMXMAXSASAAAMAMMSMMMSASXSX
AAMASMSSMAMMMAMMMASAAAMAXXMAMSASAMMMMMSAMXMSSSSSSSMMMSSMMAMXMMMMMSXSAMASMMSMMMXSAMMSMXMAXXMMMMASAMXMSXSASXMAMXXAXSASMSSMXASAMASXSAAXAASAXAAX
SASAXXMAMAXAMXMXSASMSMSXMXMAMAXSAMMSSMAXXMMAAMAMXMAMMAMXMMMMSMAMAXSMAMAXXAXAXXMMASXMXMAMMMMAXSASAXXMAASAMMSAMXMMMMAXASMAMMMMSXMAMXMSMXSASAMM
XXMASMMSMASMMSMAMASAMXXMSMMSXMXMAMXAAMAMXXMXMSMMASAXXXMAMAAAASMMXMXSXMASMXMASXXSXMAMXMMSSMSAMMASMSSMAXMAMASAMMSMSMAMSMMMXMAMXAAAXAMXMASASAMX
MAMAMAAXMXSAAAMASMMAAMSAXMAXAXXSMMMSSMAMMMMAMAAXAXXSSSSMSSSSMMXXMAMMXMASAXMASAAAMMAMMSAAAMXMSMMMMAAMMMMAMXSAMAAAMXXXMASMSMMMSMMXXASXMMMXMASX
AMMAXMMMSMSMMMSASXSXMAASMMMXAMXAAAMAMXAMMASASXSMXSSMMAAXMAAAXMMSMMXAAMMXMMXAXMXMAXXAAMMSMMAXMMAAMMXMAMSSSXMASXMSMMXMSSMXAAAXSMAXSSMMMASASXMX
SMXAMSMMXAXAXXMXSASXMXMAMASMASMAXSMASMMXSASASAXAAMAAMSMMMMMMAAAMAAMMMSAMSSSSSXSXMXXMSSMMMSSSSSSSSSSMMMAMXXXXMAXAMXAMMXASXSMXMMMXMAAMSASXXAAM
MMMSMMAMMSMMMSMXMXMASMXMSAMMAMAXSMXXMAAAMAMXMMMMMMSMMXSSXMASMMXSMMSAAXMAXAAAXASASMXXMXMAAXAAAAXAAAAASMMSXSSMMSSSSSMSAMXXAXMASAMASXMMXMSXXMMM
MXAXASAMXAAAAAAXMAMMMMXXMAXMSSSXSAASMMMSSSMMSXMASXMAXAMMXMASMMMSXAXMMMSSMMMMMMMXAXSXMASMMMMMMMMMMMMXMASAMSAXSAAXXAMMMSMMMMSASASASAMSAMXMASAS
MMMSMSAMSSSMSMMSSSXSASXMMMSAMAXAMXMSMMAXAMXAXMSAAMSSMMMSASXSMSAMMMSAMXAAAXMAXXMSMMMASAMAAXSXXSXXSXXSXXMAMSAMMMXMSMMAAAXASAMXMMMXSMMXAMXAMSAS
XSASXXAMXXMXMXMMAMASXSAMAAMAMMMXMXMSAMXMAMMSSMXSMMAMAAXSASAMAMASMAMMMMSXMMSXMSAMXASXMMSSMMMMMMAMXMAMXMSMMMAMAXSAAASMSSSMSXMMSMXMMASXMMSSXMAM
AMAXAMSMMAMXMAMMAMAMXMAMMSSSSXSMSXASAMXXASAMAMMMXMAXMMMMAMXMAXMMMASMSAMAXXXMXMAXSMSSXAXMAMAAAXSXAMAMAXAXAXAAXMASMXMAAAXASMMAAXAXSAMASAMXAMMM
SMAMSMMASXMASAXSXMXSMSMMMMAAXASAAMXMAXXSMAXSAMASMMMMASAMXMASXXSASMSXMASMMMMAXSXMXXSXMSMSMSSMSAMXXSASMSASMSSMSAMAMMSMXXMSMAMMSSSXMXXAMAXSMMMS
XMAXXASAMXSXXAMSXSAAMAMAAMSMMMMMMXXSXMMXAMXSASMSAASXMMXSAMXXMASASMXAMAMAMSASMXXAXMXXAAXAAMAAAMSAMSAXXMAMAAAAXXXAXASASMSXSXMSMMMAMXMMSXMMXAAA
SMSMSMMAXMXSMSXSAMXMMAXSXXAMMMAMXSAMMSXXSXASXMXSMMMAAAMSAMXMXMMAMAMSMMXAMXXXAAXSXASXSSSMSMMSMXMAMMXMSSMMMMMMMSSSMMSAMSAAMSMAASXXMASAAMSSSMSM
AAAXAXSMMSAMXXAMXMAMXMMMXSASMSMXMMXSASAMXMASXMASMMSSMMASXSAXSAMXMAMXAMSSSMXSXMAMXSMAAXAAXMAMXXSSMMXMAAAXSAMAXMAMAMMAMXMXMASXSMAXMAMMXMMAMAAX
MSMSXMSXAMAMAMMXAMASAMAMXXAMMAMXMMMMASASXMAMAMASAMXMASXMASAMXAMXMXXXAMAMAMASMSAAMXMMMMMMMMMSMXAAXAXMAXMMSASMMAMSSMMXMAMASXSMXXMMMSXSAAAMMMMS
XMXMXMXMXMMMXSMSXXASMXAMSMSMSXSAAAXMMMAMXAASXMMSMMAMMSAXAMMMXSMMXSMSSMMSAMMSASASASXXXXAXAAMAMSSMMSXMMSSXSAMXAAMMAXAXSXSMXASAXXXXMXAMXSMXMSAM
XAAMAMAASMSSMAMASMAMXSSSMAXAXAXXXMXMSMXMXSMSXSAMASXMASAMXXMSMXAMAMXMXAXXXXXMXMXMXMMMSSMMSSSMMXAXAMASAAXMMMMMSMSSMMMXSASXMAMMMSSMSMSMAXAXXMAS
SSXMASXSAMXAXMMAXMASMMMAMXMMMMMSMMXSAMMSAXAMMMAMASMMASAMXSMXASAMASMSMSMSASXSAMAMXSAAAAAMAAMXXSXMASAMMSMMSSMMAMAAMAMAMXMXMXXAAAAAAAAMMSAMXSAM
XAXSAMXXXSSSMXMSSMSAASMSMXMMASASAAMSASAXASAMXSXMASASMMAAAAXMMMASAXXAAAXSAMXSASMSMSMSSSMMMSMMXMASMMXSXXAAAAASAMMSMMMASMMXMXSMMSSMMSMSXSAMAMAS
MAMMSAMXAAAAMXAXXMXMMMXMXAMSMSASMMMSAMMSASXMASXMAMAMXSMMASAMXMMXAXXMMMXMXMMSMMAAMXMXMAMXAAAAAMMMAAAMAMMMMXMMASXMAXSAMXSASXXSAMAAAXXXASAMXSAM
MMMMMXXMAXXAMSAMXXXXASAMMXXAAMAMAXAMXAMMMMAMASMMSMMAMMASAAMMASXMSMXXASAMAMXXMASXMASAMAMSXSMSMSAMMMSSMXSXSXMMMMAMAMAAAMXAMMXMSSMMSXSMMMXSMMAS
SASASMXMASMSMXMXMMMSMXASAMSMMMSSSMXSMXSAMXMMXXAAMXSMASAMXMXSASAAAAAXMSASXXAAMAXMSXSMSAXSAXAMXSXSXAMAMSMASAMSSMMMMMSXMXMSMMSMASXAMMMAMXAXAXXM
MAMASAAMAXAAXAXAMXXXSMSMXXAXAXMAMAXXAMSMMSXSMSMMSXXAMMMSASXMMSMSMXSAMXXMAXSMMASAMXMAMXSMAMAMAXAXMXSAMAXAMAMAAAXSAMXXMMMMAAXMASMXMASAMMSSMSSS
MAMAMMXMSSSMMMSMSMAAMXXSXSASXSMMMSSMSMMAXXAAAAMAXMMSMAMMMAMXAXMMXAAAMMAMXAXASASMSAMAMXSMAMXMMMXMMXXAXMAXSXMXSMMXAXXXXAASMMSMASAMSAXAXAMXXAAA
SMMSAMXSAAAXSXAAMXMXMAMAXMAAAMMXAXMAAMSSMMSMSMMMMAAASXMASMAMMSASMSSMMMMMMASAMXSASXSASAMXAXSAMXMASMSXMXSXSASXAASMMMSMXXMXXAXMAXMMMMMSMMXSMMSM
AAAMAMSMMXMAAXMXMAMAMASMSXSMSMAMXSSSXMAAAAAAAMASMMSMSXSXXXSMXAAMXMXMAMSAMXMXSMMMMASAMMSSMSMMSMSASXSAMXXAMAXSAMXAAAAMMSSMMSXMASXMASAXAXSAAXMM
MMMSSMSASXSAMXSASASASASXAAMXXMAMXMAAMMSSSMMSMMASAAXMXMMSMSMSSMXMXXAMMSSXXMSAMXAAMMMAMXXXMAMAAAMASAMAMASAMAMXXSSSMSXSAAAMAAXMXAXSAXMSSMMSMMSX
MXMXAAXAMAXSXXSASASMSXSMMSMAMMSMXMASMXXMMAMXXMMSMMMMSAAAMSXAMMMSXSMSXMXSAAMASMSSMMSAMXMXSASMMMMMMMSXMASXMASMMAMAAXAMMSSMMSAMXSMMSXMAAAAXXASM
SAMSMMMSSMSAMAMMMASASAMXAXXXXAAAXASMMXMAMSAMXSAMXMAXMMMSSMMXSXAMAXMAMMAXMXMAMMAXAXAAXSAMSASAMXSXAXAXMXMXMAAMMASMMMXMMAXMXXAMAAAAAXMASMMMMSSM
SAMXMXAAAXMAMSXSXXSAMMMMXSASMSMSSMMMMAMXAMMSMMASMSMSAAXMAMASXMAMSASMMMAMXMMXMMAMXMSAMASAMMMXXAXAXMMXSAMMMMMXSASAAXSAMXSMASAMSSMMSSSMMAXSXAXA
SMMAAMMSSMSAMXAAXMMAMMAMAMAMAXXAAMAAXAXMASAMASXMAXMAXMXMAMXXSAAAMXMAMXAXXSMMXMXXAMXSMSMMMASAMSSMMMXMSMMAXASXXAXXMMXMASXMXSAMMAMAXMXAMMMAMMSM
XASMMMAXAMSASMMMMXSSMSASAMAMAMMSSMSXSAASAMXSMXAMSAMXASXSASXMASMXXXMAMXSSMXAMSMMSASAXXXAXSMSMXXAMMXAXMXSXSASAMSSMMSMMMMMSMSAMMAMSSMSSMMMMSMAM
SMXAAMMSMASXMXMASMMMAXASASMMASXXMAXAAMMMASAAXXMMAAMAMAMSAXASXXMSSXSASXMAMMAMMAMXAXXMSMMMAMSXXMAMXSMSSXAAMXMAMAAMSAMXAAMSASXMXXMXAAAAXXAXMASX
AXSSMSMAXAMASMMAXAASXMXMMMXSAMXXMAMMMMXSAMASXMXSMXMMSMMMSMAXAAXAAASAMXXAMMAXMAMMXMAMSAASAMSASMMMMXAAMMMMMAMAMMXMSAMXXXXMXMASXMMSMMMXMSMMSAMX
MMXAAXMMMASAMAMSSSMSAMXAXAXMASXXMAMXAXMAMXMMMAAXXAXXMXSAMMAMXSMMSMMASXSXMXMSSXXAAMAMMSMXMSMAMMXSMXMAMXAAXMSSMXSASAMSXSAAMMAMASMMXSXAASAMSAMS
MMAMMMMXSAMAMSAMAMXSMMSXMMMSAMXMASXSASMAMSXAAMSMSMSSXAMSMMMSMAXMAXMAXMAXSAMXMMMSMSAMMAMSXAMAMSMSMASXMSMSXMAXAAAMMAMAASXMMMAXSMAMASXMSMAMMAMM
SMSMAXMAMASXMMAMXMASMASXXAAMASAMXXMASMMAMAMXXSAMXAAXMXMAXMAAXSMSASXSSXSASASXXAXAASAMSAMASXSASXAMSASAAXAAXMASMXMXXSMMMMMXSSSSXSSMAMXMAMAMSMMX
AAAXXXMXSMMMSSXMAXMXMASXSMSSXMASMXXXAXMXXAAMXXMASMSMSASXSMSSXMAMMSAAAAXXSMMXSMSMMMAMSASMSXXXMMSMMXMMMMXMSMASXMXSAMASXMMAAXMAMAMMMXAMSSMMAMMX
MSMXMSMXSAASMMMXXXXXMMSAMAMXMXMAMMSMSMSSSMSAMXXAMXXASASXAAAMAMAMAMMXMMMMMXAMXAAAASAMXAMXMMMMSAMAMSSSMMAXAMMSMAMMMXAMAAMMMSMMMSMAAXSMMAXSAXSA
MAAASAMXSMMSAMMMSAMXMAMAMXMASASAXMAAAAAAAXXMAXMMSAMMMMXXAMXSMSAMXSXSMMAAAMXXXMMSMSMMMXMAXXXAAXSAMMAAXSXSXSXMASXAMMASMMMMSMASAMMASAXASAMSMMAX
MMSMSASAXXXSAMAAAASXMASAMAMAXAXAMSMSMSMMMMSXSMSAMMSXSXMSMSXSXSAMXAAXASMSSSSXASAMXMMSMSMSSXMASMSMMMMMMAAMAXAMSASAMAASXMAMASAMXSXXMAMAMMXXXAMX
MXAXSAMXMAMXAMMMMXMMSMSASXSSSSMSAMAMAXXMSASXXAMASXXAXMAAAXAXXXAMSSSMAMAAAAXSAMXMAMAAAAAMMAMAXXXAMMAAMMXMASXMMMXSMSXMMSMSAMXXAMMAMAMXMXMAMSXM
XSAMMXMASXXSAMXXMMSAXASMMMAXAXAXMMAXXXAXMASAMMMMXMMSMASMSMXMMMAMXAAMAMMMMMMSXMSXSXSXSMSMSMMMSMSSMSSSSXMMAMAAAXXXXMAAMAMXXMASAAAASAMASAMAMAAS
MSXMAXXXXMAMAMXSAAXMMMMMAMXMMMSMXSSSSMSMMXMXMMAMAMAXAMXAAASMSAMSMMMXMXAAAXXMAASAXAMXAAXAAXMXAXMAAAAAMMAMXSSSMSSMASXMMASXMAXASXSMSASASXMAXSAM
ASAMXMSAMAXMSMASMSMXAAAMXSMSXAAMXMAAXAXXSAMXXXAXSMMSSSMXMXAAXXSAAAAASMSMSASXMMMAMAMSMMMSMSXSXSSMMMSMAMSMMAAAXXASXMMMSAMAAMSMMMAXSXMXSAXMXXAX
SMAMAMSASXSAXMXMMXMXSSSSXXAXMXSMAMMMMXMAXASXXSSSXAXAAAAASAMXMSMMSMSXSAAXMASXAAXAMAMASMAAAMAXAMAMXAXAMXAAAMXMMSMMMMAMMMSSMMXAASAMXXMMXMASMSXM
ASMMXMSAMAMASXMXSMSXAAXAMMXMAAAMSMXMASMSSMMXXMMAMSMMMMSASAXAXSAAMMMMMMMMMXSMSMSXSXSASMSMMMAMMMAAMMSAMSMSXSAAAXXMASASAMXMMAXXMMXMAXSAAXXMASXM
MAXXSAMXMXMAMMAXXAMMMMMAXXMASMSMMAXSSXXAAAMMMMMXMXAAXXAAMAMXMMMMSXAAAAAXXXSAXXMXXMMXMMASAMMXSAMXSAMAMSAAAMXMMSMSASMSASAMXMSSMSASAMXSMSAMAMAM
XXMXMAXSAMMSSXSXMSMSMSSXXSMXMAMAXSMMXSMSMMMAAXSSMXSMSMSSSMSXMAMASXSSSMSASXMMMAXMMMMSMSASMSASMMMXMASXMMMMSMSMAAMMMSMMXSXMXXAAASXMAAAMXSAMSSXM
XMXAXSMMSAMXMAAMAAAAAMAMMASAMXMMMMAXXMXXASXSMSAXMAXXXAAXAAAASMSMSAMAMXMMSAAASAAASAAAXMASAMMMAAXAMXAMAASXMMSMSSSMASAMASMSMSMMMMASAMXMAMXMAAAM
ASMMMAXXAMMAMXMSSMSMSMAMMAMXMXAXASMMSSMSMMAAXMMMMMSMMMMSMMMAMAAASXMAAXMASMMMSMMMMMMXMMXMXMXXSMSXSXMXSMSXMASAAMAMAXAMAMXAAAXSAMXSMMAMASAMXXXM
XMAMSMMMMMSXSXXXAAAXAMXMASXMMSMSMSMAAAAAAMMMMSXSXAAAASAXXXSXMSMMMASXSAXASASASMSASMSSMMMMAMAXMAMASMXMMSXXMMMMMSSMMXSMSSSMSMSSXMASASMSMSASMSMS
MMMMAAAAXASASAAXMASXXXASXMAAMAAAASMMSMXAMAMXAAAXMSSSMSMSSXMAAXAAXXMAXAMASMMASASXSAAXAAAMMMMXMAMXMASASAMXSAMXAAMASMAAAXAAAXMXAMASXMASASASXAAA
AAASMSMSMASAMMSXXXMAMMAMAXMMSMSMSMAMMMMMSAXSAMXMXMAMAXMAXAMSMSXMSXMXMASASXMMMAMAMMMMSSSXASXMSAMXXXMXSAMSAMXMMMMAMMMMMSSSMSMSSMMSAXAMXMAMMMSM
MSXSAXMXXAMAMXMAMMSXMASMXMXAXAXMAMAMXSAMMMMAMXMMASAMXMMSSMMAAAMXXMASMMMASXAAMAMAMAAMAXXXAMAASASMSMMXSAMXMASMAAMMMMASXAAAXXAAAAASMMXSXMMMAMAM
MXAMXMSMMXMXMAMAMAAAAAXAXXMSMMMSXSXSAMMSSXSAMXMXASASMXMMAXSMMMMSAXAAMXMAMMSASXSMSXSMASMMSMMMMASAAAXMXXMAXXXMMMSAASASMMSMASMXSMMMXSASAMXXXSAM
XMAMAMXAXMSASAMAMXXSMMMASXAMAXXAMXXMAMXXAXSXSMXMASMMAAXMMMXAAAASXMMXMAXXXMMXMXXAXXMAMMAAXMAXMAXMSSMASMMXSMXXMAXXMMASXAMXMXAXMMSMAMAMAMAAXMXS
SSMMAAXSAAAXMAASMSMXASXAAMXMAMMASXMMSXXMAAMMSMXAXXASXMSAASXSMMMSAXAASXSSMXMASAMXMMSASXMMSSSXMASMMMXSXAAMMMSASMSXXMAMMMSSXMSMSAAMXMAMXMMSXAAX
XAASMSMXASMSMXMAAAAMAMMXMSAMXMSAMAMAMMXMSMMASAMMMSAMAAXXASAMMXXSAMMXMAAXAAXXMAMXAAXXXAMXXAMMMMXMAMXXSMMSAXXAMAAMSMSAMXAXXAXAMSMMAMAXAAMAMXMX
XSMMSAMXXXXAAAMMSMMMAMASXSASXXMAMXMAXAAXAAMXSAMAXMMMMMMMMMXMSMMSAMXSMMMMSXSAAAMMSSMSSXMMMMMMAMASMSAMASMMMSMSMMMSAAAMMMAXSMMSMMMSMSASXSMSAMXM
MAMXMMSMMMSMSXXMAMXSXSAMMMMMXMASMMSSSMMXSXMAXAMXMAAXASMXSAAMAAASAMAMAXSXAXMMMMMAMAXMAMXAXSASASMSXMASAMSAMXAAMMMXMSMSMMSXAMAMASAAXMASAAAAMXAA
AMMSSMAAAAAXMXXSMXXAMMASMMAXXXAMXMAXXASAXASMMMMXSSMSASAAMSSSMMMSSMAMAMSMMSSMASMMSSMXMMMSMAASASAMXMMMXSMMMMSMSSXMAXAXXAMSSMASXMMSSMMMXMMMSSSS
XAAXASXMMSASMXMMSMMMMSMMASASXMSSSMSSMMMAMAAXAAXXMAAXAMMMMAMXXMAMAMSSSXXAMAAMASXMAXMAAAAMAMAMAMMMXSAMXMASXAAASASAAXMXMAXMMXAMMXAAAAXAAXMAMAXA
MMSXMMMXMMMMMAMAAXAMAMASMMXXAAAAAAAAXSMSMSMSSMSMSMMMMXMSMSSSSMMSMMMAMMSSMMXMMSAMASXSSMSSSMXMXMAAXXASASMMMSSMMAMMMMMASXSASMXSAMMXSMMSMXMAMSMM
MAXAXSMMAAAASXMSXSMSASMXAXXXMMMXMMMXMAAMAMMXMXAMAMMSMAAAAMAMXAMXMXMAMXMASAMXMSMMAXXAXAXAXXMASXMSMSAMAXSAAAAAMAMASASASMSAMAAAMXXMAMXMAMSAMXSX
MASMMAAAMSXMMAMXASASASXSSSSXSASASASXAMXMASXAXMASMSAAMXXMXMAMSMMMMMXSMASAMXSAAXMASXMMMMMMMXMMXASAAMMMXXSMMSMMSSMXSASASAMMMMMSMMSAMXAMAMMASXMS
MASMSSSMXMMSSXMMXMAMAMMAAAAASASMSAMSSXXSSMMMSAXSAMXSXMMSASAMAAAMASMMMAMASASMSMSMXMASASAMAMSASMMMXMSMSASMAXMMMXSXMAMMMMMAMAMXAMMMMMMSMMSMMASX
MAMXAAXMAXAXMMMXXMAMMMMMMMMMMMXXMXMSXMAMAXASAMSMAMMMXXASAMASMSXSASAAMMSXMAXAAAAXAAXXAXASAAMASXAXSMAAMAMMAMAAMMASMXMAMASASASXSMAAXAMAMMAXSXMX
ASAMMSMMMSMSAAAAXXXXXXMASAXXXXAMAAXMAXSSSMMSAMXMAMAAMMAMMSMMMAXMASXMSXMMMAMSMSMMMXSXMSAMXMMAMMAMAMMSMAMMAMSMSSMXMASASASASASAMSSSSMSASXMMSXSX
MMAMXXMAMAASMMSSMMSMSSSXSASMMMMASMMMAMMAMMAMMMXSSSMAXXXAMAXAMXMMMMAXSAMXMAXAAXAMSAAAMXXMMSMAXXXXXXXMXXXMSMXAAMXMAMSMXXMXMXMAMAMAMASXMASMSASM
XXMMXXSASMXMXMAMAAAAAXXXSAXAXAAXMXSMMXMAMMAMAMAMXAMAMSXXSMSXSSSSXSXMXAMSXSMMMMAAXAMSMAAMASMSSMSSXMSSMMSMMAMMMXAMAMXMMMSXMXMSMSMSMMMSMXMAMAMA
AASAMXSASXMSXMASMMMMMXMAMAMSSMSMSASASXMMXSMSSXAASMMSMMAMAXAASXXSAAXMSSMMAMXMXSMMXSXXMXMMASMAAAASAMXAAAAAMSMSMSXSASXSAAAMSAXMAMXMAMASXAMAMMMS
SMSAMXMAMXXASMAMAXMASXSAMSMXAMAAMASAMAXMMXMAAMSMMXAMASXMAMMXMAAMMMSXSXAMAMAMAXAXAXXSMSSMASMSXMASXSSSMMSAMXMAAAMSAMXSMSSXSASMAMMSAMAXAASASAAM
XXXAMXMAMAMMXXXXXMMAXMXAXMMXMAMMMAMASAMXAXMXMAXSMMMSMMAASMMAMMMMAXSXXSMMMXAMSSMMMSASAASAMXXMAMAMMXAXMMMXMASMXMXMMMMMMMMMSXMMASXSAMXSMXSASMSS
SSSSMAMASMAXASAXSAMASMMXMAXMXXXXSSSMMMSMMSSMXAXAXMAAAXXMXAMAXAASMSSMXXSASMMAXMXSAAAMMMSXSSMSSMAXAMMMMAMAMAMAASASASMSMSAAXMASXMASMMMSXAMMMMAM
AAAXSXSAMXXMAXAASAMXSXAXSXMXAMXXXAAAXAAAXAAAMSSMXMSSXMXXXSSMSSMXSAXAMMSXSAMSXXASXMAMXAMAMAXAXXMMSMSAMAMMMSMXMXAXAMAAAXMMSXAAASMMAMAMMXMAAMAS
MMMMXXMASMXSMMXMSAMXXMXMXAAMMASMSSMMMSSSMXSSMMAXXMAMXASXAXAAAMASMSMSAASXSXMXSMMXXXAMAAMAMMMMSAMXAASMSMSMXXAASMSMSMMMMMMAMMMSMMASMMAMASASXMAS
AXAMMXMAMMASASMXSAAXXMSASMSXSASAAXAAXXAAXAMXASXMSMAMMMAMXXMMMSSMAAMAMMSMMMSMAMAMMSMSSXSASXAAAXMMMXMAAAAXAMMMMAXAXAXSASMASAXAASAMXXAMMXMMSMAS
XSMSMAMSXMMSAMAAMSXXXXAXSAAAMAMMMSSMSMSMMSSSMMSAAMSSSMSAASMXAXAMAMXAXMSAMAAAAMASMAMAXXSAXAMXSMSASAMSMSMMSXSAMAMMMMMMAXMMMXSSXMMMXSMMMAMAMMXM
XSAAAMXAAMAMXMMMMXMMMSMSMXMXMXMXAXAAXXXAAXAAMAXXMSXAMAMSMAAMSSMMMXXXSMXAMSSSXSAAXAMMMXMMMSMMXMMAXXXAMXXAAAXMAMAMAAAMXMAAMXMXMASAAAAXSSMSXMAM
SMSMSXMSXSAXMAMMMMMAAMMAMAXMAMXMASMMMXXMAMMMMMSMXMMMMXMAMMXMAAASXXSAMXSMMAMMXXMXSMSXSAMXAXASXSMAMSSSSXMAMSSMSXSXSSSXMXXASXMASXMMMSSMAXSXASMS
AMAMXAMAAXMMMSMMAASMSSSXSASAXAMXAXAAXMAMXSXAXAAMAMXSAAMMMXMMMSMMAAMAMAAAMAXXAXMASAAAMAMMMXXMAASAMXAMMMMSMAAAMAMAAMAASMSMMXSXMMMXXAAMAMMSAMXM
AMAMMAMMSMAXMAASMMSXXAMASASMSSMMSMSMSXXXMAXMMSMSMSMSSSSMMAMXMAMMXMAXMMSSMSMMMSMAMMMMMASAXAAMMMXSAMXMMAAAMMMMMAMMMMSMMAAAXASMSAMAMMMSAMXMMMAS
SSSSSSMAMMMSMSMMASMMSAMXMAMXMAAXMAXAMXSXMAXSAMXSAAAMAMXAXMSMMMSMMSMXSXAMAXMAXXMXSSXSSXSAXSSMXMAXSAMXSMSXSAMXMXMASXMMXSSSMASASMSAAXXAMAAMASAX
AAAAAASXMAAAXXAMMMMAXAMXMXMSSSMMMXMAMAMAMAMSASAMMMSMMMSSMSAXAXXAAAMAXMMMAMSSSMSMXMAMMXMAMXAAXMAXAMMAMXMAMAMAMXMAMAAMMMAXMAMXMAXXMMAAXSMSASXS
MMMMSMMXSMXMSXXXAAMMSXMAMAMXAMMAXSSXMXMAMXMMAMMMAAXXAAMAXSASXSMMXSMSXSXMMMAMAMXMAMAMSXSAAMMMMMSSMSMASAMAMASMSAMMMXMMAMMMMXSXMAMMSMXSAXAMMMMA
XAAMXMMXMASXMMMSMSSMAASASMXMAMXSAXAAMSMMSXXAAMAMMSSSMMSMMMAMAMXSMMAXASXMXMXMXXASMSXMXASXSXSAMXXAAAMXMASXSXMASMSMASMSSSMAAXXMMMSAAAAMASMMMMAM
SSSMAASAMAMAAAAXAAAMAMSAMAASAMAMMAMSMSAXAMXSSSXSXAXXAAAAAMAMXXAXAMAMXMAMSMSMSSXSMAMSMXMAMXSMSAMMXMSXXXMAMXMAMAXMAMAAAMXMSMMAAAMMMMMMAMXAAXSA
AMAMSMSASMSXMMSMASMMMXMAMSMXAMXASMXAASMMASMAMXMAXASMMSSSXSXSXSXSAMXSXMAMAAAAMAMXMSXAAXSAMXXAAXAXAXMMSAMAMXMXSMSMMSMXMAAMAAAMMXSAMAMMMMMXMAAX
MSAMMXSXMXSAXXXAXXMASMSAMASMSMSAMAXMMSXAAMMAMAXMXXXAAMXXMMAMAAAXMMAAMMXMMXMMMMAXSAXXSAMXMMMXMAMSXSAASASXSAMMAXXAXSXSXMASMMSASASXSASAMMSMXMXM
XMXMAXMAMAMAMASMSASMMXSASAXXAASASMXXAXAMXSXMSXSASMSSSSSMSMAMMMMMMMXSXASMMMXXAXXMAMASMMMAAAXMXSAAMMMMSAMMSASAMSMAMXAMXMASXAXAMASMSASMSAAAAMAM
SMSSMMSSMMSMMXAAMAMAAASXMXSSMMMAAXSMMSXMAXAMAMXAAAAAMXAAXMAMAAXAASAXMAXAASMSSSMMMXXXAASXSSMSAXMMMAMXMAAXSMMMAAAAXMXMAMSMMSMXMAMAMAMAMXMXXXAM
AAAAAMAMXMAAXXMAMSMXMASXSSMAASMMMXMAMXAMSXMMAAMXMSMXMXMMMMSXSSMXAMXSXAMXMMAAAMAAXXMSMMSXXXAMXXMXMASXSSMMSAMXSXSMSMMXAXAAXAASMSSXMAMXMSSMSSSS
MMMXSMSSSSMSSSXAAAMXSXMASAMAMMXMSMSXMXSXAASASXSXXXMASMXSXAMXMXMMAXXAMXMMAMMMXMSMSMAMMASMMMMMXASAMMSMMAXAMAMMMXMMXMASXSMAMMSMAAMMSSSMXAAXMAXA
XASAMMXMAAAMXMASMMSAAAMXSAMSXSXMAASMMMXMSMMAMASMXAXAMAAMMMSASAXMMMMMSAAXXMSSMXAAAMAMMASMSAAMMMSASASASMMXMMMAXAAAASMXMAXMXXAMXMAAAAAAMSSXMMMX
MSMASAXMSMMMAMAXSXMASXMMMXMXASMSMSMAAAXAAXMAMMMAXMMSMMAMAXSAMSMMAAXXAAMSAMAAXXXSMSMSMMSASXSSSXSAMXSAMXSXASMMSMMSMSAXSMMASMMMAXMMMSMMMAMXMXMX
SAMXMMMMAMMSMMSMAMSXMMXMASMMAMAXXAMSXSSSMSMXXMASXMAMASAMXMMXMAMXSMSAASMAMMSMMMMAAAMMAMMAMAMAXAMXMXMAXAMSXMAXAAAXMMXMAAAAXAASXSMSAMMXASXMASMS
SXSASAAMASAXXAXAMAXASAXMAMXMAMSMSMAXMAMAXSAXXSAMXMASXXAMXXXAMASXMASMMMMXMXMAAAAMMMMSAMMMMMMAMMMAMXSAMMXMSSXMSMMXSAMMSMMMSSMSAAXMAXAMXMAXAAXA
SASASXSSXSAMMMMSXSMXMASMSSMMAXMAMXAMASXMMMMSMMASMAAXAMASXMSXSASAMMMXAXXMMASXMMSXAAXMSMXMAMSXSAXAMMASMXASAMSAMAMAMASXMAAAMAAMMMMMAMMSAXXMXMAM
MAMAMMMAXMXXAASXXXAAXAMXMAMSSSMXAMXSXXAXMAAAXSAMXAMXMXAMAMAMMMSMMAAMSSMASASAMXXMMSMMXXXMAMXASASXMMAXMXXMAXXMSAMXSAMASMMSSMMMXMAMSSMAMAMSSSMX
MXMXMAMMMMASMXXSAXSMSAMMMAMMMAMSMSASMSXMSMSXXAMXAXSXSMMXAMASAMMMSMSMAAXAMASXXXMASAAMMMMSMSMMMMMMAMSMMXSSSMMMSXMXMAMXMAAAAASXMAMAMAXMAXMAAAXM
MSSSXXXXAXAXXXMMSMAXSAASMSSSMAMAAMAMXSAAXXAMSSMMSXMASXSSXSXSMSAMMAMMMMSXSMMXSAMXMSSMAAAAAXAAASMMSMAASXMAXAMAMXMAXAXSMMMMSMMMSSMSSSMXMXSMSMMA
MMAAASMSXSMSMSMAMSMMMAMXAAXMXMMMMMAMMMMSSMXXAAAAXAMAMAAMAMAMMSASMAMXXAMXXAXMMMSXMAMXSMSMSMSMMMAAMSSSMAMAMXMAXAAMXMXMAAAXMMAAAXAAAMAAMAMXAMXS
MMMMMMAAASXAAAMAMAMAMAMMMMXSASXSAMASAAAAMAMMSSMMSXMSMSMXAMAMXMXMXXSXMASMSSMSAAXXMAXXMMXAMAMMSSMMMXMAXSMMSASAMSXSASXSAMSSSSSSMMSMXMSAMMSXMSAM
SSSSSMXMMMAMSMSMMASASMSXMAMSAXASAXAXMMMXMAXXAXAXAAXXAAASXSMSXMASMXMASXAAAXASMSSMSMSMSMMXMAMXAAMAMMSSMXMASAMAXMASMXAASXMAAAAMXAXMAXMAMASAMXAM
AAAAXSSMMAXMXMAXMASMSMSAMAXMXMXMMMSSMXSASXSSMSMMSSMMMMXMXAXAXSASMAAAXMASMMXMAXMAAXAAAMSMSSSSMSMAMMAMXXMASAMMMMAMXMMMMMMMMMMMMASXXSSXMASAMMSS
MMMMMMSAASMMXMAMXAMXSXSASMSSMMSASXAAMASASXAAMXMAMMMSAMAMSSMSMMXSXXSAMAMXXMMMMXMSMSMSMSAAXMAXAXXXXMASXMMAMXMXSMMMSMXAXAMMSXMMMSSMXXXAMAXAMXAX
XSXSASMSMXAXMMASMAMXSASMMAAXAXSAMMXSMASMMMSMMXMMXAASMSMXAXAXSMAMAXMXASXMXXAAMMMAASAMXMMSMMSMMMAMSMMSAMXMSAMAMAAAMAMXMASAMAMXMAMXMXSSMASMMMMS
XAASMSAXXMXMMMASXSMMMXMAMMMMMMMMMMXMMXXAMXMAMSSSSMMSMAMMMMMMAMXSXSASXXASMSSXSAXMSMAMXSAMAAAASMSMXAASAMAMSXMAXSMSMSSSMAMMSMMAMMSASMAAAAXAAAAX
XMMMMMAMMSMMXMAXAMMXXASMSAAXAAXAAMXMASXSMASAAMAAXSAXMAMAXAMSMXMAMMAMMXAXAAXMXXMXXXXMMMASMXSMMXMASMMSMMSMMMSXMXMXAMAXMAMXAASASXSASMSMMMMXMMMX
MXAAAMAMAAASXSSMAMMSSMMXSXSSSSXSSSMXMAAXSXSMXMMMMMSSSSSSXMXMXSXXXMAMASMMSMXXXASMASMAXMMMMAMAMXMMMAAMMAXAXAAMSMSMAMMMMASMSXSASXMXMXXXXMAMSSSM
ASMSMSSMXMMMAAASXMSAXAAMXAMMAAAXAMMASMMMSMXMSAAMMAXMMXXAASMMASAMMXMMXXXAAAMSMMAMAMXAMXMAMAXMMXSSSXMSMMSSMMXMAAASAMXAMMAMXAMXMASASMAMSMMSAAMA
MSAMAXMASXXMMMMSMMMASMMSMSMAMMMMAMSASXMAXMASMSSSMSSMSMMSMMAMASAMAASMSXMMMXMAASXMASXXAMSAMXSXMAMXMMXXAMXAMXASMSMSMMMXSMAAMXMASAMMAMAAMAMMMMMX
MMAMMMMMMMAAAMXXAMMMMXAXAMAAMXXMXMMASAMMSSXSXAXXXMAAXXAAMSAMMMMMSASAMXMASASMXMMMXSAMAXMXMXAXMXSAMSMSXMXXMSXSAMXSAMXAMMMMMSSMMASMSSMSMMMAXXXX
XSAMXSXSASXSMSXSAMXSSMMMMMMMSXAMMXMASAMAMMMMMMMSMSMMMMSMXAASMMXAMXXAAXAXSASMSAMSAMXSMSMMMSMXXAMXSAAMMSAMXSXMASASASMXSAMAXAAXSAMMMAMMAMMSSMAS
XSAXAXMMASMAAXASXXMASMXAXAAXXXAMXXSXSMMMSAAAAAAAAXAMXXAMAMXAAXMXSAMXSSMMMMMMSAMAAXAXAAAAAAXMMXMMSMSMAAXAXSAXAMASAMXAMASXXMSMMMSMXAMSAMMXAMXA
ASAMSSMMMMMMMMMXMXMAMXSXSSSSMSSMMASAMXSASMSMXMXMMMMSMSMSMXMSXMMASAMAAAAMSXMXSAMSSMSSSSSMMSASXMSAXAMMMMXSXSXMASAMXMAMSMMXSXXMXXMAXSMSMSXMAMXX
MMAMMAXSSXMXSXMAMAMASMSAAAAAXAAASAMAMAMASMMMSSMSMMMAMXMAMAXXAMMASAMSSSMMSAMXMAMXXMMAMXAXXMAMAAMAMXMSAAMXMXMAXMASXSXMAAXAAAMAMMMAMXAMAAXSSMMS
XSAMSMMMAASAMAMSSMSXSAMMMMMMMSSMMMSAMASXMASAMXAAASXSMMSASXMSAMAMMXMAAAXASAMXMXMSXSMAMSMMXMAMMMMASXASMMAMMSXMASXMMMASMSMXMAMAAAMSSMAMMMMAAMAM
MSAXAXAMSMMASAMMAXXMMXXMASXXAXXXXMSMMXSMMXMAMMMMSMAMMASXSAAXMMSSMMMMSMMXMAMSMSAMAASAMAAAASXSMMAAAMAMAMSAAMMSAMMMMSAMAMMMMXSXSSXMAMXMMMMMSMMS
XSXSSSXMMMSMMXMSAMXXAAXMSMSMXSAMXMMMSMMASAXAMXXSXMAMMASXSMMMSAAAMXSMAMSMSMMAAMXMAMSMSSSSMSMSAAMASMASXMXMXXAAMAAAAMASAMSAMXAAXMASMMMXSXSAAASX
AMAMAXMASAXAAAXAAMMMMXMXAAXMASAMMXAAAMXMSXMMXAXMAXSXMASXSASAMMSMMAXSAXXAAXMMMMMXMMXMAMXMASASMMMXXXASXMSASMSMSSSSXMAMAXSSSXMAXAXASAAASAMXSXMX
MMAMMMXXMXSMMMSSMMAAXXSMMSMMXSXMMXMSSSSXSMASMXMASXMAMXSAMAMSSMXAMXXMMSMSMSMSSXXXMASMMSSMAMXMASXXMMMSAXMAMMXXXMAMXMSSMMXAXXXMASMMSMMSMAMAMMMM
AXASXXMMMASXAXMAASXMSMSAAXXMMSMSSMMXAAAAXAXMASAXMASAMSMXMSMMSAXAMXXAASXMASAAMSMXMAXMAAXMAXMSMMMMMAMMMMMMMASMSXSASMAAASMMSMMMAXAAMMMXMAMXXAAA
MSMSMSAAXAMMMMMSMMAAXAMXMXAMAMAXMASXMMMSMMSAMMSMXMMAMXAMMMAMXMSSMASMMSAMAMMMMAMAXMXMMSSSMXMXXAAAXSMMXSAAXMMAAAXASMMSMMAAAAAMMSMMMAXMSSSMSSMS
XAAMAMMXMMSASMXMXSMMMSMSSSSMSSSMSAMAASAMXAXAXMAMASMMMMXMASAMXAAAMMXMASAMAXAAXAMMMMASXMMAAASMSMSXXAASASMMMAMSMMMMMAAXXSMMSMXMMXMASMSMAAAAAXAM
SMSMSMSXXXMAMAAMAXAXXMAMAAXAXAMAMMMSMMMSMSSMMSASXSAMASASASAXXMSMMXAAMMXXMXSXSMSMASASAMXMSMSAAAAXMMMMASAMSMMMAMAAMXMXAXXMXXSMSAMXAMMMASMMMMMM
AAAXAXAXXMASMSMMMSMMMMAMMMMXMAMSMMAXAMASXMAXASASMSAMMSASASMMSXMASMMSMMAASAXASAAXAMASMMAXAAMMMSASMSMMMMXMAXASASXSMAXXXMMXMAXXXXMAMMMMAXXMSSSM
MSMSSSMMXAMXAAAXXAMAXSXSXMAXSAAXAMXXAMXSASAMMSXMASMMMMAMAMAASASAMAXMAMXSMASAMSMMSXMMAMXMMMMXMMAAAAXSMSMSMSMSASAMXXSXMAXMMSSMMSMXSAMSMSSXAAAM
XMAXAAXAMSMSSSMMSMMSMSXXMAXXMMSSSMSSXMSSMMMSAMAMAMAAMMMMXMMXSMMMSMMSAMXXMXMXMXXAAAXSXMAXAASAXMAMXMMMAAMAAMXMMMAMXMAXAMXXAAAAXSAAMMXAAAAMMSMM
SMMMXXMMXAAAXAMXAAXMXSXMASXSXXAAXAAAAMAMAAAMAMAMXXSMSSXSMSXMXXAAAAXSAXMSMSAMXXMASMMAASXSSSSXMMSXMSAMSMSMXMAXASAMAAXXMXSMMSSMMMMMSXSMSMMXMAMS
AAAMSSMMSMSMSMMSSMMMASAMAXMMMMMSMMSSMMASMMSSSMSMSMASXMAMSAXMASMSSSMSAMSAMAMMSMMMAASMMSAMXAMAXSXMASAXAAAMMSMSXSASXSMMSMMAXAAAXSAXSMSMXXXXSASM
SSMSAAAAXAMXXMXAMASMAMAMAXAAAAAAAMMAMXASAAAAAAAAAXMASMAMAMXMAMMAAAMMAMSASXSAAAXXMMMAAXAXMAMSMMAMAXMSMSMSAAMSASAMAAXAAASXMASXMASMSAMXSMSAMXAM
AAMMXSMASAMXMXMASXMASMXMMSSSSMSSSMSXMMASMMMSMMMSMSAMXMASMXSASMMMSMMSMMSXMAMMSSMAXXSMMMMXSASAASXMXSASAMXMMSSMAMAMSXMSSMMMSAMXMAMXMXMASAMXMSMX''';
