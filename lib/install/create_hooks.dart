// ignore_for_file: avoid_print

import 'dart:io';

import 'package:git_hooks/git_hooks.dart';
import 'package:git_hooks/install/hook_template.dart';
import 'package:git_hooks/utils/logging.dart';
import 'package:path/path.dart';

String _rootDir = Directory.current.path;

/// install hooks
class CreateHooks {
  /// Create files to `.git/hooks` and [targetPath]
  static Future<bool> copyFile({String targetPath = 'git_hooks.dart'}) async {
    if (!targetPath.endsWith('.dart')) {
      print('the file what you want to create is not a dart file');
      exit(1);
    }
    final relativePath = '$_rootDir/$targetPath';
    final hookFile = File(Utils.uri(absolute(_rootDir, relativePath)));
    final logger = Logger.standard();
    try {
      var commonStr = commonHook(Utils.uri(targetPath));
      commonStr = createHeader() + commonStr;
      final progress = logger.progress('create files');
      await _hooksCommand((hookFile) async {
        if (!hookFile.existsSync()) {
          await hookFile.create(recursive: true);
        }
        await hookFile.writeAsString(commonStr);
        if (!Platform.isWindows) {
          await Process.run('chmod', ['777', hookFile.path]).catchError(print);
        }
        return true;
      });
      if (!hookFile.existsSync()) {
        const exampleStr = userHooks;
        hookFile
          ..createSync(recursive: true)
          ..writeAsStringSync(exampleStr);
      }
      print('All files wrote successful!');
      progress.finish(showTiming: true);
      return true;
    } catch (e) {
      print(e.toString());
      return false;
    }
  }

  /// get target file path.
  /// returns the path that the git hooks points to.
  static Future<String> getTargetFilePath() async {
    var commandPath = '';
    await _hooksCommand((hookFile) async {
      final hookTemplate = hookFile.readAsStringSync();
      final match =
          RegExp(r'dart\s(\S+)\s\$hookName').allMatches(hookTemplate).first;
      commandPath = match.group(1)!;
      return false;
    });
    return commandPath;
  }

  static Future<void> _hooksCommand(
    Future<bool> Function(File) callBack,
  ) async {
    final gitDir = Directory(Utils.uri('$_rootDir/.git/'));
    final gitHookDir = Utils.gitHookFolder;
    if (!gitDir.existsSync()) {
      throw ArgumentError('.git is not exists in your project');
    }
    for (final hook in hookList.values) {
      final path = gitHookDir + hook;
      final hookFile = File(path);
      if (!await callBack(hookFile)) {
        return;
      }
    }
  }
}
