void main() {
  var angka = [1, 2, 3];
  var total = angka.reduce((value, element) => element + value);
  print(total);
}
