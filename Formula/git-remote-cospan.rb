class GitRemoteCospan < Formula
  desc "Git remote helper for cospan:// URLs (enables git push/pull/clone via panproto)"
  homepage "https://github.com/panproto/panproto"
  version "0.29.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/panproto/panproto/releases/download/v0.29.0/git-remote-cospan-aarch64-apple-darwin.tar.xz"
      sha256 "0af7e4c38b44f115319efe5f09c2606d6457e4e682c9e12f19037accbc143dd5"
    end
    if Hardware::CPU.intel?
      url "https://github.com/panproto/panproto/releases/download/v0.29.0/git-remote-cospan-x86_64-apple-darwin.tar.xz"
      sha256 "883ee5a3c23eb158affab61b6473538194fb8d7b39f096f5ec99a9189ba0f370"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/panproto/panproto/releases/download/v0.29.0/git-remote-cospan-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "11bfbb1c09efacf16b5151162f8dbbdf93d9ca1af4b52ac09be26a3189226703"
    end
    if Hardware::CPU.intel?
      url "https://github.com/panproto/panproto/releases/download/v0.29.0/git-remote-cospan-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "1c42c4f41dc675a0e3c0768e204585e3d641e503e96b6577360344d58b7e8af5"
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
