# Prebuilt binaries rather than a source build: the crate takes about ninety
# seconds to compile, and `brew install` should not.
class AiCrewSync < Formula
  desc "MCP coordination bus for a team's AI coding agents"
  homepage "https://github.com/joaquinbejar/ai-crew-sync"
  version "0.7.8"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/joaquinbejar/ai-crew-sync/releases/download/v0.7.8/ai-crew-sync-v0.7.8-aarch64-apple-darwin.tar.gz"
      sha256 "99f80ee9385cfb4ad40eac17bcd4255b41999e7a86edae7a8e2f064b8030d84f"
    end
    on_intel do
      url "https://github.com/joaquinbejar/ai-crew-sync/releases/download/v0.7.8/ai-crew-sync-v0.7.8-x86_64-apple-darwin.tar.gz"
      sha256 "a9caaa4c1cba555b340171c13063c9988fd2045e0c23ab80d93eb05392ae1717"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/joaquinbejar/ai-crew-sync/releases/download/v0.7.8/ai-crew-sync-v0.7.8-aarch64-unknown-linux-musl.tar.gz"
      sha256 "6ba2d43aac5a3fb7c4b40022eb5d4ef3914ba3c3e53440d82e1166ed7b0602b4"
    end
    on_intel do
      url "https://github.com/joaquinbejar/ai-crew-sync/releases/download/v0.7.8/ai-crew-sync-v0.7.8-x86_64-unknown-linux-musl.tar.gz"
      sha256 "2eb45b90dae05562b3135168161822b0c844a74ba39c2279c5b381e1d8d18d01"
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
