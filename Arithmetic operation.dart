void main() {
  var n1 = 10;
  var n2 = 3;
  var result = n1 / n2;
  print(result);

  var result1 = n1 ~/ n2;
  print(result1);

  var name = "Mahfuzar Rahman";
  var result2 = name is String;
  print(result2);

  //ternery operation
  String color = "red";
  String result3 = (color == "red") ? "Red" : "Blue";
  print(result3);
  //null check operator
  int? age;
  var result4 = age ?? 25;
  print(result4);
}
