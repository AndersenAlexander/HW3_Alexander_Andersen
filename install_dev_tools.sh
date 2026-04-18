#!/bin/bash
# Exit immediately if a command exits with a non-zero status
set -e

# --- Environment Setup ---
# Prevent apt-get from opening interactive prompts
export DEBIAN_FRONTEND=noninteractive

# --- Colors for output ---
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

function print_info() {
    echo -e "\n${BLUE}===> $1${NC}"
}

function print_success() {
    echo -e "${GREEN}✓ $1${NC}"
}

function print_warning() {
    echo -e "${YELLOW}! $1${NC}"
}

print_info "Authenticating sudo privileges..."
sudo -v

print_info "Updating package index"
sudo apt-get update -y -qq

print_info "Checking and installing Docker"
if ! command -v docker >/dev/null 2>&1; then
  # Detect OS (ubuntu or debian) for the correct Docker repository
  . /etc/os-release
  OS_ID=$ID

  sudo apt-get install -y -qq ca-certificates curl gnupg lsb-release
  sudo mkdir -p /etc/apt/keyrings
  curl -fsSL "https://download.docker.com/linux/$OS_ID/gpg" | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg --yes
  echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/$OS_ID $(lsb_release -cs) stable" \
    | sudo tee /etc/apt/sources.list.d/docker.list >/dev/null
    
  sudo apt-get update -y -qq
  sudo apt-get install -y -qq docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
  print_success "Docker has been successfully installed"
else
  print_warning "Docker is already installed"
fi

print_info "Checking and installing Docker Compose"
if command -v docker >/dev/null 2>&1 && docker compose version >/dev/null 2>&1; then
  print_warning "Docker Compose (v2) is already installed"
elif command -v docker-compose >/dev/null 2>&1; then
  print_warning "Docker Compose (v1) is already installed"
else
  sudo apt-get install -y -qq docker-compose-plugin || sudo apt-get install -y -qq docker-compose
  print_success "Docker Compose has been successfully installed"
fi

print_info "Checking and installing Python (>= 3.9)"
if ! command -v python3 >/dev/null 2>&1; then
  sudo apt-get install -y -qq python3 python3-pip
  print_success "Python has been installed"
else
  print_warning "Python is already installed"
  # Ensure pip3 is installed even if python3 was already there
  command -v pip3 >/dev/null 2>&1 || sudo apt-get install -y -qq python3-pip
fi

# Verify and print Python version to meet homework criteria
PY_VERSION=$(python3 -c 'import sys; print(f"{sys.version_info.major}.{sys.version_info.minor}")')
print_success "Current Python version: $PY_VERSION"

print_info "Checking and installing Django"
if ! python3 -m django --version >/dev/null 2>&1; then
  # Install for current user; if the script is run via sudo —
  # perform the installation on behalf of the real user
  RUN_AS="${SUDO_USER:-$USER}"
  sudo -u "$RUN_AS" pip3 install --user --quiet --break-system-packages "Django>=4"
  
  DJANGO_VERSION=$(sudo -u "$RUN_AS" python3 -m django --version)
  print_success "Django has been installed (user-site): $DJANGO_VERSION"
else
  print_warning "Django is already installed: $(python3 -m django --version)"
fi

echo -e "\n${GREEN}===========================================${NC}"
echo -e "${GREEN}✓ All DevOps tools are installed and ready!${NC}"
echo -e "${GREEN}===========================================${NC}\n"