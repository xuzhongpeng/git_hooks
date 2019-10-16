export "package:git_hooks/utils/logging.dart";
export "package:git_hooks/utils/type.dart";
import 'dart:io';

import "package:git_hooks/utils/type.dart";

void change(List<String> argument, Map<Git, UserBackFun> params) async {
  String type = argument[0];
  try {
    params.keys.forEach((userType) async {
      if (hookList[userType.toString().split(".")[1]] == type) {
        if (!await params[userType]()) {
          exit(1);
        }
      }
    });
  } catch (e) {
    print(e);
    print('git_hooks crashed when call ${type},check your function');
  }
}
