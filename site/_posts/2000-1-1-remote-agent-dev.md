---
layout: post
title: "How To Set Up Remote Agent Dev With Claude Code, Codex and Tailscale"
description: "Run Claude Code and Codex on a disposable Linux dev box that keeps agents away from your personal files, then drive them from your phone anywhere with Tailscale. Step by step for Windows and Mac, with the full scripts."
date: "2026/09/26 00:00:00 +1000"
author: "Christian Findlay"
post_image: "/assets/images/blog/ai-agent/header.webp"
image: "/assets/images/blog/ai-agent/header.webp"
tags: ai claude-code codex tailscale
categories: [software development]
permalink: /blog/:title
keywords: [remote development, Claude Code remote control, Claude Code mobile, Codex remote, Claude Code sandbox, Claude Code Docker, Claude Code SSH, Claude Code WSL, Tailscale SSH, AI agent security, WSL2 dev environment, Multipass]
---

I don't run coding agents on my personal computer anymore. Claude Code and Codex live on a Linux box that runs 24/7, and I can wipe it and rebuild it with one command. I start sessions from my phone, check on them from my Mac, and pick them up from wherever I happen to be. None of this requires a cloud VM, a static IP, or an open port on my router.

This tutorial walks you through the exact setup, on Windows or Mac, with the real scripts. It works for Claude Code, Codex, and any other agent harness that runs in a terminal.

> **Key Takeaways**: Give your agents their own disposable Linux machine: WSL2 on Windows, a Multipass VM on a Mac. That keeps them away from your personal files, and a script can rebuild the machine from scratch at any time. Claude Code's Remote Control and Codex's remote control let you drive sessions from your phone. Tailscale gives you secure SSH access from anywhere, with no ports open to the internet. Cloud agents are still a good option, but they're ephemeral. This is a persistent dev machine.

## Why Your Agents Need Their Own Machine

Coding agents run shell commands. That's the whole point. They install packages, delete files, run migrations, and push branches. Permission prompts are supposed to keep that under control, but let's be honest about what happens in practice. After the fortieth prompt, everybody either clicks "yes" without reading or switches to bypass mode.

Now think about what else lives on your personal computer. Browser sessions. SSH keys. Your password manager. Cloud credentials. Tax returns and family photos. The agent needs none of that, and every one of those things is one bad command or one [prompt injection](https://genai.owasp.org/llmrisk/llm01-prompt-injection/) away from being deleted or leaked. Prompt injection is the one that worries me. A README, a GitHub issue, or a web page the agent reads can contain instructions, and the agent can't reliably tell the difference between your instructions and someone else's.

Anthropic's own [development container docs](https://code.claude.com/docs/en/devcontainer) say you should only skip permissions inside an isolated container. They also point out that the container doesn't stop a malicious project from exfiltrating anything *inside* the container, including Claude's own credentials. So the rule is simple: **the agent's machine should only contain what the agent needs.**

The other half of this is disposability. If an agent trashes the machine, or you do, you wipe it and run the script again. If you reinstall your whole computer, you run the script again. That only works if you follow one rule religiously:

**Anything that gets installed on the box goes in the script.** No manual installs. No "I'll write that down later". If it isn't in the script, it doesn't exist.

## Container, VM, or Cloud?

I'm using the word container loosely here. What you want is a separate Linux machine with its own filesystem, and there are a few ways to get one.

| Option | Persists? | Good For |
| --- | --- | --- |
| Cloud agents ([Claude Code on the web](https://code.claude.com/docs/en/claude-code-on-the-web), Codex cloud) | No, a fresh container per task | Fire-and-forget tasks against a GitHub repo |
| Dev containers (Docker, per project) | Per project | Isolating one repo's toolchain |
| **A local Linux box (WSL2 or Multipass)** | **Yes** | **A primary dev machine that agents live on** |

Cloud agents aren't wrong. They're another option, and I use them. But they're designed to be ephemeral. Every task starts from a clean image, so your caches, toolchains, logins, and half-finished branches don't stick around. What I'm describing here is a dev machine that persists over time, just like your laptop does, but one you can throw away the moment it stops being useful.

On Windows, that's [WSL2](https://learn.microsoft.com/en-us/windows/wsl/about), which runs a real Linux kernel in a lightweight utility VM. On a Mac, it's [Multipass](https://canonical.com/multipass), which runs a full Ubuntu VM. Either way, you end up with a normal Ubuntu machine that you can SSH into.

## Tailscale Is the Missing Piece

Claude and ChatGPT both relay remote sessions through their own servers, so the mobile apps can reach your machine without any networking on your part. But the moment you want a terminal, VS Code, or any other agent harness, you need to reach the box itself. The traditional answer is port forwarding, dynamic DNS, and an SSH port exposed to the entire internet. Please don't do that.

[Tailscale](https://tailscale.com) is a WireGuard-based private network that connects your own devices to each other, wherever they are. Your phone on mobile data can reach your dev box at home by name. Nothing is opened on your router. Nothing is exposed to the internet. The free personal plan is plenty for this.

[Tailscale SSH](https://tailscale.com/kb/1193/tailscale-ssh) is the best part. Tailscale handles authentication with your identity instead of SSH keys, so there are no keys to generate, copy, or lose. By default, new tailnets let you SSH to your own devices in "check mode", which makes you re-authenticate in a browser every 12 hours.

## What You're Building

When you're done, you'll have this:

- **An Ubuntu 26.04 dev box** that starts when the computer boots, before anyone logs in, and stays running
- **Claude Code** with Remote Control on for every session, plus an always-on Remote Control server for each project folder
- **Codex** with its remote control daemon running at boot
- **Tailscale** so you can SSH into the box from your phone, laptop, or anywhere else
- **Docker, Node, Rust, .NET, and Python** as a starting point, which you should swap for your own toolchains
- **Two scripts** that rebuild all of it from nothing

Before you start, you need:

- A computer that stays on. A desktop PC or a Mac mini is ideal. A laptop with the lid closed goes to sleep, and a sleeping machine can't run agents.
- A Claude Pro, Max, Team, or Enterprise plan. [Remote Control doesn't work with API keys](https://code.claude.com/docs/en/remote-control), and on Team and Enterprise an owner has to switch it on first.
- A ChatGPT plan that includes Codex.
- A free [Tailscale](https://tailscale.com) account.

## Step 1 on Windows: Create the Box With WSL2

Save `setup.ps1` (below) and `bootstrap.sh` (from Step 2) in the same folder, then run this from PowerShell:

```powershell
powershell -ExecutionPolicy Bypass -File .\setup.ps1
```

It asks for admin rights once. If WSL isn't installed yet, it installs it and tells you to reboot and run it again. This is what the script does:

1. Creates an Ubuntu 26.04 WSL distro called `AgentBox`, with a Linux user matching your Windows username and passwordless `sudo`
2. Switches on systemd, sets the hostname to `devbox`, and **turns off mounting your Windows drives inside Linux**
3. Copies `bootstrap.sh` into the box and runs it
4. Registers a scheduled task that starts the box at boot, before anyone logs in
5. Stops Windows sleeping, and stops Windows Update installing preview updates and restarting on its own

That last one isn't paranoia. While I was setting this up, Windows installed an optional preview update and restarted itself in the middle of the day. Every agent session on the box died. The box came back up by itself, which is nice, but the running sessions didn't.

```powershell
# Creates (or with -Wipe, recreates) the agent dev box in WSL and provisions it with bootstrap.sh. Safe to re-run; self-elevates.
# Usage: .\setup.ps1 [-Wipe] [-Distro AgentBox] [-User yourname] [-HostName devbox]
param([string]$Distro = 'AgentBox', [string]$User = $env:USERNAME.ToLower(), [string]$HostName = 'devbox', [switch]$Wipe)
$ErrorActionPreference = 'Stop'; $env:WSL_UTF8 = 1
$log = "$env:TEMP\$Distro-setup.log"
if (-not ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole('Administrators')) {
  $a = @('-NoProfile', '-ExecutionPolicy', 'Bypass', '-File', "`"$PSCommandPath`"") + ($PSBoundParameters.GetEnumerator() | % { if ($_.Value -is [switch]) { "-$($_.Key)" } else { "-$($_.Key)", $_.Value } })
  Start-Process powershell -Verb RunAs -Wait -ArgumentList $a; Get-Content $log; exit
}
Start-Transcript $log | Out-Null
function Run { & $args[0] $args[1..($args.Count - 1)]; if ($LASTEXITCODE) { throw "Failed: $args" } }
function Root { Run wsl -d $Distro -u root --exec sh -c $args[0] }

wsl --version *> $null
if ($LASTEXITCODE) { Run wsl --install --no-distribution; throw 'WSL installed. Reboot, then run setup.ps1 again.' }
if ($Wipe) { wsl --unregister $Distro }
if ((wsl -l -q) -notcontains $Distro) { Run wsl --install Ubuntu-26.04 --name $Distro --no-launch }

Root "id $User >/dev/null 2>&1 || useradd -m -s /bin/bash -G sudo $User"
Root "echo '$User ALL=(ALL) NOPASSWD:ALL' > /etc/sudoers.d/$User"
# systemd for services, and no Windows drives mounted inside Linux: the agents can't see your personal files.
$conf = "[boot]`nsystemd=true`n[user]`ndefault=$User`n[network]`nhostname=$HostName`n[automount]`nenabled=false`n[interop]`nappendWindowsPath=false"
if ((((wsl -d $Distro -u root --exec cat /etc/wsl.conf) -join "`n") -ne $conf)) {
  Root "printf '$($conf.Replace("`n", '\n'))\n' > /etc/wsl.conf"; Run wsl --terminate $Distro
}

# Copy bootstrap.sh in (the Windows drive isn't mounted) and run it as your Linux user.
$b64 = [Convert]::ToBase64String([IO.File]::ReadAllBytes("$PSScriptRoot\bootstrap.sh"))
Root "echo $b64 | base64 -d | tr -d '\r' > /usr/local/bin/devbox-bootstrap && chmod +x /usr/local/bin/devbox-bootstrap"
$name = try { git config --global user.name } catch { '' }; $email = try { git config --global user.email } catch { '' }
Run wsl -d $Distro -u $User --exec env "GIT_NAME=$name" "GIT_EMAIL=$email" "TS_AUTHKEY=$env:TS_AUTHKEY" devbox-bootstrap

# Start the box at boot, before anyone logs on, and keep it running.
$settings = New-ScheduledTaskSettingsSet -ExecutionTimeLimit ([TimeSpan]::Zero) -AllowStartIfOnBatteries -DontStopIfGoingOnBatteries
$boot = New-ScheduledTaskAction -Execute wsl.exe -Argument "-d $Distro --exec sleep infinity"
Register-ScheduledTask "WSL $Distro boot" -Action $boot -Trigger (New-ScheduledTaskTrigger -AtStartup) -Settings $settings -Principal (New-ScheduledTaskPrincipal -UserId $env:USERNAME -LogonType S4U) -Force | Out-Null
Start-ScheduledTask "WSL $Distro boot"

# On 24/7 when plugged in: no sleep, no hibernate, no disk spin-down. Only the monitor turns off.
'standby-timeout-ac', 'hibernate-timeout-ac', 'disk-timeout-ac' | % { powercfg /change $_ 0 }
# No surprise reboots (they kill every agent session): no preview updates, and you choose when to install and restart.
$au = 'HKLM:\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate\AU'; New-Item $au -Force | Out-Null
@{ AUOptions = 3; NoAutoUpdate = 0; NoAutoRebootWithLoggedOnUsers = 1 }.GetEnumerator() | % { Set-ItemProperty $au $_.Key $_.Value -Type DWord }
Set-ItemProperty 'HKLM:\SOFTWARE\Microsoft\WindowsUpdate\UX\Settings' IsContinuousInnovationOptedIn 0 -Type DWord

Write-Host "Done. Open it with: wsl -d $Distro"
Stop-Transcript | Out-Null
```

A few things to know about the Windows side.

**By default, WSL mounts your entire C: drive at `/mnt/c`, with read and write access.** That's convenient, and it defeats the whole point of this exercise. The script turns it off with `[automount] enabled=false` in [`wsl.conf`](https://learn.microsoft.com/en-us/windows/wsl/wsl-config). That's why it copies `bootstrap.sh` into the box instead of running it from your Windows folder. Be clear about what this is, though: it's a guardrail, not a wall. Your Linux user has passwordless `sudo`, and root inside WSL can mount a Windows drive again. There are also [edge cases](https://github.com/microsoft/WSL/issues/12443) where WSL mounts drives anyway. It stops accidents and casual snooping. If you need a hard boundary, use a full VM.

**Interop stays on.** Windows interop lets Linux launch Windows programs. You could switch it off too, but [VS Code needs it to connect to WSL](https://github.com/microsoft/vscode/issues/261234). I keep it on and stop Windows' `PATH` leaking into Linux instead.

**You can still browse the box's files from Windows.** Open `\\wsl.localhost\AgentBox` in File Explorer. Access works in that direction only.

## Step 1 on a Mac: Create the Box With Multipass

On a Mac, [Multipass](https://canonical.com/multipass) gives you a real Ubuntu VM with a single command. Install it and create a **named** instance:

```bash
brew install --cask multipass
multipass launch 26.04 --name devbox --cpus 4 --memory 16G --disk 200G
```

Use a named instance, not Multipass's "primary" instance. The [primary instance automatically mounts your home folder](https://canonical.com/multipass/docs/latest/how-to-guides/manage-instances/use-the-primary-instance/), which is exactly what you're trying to avoid. A named instance can't see your Mac's files unless you explicitly run `multipass mount`.

Save `bootstrap.sh` from Step 2, copy it in, and run it:

```bash
multipass transfer bootstrap.sh devbox:
multipass exec devbox -- env GIT_NAME="$(git config user.name)" GIT_EMAIL="$(git config user.email)" TS_AUTHKEY="$TS_AUTHKEY" bash bootstrap.sh
```

Multipass doesn't restart instances after a reboot, so add a launch daemon that starts the box at boot and checks on it every five minutes:

```bash
sudo tee /Library/LaunchDaemons/dev.devbox.start.plist >/dev/null <<'EOF'
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0"><dict>
  <key>Label</key><string>dev.devbox.start</string>
  <key>ProgramArguments</key><array><string>/usr/local/bin/multipass</string><string>start</string><string>devbox</string></array>
  <key>RunAtLoad</key><true/>
  <key>StartInterval</key><integer>300</integer>
</dict></plist>
EOF
sudo launchctl bootstrap system /Library/LaunchDaemons/dev.devbox.start.plist
```

Then stop the Mac sleeping, bring it back after a power cut, and stop macOS installing updates and restarting on its own:

```bash
sudo pmset -a sleep 0 disksleep 0 displaysleep 10 autorestart 1 womp 1
sudo defaults write /Library/Preferences/com.apple.SoftwareUpdate AutomaticallyInstallMacOSUpdates -bool false
```

Everything in `bootstrap.sh` supports both Intel and Apple silicon, so the same script works on either kind of Mac.

## Step 2: The Bootstrap Script

`bootstrap.sh` is the single source of truth for what's on the box. It's idempotent, so you can run it again at any time to update everything or add something new. Put your repos in `REPOS` at the top, and swap the `toolchains` section for whatever you actually build with.

```bash
#!/usr/bin/env bash
# Provisions the agent dev box. Idempotent: re-run it any time to install or update everything.
set -euo pipefail
REPOS=""  # e.g. "your-org/your-repo your-org/other-repo" - cloned into ~/code
export DEBIAN_FRONTEND=noninteractive PATH="$HOME/.local/bin:$HOME/.cargo/bin:$HOME/.dotnet:$PATH"
has() { command -v "$1" >/dev/null; }
step() { printf '\n\033[1;36m==> %s\033[0m\n' "$*"; }

step apt
systemctl is-system-running --wait >/dev/null 2>&1 || true  # a fresh box may still be booting
gh=/usr/share/keyrings/githubcli-archive-keyring.gpg
[ -f $gh ] || { curl -fsSL https://cli.github.com/packages/githubcli-archive-keyring.gpg | sudo tee $gh >/dev/null
  echo "deb [signed-by=$gh] https://cli.github.com/packages stable main" | sudo tee /etc/apt/sources.list.d/github-cli.list >/dev/null; }
sudo apt-get update -qq
sudo apt-get install -y -qq build-essential pkg-config libssl-dev git curl unzip jq ripgrep tmux gh \
  libicu-dev python3 python3-venv docker.io docker-compose-v2
sudo apt-get upgrade -y -qq
sudo usermod -aG docker "$USER" && sudo systemctl enable --now docker

step git
git config --global init.defaultBranch main
[ -z "${GIT_NAME:-}" ] || git config --global user.name "$GIT_NAME"
[ -z "${GIT_EMAIL:-}" ] || git config --global user.email "$GIT_EMAIL"

step toolchains  # swap these for whatever you build with
has fnm || curl -fsSL https://fnm.vercel.app/install | bash -s -- --install-dir "$HOME/.local/bin" --skip-shell
fnm install --lts && fnm default lts-latest && eval "$(fnm env)"
has rustup || curl -fsSL https://sh.rustup.rs | sh -s -- -y --no-modify-path
rustup update stable && rustup component add clippy rustfmt
curl -fsSL https://dot.net/v1/dotnet-install.sh | bash -s -- --channel LTS --install-dir "$HOME/.dotnet"
has uv || curl -fsSL https://astral.sh/uv/install.sh | env UV_NO_MODIFY_PATH=1 sh

step agents
has claude || curl -fsSL https://claude.ai/install.sh | bash
npm i -g --silent @openai/codex
s=~/.claude/settings.json && mkdir -p ~/.claude ~/.codex && { [ -s $s ] || echo '{}' > $s; }
jq '.remoteControlAtStartup = true' $s > $s.tmp && mv $s.tmp $s  # every Claude session is remote-controllable

step services
# One Claude Remote Control server for ~/code plus one per folder in it, a watcher that adds/removes
# servers as folders come and go, and the Codex remote control daemon. They retry until you've signed in.
u=~/.config/systemd/user && mkdir -p ~/code ~/.local/bin $u/default.target.wants
unit() { printf '[Unit]\nDescription=Claude Remote Control %s\n[Service]\nWorkingDirectory=%s\nExecStart=/bin/bash -lc '\''exec claude remote-control %s'\''\nRestart=always\nRestartSec=30\n' "$@"; }
unit '~/code' '%h/code' '' > $u/claude-rc.service
unit '~/code/%I' '%h/code/%I' '--no-create-session-in-dir' > $u/claude-rc@.service
printf '[Service]\nType=oneshot\nExecStart=%%h/.local/bin/claude-rc-sync\n' > $u/claude-rc-sync.service
printf '[Path]\nPathChanged=%%h/code\n' > $u/claude-rc-sync.path
printf '[Unit]\nDescription=Codex remote control\n[Service]\nType=oneshot\nRemainAfterExit=yes\nWorkingDirectory=%%h/code\nExecStart=/bin/bash -lc '\''exec codex remote-control start'\''\nExecStop=/bin/bash -lc '\''exec codex remote-control stop'\''\nRestart=on-failure\nRestartSec=30\n' > $u/codex-rc.service
cat > ~/.local/bin/claude-rc-sync <<'EOF'
#!/usr/bin/env bash
f=~/.claude.json && { [ -s $f ] || echo '{}' > $f; }
for d in ~/code/*/; do [ -d "$d" ] || continue; n=$(basename "$d"); p=$HOME/code/$n
  jq -e --arg p "$p" '.projects[$p].hasTrustDialogAccepted' $f >/dev/null ||  # everything in ~/code is yours: trust it
    { jq --arg p "$p" '.projects[$p].hasTrustDialogAccepted = true' $f > $f.tmp && mv $f.tmp $f; }
  grep -qF "[projects.\"$p\"]" ~/.codex/config.toml 2>/dev/null || printf '\n[projects."%s"]\ntrust_level = "trusted"\n' "$p" >> ~/.codex/config.toml
  systemctl --user start "$(systemd-escape --template=claude-rc@.service "$n")"; done
systemctl --user list-units 'claude-rc@*' --plain --no-legend | while read -r s _; do
  [ -d ~/code/"$(systemd-escape -u --instance "$s")" ] || systemctl --user stop "$s"; done
EOF
chmod +x ~/.local/bin/claude-rc-sync
for s in claude-rc.service claude-rc-sync.service claude-rc-sync.path codex-rc.service; do ln -sf ../$s $u/default.target.wants/$s; done
sudo loginctl enable-linger "$USER"  # user services start at boot, no login needed
export XDG_RUNTIME_DIR=/run/user/$(id -u)
systemctl --user daemon-reload && systemctl --user start claude-rc.service claude-rc-sync.path claude-rc-sync.service codex-rc.service || true

step tailscale
has tailscale || curl -fsSL https://tailscale.com/install.sh | sh
[ -z "${TS_AUTHKEY:-}" ] || tailscale status >/dev/null 2>&1 || sudo tailscale up --ssh --auth-key="$TS_AUTHKEY"

step shell
cat > ~/.devenv <<'EOF'
[ -n "${DEVENV:-}" ] && return; export DEVENV=1
export PATH="$HOME/.local/bin:$HOME/.cargo/bin:$HOME/.dotnet:$PATH" DOTNET_ROOT="$HOME/.dotnet"
eval "$(fnm env --shell bash)"
EOF
for f in ~/.profile ~/.bashrc; do grep -q '\.devenv' "$f" || echo '. ~/.devenv' >> "$f"; done

step repos
for r in $REPOS; do [ -d ~/code/"${r#*/}" ] || GIT_TERMINAL_PROMPT=0 git clone -q "https://github.com/$r" ~/code/"${r#*/}" || echo "clone $r failed: re-run after signing in to gh"; done

step versions
for c in node cargo dotnet uv docker gh claude codex tailscale; do printf '%-10s %s\n' "$c" "$("$c" --version 2>&1 | head -1)"; done
```

Most of that is ordinary package installation. The `agents` and `services` sections are the interesting parts.

**`remoteControlAtStartup`** makes every interactive Claude Code session on the box connect to Remote Control automatically. It has to go in your *user* settings file, `~/.claude/settings.json`. [Claude ignores a `true` in a project's settings](https://code.claude.com/docs/en/remote-control), so a repo can switch Remote Control off for itself but can't switch it on.

**One Remote Control server per project.** `claude remote-control` runs Claude Code in [server mode](https://code.claude.com/docs/en/remote-control): a long-running process that you can start new sessions from, from the Claude app or [claude.ai/code](https://claude.ai/code). Each server serves one directory, so the script runs one for `~/code` and one for every folder inside it. A systemd path unit watches `~/code`. Clone a repo and its server appears within seconds. Delete the folder and the server stops.

**systemd restarts everything.** In server mode, Claude gives up after roughly ten minutes without a network connection, and the process exits. That's fine here, because systemd starts it again. `loginctl enable-linger` makes these user services start at boot without anyone logging in.

**Auto-trust is a deliberate trade-off.** Claude and Codex both refuse to work in a folder until you accept a "do you trust this folder?" prompt. There's nobody at the keyboard to click it, so the watcher trusts every folder in `~/code`. Only put your own code there. If you clone something you don't trust, clone it somewhere else.

**Codex runs a shared daemon.** `codex remote-control start` starts the app-server daemon with remote control enabled. Codex sessions on the box use that daemon by default, so they're reachable from the ChatGPT app too.

## Step 3: Sign In Once

Open the box (`wsl -d AgentBox` on Windows, `multipass shell devbox` on a Mac) and run:

```bash
gh auth login && gh auth setup-git; claude; codex login; sudo tailscale up --ssh
```

Exit Claude with `/exit` once you've logged in, so the next command runs. Each tool prints a link, and **you can open every one of them on your phone**. You don't need to be sitting at the computer.

This is a one-time step. Reboots, power cuts, and updates don't log anything out. The Remote Control servers and the Codex daemon have been retrying in the background the whole time, and they connect within 30 seconds of you signing in. Tailscale reconnects by itself on every boot from now on.

Only a wipe resets the logins. If you want a wipe to be completely hands-off, create a reusable [Tailscale auth key](https://tailscale.com/kb/1085/auth-keys) and set it before running the setup. The bootstrap script uses it to join your tailnet automatically:

```powershell
$env:TS_AUTHKEY = "tskey-auth-..."   # Windows, before .\setup.ps1
```

On a Mac, run `export TS_AUTHKEY=tskey-auth-...` before the `multipass exec` command.

## Step 4: Drive It From Your Phone

**Claude Code.** Open the Claude app, go to **Code**, and pick the environment for the project you want. Every folder in `~/code` shows up, because every folder has its own server. Start a session and go. If a session goes offline because the box restarted, send it a message once the box is back. In server mode, [Claude serves a crashed session again](https://code.claude.com/docs/en/remote-control) when you message it.

**Codex.** On the box, run:

```bash
codex remote-control pair
```

It prints a short-lived pairing code. In the ChatGPT app, open the Codex pairing screen, choose **Pair manually**, and enter the code. OpenAI's [documented flow](https://learn.chatgpt.com/docs/remote) pairs through the ChatGPT desktop app with a QR code. The CLI route is still marked experimental, but it's the one that works on a headless Linux box.

**A terminal.** Install Tailscale on your phone and sign in with the same account. On an iPhone, install [Termius](https://termius.com) and add a host with hostname `devbox`, your Linux username, and no password. On a Mac or another laptop, it's just this:

```bash
ssh yourname@devbox
```

Once you're in, start or reattach a tmux session so your work survives your phone dropping out:

```bash
tmux new -A -s main
```

**VS Code.** On Windows, run **WSL: Connect to WSL** and pick the distro. From anywhere else, use [Remote - SSH](https://code.visualstudio.com/docs/remote/ssh) to connect to `devbox` over Tailscale.

## Any Other Agent Harness

Nothing here is specific to Claude or Codex. Any agent that runs in a terminal works over SSH and tmux: Aider, OpenCode, Gemini CLI, your own homegrown agent. Add its install line to `bootstrap.sh`, run the script again, and it's on the box. The only thing that's specific to Claude and Codex is the phone apps.

## Wipe It Whenever You Like

The box is disposable, so treat it that way:

```powershell
powershell -ExecutionPolicy Bypass -File .\setup.ps1 -Wipe   # Windows
```

```bash
multipass delete --purge devbox   # Mac, then repeat Step 1
```

Your code lives in git, so push often. Anything that isn't pushed and isn't in the script is gone after a wipe. That's the feature, not the bug. It forces the machine to stay reproducible.

## Gotchas

- **Keep the computer awake.** A sleeping computer means sleeping agents. Both setups switch sleep off. Only the display turns off.
- **Automatic OS restarts kill running sessions.** The box comes back by itself, but work in progress doesn't. That's why both setups stop automatic restarts, and why you should install updates yourself when nothing is running.
- **Remote Control needs a subscription.** It doesn't work with an API key, or with the long-lived tokens from `claude setup-token`. Sign in with `claude` normally.
- **Remote Control transcripts are stored on Anthropic's servers** while you're connected. That's how the conversation syncs across devices. If you're on a Pro or Max plan, consider turning on **Require trusted devices** in your Claude account settings.
- **Codex on Windows refuses to run with admin rights.** This only matters if you also run Codex on the Windows host. Start it from a normal terminal, not an elevated one.
- **"Failed to start the systemd user session" on WSL.** If you already run another systemd distro, the box's user services can fail with `Device or resource busy`. This is a [known WSL issue](https://github.com/microsoft/WSL/issues/8842). Run `wsl --shutdown` once and open the box again.
- **Disk space.** The Linux disk grows on your host's drive. Rust `target` folders and Docker images add up fast.

## Remote Agent Dev Is a Solved Problem

Twelve months ago, running agents remotely meant renting a cloud VM, wrestling with SSH keys, and keeping a terminal open on your laptop. Now it's two scripts and a one-time sign-in. The agents get a machine of their own, your personal files stay out of reach, and Tailscale gives you secure access from anywhere without exposing anything to the internet.

Cloud containers are still a good option for fire-and-forget tasks. But if you want a real dev machine that remembers your toolchains and your half-finished work, runs around the clock, and doesn't have access to your whole life, this is the setup.

Build the box, sign in once, and go for a walk. Your agents will still be there when you check your phone.

<small>Note that some or all of the content here was written with the assistance of AI. [View the AI Content Policy](ai-writing)</small>
