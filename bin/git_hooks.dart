import "dart:io";

import 'package:git_hooks/install/create_hooks.dart';
import 'package:git_hooks/runtime/git_hooks.dart';
import 'package:git_hooks/utils/utils.dart';
import "package:yaml/yaml.dart";

main(List<String> arguments) {
  if (arguments.isNotEmpty) {
    String str = arguments[0];
    if (arguments.length >= 1) {
      if (str == 'create') {
        //init files
        String targetPath = arguments[1];
        if (targetPath is String && targetPath.endsWith(".dart")) {
          CreateHooks.copyFile(targetPath: targetPath);
        } else
          CreateHooks.copyFile();
      } else if (str == '-h' || str == '-help') {
        help();
      } else if (str == '-v' || str == '--version') {
        File f = new File(Utils.uri(Utils.getOwnPath()! + "/pubspec.yaml"));
        String text = f.readAsStringSync();
        Map yaml = loadYaml(text);
        String version = yaml['version'];
        print(version);
      } else if (str == 'uninstall') {
        GitHooks.unInstall();
      } else {
        print("'${str}' is not a git_hooks command,see follow");
        print('');
        help();
      }
    } else {
      print(
          "Too many positional arguments: 1 expected, but ${arguments.length} found");
      print('');
      help();
    }
  } else {
    print("please Enter the command");
    print('');
    help();
  }
}

void help() {
  print("Common commands:");
  print("");
  print(" git_hooks create {{targetPath}}");
  print("   Create hooks files in '.git/hooks'");
  print("");
}
