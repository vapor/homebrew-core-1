class Talhelper < Formula
  desc "Configuration helper for talos clusters"
  homepage "https://budimanjojo.github.io/talhelper/latest/"
  url "https://github.com/budimanjojo/talhelper/archive/refs/tags/v3.0.7.tar.gz"
  sha256 "1abb6370414f41a1a725337d85dba483b5f393d6b702109d874cf4b16e7878b6"
  license "BSD-3-Clause"
  head "https://github.com/budimanjojo/talhelper.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "eb76bce7561e3c705c152f037f542b60f1e80665238aa8c8c297dc370a47bd65"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "eb76bce7561e3c705c152f037f542b60f1e80665238aa8c8c297dc370a47bd65"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "eb76bce7561e3c705c152f037f542b60f1e80665238aa8c8c297dc370a47bd65"
    sha256 cellar: :any_skip_relocation, sonoma:        "c1e3ab2479ec1e21a20273d8c16c3b145e84b0f690d182ec3270ad03b89cacbd"
    sha256 cellar: :any_skip_relocation, ventura:       "c1e3ab2479ec1e21a20273d8c16c3b145e84b0f690d182ec3270ad03b89cacbd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f67d0f71c0faab1dc48e57364702a665f23f1162fbe300de5600a1a1c7ecb8c6"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/budimanjojo/talhelper/v#{version.major}/cmd.version=#{version}"
    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin/"talhelper", "completion")
    pkgshare.install "example"
  end

  test do
    cp_r Dir["#{pkgshare}/example/*"], testpath

    output = shell_output("#{bin}/talhelper genconfig 2>&1", 1)
    assert_match "failed to load env file: trying to decrypt talenv.yaml with sops", output

    assert_match "cluster:", shell_output("#{bin}/talhelper gensecret")

    assert_match version.to_s, shell_output("#{bin}/talhelper --version")
  end
end
