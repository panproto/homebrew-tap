class PanprotoGitRemote < Formula
  desc "Git remote helper for panproto:// URLs (enables git push/pull/clone via panproto)"
  homepage "https://github.com/panproto/panproto"
  version "0.70.1"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/panproto/panproto/releases/download/v0.70.1/panproto-git-remote-aarch64-apple-darwin.tar.xz"
      sha256 "12e898039f0f51f6745cb1c39420472fcc0d564e7d275727d67fa334f5b9d165"
    end
    if Hardware::CPU.intel?
      url "https://github.com/panproto/panproto/releases/download/v0.70.1/panproto-git-remote-x86_64-apple-darwin.tar.xz"
      sha256 "fbce9aa32bfb95aa933ca7327d6947b94ce8e7f96f3572c07bf68f3f1f39cb79"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/panproto/panproto/releases/download/v0.70.1/panproto-git-remote-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "6210d8a043b94d52d423da29128d91d685c2832c796177df1a3bed9da6c80a33"
    end
    if Hardware::CPU.intel?
      url "https://github.com/panproto/panproto/releases/download/v0.70.1/panproto-git-remote-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "e25291ae4c99b54ecfa22dd1a144b5d4f60674a60320a26bbe4231a7f519ff0a"
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
      bin.install "git-remote-panproto"
    end
    if OS.mac? && Hardware::CPU.intel?
      bin.install "git-remote-panproto"
    end
    if OS.linux? && Hardware::CPU.arm?
      bin.install "git-remote-panproto"
    end
    if OS.linux? && Hardware::CPU.intel?
      bin.install "git-remote-panproto"
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
