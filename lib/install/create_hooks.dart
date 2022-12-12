import 'dart:io';
import 'package:git_hooks/utils/logging.dart';
import 'package:git_hooks/utils/utils.dart';
import '../git_hooks.dart';
import './hook_template.dart';
import 'package:path/path.dart';

typedef _HooksCommandFile = Future<bool> Function(File file);
String _rootDir = Directory.current.path;

/// install hooks
class CreateHooks {
  /// Create files to `.git/hooks` and [targetPath]
  static Future<bool> copyFile({String? targetPath}) async {
    if (targetPath == null) {
      targetPath = 'git_hooks.dart';
    } else {
      if (!targetPath.endsWith('.dart')) {
        print('the file what you want to create is not a dart file');
        exit(1);
      }
    }
    var relativePath = '${_rootDir}/${targetPath}';
    var hookFile = File(Utils.uri(absolute(_rootDir, relativePath)));
    var logger = Logger.standard();
    try {
      var commonStr = commonHook(Utils.uri(targetPath));
      commonStr = createHeader() + commonStr;
      var progress = logger.progress('create files');
      await _hooksCommand((hookFile) async {
        if (!hookFile.existsSync()) {
          await hookFile.create(recursive: true);
        }
        await hookFile.writeAsString(commonStr);
        if (!Platform.isWindows) {
          await Process.run('chmod', ['777', hookFile.path])
              .catchError((onError) {
            print(onError);
          });
        }
        return true;
      });
      if (!hookFile.existsSync()) {
        var exampleStr = userHooks;
        hookFile.createSync(recursive: true);
        hookFile.writeAsStringSync(exampleStr);
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
  static Future<String?> getTargetFilePath() async {
    String? commandPath = '';
    await _hooksCommand((hookFile) async {
      var hookTemplate = hookFile.readAsStringSync();
      var match = RegExp(r'dart\s(\S+)\s\$hookName').firstMatch(hookTemplate);
      if (match is RegExpMatch) {
        commandPath = match.group(1)!;
        return false;
      }
      return true;
    });
    return commandPath;
  }

  static Future<void> _hooksCommand(_HooksCommandFile callBack) async {
    var gitDir = Directory(Utils.uri(_rootDir + '/.git/'));
    var gitHookDir = Utils.gitHookFolder;
    if (!gitDir.existsSync()) {
      throw ArgumentError('.git is not exists in your project');
    }
    for (var hook in hookList.values) {
      var path = gitHookDir + hook;
      var hookFile = File(path);
      if (!await callBack(hookFile)) {
        return;
      }
    }
  }
}
