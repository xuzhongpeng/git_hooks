import "package:yaml/yaml.dart";
import "dart:io";

const commonHook = r"""
hookName=`basename "$0"`
gitParams="$*"
program_exists() {
    local ret='0'
    command -v $1 >/dev/null 2>&1 || { local ret='1'; }
    if [ "$ret" -ne 0 ]; then
        return 1
    fi
    return 0
}
error() {
  echo "\033[31m $1 \033[0m" 
}
if program_exists git_hooks; then
  git_hooks run $hookName "$gitParams"
  if [ "$?" -ne "0" ];then
    exit 1
  fi
else
  error "Can't find git_hooks, skipping $hookName hook"
  echo "you can write \033[33mgit_hooks:any\033[0m in pubspec.yaml and using 'pub get' to install"
fi
""";
const userHooks = r"""
import "package:git_hooks/git_hooks.dart";
import "dart:io";

void main(List arguments) {
  Map<Git, UserBackFun> params = {Git.commitMsg: commitMsg};
  change(arguments, params);
}

Future<bool> commitMsg() async {
  Directory rootDir = Directory.current;
  File myFile = new File(uri("${rootDir.path}/.git/COMMIT_EDITMSG"));
  String commitMsg = myFile.readAsStringSync();
  if (commitMsg.startsWith('fix:')) {
    return false;
  } else
    return false;
}
""";

String createHeader() {
  Directory rootDir = Directory.current;
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
#   Homepage: ${homepage}#readme

''';
}
