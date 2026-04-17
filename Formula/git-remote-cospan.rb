class GitRemoteCospan < Formula
  desc "Git remote helper for cospan:// URLs (enables git push/pull/clone via panproto)"
  homepage "https://github.com/panproto/panproto"
  version "0.33.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/panproto/panproto/releases/download/v0.33.0/git-remote-cospan-aarch64-apple-darwin.tar.xz"
      sha256 "241b86e6948cd51b1ef5c2bbf577d5b3a01015d8298382c3e4d97a9abc452a9b"
    end
    if Hardware::CPU.intel?
      url "https://github.com/panproto/panproto/releases/download/v0.33.0/git-remote-cospan-x86_64-apple-darwin.tar.xz"
      sha256 "7b982d1db3d5c009d2f7242df5a36c17797f5420a9c7b40d7d8f4273c389b5f2"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/panproto/panproto/releases/download/v0.33.0/git-remote-cospan-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "64e363344a06194230741e8084518028f88899657f29af58bfbbd5a5e5f8181a"
    end
    if Hardware::CPU.intel?
      url "https://github.com/panproto/panproto/releases/download/v0.33.0/git-remote-cospan-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "b70b626e0af3bdca56558acadad54e1fa413750560d7442baaa92370d5afa756"
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
