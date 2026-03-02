#!/usr/bin/env bash
set -euo pipefail

PYTHON_VERSION="3.11.14"

# Two identical venvs with different names
NPU_VENV_NAME="NPU_lab_venv"     # will be created at ./NPU_lab_venv
CPU_VENV_NAME="CPU_lab_venv"     # will be created at ./CPU_lab_venv

REPO_URL="https://github.com/pytorch/executorch.git"
REPO_DIR="NPU_Lab_ExecuTorch/executorch"

echo "Working directory: $(pwd)"
echo "NPU venv path: ./${NPU_VENV_NAME}"
echo "CPU venv path: ./${CPU_VENV_NAME}"
echo "Repo path: ./${REPO_DIR}"
echo

OS="$(uname -s)"
echo "Detected OS: ${OS}"
echo

have_cmd() { command -v "$1" >/dev/null 2>&1; }

SUDO=""
if have_cmd sudo; then SUDO="sudo"; fi

ram_mb() {
  # Linux: MemTotal in kB. macOS: sysctl bytes.
  if [ "$(uname -s)" = "Linux" ]; then
    awk '/MemTotal/ {print int($2/1024)}' /proc/meminfo
  else
    # bytes -> MB
    python3 - <<'PY' 2>/dev/null || echo 8192
import os, subprocess
out = subprocess.check_output(["sysctl","-n","hw.memsize"]).decode().strip()
print(int(int(out)/(1024*1024)))
PY
  fi
}

ensure_tmpdir() {
  # Avoid tiny/tmpfs /tmp on Pi; build in $HOME
  export TMPDIR="${HOME}/pyenv-tmp"
  mkdir -p "$TMPDIR"
}

ensure_linux_swap_if_low_ram() {
  # Only for Linux. Helps a LOT for pyenv builds on small RAM.
  [ "$(uname -s)" = "Linux" ] || return 0

  local mb
  mb="$(ram_mb)"
  echo "Detected RAM: ${mb} MB"

  # If < 3500MB, we’ll add a swapfile if none exists / swap is tiny.
  if [ "${mb}" -lt 3500 ]; then
    echo "Low-RAM Linux detected; ensuring swap for pyenv build..."

    # If already has swap, don't fight it—just report.
    if [ -r /proc/swaps ] && awk 'NR>1 {found=1} END{exit !found}' /proc/swaps; then
      echo "Swap already configured:"
      cat /proc/swaps || true
      return 0
    fi

    # Try dphys-swapfile first (common on Raspberry Pi OS)
    if have_cmd dphys-swapfile; then
      echo "Using dphys-swapfile to enable swap (4096MB)..."
      $SUDO dphys-swapfile swapoff || true
      $SUDO sed -i 's/^CONF_SWAPSIZE=.*/CONF_SWAPSIZE=4096/' /etc/dphys-swapfile
      $SUDO dphys-swapfile setup
      $SUDO dphys-swapfile swapon
      return 0
    fi

    # Fallback: create a swapfile
    echo "Creating /swapfile (4096MB)..."
    $SUDO fallocate -l 4G /swapfile 2>/dev/null || $SUDO dd if=/dev/zero of=/swapfile bs=1M count=4096
    $SUDO chmod 600 /swapfile
    $SUDO mkswap /swapfile
    $SUDO swapon /swapfile
    echo "/swapfile none swap sw 0 0" | $SUDO tee -a /etc/fstab >/dev/null || true
  fi
}

pyenv_install_with_diagnostics() {
  local version="$1"

  ensure_tmpdir
  ensure_linux_swap_if_low_ram

  # Conservative defaults; safe everywhere.
  export MAKEOPTS="-j1"
  export PYTHON_BUILD_MAKE_OPTS="-j1"
  export PYTHON_BUILD_MAX_JOBS=1

  echo "Diagnostics:"
  echo "  Arch: $(uname -m)"
  echo "  TMPDIR: ${TMPDIR}"
  if have_cmd free; then free -h || true; fi
  df -h . "${TMPDIR}" /tmp 2>/dev/null || true

  echo
  echo "3) Installing Python ${version} (pyenv)..."
  if ! pyenv install -s "${version}"; then
    echo
    echo "pyenv install failed. Showing latest python-build log tail:"
    local log
    log="$(ls -t /tmp/python-build.*.log 2>/dev/null | head -n 1 || true)"
    if [ -n "${log}" ]; then
      echo "---- ${log} (tail -n 160) ----"
      tail -n 160 "${log}" || true
    else
      echo "No /tmp/python-build.*.log found."
    fi
    return 1
  fi

  pyenv rehash
}

install_deps_macos() {
  echo "1) Installing build dependencies (macOS)..."

  if ! xcode-select -p >/dev/null 2>&1; then
    echo "Xcode Command Line Tools not found. Installing..."
    xcode-select --install || true
    echo "If a GUI prompt appeared, finish that install then re-run this script."
    exit 1
  fi

  # Homebrew
  if ! command -v brew >/dev/null 2>&1; then
    echo "Homebrew not found. Installing Homebrew..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  else
    echo "Homebrew already installed — skipping."
  fi

  # Ensure brew is on PATH in non-interactive shells
  if [ -x "/opt/homebrew/bin/brew" ]; then
    eval "$(/opt/homebrew/bin/brew shellenv)"
  elif [ -x "/usr/local/bin/brew" ]; then
    eval "$(/usr/local/bin/brew shellenv)"
  fi

  brew update
  brew install openssl readline sqlite3 xz zlib tcl-tk libffi git curl wget pyenv
}

install_deps_linux_apt() {
  echo "1) Installing build dependencies (Linux/apt)..."
  sudo apt update
  sudo apt install -y \
    make build-essential \
    libssl-dev zlib1g-dev \
    libbz2-dev libreadline-dev libsqlite3-dev \
    curl wget git \
    libncurses5-dev libncursesw5-dev \
    xz-utils tk-dev \
    libxml2-dev libxmlsec1-dev \
    libffi-dev liblzma-dev \
    libgdbm-dev libgdbm-compat-dev \
    uuid-dev libnss3-dev
}

install_pyenv_linux_if_missing() {
  # On macOS we install pyenv via brew above; on Linux we use pyenv.run
  if [ ! -d "${HOME}/.pyenv" ]; then
    echo
    echo "2) Installing pyenv (Linux)..."
    curl -fsSL https://pyenv.run | bash
  else
    echo
    echo "2) pyenv already installed — skipping install."
  fi
}

# --- OS branching ---
case "${OS}" in
  Darwin)
    install_deps_macos
    ;;
  Linux)
    install_deps_linux_apt
    install_pyenv_linux_if_missing
    ;;
  *)
    echo "ERROR: Unsupported OS: ${OS}"
    echo "This script supports macOS (Darwin) and apt-based Linux."
    exit 1
    ;;
esac

# --- pyenv env setup (both platforms) ---
export PYENV_ROOT="${HOME}/.pyenv"
export PATH="${PYENV_ROOT}/bin:${PATH}"

eval "$(pyenv init --path)"
eval "$(pyenv init -)"

if ! command -v pyenv >/dev/null 2>&1; then
  echo "ERROR: pyenv not found in PATH after install."
  exit 1
fi
echo
echo "pyenv: $(pyenv --version)"

# Install the desired Python version (idempotent)
echo
echo "3) Installing Python ${PYTHON_VERSION} (pyenv)..."
pyenv install -s "${PYTHON_VERSION}"
pyenv rehash

# Ensure we use *this* Python version explicitly
PYENV_PYTHON="${PYENV_ROOT}/versions/${PYTHON_VERSION}/bin/python"
if [ ! -x "${PYENV_PYTHON}" ]; then
  echo "ERROR: Expected interpreter not found at ${PYENV_PYTHON}"
  exit 1
fi

echo "Using interpreter: ${PYENV_PYTHON}"
echo "Interpreter version: $(${PYENV_PYTHON} --version)"

create_venv_and_kernel() {
  local venv_name="$1"        
  local kernel_name="$2"      
  local display_name="$3"     

  local venv_path="./${venv_name}"
  local venv_python="${venv_path}/bin/python"

  echo
  echo "4) Ensuring virtualenv exists at ${venv_path}..."
  if [ -d "${venv_path}" ]; then
    echo "   Virtualenv already exists — skipping creation."
  else
    echo "   Creating virtualenv using ${PYENV_PYTHON}..."
    "${PYENV_PYTHON}" -m venv "${venv_path}"
    echo "   Created venv: ${venv_path}"
  fi

  echo "   Venv interpreter: $(${venv_python} --version)"

  echo "   Installing / upgrading pip + ipykernel in ${venv_name}..."
  "${venv_python}" -m pip install -U pip setuptools wheel
  "${venv_python}" -m pip install -U ipykernel jupyter
  "${venv_python}" -m pip install -U huggingface_hub

  echo "   Registering Jupyter kernel: ${display_name} (${kernel_name})"
  # This is idempotent: re-running updates the kernel spec.
  "${venv_python}" -m ipykernel install --user \
    --name "${kernel_name}" \
    --display-name "${display_name}"
}

# Create both identical venvs + kernels
create_venv_and_kernel "${NPU_VENV_NAME}" "npu_lab_venv" "Python (${NPU_VENV_NAME})"
create_venv_and_kernel "${CPU_VENV_NAME}" "cpu_lab_venv" "Python (${CPU_VENV_NAME})"

# Clone the executorch repo if missing
if [ -d "${REPO_DIR}" ]; then
  echo
  echo "5) Repo ${REPO_DIR} already exists — skipping clone."
else
  echo
  echo "5) Cloning ExecuTorch into ./${REPO_DIR} ..."
  git clone "${REPO_URL}" "${REPO_DIR}"
fi

echo
echo "Setup complete ✅"
echo
echo "Next steps:"
echo "  cd ${REPO_DIR}"
echo "  source ../${NPU_VENV_NAME}/bin/activate   # or ../${CPU_VENV_NAME}/bin/activate"
echo
echo "Jupyter kernels installed:"
echo "  - Python (${NPU_VENV_NAME})  [kernel: npu_lab_venv]"
echo "  - Python (${CPU_VENV_NAME})  [kernel: cpu_lab_venv]"
echo
echo "To make pyenv available in new shells:"
echo "  macOS (zsh): add to ~/.zshrc"
echo "  Linux (bash): add to ~/.bashrc or ~/.profile"
echo '  export PYENV_ROOT="$HOME/.pyenv"'
echo '  export PATH="$PYENV_ROOT/bin:$PATH"'
echo '  eval "$(pyenv init --path)"'
echo '  eval "$(pyenv init -)"'