################################################################################
# Build all of the platforms manually since the `all_platforms' target
# doesn't preserve all of the build outputs and overrides CFLAGS.
set -euxo pipefail

################################################################################
# Prevent a warning from shellcheck:
out=${out:-/tmp}

################################################################################
# export CFLAGS=$NIX_CFLAGS_COMPILE
export MAKEFLAGS="\
  ${enableParallelBuilding:+-j${NIX_BUILD_CORES}}"

################################################################################
PRODUCTS="firmware.bin firmware.hex firmware.uf2 firmware.elf"

################################################################################

install_platform() {
  mkdir -p "$out/$1"
  
  for product in $PRODUCTS
  do
    echo $product
    if [ -f "_build/$1/$product" ]
    then
        cp "_build/$1/$product" "$out/$1/"
    fi
    if [ -f "_build/$product" ]
    then
        cp "_build/$product" "$out/$1/"
    fi
  done
}

make_platform() {
  echo "Building for hardware platform $1"

  rm -rf _build
  make APOLLO_BOARD="$1" get-deps
  make APOLLO_BOARD="$1" ${2:-}

  install_platform "$1"
}

make_rp2040_platform() {
  echo "Building for hardware platform $1"

  rm -rf _build
  make APOLLO_BOARD="$1" "_build/raspberry_pi_pico"
  make APOLLO_BOARD="$1" -C "_build" ${2:-}

  install_platform "$1"
}

################################################################################
# And now all of the platforms:

cd firmware

make_platform "samd11_xplained"
make_platform "qtpy" "uf2"
make_platform "cynthion_d11"
make_platform "cynthion_d21" "uf2"
make_rp2040_platform "raspberry_pi_pico"
make_rp2040_platform "waveshare_rp2040_zero"
make_rp2040_platform "adafruit_qtpy_rp2040"
