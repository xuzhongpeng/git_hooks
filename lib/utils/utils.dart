import 'package:path/path.dart' as path;
import 'dart:io';

typedef Future<bool> UserBackFun();

class Utils {
  static String uri(String file) {
    return path.fromUri(path.toUri(file));
  }
  /// get path of git_hooks library 
  static String getOwnPath() {
    String pacPath = path.fromUri(path.current + '/.packages');
    File pac = File(pacPath);
    String a = pac.readAsStringSync();
    List<String> b = a.split('\n');
    String resPath;
    b.forEach((v) {
      if (v.startsWith('git_hooks:')) {
        int index = v.indexOf(':');
        int lastIndex = v.lastIndexOf('lib');
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
    Directory rootDir = Directory.current;
    File myFile = new File(Utils.uri("${rootDir.path}/.git/COMMIT_EDITMSG"));
    String commitMsg = myFile.readAsStringSync();
    return commitMsg;
  }
}
