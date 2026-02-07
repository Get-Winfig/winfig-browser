// ========================================
// UI / CSS support
// ========================================

user_pref("toolkit.legacyUserProfileCustomizations.stylesheets", true);
user_pref("zen.urlbar.behavior", "float");
user_pref("zen.welcome-screen.seen", true);
user_pref("sidebar.visibility", "hide-sidebar");
user_pref("ui.systemUsesDarkTheme", 1);
user_pref("browser.theme.toolbar-theme", 0);
user_pref("layout.css.prefers-color-scheme.enabled", true);
user_pref("layout.css.prefers-color-scheme.content-override", 0);
user_pref("zen.sidebar.autoCollapse", true);
user_pref("zen.sidebar.collapse.on.blur", true);
user_pref("browser.uiCustomization.state", "{\"placements\": {\"nav-bar\": [\"back-button\", \"forward-button\", \"bookmarks-menu-button\", \"home-button\", \"customizableui-special-spring1\", \"vertical-spacer\", \"urlbar-container\"]}}")
user_pref("browser.places.importBookmarksHTML", true);
user_pref("browser.toolbars.bookmarks.visibility", "always");
user_pref("browser.bookmarks.defaultLocation", "toolbar");

// ========================================
// Privacy / Tracking Protection
// ========================================

user_pref("browser.contentblocking.category", "strict");
user_pref("privacy.globalprivacycontrol.enabled", true);
user_pref("privacy.trackingprotection.enabled", true);
user_pref("privacy.trackingprotection.socialtracking.enabled", true);
user_pref("privacy.partition.network_state", true);

// ========================================
// Telemetry reduction (safe level)
// ========================================

user_pref("toolkit.telemetry.reportingpolicy.firstRun", false);
user_pref("toolkit.telemetry.enabled", false);
user_pref("datareporting.healthreport.uploadEnabled", false);

// ========================================
// Search / URL bar
// ========================================

user_pref("browser.urlbar.quicksuggest.enabled", false);
user_pref("browser.urlbar.suggest.quicksuggest.nonsponsored", false);
user_pref("browser.urlbar.suggest.quicksuggest.sponsored", false);

// ========================================
// Session / startup behavior
// ========================================

user_pref("browser.shell.checkDefaultBrowser", false);
user_pref("browser.startup.page", 3);

// ========================================
// Zen-specific (SAFE)
// ========================================

user_pref("zen.view.compact.enable-at-startup", true);
user_pref("zen.tabs.show-newtab-vertical", false);
user_pref("zen.view.use-single-toolbar", false);

// ========================================
// Fonts / Ligatures
// ========================================

user_pref("font.name.serif.x-western", "Hack Nerd Font");
user_pref("font.size.variable.x-western", 14);

// ========================================
// Disable geolocation
// ========================================

user_pref("geo.enabled", false);

// ========================================
// Reduce fingerprinting (safe mode)
// ========================================

user_pref("privacy.resistFingerprinting", false);
user_pref("privacy.fingerprintingProtection", true);

// ========================================
// HTTPS & mixed content
// ========================================

user_pref("dom.security.https_only_mode", true);
user_pref("security.mixed_content.block_active_content", true);

// ========================================
// WebRTC IP leak protection
// ========================================

user_pref("media.peerconnection.ice.default_address_only", true);
user_pref("media.peerconnection.ice.no_host", true);

// ========================================
// Referrer hardening
// ========================================

user_pref("network.http.referer.XOriginPolicy", 2);
user_pref("network.http.referer.XOriginTrimmingPolicy", 2);
