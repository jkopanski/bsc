{
  description = "Bluespec Compiler";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/release-25.11";
    utils.url = "github:numtide/flake-utils";
  };

  outputs = inputs@{ self, nixpkgs, utils, ... }:
    (utils.lib.eachDefaultSystem (system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
        haskell = pkgs.haskell.packages.ghc96;
        ghc = haskell.ghcWithPackages (hpkgs: with hpkgs; [
          regex-compat syb old-time split strict-concurrency
        ]);
        python = pkgs.python3.withPackages (ps: [ ps.pyyaml ]);

      in {
        devShells.default = pkgs.mkShell {
          nativeBuildInputs = [
            ghc
            python
            
            pkgs.autoconf
            pkgs.automake
            pkgs.bison
            pkgs.dejagnu
            pkgs.flex
            pkgs.gccgo
            pkgs.gmp
            pkgs.gperf
            pkgs.pkg-config
            pkgs.zlib
            
            pkgs.tcl-9_0
            pkgs.iverilog

            haskell.ghcid
            haskell.haskell-language-server
            haskell.fix-whitespace
          ];

          shellHook = ''
            BSC_VERSION=$(echo 'puts [lindex [Bluetcl::version] 0]' | inst/bin/bluetcl)
          '';
        };
      }
    ));
}
