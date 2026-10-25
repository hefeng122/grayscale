.PHONY: app package clean

# Computed with $(abspath $(dir $(lastword $(MAKEFILE_LIST)))) instead of
# $(shell dirname $(realpath ...)): make word-splits function arguments on
# spaces, so a repository path containing spaces (a very common macOS
# location) used to resolve to a corrupted directory. The makefile's own base
# name has no spaces, so $(dir ...) yields "./" and $(abspath) expands it
# cleanly, with the space only appearing in the final result.
MAKEFILE_DIR:="$(abspath $(dir $(lastword $(MAKEFILE_LIST))))"

# puts the app in $(MAKEFILE_DIR)/build/Build/Products/Release/name.app
app:
	pushd $(MAKEFILE_DIR); xcodebuild -project grayscale.xcodeproj -scheme grayscale -configuration Release -derivedDataPath build; popd

BUILT_APP_PATH:=$(MAKEFILE_DIR)/build/Build/Products/Release/grayscale.app

# builds the app first, then packages it as a .pkg installer and a .zip
# (the .zip is what the homebrew casks and GitHub releases use)
package: app
	# productbuild: --component <app> <install-dir> <output.pkg>
	productbuild --component $(BUILT_APP_PATH) /Applications $(MAKEFILE_DIR)/build/GrayscaleInstaller.pkg
	# ditto: zip the app bundle, preserving resource forks and the parent directory
	ditto -c -k --sequesterRsrc --keepParent $(BUILT_APP_PATH) $(MAKEFILE_DIR)/build/grayscale.app.zip

clean:
	rm -rf $(MAKEFILE_DIR)/build
