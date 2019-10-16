import 'dart:io';
import "package:path/path.dart" show dirname;
import 'package:git_hooks/git_hooks.dart';
import 'package:yaml/yaml.dart';

class CreateHooks {
  Directory rootDir = Directory.current;
  String nowDir = dirname(Platform.script.path);
  Future<bool> copyFile() async {
    Logger logger = new Logger.standard();
    try {
      var commonFile = new File(nowDir + '/install/common');
      String commonStr = commonFile.readAsStringSync();
      commonStr = _createHeader() + commonStr;
      Directory gitDir = Directory(rootDir.path + "/.git/");
      String gitHookDir = rootDir.path + "/.git/hooks/";
      if (!gitDir.existsSync()) {
        print(gitDir.path);
        throw new ArgumentError('.git is not exists in your project');
      }
      Progress progress = logger.progress('create files');
      for (var hook in hookList.values) {
        String path = gitHookDir + hook;
        var hookFile = new File(path);
        if (!hookFile.existsSync()) {
          await hookFile.create();
        }
        await hookFile.writeAsString(commonStr);
        await Process.run('chmod', ['777', path])
            .catchError((onError) => print(onError));
      }
      File hookFile = new File(rootDir.path + '/git_hooks.dart');
      if (!hookFile.existsSync()) {
        File example = new File(nowDir + '/install/git_hooks_example');
        String exampleStr = await example.readAsStringSync();
        await hookFile.createSync();
        await hookFile.writeAsStringSync(exampleStr);
      }
      progress.finish(showTiming: true);
      print("all files write success!");
      return true;
    } catch (e) {
      print(e.toString());
      return false;
    }
  }

  String _createHeader() {
    File f = new File(rootDir.path + "/pubspec.yaml");
    String text = f.readAsStringSync();
    Map yaml = loadYaml(text);
    String name = yaml['name'];
    String author = yaml['author'];
    String version = yaml['version'];
    String homepage = yaml['homepage'];
    return '''
#!/bin/sh
# ${name}
# Hook created by ${author}
#   Version: ${version}
#   At: ${DateTime.now()}
#   See: ${homepage}#readme

# From
#   Directory: ${nowDir}
#   Homepage: ${homepage}#readme

''';
  }
}
