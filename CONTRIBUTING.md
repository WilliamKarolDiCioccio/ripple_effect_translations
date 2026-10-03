# Contributing a translation

Thank you. A translation here is read by everyone who uses ripple_effect in
your language, so the bar is a person who reads that language well, and no
lower.

## Before you start

- **Sign off every commit**: `git commit -s` adds a `Signed-off-by:` line
  with your name and email. By adding it you certify the
  [Developer Certificate of Origin](DCO): that you wrote the contribution, or
  otherwise have the right to submit it under this repository's
  [MIT licence](LICENSE). A check refuses a pull request with an unsigned
  commit. The sign-off is public and permanent, like the rest of the history.
- **Read [`glossary.md`](glossary.md).** It says which words stay in English
  (the product's name, the card types, Python, Markdown…) and which terms
  must be translated the same way every time.
- **Check the language has a maintainer.** `.github/CODEOWNERS` lists them.
  If yours has none, open a *New language* issue and offer to be one.

## Translating a string

Each language folder has two files that matter:

- `draft.arb` — what the machine wrote. Unreviewed.
- `app_<tag>.arb` — what a person approved. Reviewed.

To translate, **move a string from `draft.arb` to `app_<tag>.arb`**,
correcting it on the way. Copy the key exactly, and remove it from the draft
in the same commit. Do not edit `source/app_en.arb` or `glossary.md`: they
are mirrored from the application and overwritten on the next update. If the
English is wrong or a description is unclear, open an issue — fixing it at
the source fixes it for every language.

For each string, read its `@description` in `source/app_en.arb`. It says
where the string appears, what it is (a button, a title, a menu entry) and
how much room it has. A button with room for one word needs one word.

**Do not translate:**

- anything inside braces: `{count}`, `{language}`, `{name}`;
- the words `plural`, `select`, `other`, `one`, `few`, `many`, `=0`, `=1` in
  an ICU message — translate only the text inside the inner braces;
- whatever `glossary.md` says stays in English.

**Do** add or remove plural branches your language needs. English has `one`
and `other`; Polish needs `one`, `few`, `many` and `other`. The
[CLDR plural rules](https://www.unicode.org/cldr/charts/latest/supplemental/language_plural_rules.html)
list them.

```json
"nodeEditorCutLinks": "{count, plural, =1{Taglia il collegamento} other{Taglia i collegamenti}}"
```

## The check

Every pull request runs `tool/check.dart`, the same validator the application
runs before it imports a language: placeholders kept, plural and select
structure intact, nothing empty, nothing left in English by mistake, no key
the source does not have. A key still missing from `app_<tag>.arb` is
reported as coverage, not as an error — a language is translated a pull
request at a time. To run it yourself, with the
[Dart SDK](https://dart.dev/get-dart) installed:

```sh
dart pub get
dart run tool/check.dart
```

## Review

A language's maintainer reviews every pull request to its folder; a pull
request touching `source/`, `glossary.md` or `.github/` is the project's.
Reviewing means reading every changed string in context — its description,
and what the English says — not only checking it parses.

## Credit

Add your name to `languages/<tag>/CONTRIBUTORS` in your first pull request:
one person per line, as you want to be credited, optionally followed by a
link. The app shows the names in its About box when it runs in your language.
Leave it out if you would rather not be named; the history still records your
sign-off.

## A new language

Open a *New language* issue. When somebody has volunteered to maintain it,
the folder is created with a machine draft and the maintainer is added to
`CODEOWNERS`. A language ships when it is complete and its maintainer says it
is ready.
