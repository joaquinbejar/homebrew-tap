# Prebuilt binaries rather than a source build: the crate takes about ninety
# seconds to compile, and `brew install` should not.
class AiCrewSync < Formula
  desc "MCP coordination bus for a team's AI coding agents"
  homepage "https://github.com/joaquinbejar/ai-crew-sync"
  version "0.7.10"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/joaquinbejar/ai-crew-sync/releases/download/v0.7.10/ai-crew-sync-v0.7.10-aarch64-apple-darwin.tar.gz"
      sha256 "ee5c90868b442f64edc94173ea87572030612d835c9facd5d2a4797677b7d652"
    end
    on_intel do
      url "https://github.com/joaquinbejar/ai-crew-sync/releases/download/v0.7.10/ai-crew-sync-v0.7.10-x86_64-apple-darwin.tar.gz"
      sha256 "59620d2013124db4e84ddb5bc9f51f172f004440bb74c4758c29a69dd0bbef70"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/joaquinbejar/ai-crew-sync/releases/download/v0.7.10/ai-crew-sync-v0.7.10-aarch64-unknown-linux-musl.tar.gz"
      sha256 "be1b83edc88547d3b783ed7038e3f29538f7e63199d60f2183d84a4594a69577"
    end
    on_intel do
      url "https://github.com/joaquinbejar/ai-crew-sync/releases/download/v0.7.10/ai-crew-sync-v0.7.10-x86_64-unknown-linux-musl.tar.gz"
      sha256 "ff6ad718679c3a54ae9d9f27773ec7a65ecf29ccbac77ce4728369634b6c495e"
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
