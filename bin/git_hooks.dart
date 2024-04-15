import 'package:git_hooks/runtime/git_hooks.dart';

import 'package:git_hooks/install/create_hooks.dart';

void main(List<dynamic>? arguments) {
  if (arguments != null && arguments.isNotEmpty) {
    var str = arguments[0]!.toString();
    if (arguments.isNotEmpty) {
      if (str == 'create') {
        //init files
        String? targetPath;
        try {
          targetPath = arguments[1];
        } on RangeError {
          targetPath = null;
        }
        if (targetPath is String && targetPath.endsWith('.dart')) {
          CreateHooks.copyFile(targetPath: targetPath);
        } else {
          CreateHooks.copyFile();
        }
      } else if (str == '-h' || str == '-help') {
        help();
      } else if (str == 'uninstall') {
        GitHooks.unInstall();
      } else {
        print('${str} is not a git_hooks command,see follow');
        print('');
        help();
      }
    } else {
      print(
          'Too many positional arguments: 1 expected, but ${arguments.length} found');
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
  print('   Create hooks files in \'.git/hooks\'');
  print('');
}
