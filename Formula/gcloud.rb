class Gcloud < Formula
  desc "Command-line tool for managing Google Cloud resources"
  homepage "https://cloud.google.com/sdk"
  url "https://dl.google.com/dl/cloudsdk/channels/rapid/downloads/google-cloud-cli-linux-x86_64.tar.gz"
  sha256 "e516d3d6a7f74dab32a7f4112f273584bf2314df3299d32babad67cb6fa14a93"
  license "Apache-2.0"

  depends_on "python@3.12"

  def install
    # The tarball extracts to buildpath which IS the google-cloud-sdk directory
    # Copy everything from buildpath to prefix/google-cloud-sdk
    cp_r buildpath, prefix

    # Run the install script from the parent directory
    # The install script calculates CLOUDSDK_ROOT_DIR based on script location
    google_cloud_sdk_root = prefix/"google-cloud-sdk"
    cd prefix do
      system "bash", "google-cloud-sdk/install.sh",
             "--quiet",
             "--usage-reporting", "false",
             "--bash-completion", "false",
             "--path-update", "false",
             "--rc-path", "false",
             "--update-installed-components"
    end

    # Link binaries to bin
    bin.mkpath
    (google_cloud_sdk_root/"bin").find.each do |f|
      if f.file? && f.executable?
        bin.install_symlink f
      end
    end
  end

  test do
    assert_match "gcloud", shell_output("#{bin}/gcloud --version")
    assert_match "gsutil", shell_output("#{bin}/gsutil --version")
  end
end
