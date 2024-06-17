# This flake was initially generated by fh, the CLI for FlakeHub (version 0.1.11)
{
  # A helpful description of your flake
  description = "superbird_mpris nix flake";

  # Flake inputs
  inputs = {
    flake-schemas.url = "https://flakehub.com/f/DeterminateSystems/flake-schemas/*.tar.gz";

    flake-utils.url = "github:numtide/flake-utils";
    nix-filter.url = "github:numtide/nix-filter";
    nixpkgs.inputs.flake-utils.follows = "flake-utils";

    #    nixpkgs.url = "https://flakehub.com/f/NixOS/nixpkgs/*.tar.gz";
    nixpkgs.url = "github:nix-ocaml/nix-overlays";
  };

  # Flake outputs that other flakes can use
  outputs = { self, flake-schemas, nixpkgs, flake-utils, nix-filter }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = nixpkgs.legacyPackages."${system}".extend (self: super: {
          ocamlPackages = super.ocaml-ng.ocamlPackages_5_2.overrideScope(oself: osuper: {
            cobs = oself.buildDunePackage rec {
              pname = "cobs";
              version = "0.1.1";
              src = builtins.fetchurl {
                url = "https://github.com/Merlin04/ocaml-cobs/archive/refs/tags/0.1.1.tar.gz";
                sha256 = "sha256:0pslkilvaa2i2514cssnyv59kv4zy4b7d7fa7zalxnvmqjl7v9w1";
              };
              propagatedBuildInputs = [ ];
            };
            pbrt = oself.buildDunePackage rec {
              pname = "pbrt";
              version = "3.0.1";
              src = builtins.fetchurl {
                url = "https://github.com/mransan/ocaml-protoc/releases/download/v3.0.2/ocaml-protoc-3.0.2.tbz";
                sha256 = "sha256:1v2z40ssp98mds1cplxpb2a98wlksh0v5p4959mpdh0cc59sjg7b";
              };
              propagatedBuildInputs = [
                oself.stdlib-shims
              ];
            };
            pbrt_yojson = oself.buildDunePackage rec {
              pname = "pbrt_yojson";
              version = "3.0.1";
              src = builtins.fetchurl {
                url = "https://github.com/mransan/ocaml-protoc/releases/download/v3.0.2/ocaml-protoc-3.0.2.tbz";
                sha256 = "sha256:1v2z40ssp98mds1cplxpb2a98wlksh0v5p4959mpdh0cc59sjg7b";
              };
              propagatedBuildInputs = [
                oself.yojson
                oself.base64
              ];
            };
            pbrt_services = oself.buildDunePackage rec {
              pname = "pbrt_services";
              version = "3.0.1";
              src = builtins.fetchurl {
                url = "https://github.com/mransan/ocaml-protoc/releases/download/v3.0.2/ocaml-protoc-3.0.2.tbz";
                sha256 = "sha256:1v2z40ssp98mds1cplxpb2a98wlksh0v5p4959mpdh0cc59sjg7b";
              };
              propagatedBuildInputs = with oself; [
                pbrt
                pbrt_yojson
              ];
            };
          });
        });
        native = pkgs.callPackage ./nix {
          nix-filter = nix-filter.lib;
        };
      in
      {
        # Schemas tell Nix about the structure of your flake's outputs
        schemas = flake-schemas.schemas;
        formatter = nixpkgs.legacyPackages.x86_64-linux.nixpkgs-fmt;
        packages = {
          inherit native;
          musl =
            let pkgs' = pkgs.pkgsCross.musl64; in
            pkgs'.lib.callPackageWith pkgs' ./nix {
              static = true;
              nix-filter = nix-filter.lib;
            };
          arm64-musl =
            let pkgs' = pkgs.pkgsCross.aarch64-multiplatform-musl; in
            (pkgs'.lib.callPackageWith pkgs' ./nix {
              static = true;
              nix-filter = nix-filter.lib;
              crossName = "aarch64";
            }).overrideAttrs (o: {
              OCAMLFIND_CONF = pkgs'.ocamlPackages.findlib.makeFindlibConf native o;
            });
        };
      }
    );
}
