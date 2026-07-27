class PanprotoCli < Formula
  desc "Schematic version control CLI for panproto"
  homepage "https://github.com/panproto/panproto"
  version "0.67.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/panproto/panproto/releases/download/v0.67.0/panproto-cli-aarch64-apple-darwin.tar.xz"
      sha256 "96b83352ccf2d763b0fb5c0eea84efe656b1bb6c3bece6811fbcb804a2da6ad9"
    end
    if Hardware::CPU.intel?
      url "https://github.com/panproto/panproto/releases/download/v0.67.0/panproto-cli-x86_64-apple-darwin.tar.xz"
      sha256 "2b2e595a942f210d8b1a6692b246dd88631d97402182e45d3174ce0c78d7f1b5"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/panproto/panproto/releases/download/v0.67.0/panproto-cli-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "01623409a312a7bda2ad6428baed89757f416ee1dd8fcf5eff82a46445fa8b6e"
    end
    if Hardware::CPU.intel?
      url "https://github.com/panproto/panproto/releases/download/v0.67.0/panproto-cli-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "e7c050df924d81c128e3f4f11d998a2638681a7bb3a5361d93381d19cfe30214"
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
    bin.install "schema" if OS.mac? && Hardware::CPU.arm?
    bin.install "schema" if OS.mac? && Hardware::CPU.intel?
    bin.install "schema" if OS.linux? && Hardware::CPU.arm?
    bin.install "schema" if OS.linux? && Hardware::CPU.intel?

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
