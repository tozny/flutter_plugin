# Tozny Plugin Specifics

General flutter plugin development info can be found at <https://flutter.dev/docs/development/packages-and-plugins/developing-packages>

IDE integration seems well supported in vscode and android studio, but android
studio is recommended [setup](https://flutter.dev/docs/get-started/editor).

## Generating JSON Parsing Code

The flutter and native code in this repo communicate by serializing responses to JSON strings.
In the future it may be valuable to take advantage of [pigeon](https://pub.dev/packages/pigeon)
for type safety; however, since it is in pre-release we are not currently utilizing it.
The current plugin takes advantage of [annotations](https://pub.dev/packages/json_annotation),
to generate JSON parsers automatically. The models live in tozny_models.dart and
the generated files are created by running `flutter pub run build_runner build`.

## Hot Reloading Native Code

When developing native portions of the plugin a full re-compile is needed, hot
restarts don't reflect current state.

## Publishing

* Checkout code from branch
* Write code, test code
* Update plugin version in `pubspec.yaml` file, `CHANGELOG.md` and `README.md` as needed
* Before committing changes for review, run `flutter pub publish --dry-run`
* Commit & PR changes
* Once PR is approved, merge into trunk
* Check out trunk, push a git tag matching the version tag in `pubspec.yaml`
* Run `flutter pub publish`
