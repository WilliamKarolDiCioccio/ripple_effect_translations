# ripple_effect translations

The words [ripple_effect](https://ripplefx.app) says — its buttons, menus,
dialogs and explanations — in languages other than English, translated in the
open by the people who will read them.

ripple_effect is a desktop application for writing branching stories and
tabletop campaigns as graphs of connected cards. This repository holds only
its interface text. The application itself is not here and is not open
source.

## What is here

| | |
| --- | --- |
| `source/app_en.arb` | **The English**, every string the app says with a description of where it appears. Mirrored from the application; never edited here. |
| `glossary.md` | The product's terms, what stays in English, and the register. Read it before translating anything. |
| `languages/<tag>/app_<tag>.arb` | **Reviewed translations.** Only strings a person has read and approved. This is what ships. |
| `languages/<tag>/draft.arb` | **Machine drafts**, written by a local language model and read by nobody yet. A starting point, never a translation. |
| `languages/<tag>/CONTRIBUTORS` | The people who translated and reviewed this language, one per line. The app credits them in its About box. |

The files are [ARB](https://github.com/google/app-resource-bundle/wiki/ApplicationResourceBundleSpecification),
which is JSON: a key, and the text for it. Some strings are
[ICU messages](https://unicode-org.github.io/icu/userguide/format_parse/messages/)
with plural or select forms; `CONTRIBUTING.md` explains the parts you must
not translate.

## How a translation reaches the app

1. A language gets a folder when somebody volunteers to maintain it — open a
   *New language* issue. The folder starts with a machine draft.
2. Contributors move strings from `draft.arb` into `app_<tag>.arb`, fixing
   them on the way, in pull requests the language's maintainer reviews.
3. When the language is complete, it is imported into the application —
   through the same checks every translation passes there — and ships in the
   next release.

New English strings arrive here as the app grows, with fresh drafts for them.
Nothing in this repository is built directly: the application reads only
what it imports, so a pull request merged here never changes a release by
itself.

## Contributing

Read [CONTRIBUTING.md](CONTRIBUTING.md). Every commit needs a sign-off
(`git commit -s`) under the [Developer Certificate of Origin](DCO).

## Licence

The contents of this repository are under the [MIT licence](LICENSE), and
every contribution is made under it. That covers the strings in these files
and nothing more: the ripple_effect application is proprietary software
governed by its [End-User Licence Agreement](https://legal.ripplefx.app/eula/),
which this licence does not change.
