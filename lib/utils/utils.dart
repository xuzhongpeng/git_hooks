import 'package:path/path.dart' as path;
import 'dart:io';

typedef UserBackFun = Future<bool> Function();

/// utils class
class Utils {
  /// check the file Path
  static String uri(String filePath) {
    return path.fromUri(path.toUri(filePath));
  }

  /// get path of git_hooks library
  static String getOwnPath() {
    var pacPath = path.fromUri(path.current + '/.packages');
    var pac = File(pacPath);
    var a = pac.readAsStringSync();
    var b = a.split('\n');
    String resPath;
    b.forEach((v) {
      if (v.startsWith('git_hooks:')) {
        var index = v.indexOf(':');
        var lastIndex = v.lastIndexOf('lib');
        resPath = v.substring(index + 1, lastIndex);
      }
    });
    resPath = path.fromUri(resPath);
    if (path.isRelative(resPath)) {
      resPath = path.canonicalize(resPath);
    }
    if (!Directory(resPath).existsSync()) {
      return null;
    }
    return resPath;
  }

  /// get commit edit msg from '.git/COMMIT_EDITMSG'
  static String getCommitEditMsg() {
    var rootDir = Directory.current;
    var myFile = File(Utils.uri('${rootDir.path}/.git/COMMIT_EDITMSG'));
    var commitMsg = myFile.readAsStringSync();
    return commitMsg;
  }
}
