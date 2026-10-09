class PanprotoGitRemote < Formula
  desc "Git remote helper for panproto:// URLs (enables git push/pull/clone via panproto)"
  homepage "https://github.com/panproto/panproto"
  version "0.75.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/panproto/panproto/releases/download/v0.75.0/panproto-git-remote-aarch64-apple-darwin.tar.xz"
      sha256 "15cd811d98b0ccf6fe7e4542e4872350d0d099c634ccb827f24c50a761fe691e"
    end
    if Hardware::CPU.intel?
      url "https://github.com/panproto/panproto/releases/download/v0.75.0/panproto-git-remote-x86_64-apple-darwin.tar.xz"
      sha256 "6e7795c5ca1d69011243174cc7568181975cf8f6e4f48b7024dee999e9b9e04d"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/panproto/panproto/releases/download/v0.75.0/panproto-git-remote-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "14424e60b89b0c5c3ca1181e3e802410efa4803df004d6eef7ebac8c30c29e05"
    end
    if Hardware::CPU.intel?
      url "https://github.com/panproto/panproto/releases/download/v0.75.0/panproto-git-remote-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "9211ea02850ac0c4dd7c1d8340536f346a8653325e27f70ba9766a701cc165c4"
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
    if OS.mac? && Hardware::CPU.arm?
      bin.install "git-remote-panproto"
    end
    if OS.mac? && Hardware::CPU.intel?
      bin.install "git-remote-panproto"
    end
    if OS.linux? && Hardware::CPU.arm?
      bin.install "git-remote-panproto"
    end
    if OS.linux? && Hardware::CPU.intel?
      bin.install "git-remote-panproto"
    end

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
