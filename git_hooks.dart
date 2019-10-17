import "package:git_hooks/git_hooks.dart";
import "dart:io";

void main(List arguments) {
  Map<Git, UserBackFun> params = {Git.commitMsg: commitMsg};
  change(arguments, params);
}

Future<bool> commitMsg() async {
  Directory rootDir = Directory.current;
  File myFile = new File(uri("${rootDir.path}/.git/COMMIT_EDITMSG"));
  String commitMsg = myFile.readAsStringSync();
  print(commitMsg);
  if (commitMsg.startsWith('fix:')) {
    return false;
  } else {
    return false;
  }
}
