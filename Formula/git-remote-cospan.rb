class GitRemoteCospan < Formula
  desc "Git remote helper for cospan:// URLs (enables git push/pull/clone via panproto)"
  homepage "https://github.com/panproto/panproto"
  version "0.31.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/panproto/panproto/releases/download/v0.31.0/git-remote-cospan-aarch64-apple-darwin.tar.xz"
      sha256 "3620231a575009c510f9a663346b684269abacc031d2485faf9c5be5f68db7c5"
    end
    if Hardware::CPU.intel?
      url "https://github.com/panproto/panproto/releases/download/v0.31.0/git-remote-cospan-x86_64-apple-darwin.tar.xz"
      sha256 "96305146bf60f52b7689aac4ab3e91ae3d787ab2174cd287ba77f04c8d9bb7a4"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/panproto/panproto/releases/download/v0.31.0/git-remote-cospan-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "984211f311e5c3024c38b506c746399919a5d757dc9673a44f50eed9ef908802"
    end
    if Hardware::CPU.intel?
      url "https://github.com/panproto/panproto/releases/download/v0.31.0/git-remote-cospan-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "e288db0554bf0f38026475490b779471a018780a25d8096892c76b83d3ad2cef"
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
