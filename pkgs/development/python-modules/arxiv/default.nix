{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  feedparser,
  mock,
  pytestCheckHook,
  requests,
  setuptools,
}:
buildPythonPackage rec {
  pname = "arxiv";
  version = "2.1.0";

  src = fetchFromGitHub {
    owner = "lukasschwab";
    repo = "arxiv.py";
    rev = "refs/tags/${version}";
    hash = "sha256-2+Wyu4nQip9NDdJ1jHLRPcn21gpGFEfVz3zDruYZpeo=";
  };

  nativeBuildInputs = [ setuptools ];

  propagatedBuildInputs = [
    feedparser
    requests
  ];

  nativeCheckInputs = [
    pytestCheckHook
    mock
  ];

  pythonImportsCheck = [ "arxiv" ];

  meta = {
    description = "Python wrapper for the arXiv API";
    homepage = "https://github.com/lukasschwab/arxiv.py";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.octvs ];
  };
}
