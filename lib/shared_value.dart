import 'package:shared_value/shared_value.dart';

final SharedValue<dynamic> millId = SharedValue(
  value: "", // initial value
  key: "millID", // disk storage key for shared_preferences
  autosave: true, // autosave to shared prefs when value changes
);
final SharedValue<dynamic> userCategory = SharedValue(
  value: "", // initial value
  key: "userCategory", // disk storage key for shared_preferences
  autosave: true, // autosave to shared prefs when value changes
);
final SharedValue<dynamic> userId = SharedValue(
    value: "",
    key: "userId",
    autosave: true
);
