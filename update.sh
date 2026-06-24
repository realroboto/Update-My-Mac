#!/bin/sh
#
# Update My Mac — script pessoal de manutenção do macOS.
#
# Executado via (SEM sudo — ver README.md):
#   sh -c 'sh -c "$(curl -sL https://raw.githubusercontent.com/realroboto/Update-My-Mac/main/update.sh)"'
#
# POSIX sh: roda sob /bin/sh quando vindo do curl. Sem bashisms.
# Best-effort: cada passo loga e continua mesmo se falhar (não usa `set -e`),
# espelhando o comportamento original onde tweaks/restart sempre rodavam.

set -u

log()  { printf '\033[1;34m==>\033[0m %s\n' "$1"; }
warn() { printf '\033[1;33m[!]\033[0m %s\n'  "$1" >&2; }

# --- Pré-requisitos --------------------------------------------------------

command -v brew >/dev/null 2>&1 || {
	warn "Homebrew não encontrado. Abortando."
	exit 1
}

# --- Operações privilegiadas (UMA única autenticação sudo) -----------------
#
# Todo comando que precisa de root roda aqui, numa só invocação de `sudo sh
# -c`. Uma invocação = um único prompt de senha/Touch ID, independente do
# `timestamp_timeout` do sudoers (não depende de cache nem de keepalive).
# Nada aqui depende do brew nem da ordem, então rodar no início é seguro.
# Se for habilitar algo do catálogo opcional que precise de root
# (softwareupdate, scutil, rm do QuickLook), coloque dentro deste bloco
# para continuar com um prompt só.
log "Tarefas administrativas (pede sudo uma única vez)…"
sudo sh -c '
	purge                       || echo "[!] purge falhou" >&2
	ifconfig awdl0 down         || echo "[!] ifconfig awdl0 falhou" >&2
	dscacheutil -flushcache     || echo "[!] flushcache falhou" >&2
	killall -HUP mDNSResponder  || echo "[!] reload do mDNSResponder falhou" >&2
' || { warn "sudo necessário / bloco administrativo falhou. Abortando."; exit 1; }

# --- Homebrew --------------------------------------------------------------

brew analytics off || true

log "Atualizando catálogo do Homebrew…"
brew update || warn "brew update falhou"

log "Atualizando fórmulas e casks (--greedy: inclui auto_updates / :latest)…"
brew upgrade --greedy || warn "brew upgrade falhou"

log "Removendo dependências órfãs…"
brew autoremove || warn "brew autoremove falhou"

log "Limpando cache e versões antigas (-s --prune=all)…"
brew cleanup -s --prune=all || warn "brew cleanup falhou"

log "Reparando taps…"
brew tap --repair || warn "brew tap --repair falhou"

#brew doctor || true   # diagnóstico opcional (não interrompe a execução)

# (purge / AWDL / flush de DNS rodaram no bloco privilegiado lá em cima.)

# --- Catálogo opcional (desabilitado por padrão) ---------------------------
# Convenção do projeto: "disable, don't delete". Descomente o que quiser.

# Limpa SSH known_hosts. ATENÇÃO: downgrade de segurança — remove a
# detecção de MITM em hosts já confiados. Num Mac recém-formatado o
# arquivo já está vazio de qualquer forma.
#: > "$HOME/.ssh/known_hosts"

# Atualizações de sistema do macOS (reinicia ao final).
#sudo softwareupdate -i -a -R --agree-to-license --verbose

# Identidade da máquina.
#sudo scutil --set ComputerName M1
#sudo scutil --set LocalHostName M1

# Cache de miniaturas do QuickLook.
#QL="$(getconf DARWIN_USER_CACHE_DIR)/com.apple.QuickLook.thumbnailcache"
#sudo rm -rfv "$QL/thumbnails.fraghandler"
#sudo rm -rfv "$QL/exclusive"
#sudo rm -rfv "$QL/index.sqlite"
#sudo rm -rfv "$QL/index.sqlite-shm"
#sudo rm -rfv "$QL/index.sqlite-wal"
#sudo rm -rfv "$QL/resetreason"
#sudo rm -rfv "$QL/thumbnails.data"

# --- Preferências do macOS -------------------------------------------------

#log "Aplicando preferências do sistema…"
#defaults write com.apple.screensaver askForPassword -int 1
#defaults write com.apple.screensaver askForPasswordDelay -int 0
#defaults write com.apple.finder AppleShowAllFiles -bool true
#chflags nohidden "$HOME/Library"
#defaults write NSGlobalDomain AppleShowAllExtensions -bool true

# Dock — timing de auto-hide.
#defaults write com.apple.dock autohide-delay -float 0
#defaults write com.apple.dock autohide-time-modifier -float 0.5

# Tweaks de performance (catálogo opcional, desabilitado):
# Desabilita o controle de AutoFill que causa lag
#defaults write -g NSAutoFillHeuristicControllerEnabled -bool false
# Desabilita shadow rendering que causa alto uso de GPU
#launchctl setenv CHROME_HEADLESS 1
# Acelerar animações do Finder
#defaults write com.apple.finder DisableAllAnimations -bool true
# Desabilita animações
#defaults write NSGlobalDomain NSAutomaticWindowAnimationsEnabled -bool false
#defaults write NSGlobalDomain NSWindowResizeTime -float 0.001

# --- Reinicia serviços de UI para aplicar ----------------------------------

#log "Reiniciando Finder / Dock / SystemUIServer…"
#killall Finder         2>/dev/null || true
#killall Dock           2>/dev/null || true
#killall SystemUIServer 2>/dev/null || true

log "Concluído."
