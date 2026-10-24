# Prebuilt binaries rather than a source build: the crate takes about ninety
# seconds to compile, and `brew install` should not.
class AiCrewSync < Formula
  desc "MCP coordination bus for a team's AI coding agents"
  homepage "https://github.com/joaquinbejar/ai-crew-sync"
  version "0.7.9"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/joaquinbejar/ai-crew-sync/releases/download/v0.7.9/ai-crew-sync-v0.7.9-aarch64-apple-darwin.tar.gz"
      sha256 "7bfdf5411e6355ed1f304a986508facca371a664840d7b8481c4ff2805cfdaa8"
    end
    on_intel do
      url "https://github.com/joaquinbejar/ai-crew-sync/releases/download/v0.7.9/ai-crew-sync-v0.7.9-x86_64-apple-darwin.tar.gz"
      sha256 "9eff3ed93cb758ff1f8791f14d4f4459a50b9b96f7fc7ee87d2d0ab3bcc446e1"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/joaquinbejar/ai-crew-sync/releases/download/v0.7.9/ai-crew-sync-v0.7.9-aarch64-unknown-linux-musl.tar.gz"
      sha256 "bec29956bef07d00b96c292f859b646e59c93e2400a550406fdccd3dd62a566c"
    end
    on_intel do
      url "https://github.com/joaquinbejar/ai-crew-sync/releases/download/v0.7.9/ai-crew-sync-v0.7.9-x86_64-unknown-linux-musl.tar.gz"
      sha256 "680d3a84724a4b3959182234387e96619bf39d576229cf441d906b833dafbaa9"
    end
  end

  def install
    bin.install "ai-crew-sync"
    doc.install "README.md", "LICENSE"
    # The documented list of every configuration knob, with defaults.
    pkgshare.install ".env.example"
  end

  def caveats
    <<~EOS
      This installs one binary that is the server, the operator CLI and the
      console client.

      To talk to a bus your team already runs:
        export BUS_URL=https://bus.example.com/mcp
        export BUS_TOKEN=acs_...        # from `ai-crew-sync agent add`
        ai-crew-sync client whoami

      To run a bus yourself you also need PostgreSQL 16 or newer. Most people
      want the container image for that:
        docker pull ghcr.io/joaquinbejar/ai-crew-sync

      Every configuration knob, with its default:
        #{opt_pkgshare}/.env.example
    EOS
  end

  test do
    # Hermetic on purpose: anything that reaches for a bus would hang in the
    # sandbox, and a formula test should prove the binary is installed and
    # runnable, not that a server is up.
    assert_match version.to_s, shell_output("#{bin}/ai-crew-sync --version")
    assert_match "coordination bus", shell_output("#{bin}/ai-crew-sync --help")
    assert_match "serve", shell_output("#{bin}/ai-crew-sync --help")
  end
end
