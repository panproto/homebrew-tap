class PanprotoRepl < Formula
  desc "Interactive REPL for panproto theories, terms, and morphisms."
  homepage "https://github.com/panproto/panproto"
  version "0.38.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/panproto/panproto/releases/download/v0.38.0/panproto-repl-aarch64-apple-darwin.tar.xz"
      sha256 "d2ebf3538fa7101a224cc6665b4e5d6f84f66ad6acdc1117609613578a2ff006"
    end
    if Hardware::CPU.intel?
      url "https://github.com/panproto/panproto/releases/download/v0.38.0/panproto-repl-x86_64-apple-darwin.tar.xz"
      sha256 "802b8bb00d3d256353999230b12ee0d61da658fbf1250f642d56cf0faea289b8"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/panproto/panproto/releases/download/v0.38.0/panproto-repl-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "c128b5dbac1bc1ed596a520d91b1a48bf9950006af6b8804bc8aeb66973f0fdb"
    end
    if Hardware::CPU.intel?
      url "https://github.com/panproto/panproto/releases/download/v0.38.0/panproto-repl-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "d0138d51464b1b82691ed5f88c23995dc8d8b29e20a4ba4158cbeebff1b5a13f"
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
    bin.install "panproto-repl" if OS.mac? && Hardware::CPU.arm?
    bin.install "panproto-repl" if OS.mac? && Hardware::CPU.intel?
    bin.install "panproto-repl" if OS.linux? && Hardware::CPU.arm?
    bin.install "panproto-repl" if OS.linux? && Hardware::CPU.intel?

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
