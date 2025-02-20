# BeSman Script for Installing Garak and Security Tools

__besman_install() {
    echo "Installing Garak and required security tools..."
    sudo apt update
    sudo apt install -y python3 python3-pip docker.io git
    
    # Install Garak
    pip install garak
    
    # Setup SonarQube
    docker pull sonarqube
    docker run -d --name sonarqube -p 9000:9000 sonarqube
    
    # Install SPDX SBOM Generator
    pip install spdx-sbom-generator
    
    # Install Fossology
    docker pull fossology/fossology
    docker run -d --name fossology -p 8081:80 fossology/fossology
    
    # Install Criticality Score
    pip install criticality-score
    
    echo "Installation complete."
}

__besman_update() {
    echo "Updating Garak and security tools..."
    pip install --upgrade garak spdx-sbom-generator criticality-score
    docker pull sonarqube
    docker pull fossology/fossology
    echo "Update complete."
}

__besman_uninstall() {
    echo "Uninstalling Garak and security tools..."
    pip uninstall -y garak spdx-sbom-generator criticality-score
    docker stop sonarqube fossology
    docker rm sonarqube fossology
    echo "Uninstallation complete."
}

__besman_validate() {
    echo "Validating installation..."
    command -v garak >/dev/null 2>&1 && echo "Garak installed successfully." || echo "Garak not found."
    docker ps | grep sonarqube && echo "SonarQube is running." || echo "SonarQube is not running."
    docker ps | grep fossology && echo "Fossology is running." || echo "Fossology is not running."
    command -v spdx-sbom-generator >/dev/null 2>&1 && echo "SPDX SBOM Generator installed." || echo "SPDX SBOM Generator not found."
    command -v criticality-score >/dev/null 2>&1 && echo "Criticality Score installed." || echo "Criticality Score not found."
    echo "Validation complete."
}

__besman_reset() {
    echo "Resetting Garak and security tools to initial state..."
    __besman_uninstall
    __besman_install
    echo "Reset complete."
}
