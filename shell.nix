let
  nixpkgs_hash = "651b4702e27a388f0f18e1b970534162dec09aff"; # nixos-23.11 on 2024-05-06
  nixpkgs_url = "https://github.com/NixOS/nixpkgs/archive/${nixpkgs_hash}.tar.gz";
  nixpkgs_src = builtins.fetchTarball {
    url = nixpkgs_url;
  };
in
{ pkgs ? import nixpkgs_src { } }:

with pkgs;
mkShell {
  buildInputs = [
    gcc-arm-embedded
    cmake
    dfu-util
  ];

  PICO_SDK_PATH = "${pico-sdk}/lib/pico-sdk";
}
