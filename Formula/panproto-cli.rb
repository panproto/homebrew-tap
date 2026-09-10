class PanprotoCli < Formula
  desc "Schematic version control CLI for panproto"
  homepage "https://github.com/panproto/panproto"
  version "0.74.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/panproto/panproto/releases/download/v0.74.0/panproto-cli-aarch64-apple-darwin.tar.xz"
      sha256 "2422c46afc96a8e975c6d1ff667c78cba7d7e9aad3e55b642bd853576fe75b62"
    end
    if Hardware::CPU.intel?
      url "https://github.com/panproto/panproto/releases/download/v0.74.0/panproto-cli-x86_64-apple-darwin.tar.xz"
      sha256 "5cc4ac64121d0d27d1c4a77676990674a026b3b6de6f5ee42ee4a5224d78856f"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/panproto/panproto/releases/download/v0.74.0/panproto-cli-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "1836d1b9468140e3bb2a78035f3a3efa7cab274ffaa73d2737228c142e365bd8"
    end
    if Hardware::CPU.intel?
      url "https://github.com/panproto/panproto/releases/download/v0.74.0/panproto-cli-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "721dd9ef149c055308dbe84728457b020bb98eb9ab42c426a103492d9fd70119"
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
