class PanprotoGitRemote < Formula
  desc "Git remote helper for panproto:// URLs (enables git push/pull/clone via panproto)"
  homepage "https://github.com/panproto/panproto"
  version "0.72.1"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/panproto/panproto/releases/download/v0.72.1/panproto-git-remote-aarch64-apple-darwin.tar.xz"
      sha256 "6ce64d09c94ecdb765ebc378c0a7a66d6a0647a0dfb9851da9dbb4a074046e6e"
    end
    if Hardware::CPU.intel?
      url "https://github.com/panproto/panproto/releases/download/v0.72.1/panproto-git-remote-x86_64-apple-darwin.tar.xz"
      sha256 "702113186acdbda6ed68bd981c406b8679ce44a940c45da695d81ffc41090241"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/panproto/panproto/releases/download/v0.72.1/panproto-git-remote-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "dce3bf2101f195e6f7b464e0a239596763c4b291eec300453d77ef8c0b5e3d5d"
    end
    if Hardware::CPU.intel?
      url "https://github.com/panproto/panproto/releases/download/v0.72.1/panproto-git-remote-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "4ea199c62265eb58228ea3a1ae0878c36076054bbf305b19d3ed19753d641c2d"
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
