# Prebuilt binaries rather than a source build: the crate takes about ninety
# seconds to compile, and `brew install` should not.
class AiCrewSync < Formula
  desc "MCP coordination bus for a team's AI coding agents"
  homepage "https://github.com/joaquinbejar/ai-crew-sync"
  version "0.6.1"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/joaquinbejar/ai-crew-sync/releases/download/v0.6.1/ai-crew-sync-v0.6.1-aarch64-apple-darwin.tar.gz"
      sha256 "c39e40270618e5d3555bc2bf0d6d8d088ba110f34a10f0cc272fb64768716122"
    end
    on_intel do
      url "https://github.com/joaquinbejar/ai-crew-sync/releases/download/v0.6.1/ai-crew-sync-v0.6.1-x86_64-apple-darwin.tar.gz"
      sha256 "8165c71ff99513f54391a2f45b75eb916b21ee6b55ddd813702952926a73afca"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/joaquinbejar/ai-crew-sync/releases/download/v0.6.1/ai-crew-sync-v0.6.1-aarch64-unknown-linux-musl.tar.gz"
      sha256 "4b73d9fbb4e87dc117aa1242f050ca1827e96ca4c260765816d4fe3875e32380"
    end
    on_intel do
      url "https://github.com/joaquinbejar/ai-crew-sync/releases/download/v0.6.1/ai-crew-sync-v0.6.1-x86_64-unknown-linux-musl.tar.gz"
      sha256 "4f735ef1265b6a051784a00c12dc2a7d9916101763011b14ce7beb2a6e4f9137"
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
