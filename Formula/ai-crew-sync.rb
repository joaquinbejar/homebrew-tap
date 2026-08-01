# Prebuilt binaries rather than a source build: the crate takes about ninety
# seconds to compile, and `brew install` should not.
class AiCrewSync < Formula
  desc "MCP coordination bus for a team's AI coding agents"
  homepage "https://github.com/joaquinbejar/ai-crew-sync"
  version "0.5.2"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/joaquinbejar/ai-crew-sync/releases/download/v0.5.2/ai-crew-sync-v0.5.2-aarch64-apple-darwin.tar.gz"
      sha256 "422974b8bfddd38186d0e04a86db43ef9ec495a609a6d4a728a24e5c85344d26"
    end
    on_intel do
      url "https://github.com/joaquinbejar/ai-crew-sync/releases/download/v0.5.2/ai-crew-sync-v0.5.2-x86_64-apple-darwin.tar.gz"
      sha256 "d52efd742f4921913e405d68f25ee688dc15986a9537d31300b3ff03e8e7d450"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/joaquinbejar/ai-crew-sync/releases/download/v0.5.2/ai-crew-sync-v0.5.2-aarch64-unknown-linux-musl.tar.gz"
      sha256 "8ba6bb0c4f86e874beec9cdc3ae00fb87abdbc4d48be06a7c642552abaf823f5"
    end
    on_intel do
      url "https://github.com/joaquinbejar/ai-crew-sync/releases/download/v0.5.2/ai-crew-sync-v0.5.2-x86_64-unknown-linux-musl.tar.gz"
      sha256 "304b445aca3a702565a0ccf009990bd0cb08f14429f226cc43f0dd955191bfad"
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
