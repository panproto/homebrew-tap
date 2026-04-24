class PanprotoGitRemote < Formula
  desc "Git remote helper for panproto:// URLs (enables git push/pull/clone via panproto)"
  homepage "https://github.com/panproto/panproto"
  version "0.37.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/panproto/panproto/releases/download/v0.37.0/panproto-git-remote-aarch64-apple-darwin.tar.xz"
      sha256 "7de7ae5c6550cf1bf1c3735f8e27928e4558ee15a9678a88a9bccac7269403cb"
    end
    if Hardware::CPU.intel?
      url "https://github.com/panproto/panproto/releases/download/v0.37.0/panproto-git-remote-x86_64-apple-darwin.tar.xz"
      sha256 "e4e35219d96f61952c470be8439cf4d41f55cf3a9ff02cf88b24501e9b3a9231"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/panproto/panproto/releases/download/v0.37.0/panproto-git-remote-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "d9c16bbda6f3b43b2d4873b0c10af235c520ed862ca866d6960dbee317860892"
    end
    if Hardware::CPU.intel?
      url "https://github.com/panproto/panproto/releases/download/v0.37.0/panproto-git-remote-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "0594dff9542dbe436952dd57bc7bd6566d748c1fe7bcdeae85b631b1e81d04fa"
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
