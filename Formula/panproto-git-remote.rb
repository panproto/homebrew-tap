class PanprotoGitRemote < Formula
  desc "Git remote helper for panproto:// URLs (enables git push/pull/clone via panproto)"
  homepage "https://github.com/panproto/panproto"
  version "0.69.1"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/panproto/panproto/releases/download/v0.69.1/panproto-git-remote-aarch64-apple-darwin.tar.xz"
      sha256 "ef3c23b15cecd08c4251164f643571fc278ff7f108a2a9a1a81b612fad1f3e4e"
    end
    if Hardware::CPU.intel?
      url "https://github.com/panproto/panproto/releases/download/v0.69.1/panproto-git-remote-x86_64-apple-darwin.tar.xz"
      sha256 "fdb73dfa0e03ce1d2b16dbebd7001ed84fdaeebd809b66e39ad0278cc7624701"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/panproto/panproto/releases/download/v0.69.1/panproto-git-remote-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "38f9de71c24858308cfbe9265ef147270946dc855f1dcdf8ece0107e9404bb34"
    end
    if Hardware::CPU.intel?
      url "https://github.com/panproto/panproto/releases/download/v0.69.1/panproto-git-remote-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "c536525886b2c42b4e4b21613273808c04888f67a7864549de189aa55cad492f"
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
