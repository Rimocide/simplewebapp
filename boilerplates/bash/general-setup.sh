#!/bin/bash
# ============================================
# GENERAL PURPOSE DEVOPS SCRIPT
# ============================================
set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

log() { echo -e "${GREEN}[INFO]${NC} $1"; }
warn() { echo -e "${YELLOW}[WARN]${NC} $1"; }
error() { echo -e "${RED}[ERROR]${NC} $1"; exit 1; }

# -------- INSTALL DOCKER --------
install_docker() {
    log "Installing Docker..."
    yum update -y
    yum install -y docker
    systemctl start docker
    systemctl enable docker
    usermod -aG docker ec2-user
    log "Docker installed successfully"
}

# -------- INSTALL DOCKER COMPOSE --------
install_docker_compose() {
    log "Installing Docker Compose..."
    curl -L "https://github.com/docker/compose/releases/latest/download/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
    chmod +x /usr/local/bin/docker-compose
    ln -sf /usr/local/bin/docker-compose /usr/bin/docker-compose
    log "Docker Compose installed successfully"
}

# -------- CLONE REPO --------
clone_repo() {
    REPO_URL=$1
    DEST_DIR=${2:-/var/www/app}
    
    log "Cloning $REPO_URL to $DEST_DIR..."
    mkdir -p $(dirname $DEST_DIR)
    git clone $REPO_URL $DEST_DIR || (cd $DEST_DIR && git pull)
    log "Repository cloned successfully"
}

# -------- CREATE ENV FILE --------
create_env_file() {
    ENV_FILE=${1:-.env}
    log "Creating $ENV_FILE..."
    
    cat > $ENV_FILE << EOF
DB_HOST=${DB_HOST:-localhost}
DB_USER=${DB_USER:-admin}
DB_PASSWORD=${DB_PASSWORD:-password}
DB_NAME=${DB_NAME:-appdb}
NODE_ENV=${NODE_ENV:-production}
EOF
    log "Environment file created"
}

# -------- ECR LOGIN --------
ecr_login() {
    AWS_REGION=${1:-us-east-1}
    ECR_URL=$2
    
    log "Logging into ECR..."
    aws ecr get-login-password --region $AWS_REGION | docker login --username AWS --password-stdin $ECR_URL
    log "ECR login successful"
}

# -------- RUN DOCKER COMPOSE --------
run_compose() {
    COMPOSE_FILE=${1:-docker-compose.yml}
    
    log "Starting containers with $COMPOSE_FILE..."
    docker-compose -f $COMPOSE_FILE down || true
    docker-compose -f $COMPOSE_FILE up -d --build
    log "Containers started successfully"
}

# -------- CLEANUP --------
cleanup() {
    log "Cleaning up Docker resources..."
    docker system prune -af
    log "Cleanup complete"
}

# -------- MAIN --------
main() {
    case "$1" in
        install-docker)     install_docker ;;
        install-compose)    install_docker_compose ;;
        clone)              clone_repo "$2" "$3" ;;
        create-env)         create_env_file "$2" ;;
        ecr-login)          ecr_login "$2" "$3" ;;
        run)                run_compose "$2" ;;
        cleanup)            cleanup ;;
        full-setup)
            install_docker
            install_docker_compose
            clone_repo "$2" "$3"
            create_env_file
            run_compose
            ;;
        *)
            echo "Usage: $0 {install-docker|install-compose|clone|create-env|ecr-login|run|cleanup|full-setup}"
            echo ""
            echo "Examples:"
            echo "  $0 install-docker"
            echo "  $0 clone https://github.com/user/repo.git /var/www/app"
            echo "  $0 ecr-login us-east-1 123456.dkr.ecr.us-east-1.amazonaws.com"
            echo "  $0 run docker-compose.yml"
            echo "  $0 full-setup https://github.com/user/repo.git"
            exit 1
            ;;
    esac
}

main "$@"
