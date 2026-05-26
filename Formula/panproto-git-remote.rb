class PanprotoGitRemote < Formula
  desc "Git remote helper for panproto:// URLs (enables git push/pull/clone via panproto)"
  homepage "https://github.com/panproto/panproto"
  version "0.50.6"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/panproto/panproto/releases/download/v0.50.6/panproto-git-remote-aarch64-apple-darwin.tar.xz"
      sha256 "d8b943a24411b3114153c1e8120789c5c0ddaaac1fcfdd42663a65685cad91a3"
    end
    if Hardware::CPU.intel?
      url "https://github.com/panproto/panproto/releases/download/v0.50.6/panproto-git-remote-x86_64-apple-darwin.tar.xz"
      sha256 "e5c8ed6c28309f556b78c5dcfc6618db5a6e7ff88ac195217c7ee7ba57057308"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/panproto/panproto/releases/download/v0.50.6/panproto-git-remote-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "e62c5ac1013c9aeac76b46e678db8499ed3ef4113dbead3ac95e4db17fb6692f"
    end
    if Hardware::CPU.intel?
      url "https://github.com/panproto/panproto/releases/download/v0.50.6/panproto-git-remote-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "b1e3cdc77593ab4f7bf43b579a360abfd5b972ba0b3e3cd3f168731b98a9109b"
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
    bin.install "git-remote-panproto" if OS.mac? && Hardware::CPU.arm?
    bin.install "git-remote-panproto" if OS.mac? && Hardware::CPU.intel?
    bin.install "git-remote-panproto" if OS.linux? && Hardware::CPU.arm?
    bin.install "git-remote-panproto" if OS.linux? && Hardware::CPU.intel?

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
