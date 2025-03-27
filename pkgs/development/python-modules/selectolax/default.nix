{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  # build-system
  setuptools,
  cython,
  # test
  pytestCheckHook,
}:
buildPythonPackage rec {
  pname = "selectolax";
  version = "0.3.28";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "rushter";
    repo = "selectolax";
    tag = "v${version}";
    hash = "sha256-41KVec4LPWJitmJgmv4D2DHwanZl4LVoFk//rUv2rMU=";
    fetchSubmodules = true;
    leaveDotGit = true;
    postFetch = ''
      cd $src
      touch anan.xml
      # Download connectedhomeip.
      git fetch
      git reset --hard HEAD
      git submodule update --init --depth 1 lexbor modest
    '';
  };

  build-system = [setuptools cython];
  #
  # nativeCheckInputs = [pytestCheckHook];
  #
  # pythonImportsCheck = ["selectolax"];

  doCheck = false;

  meta = {
    description = "Python binding to Modest and Lexbor engines (fast HTML5 parser with CSS selectors).";
    homepage = "https://github.com/rushter/selectolax";
    changelog = "https://github.com/rushter/selectolax/releases/tag/${version}";
    license = lib.licenses.mit;
    maintainers = [lib.maintainers.octvs];
  };
}
