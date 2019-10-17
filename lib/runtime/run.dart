import 'dart:io';
import 'package:git_hooks/git_hooks.dart';
import 'package:git_hooks/utils/type.dart';

run(List<String> arguments) async {
  try {
    Logger logger = new Logger.standard();
    Ansi ansi = new Ansi(true);
    Progress progress = logger.progress('start ${arguments[1]} hook');
    print('');
    Directory rootDir = Directory.current;
    print(uri(rootDir.path + "/git_hooks.dart"));
    try {
      String hookPath = uri(rootDir.path + "/git_hooks.dart");
      if (!File(hookPath).existsSync()) {
        print(ansi.subtle(
            "check 'git_hooks.dart' file in your project,you can use 'git_hooks create' to create a default one."));
        exit(0);
      }
      ProcessResult result =
          await Process.run('dart', [hookPath, ...arguments.sublist(1)]);
      if (result.stderr.length != 0) {
        print(ansi.error(result.stderr));
        print(ansi.subtle(
            "You can check 'git_hooks' in your pubspec.yaml,and use 'pub get' or 'flutter pub get' again"));
        exit(1);
      }
      if (result.stdout.length != 0) {
        print(result.stdout);
      }
      progress.finish(showTiming: true);
      if (result.exitCode == 1) {
        exit(1);
      }
    } catch (e) {
      print(e);
      print(Ansi(true).subtle(
          "You can check 'git_hooks' in your pubspec.yaml,and use 'pub get' or 'flutter pub get' again"));
      exit(1);
    }
  } catch (e) {
    print(e);
  }
}
