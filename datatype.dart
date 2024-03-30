class TestClass {
  void disp() {
    print("This is a test class");
  }
}

void main() {
  print("Hello world!");
  int age = 30;
  print(age);
  double time = 12.30;
  print(time);
  String name = "Mahfuzar Rahman";
  print(name);
  TestClass test = new TestClass();
  test.disp();
  var roll = 3;
  print(roll);
  var name2 = "Masud";
  print(name2);

  const pi = 3.1416;
  const area = pi * 12 * 12;
  print("The output is ${area}");

  List myList = [
    "one",
    "two",
    "three",
    "four",
    "five",
    "six",
    "seven",
    "eight"
  ];
  print(myList);
  for (var i = 0; i < myList.length; i++) {
    print(myList[i]);
  }

  print("List print in another way: ");

  for (String list in myList) {
    print(list);
  }
  Map<String, dynamic> myMap = {"name": "Mahfuzar", "age": 30};
  print(myMap);

  print("Key print of map : ");
  for (var key in myMap.keys) {
    print(key);
  }
  print("Value print of map : ");
  for (var value in myMap.values) {
    print(value);
  }

  for (var entry in myMap.entries) {
    print(entry.key + " :  " + "${entry.value}");
  }

  Set mySet = {1, 2, 3, 4, 5, 6, 7, 8, 9, 10};
  print(mySet);
  final nametwo = 'Mahfuzar';
  print(nametwo.codeUnits);

  Runes input = Runes('\u{1f49b}');
  print(String.fromCharCodes(input));
}
