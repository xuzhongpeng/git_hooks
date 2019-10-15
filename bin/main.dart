import 'package:git_hooks/git_hooks.dart' as git_hooks;

main(List<String> arguments) {
  print('Hello world: ${git_hooks.calculate()}!');
  print('Hello world: ${arguments}!');
}
