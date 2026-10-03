// Checks every language against the English, with the same validator the
// application runs before it imports one (smart_arb_translator, pinned in
// pubspec.yaml to the version the application pins).
//
//   dart run tool/check.dart
//
// Run from the repository root. A key a language has not translated yet is
// coverage, not an error: a language is translated a pull request at a time,
// and the application refuses an incomplete one when it imports it.

import 'dart:convert';
import 'dart:io';

import 'package:smart_arb_translator/smart_arb_translator.dart'
    show ArbDocument, LocalizationValidator;

const String _source = 'source/app_en.arb';

void main() {
  final sourceFile = File(_source);
  if (!sourceFile.existsSync()) {
    stderr.writeln('check: run from the repository root.');
    exitCode = 2;
    return;
  }
  final source = ArbDocument.decode(sourceFile.readAsStringSync());
  final total = source.resources.length;
  final folders = Directory('languages').existsSync()
      ? (Directory('languages').listSync().whereType<Directory>().toList()
          ..sort((a, b) => a.path.compareTo(b.path)))
      : const <Directory>[];

  var failed = false;
  for (final folder in folders) {
    final tag = folder.uri.pathSegments.lastWhere((s) => s.isNotEmpty);
    final reviewed = File('${folder.path}/app_${tag.replaceAll('-', '_')}.arb');
    final draft = File('${folder.path}/draft.arb');

    final unexpected = <String>[
      for (final file in folder.listSync().whereType<File>())
        if (file.path != reviewed.path &&
            file.path != draft.path &&
            !file.path.endsWith('/CONTRIBUTORS'))
          file.path,
    ];
    for (final path in unexpected) {
      stdout.writeln('$tag: $path is not a file a language folder holds.');
      failed = true;
    }

    var translated = 0;
    if (reviewed.existsSync()) {
      final problems = _check(source, reviewed, tag);
      failed |= problems;
      translated = ArbDocument.decode(
        reviewed.readAsStringSync(),
      ).resources.length;
    }
    if (draft.existsSync()) {
      failed |= _check(source, draft, tag);
    }
    final percent = total == 0 ? 100 : (translated * 100 / total).floor();
    stdout.writeln('$tag: $translated of $total reviewed ($percent%).');
  }
  if (folders.isEmpty) stdout.writeln('No languages yet.');
  exitCode = failed ? 1 : 0;
}

/// Reports what the validator finds in [file], except keys it has not got
/// yet; true when anything was found.
bool _check(ArbDocument source, File file, String tag) {
  final ArbDocument target;
  try {
    target = ArbDocument.decode(file.readAsStringSync());
  } on FormatException catch (e) {
    stdout.writeln('${file.path}: not valid JSON — ${e.message}');
    return true;
  }
  final declared = (jsonDecode(file.readAsStringSync()) as Map)['@@locale'];
  final issues = [
    if (declared != tag.replaceAll('-', '_'))
      '@@locale: is "$declared", the folder says "${tag.replaceAll('-', '_')}"',
    for (final issue in LocalizationValidator.validatePair(
      source: source,
      target: target,
      targetLocale: tag,
    ))
      if (issue.code != 'missing_key')
        '${issue.key}: ${issue.code} — ${issue.message}',
  ];
  for (final issue in issues) {
    stdout.writeln('${file.path}: $issue');
  }
  return issues.isNotEmpty;
}
