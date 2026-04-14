class GitRemoteCospan < Formula
  desc "Git remote helper for cospan:// URLs (enables git push/pull/clone via panproto)"
  homepage "https://github.com/panproto/panproto"
  version "0.30.1"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/panproto/panproto/releases/download/v0.30.1/git-remote-cospan-aarch64-apple-darwin.tar.xz"
      sha256 "2fa6c667f4af78fb0ba36ba7bb994a2d7b06f1eddf4031667baff76b7ba3e468"
    end
    if Hardware::CPU.intel?
      url "https://github.com/panproto/panproto/releases/download/v0.30.1/git-remote-cospan-x86_64-apple-darwin.tar.xz"
      sha256 "31f8aab88900e6dd41efc8380556c2a609ca5e55fc88162f686dd82978a99100"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/panproto/panproto/releases/download/v0.30.1/git-remote-cospan-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "3895252f4d6e50a641b5a87116fda5c29be4e784c5e56d863d6742da9921d872"
    end
    if Hardware::CPU.intel?
      url "https://github.com/panproto/panproto/releases/download/v0.30.1/git-remote-cospan-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "9b5a7923dcf3b9c11e22c2d979d708d73f0d4d5efc74d6975eaca6534df2accc"
    end
  end
  license "MIT"

  BINARY_ALIASES = {
    "aarch64-apple-darwin":               {},
    "aarch64-unknown-linux-gnu":          {},
    "aarch64-unknown-linux-musl-dynamic": {},
    "aarch64-unknown-linux-musl-static":  {},
    "x86_64-apple-darwin":                {},
    "x86_64-pc-windows-gnu":              {},
    "x86_64-unknown-linux-gnu":           {},
    "x86_64-unknown-linux-musl-dynamic":  {},
    "x86_64-unknown-linux-musl-static":   {},
  }.freeze

  def target_triple
    cpu = Hardware::CPU.arm? ? "aarch64" : "x86_64"
    os = OS.mac? ? "apple-darwin" : "unknown-linux-gnu"

    "#{cpu}-#{os}"
  end

  def install_binary_aliases!
    BINARY_ALIASES[target_triple.to_sym].each do |source, dests|
      dests.each do |dest|
        bin.install_symlink bin/source.to_s => dest
      end
    end
  end

  def install
    bin.install "git-remote-cospan" if OS.mac? && Hardware::CPU.arm?
    bin.install "git-remote-cospan" if OS.mac? && Hardware::CPU.intel?
    bin.install "git-remote-cospan" if OS.linux? && Hardware::CPU.arm?
    bin.install "git-remote-cospan" if OS.linux? && Hardware::CPU.intel?

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
