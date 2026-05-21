class PanprotoGitRemote < Formula
  desc "Git remote helper for panproto:// URLs (enables git push/pull/clone via panproto)"
  homepage "https://github.com/panproto/panproto"
  version "0.48.6"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/panproto/panproto/releases/download/v0.48.6/panproto-git-remote-aarch64-apple-darwin.tar.xz"
      sha256 "0201b12404a391341558a0de127213084aebcf81bcc405a0c1192da311ab0387"
    end
    if Hardware::CPU.intel?
      url "https://github.com/panproto/panproto/releases/download/v0.48.6/panproto-git-remote-x86_64-apple-darwin.tar.xz"
      sha256 "dfa63655bed6a1e24019fbfa5c0f66c7c982410b39158bd28d634a1807fc14a6"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/panproto/panproto/releases/download/v0.48.6/panproto-git-remote-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "efeaafe4a47f81bd4d8d1daa79285bf8e67298d661e197825b02f6fb4c1451fd"
    end
    if Hardware::CPU.intel?
      url "https://github.com/panproto/panproto/releases/download/v0.48.6/panproto-git-remote-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "b43cf08c5916c41287bbcfa7fd49223de478a9196ed3708fe9dd456f6097eaa2"
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
