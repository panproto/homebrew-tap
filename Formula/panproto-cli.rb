class PanprotoCli < Formula
  desc "Schematic version control CLI for panproto"
  homepage "https://github.com/panproto/panproto"
  version "0.42.1"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/panproto/panproto/releases/download/v0.42.1/panproto-cli-aarch64-apple-darwin.tar.xz"
      sha256 "6286e8911e2a459832b2370dfebfcdea853f77199a52100965c96f8123c2f46a"
    end
    if Hardware::CPU.intel?
      url "https://github.com/panproto/panproto/releases/download/v0.42.1/panproto-cli-x86_64-apple-darwin.tar.xz"
      sha256 "8701e5d4e2e6d0caf6c6462cf58100912f404935acd516f32439dffd515aaf8d"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/panproto/panproto/releases/download/v0.42.1/panproto-cli-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "afca54302f1d61e40c9ff77329f07cd3972a3524737d93de78b6bfd1eed396ad"
    end
    if Hardware::CPU.intel?
      url "https://github.com/panproto/panproto/releases/download/v0.42.1/panproto-cli-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "c6958af8ea9dea3734793eed3225fb4e67d5f70b621d53800bde4733b7b840dc"
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
