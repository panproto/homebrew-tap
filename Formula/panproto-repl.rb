class PanprotoRepl < Formula
  desc "Interactive REPL for panproto theories, terms, and morphisms."
  homepage "https://github.com/panproto/panproto"
  version "0.39.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/panproto/panproto/releases/download/v0.39.0/panproto-repl-aarch64-apple-darwin.tar.xz"
      sha256 "276b69a6377017b1702d329428edeae59b2a77b83115d4be5415be21c5c609be"
    end
    if Hardware::CPU.intel?
      url "https://github.com/panproto/panproto/releases/download/v0.39.0/panproto-repl-x86_64-apple-darwin.tar.xz"
      sha256 "1017ce7ec671a31df378fdee92f960bf7de728eaf9a49af42e3c5cf99774d80d"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/panproto/panproto/releases/download/v0.39.0/panproto-repl-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "798f8d9a094dcaf98ee60a1bc5cfa02f61595533d225682130eaac284456f99b"
    end
    if Hardware::CPU.intel?
      url "https://github.com/panproto/panproto/releases/download/v0.39.0/panproto-repl-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "6983658d35c4d7ee9cb3d1b4b23157f823bbe0c05667af2b7f157bab75c235b8"
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
