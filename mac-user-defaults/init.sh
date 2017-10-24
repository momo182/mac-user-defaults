#!/usr/bin/env bash

: ${1?"Usage: $0 NAME"}

echo "# ~/.osx — http://mths.be/osx"

echo "# Ask for the administrator password upfront"
sudo -v

echo "# Keep-alive: update existing `sudo` time stamp until `.osx` has finished"
while true; do sudo -n true; sleep 60; kill -0 "$$" || exit; done 2>/dev/null &

###############################################################################
# General UI/UX                                                               #
###############################################################################

echo "# Set computer name (as done via System Preferences → Sharing)"
sudo scutil --set ComputerName $1
sudo scutil --set HostName $1
sudo scutil --set LocalHostName $1
sudo defaults write /Library/Preferences/SystemConfiguration/com.apple.smb.server NetBIOSName -string $1

#echo "# Set standby delay to 24 hours (default is 1 hour)"
#sudo pmset -a standbydelay 86400

echo "# Disable the sound effects on boot"
sudo nvram SystemAudioVolume=" "

echo "# Menu bar: disable transparency"
defaults write NSGlobalDomain AppleEnableMenuBarTransparency -bool true

echo "# Menu bar: hide the Time Machine, Volume, User, and Bluetooth icons"
for domain in ~/Library/Preferences/ByHost/com.apple.systemuiserver.*; do
	defaults write "${domain}" dontAutoLoad -array \
		"/System/Library/CoreServices/Menu Extras/TimeMachine.menu" \
#		"/System/Library/CoreServices/Menu Extras/Volume.menu" \
#		"/System/Library/CoreServices/Menu Extras/User.menu"
done
defaults write com.apple.systemuiserver menuExtras -array \
	"/System/Library/CoreServices/Menu Extras/Bluetooth.menu" \
	"/System/Library/CoreServices/Menu Extras/AirPort.menu" \
	"/System/Library/CoreServices/Menu Extras/Battery.menu" \
	"/System/Library/CoreServices/Menu Extras/Clock.menu"

echo "# Set highlight color to green"
defaults write NSGlobalDomain AppleHighlightColor -string "0.764700 0.976500 0.568600"

echo "# Set sidebar icon size to medium"
defaults write NSGlobalDomain NSTableViewDefaultSizeMode -int 2

echo "# Always show scrollbars"
defaults write NSGlobalDomain AppleShowScrollBars -string "WhenScrolling"
# Possible values: `WhenScrolling`, `Automatic` and `Always`

echo "# Disable smooth scrolling"
# (Uncomment if you’re on an older Mac that messes up the animation)
defaults write NSGlobalDomain NSScrollAnimationEnabled -bool false

echo "# Increase window resize speed for Cocoa applications"
defaults write NSGlobalDomain NSWindowResizeTime -float 0.001

echo "# Expand save panel by default"
defaults write NSGlobalDomain NSNavPanelExpandedStateForSaveMode -bool true
defaults write NSGlobalDomain NSNavPanelExpandedStateForSaveMode2 -bool true

echo "# Expand print panel by default"
defaults write NSGlobalDomain PMPrintingExpandedStateForPrint -bool true
defaults write NSGlobalDomain PMPrintingExpandedStateForPrint2 -bool true

echo "# Save to disk (not to iCloud) by default"
defaults write NSGlobalDomain NSDocumentSaveNewDocumentsToCloud -bool false

echo "# Automatically quit printer app once the print jobs complete"
defaults write com.apple.print.PrintingPrefs "Quit When Finished" -bool true

echo "# Disable the “Are you sure you want to open this application?” dialog"
defaults write com.apple.LaunchServices LSQuarantine -bool false

echo "# Remove duplicates in the “Open With” menu (also see `lscleanup` alias)"
/System/Library/Frameworks/CoreServices.framework/Frameworks/LaunchServices.framework/Support/lsregister -kill -r -domain local -domain system -domain user

echo "# Display ASCII control characters using caret notation in standard text views"
# Try e.g. `cd /tmp; unidecode "\x{0000}" > cc.txt; open -e cc.txt`
defaults write NSGlobalDomain NSTextShowsControlCharacters -bool true


#echo "# Disable automatic termination of inactive apps"
#defaults write NSGlobalDomain NSDisableAutomaticTermination -bool true

echo "# Disable the crash reporter"
defaults write com.apple.CrashReporter DialogType -string "none"

echo "# Set Help Viewer windows to non-floating mode"
defaults write com.apple.helpviewer DevMode -bool true

echo "# Fix for the ancient UTF-8 bug in QuickLook (http://mths.be/bbo)"
# Commented out, as this is known to cause problems in various Adobe apps :(
# See https://github.com/mathiasbynens/dotfiles/issues/237
#echo "0x08000100:0" > ~/.CFUserTextEncoding

echo "# Reveal IP address, hostname, OS version, etc. when clicking the clock"
# in the login window
sudo defaults write /Library/Preferences/com.apple.loginwindow AdminHostInfo HostName

echo "# Restart automatically if the computer freezes"
systemsetup -setrestartfreeze on

echo "# Never go into computer sleep mode"
systemsetup -setcomputersleep Off > /dev/null

echo "# Check for software updates daily, not just once per week"
#defaults write com.apple.SoftwareUpdate ScheduleFrequency -int 9999

echo "# Disable Notification Center and remove the menu bar icon"
#launchctl unload -w /System/Library/LaunchAgents/com.apple.notificationcenterui.plist 2> /dev/null

echo "# Disable smart quotes as they’re annoying when typing code"
defaults write NSGlobalDomain NSAutomaticQuoteSubstitutionEnabled -bool false

echo "# Disable smart dashes as they’re annoying when typing code"
defaults write NSGlobalDomain NSAutomaticDashSubstitutionEnabled -bool false

# Set a custom wallpaper image. `DefaultDesktop.jpg` is already a symlink, and
# all wallpapers are in `/Library/Desktop Pictures/`. The default is `Wave.jpg`.
#rm -rf ~/Library/Application Support/Dock/desktoppicture.db
#sudo rm -rf /System/Library/CoreServices/DefaultDesktop.jpg
#sudo ln -s /path/to/your/image /System/Library/CoreServices/DefaultDesktop.jpg

###############################################################################
echo "# SSD-specific tweaks                                                         #"
###############################################################################

echo "# Disable local Time Machine snapshots"
sudo tmutil disablelocal

echo "# Enable long hibernation (speeds up entering sleep mode)"
# sudo pmset -a hibernatemode 3 ### default for laptops
#sudo pmset -a hibernatemode 25
#sudo pmset -b hibernatemode 25

echo "# Remove the sleep image file to save disk space"
sudo rm /Private/var/vm/sleepimage
echo "# Create a zero-byte file instead…"
sudo touch /Private/var/vm/sleepimage
echo "# …and make sure it can’t be rewritten"
sudo chflags uchg /Private/var/vm/sleepimage

echo "# Disable the sudden motion sensor as it’s not useful for SSDs"
sudo pmset -a sms 0

###############################################################################
# Trackpad, mouse, keyboard, Bluetooth accessories, and input                 #
###############################################################################

echo "# Trackpad: enable tap to click for this user and for the login screen"
defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad Clicking -bool true
defaults -currentHost write NSGlobalDomain com.apple.mouse.tapBehavior -int 1
defaults write NSGlobalDomain com.apple.mouse.tapBehavior -int 1

echo "# Trackpad: map bottom right corner to right-click"
# defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad TrackpadCornerSecondaryClick -int 2
defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad TrackpadRightClick -bool true
# defaults -currentHost write NSGlobalDomain com.apple.trackpad.trackpadCornerClickBehavior -int 1
defaults -currentHost write NSGlobalDomain com.apple.trackpad.enableSecondaryClick -bool true

# Disable “natural” (Lion-style) scrolling
#defaults write NSGlobalDomain com.apple.swipescrolldirection -bool false

echo "# Increase sound quality for Bluetooth headphones/headsets"
defaults write com.apple.BluetoothAudioAgent "Apple Bitpool Min (editable)" -int 40

echo "# Enable full keyboard access for all controls"
# (e.g. enable Tab in modal dialogs)
defaults write NSGlobalDomain AppleKeyboardUIMode -int 3

echo "# Use scroll gesture with the Ctrl (^) modifier key to zoom"
defaults write com.apple.universalaccess closeViewScrollWheelToggle -bool true
defaults write com.apple.universalaccess HIDScrollZoomModifierMask -int 262144
echo "# Follow the keyboard focus while zoomed in"
defaults write com.apple.universalaccess closeViewZoomFollowsFocus -bool true

echo "# Disable press-and-hold for keys in favor of key repeat"
defaults write NSGlobalDomain ApplePressAndHoldEnabled -bool false

echo "# Set a blazingly fast keyboard repeat rate"
defaults write NSGlobalDomain KeyRepeat -int 0

echo "# Set language and text formats"
# Note: if you’re in the US, replace `EUR` with `USD`, `Centimeters` with
# `Inches`, `en_GB` with `en_US`, and `true` with `false`.
defaults write NSGlobalDomain AppleLanguages -array "en" "ru"
defaults write NSGlobalDomain AppleLocale -string "en_GB@currency=EUR"
defaults write NSGlobalDomain AppleMeasurementUnits -string "Centimeters"
defaults write NSGlobalDomain AppleMetricUnits -bool true

echo "# Set the timezone; see `systemsetup -listtimezones` for other values"
systemsetup -settimezone "Europe/Moscow" > /dev/null

echo "# Disable auto-correct"
defaults write NSGlobalDomain NSAutomaticSpellingCorrectionEnabled -bool false

echo "# Stop iTunes from responding to the keyboard media keys"
launchctl unload -w /System/Library/LaunchAgents/com.apple.rcd.plist 2> /dev/null

###############################################################################
# Screen                                                                      #
###############################################################################

echo "# Require password immediately after sleep or screen saver begins"
defaults write com.apple.screensaver askForPassword -int 1
defaults write com.apple.screensaver askForPasswordDelay -int 5

echo "# Save screenshots to the desktop"
defaults write com.apple.screencapture location -string "${HOME}/Desktop"

echo "# Save screenshots in PNG format (other options: BMP, GIF, JPG, PDF, TIFF)"
defaults write com.apple.screencapture type -string "png"

echo "# Disable shadow in screenshots"
defaults write com.apple.screencapture disable-shadow -bool true

echo "# Enable subpixel font rendering on non-Apple LCDs"
defaults write NSGlobalDomain AppleFontSmoothing -int 2

echo "# Enable HiDPI display modes (requires restart)"
sudo defaults write /Library/Preferences/com.apple.windowserver DisplayResolutionEnabled -bool true

###############################################################################
# Finder                                                                      #
###############################################################################

echo "# Finder: allow quitting via ⌘ + Q; doing so will also hide desktop icons"
defaults write com.apple.finder QuitMenuItem -bool true

echo "# Finder: disable window animations and Get Info animations"
defaults write com.apple.finder DisableAllAnimations -bool true

echo "# Set Desktop as the default location for new Finder windows"
# For other paths, use `PfLo` and `file:///full/path/here/`
defaults write com.apple.finder NewWindowTarget -string "PfDe"
#defaults write com.apple.finder NewWindowTargetPath -string "file://${HOME}/Desktop/"
defaults write com.apple.finder NewWindowTargetPath -string "file://${HOME}"


echo "# Show icons for hard drives, servers, and removable media on the desktop"
defaults write com.apple.finder ShowExternalHardDrivesOnDesktop -bool true
defaults write com.apple.finder ShowHardDrivesOnDesktop -bool true
defaults write com.apple.finder ShowMountedServersOnDesktop -bool true
defaults write com.apple.finder ShowRemovableMediaOnDesktop -bool true

echo "# Finder: show hidden files by default"
#defaults write com.apple.finder AppleShowAllFiles -bool true

echo "# Finder: show all filename extensions"
defaults write NSGlobalDomain AppleShowAllExtensions -bool true

echo "# Finder: show status bar"
defaults write com.apple.finder ShowStatusBar -bool true

echo "# Finder: show path bar"
defaults write com.apple.finder ShowPathbar -bool true

echo "# Finder: allow text selection in Quick Look"
defaults write com.apple.finder QLEnableTextSelection -bool true

echo "# Display full POSIX path as Finder window title"
defaults write com.apple.finder _FXShowPosixPathInTitle -bool true

echo "# When performing a search, search the current folder by default"
defaults write com.apple.finder FXDefaultSearchScope -string "SCcf"

echo "# Disable the warning when changing a file extension"
defaults write com.apple.finder FXEnableExtensionChangeWarning -bool false

echo "# Enable spring loading for directories"
defaults write NSGlobalDomain com.apple.springing.enabled -bool true

echo "# Remove the spring loading delay for directories"
defaults write NSGlobalDomain com.apple.springing.delay -float 1

echo "# Avoid creating .DS_Store files on network volumes"
defaults write com.apple.desktopservices DSDontWriteNetworkStores -bool true

echo "# Disable disk image verification"
defaults write com.apple.frameworks.diskimages skip-verify -bool true
defaults write com.apple.frameworks.diskimages skip-verify-locked -bool true
defaults write com.apple.frameworks.diskimages skip-verify-remote -bool true

echo "# Automatically open a new Finder window when a volume is mounted"
defaults write com.apple.frameworks.diskimages auto-open-ro-root -bool true
defaults write com.apple.frameworks.diskimages auto-open-rw-root -bool true
defaults write com.apple.finder OpenWindowForNewRemovableDisk -bool true

echo "# Do not show item info near icons on the desktop and in other icon views"
/usr/libexec/PlistBuddy -c "Set :DesktopViewSettings:IconViewSettings:showItemInfo false" ~/Library/Preferences/com.apple.finder.plist
/usr/libexec/PlistBuddy -c "Set :FK_StandardViewSettings:IconViewSettings:showItemInfo false" ~/Library/Preferences/com.apple.finder.plist
/usr/libexec/PlistBuddy -c "Set :StandardViewSettings:IconViewSettings:showItemInfo false" ~/Library/Preferences/com.apple.finder.plist

echo "# Show item info to the right of the icons on the desktop"
/usr/libexec/PlistBuddy -c "Set DesktopViewSettings:IconViewSettings:labelOnBottom false" ~/Library/Preferences/com.apple.finder.plist

echo "# Enable snap-to-grid for icons on the desktop and in other icon views"
/usr/libexec/PlistBuddy -c "Set :DesktopViewSettings:IconViewSettings:arrangeBy kind" ~/Library/Preferences/com.apple.finder.plist
/usr/libexec/PlistBuddy -c "Set :FK_StandardViewSettings:IconViewSettings:arrangeBy kind" ~/Library/Preferences/com.apple.finder.plist
/usr/libexec/PlistBuddy -c "Set :StandardViewSettings:IconViewSettings:arrangeBy kind" ~/Library/Preferences/com.apple.finder.plist

echo "# Increase grid spacing for icons on the desktop and in other icon views"
/usr/libexec/PlistBuddy -c "Set :DesktopViewSettings:IconViewSettings:gridSpacing 100" ~/Library/Preferences/com.apple.finder.plist
/usr/libexec/PlistBuddy -c "Set :FK_StandardViewSettings:IconViewSettings:gridSpacing 100" ~/Library/Preferences/com.apple.finder.plist
/usr/libexec/PlistBuddy -c "Set :StandardViewSettings:IconViewSettings:gridSpacing 100" ~/Library/Preferences/com.apple.finder.plist

echo "# Increase the size of icons on the desktop and in other icon views"
/usr/libexec/PlistBuddy -c "Set :DesktopViewSettings:IconViewSettings:iconSize 16" ~/Library/Preferences/com.apple.finder.plist
/usr/libexec/PlistBuddy -c "Set :FK_StandardViewSettings:IconViewSettings:iconSize 64" ~/Library/Preferences/com.apple.finder.plist
/usr/libexec/PlistBuddy -c "Set :StandardViewSettings:IconViewSettings:iconSize 64" ~/Library/Preferences/com.apple.finder.plist

echo "# Use list view in all Finder windows by default"
# Four-letter codes for the other view modes: `icnv`, `clmv`, `Flwv`
defaults write com.apple.finder FXPreferredViewStyle -string "Nlsv"

echo "# Disable the warning before emptying the Trash"
defaults write com.apple.finder WarnOnEmptyTrash -bool false

echo "# Empty Trash securely by default"
defaults write com.apple.finder EmptyTrashSecurely -bool false

#echo "# Enable AirDrop over Ethernet and on unsupported Macs running Lion"
#defaults write com.apple.NetworkBrowser BrowseAllInterfaces -bool true

echo "# Enable the MacBook Air SuperDrive on any Mac"
sudo nvram boot-args="mbasd=1"

echo "# Show the ~/Library folder"
chflags nohidden ~/Library

echo "# Remove Dropbox’s green checkmark icons in Finder"
file=/Applications/Dropbox.app/Contents/Resources/emblem-dropbox-uptodate.icns
[ -e "${file}" ] && mv -f "${file}" "${file}.bak"

echo "# Expand the following File Info panes:"
# “General”, “Open with”, and “Sharing & Permissions”
defaults write com.apple.finder FXInfoPanesExpanded -dict \
	General -bool true \
	OpenWith -bool true \
	Privileges -bool true

###############################################################################
# Dock, Dashboard, and hot corners                                            #
###############################################################################

echo "# Enable highlight hover effect for the grid view of a stack (Dock)"
#defaults write com.apple.dock mouse-over-hilite-stack -bool true

echo "# Set the icon size of Dock items to 36 pixels"
defaults write com.apple.dock tilesize -int 36

echo "# Change minimize/maximize window effect"
defaults write com.apple.dock mineffect -string "scale"

echo "# Minimize windows into their application’s icon"
defaults write com.apple.dock minimize-to-application -bool false

echo "# Enable spring loading for all Dock items"
defaults write com.apple.dock enable-spring-load-actions-on-all-items -bool true

echo "# Show indicator lights for open applications in the Dock"
defaults write com.apple.dock show-process-indicators -bool true

echo "# Wipe all (default) app icons from the Dock"
# This is only really useful when setting up a new Mac, or if you don’t use
# the Dock to launch apps.
defaults write com.apple.dock persistent-apps -array ""

echo "# Don’t animate opening applications from the Dock"
defaults write com.apple.dock launchanim -bool false

echo "# Speed up Mission Control animations"
defaults write com.apple.dock expose-animation-duration -float 0.1

echo "# Don’t group windows by application in Mission Control"
# (i.e. use the old Exposé behavior instead)
defaults write com.apple.dock expose-group-by-app -bool false

echo "# Disable Dashboard"
defaults write com.apple.dashboard mcx-disabled -bool true

echo "# Don’t show Dashboard as a Space"
defaults write com.apple.dock dashboard-in-overlay -bool true

echo "# Don’t automatically rearrange Spaces based on most recent use"
defaults write com.apple.dock mru-spaces -bool false

echo "# Remove the auto-hiding Dock delay"
#defaults write com.apple.dock autohide-delay -float 0
echo "# Remove the animation when hiding/showing the Dock"
defaults write com.apple.dock autohide-time-modifier -float 0

echo "# Enable the 2D Dock"
defaults write com.apple.dock no-glass -bool true

echo "# Automatically hide and show the Dock"
defaults write com.apple.dock autohide -bool true

echo "# Make Dock icons of hidden applications translucent"
defaults write com.apple.dock showhidden -bool true

echo "# Make Dock more transparent"
defaults write com.apple.dock hide-mirror -bool true

echo "# Disable the Launchpad gesture (pinch with thumb and three fingers)"
defaults write com.apple.dock showLaunchpadGestureEnabled -int 0

echo "# Reset Launchpad, but keep the desktop wallpaper intact"
find "${HOME}/Library/Application Support/Dock" -name "*-*.db" -maxdepth 1 -delete

echo "# Add iOS Simulator to Launchpad"
sudo ln -sf "/Applications/Xcode.app/Contents/Developer/Platforms/iPhoneSimulator.platform/Developer/Applications/iPhone Simulator.app" "/Applications/iOS Simulator.app"

echo "# Add a spacer to the left side of the Dock (where the applications are)"
#defaults write com.apple.dock persistent-apps -array-add '{tile-data={}; tile-type="spacer-tile";}'
echo "# Add a spacer to the right side of the Dock (where the Trash is)"
#defaults write com.apple.dock persistent-others -array-add '{tile-data={}; tile-type="spacer-tile";}'

echo "# Hot corners"
# Possible values:
#  0: no-op
#  2: Mission Control
#  3: Show application windows
#  4: Desktop
#  5: Start screen saver
#  6: Disable screen saver
#  7: Dashboard
# 10: Put display to sleep
# 11: Launchpad
# 12: Notification Center
# Top left screen corner → Mission Control
#defaults write com.apple.dock wvous-tl-corner -int 2
#defaults write com.apple.dock wvous-tl-modifier -int 0
# Top right screen corner → Desktop
#defaults write com.apple.dock wvous-tr-corner -int 4
#defaults write com.apple.dock wvous-tr-modifier -int 0
# Bottom left screen corner → Start screen saver
#defaults write com.apple.dock wvous-bl-corner -int 5
#defaults write com.apple.dock wvous-bl-modifier -int 0

###############################################################################
echo "# Safari & WebKit                                                             #"
###############################################################################

echo "# Set Safari’s home page to `about:blank` for faster loading"
defaults write com.apple.Safari HomePage -string "about:blank"

echo "# Prevent Safari from opening ‘safe’ files automatically after downloading"
defaults write com.apple.Safari AutoOpenSafeDownloads -bool false

echo "# Allow hitting the Backspace key to go to the previous page in history"
defaults write com.apple.Safari com.apple.Safari.ContentPageGroupIdentifier.WebKit2BackspaceKeyNavigationEnabled -bool true

echo "# Hide Safari’s bookmarks bar by default"
defaults write com.apple.Safari ShowFavoritesBar -bool false

echo "# Hide Safari’s sidebar in Top Sites"
defaults write com.apple.Safari ShowSidebarInTopSites -bool false

echo "# Disable Safari’s thumbnail cache for History and Top Sites"
defaults write com.apple.Safari DebugSnapshotsUpdatePolicy -int 2

echo "# Enable Safari’s debug menu"
defaults write com.apple.Safari IncludeInternalDebugMenu -bool true

echo "# Make Safari’s search banners default to Contains instead of Starts With"
defaults write com.apple.Safari FindOnPageMatchesWordStartsOnly -bool false

echo "# Remove useless icons from Safari’s bookmarks bar"
defaults write com.apple.Safari ProxiesInBookmarksBar "()"

echo "# Enable the Develop menu and the Web Inspector in Safari"
defaults write com.apple.Safari IncludeDevelopMenu -bool true
defaults write com.apple.Safari WebKitDeveloperExtrasEnabledPreferenceKey -bool true
defaults write com.apple.Safari com.apple.Safari.ContentPageGroupIdentifier.WebKit2DeveloperExtrasEnabled -bool true

echo "# Add a context menu item for showing the Web Inspector in web views"
defaults write NSGlobalDomain WebKitDeveloperExtras -bool true

###############################################################################
echo "# Mail                                                                        #"
###############################################################################

echo "# Disable send and reply animations in Mail.app"
defaults write com.apple.mail DisableReplyAnimations -bool true
defaults write com.apple.mail DisableSendAnimations -bool true

echo "# Copy email addresses as `foo@example.com` instead of `Foo Bar <foo@example.com>` in Mail.app"
defaults write com.apple.mail AddressesIncludeNameOnPasteboard -bool false

echo "# Add the keyboard shortcut ⌘ + Enter to send an email in Mail.app"
defaults write com.apple.mail NSUserKeyEquivalents -dict-add "Send" -string "@\\U21a9"

echo "# Display emails in threaded mode, sorted by date (oldest at the top)"
defaults write com.apple.mail DraftsViewerAttributes -dict-add "DisplayInThreadedMode" -string "yes"
defaults write com.apple.mail DraftsViewerAttributes -dict-add "SortedDescending" -string "yes"
defaults write com.apple.mail DraftsViewerAttributes -dict-add "SortOrder" -string "received-date"

#echo "# Disable inline attachments (just show the icons)"
#defaults write com.apple.mail DisableInlineAttachmentViewing -bool true

echo "# Disable automatic spell checking"
defaults write com.apple.mail SpellCheckingBehavior -string "NoSpellCheckingEnabled"

###############################################################################
echo "# Spotlight                                                                   #"
###############################################################################

echo "# Hide Spotlight tray-icon (and subsequent helper)"
#sudo chmod 600 /System/Library/CoreServices/Search.bundle/Contents/MacOS/Search
# Disable Spotlight indexing for any volume that gets mounted and has not yet
# been indexed before.
# Use `sudo mdutil -i off "/Volumes/foo"` to stop indexing any volume.
sudo defaults write /.Spotlight-V100/VolumeConfiguration Exclusions -array "/Volumes"
# Change indexing order and disable some file types
defaults write com.apple.spotlight orderedItems -array \
	'{"enabled" = 1;"name" = "APPLICATIONS";}' \
	'{"enabled" = 1;"name" = "SYSTEM_PREFS";}' \
	'{"enabled" = 1;"name" = "DIRECTORIES";}' \
	'{"enabled" = 1;"name" = "PDF";}' \
	'{"enabled" = 1;"name" = "FONTS";}' \
	'{"enabled" = 1;"name" = "DOCUMENTS";}' \
	'{"enabled" = 0;"name" = "MESSAGES";}' \
	'{"enabled" = 0;"name" = "CONTACT";}' \
	'{"enabled" = 1;"name" = "EVENT_TODO";}' \
	'{"enabled" = 1;"name" = "IMAGES";}' \
	'{"enabled" = 0;"name" = "BOOKMARKS";}' \
	'{"enabled" = 1;"name" = "MUSIC";}' \
	'{"enabled" = 1;"name" = "MOVIES";}' \
	'{"enabled" = 0;"name" = "PRESENTATIONS";}' \
	'{"enabled" = 1;"name" = "SPREADSHEETS";}' \
	'{"enabled" = 1;"name" = "SOURCE";}'
echo "# Load new settings before rebuilding the index"
killall mds > /dev/null 2>&1
echo "# Make sure indexing is enabled for the main volume"
sudo mdutil -i on / > /dev/null
echo "# Rebuild the index from scratch"
sudo mdutil -E / > /dev/null


###############################################################################
echo "# Time Machine                                                                #"
###############################################################################

echo "# Prevent Time Machine from prompting to use new hard drives as backup volume"
defaults write com.apple.TimeMachine DoNotOfferNewDisksForBackup -bool true

echo "# Disable local Time Machine backups"
hash tmutil &> /dev/null && sudo tmutil disablelocal

###############################################################################
echo "# Activity Monitor                                                            #"
###############################################################################

echo "# Show the main window when launching Activity Monitor"
defaults write com.apple.ActivityMonitor OpenMainWindow -bool true

echo "# Visualize CPU usage in the Activity Monitor Dock icon"
defaults write com.apple.ActivityMonitor IconType -int 5

echo "# Show all processes in Activity Monitor"
defaults write com.apple.ActivityMonitor ShowCategory -int 0

echo "# Sort Activity Monitor results by CPU usage"
defaults write com.apple.ActivityMonitor SortColumn -string "CPUUsage"
defaults write com.apple.ActivityMonitor SortDirection -int 0

###############################################################################
echo "# Address Book, Dashboard, iCal, TextEdit, and Disk Utility                   #"
###############################################################################

echo "# Enable the debug menu in Address Book"
defaults write com.apple.addressbook ABShowDebugMenu -bool true

echo "# Enable Dashboard dev mode (allows keeping widgets on the desktop)"
defaults write com.apple.dashboard devmode -bool true

echo "# Enable the debug menu in iCal (pre-10.8)"
defaults write com.apple.iCal IncludeDebugMenu -bool true

echo "# Use plain text mode for new TextEdit documents"
defaults write com.apple.TextEdit RichText -int 0
echo "# Open and save files as UTF-8 in TextEdit"
defaults write com.apple.TextEdit PlainTextEncoding -int 4
defaults write com.apple.TextEdit PlainTextEncodingForWrite -int 4

echo "# Enable the debug menu in Disk Utility"
defaults write com.apple.DiskUtility DUDebugMenuEnabled -bool true
defaults write com.apple.DiskUtility advanced-image-options -bool true

###############################################################################
echo "# Mac App Store                                                               #"
###############################################################################

echo "# Enable the WebKit Developer Tools in the Mac App Store"
defaults write com.apple.appstore WebKitDeveloperExtras -bool true

echo "# Enable Debug Menu in the Mac App Store"
defaults write com.apple.appstore ShowDebugMenu -bool true

###############################################################################
echo "# Messages                                                                    #"
###############################################################################

echo "# Disable automatic emoji substitution (i.e. use plain text smileys)"
defaults write com.apple.messageshelper.MessageController SOInputLineSettings -dict-add "automaticEmojiSubstitutionEnablediMessage" -bool false

echo "# Disable smart quotes as it’s annoying for messages that contain code"
defaults write com.apple.messageshelper.MessageController SOInputLineSettings -dict-add "automaticQuoteSubstitutionEnabled" -bool false

echo "# Disable continuous spell checking"
defaults write com.apple.messageshelper.MessageController SOInputLineSettings -dict-add "continuousSpellCheckingEnabled" -bool false

###############################################################################
echo "# Google Chrome & Google Chrome Canary                                        #"
###############################################################################

echo "# Allow installing user scripts via GitHub Gist or Userscripts.org"
defaults write com.google.Chrome ExtensionInstallSources -array "https://gist.githubusercontent.com/" "http://userscripts.org/*"
defaults write com.google.Chrome.canary ExtensionInstallSources -array "https://gist.githubusercontent.com/" "http://userscripts.org/*"

###############################################################################
#echo "# GPGMail 2                                                                   #"
###############################################################################

#echo "# Disable signing emails by default"
#defaults write ~/Library/Preferences/org.gpgtools.gpgmail SignNewEmailsByDefault -bool false

###############################################################################
#echo "# SizeUp.app                                                                  #"
###############################################################################

#echo "# Start SizeUp at login"
# defaults write com.irradiatedsoftware.SizeUp StartAtLogin -bool true

#echo "# Don’t show the preferences window on next start"
# defaults write com.irradiatedsoftware.SizeUp ShowPrefsOnNextStart -bool false

###############################################################################
#echo "# Sublime Text                                                                #"
###############################################################################

#echo "# Install Sublime Text settings"
#cp -r init/Preferences.sublime-settings ~/Library/Application\ Support/Sublime\ Text*/Packages/User/Preferences.sublime-settings 2> /dev/null

#echo "###############################################################################"
#echo "# Transmission.app                                                            #"
#echo "###############################################################################"

echo "# Use `~/Documents/Torrents` to store incomplete downloads"
defaults write org.m0k.transmission UseIncompleteDownloadFolder -bool true
defaults write org.m0k.transmission IncompleteDownloadFolder -string "${HOME}/Documents/Torrents"

echo "# Don’t prompt for confirmation before downloading"
defaults write org.m0k.transmission DownloadAsk -bool false

echo "# Trash original torrent files"
defaults write org.m0k.transmission DeleteOriginalTorrent -bool true

echo "# Hide the donate message"
defaults write org.m0k.transmission WarningDonate -bool false
echo "# Hide the legal disclaimer"
defaults write org.m0k.transmission WarningLegal -bool false

#echo "###############################################################################"
#echo "# Twitter.app                                                                 #"
#echo "###############################################################################"

#echo "# Disable smart quotes as it’s annoying for code tweets"
#defaults write com.twitter.twitter-mac AutomaticQuoteSubstitutionEnabled -bool false

#echo "# Show the app window when clicking the menu bar icon"
#defaults write com.twitter.twitter-mac MenuItemBehavior -int 1

#echo "# Enable the hidden ‘Develop’ menu"
#defaults write com.twitter.twitter-mac ShowDevelopMenu -bool true

#echo "# Open links in the background"
#defaults write com.twitter.twitter-mac openLinksInBackground -bool true

#echo "# Allow closing the ‘new tweet’ window by pressing `Esc`"
#defaults write com.twitter.twitter-mac ESCClosesComposeWindow -bool true

#echo "# Show full names rather than Twitter handles"
#defaults write com.twitter.twitter-mac ShowFullNames -bool true

#echo "# Hide the app in the background if it’s not the front-most window"
#defaults write com.twitter.twitter-mac HideInBackground -bool true


echo "###############################################################################"
echo "# Momo settings"
echo "###############################################################################"

echo "# Disable Resume system-wide"
defaults write NSGlobalDomain NSQuitAlwaysKeepsWindows -bool false
sudo cat /dev/null > ~/Library/Preferences/ByHost/com.apple.loginwindow.*
sudo chmod 0000 ~/Library/Preferences/ByHost/com.apple.loginwindow.*
sudo chmod -R 0000 ~/Library/Saved\ Application\ State/

echo "# Lock login prefs and stop apps restore"
sudo chflags uchg $HOME/Library/Preferences/ByHost/com.apple.loginwindow*
sudo rm -rf $HOME/Library/Saved\ Application\ State/*
sudo chmod 0000 $HOME/Library/Saved\ Application\ State/

echo "# Preven Photos app from launching"
defaults -currentHost write com.apple.ImageCapture disableHotPlug -bool NO

echo "# Symlink my wallpapers into ~/Pictures folder"

#for file in $HOME/Google\ Drive/wallz/Public/*; do ln -s "$file" "/Users/$USER/Pictures$(echo $file | sed -e "s/\/Users\/$USER\/Google\ Drive\/wallz\/Public//")"; done
#for file in $HOME/Google\ Drive/wallz/Private/*; do ln -s "$file" "/Users/$USER/Pictures$(echo $file | sed -e "s/\/Users\/$USER\/Google\ Drive\/wallz\/Private//")"; done

echo "# Install apps"
echo "Installing Homebrew"

/usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"

echo "Installing favourite packages"

brew cask install iterm2 sublime-text google-chrome telegram-desktop google-hangouts hammerspoon prepros keka keeweb  flux 

brew install mc go wget fish htop nmap fzf 

echo “you should install go2shell from app store”

echo "# make hammerspoon config"
mkdir -p $HOME/.hammerspoon
cp -r $HOME/Google\ Drive/_osx_used_shell_toolz/hammerspoon/.hammerspoon/init.lua $HOME/.hammerspoon/


echo "enable fullscreen dark mode"
defaults write NSGlobalDomain AppleInterfaceStyle Dark
defaults write -g NSFullScreenDarkMenu -bool true

echo "###############################################################################"
echo "# Kill affected applications                                                  #"
echo "###############################################################################"

for app in "Activity Monitor" "Address Book" "Calendar" "Contacts" "cfprefsd" \
	"Dock" "Finder" "Mail" "Messages" "Safari" "SizeUp" "SystemUIServer" \
	"Terminal" "Transmission" "Twitter" "iCal"; do
	killall "${app}" > /dev/null 2>&1
done
echo "Done. Note that some of these changes require a logout/restart to take effect."

###############################################################################
echo "# Terminal & iTerm 2                                                          #"
###############################################################################

echo "# Only use UTF-8 in Terminal.app"
defaults write com.apple.terminal StringEncodings -array 4

echo "# Use a modified version of the Solarized Dark theme by default in Terminal.app"
TERM_PROFILE='Solarized Dark xterm-256color';
CURRENT_PROFILE="$(defaults read com.apple.terminal 'Default Window Settings')";
if [ "${CURRENT_PROFILE}" != "${TERM_PROFILE}" ]; then
	open "${HOME}/init/${TERM_PROFILE}.terminal";
	sleep 1; # Wait a bit to make sure the theme is loaded
	defaults write com.apple.terminal 'Default Window Settings' -string "${TERM_PROFILE}";
	defaults write com.apple.terminal 'Startup Window Settings' -string "${TERM_PROFILE}";
fi;

echo "# Enable “focus follows mouse” for Terminal.app and all X11 apps"
i.e. hover over a window and start typing in it without clicking first
defaults write com.apple.terminal FocusFollowsMouse -bool true
defaults write org.x.X11 wm_ffm -bool true

echo "# Install the Solarized Dark theme for iTerm"
open "${HOME}/init/Solarized Dark.itermcolors"

echo "# Don’t display the annoying prompt when quitting iTerm"
defaults write com.googlecode.iterm2 PromptOnQuit -bool false