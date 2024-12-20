class Youtubedr < Formula
  desc "Download Youtube Video in Golang"
  homepage "https://github.com/kkdai/youtube"
  url "https://github.com/kkdai/youtube/archive/refs/tags/v2.10.2.tar.gz"
  sha256 "7c8f8875fbf47110782e4ebd24dd70e3bb277cf25a7802d89fe4ca00d684e1d1"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "3662c7e71b59b9f4478005258f321f194a5af87299bbe15e04cfbdd45d0e1a6a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "bf51ce334055c76a3e088792bdb2afb76b93f80c0a62f999632963c26dc05081"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "bf51ce334055c76a3e088792bdb2afb76b93f80c0a62f999632963c26dc05081"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "bf51ce334055c76a3e088792bdb2afb76b93f80c0a62f999632963c26dc05081"
    sha256 cellar: :any_skip_relocation, sonoma:         "71a9b739954a568539ae25e32bfe3433273860f91e39d63d476c9d49d2848ac5"
    sha256 cellar: :any_skip_relocation, ventura:        "71a9b739954a568539ae25e32bfe3433273860f91e39d63d476c9d49d2848ac5"
    sha256 cellar: :any_skip_relocation, monterey:       "71a9b739954a568539ae25e32bfe3433273860f91e39d63d476c9d49d2848ac5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "efab440af5b55fa6c5865fc2972b2be741f6e213395591b600bfa3e47475fa85"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.version=#{version} -X main.date=#{time.iso8601}"
    system "go", "build", *std_go_args(ldflags:), "./cmd/youtubedr"

    generate_completions_from_executable(bin/"youtubedr", "completion")
  end

  test do
    version_output = pipe_output("#{bin}/youtubedr version").split("\n")
    assert_match(/Version:\s+#{version}/, version_output[0])

    # Fails in Linux CI with "can't bypass age restriction: login required"
    return if OS.linux? && ENV["HOMEBREW_GITHUB_ACTIONS"]

    info_output = pipe_output("#{bin}/youtubedr info https://www.youtube.com/watch?v=pOtd1cbOP7k").split("\n")
    assert_match "Title:       History of homebrew-core", info_output[0]
    assert_match "Author:      Rui Chen", info_output[1]
    assert_match "Duration:    13m15s", info_output[2]
  end
end
