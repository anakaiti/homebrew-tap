class Gcloud < Formula
  desc "Command-line tool for managing Google Cloud resources"
  homepage "https://cloud.google.com/sdk"
  url "https://dl.google.com/dl/cloudsdk/channels/rapid/downloads/google-cloud-cli-linux-x86_64.tar.gz"
  sha256 "e516d3d6a7f74dab32a7f4112f273584bf2314df3299d32babad67cb6fa14a93"
  license "Apache-2.0"

  depends_on "python@3.12"

  def install
    (buildpath/".install").write "n"
    system "./google-cloud-sdk/install.sh",
           "--quiet",
           "--path-update", "false",
           "--command-completion", "false",
           "--usage-reporting", "false",
           "--install-dir", prefix

    bin.mkpath
    (prefix/"google-cloud-sdk/bin").find.each do |f|
      if f.file? && f.executable?
        binname = File.basename(f)
        bin.install_symlink prefix/"google-cloud-sdk/bin" => binname
      end
    end
  end

  test do
    assert_match "gcloud", shell_output("#{bin}/gcloud --version")
    assert_match "gsutil", shell_output("#{bin}/gsutil --version")
  end
end
