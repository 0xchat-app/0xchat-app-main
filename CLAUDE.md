# Working notes for Claude Code

## Commit attribution

Commits must not be attributed to the `wcat7` / `water783` account.

Git authorship is already correct — this environment commits as
`Claude <noreply@anthropic.com>` — so nothing needs changing there.

The account leaks in through **merge commits**: merging a PR through the
GitHub API or web button authors the merge commit as whoever performed it.
`e49c3d3` (PR #88) is an example, created by an agent-side merge.

So: **do not merge pull requests.** Open the PR and leave the merge to a
human, who can choose the identity it lands under.

Note the limit of this rule. Every GitHub API action in an agent session —
opening a PR, commenting on an issue, dispatching a workflow, pushing a tag —
is recorded under the account backing the session token, which is currently
`wcat7`. That is the session identity and cannot be switched from inside the
session. Only the git commit author and the choice not to merge are under
agent control; anything requiring a different actor has to be done by a human
or by a session authenticated as a different account.
