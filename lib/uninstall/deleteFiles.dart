import "dart:io";

import "package:git_hooks/git_hooks.dart";
import 'package:git_hooks/utils/utils.dart';

deleteFiles() async {
  Directory rootDir = Directory.current;
  Logger logger = new Logger.standard();

  Directory gitDir = Directory(Utils.uri(rootDir.path + "/.git/"));
  String gitHookDir = Utils.uri(rootDir.path + "/.git/hooks/");
  if (!gitDir.existsSync()) {
    print(gitDir.path);
    throw new ArgumentError('.git is not exists in your project');
  }
  Progress progress = logger.progress('delete files');
  for (var hook in hookList.values) {
    String path = gitHookDir + hook;
    var hookFile = new File(path);
    if (hookFile.existsSync()) {
      await hookFile.delete();
    }
  }
  File hookFile = new File(Utils.uri(rootDir.path + '/git_hooks.dart'));
  if (hookFile.existsSync()) {
    await hookFile.delete();
    print("git_hooks.dart deleted successfully!");
  }
  progress.finish(showTiming: true);
  print("All files deleted successfully!");
  await Process.run('pub', ['global', 'deactivate', 'git_hooks'])
      .catchError((onError) => print(onError));
  print("git_hooks uninstalled successsfull!");
  return true;
}
