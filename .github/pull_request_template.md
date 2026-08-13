<!--
  Org-wide PR template — SYNCED from nsheaps/.github
  (ansible/templates/.github/pull_request_template.md). Local edits are
  replaced on the next org sync run; propose changes upstream instead.

  Delete any section that genuinely does not apply. Do not delete
  "Blast radius" or "Validation performed" — if they are empty, say why.
-->

## What changed

<!--
  The actual diff, file by file, in the order a reviewer should read it.
  A table works well when several files change for different reasons.
  Link to specific lines (`path/to/file.py:120-134`) rather than describing.
-->

## Why

<!--
  The problem or requirement this serves. If it came from an issue, a
  review comment, or an incident, link it. "Because it was asked for" is
  a real reason — say who asked and where.
-->

## Blast radius

<!--
  READ THIS SECTION BEFORE APPROVING.

  Answer concretely:
    - What is affected? (this repo only / N managed repos / all org members)
    - When does it take effect? (on merge / on next sync / only for new repos)
    - What breaks if this is wrong? What is the rollback?
    - What existing behaviour or local decision does this override?

  If the change is genuinely inert today (feature-flagged, enforcement
  disabled, no consumer yet), say so AND say what would make it live.
-->

## Validation performed

<!--
  Paste REAL output — command invocations and their actual results. Not
  "tests pass", not a description of what you would run.

  Where a test is meant to catch a regression, show that it actually fails
  without the fix. An assertion that never fails is not validation.
-->

```
$ <command>
<output>
```

## What a reviewer should scrutinise

<!--
  The parts you are least sure about, the trade-offs you made, and any
  decision you made unilaterally that the reviewer might have made
  differently. Pre-empt the strongest objection to this PR rather than
  waiting for review to find it.
-->

1.
2.

## Related

<!-- Issues, prior PRs, specs, Discord threads. Use "Closes #N" to auto-close. -->

-
