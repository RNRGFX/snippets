# Makefile for installing Affinity Suite v2 on Linux (Ubuntu) using Wine
# Important Considerations & Caveats:

# Wine & Winetricks: This Makefile assumes you have wine (preferably a recent stable or staging version) and winetricks installed on your Ubuntu system. You can usually install them with "sudo apt update && sudo apt install wine winetricks".
# Dependencies: The specific winetricks dependencies might change slightly between Affinity versions or based on your system configuration. The ones included (dotnet48, corefonts, d3dcompiler_47, vcrun2022) are common requirements found in guides for V2, but you might need to adjust them based on the exact forum/GitHub guide recommendations or if you encounter issues.
# Installer Files: You must download the .exe installer files for Affinity Photo v2, Designer v2, and Publisher v2 from your Affinity account first.
# Interactivity: The Wine installer process will likely still require you to click through the graphical installation steps for each application. This Makefile automates the setup and launching of the installers within the correct Wine environment.
# Desktop Integration: This Makefile focuses on installation. Creating .desktop files for easy launching from your application menu is a separate step, often involving creating small shell scripts that set the WINEPREFIX before running the application's .exe. The GitHub guide likely contains examples of this.
# Graphics Drivers: Ensure you have appropriate graphics drivers installed for your hardware, as this heavily impacts Wine performance, especially for graphics applications.
# Root Permissions: This Makefile does not require root permissions (sudo) for its core operations, as it installs everything within the user's home directory.

# --- User Configuration ---
# !!! IMPORTANT: You MUST override these variables when running make !!!
# Example: make install USERNAME=youruser PHOTO_INSTALLER=/path/to/photo.exe ...

USERNAME ?= $(error Please specify USERNAME, e.g., make install USERNAME=myuser)
PHOTO_INSTALLER ?= $(error Please specify PHOTO_INSTALLER=/path/to/affinity-photo-2.x.x.exe)
DESIGNER_INSTALLER ?= $(error Please specify DESIGNER_INSTALLER=/path/to/affinity-designer-2.x.x.exe)
PUBLISHER_INSTALLER ?= $(error Please specify PUBLISHER_INSTALLER=/path/to/affinity-publisher-2.x.x.exe)

# --- Internal Configuration ---
# Define the Wine prefix location. Using .local/share is often preferred.
WINEPREFIX_BASE := /home/$(USERNAME)/.local/share/wineprefixes
WINEPREFIX := $(WINEPREFIX_BASE)/affinity_v2
WINEDEBUG := -all # Disable excessive wine debug logging during install

# Winetricks dependencies - Adjust if needed based on guides/experience
# Common dependencies for Affinity v2 often include dotnet, corefonts, vcrun, d3dcompiler
WINETRICKS_DEPS := dotnet48 corefonts d3dcompiler_47 vcrun2022

# Phony targets don't represent files
.PHONY: all install setup_prefix install_photo install_designer install_publisher check_deps clean help

# Default target
all: install

# Main installation target
install: check_deps setup_prefix install_photo install_designer install_publisher
	@echo "------------------------------------------------------------"
	@echo " Affinity Suite Installation Process Initiated."
	@echo " Follow the on-screen prompts for each installer."
	@echo " Installation path inside Wine:"
	@echo "   $(WINEPREFIX)/drive_c/Program Files/Affinity/"
	@echo "------------------------------------------------------------"
	@echo "Installation complete. You may need to create desktop launchers manually."
	@echo "See guides for details on launching the applications, e.g.:"
	@echo "WINEPREFIX=$(WINEPREFIX) wine '$(WINEPREFIX)/drive_c/Program Files/Affinity/Photo 2/Photo.exe'"
	@echo "------------------------------------------------------------"

# Target to check for required tools
check_deps:
	@command -v wine >/dev/null 2>&1 || { echo >&2 "Error: 'wine' command not found. Please install Wine."; exit 1; }
	@command -v winetricks >/dev/null 2>&1 || { echo >&2 "Error: 'winetricks' command not found. Please install Winetricks."; exit 1; }
	@echo "Wine and Winetricks found."

# Target to create and prepare the Wine prefix
setup_prefix: check_deps
	@echo "Setting up Wine prefix at $(WINEPREFIX)..."
	@if [ ! -d "$(WINEPREFIX)" ]; then \
		echo "Creating 64-bit Wine prefix..."; \
		mkdir -p $(WINEPREFIX_BASE); \
		WINEARCH=win64 WINEPREFIX=$(WINEPREFIX) wineboot -u; \
		echo "Installing Winetricks dependencies: $(WINETRICKS_DEPS)..."; \
		WINEPREFIX=$(WINEPREFIX) winetricks -q $(WINETRICKS_DEPS); \
		echo "Wine prefix setup complete."; \
	else \
		echo "Wine prefix already exists. Skipping creation."; \
		echo "Consider running 'make clean' first if you want a fresh setup."; \
		echo "Attempting to install dependencies (if not already present)..."; \
		WINEPREFIX=$(WINEPREFIX) winetricks -q $(WINETRICKS_DEPS); \
	fi

# Target to install Affinity Photo
install_photo: setup_prefix
	@echo "------------------------------------------------------------"
	@echo "Starting Affinity Photo v2 installation..."
	@if [ ! -f "$(PHOTO_INSTALLER)" ]; then \
		echo >&2 "Error: Photo installer not found at $(PHOTO_INSTALLER)"; exit 1; \
	fi
	WINEDEBUG=$(WINEDEBUG) WINEPREFIX=$(WINEPREFIX) wine $(PHOTO_INSTALLER)
	@echo "Affinity Photo v2 installation process finished."
	@echo "------------------------------------------------------------"

# Target to install Affinity Designer
install_designer: setup_prefix
	@echo "------------------------------------------------------------"
	@echo "Starting Affinity Designer v2 installation..."
	@if [ ! -f "$(DESIGNER_INSTALLER)" ]; then \
		echo >&2 "Error: Designer installer not found at $(DESIGNER_INSTALLER)"; exit 1; \
	fi
	WINEDEBUG=$(WINEDEBUG) WINEPREFIX=$(WINEPREFIX) wine $(DESIGNER_INSTALLER)
	@echo "Affinity Designer v2 installation process finished."
	@echo "------------------------------------------------------------"

# Target to install Affinity Publisher
install_publisher: setup_prefix
	@echo "------------------------------------------------------------"
	@echo "Starting Affinity Publisher v2 installation..."
	@if [ ! -f "$(PUBLISHER_INSTALLER)" ]; then \
		echo >&2 "Error: Publisher installer not found at $(PUBLISHER_INSTALLER)"; exit 1; \
	fi
	WINEDEBUG=$(WINEDEBUG) WINEPREFIX=$(WINEPREFIX) wine $(PUBLISHER_INSTALLER)
	@echo "Affinity Publisher v2 installation process finished."
	@echo "------------------------------------------------------------"


# Target to clean the Wine prefix
clean:
	@echo "WARNING: This will permanently delete the Affinity Wine prefix!"
	@echo "Prefix location: $(WINEPREFIX)"
	@read -p "Are you sure? (y/N) " choice; \
	if [ "$${choice}" = "y" ] || [ "$${choice}" = "Y" ]; then \
		echo "Removing $(WINEPREFIX)..."; \
		rm -rf $(WINEPREFIX); \
		echo "Clean complete."; \
	else \
		echo "Clean cancelled."; \
	fi

# Help target
help:
	@echo "Makefile for installing Affinity Suite v2 via Wine"
	@echo ""
	@echo "Usage: make [target] [VARIABLES]"
	@echo ""
	@echo "Targets:"
	@echo "  all                 (Default) Checks dependencies, sets up prefix, installs all apps."
	@echo "  install             Alias for 'all'."
	@echo "  setup_prefix        Creates the Wine prefix and installs Winetricks dependencies."
	@echo "  install_photo       Installs only Affinity Photo."
	@echo "  install_designer    Installs only Affinity Designer."
	@echo "  install_publisher   Installs only Affinity Publisher."
	@echo "  check_deps          Checks if Wine and Winetricks are installed."
	@echo "  clean               Removes the Wine prefix ($(WINEPREFIX))."
	@echo "  help                Shows this help message."
	@echo ""
	@echo "Required Variables:"
	@echo "  USERNAME=<your_linux_username>"
	@echo "      Your username on the system."
	@echo "  PHOTO_INSTALLER=<path/to/affinity-photo-2.x.x.exe>"
	@echo "      Full path to the Affinity Photo v2 installer."
	@echo "  DESIGNER_INSTALLER=<path/to/affinity-designer-2.x.x.exe>"
	@echo "      Full path to the Affinity Designer v2 installer."
	@echo "  PUBLISHER_INSTALLER=<path/to/affinity-publisher-2.x.x.exe>"
	@echo "      Full path to the Affinity Publisher v2 installer."
	@echo ""
	@echo "Example:"
	@echo "  make install USERNAME=myuser \\"
	@echo "    PHOTO_INSTALLER=/home/myuser/Downloads/affinity-photo-2.5.0.exe \\"
	@echo "    DESIGNER_INSTALLER=/home/myuser/Downloads/affinity-designer-2.5.0.exe \\"
	@echo "    PUBLISHER_INSTALLER=/home/myuser/Downloads/affinity-publisher-2.5.0.exe"
	@echo ""
	@echo "To clean up:"
	@echo "  make clean USERNAME=myuser"
	@echo ""
