class FernApi < Formula
  desc "Stripe-level SDKs and Docs for your API"
  homepage "https://buildwithfern.com/"
  url "https://registry.npmjs.org/fern-api/-/fern-api-0.56.20.tgz"
  sha256 "8a8ab7f87f324e6e4acd00c63b3ad98e79f37c00940beea8a378d8ca48d736f6"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "d355c9a3a89f57c2ff4d5fb6ee073df727a3697d024d3a2346cdd1b44a461d6a"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    system bin/"fern", "init", "--docs", "--org", "brewtest"
    assert_path_exists testpath/"fern/docs.yml"
    assert_match "\"organization\": \"brewtest\"", (testpath/"fern/fern.config.json").read

    system bin/"fern", "--version"
  end
end
