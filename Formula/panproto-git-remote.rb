class PanprotoGitRemote < Formula
  desc "Git remote helper for panproto:// URLs (enables git push/pull/clone via panproto)"
  homepage "https://github.com/panproto/panproto"
  version "0.59.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/panproto/panproto/releases/download/v0.59.0/panproto-git-remote-aarch64-apple-darwin.tar.xz"
      sha256 "600c5d4cc619d9cb450c16802eb83cf85e130d720f1bf5b86fc6bebe9495044b"
    end
    if Hardware::CPU.intel?
      url "https://github.com/panproto/panproto/releases/download/v0.59.0/panproto-git-remote-x86_64-apple-darwin.tar.xz"
      sha256 "ceb94c9a9b203d9bbbdcaf5073a2cd4bef94f112b0db286bd589c927d05285f6"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/panproto/panproto/releases/download/v0.59.0/panproto-git-remote-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "02fa74a39c213aeaa4cdaee926c9a0e5ea0bfc807b59032ab09a190551871569"
    end
    if Hardware::CPU.intel?
      url "https://github.com/panproto/panproto/releases/download/v0.59.0/panproto-git-remote-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "96366e6072e57ab5cdd5760cca2954966f9d7b9de2a3376dd1ab9137eaa0249e"
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
