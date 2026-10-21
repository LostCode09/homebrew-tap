cask "centella" do
  version "0.2.0"
  sha256 "85d97acbb758d3ae3853851a06394f38a7b6c6dafd09b6b5f4109fa69c6b922a"

  url "https://github.com/LostCode09/centella-releases/releases/download/v#{version}/Centella-#{version}.dmg"
  name "Centella"
  desc "VPN client based on sing-box and Xray"
  homepage "https://github.com/LostCode09/centella-releases"

  depends_on arch: :arm64
  depends_on macos: :sequoia

  app "Centella.app"

  # Quitting first lets Centella disconnect, which restores DNS and the proxy settings;
  # then the privileged helper and its kill switch rules are removed.
  uninstall quit:   "io.github.centella.mac",
            script: {
              executable: "/bin/sh",
              args:       [
                "-c",
                "launchctl bootout system/io.github.centella.helper 2>/dev/null; " \
                "pfctl -a com.apple/centella -F rules 2>/dev/null; true",
              ],
              sudo:       true,
            },
            delete: [
              "/Library/LaunchDaemons/io.github.centella.helper.plist",
              "/Library/PrivilegedHelperTools/io.github.centella.helper",
              "/Library/PrivilegedHelperTools/io.github.centella.sing-box",
            ]

  zap delete: "/Library/Application Support/Centella Helper",
      trash:  [
        "~/Library/Application Support/Centella",
        "~/Library/Preferences/io.github.centella.mac.plist",
      ]

  caveats <<~EOS
    Centella is not signed with an Apple Developer ID. On first launch open
    System Settings → Privacy & Security and click "Open Anyway" for Centella.
  EOS
end
