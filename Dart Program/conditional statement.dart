import 'dart:html';

void main() {
  String connection = "connected";
  if (connection == 'connected') {
    print("connected");
  } else if (connection == 'waiting') {
    print('waiting');
  } else {
    print('disconnected');
  }
/**switch case*/
  switch (connection) {
    case 'connnected':
      print('connected');
      break;
    case 'waiting':
      print('waitng ');
      break;
    default:
      print('disconnected');
  }
}
