import "dart:io";
import "package:git_hooks/git_hooks.dart";
import 'package:git_hooks/utils/utils.dart';
import "./hook_template.dart";
import 'package:path/path.dart';

typedef HooksCommandFile = Future<bool> Function(File file);

class CreateHooks {
  static String rootDir = Directory.current.path;
  static Future<bool> copyFile({String targetPath}) async {
    if (targetPath == null) {
      targetPath = '/git_hooks.dart';
    } else {
      if (!targetPath.endsWith(".dart")) {
        print("the file what you want to create is not a dart file");
        exit(1);
      }
    }
    targetPath = '${rootDir}/${targetPath}';
    File hookFile = new File(Utils.uri(absolute(rootDir, targetPath)));
    Logger logger = new Logger.standard();
    try {
      String commonStr = commonHook(hookFile.path);
      commonStr = createHeader() + commonStr;
      Progress progress = logger.progress('create files');
      await _hooksCommand((hookFile) async {
        if (!hookFile.existsSync()) {
          await hookFile.create(recursive: true);
        }
        await hookFile.writeAsString(commonStr);
        if (!Platform.isWindows) {
          await Process.run('chmod', ['777', hookFile.path])
              .catchError((onError) => print(onError));
        }
        return true;
      });
      if (!hookFile.existsSync()) {
        String exampleStr = userHooks;
        await hookFile.createSync(recursive: true);
        await hookFile.writeAsStringSync(exampleStr);
      }
      print("All files wrote successful!");
      progress.finish(showTiming: true);
      return true;
    } catch (e) {
      print(e.toString());
      return false;
    }
  }

  static Future<String> getTargetFilePath() async {
    String commandPath = '';
    await _hooksCommand((hookFile) async {
      String hookTemplate = hookFile.readAsStringSync();
      var match= RegExp(r'dart\s(\S+)\s\$hookName').allMatches(hookTemplate).first;
      commandPath = match.group(1);
      return false;
    });
    return commandPath;
  }

  static Future<void> _hooksCommand(HooksCommandFile callBack) async {
    Directory gitDir = Directory(Utils.uri(rootDir + "/.git/"));
    String gitHookDir = Utils.uri(rootDir + "/.git/hooks/");
    if (!gitDir.existsSync()) {
      throw new ArgumentError('.git is not exists in your project');
    }
    for (var hook in hookList.values) {
      String path = gitHookDir + hook;
      var hookFile = new File(path);
      if (!await callBack(hookFile)) {
        return;
      }
    }
  }
}
