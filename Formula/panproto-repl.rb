class PanprotoRepl < Formula
  desc "Interactive REPL for panproto theories, terms, and morphisms."
  homepage "https://github.com/panproto/panproto"
  version "0.40.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/panproto/panproto/releases/download/v0.40.0/panproto-repl-aarch64-apple-darwin.tar.xz"
      sha256 "08a676745b14a4c4ac06e85be8433869d30704451df935ad75d37a013f97f8ed"
    end
    if Hardware::CPU.intel?
      url "https://github.com/panproto/panproto/releases/download/v0.40.0/panproto-repl-x86_64-apple-darwin.tar.xz"
      sha256 "e4c64da3e39bd00eeeec820169832aa796298b2beed0fab3a52bc81a23aa202d"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/panproto/panproto/releases/download/v0.40.0/panproto-repl-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "4160fe563daf95e50637299b25e0bfed0f8a7ecb7412b34763d8d0e1d1ed3964"
    end
    if Hardware::CPU.intel?
      url "https://github.com/panproto/panproto/releases/download/v0.40.0/panproto-repl-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "84c9f9f6898257a4281122ee86ac6c0d635937d31a90bb2cb89acfff9d4f35dd"
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
