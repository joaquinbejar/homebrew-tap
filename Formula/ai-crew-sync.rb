# Prebuilt binaries rather than a source build: the crate takes about ninety
# seconds to compile, and `brew install` should not.
class AiCrewSync < Formula
  desc "MCP coordination bus for a team's AI coding agents"
  homepage "https://github.com/joaquinbejar/ai-crew-sync"
  version "0.5.3"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/joaquinbejar/ai-crew-sync/releases/download/v0.5.3/ai-crew-sync-v0.5.3-aarch64-apple-darwin.tar.gz"
      sha256 "1bf8a3833fcc31d0e5aa69dde60ad90c5877e5add2349889457a6f97f09905c7"
    end
    on_intel do
      url "https://github.com/joaquinbejar/ai-crew-sync/releases/download/v0.5.3/ai-crew-sync-v0.5.3-x86_64-apple-darwin.tar.gz"
      sha256 "e59a081860c4e8ae060d0b1d39ffc0a7a6ca0d1a6848c1080904ecbae0ceed2e"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/joaquinbejar/ai-crew-sync/releases/download/v0.5.3/ai-crew-sync-v0.5.3-aarch64-unknown-linux-musl.tar.gz"
      sha256 "7140c2facaf2707fe9f12645b2a60ff677b09504417b9c32eec7a63709d417de"
    end
    on_intel do
      url "https://github.com/joaquinbejar/ai-crew-sync/releases/download/v0.5.3/ai-crew-sync-v0.5.3-x86_64-unknown-linux-musl.tar.gz"
      sha256 "27daf657d67dc9698def765026f0ebd8355a74896aecf49c8c0995bbdbe6237a"
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
