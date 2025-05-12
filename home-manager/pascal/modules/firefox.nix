{
  inputs,
  config,
  lib,
  pkgs,
  ...
}: {

  # force creation of ~/.mozilla/firefox/profiles.ini otherwise home-manager will fail
  home.file.".mozilla/firefox/profiles.ini".force = true;

  programs.firefox = {
    enable = true;
    package = pkgs.firefox-bin;

    profiles.playnix = {
      id = 0;
      name = "PlayNix";
      isDefault = true;

      search = {
        default = "duckduckgo";
        force = true;
      };

      settings = {
        "browser.aboutConfig.showWarning" = false;
        "toolkit.telemetry.enabled" = false;
        "browser.startup.page" = 3; # Open windows and tabs from the last session
        "browser.sessionstore.resume_from_crash" = true;
        "browser.sessionstore.max_resumed_crashes" = -1;
        "browser.newtabpage.enabled" = true;
        "browser.newtabpage.activity-stream.topSitesRows" = 2;
        "browser.newtabpage.storageVersion" = 1;

        "browser.newtab.preload" = false;
        "browser.newtabpage.activity-stream.telemetry" = false;
        "browser.newtabpage.activity-stream.showSponsored" = false;
        "browser.newtabpage.activity-stream.showSponsoredTopSites" = false;
        "browser.newtabpage.activity-stream.feeds.topsites" = false;
        "browser.newtabpage.activity-stream.feeds.sections" = false;
        "browser.newtabpage.activity-stream.feeds.telemetry" = false;
        "browser.newtabpage.activity-stream.feeds.snippets" = false;
        "browser.newtabpage.activity-stream.feeds.section.topstories" = false;
        "browser.newtabpage.activity-stream.feeds.discoverystreamfeed" = false;
        "browser.newtabpage.activity-stream.section.highlights.includePocket" = false;
        "browser.newtabpage.activity-stream.default.sites" = "";

        "browser.tabs.tabmanager.enabled" = false;

        "browser.in-content.dark-mode" = true;
        "ui.systemUsesDarkTheme" = 1;
        # disable alt key bringing up window menu
        "ui.key.menuAccessKeyFocuses" = false;

        "browser.theme.toolbar-theme" = 0;
        "browser.theme.content-theme" = 0;

        "media.eme.enabled" = true;
        "media.gmp-widevinecdm.visible" = true;
        "media.gmp-widevinecdm.enabled" = true;

        "browser.discovery.enabled" = false;
        "extensions.getAddons.showPane" = false;
        "extensions.getAddons.cache.enabled" = false;
        "extensions.htmlaboutaddons.recommendations.enabled" = false;
        "extensions.pocket.enabled" = false;
        "extensions.screenshots.disabled" = true;
        "extensions.blocklist.enabled" = false;
        "identity.fxaccounts.enabled" = false;

        "breakpad.reportURL" = "";
        "browser.tabs.crashReporting.sendReport" = false;
        "datareporting.policy.dataSubmissionEnabled" = false;
        "datareporting.healthreport.uploadEnabled" = false;
        "toolkit.coverage.endpoint.base" = "";
        "toolkit.coverage.opt-out" = true;
        "toolkit.telemetry.coverage.opt-out" = true;
        "browser.region.update.enabled" = false;
        "browser.region.network.url" = "";
        "browser.aboutHomeSnippets.updateUrl" = "";
        "browser.selfsupport" = false;

        "browser.safebrowsing.phishing.enabled" = false;
        "browser.safebrowsing.malware.enabled" = false;
        "browser.safebrowsing.blockedURIs.enabled" = false;
        "browser.safebrowsing.downloads.enabled" = false;
        "browser.safebrowsing.downloads.remote.enabled" = false;
        "browser.safebrowsing.downloads.remote.block_dangerous" = false;
        "browser.safebrowsing.downloads.remote.block_dangerous_host" = false;
        "browser.safebrowsing.downloads.remote.block_potentially_unwanted" = false;
        "browser.safebrowsing.downloads.remote.block_uncommon" = false;
        "browser.safebrowsing.downloads.remote.url" = "";
        "browser.safebrowsing.provider.*.gethashURL" = "";
        "browser.safebrowsing.provider.*.updateURL" = "";
        "browser.pagethumbnails.capturing_disabled" = true;
        "browser.startup.homepage_override.mstone" = "ignore";
        "browser.newtabpage.activity-stream.asrouter.userprefs.cfr.addons" = false;
        "browser.newtabpage.activity-stream.asrouter.userprefs.cfr.features" = false;
        "extensions.ui.lastCategory" = "about:addons";
        "browser.vpn_promo.enabled" = false;
        "app.normandy.enabled" = false;
        "extensions.webextensions.restrictedDomains" = "";
        "network.connectivity-service.enabled" = false;
        "browser.search.geoip.url" = "";

        "cookiebanners.service.mode" = 2;
        "cookiebanners.service.mode.privateBrowsing" = 2;

        "media.autoplay.default" = 5;
        "layout.css.prefers-color-scheme.content-override" = 0;
        "dom.security.https_only_mode" = false;
        "dom.serviceWorkers.enabled" = false;
        "network.trr.mode" = 1;
        "network.trr.uri" = "https://mozilla.cloudflare-dns.com/dns-query";
        "network.dns.echconfig.enabled" = true;
        "network.dns.http3_echconfig.enabled" = true;
        "network.prefetch-next" = false;
        "network.dns.disablePrefetch" = true;
        "media.peerconnection.ice.default_address_only" = true;
        "geo.provider.network.url" = "https://location.services.mozilla.com/v1/geolocate?key=%MOZILLA_API_KEY%";
        "signon.rememberSignons" = false;
        "signon.autofillForms" = false;
        "browser.formfill.enable" = false;
        "extensions.formautofill.addresses.enabled" = false;
        "extensions.formautofill.creditCards.enabled" = false;
        "extensions.formautofill.heuristics.enabled" = false;
        "signon.formlessCapture.enabled" = false;
        "network.auth.subresource-http-auth-allow" = 1;
        "gfx.webrender.all" = true;
        "media.ffmpeg.vaapi.enabled" = true;
        "widget.dmabuf.force-enabled" = true;
        "webgl.enable-debug-renderer-info" = false;
        "network.http.speculative-parallel-limit" = 0;

        "widget.use-xdg-desktop-portal.file-picker" = 1;
      };

      extraConfig = ''
        user_pref("browser.theme.content-theme", 0);
        user_pref("browser.theme.toolbar-theme", 0);
        user_pref("toolkit.legacyUserProfileCustomizations.stylesheets", true);
        user_pref("full-screen-api.warning.timeout", 0);
        user_pref("media.hardware-video-decoding.enabled", true);
        user_pref("media.hardware-video-decoding.force-enabled", true);
        user_pref("media.ffmpeg.vaapi.enabled", true);
        user_pref("media.rdd-vpx.enabled", true);
        user_pref("apz.overscroll.enabled", true);
        user_pref("browser.shell.checkDefaultBrowser", false);
        user_pref("privacy.resistFingerprinting", false);
        user_pref("ui.systemUsesDarkTheme", 1);
        user_pref("browser.translations.automaticallyPopup", false);

        user_pref("apz.gtk.kinetic_scroll.enabled", true);

        user_pref("browser.bookmarks.defaultLocation", "toolbar");
        user_pref("browser.toolbars.bookmarks.visibility", "always");

        user_pref("browser.tabs.loadBookmarksInTabs", true);
      '';

      bookmarks = {
        force = true;
        settings = [
          {
            name = "toolbar";
            toolbar = true;
            bookmarks = [
              {
                name = "PlayNix";
                tags = [ "playnix" ];
                keyword = "playnix";
                url = "https://github.com/Mag1cByt3s/PlayNix";
              }
              {
                name = "NixOS";
                bookmarks = [
                  {
                    name = "Package Search";
                    tags = [ "nixos" ];
                    keyword = "nixos";
                    url = "https://search.nixos.org/packages?channel=unstable";
                  }
                  {
                    name = "Option Search";
                    tags = [ "nixos" ];
                    keyword = "nixos";
                    url = "https://search.nixos.org/options?channel=unstable";
                  }
                  {
                    name = "Nix package versions";
                    tags = [ "nixos" ];
                    keyword = "nixos";
                    url = "https://lazamar.co.uk/nix-versions/";
                  }
                  {
                    name = "Chaotic's Nyx";
                    tags = [ "nixos" ];
                    keyword = "nixos";
                    url = "https://www.nyx.chaotic.cx/";
                  }
                  {
                    name = "NUR";
                    tags = [ "nixos" ];
                    keyword = "nixos";
                    url = "https://nur.nix-community.org/";
                  }
                  {
                    name = "Noogle";
                    tags = [ "nixos" ];
                    keyword = "nixos";
                    url = "https://noogle.dev/";
                  }
                  {
                    name = "Home Manager Options";
                    tags = [ "homemanager" ];
                    keyword = "homemanager";
                    url = "https://home-manager-options.extranix.com/";
                  }
                  {
                    name = "NixOS & Flakes Book";
                    tags = [ "nixos" ];
                    keyword = "nixos";
                    url = "https://nixos-and-flakes.thiscute.world/introduction/";
                  }
                  {
                    name = "Nix Pills";
                    tags = [ "nix" ];
                    keyword = "nix";
                    url = "https://nixos.org/guides/nix-pills/";
                  }
                  {
                    name = "Zero to Nix";
                    tags = [ "nix" ];
                    keyword = "nix";
                    url = "https://zero-to-nix.com/";
                  }
                  {
                    name = "nix.dev";
                    tags = [ "nix" ];
                    keyword = "nix";
                    url = "https://nix.dev/";
                  }
                  {
                    name = "Wombat's Book of Nix";
                    tags = [ "nix" ];
                    keyword = "nix";
                    url = "https://mhwombat.codeberg.page/nix-book/";
                  }
                  {
                    name = "Plasma-Manager Options";
                    tags = [ "nix" ];
                    keyword = "nix";
                    url = "https://nix-community.github.io/plasma-manager/options.xhtml";
                  }
                ];
              }
              {
                name = "AI";
                bookmarks = [
                  {
                    name = "ChatGPT";
                    tags = [ "chatgpt" ];
                    keyword = "chatgpt";
                    url = "https://chatgpt.com";
                  }
                ];
              }
              {
                name = "Git";
                bookmarks = [
                  {
                    name = "GitHub";
                    tags = [ "github" ];
                    keyword = "github";
                    url = "https://github.com";
                  }
                  {
                    name = "GitLab";
                    tags = [ "gitlab" ];
                    keyword = "gitlab";
                    url = "https://gitlab.com";
                  }
                  {
                    name = "Codeberg";
                    tags = [ "codeberg" ];
                    keyword = "codeberg";
                    url = "https://codeberg.org/";
                  }
                ];
              }
              {
                name = "Gaming";
                bookmarks = [
                  {
                    name = "NixOS Steam";
                    tags = [ "steam" ];
                    keyword = "steam";
                    url = "https://nixos.wiki/wiki/Steam";
                  }
                  {
                    name = "Gaming on NixOS!";
                    tags = [ "gaming" ];
                    keyword = "gaming";
                    url = "https://medium.com/@notquitethereyet_/gaming-on-nixos-️-f98506351a24";
                  }
                ];
              }
            ];
          }
        ];
      };
    };

    policies = {
      
      ## to find the correct GUID of an extension go to https://addons.mozilla.org/, open any extension page, view the page source code and search for "guid", then use this value for the extension name.
      ExtensionSettings = {
        "addon@darkreader.org" = {
          install_url = "https://addons.mozilla.org/firefox/downloads/latest/darkreader/latest.xpi";
          installation_mode = "force_installed";
          default_area = "navbar";
        };
        "{446900e4-71c2-419f-a6a7-df9c091e268b}" = {
          install_url = "https://addons.mozilla.org/firefox/downloads/latest/bitwarden-password-manager/latest.xpi";
          installation_mode = "force_installed";
          default_area = "navbar";
        };
        "uBlock0@raymondhill.net" = {
          install_url = "https://addons.mozilla.org/firefox/downloads/latest/ublock-origin/latest.xpi";
          installation_mode = "force_installed";
          default_area = "navbar";
        };
        "simple-translate@sienori" = {
          install_url = "https://addons.mozilla.org/firefox/downloads/latest/simple-translate/latest.xpi";
          installation_mode = "force_installed";
          default_area = "navbar";
        };
        "default-compact-dark-theme@glitchii.github.io" = {
          install_url = "https://addons.mozilla.org/firefox/downloads/latest/default-compact-dark-theme/latest.xpi";
          installation_mode = "force_installed";
        };
      };
    };

      # extraConfig = '' ''; # user.js
      # userChrome = '' ''; # chrome CSS
      # userContent = '' ''; # content CSS
  };

}
