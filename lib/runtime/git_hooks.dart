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
  static void init({String? targetPath}) async {
    await CreateHooks.copyFile(targetPath: targetPath);
  }

  /// unInstall git_hooks
  static Future<bool> unInstall({String? path}) {
    return deleteFiles();
  }

  /// get target file path.
  /// returns the path that the git hooks points to.
  static Future<String?> getTargetFilePath({String? path}) async {
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
  static void call(List<dynamic> argument, Map<Git, UserBackFun> params) async {
    var type = argument[0];
    try {
      params.forEach((userType, function) async {
        if (hookList[userType.toString().split('.')[1]] == type) {
          if (!await params[userType]!()) {
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
