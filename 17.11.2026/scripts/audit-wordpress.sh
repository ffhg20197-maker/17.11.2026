#!/usr/bin/env bash
# Read-only audit. Usage: bash audit-wordpress.sh /path/to/wordpress
set -u
ROOT="${1:-.}"
ROOT="$(cd "$ROOT" 2>/dev/null && pwd)" || { echo 'ERROR: root not found'; exit 2; }
PASS=0; WARN=0; FAIL=0
ok(){ echo "[PASS] $1"; PASS=$((PASS+1)); }
warn(){ echo "[WARN] $1"; WARN=$((WARN+1)); }
fail(){ echo "[FAIL] $1"; FAIL=$((FAIL+1)); }
for f in wp-load.php wp-settings.php wp-includes/version.php; do [ -f "$ROOT/$f" ] && ok "Core marker: $f" || fail "Missing: $f"; done
for f in readme.html license.txt; do [ -e "$ROOT/$f" ] && warn "Remove if unnecessary: $f" || ok "Absent: $f"; done
if find "$ROOT" -maxdepth 1 -type f \( -iname '*.sql' -o -iname '*.zip' -o -iname '*.bak' \) -print -quit | grep -q .; then fail 'Backup/dump file in web-root'; else ok 'No common backups in web-root'; fi
CFG="$ROOT/wp-config.php"; [ -f "$CFG" ] || CFG="$(dirname "$ROOT")/wp-config.php"
if [ -f "$CFG" ]; then
 mode="$(stat -c '%a' "$CFG" 2>/dev/null || stat -f '%Lp' "$CFG" 2>/dev/null || echo unknown)"
 case "$mode" in 400|440) ok "wp-config.php mode $mode";; *) warn "wp-config.php mode $mode; target 400/440";; esac
 grep -Eq "DISALLOW_FILE_EDIT[[:space:]]*,[[:space:]]*true" "$CFG" && ok 'DISALLOW_FILE_EDIT true' || warn 'DISALLOW_FILE_EDIT not detected'
 for c in WP_DEBUG WP_DEBUG_DISPLAY WP_DEBUG_LOG; do grep -q "$c" "$CFG" && ok "$c directive found" || warn "$c not detected"; done
 grep -Eq "table_prefix[[:space:]]*=[[:space:]]*['\"]wp_['\"]" "$CFG" && warn 'Default wp_ prefix detected' || ok 'No literal default prefix detected; verify manually'
else fail 'wp-config.php missing in root and parent'; fi
UP="$ROOT/wp-content/uploads"
if [ -d "$UP" ]; then
 [ -f "$UP/.htaccess" ] && grep -q 'Require all denied' "$UP/.htaccess" && ok 'uploads deny rule exists' || warn 'uploads deny rule not detected'
 find "$UP" -type f \( -iname '*.php' -o -iname '*.phtml' -o -iname '*.phar' \) -print -quit | grep -q . && fail 'PHP file found in uploads' || ok 'No PHP-family files in uploads'
else warn 'uploads directory missing'; fi
echo "Summary: PASS=$PASS WARN=$WARN FAIL=$FAIL"
[ "$FAIL" -eq 0 ] || exit 1
