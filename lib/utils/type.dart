import 'package:path/path.dart' as path;
import 'dart:io';
import 'package:git_hooks/git_hooks.dart';

enum Git {
  applypatchMsg,
  preApplypatch,
  postApplypatch,
  preCommit,
  prepareCommitMsg,
  commitMsg,
  postCommit,
  preRebase,
  postCheckout,
  postMerge,
  prePush,
  preReceive,
  update,
  postReceive,
  postUpdate,
  pushToCheckout,
  preAutoGc,
  postRewrite,
  sendemailValidate
}
final Map<String, String> hookList = {
  'applypatchMsg': 'applypatch-msg',
  'preApplypatch': 'pre-applypatch',
  'postApplypatch': 'post-applypatch',
  'preCommit': 'pre-commit',
  'prepareCommitMsg': 'prepare-commit-msg',
  'commitMsg': 'commit-msg',
  'postCommit': 'post-commit',
  'preRebase': 'pre-rebase',
  'postCheckout': 'post-checkout',
  'postMerge': 'post-merge',
  'prePush': 'pre-push',
  'preReceive': 'pre-receive',
  'update': 'update',
  'postReceive': 'post-receive',
  'postUpdate': 'post-update',
  'pushToCheckout': 'push-to-checkout',
  'preAutoGc': 'pre-auto-gc',
  'postRewrite': 'post-rewrite',
  'sendemailValidate': 'sendemail-validate'
};
typedef Future<bool> UserBackFun();
String uri(String file) {
  return path.fromUri(path.toUri(file));
}

String getOwnPath() {
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
