import 'package:git_hooks/runtime/run.dart' as m;
import './install/CreateHooks.dart';

main(List<String> arguments) {
  if (arguments != null && arguments.length > 0) {
    String str = arguments[0];
    if (arguments?.length == 1) {
      if (str == 'create') {
        //安装的时候创建文件
        CreateHooks().copyFile();
      } else if (str == '-h' || str == '-help') {
        help();
      } else if (str == '-v' || str == '--version') {
        print('v0.0.1');
      } else {
        print("'${str}' is not a git_hooks command,see follow");
        print('');
        help();
      }
    } else if (str == 'run') {
      //运行的时候执行
      m.run(arguments);
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
  print(" git_hooks create");
  print("   Create hooks files in '.git/hooks'");
  print("");
}
