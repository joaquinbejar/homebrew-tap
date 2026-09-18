# Prebuilt binaries rather than a source build: the crate takes about ninety
# seconds to compile, and `brew install` should not.
class AiCrewSync < Formula
  desc "MCP coordination bus for a team's AI coding agents"
  homepage "https://github.com/joaquinbejar/ai-crew-sync"
  version "0.6.3"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/joaquinbejar/ai-crew-sync/releases/download/v0.6.3/ai-crew-sync-v0.6.3-aarch64-apple-darwin.tar.gz"
      sha256 "4b2e4ab1b311c200d489e04e8ffe838089fa37fe51e6adf503574208b1459053"
    end
    on_intel do
      url "https://github.com/joaquinbejar/ai-crew-sync/releases/download/v0.6.3/ai-crew-sync-v0.6.3-x86_64-apple-darwin.tar.gz"
      sha256 "b5d47bc51971ca25cc50c887ccb61884e29455b938f555d24dd375f11106d9ee"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/joaquinbejar/ai-crew-sync/releases/download/v0.6.3/ai-crew-sync-v0.6.3-aarch64-unknown-linux-musl.tar.gz"
      sha256 "9ac21e17c56bfc3940e9989aed47aa6bb7acac09a70447b6271b9d1e9c2807e9"
    end
    on_intel do
      url "https://github.com/joaquinbejar/ai-crew-sync/releases/download/v0.6.3/ai-crew-sync-v0.6.3-x86_64-unknown-linux-musl.tar.gz"
      sha256 "10e9e9887cb08743f4e5cd96ac62eb8511cbfd0f479b082b183388f143f694d7"
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
