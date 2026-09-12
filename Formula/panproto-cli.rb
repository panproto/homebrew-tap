class PanprotoCli < Formula
  desc "Schematic version control CLI for panproto"
  homepage "https://github.com/panproto/panproto"
  version "0.74.2"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/panproto/panproto/releases/download/v0.74.2/panproto-cli-aarch64-apple-darwin.tar.xz"
      sha256 "76af1dff5c9d7eda62644ca899bc808788b13671b3dccb94aeaf9c0ddd48ac7a"
    end
    if Hardware::CPU.intel?
      url "https://github.com/panproto/panproto/releases/download/v0.74.2/panproto-cli-x86_64-apple-darwin.tar.xz"
      sha256 "ff253418e052baf4160613c10627f736cc54d4762a366181763a96cc0ef46ecc"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/panproto/panproto/releases/download/v0.74.2/panproto-cli-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "6c14e4587ccdd1ea28990893dd7baba5434d06c3207564a1a9818ef73e23cdaa"
    end
    if Hardware::CPU.intel?
      url "https://github.com/panproto/panproto/releases/download/v0.74.2/panproto-cli-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "3f6b026c77ef4028dc591f2d80421f586423bac3bb84de89915b399a2733ca6d"
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
