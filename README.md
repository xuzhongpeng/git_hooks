# git_hooks

![https://img.shields.io/github/license/xuzhongpeng/git_hooks](https://img.shields.io/github/license/xuzhongpeng/git_hooks) ![Pub](https://img.shields.io/pub/v/git_hooks)

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

we can create git hooks with

```
git_hooks create
```

It will create some hooks files in .git/hooks. You can check whether the installation is correct by judging whether the file(".git/hooks/commit-msg" and other fils) exists.

It will create a file `git_hooks.dart` in your project root directory.

## Using

we can change `git_hooks.dart`

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

add file to git

```
git add .
git commit -m 'some messages'
```

if it output following.Congratulations on your successful use of it.

```
start pre-commit hook...               /
-this is pre-commit

1.1s
start prepare-commit-msg hook...       /
1.1s
start commit-msg hook...               /
\commit message is 'fix: fix some min-bugs
'
this is commitMsg

1.2s
```

##
