# git_hooks

![https://img.shields.io/github/license/xuzhongpeng/git_hooks](https://img.shields.io/github/license/xuzhongpeng/git_hooks) ![Pub](https://img.shields.io/pub/v/git_hooks) ![](https://img.shields.io/powershellgallery/p/PackageManagement?color=%23)

git_hooks can prevent bad `git commit`,`git push` and more easy in dart and flutter!

## Install

```
dev_dependencies:
  git_hooks: ^0.0.1
```

then

```
pub get
```

or

```
flutter pub get
```

and then activate it in shell

```
pub global activate git_hooks
```

## Uninstall

```
dev_dependencies:
  - git_hooks: ^0.0.1
```

```
pub get
```

or

```
flutter pub get
```

and

```
pub global deactivate git_hooks
```

## create files in .git/hooks

We can create git hooks with

```
git_hooks create
```

It will create some hooks files in .git/hooks. You can check whether the installation is correct by judging whether the file(".git/hooks/commit-msg" and other fils) exists.

It will create a file `git_hooks.dart` in your project root directory.

## Using

You can change `git_hooks.dart`

```dart
void main(List arguments) {
  Map<Git, UserBackFun> params = {
    Git.commitMsg: commitMsg,
    Git.preCommit: preCommit
  };
  change(arguments, params);
}

Future<bool> commitMsg() async {
  Directory rootDir = Directory.current;
  File myFile = new File(rootDir.path + "/.git/COMMIT_EDITMSG");
  print("commit message is '${myFile.readAsStringSync()}'");
  print('this is commitMsg');
  return false;
}
Future<bool> preCommit() async {
  print('this is pre-commit');
  return true;
}
```

If you want interrupt your commit or push,you can return false.Then you can return true if only nothing to do.

add file to git

```
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

You can define own function.For example,I want define a hook what can verify commit message starts with 'fix:'.

`git_hooks.dart`

```dart
import "package:git_hooks/git_hooks.dart";
import "dart:io";

void main(List arguments) {
  Map<Git, UserBackFun> params = {Git.preCommit: commitMsg};
  change(arguments, params);
}

Future<bool> commitMsg() async {
  Directory rootDir = Directory.current;
  File myFile = new File(uri("${rootDir.path}/.git/COMMIT_EDITMSG"));
  String commitMsg = myFile.readAsStringSync();
  print("commit message is '${commitMsg}'");
  if (commitMsg.startsWith('fix:')) {
    return false;
  } else
    return false;
}

```
