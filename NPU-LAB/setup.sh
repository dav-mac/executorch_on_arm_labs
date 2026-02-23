#!/usr/bin/env bash
set -euo pipefail

# Config: change these if you want different names/locations
PYTHON_VERSION="3.11.14"
VENV_NAME="NPU_lab-venv"     # will be created at ./NPU_lab-venv
REPO_URL="https://github.com/pytorch/executorch.git"
REPO_DIR="repo"              # will be cloned to ./repo

echo "Working directory: $(pwd)"
echo "Venv path: ./${VENV_NAME}"
echo "Repo path: ./${REPO_DIR}"
echo

# Optional: install OS build deps required for building Python (safe to run)
echo "1) Installing build dependencies (may ask for sudo password)..."
sudo apt update
sudo apt install -y make build-essential libssl-dev zlib1g-dev \
  libbz2-dev libreadline-dev libsqlite3-dev curl git \
  libncursesw5-dev xz-utils tk-dev libxml2-dev libxmlsec1-dev \
  libffi-dev liblzma-dev

# Install pyenv if missing
if [ ! -d "${HOME}/.pyenv" ]; then
  echo
  echo "2) Installing pyenv..."
  curl https://pyenv.run | bash
else
  echo
  echo "2) pyenv already installed — skipping install."
fi

# Make pyenv available in this script
export PYENV_ROOT="${HOME}/.pyenv"
export PATH="${PYENV_ROOT}/bin:${PATH}"

# Initialize pyenv for non-interactive shell usage
eval "$(pyenv init --path)"
eval "$(pyenv init -)"

# Sanity check
if ! command -v pyenv >/dev/null 2>&1; then
  echo "ERROR: pyenv not found in PATH after install. Ensure ~/.pyenv is available."
  exit 1
fi
echo "pyenv: $(pyenv --version)"

# Install the desired Python version (idempotent)
echo
echo "3) Installing Python ${PYTHON_VERSION} (pyenv)..."
pyenv install -s "${PYTHON_VERSION}"
pyenv rehash

PYENV_PYTHON="$(pyenv which python)"
echo "Using interpreter: ${PYENV_PYTHON}"
echo "Interpreter version: $(${PYENV_PYTHON} --version)"

# Create venv in current working directory using the pyenv-managed interpreter
VENV_PATH="./${VENV_NAME}"
if [ -d "${VENV_PATH}" ]; then
  echo
  echo "4) Virtualenv already exists at ${VENV_PATH} — skipping creation."
else
  echo
  echo "4) Creating virtualenv at ${VENV_PATH} using ${PYENV_PYTHON}..."
  "${PYENV_PYTHON}" -m venv "${VENV_PATH}"
  echo "Created venv: ${VENV_PATH}"
fi

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
echo "  cd ${REPO_DIR}                      # go into the repo"
echo "  source ../${VENV_NAME}/bin/activate # activate the venv (venv is one dir above repo if you cd in)"
echo
echo "If you'd like pyenv available in new shells, add to your ~/.bashrc or ~/.profile:"
echo '  export PYENV_ROOT="$HOME/.pyenv"'
echo '  export PATH="$PYENV_ROOT/bin:$PATH"'
echo '  eval "$(pyenv init --path)"'
echo '  eval "$(pyenv init -)"'