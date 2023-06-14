{ lib, stdenv, fetchurl }:

stdenv.mkDerivation rec {
  pname = "alsa-ucm-conf-x13s";
  version = "1.2.9";

  src = fetchurl {
    url = "https://git.linaro.org/people/srinivas.kandagatla/alsa-ucm-conf.git/snapshot/alsa-ucm-conf-x13s.tar.gz";
    hash = "sha256-NwTZHeMbe6PC6Q+ba/Fd7JX8DstJo4U8LnuIDJE7yS8=";
  };

  dontBuild = true;

  installPhase = ''
    runHook preInstall

    mkdir -p $out/share/alsa
    cp -r ucm ucm2 $out/share/alsa

    runHook postInstall
  '';

  meta = with lib; {
    homepage = "https://www.alsa-project.org/";
    description = "ALSA Use Case Manager configuration";

    longDescription = ''
      The Advanced Linux Sound Architecture (ALSA) provides audio and
      MIDI functionality to the Linux-based operating system.
    '';

    license = licenses.bsd3;
    maintainers = [ maintainers.roastiek ];
    platforms = platforms.linux;
  };
}