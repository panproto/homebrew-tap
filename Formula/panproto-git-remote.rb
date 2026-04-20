class PanprotoGitRemote < Formula
  desc "Git remote helper for panproto:// URLs (enables git push/pull/clone via panproto)"
  homepage "https://github.com/panproto/panproto"
  version "0.35.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/panproto/panproto/releases/download/v0.35.0/panproto-git-remote-aarch64-apple-darwin.tar.xz"
      sha256 "42b7f5c698bdc2338db86026b1301ad6a71cc7a24435371de5f827522d019129"
    end
    if Hardware::CPU.intel?
      url "https://github.com/panproto/panproto/releases/download/v0.35.0/panproto-git-remote-x86_64-apple-darwin.tar.xz"
      sha256 "35bf21ade8da82dc004f17348b53b0ac04b9f2e6d8251e1d1558399b6baa9a2d"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/panproto/panproto/releases/download/v0.35.0/panproto-git-remote-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "8bc24dbc606b06257b64a0f729c7941275d2999864b8abc31f9975e94c2240a2"
    end
    if Hardware::CPU.intel?
      url "https://github.com/panproto/panproto/releases/download/v0.35.0/panproto-git-remote-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "aa3faa49a63f848598eea31a3991910f130ba1c22fd755a6b3690f513c07bdd6"
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
    bin.install "git-remote-panproto" if OS.mac? && Hardware::CPU.arm?
    bin.install "git-remote-panproto" if OS.mac? && Hardware::CPU.intel?
    bin.install "git-remote-panproto" if OS.linux? && Hardware::CPU.arm?
    bin.install "git-remote-panproto" if OS.linux? && Hardware::CPU.intel?

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
