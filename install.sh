#!/bin/sh
# ═══════════════════════════════════════════════════════════════
#  MEGA BOT - ISH Shell Installer
#  One-command install for iOS ISH Shell
#  Usage: sh install.sh
# ═══════════════════════════════════════════════════════════════

set -e

# Colors
RED='\033[91m'
GREEN='\033[92m'
YELLOW='\033[93m'
CYAN='\033[96m'
BOLD='\033[1m'
DIM='\033[2m'
RESET='\033[0m'

MEGA_DIR="$HOME/mega-bot"
MEGA_BIN="/usr/local/bin/mega"

echo ""
echo "${CYAN}${BOLD}"
echo "    ███╗   ███╗███████╗ ██████╗  █████╗ "
echo "    ████╗ ████║██╔════╝██╔════╝ ██╔══██╗"
echo "    ██╔████╔██║█████╗  ██║  ███╗███████║"
echo "    ██║╚██╔╝██║██╔══╝  ██║   ██║██╔══██║"
echo "    ██║ ╚═╝ ██║███████╗╚██████╔╝██║  ██║"
echo "    ╚═╝     ╚═╝╚══════╝ ╚═════╝ ╚═╝  ╚═╝"
echo "${RESET}"
echo "    ${DIM}ISH Shell Installer v2.0${RESET}"
echo ""

# ── Step 1: Update package manager ──────────────────────────
echo "${YELLOW}[1/6]${RESET} Updating apk package manager..."
apk update 2>/dev/null || {
    echo "${RED}✗ Failed to update apk. Make sure you have internet.${RESET}"
    exit 1
}
echo "${GREEN}  ✓ Package manager updated${RESET}"

# ── Step 2: Install Python & dependencies ───────────────────
echo "${YELLOW}[2/6]${RESET} Installing Python 3 and dependencies..."
apk add --no-cache \
    python3 \
    py3-pip \
    py3-openssl \
    ca-certificates \
    curl \
    git \
    openssl \
    libffi-dev \
    2>/dev/null

# Ensure python3 is linked
if ! command -v python3 >/dev/null 2>&1; then
    echo "${RED}✗ Python3 installation failed${RESET}"
    exit 1
fi
echo "${GREEN}  ✓ Python $(python3 --version 2>&1 | awk '{print $2}') installed${RESET}"

# ── Step 3: Create Mega directory ───────────────────────────
echo "${YELLOW}[3/6]${RESET} Setting up Mega directory..."
mkdir -p "$MEGA_DIR"
echo "${GREEN}  ✓ Created $MEGA_DIR${RESET}"

# ── Step 4: Download Mega bot ──────────────────────────────
echo "${YELLOW}[4/6]${RESET} Downloading Mega bot..."

# Clone from GitHub
REPO_URL="https://github.com/mega-ai-bot/mega-bot.git"

# Try git clone first
if command -v git >/dev/null 2>&1; then
    if git clone "$REPO_URL" "$MEGA_DIR/repo" 2>/dev/null; then
        cp "$MEGA_DIR/repo/mega.py" "$MEGA_DIR/mega.py"
        rm -rf "$MEGA_DIR/repo"
        echo "${GREEN}  ✓ Downloaded from GitHub${RESET}"
    else
        echo "${YELLOW}  ⚠ GitHub clone failed, checking local files...${RESET}"
        if [ ! -f "$MEGA_DIR/mega.py" ]; then
            echo "${YELLOW}  → Downloading via curl fallback...${RESET}"
            curl -sL "https://raw.githubusercontent.com/mega-ai-bot/mega-bot/main/mega.py" \
                -o "$MEGA_DIR/mega.py" 2>/dev/null || {
                echo "${RED}  ✗ Download failed. Place mega.py in $MEGA_DIR manually.${RESET}"
                echo "${DIM}  You can copy mega.py from the GitHub repo to $MEGA_DIR/${RESET}"
            }
        fi
    fi
else
    echo "${YELLOW}  ⚠ Git not available, using curl...${RESET}"
    curl -sL "https://raw.githubusercontent.com/mega-ai-bot/mega-bot/main/mega.py" \
        -o "$MEGA_DIR/mega.py" 2>/dev/null || {
        echo "${YELLOW}  → Using local mega.py if available${RESET}"
    }
fi

# Verify mega.py exists
if [ ! -f "$MEGA_DIR/mega.py" ]; then
    echo "${RED}✗ mega.py not found in $MEGA_DIR${RESET}"
    echo "${YELLOW}  Please copy mega.py to $MEGA_DIR/ manually${RESET}"
    echo "${DIM}  Then run: sh install.sh${RESET}"
    exit 1
fi

echo "${GREEN}  ✓ Mega bot ready at $MEGA_DIR/mega.py${RESET}"

# ── Step 5: Create launcher script ─────────────────────────
echo "${YELLOW}[5/6]${RESET} Creating 'mega' command..."

cat > "$MEGA_BIN" << 'LAUNCHER'
#!/bin/sh
# Mega Bot Launcher
MEGA_DIR="$HOME/mega-bot"
MEGA_SCRIPT="$MEGA_DIR/mega.py"

if [ ! -f "$MEGA_SCRIPT" ]; then
    echo "\033[91m✗ Mega not found at $MEGA_SCRIPT\033[0m"
    echo "  Run the installer again or place mega.py in $MEGA_DIR/"
    exit 1
fi

# Pass all arguments through
exec python3 "$MEGA_SCRIPT" "$@"
LAUNCHER

chmod +x "$MEGA_BIN"
chmod +x "$MEGA_DIR/mega.py"
echo "${GREEN}  ✓ Command 'mega' installed${RESET}"

# ── Step 6: Create uninstaller ──────────────────────────────
echo "${YELLOW}[6/6]${RESET} Creating uninstaller..."

cat > "$MEGA_DIR/uninstall.sh" << 'UNINSTALL'
#!/bin/sh
echo "Removing Mega bot..."
rm -f /usr/local/bin/mega
rm -rf "$HOME/mega-bot"
rm -f "$HOME/.mega_config.json"
rm -f "$HOME/.mega_history.json"
rm -f "$HOME/.mega_proxies.json"
echo "✓ Mega has been uninstalled"
UNINSTALL
chmod +x "$MEGA_DIR/uninstall.sh"
echo "${GREEN}  ✓ Uninstaller created${RESET}"

# ── Done ────────────────────────────────────────────────────
echo ""
echo "${GREEN}${BOLD}═══════════════════════════════════════════════════${RESET}"
echo "${GREEN}${BOLD}  ✓ MEGA BOT INSTALLED SUCCESSFULLY${RESET}"
echo "${GREEN}${BOLD}═══════════════════════════════════════════════════${RESET}"
echo ""
echo "  ${CYAN}To start Mega:${RESET}"
echo "    ${BOLD}mega${RESET}"
echo ""
echo "  ${CYAN}Quick commands inside Mega:${RESET}"
echo "    ${YELLOW}/help${RESET}           - Show all commands"
echo "    ${YELLOW}/proxy on${RESET}       - Enable proxy tunnel"
echo "    ${YELLOW}/proxy off${RESET}      - Direct connection"
echo "    ${YELLOW}/proxy refresh${RESET}  - Get fresh proxies"
echo "    ${YELLOW}/status${RESET}         - Show bot status"
echo "    ${YELLOW}/quit${RESET}           - Exit"
echo ""
echo "  ${CYAN}Optional - Set your own API key:${RESET}"
echo "    ${DIM}export MEGA_API_KEY=sk-your-key-here${RESET}"
echo ""
echo "  ${CYAN}To uninstall:${RESET}"
echo "    ${DIM}sh ~/mega-bot/uninstall.sh${RESET}"
echo ""
echo "  ${GREEN}${BOLD}Type 'mega' to start chatting!${RESET}"
echo ""
