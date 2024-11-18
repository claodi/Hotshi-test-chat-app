import 'package:shared_value/shared_value.dart';

final SharedValue<String?> access_token = SharedValue(
  value: "", // initial value
  key: "access_token", // disk storage key for shared_preferences
  autosave: true, // autosave to shared prefs when value changes
);

final SharedValue<int?> user_id = SharedValue(
  value: 0, // initial value
  key: "user_id", // disk storage key for shared_preferences
  //autosave: true, // autosave to shared prefs when value changes
);

final SharedValue<String?> auth_user_id = SharedValue(
  value: '0', // initial value
  key: "auth_user_id", // disk storage key for shared_preferences
  //autosave: true, // autosave to shared prefs when value changes
);

final SharedValue<String?> user_name = SharedValue(
  value: "", // initial value
  key: "user_name", // disk storage key for shared_preferences
  autosave: true, // autosave to shared prefs when value changes
);

// void main() async {
//   // Load data value from shared preferences
//   await access_token.load();
//   await user_id.load();
//   await user_name.load();
//   await auth_user_id.load();
// }
