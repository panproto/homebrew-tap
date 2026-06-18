class PanprotoCli < Formula
  desc "Schematic version control CLI for panproto"
  homepage "https://github.com/panproto/panproto"
  version "0.56.1"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/panproto/panproto/releases/download/v0.56.1/panproto-cli-aarch64-apple-darwin.tar.xz"
      sha256 "0c3d204c040d27880586b43fd8161ec98e4c1dd246aa3a0eeddba8fff724caf9"
    end
    if Hardware::CPU.intel?
      url "https://github.com/panproto/panproto/releases/download/v0.56.1/panproto-cli-x86_64-apple-darwin.tar.xz"
      sha256 "3720bd28361669fe6257b06d763e7ec7e3924fea048c434faa0f5704c523c1a3"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/panproto/panproto/releases/download/v0.56.1/panproto-cli-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "d2f13a660124b1e25f45e627857dc853b19f494efc293040e6e2aaad28701af1"
    end
    if Hardware::CPU.intel?
      url "https://github.com/panproto/panproto/releases/download/v0.56.1/panproto-cli-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "4ba56f21776fa0c25850dfaecf7b79f49cf16e81c1910c12459f15b2d1cf59da"
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
