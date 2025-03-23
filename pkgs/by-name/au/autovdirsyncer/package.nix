{
  lib,
  stdenv,
  buildGoModule,
  makeWrapper,
  fetchFromSourcehut,
  # dependencies
  vdirsyncer,
}:
buildGoModule rec {
  pname = "autovdirsyncer";
  version = "0.2.1-unstable-2024-03-09";

  src = fetchFromSourcehut {
    owner = "~whynothugo";
    repo = "autovdirsyncer";
    rev = "f96fe65912fcc6170cdca7da0a6746ba612c1a20";
    hash = "sha256-7RG+r6i+zIAj/z5DPfmr/YsiYpayq9hJt33ZCdp8mro=";
  };

  vendorHash = "sha256-rEefjzsE1fAxe0y7fOCTTxKiOokOt4x/bczAzoNW7fk=";

  nativeBuildInputs = [makeWrapper];

  postInstall = lib.optionalString (stdenv.hostPlatform.isLinux) ''
    mkdir -p $out/lib/systemd/user

    substitute autovdirsyncer.service \
               $out/lib/systemd/user/autovdirsyncer.service \
               --replace-fail /usr/bin/vdirsyncer ${vdirsyncer}/bin/vdirsyncer \
               --replace-fail /usr/lib/autovdirsyncer $out/bin/autovdirsyncer
  '';

  preFixup = ''
    wrapProgram $out/bin/autovdirsyncer \
      --prefix PATH ":" "${lib.makeBinPath [
      vdirsyncer
    ]}";
  '';

  meta = {
    description = "Wrapper to daemonise vdirsyncer";
    homepage = "https://git.sr.ht/~whynothugo/autovdirsyncer";
    changelog = "https://git.sr.ht/~whynothugo/autovdirsyncer/refs/v${version}";
    license = lib.licenses.isc;
    maintainers = [lib.maintainers.octvs];
  };
}
