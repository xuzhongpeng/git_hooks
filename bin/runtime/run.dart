import 'dart:io';
import 'package:git_hooks/git_hooks.dart';

run(List<String> arguments) async {
  try {
    Logger logger = new Logger.standard();
    Progress progress = logger.progress('start ${arguments[1]} hook');
    print('');
    Directory rootDir = Directory.current;
    ProcessResult result = await Process.run(
        'dart', [rootDir.path + "/git_hooks.dart", ...arguments.sublist(1)]);
    if (result.stdout.length != 0) {
      print(result.stdout);
    }
    progress.finish(showTiming: true);
    if (result.exitCode != 0) {
      exit(1);
    }
  } catch (e) {
    print(e);
  }
}
