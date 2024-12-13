void main() {
  List<String> lines = inputString.split('\n');
  print(lines);
  final fencePrice = calculateFencePrice(lines);
  print('fencePrice: $fencePrice');
}

int calculateFencePrice(List<String> lines) {
  int fields = 0;
  int fenceLength = 0;
  int fencePrice = 0;

  for (int x = 0; x < lines.length; x++) {
    for (int y = 0; y < lines[x].length; y++) {
      if (lines[x][y] == '#' || lines[x][y] == '\$') {
        continue;
      }
      final actualChar = lines[x][y];
      print('actualChar: $actualChar');
      final response = checkNeighBors(lines, x, y, actualChar);
      fields += response.key;
      fenceLength += response.value;
      print('fields: $fields');
      print('fenceLength: $fenceLength');
      fencePrice += fields * fenceLength;
      fenceLength = 0;
      fields = 0;
      // replace all '#' with '$' to avoid checking them again
      for (int i = 0; i < lines.length; i++) {
        lines[i] = lines[i].replaceAll('#', '\$');
      }
    }
  }

  return fencePrice;
}

// recursive function to check the neighbours of the actual character
MapEntry<int, int> checkNeighBors(List<String> lines, int x, int y, String actualChar) {
  int fenceLength = 0;
  int fields = 1;
  lines[x] = lines[x].replaceRange(y, y + 1, '#');

  for (String direction in directions.keys) {
    int dx = directions[direction]![0];
    int dy = directions[direction]![1];
    if (x + dx >= 0 && x + dx < lines.length && y + dy >= 0 && y + dy < lines[x].length) {
      if (actualChar == lines[x + dx][y + dy]) {
        final response = checkNeighBors(lines, x + dx, y + dy, actualChar);
        fields += response.key;
        fenceLength += response.value;
      } else if (lines[x + dx][y + dy] != '#') {
        fenceLength++;
      }
    } else {
      fenceLength++;
    }
  }

  return MapEntry(fields, fenceLength);
}

final inputString = '''
AAAA
BBCD
BBCC
EEEC''';

Map<String, List<int>> directions = {
  'E': [0, 1],
  'S': [1, 0],
  'W': [0, -1],
  'N': [-1, 0],
};

// create a Map with all corners
Map<String, List<String>> corners = {
  'NE': ['N', 'E'],
  'SE': ['S', 'E'],
  'SW': ['S', 'W'],
  'NW': ['N', 'W'],
};
