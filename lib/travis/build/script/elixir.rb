module Travis
  module Build
    class Script
      class Elixir < Erlang
        DEFAULTS = {
          elixir: '1.0.2',
          otp_release: '17.4'
        }

        def export
          super
          sh.export 'TRAVIS_ELIXIR_VERSION', elixir_version, echo: false
        end

        def announce
          super
          sh.if has_elixir(elixir_version) do
            sh.cmd "kiex use #{elixir_version} || kiex install #{elixir_version}"
            sh.cmd "elixir --version"
          end
          sh.else do
            sh.echo "Elixir version #{elixir_version} is not available.", ansi: :red
          end
        end

        def install
        end

        def script
        end

        def cache_slug
          super << '--elixir-' << elixir_version
        end

        private

        def elixir_version
          config[:elixir].to_s
        end

        def has_elixir(version)
          "-f #{exlixir_env_file(version)}"
        end

        def exlixir_env_file(version)
          "#{HOME_DIR}/.kiex/elixirs/elixir-#{version}.env"
        end
      end
    end
  end
end
