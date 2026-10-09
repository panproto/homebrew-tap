class PanprotoGitRemote < Formula
  desc "Git remote helper for panproto:// URLs (enables git push/pull/clone via panproto)"
  homepage "https://github.com/panproto/panproto"
  version "0.76.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/panproto/panproto/releases/download/v0.76.0/panproto-git-remote-aarch64-apple-darwin.tar.xz"
      sha256 "994f8c5ac07e716b5b5dafda01bf48c01fe73f466cca7245765351953fd9f0bd"
    end
    if Hardware::CPU.intel?
      url "https://github.com/panproto/panproto/releases/download/v0.76.0/panproto-git-remote-x86_64-apple-darwin.tar.xz"
      sha256 "2948b9d489c33bcda2e628471aa69f77c54d406ef7c49036bf4355456f562f76"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/panproto/panproto/releases/download/v0.76.0/panproto-git-remote-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "cdbb330a5a5b8dd55c3f7c622607b8621177685bbed3548e743d1730d7fb8635"
    end
    if Hardware::CPU.intel?
      url "https://github.com/panproto/panproto/releases/download/v0.76.0/panproto-git-remote-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "b46760632d572701f358711a421b523ee5cc0a3752db19505d0038ac54885b82"
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
