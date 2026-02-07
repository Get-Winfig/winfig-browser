// userChrome.js
(function () {
  const { Services } = ChromeUtils.import(
    "resource://gre/modules/Services.jsm"
  );

  const BASE =
    "file:///<Sine-Path>";

  function load(relativePath) {
    try {
      Services.scriptloader.loadSubScript(BASE + relativePath, this);
      console.log("[userChrome] Loaded:", relativePath);
    } catch (e) {
      console.error("[userChrome] Failed:", relativePath, e);
    }
  }

  // Zen Tidy Downloads
  load("Zen%20Tidy%20Downloads/tidy-downloads.uc.js");
  load("Zen%20Tidy%20Downloads/zen-stuff.uc.js");
})();
