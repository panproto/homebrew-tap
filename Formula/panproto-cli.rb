class PanprotoCli < Formula
  desc "Schematic version control CLI for panproto"
  homepage "https://github.com/panproto/panproto"
  version "0.68.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/panproto/panproto/releases/download/v0.68.0/panproto-cli-aarch64-apple-darwin.tar.xz"
      sha256 "6d5bb0f10329eca2798906d6d2c0f385eb83b9c9e19c87b6592bf0015a91dee8"
    end
    if Hardware::CPU.intel?
      url "https://github.com/panproto/panproto/releases/download/v0.68.0/panproto-cli-x86_64-apple-darwin.tar.xz"
      sha256 "295c36a4057641f5b4a3fe59e7022a776a830dbbb9f1bc3663e3ed5543a1f5f9"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/panproto/panproto/releases/download/v0.68.0/panproto-cli-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "4e252fa14039e2994e045f4e350211b3aed8bb1f901a05ec09efdfbffbdc0d0e"
    end
    if Hardware::CPU.intel?
      url "https://github.com/panproto/panproto/releases/download/v0.68.0/panproto-cli-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "192b2792822bd883cbc0aff5dc700cd6066e5205ecedcd780dd531b171adf150"
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
