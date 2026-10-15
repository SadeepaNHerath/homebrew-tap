class Sf < Formula
  desc "Terminal-first macOS maintenance, app uninstaller, and disk analysis toolkit"
  homepage "https://github.com/SadeepaNHerath/Sift"
  license "MIT"
  head "https://github.com/SadeepaNHerath/Sift.git", branch: "main"

  depends_on "go" => :build if build.head?
  depends_on :macos

  on_macos do
    on_arm do
      url "https://github.com/SadeepaNHerath/Sift/releases/download/v2.3.0/Sift_2.3.0_darwin_arm64.tar.gz"
      sha256 "e234b2cddcd73d73531219d1cb7b851ab4ff95f5a4f6ab9eaeb4fc3b8bbddbfb"
    end
    on_intel do
      url "https://github.com/SadeepaNHerath/Sift/releases/download/v2.3.0/Sift_2.3.0_darwin_amd64.tar.gz"
      sha256 "8a5075bb9c12a2842df959840f75eca790f9c613805603c2279320102999fc77"
    end
  end

  def install
    if build.head?
      system "go", "build", *std_go_args(ldflags: "-s -w -X main.version=v#{version}"), "./cmd/sf"
    else
      bin.install "sf"
    end

    generate_completions_from_executable(bin/"sf", "completion")
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
    assert_match "Sift (sf)", shell_output("#{bin}/sf --help")
  end
end
