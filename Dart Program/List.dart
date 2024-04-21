void main() {
  List numbers = ["one", "two", "three", "four", "five", "six"];
  print(numbers);
  print("For loop ...");
  for (int i = 0; i < numbers.length; i++) {
    print(numbers[i]);
  }
  print("For .. in loop...");
//list print using foreach loop
  for (var number in numbers) {
    print(number);
  }

  print("forEach loop ....");
  numbers.forEach((element) => print(element));

  List<int> roll = [1, 2, 3, 4, 5];
  for (var i in roll) {
    print(i);
  }
  roll.add(5);
  roll.addAll([6, 9, 8]);

  print("List after adding");
  roll.forEach((element) => print(element));

  roll.remove(3); //remove 3 from the list
  print("List after removing");
  roll.forEach((element) => print(element));

  roll.removeAt(4);
  print("List after removing at index 4");
  roll.forEach((element) => print(element));

  roll.sort();
  print("List after sorting");
  roll.forEach((element) => print(element));

  var selectedroll = roll.sublist(0, 3);
  print("List after sublist");
  selectedroll.forEach((element) => print(element));
}
