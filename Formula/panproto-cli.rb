class PanprotoCli < Formula
  desc "Schematic version control CLI for panproto"
  homepage "https://github.com/panproto/panproto"
  version "0.74.4"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/panproto/panproto/releases/download/v0.74.4/panproto-cli-aarch64-apple-darwin.tar.xz"
      sha256 "8649f13dafb5cd7854f81356a5cd30f39865406d303d090366ea49661095a4d9"
    end
    if Hardware::CPU.intel?
      url "https://github.com/panproto/panproto/releases/download/v0.74.4/panproto-cli-x86_64-apple-darwin.tar.xz"
      sha256 "26e9f5a689ded905794b5bc38624dd7c68faf7464d7c11abdae5c2c42f725a84"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/panproto/panproto/releases/download/v0.74.4/panproto-cli-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "faf2e2cab0f9684c302e9d88a24d6304a0cca722ad1cfedfdb2206e38d334657"
    end
    if Hardware::CPU.intel?
      url "https://github.com/panproto/panproto/releases/download/v0.74.4/panproto-cli-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "255c9e489c32de96154be9e0280d8638a427d41cf09404178ae9ade6e862826d"
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
