{
  description = "Pick a Snippet";

  inputs = {
    nixpkgs.url = "github:nixOS/nixpkgs/release-25.05";
  };

  outputs =
    {
      self,
      nixpkgs,
    }:
    let
      # https://ayats.org/blog/no-flake-utils
      forAllSystems =
        function:
        nixpkgs.lib.genAttrs [
          "x86_64-linux"
        ] (system: function nixpkgs.legacyPackages.${system});

      name = "pas";
      defaultBuildInputs = (
        {
          pkgs,
          additionalPkgs ? [ ],
        }:
        with pkgs;
        [
          glibc
          clang
          lua
        ]
        ++ additionalPkgs
      );
    in
    {

      devShells = forAllSystems (pkgs: {
        default = pkgs.mkShell {
          inherit name;
          buildInputs = defaultBuildInputs {
            inherit pkgs;
            additionalPkgs = with pkgs; [
              python314
              pkg-config
              nixfmt-rfc-style
            ];
          };
          shellHook = ''
            echo "Entered development environment"
          '';
        };
      });
      packages = forAllSystems (pkgs: {
        default = pkgs.stdenv.mkDerivation {
          pname = name;
          version = "0.0.1";
          src = ./.;
          doCheck = true;
          nativeBuildInputs = [
            pkgs.pkg-config
          ];
          buildInputs = defaultBuildInputs {
            inherit pkgs;
          };

          buildPhase = ''
            bash scripts/build.sh
          '';

          installPhase = ''
            mkdir -p $out/bin
            cp build/pas $out/bin/
          '';
        };
      });
    };
}
