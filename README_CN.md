# git_hooks

![https://img.shields.io/github/license/xuzhongpeng/git_hooks](https://img.shields.io/github/license/xuzhongpeng/git_hooks)
[![Pub](https://img.shields.io/pub/v/git_hooks)](https://pub.dev/packages/git_hooks)
[![Star](https://img.shields.io/github/stars/xuzhongpeng/git_hooks)](https://github.com/xuzhongpeng/git_hooks)
[![travis](https://api.travis-ci.com/xuzhongpeng/git_hooks.svg?branch=master&status=created)](https://travis-ci.com/github/xuzhongpeng/git_hooks/builds/)

* [English Version](./README.md)

## Git Hooks
`Git Hooks`是什么，`Hooks`顾名思义，就是钩子。它在Git中的作用就是在我们通过`git`命令操作仓库或者添加项目文件时，运行一些脚本，脚本通过即可完成事件，如果失败就被终止事件。[这里](https://git-scm.com/docs/githooks.html)是官方定义的所有钩子，有兴趣的可以一一查看。比如我们在`.git/hooks/`下新建了一个`pre-commit`文件，并输入以下内容
```shell
#!/bin/sh

echo '文件正在提交'
exit(-1)
```
然后我们在命令行中执行
```shell
git add test
git commit -m '提交信息'
```
然后我们就会在命令行看到`文件正在提交`，并且文件最后没有提交到本地仓库，因为上面我exit了。

这样，我们就可以在这个文件中写一些校验，比如通过`dartanalyzer`查看本地项目语法是否有语法问题。

## [git_hooks](https://pub.dev/packages/git_hooks)

这是一个`Dart`命令行插件，也是一个Dart插件。我们看到上面使用`shell`脚本来写校验，它存在一些问题：
- 每个人的`.git`文件夹是不通过版本管理的，所以一个人第一次拉了代码，在`.git/hooks`文件夹下是不会存在能运行的hooks文件的
- shell脚本比较生涩难写，上手难度高

`git_hooks`库就是为了解决上面问题。它的作用就是能通过命令生成所有`hooks`，然后在我们通过`git`命令提交代码时，可以通过dart来进行提交前或者提交信息的校验。它让我们程序员可以忽略hooks文件存在，在dart代码中实现对所有钩子的操作。

这里我们定一个我们能看懂的术语
> `hooks文件`：指在`.git/hooks`文件夹下生成的钩子文件

> `dart钩子文件`：指在项目中生成的使用dart语言来操作`hooks文件`的dart文件

我们可以通过下面命令来安装它，安装它前请保证你的dart已经安装且已经配置了环境变量，还要保证你的 dart 版本大于 2.1.0

运行命令`dart --version`查看dart版本号

然后运行`pub global activate git_hooks`即可全局安装`git_hooks`命令

## 创建hooks项目文件

当我们打开一个拥有git版本管理的项目（在项目中可看到`.git`文件夹）

在项目中的`pubspec.yaml`文件中添加
```yaml
dev_dependencies:
  git_hooks: ^0.1.5
```

创建`hooks文件`和`dart钩子文件`的命令是：
```shell
git_hooks create {{targetFileName}}
```
- targetFileName指的是`dart钩子文件`，它可以是项目中任何位置，比如在根目录下的`git_hooks.dart`文件（这也是如果此参数不传默认会创建的文件）

那我们来执行：
```shell
git_hooks create git_hooks.dart
```
如果输出
```
create files...                        
All files wrote successful!
0.2s
```
那说明我们已经创建成功。我们来检查一下文件是否生成成功，查看`.git/hooks`文件下是否有多个文件例如`pre-commit`,`pre-push`等等，查看根目录下是否已生成`git_hooks.dart`文件

打开`git_hooks.dart`文件会看到如下
```dart
import 'package:git_hooks/git_hooks.dart';
// import 'dart:io';

void main(List arguments) {
  // ignore: omit_local_variable_types
  Map<Git, UserBackFun> params = {
    Git.commitMsg: commitMsg,
    Git.preCommit: preCommit
  };
  GitHooks.call(arguments, params);
}

Future<bool> commitMsg() async {
  // String rootDir = Directory.current.path;
  // String commitMsg = Utils.getCommitEditMsg();
  // if (commitMsg.startsWith('fix:')) {
  //   return true; // you can return true let commit go
  // } else
  //   return false;
  return true;
}

Future<bool> preCommit() async {
  // try {
  //   ProcessResult result = await Process.run('dartanalyzer', ['bin']);
  //   print(result.stdout);
  //   if (result.exitCode != 0) return false;
  // } catch (e) {
  //   return false;
  // }
  return true;
}
```
解释：
- main方法下的params是一个Map，是我们想要自定义的钩子集合，每个钩子对应下面具体的函数
- GitHooks.call 是固定写法，库的内部会执行钩子函数并校验
- commitMsg函数是一个例子，当执行git的commit-msg脚本时，会执行此函数，如果返回false，会终止git操作

我们尝试把注释打开
```dart
Future<bool> commitMsg() async {
  var commitMsg = Utils.getCommitEditMsg();
  if (commitMsg.startsWith('fix:')) {
    return true; // you can return true let commit go
  } else  {
    print('you should add `fix` in the commit message');
    return false;
  }
}
```
然后在项目路径的命令行下执行:
```shell
git add git_hooks.dart
git commit -m '提交信息'
```
脚本输出如下
```
you should add `fix` in the commit message
```
并且文件没有被提交到本地仓库。

大功告成！

## 删除所有`hooks文件`
当我们有一天被自己写的钩子折磨，不想再用此校验，我们有两个方式来删除钩子
1. 删除`.git/hooks`文件夹，注意是hooks文件夹而不是`.git`文件夹
2. 通过命令`git_hooks uninstall`来删除

## 其它钩子的枚举
你可以通过下面的枚举，添加更多的钩子操作
```dart
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
具体含义可以参考[`git官方文档`](https://git-scm.com/docs/githooks.html)

## 结语

上面是我的一个例子，当然我们可以使用该工具做更多的事情，比如使用`dartanalyzer`检查代码质量，使用`dartfmt`来检查代码文件格式是否对齐等等。


[pub仓库地址](https://pub.dev/packages/git_hooks)

[github地址](https://github.com/xuzhongpeng/git_hooks)

[git hooks 官方文档](https://git-scm.com/docs/githooks.html)

## 测试你写的`dart钩子文件`

如果你定义了 `pre-commit` 钩子（其它类似）.

你可以执行 `dart {{targetFile}} pre-commit`.

如果你想用VSCode来断点调试，可以添加下面配置
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