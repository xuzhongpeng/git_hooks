import 'dart:io';
import 'package:git_hooks/utils/logging.dart';
import 'package:git_hooks/utils/utils.dart';

import 'package:git_hooks/git_hooks.dart';

/// delete all file from `.git/hooks`
Future<bool> deleteFiles() async {
  final rootDir = Directory.current;
  final logger = Logger.standard();

  final gitDir = Directory(Utils.uri('${rootDir.path}/.git/'));
  final gitHookDir = Utils.gitHookFolder;
  if (!gitDir.existsSync()) {
    print(gitDir.path);
    throw ArgumentError('.git is not exists in your project');
  }
  final progress = logger.progress('delete files');
  for (final hook in hookList.values) {
    final path = gitHookDir + hook;
    final hookFile = File(path);
    if (hookFile.existsSync()) {
      await hookFile.delete();
    }
  }
  final hookFile = File(Utils.uri('${rootDir.path}/git_hooks.dart'));
  if (hookFile.existsSync()) {
    await hookFile.delete();
    print('git_hooks.dart deleted successfully!');
  }
  progress.finish(showTiming: true);
  print('All files deleted successfully!');
  await Process.run('pub', ['global', 'deactivate', 'git_hooks']);
  print('git_hooks uninstalled successful!');
  return true;
}
