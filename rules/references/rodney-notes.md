# Rodney CLI — Decision-Ready Notes

> **Source:** [github.com/simonw/rodney](https://github.com/simonw/rodney)
> **Version reviewed:** v0.3.0 (Feb 10, 2026) · Apache-2.0 · Written in Go

---

## Tool overview

**Rodney CLI** is a **command-line interface (CLI) browser automation tool** created by **Simon Willison** (co-authored with Claude).
It controls a real Chromium/Chrome browser via the **Chrome DevTools Protocol (CDP)** using the Go [`rod`](https://github.com/go-rod/rod) library, and exposes navigation, interaction, and assertions as plain shell commands.

**Positioning:**
Rodney sits between *ad-hoc curl checks* and *full UI test frameworks* (Playwright/Selenium).

---

## visual-grounding-for-agents

Agents that operate on **browsers, GUIs, or other rendered surfaces** must account for **visual and structural UI state**—pixels, element geometry, accessibility trees, screenshots—not only serialized text or a model’s prior summary of the page. Specs, prompts, and evals should state what the agent can actually observe; otherwise plans drift from on-screen reality. Grounding: `references/molmoweb.pdf`.

## perception-reasoning-action-loop

**Web and GUI agents** run a closed loop: **perceive** current UI/visual state → **reason** over goals and constraints → **act** via tools (navigate, click, type, API) → perceive again. Treat long-horizon tasks as iterations of this loop, not one-shot Q&A over a static text dump, unless the harness explicitly materializes state each turn. Grounding: `references/molmoweb.pdf`.

---

## Core design goals

- **CLI-first**: everything is a shell command
- **Real browser**: not a mock, not jsdom — actual Chrome/Chromium
- **Scriptable assertions**: JavaScript expressions evaluated in-page
- **Deterministic exit codes**: pass/fail usable in CI
- **Agent-friendly**: simple primitives that LLMs can compose safely
- **Session persistence**: Chrome lives independently; each CLI invocation is a short-lived client

---

## Mental model

> "A shell script that drives a browser and fails fast if reality disagrees."

```
rodney start     →  launches Chrome (headless, persists after CLI exits)
                     saves WebSocket debug URL to ~/.rodney/state.json

rodney open URL  →  connects to running Chrome via WebSocket
                     navigates the active tab, disconnects

rodney js EXPR   →  connects, evaluates JS, prints result, disconnects

rodney stop      →  connects and shuts down Chrome, cleans up state
```

- Browser = long-lived session (Chrome process survives CLI exits)
- Commands = imperative steps (`open`, `click`, `input`)
- Assertions = JS expressions returning true/expected value
- Failure = non-zero exit code

No test runner, no fixtures, no reporters.

---

## What it can do (capabilities)

### Browser lifecycle

- Start/stop Chromium sessions
- Headless or visible (`--show`)
- Attach to existing sessions
- Multi-tab management (`pages`, `newpage`, `page`, `closepage`)

### Navigation & timing

- Open URLs (auto-prefixes `http://`)
- Back, forward, reload
- Wait for element: `wait`, `waitload`, `waitstable`, `waitidle`
- Simple sleep: `sleep 2.5`

### Interaction

- Click elements by CSS selector
- Type into inputs (`input`, `clear`)
- Select dropdowns, submit forms
- Hover, focus
- Execute arbitrary JS via `rodney js EXPR`

### Extraction

- `title`, `url`, `text <selector>`, `html [selector]`, `attr <selector> <name>`
- `pdf output.pdf` — save page as PDF

### Assertions (key feature)

JS expressions are evaluated in-page and the result is returned or compared:

```sh
rodney js 'document.querySelectorAll("li.item").length'   # count items
rodney js 'document.querySelector("h1").textContent'      # text content
rodney exists ".error-message"                            # exit 0/1
rodney visible "#modal"                                   # exit 0/1
rodney count "li.item"                                    # prints number
```

### Accessibility testing (a11y)

Full CDP Accessibility domain integration — unique for a CLI tool:

```sh
rodney ax-tree                          # dump full accessibility tree
rodney ax-tree --depth 3 --json         # limit depth, JSON output
rodney ax-find --role button            # find all buttons
rodney ax-find --role link --name "Home"
rodney ax-node "#submit-btn" --json     # inspect element's a11y properties
```

CI a11y check example:
```sh
rodney ax-find --role button --json | python3 -c "
import json, sys
buttons = json.load(sys.stdin)
unnamed = [b for b in buttons if not b.get('name', {}).get('value')]
if unnamed:
    print(f'FAIL: {len(unnamed)} button(s) missing accessible name')
    sys.exit(1)
print(f'PASS: all {len(buttons)} buttons have accessible names')
"
```

### Screenshots

```sh
rodney screenshot                        # saves screenshot.png
rodney screenshot page.png               # to named file
rodney screenshot-el ".chart" chart.png  # element-level screenshot
```

---

## Full command reference

| Command | Arguments | Description |
|---|---|---|
| `start` | | Launch headless Chrome |
| `stop` | | Shut down Chrome |
| `status` | | Show browser status and active page |
| `open` | `<url>` | Navigate to URL |
| `back` | | Go back in history |
| `forward` | | Go forward in history |
| `reload` | | Reload current page |
| `url` | | Print current URL |
| `title` | | Print page title |
| `html` | `[selector]` | Print HTML (page or element) |
| `text` | `<selector>` | Print element text content |
| `attr` | `<selector> <name>` | Print attribute value |
| `pdf` | `[file]` | Save page as PDF |
| `js` | `<expression>` | Evaluate JavaScript, print result |
| `click` | `<selector>` | Click element |
| `input` | `<selector> <text>` | Type into input |
| `clear` | `<selector>` | Clear input |
| `select` | `<selector> <value>` | Select dropdown value |
| `submit` | `<selector>` | Submit form |
| `hover` | `<selector>` | Hover over element |
| `focus` | `<selector>` | Focus element |
| `wait` | `<selector>` | Wait for element to appear and be visible |
| `waitload` | | Wait for page load event |
| `waitstable` | | Wait for DOM to stop changing |
| `waitidle` | | Wait for network to be idle |
| `sleep` | `<seconds>` | Sleep N seconds (float allowed) |
| `screenshot` | `[file]` | Page screenshot |
| `screenshot-el` | `<selector> [file]` | Element screenshot |
| `pages` | | List all tabs (* = active) |
| `page` | `<index>` | Switch to tab by index |
| `newpage` | `[url]` | Open new tab |
| `closepage` | `[index]` | Close tab |
| `exists` | `<selector>` | Exit 0 if exists, 1 if not |
| `count` | `<selector>` | Print number of matching elements |
| `visible` | `<selector>` | Exit 0 if visible, 1 if not |
| `ax-tree` | `[--depth N] [--json]` | Dump accessibility tree |
| `ax-find` | `[--role R] [--name N] [--json]` | Find accessible nodes |
| `ax-node` | `<selector> [--json]` | Show element a11y properties |

---

## Configuration

| Environment Variable | Default | Description |
|---|---|---|
| `ROD_CHROME_BIN` | `/usr/bin/google-chrome` | Path to Chrome/Chromium binary |
| `ROD_TIMEOUT` | `30` | Default timeout in seconds for element queries |
| `HTTPS_PROXY` / `HTTP_PROXY` | (none) | Authenticated proxy, auto-detected on start |

State is stored in `~/.rodney/state.json`. Chrome user data in `~/.rodney/chrome-data/`.

### Proxy support

In environments with authenticated HTTP proxies (`HTTPS_PROXY=http://user:pass@host:port`), `rodney start` automatically launches a local forwarding proxy that injects `Proxy-Authorization` headers into CONNECT requests — necessary because Chrome cannot natively authenticate to proxies during HTTPS tunnel establishment.

---

## Installation

Requires Go 1.21+ and Google Chrome or Chromium.

```sh
# Build from source
git clone https://github.com/simonw/rodney
cd rodney
go build -o rodney .

# Or via PyPI (wrapper)
pip install rodney
```

Set `ROD_CHROME_BIN` if Chrome isn't at the default path.

---

## What it deliberately does NOT do

- ❌ No test DSL or test discovery
- ❌ No fixtures or setup/teardown abstractions
- ❌ No retries or flaky-test mitigation
- ❌ No cross-browser matrix
- ❌ No mobile automation
- ❌ No visual diffing (by default)
- ❌ No built-in reporting

This is by design. Discipline must come from your scripts.

---

## Comparison

### vs Playwright / Selenium

| Aspect | Rodney | Playwright |
|---|---|---|
| Setup | trivial (Go binary) | heavy (runtime + deps) |
| Language | shell | JS / Python / etc. |
| Power | limited | extensive |
| CI integration | immediate | good but verbose |
| ML demo smoke tests | excellent | overkill |
| Large UI test suites | poor fit | correct tool |
| a11y testing | built-in via CDP | via axe plugin |

### vs curl / HTTP tests

- Rodney validates **what users actually see** in a rendered browser
- curl validates only backend HTTP responses

---

## Shell scripting examples

```sh
# Basic flow
rodney start
rodney open https://example.com
rodney waitstable
title=$(rodney title)
echo "Page: $title"
rodney stop

# Conditional on element presence
if rodney exists ".error-message"; then
    rodney text ".error-message"
fi

# Screenshot loop
for url in page1 page2 page3; do
    rodney open "https://example.com/$url"
    rodney waitstable
    rodney screenshot "${url}.png"
done
```

---

## Where it fits for an ML/CV engineer

### High-value use cases

- ML → UI rendering validation (bounding boxes, masks, overlays, captions)
- Demo & dashboard smoke tests in CI
- Agent-generated UI changes verification
- Dataset inspection / labeling tools
- "Prove the demo still works after the last deploy"
- a11y compliance checks without a separate framework

### Low-value / no-value

- Model training or offline evaluation
- Algorithm research
- CUDA / kernel work
- Pure backend services with no UI

Rodney lives at the **ML ↔ Product boundary**.

---

## Strengths

- Extremely low cognitive load — it's just shell
- Shell-native: fits existing Makefiles, CI scripts, agent tool calls
- Deterministic, inspectable failures via exit codes
- Agent-safe: bounded actions, composable primitives
- Built-in a11y inspection via CDP (rare for a CLI tool)
- Apache-2.0, minimal dependencies (single Go binary)

---

## Risks / trade-offs

- Not a testing framework → you must impose discipline yourself
- JS assertions can become messy if abused
- No built-in flake handling (network timing issues)
- Depends on Chromium being installed in the environment
- Early-stage tool (v0.3.0, 14 stars, actively developed — expect API changes)
- No community ecosystem yet (no plugins, no shared assertion libraries)

---

## Operational considerations

| Factor | Assessment |
|---|---|
| Maintenance cost | Low |
| Lock-in | Minimal (shell + JS, trivial to rip out) |
| Removal cost | Trivial |
| Blast radius | Small (edge tool, not core infra) |
| CI compatibility | Any environment with Chrome available |

---

## Adoption decision

Before installing, you should be able to answer **yes** to at least one:

1. *Do I ship ML outputs to a web UI?*
2. *Do I need CI proof that a demo/dashboard still renders correctly?*
3. *Do I want agents to verify UI changes instead of just trusting them?*
4. *Do I need lightweight a11y checks without a full test framework?*

If all are **no**, skip it.

---

## Verdict

Rodney is **not foundational tooling**.
It is a **precision instrument** for a specific failure mode:

> "The model worked. The backend worked. But the UI silently broke."

If that failure mode matters to you — especially at the ML/CV → product boundary — Rodney is worth keeping in your toolbox. The cost of adding it is near-zero, and the cost of removing it is equally trivial.

If not, ignore it with zero regret.

---

*Notes compiled: February 2026 · Rodney v0.3.0*
