{ fetchFromGitea, stdenv }:
stdenv.mkDerivation {
  name = "relax";
  version = "unstable-2025-02-10";
  src = fetchFromGitea {
    domain = "git.dirk-hoeschen.de";
    owner = "c-base";
    repo = "Relaxx";
    rev = "f067d5b355f4e4bf5ef780f345ff4212b049fad2";
    hash = "sha256-yV5qSnYhAcnLkr1szJGCke++qhKbgB/QVeLIup/W9KU=";
  };

  patches = [ ./relaxx-config-fix.patch ];

  buildPhase = ''
    mkdir -p $out
    cp -r ./* $out/
  '';
}
