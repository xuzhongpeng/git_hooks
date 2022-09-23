import 'dart:io';

import 'package:git_hooks/install/create_hooks.dart';
import 'package:git_hooks/runtime/git_hooks.dart';
import 'package:git_hooks/utils/utils.dart';
import 'package:yaml/yaml.dart';

void main(List<String> arguments) {
  if (arguments.isNotEmpty) {
    final str = arguments[0];
    if (arguments.isNotEmpty) {
      if (str == 'create') {
        //init files
        String? targetPath;
        if (arguments.length == 2) {
          targetPath = arguments.last;
        }
        if (targetPath != null && targetPath.endsWith('.dart')) {
          CreateHooks.copyFile(targetPath: targetPath);
        } else {
          CreateHooks.copyFile();
        }
      } else if (str == '-h' || str == '-help') {
        help();
      } else if (str == '-v' || str == '--version') {
        final f = File(Utils.uri('${Utils.getOwnPath()}/pubspec.yaml'));
        final text = f.readAsStringSync();
        final yaml = loadYaml(text) as YamlMap;
        final version = yaml['version'];
        print(version);
      } else if (str == 'uninstall') {
        GitHooks.unInstall();
      } else {
        print('$str is not a git_hooks command,see follow');
        print('');
        help();
      }
    } else {
      print(
        'Too many positional arguments: 1 expected, but ${arguments.length} found',
      );
      print('');
      help();
    }
  } else {
    print('please Enter the command');
    print('');
    help();
  }
}

void help() {
  print('Common commands:');
  print('');
  print(' git_hooks create {{targetPath}}');
  print("   Create hooks files in '.git/hooks'");
  print('');
}
