class PanprotoCli < Formula
  desc "Schematic version control CLI for panproto"
  homepage "https://github.com/panproto/panproto"
  version "0.77.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/panproto/panproto/releases/download/v0.77.0/panproto-cli-aarch64-apple-darwin.tar.xz"
      sha256 "51f399804a3158222dae1579ebf753983d6fcd2777bd505839d14f5affe38761"
    end
    if Hardware::CPU.intel?
      url "https://github.com/panproto/panproto/releases/download/v0.77.0/panproto-cli-x86_64-apple-darwin.tar.xz"
      sha256 "c141d7a2fee1836def44c373764fcf3c53d71ba9d5004d56b7de5f5e965e7b02"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/panproto/panproto/releases/download/v0.77.0/panproto-cli-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "bda353d7797e767a134eb48ce6a27bbc5b3dd30f59e5ee914c54bb60ddae7867"
    end
    if Hardware::CPU.intel?
      url "https://github.com/panproto/panproto/releases/download/v0.77.0/panproto-cli-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "2163a27ec4ff69337328983a5557b4355f314e0af6fcf0f69d88c4c36b49937e"
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
