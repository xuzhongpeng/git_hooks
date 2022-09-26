# git_hooks

![https://img.shields.io/github/license/qurami/git_hooks](https://img.shields.io/github/license/qurami/git_hooks)

* Fork from https://github.com/xuzhongpeng/git_hooks to add support to null safety and many other features that we use internally. We'll keep on maintaining this repo for internal usage.

git_hooks can prevent bad `git commit`,`git push` and more easy in dart and flutter! It is similar to husky.

## Install

```
dev_dependencies:
  git_hooks: ^0.1.0
```

then

```
pub get
```

or

```
flutter pub get
```

## create files in .git/hooks
Here has two ways

1. Using `git_hooks` command

activate `git_hooks` in shell

```
dart pub global activate -sgit git@github.com:qurami/git_hooks.git
```
Now,we can let the `git hooks` bring into effect
```
git_hooks create bin/git_hooks.dart
```

2. Using dart code:

create `main.dart` file in `/bin/`
```dart
void main() async{
  GitHooks.init(targetPath: "bin/git_hooks.dart");
}
```
then `dart bin/main.dart` in shell.

It will create some hooks files in `.git/hooks`. You can check whether the installation is correct by judging whether the file(".git/hooks/commit-msg" and other fils) exists.

It will create a file `git_hooks.dart` in your project root directory.
## Delete files in .git/hooks

1. using git_hooks shell command
```
git_hooks uninstall
```

2. using dart codes
```dart
void main() async{
  GitHooks.unInstall();
}
```
## Notion

`Target File`: The file that the git hooks points to. It is `/git_hooks.dart` as default.

`Git hook command file`: The Git hooks file. Such as `/.git/hooks/commit-msg`.
## Using

You can change `git_hooks.dart`

```dart
import "package:git_hooks/git_hooks.dart";
import "dart:io";

void main(List arguments) {
  Map<Git, UserBackFun> params = {
    Git.commitMsg: commitMsg,
    Git.preCommit: preCommit
  };
  GitHooks.call(arguments, params);
}

Future<bool> commitMsg() async {
  String rootDir = Directory.current.path;
  String commitMsg = Utils.getCommitEditMsg();
  if (commitMsg.startsWith('fix:')) {
    return true; // you can return true let commit go
  } else
    return false;
}

Future<bool> preCommit() async {
  try {
    ProcessResult result = await Process.run('dartanalyzer', ['bin']);
    print(result.stdout);
    if (result.exitCode != 0) return false;
  } catch (e) {
    return false;
  }
  return true;
}

```

If you want interrupt your commit or push,you can return false.Then you can return true if only nothing to do.

add file to git

```shell
git add .
git commit -m 'some messages'
```

If it output following.Congratulations on your successful use of it.

```
start pre-commit hook...               /
-this is pre-commit

1.1s
start prepare-commit-msg hook...       /
1.1s
start commit-msg hook...               /
\commit message is 'some messages'
this is commitMsg

1.2s
```

## Define our own hook functions

You can use enum `Git` to Define more hooks functions.

There is all hooks provide

```
enum Git {
  applypatchMsg,
  preApplypatch,
  postApplypatch,
  preCommit,
  prepareCommitMsg,
  commitMsg,
  postCommit,
  preRebase,
  postCheckout,
  postMerge,
  prePush,
  preReceive,
  update,
  postReceive,
  postUpdate,
  pushToCheckout,
  preAutoGc,
  postRewrite,
  sendemailValidate
}
```

You can click [here](https://git-scm.com/docs/githooks.html) to learn more about git hooks. 

## Debugging hooks code with VSCode

If you debugging `pre-commit` hooks.

You can execute `dart {{targetFile}} pre-commit`.

or add Configuration in VSCode
```json
{
  "version": "0.2.0",
  "configurations": [
    {
      "name": "debugger git hooks",
      "program": "git_hooks.dart",//your targetFile
      "request": "launch",
      "type": "dart",
      "args": ["pre-commit"] // hooks argument
    }
  ]
}
```
