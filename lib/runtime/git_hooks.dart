import 'dart:io';
import 'package:git_hooks/utils/logging.dart';
import 'package:git_hooks/utils/type.dart';
import 'package:git_hooks/install/create_hooks.dart';
import 'package:git_hooks/uninstall/deleteFiles.dart';
import 'package:git_hooks/utils/utils.dart';

/// create files or call hooks functions
class GitHooks {
  static final Ansi _ansi = Ansi(true);

  /// create files from dart codes.
  /// [targetPath] is the absolute path
  static void init({String targetPath}) async {
    await Process.run('git_hooks', ['-v']).catchError((onError) async {
      var result = await Process.run('pub', [
        'global',
        'activate',
        '--source',
        'path',
        Utils.getOwnPath()
      ]).catchError((onError) => print(onError));
      print(result.stdout);
      if (result.stderr.length != 0) {
        print(_ansi.error(result.stderr));
        print(_ansi.subtle(
            'You can check \'git_hooks\' in your pubspec.yaml,and use \'pub get\' or \'flutter pub get\' again'));
        exit(1);
      }
      await CreateHooks.copyFile(targetPath: targetPath);
    });
  }

  /// unInstall git_hooks
  static void unInstall({String path}) async {
    await deleteFiles();
  }

  /// get target file path.
  /// returns the path that the git hooks points to.
  static Future<String> getTargetFilePath({String path}) async {
    return CreateHooks.getTargetFilePath();
  }

  /// ```dart
  /// Map<Git, UserBackFun> params = {
  ///   Git.commitMsg: commitMsg,
  ///   Git.preCommit: preCommit
  /// };
  /// GitHooks.call(arguments, params);
  /// ```
  /// [argument] is just passthrough from main methods. It may ['pre-commit','commit-msg'] from [hookList]
  static void call(List<String> argument, Map<Git, UserBackFun> params) async {
    var type = argument[0];
    try {
      params.keys.forEach((userType) async {
        if (hookList[userType.toString().split('.')[1]] == type) {
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
}
