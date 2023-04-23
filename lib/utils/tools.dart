List<int> intToByte(int number, int length) {
  String hexString = number.toRadixString(16).toUpperCase();
  List<int> bytes = [];
  for (int i = 0; i < hexString.length; i += 2) {
    bytes.add(int.parse(hexString.substring(i, i + 2), radix: 16));
  }
  while (bytes.length < length) {
    bytes.insert(0, 0);
  }
  return bytes;
}
