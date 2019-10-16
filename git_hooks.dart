import "package:git_hooks/git_hooks.dart";
import "dart:io";

void main(List arguments) {
  Map<Git, UserBackFun> params = {
    Git.commitMsg: commitMsg,
  };
  change(arguments, params);
}

Future<bool> commitMsg() async {
  Directory rootDir = Directory.current;
  File myFile = new File(rootDir.path + "/.git/COMMIT_EDITMSG");
  print("commit message is '${myFile.readAsStringSync()}'");
  print('this is commitMsg');
  return false;
}
