# How to Interact with GitHub Copilot on a Pull Request

This guide explains how to communicate with GitHub Copilot (the AI coding agent) directly on a pull request — including how to ask it to try again, give it new instructions, or refine its work.

---

## Overview

When GitHub Copilot opens a pull request on your behalf (e.g. after you filed an issue or used Copilot Workspace), you can continue the conversation by **leaving a comment on that pull request**. Copilot monitors the PR and responds to your comments just like it would respond to a new prompt.

---

## Step-by-Step: How to Ask Copilot to Try Again

### 1. Open the Pull Request

Go to the **Pull Requests** tab of the repository on GitHub:

```
https://github.com/ALPA-Const/kinora/pulls
```

Click on the pull request that Copilot created (or is working on).

---

### 2. Scroll to the Comment Box

Scroll to the bottom of the pull request's **Conversation** tab. You will see the standard GitHub comment box:

```
┌─────────────────────────────────────────────────────────┐
│  Leave a comment                                        │
│                                                         │
│  [                                                    ] │
│                                                         │
│                              [ Comment ]  [ Close PR ] │
└─────────────────────────────────────────────────────────┘
```

---

### 3. Type Your Comment

Type a comment addressed to `@copilot`. Some examples:

**To ask Copilot to simply retry the same task:**
```
@copilot please try again
```

**To give Copilot additional context or a correction:**
```
@copilot the backend service should use Prisma, not raw SQL. Please update the implementation.
```

**To ask Copilot to fix a specific problem:**
```
@copilot the tests are failing because the JWT middleware is missing. Please add it.
```

**To expand the scope of what was done:**
```
@copilot please also add input validation using Zod to all the new endpoints.
```

You can write naturally — Copilot reads the full comment and acts on it. The `@copilot` mention is what triggers it to respond.

---

### 4. Click "Comment"

Press the green **Comment** button. GitHub will notify Copilot, and it will:

1. Read your comment
2. Review the existing pull request changes
3. Make additional commits to the same branch to address your feedback
4. (Optionally) reply with a summary of what it changed

---

## Tips for Effective Copilot Comments

| Goal | What to Write |
|------|--------------|
| Simple retry | `@copilot please try again` |
| Fix a failing test | `@copilot the CI is failing — please fix the error in the test output above` |
| Change the approach | `@copilot please rewrite the auth module to use Passport.js instead` |
| Add something missed | `@copilot please also add error handling to the new endpoints` |
| Undo something | `@copilot please revert the changes to the database schema` |
| Ask a question | `@copilot can you explain why you chose this approach?` |

---

## What Happens After You Comment

- Copilot will process your comment (usually within a few seconds to a couple of minutes).
- It will push new commits to the pull request's branch.
- The PR will update automatically — you will see the new commits appear in the timeline.
- Copilot may also add a reply comment summarizing what it did.
- You can continue the conversation with as many follow-up comments as needed.

---

## Where the "Try Again" Prompt Comes From

When Copilot encounters an error or cannot push its changes, GitHub sometimes shows a status message on the PR like:

> *"Copilot encountered an error. You can leave a comment on this pull request asking Copilot to try again."*

This is GitHub's way of telling you that the agent stopped unexpectedly. The fix is exactly as described above — leave a comment like `@copilot please try again` and Copilot will restart its work on the same task.

---

## Related Resources

- [GitHub Copilot documentation](https://docs.github.com/en/copilot)
- [Using Copilot in pull requests](https://docs.github.com/en/copilot/using-github-copilot/using-github-copilot-in-a-pull-request)
- [Kinora MVP Specification](../kinora-elite-mvp-prompt.md)
