{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchzip,
  firefox-bin,
  buildNpmPackage,
  nodejs,
  makeWrapper,
  makeDesktopItem,
  copyDesktopItems,
  autoPatchelfHook,
  patchelf,
  linkFarm,
  makeFontsConf,
  alsa-lib,
  at-spi2-atk,
  atk,
  cairo,
  cups,
  dbus,
  expat,
  glib,
  libgbm,
  libgcc,
  libxkbcommon,
  nspr,
  nss,
  pango,
  systemd,
  libx11,
  libxcomposite,
  libxdamage,
  libxext,
  libxfixes,
  libxrandr,
  libxcb,
  libGL,
  vulkan-loader,
  pciutils,
}:
let
  revision = "1247";
  browserVersion = "155.0.8059.12";
  base = "https://cdn.playwright.dev/builds/cft/${browserVersion}/linux64";
  fonts = makeFontsConf { fontDirectories = [ ]; };
  browser =
    {
      name,
      archive,
      hash,
      directory,
      executable,
    }:
    stdenv.mkDerivation {
      pname = "playwright-${name}";
      version = browserVersion;
      src = fetchzip {
        url = "${base}/${archive}.zip";
        inherit hash;
      };
      nativeBuildInputs = [
        autoPatchelfHook
        patchelf
        makeWrapper
      ];
      buildInputs = [
        alsa-lib
        at-spi2-atk
        atk
        cairo
        cups
        dbus
        expat
        glib
        libgbm
        libgcc
        libxkbcommon
        nspr
        nss
        pango
        systemd
        libx11
        libxcomposite
        libxdamage
        libxext
        libxfixes
        libxrandr
        libxcb
        stdenv.cc.cc.lib
      ];
      appendRunpaths = lib.makeLibraryPath [
        libGL
        vulkan-loader
        pciutils
      ];
      installPhase = ''
        runHook preInstall
        mkdir -p "$out/${directory}"
        if [ -d "${directory}" ]; then
          cp -R "${directory}/." "$out/${directory}"
        else
          cp -R . "$out/${directory}"
        fi
        wrapProgram "$out/${directory}/${executable}" \
          --set-default SSL_CERT_FILE /etc/ssl/certs/ca-bundle.crt \
          --set-default FONTCONFIG_FILE ${fonts}
        runHook postInstall
      '';
      postFixup = ''
        if [ -e "$out/${directory}/libvulkan.so.1" ]; then
          rm "$out/${directory}/libvulkan.so.1"
          ln -s ${lib.getLib vulkan-loader}/lib/libvulkan.so.1 "$out/${directory}/libvulkan.so.1"
        fi
      '';
    };
  firefox = stdenv.mkDerivation {
    pname = "playwright-firefox";
    version = "156.0";
    src = fetchzip {
      url = "https://cdn.playwright.dev/dbazure/download/playwright/builds/firefox/1553/firefox-ubuntu-24.04.zip";
      hash = "sha256-1mDuphiBFmWsToHxSJ2AW1wKXxVoP9ZAOjtVTX22Eqo=";
    };
    inherit (firefox-bin.unwrapped)
      nativeBuildInputs
      buildInputs
      runtimeDependencies
      appendRunpaths
      patchelfFlags
      ;
    installPhase = ''
      runHook preInstall
      mkdir -p "$out/firefox"
      cp -R . "$out/firefox"
      runHook postInstall
    '';
  };
  browsers = linkFarm "playwright-cli-browsers" [
    {
      name = "firefox-1553";
      path = firefox;
    }
    {
      name = "chromium-${revision}";
      path = browser {
        name = "chromium";
        archive = "chrome-linux64";
        directory = "chrome-linux64";
        executable = "chrome";
        hash = "sha256-w90ze/7xfsSlR2TYOK8SBpdjXvZ7hGsozdIgTqt2c9Y=";
      };
    }
    {
      name = "chromium_headless_shell-${revision}";
      path = browser {
        name = "headless-shell";
        archive = "chrome-headless-shell-linux64";
        directory = "chrome-headless-shell-linux64";
        executable = "chrome-headless-shell";
        hash = "sha256-P9veFZJxNZLxMjrqRZrxoQzVkqYY9j6tct3WqFOa9RY=";
      };
    }
  ];
  desktopItem = makeDesktopItem {
    name = "playwright-cli-show";
    desktopName = "Playwright CLI Dashboard";
    comment = "Open the Playwright CLI browser dashboard";
    exec = "playwright-cli show";
    tryExec = "playwright-cli";
    icon = "web-browser";
    terminal = false;
    startupNotify = true;
    categories = [ "Development" "WebDevelopment" ];
    keywords = [ "browser" "automation" "testing" "playwright" ];
  };
in
assert stdenv.hostPlatform.system == "x86_64-linux";
buildNpmPackage {
  pname = "playwright-cli";
  version = "0.1.22";
  src = fetchFromGitHub {
    owner = "microsoft";
    repo = "playwright-cli";
    rev = "b85c7a736bb473bf55b584e54a09ffa698d6d871";
    hash = "sha256-80xzHvf7BHGvoKvMdkGeNUsUrpZrpw5eryuQM8NKT/E=";
  };
  npmDepsHash = "sha256-mGD7a/v1cx/xPGZo8nN3WA40mYGgF/KzMKiGbvUeX4E=";
  dontNpmBuild = true;
  nativeBuildInputs = [ makeWrapper copyDesktopItems ];
  desktopItems = [ desktopItem ];
  postInstall = ''
    cp ${./launcher.js} "$out/lib/node_modules/@playwright/cli/nix-launcher.js"
    rm "$out/bin/playwright-cli"
    makeWrapper ${nodejs}/bin/node "$out/bin/playwright-cli" \
      --add-flags "$out/lib/node_modules/@playwright/cli/nix-launcher.js" \
      --set-default PLAYWRIGHT_BROWSERS_PATH ${browsers}
  '';
  meta = {
    description = "Playwright command-line browser automation";
    homepage = "https://github.com/microsoft/playwright-cli";
    license = lib.licenses.asl20;
    platforms = [ "x86_64-linux" ];
    mainProgram = "playwright-cli";
  };
}
