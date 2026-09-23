# Prebuilt binaries rather than a source build: the crate takes about ninety
# seconds to compile, and `brew install` should not.
class AiCrewSync < Formula
  desc "MCP coordination bus for a team's AI coding agents"
  homepage "https://github.com/joaquinbejar/ai-crew-sync"
  version "0.7.0"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/joaquinbejar/ai-crew-sync/releases/download/v0.7.0/ai-crew-sync-v0.7.0-aarch64-apple-darwin.tar.gz"
      sha256 "87950bce3f47c44d4f831f990d5971e92af7f8f97735dbba56c36e4befdeff7a"
    end
    on_intel do
      url "https://github.com/joaquinbejar/ai-crew-sync/releases/download/v0.7.0/ai-crew-sync-v0.7.0-x86_64-apple-darwin.tar.gz"
      sha256 "bdca525655e7e245422ec42f50c6730fd72955ceab991edc47a951a6d94eb53b"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/joaquinbejar/ai-crew-sync/releases/download/v0.7.0/ai-crew-sync-v0.7.0-aarch64-unknown-linux-musl.tar.gz"
      sha256 "2c97df240e14fb4fbb98780677a8bec94e0ded834710aa0c4450502511514005"
    end
    on_intel do
      url "https://github.com/joaquinbejar/ai-crew-sync/releases/download/v0.7.0/ai-crew-sync-v0.7.0-x86_64-unknown-linux-musl.tar.gz"
      sha256 "af25156a9ca9b79ebb4042806ccc4bd996d37a4f5db9e547d4a32f8224341194"
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
