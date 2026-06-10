# MEGA - Unrestricted AI Chatbot for iOS (ISH Shell)

```
███╗   ███╗███████╗ ██████╗  █████╗ 
████╗ ████║██╔════╝██╔════╝ ██╔══██╗
██╔████╔██║█████╗  ██║  ███╗███████║
██║╚██╔╝██║██╔══╝  ██║   ██║██╔══██║
██║ ╚═╝ ██║███████╗╚██████╔╝██║  ██║
╚═╝     ╚═╝╚══════╝ ╚═════╝ ╚═╝  ╚═╝
```

## Features

- **Unrestricted AI** — No filters, no refusals, no censorship
- **Proxy Tunneling** — Routes all traffic through rotating proxy pool
- **Auto Proxy Rotation** — Scrapes and rotates through free elite proxies
- **Multiple AI Endpoints** — Falls back through multiple free API providers
- **Session Management** — Save/load multiple conversation threads
- **Full CLI Interface** — Slash commands for everything
- **ISH Shell Optimized** — Built specifically for iOS ISH Shell (Alpine Linux)
- **Offline Fallback** — Graceful degradation when APIs are down
- **Zero Dependencies** — Pure Python 3 standard library, no pip packages needed
- **Persistent Config** — Settings saved between sessions

## Quick Install (ISH Shell on iOS)

### Step 1: Get ISH Shell
Download **ISH Shell** from the iOS App Store (free).

### Step 2: One-Command Install
Open ISH Shell and paste:

```bash
apk add curl && curl -sL https://raw.githubusercontent.com/mega-ai-bot/mega-bot/main/install.sh | sh
```

### Alternative: Manual Install
```bash
# Update packages
apk update
apk add python3 git curl

# Clone the repo
git clone https://github.com/mega-ai-bot/mega-bot.git ~/mega-bot

# Run installer
sh ~/mega-bot/install.sh
```

### Step 3: Launch
```bash
mega
```

That's it. You're in.

## Usage

### Basic Chat
Just type and hit enter:
```
You ▸ explain quantum computing
Mega ▸ [AI response appears here with typing effect]
```

### Commands
| Command | Description |
|---------|-------------|
| `/help` | Show all commands |
| `/clear` | Clear conversation history |
| `/config` | Show current settings |
| `/set <key> <value>` | Change a setting |
| `/model <name>` | Switch AI model |
| `/system <prompt>` | Change system prompt |
| `/proxy on` | Enable proxy tunneling |
| `/proxy off` | Direct connection |
| `/proxy refresh` | Fetch fresh proxy pool |
| `/proxy status` | Show proxy info |
| `/session <name>` | Switch conversation session |
| `/sessions` | List all sessions |
| `/export` | Export chat to text file |
| `/status` | Show bot status |
| `/quit` | Exit Mega |

### Proxy System

Mega automatically scrapes elite proxies from multiple sources and rotates through them. If a proxy fails, it's blacklisted and the next one is used.

```
/proxy on        # Enable proxy routing
/proxy off       # Disable (direct connection)
/proxy refresh   # Get fresh proxy pool
/proxy status    # Check current proxy info
```

### Custom API Key (Optional)

If you have your own OpenAI or compatible API key:
```bash
export MEGA_API_KEY=sk-your-key-here
mega
```

### Multiple Sessions

Keep separate conversations:
```
/session work      # Switch to 'work' session
/session personal  # Switch to 'personal' session  
/sessions          # List all sessions
```

## File Structure

```
~/mega-bot/
├── mega.py          # Main bot application
├── install.sh       # ISH Shell installer
├── uninstall.sh     # Uninstaller (created by install.sh)
└── README.md        # This file

~/.mega_config.json    # User configuration
~/.mega_history.json   # Conversation history
~/.mega_proxies.json   # Cached proxy list
```

## Configuration

Default settings (stored in `~/.mega_config.json`):

```json
{
    "bot_name": "Mega",
    "model": "gpt-3.5-turbo",
    "temperature": 0.9,
    "max_tokens": 4096,
    "proxy_enabled": true,
    "proxy_rotate": true,
    "proxy_timeout": 15,
    "max_history": 50,
    "stream_output": true,
    "color_output": true,
    "retry_attempts": 3
}
```

Change any setting with `/set`:
```
/set temperature 1.2
/set max_tokens 8192
/set proxy_timeout 20
```

## How the Proxy Works

1. On startup, Mega scrapes proxies from 5+ public proxy sources
2. Proxies are tested for connectivity and shuffled
3. Each API request is routed through a random proxy via HTTP CONNECT tunnel
4. If a proxy fails mid-request, it's blacklisted and the next one is used automatically
5. Proxy cache is saved locally and refreshed every hour
6. All traffic uses SSL with the proxy acting as a tunnel (proxy cannot read your data)

## Troubleshooting

**"All proxy attempts failed"**
- Run `/proxy refresh` to get new proxies
- Try `/proxy off` for direct connection
- Check your internet connection in ISH

**"No proxies found"**
- ISH needs active internet. Make sure your iOS device is connected
- Some networks block proxy scraping. Try on a different network

**Slow responses**
- Free proxies can be slow. Try `/proxy off` for speed
- Or set your own API key for faster, direct access

## Uninstall

```bash
sh ~/mega-bot/uninstall.sh
```

## License

Do whatever you want with it. No restrictions.
