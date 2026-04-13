class GitRemoteCospan < Formula
  desc "Git remote helper for cospan:// URLs (enables git push/pull/clone via panproto)"
  homepage "https://github.com/panproto/panproto"
  version "0.29.1"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/panproto/panproto/releases/download/v0.29.1/git-remote-cospan-aarch64-apple-darwin.tar.xz"
      sha256 "47b48224b47619ed847863476cc4977fa8705eaae86f6caf5d34f707773e3ec3"
    end
    if Hardware::CPU.intel?
      url "https://github.com/panproto/panproto/releases/download/v0.29.1/git-remote-cospan-x86_64-apple-darwin.tar.xz"
      sha256 "0ea85d0ef95a9ad29a63029bccd6aa190b5ee28071ea3629f604b7cee44d2845"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/panproto/panproto/releases/download/v0.29.1/git-remote-cospan-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "9b1eceb42b8a8fb593445635cdb43ff8bff240b6350ea370233aeab1e8d90a15"
    end
    if Hardware::CPU.intel?
      url "https://github.com/panproto/panproto/releases/download/v0.29.1/git-remote-cospan-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "901d7e11b78a1bba6d2adc012273ff38d627f49a64917dedbee45348ae93d8e7"
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
    bin.install "git-remote-cospan" if OS.mac? && Hardware::CPU.arm?
    bin.install "git-remote-cospan" if OS.mac? && Hardware::CPU.intel?
    bin.install "git-remote-cospan" if OS.linux? && Hardware::CPU.arm?
    bin.install "git-remote-cospan" if OS.linux? && Hardware::CPU.intel?

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
