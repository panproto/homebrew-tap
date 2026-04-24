class PanprotoRepl < Formula
  desc "Interactive REPL for panproto theories, terms, and morphisms."
  homepage "https://github.com/panproto/panproto"
  version "0.37.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/panproto/panproto/releases/download/v0.37.0/panproto-repl-aarch64-apple-darwin.tar.xz"
      sha256 "007474d88f6517d69866e745250b3eae722d354f444bf228ec5f9cebabc48baa"
    end
    if Hardware::CPU.intel?
      url "https://github.com/panproto/panproto/releases/download/v0.37.0/panproto-repl-x86_64-apple-darwin.tar.xz"
      sha256 "d425e125521c8368ee6d9b04a8e27c0d30c5c86c43c7a5278936c2484a250f37"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/panproto/panproto/releases/download/v0.37.0/panproto-repl-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "8095e84cf2daf9f0a1e4cdb6536fec8ff6757e6ec735bfa3ab4765b1425c1bb2"
    end
    if Hardware::CPU.intel?
      url "https://github.com/panproto/panproto/releases/download/v0.37.0/panproto-repl-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "622cbcb3ef2765da67cb3fff3d54b951d58ecd6eff44352f343203be61c88f10"
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
