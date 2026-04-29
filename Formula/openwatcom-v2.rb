class OpenwatcomV2 < Formula
  desc "C/C++ compiler and tools"
  homepage "https://github.com/open-watcom/open-watcom-v2"
  url "https://github.com/open-watcom/open-watcom-v2/releases/download/2026-04-01-Build/ow-snapshot.tar.xz"
  version "2026-04-01"
  sha256 "98f295becd969196cf8915a70115df014291e3e73073db71e9065e4780ec23d5"
  license "Watcom-1.0"

  bottle do
    root_url "https://github.com/SharkyRawr/homebrew-openwatcom/releases/download/openwatcom-v2-2026-04-01"
    rebuild 3
    sha256 cellar: :any_skip_relocation, arm64_tahoe: "2188c983fec262612e45ed6a4415851317cf959ebca55acac641c901f9ebecd4"
  end

  # The snapshot is a multi-platform distribution.
  # macOS host binaries are in bino64 (Intel) and armo64 (Apple Silicon).

  def install
    # Install the full snapshot to prefix.
    prefix.install Dir["*"]

    # Remove non-native macOS host binaries to avoid audit failures.
    # The snapshot contains both Intel (bino64) and Apple Silicon (armo64) binaries.
    non_native_dir = Hardware::CPU.arm? ? "bino64" : "armo64"
    rm_r prefix/non_native_dir if (prefix/non_native_dir).directory?

    # Symlink host-native tools into bin/ for convenience.
    # Skip vi and ctags to avoid conflicts with common Homebrew formulae.
    bindir = Hardware::CPU.arm? ? "armo64" : "bino64"
    excluded = %w[vi ctags]

    (prefix/bindir).each_child do |f|
      next if !f.file? || !f.executable?
      next if excluded.include?(f.basename.to_s)

      bin.install_symlink f
    end

    # Create an environment setup script that users can source.
    (bin/"owenv.sh").write <<~SHELL
      #!/bin/sh
      # Open Watcom V2 environment setup script
      export WATCOM="#{opt_prefix}"
      export PATH="#{opt_prefix}/#{bindir}:${PATH}"
      export INCLUDE="#{opt_prefix}/h"
      export EDPATH="#{opt_prefix}/eddat"
    SHELL
    (bin/"owenv.sh").chmod(0755)
  end

  def caveats
    <<~EOS
      Open Watcom has been installed to:
        #{opt_prefix}

      To set up the environment for the current shell, run:
        . #{opt_bin}/owenv.sh

      To make this permanent, add the following line to your shell profile
      (e.g., ~/.zshrc or ~/.bash_profile):
        . #{opt_bin}/owenv.sh

      For cross-compilation, target-specific headers and libraries are in:
        #{opt_prefix}/h
        #{opt_prefix}/lib286
        #{opt_prefix}/lib386
    EOS
  end

  test do
    bindir = Hardware::CPU.arm? ? "armo64" : "bino64"
    ENV["WATCOM"] = opt_prefix
    ENV["PATH"] = "#{opt_prefix}/#{bindir}:#{ENV["PATH"]}"
    ENV["INCLUDE"] = "#{opt_prefix}/h"

    (testpath/"hello.c").write <<~C
      #include <stdio.h>
      int main(void) {
        printf("Hello, World!\\n");
        return 0;
      }
    C

    # Compile a simple C file.
    # wcc outputs hello.o by default.
    system "#{opt_prefix}/#{bindir}/wcc", "hello.c"
    assert_path_exists testpath/"hello.o"
  end
end
