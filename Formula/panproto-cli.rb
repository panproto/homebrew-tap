class PanprotoCli < Formula
  desc "Schematic version control CLI for panproto"
  homepage "https://github.com/panproto/panproto"
  version "0.52.1"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/panproto/panproto/releases/download/v0.52.1/panproto-cli-aarch64-apple-darwin.tar.xz"
      sha256 "ed0e9df81550332ad31742b061424c2d5b18763fe97ac6b2f84239772e8ce35d"
    end
    if Hardware::CPU.intel?
      url "https://github.com/panproto/panproto/releases/download/v0.52.1/panproto-cli-x86_64-apple-darwin.tar.xz"
      sha256 "3772f9876b4c286e39889a290487908453982d27a17ec83fb90e15d1cb71cf0b"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/panproto/panproto/releases/download/v0.52.1/panproto-cli-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "104bdd120bc3f576caaae7722d6315bee444d4925decad263f77fc82f36fb42f"
    end
    if Hardware::CPU.intel?
      url "https://github.com/panproto/panproto/releases/download/v0.52.1/panproto-cli-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "51c17f549f061f8f037889ff0ea16f4150295fc37e350a6cb90cccde90600bec"
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
