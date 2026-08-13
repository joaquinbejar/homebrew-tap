# Prebuilt binaries rather than a source build: the crate takes about ninety
# seconds to compile, and `brew install` should not.
class AiCrewSync < Formula
  desc "MCP coordination bus for a team's AI coding agents"
  homepage "https://github.com/joaquinbejar/ai-crew-sync"
  version "0.6.2"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/joaquinbejar/ai-crew-sync/releases/download/v0.6.2/ai-crew-sync-v0.6.2-aarch64-apple-darwin.tar.gz"
      sha256 "a96e555f722ab7fd2f4e1ad64c0648b7368681e70ca7ca3f7a2273269b85573c"
    end
    on_intel do
      url "https://github.com/joaquinbejar/ai-crew-sync/releases/download/v0.6.2/ai-crew-sync-v0.6.2-x86_64-apple-darwin.tar.gz"
      sha256 "91c36bed06a322064f0c50cb567adbc53c5af7a486ee365016c7986c9d33f5ca"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/joaquinbejar/ai-crew-sync/releases/download/v0.6.2/ai-crew-sync-v0.6.2-aarch64-unknown-linux-musl.tar.gz"
      sha256 "d3004fbe620c44e41b64c1d94441dfe84ccfb8bef5fcf83aa3c667d35752ac37"
    end
    on_intel do
      url "https://github.com/joaquinbejar/ai-crew-sync/releases/download/v0.6.2/ai-crew-sync-v0.6.2-x86_64-unknown-linux-musl.tar.gz"
      sha256 "b125b2d7ccffb2d0000361064771bf5e1d08d9194f1ad206e8d266204a8fffb7"
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
