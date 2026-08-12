class PanprotoCli < Formula
  desc "Schematic version control CLI for panproto"
  homepage "https://github.com/panproto/panproto"
  version "0.70.1"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/panproto/panproto/releases/download/v0.70.1/panproto-cli-aarch64-apple-darwin.tar.xz"
      sha256 "38eac14415fb392e451bd6f2b4ee607214ee560c756fc72c1d5e3def9936bca5"
    end
    if Hardware::CPU.intel?
      url "https://github.com/panproto/panproto/releases/download/v0.70.1/panproto-cli-x86_64-apple-darwin.tar.xz"
      sha256 "50f71ad3c369ce46bffe4d97a95492151906b4770a68536b90b02727e62d3f34"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/panproto/panproto/releases/download/v0.70.1/panproto-cli-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "ae58e4eb7faab4d8419e623779f988c20c9c232846c9b98b25e6820141c39f30"
    end
    if Hardware::CPU.intel?
      url "https://github.com/panproto/panproto/releases/download/v0.70.1/panproto-cli-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "e135b85684612660d3169d360891caec262c0ee1dfa662f035698940dd068bbf"
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
      bin.install "schema"
    end
    if OS.mac? && Hardware::CPU.intel?
      bin.install "schema"
    end
    if OS.linux? && Hardware::CPU.arm?
      bin.install "schema"
    end
    if OS.linux? && Hardware::CPU.intel?
      bin.install "schema"
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
