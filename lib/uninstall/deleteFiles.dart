import 'dart:io';
import 'package:git_hooks/utils/logging.dart';
import 'package:git_hooks/utils/utils.dart';

import '../git_hooks.dart';
/// delete all file from `.git/hooks`
Future<bool> deleteFiles() async {
  Directory rootDir = Directory.current;
  Logger logger = Logger.standard();

  Directory gitDir = Directory(Utils.uri(rootDir.path + '/.git/'));
  String gitHookDir = Utils.uri(rootDir.path + '/.git/hooks/');
  if (!gitDir.existsSync()) {
    print(gitDir.path);
    throw ArgumentError('.git is not exists in your project');
  }
  Progress progress = logger.progress('delete files');
  for (var hook in hookList.values) {
    String path = gitHookDir + hook;
    var hookFile = File(path);
    if (hookFile.existsSync()) {
      await hookFile.delete();
    }
  }
  File hookFile = File(Utils.uri(rootDir.path + '/git_hooks.dart'));
  if (hookFile.existsSync()) {
    await hookFile.delete();
    print('git_hooks.dart deleted successfully!');
  }
  progress.finish(showTiming: true);
  print('All files deleted successfully!');
  await Process.run('pub', ['global', 'deactivate', 'git_hooks'])
      .catchError((onError) => print(onError));
  print('git_hooks uninstalled successsfull!');
  return true;
}
