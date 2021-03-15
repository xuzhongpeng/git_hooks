import 'dart:io';

import 'package:git_hooks/git_hooks.dart';
import 'package:git_hooks/install/create_hooks.dart';
import 'package:test/test.dart';

void main() {
  var _rootDir = Directory.current.path;
  var _tmp = '$_rootDir/.dart_tool/tmp';
  var hooksDirUri = Utils.uri('$_tmp/.gitHooks/hooks');
  Utils.setGitHooksFolder(hooksDirUri);

  tearDown(() {
    var dir = Directory('$_rootDir/.dart_tool/tmp');
    dir.delete(recursive: true);
  });
  group('test install', () {
    test('test copy file', () async {
      var dartFileUri = Utils.uri('.dart_tool/tmp/.gitHooks/test.dart');
      Utils.setGitHooksFolder(hooksDirUri);
      await CreateHooks.copyFile(targetPath: dartFileUri);
      // test dart file is exists
      var dartFile = File(dartFileUri);
      expect(true, dartFile.existsSync());

      // test hooks files is exists
      var hookFile = File('$hooksDirUri/${hookList.values.first}');
      expect(true, hookFile.existsSync());
    });

    test('test uninstall files', () async {
      await GitHooks.unInstall();
      // test hooks files is exists
      var hookFile = File('$hooksDirUri/${hookList.values.first}');
      expect(false, hookFile.existsSync());
    });
  });
}
