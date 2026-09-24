# Prebuilt binaries rather than a source build: the crate takes about ninety
# seconds to compile, and `brew install` should not.
class AiCrewSync < Formula
  desc "MCP coordination bus for a team's AI coding agents"
  homepage "https://github.com/joaquinbejar/ai-crew-sync"
  version "0.7.3"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/joaquinbejar/ai-crew-sync/releases/download/v0.7.3/ai-crew-sync-v0.7.3-aarch64-apple-darwin.tar.gz"
      sha256 "a40a25fad1c3437c408e71dba5d9e7867f08e3c523152f0c8cb03083effc546d"
    end
    on_intel do
      url "https://github.com/joaquinbejar/ai-crew-sync/releases/download/v0.7.3/ai-crew-sync-v0.7.3-x86_64-apple-darwin.tar.gz"
      sha256 "940be78605d975bb208e235deedf857dea69730ec125705ca18cb74b13b1b74a"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/joaquinbejar/ai-crew-sync/releases/download/v0.7.3/ai-crew-sync-v0.7.3-aarch64-unknown-linux-musl.tar.gz"
      sha256 "6babe17f04172a5f3e5d71a7712711c2e53c2f299120d436ffd796e3f92107cb"
    end
    on_intel do
      url "https://github.com/joaquinbejar/ai-crew-sync/releases/download/v0.7.3/ai-crew-sync-v0.7.3-x86_64-unknown-linux-musl.tar.gz"
      sha256 "23f8d1885898b04a7975bb20c8b5178ed97c393378f9a4cf3e459c393f4b656f"
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
