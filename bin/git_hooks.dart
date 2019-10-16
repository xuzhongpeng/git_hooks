import './runtime/run.dart' as m;
import './install/CreateHooks.dart';
import './utils/logging.dart';

main(List<String> arguments) async {
  Logger logger = new Logger.standard();
  logger.stdout('111');
  logger.trace("222");
  logger.stderr('333');
  if (arguments.length > 0) {
    if (arguments.length == 1) {
      String str = arguments[0];
      if (str == 'run') {
        //运行的时候执行
        m.run(arguments);
      } else if (str == 'create') {
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
