class Sift < Formula
  desc "Terminal-first macOS maintenance, app uninstaller, and disk analysis toolkit"
  homepage "https://github.com/SadeepaNHerath/Sift"
  url "https://github.com/SadeepaNHerath/Sift/archive/refs/tags/v2.3.0.tar.gz"
  sha256 "692fc1ead96e069352e86eae15479ffc75f17d6d1928a9a9f91faea11d058a6c"
  license "MIT"
  head "https://github.com/SadeepaNHerath/Sift.git", branch: "main"

  depends_on "go" => :build
  depends_on :macos

  conflicts_with "sf", because: "both install an 'sf' binary"

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.version=v#{version}"), "./cmd/sf"
    bin.install_symlink bin/"sift" => "sf"

    generate_completions_from_executable(bin/"sift", "completion")
  end

  def caveats
    <<~EOS
      Sift (sf) requires non-root user execution. Never run with sudo sf.
      Elevate privileges with Touch ID via:
        sf touchid enable

      If 'sf --version' still shows an older version after upgrading, an older
      binary (e.g. from an earlier curl install) in ~/.local/bin may be shadowing Homebrew:
        which -a sf
        rm -f ~/.local/bin/sf
    EOS
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/sift --version")
    assert_match "Sift (sf)", shell_output("#{bin}/sf --help")
  end
end
