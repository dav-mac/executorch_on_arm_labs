#!/usr/bin/env bash
set -euo pipefail

# venv-set (external) -------------------------------------------------------
# Usage:
#   ./venv-set /path/to/venv /path/to/executorch
# OR
#   VENV_PATH=/path/to/venv REPO_PATH=/path/to/executorch ./venv-set
#
# Defaults (if not provided):
#   VENV_PATH = ./NPU_lab-venv         (relative to the script's cwd)
#   REPO_PATH = ./executorch           (relative to the script's cwd)
# -------------------------------------------------------------------------

# Resolve CLI args / env vars with defaults
SCRIPT_CWD="$(pwd)"
VENV_PATH="${1:-${VENV_PATH:-${SCRIPT_CWD}/NPU_lab-venv}}"
REPO_PATH="${2:-${REPO_PATH:-${SCRIPT_CWD}/executorch}}"

SETUP_SCRIPT_REL="./examples/arm/setup.sh"
EULA_FLAG="--i-agree-to-the-contained-eula"

echo "venv-set starting..."
echo "Virtualenv path: ${VENV_PATH}"
echo "ExecuTorch repo path: ${REPO_PATH}"
echo

# Basic checks
if [ ! -d "${VENV_PATH}" ]; then
  echo "Error: virtual environment not found at: ${VENV_PATH}"
  echo "Create it first, e.g.:"
  echo "  PYTHON=\"\$(pyenv which python)\""
  echo "  \"\${PYTHON}\" -m venv \"${VENV_PATH}\""
  exit 2
fi

if [ ! -d "${REPO_PATH}" ]; then
  echo "Error: ExecuTorch repo not found at: ${REPO_PATH}"
  echo "Clone it first, e.g.: git clone https://github.com/pytorch/executorch.git ${REPO_PATH}"
  exit 3
fi

# Activate external venv
# shellcheck disable=SC1090
source "${VENV_PATH}/bin/activate"
echo "Activated venv: ${VENV_PATH}"
echo "Python: $(which python) ($(python --version 2>&1))"
echo "Pip: $(which pip) ($(pip --version 2>&1))"
echo

# Move into repo and sanity-check
cd "${REPO_PATH}"
if [ ! -f "setup.py" ] && [ ! -f "pyproject.toml" ] && [ ! -d ".git" ]; then
  echo "Error: ${REPO_PATH} does not look like the executorch repo (no setup.py/pyproject.toml/.git)."
  exit 4
fi

# Update git submodules (may take a while)
echo "Updating git submodules (if any)..."
git submodule update --init --recursive

# Ensure the target setup script exists
if [ ! -f "${SETUP_SCRIPT_REL}" ]; then
  echo "Error: expected setup script not found at ${REPO_PATH}/${SETUP_SCRIPT_REL}"
  exit 5
fi

# Make the setup script executable and run it
chmod +x "${SETUP_SCRIPT_REL}"
echo
echo "Running Ethos-U example setup: ${SETUP_SCRIPT_REL} ${EULA_FLAG}"
if ! ./"${SETUP_SCRIPT_REL#./}" "${EULA_FLAG}"; then
  echo
  echo "Error: ${SETUP_SCRIPT_REL} failed. Check output above for details."
  exit 6
fi

# Install ExecuTorch via pip (non-editable)
echo
echo "Installing ExecuTorch via pip (package name: executorch)..."
if ! pip install executorch; then
  echo
  echo "ERROR: pip install failed."
  echo "Common causes and fixes:"
  echo "  * This venv was created from a distro-managed Python and pip is blocked by PEP 668."
  echo "    -> Recreate the venv using a pyenv-built Python (recommended):"
  echo "       pyenv install -s 3.11.14"
  echo "       PYTHON=\"\$(pyenv which python)\""
  echo "       \"\${PYTHON}\" -m venv \"${VENV_PATH}\""
  echo "  * Missing build tools for compiled dependencies (install build deps via apt)."
  echo
  echo "If you must override the distro guard (not recommended):"
  echo "  pip install --break-system-packages executorch"
  exit 7
fi

if ! pip install torchvision; then

    echo 
    echo "Error: pip install failed"
fi 

if ! pip install ai-edge-model-explorer; then 
    echo 
    echo "Pip error"
fi

if ! pip install cmake; then
  echo 
  echo "pip cmake error"
fi 


echo
echo "Success ✅"
echo "ExecuTorch setup script ran and pip install executorch completed."
echo
echo "To reactivate the venv later:"
echo "  source \"${VENV_PATH}/bin/activate\""
echo "To work in repo:"
echo "  cd \"${REPO_PATH}\""
source deactivate
