{
  lib,
  stdenv,
  arxiv,
  beautifulsoup4,
  bibtexparser,
  buildPythonPackage,
  chardet,
  click,
  colorama,
  configparser,
  docutils,
  dominate,
  fetchFromGitHub,
  filetype,
  git,
  habanero,
  hatchling,
  isbnlib,
  lxml,
  platformdirs,
  prompt-toolkit,
  pygments,
  pyparsing,
  pytestCheckHook,
  python-doi,
  python-slugify,
  pythonOlder,
  pyyaml,
  requests,
  sphinx,
  sphinx-click,
  stevedore,
  typing-extensions,
  whoosh,
}:
buildPythonPackage rec {
  pname = "papis";
  version = "0.14";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "papis";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-UpZoMYk4URN8tSFGIynVzWMk+9S0izROAgbx6uI2cN8=";
  };

  build-system = [ hatchling ];

  propagatedBuildInputs = [
    docutils
    arxiv
    platformdirs
    beautifulsoup4
    bibtexparser
    chardet
    click
    colorama
    configparser
    dominate
    filetype
    habanero
    isbnlib
    lxml
    prompt-toolkit
    pygments
    pyparsing
    python-doi
    python-slugify
    pyyaml
    requests
    stevedore
    typing-extensions
    whoosh
    sphinx
    sphinx-click
  ];

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace "--cov=papis" ""
  '';

  nativeCheckInputs = [
    pytestCheckHook
    git
  ];

  preCheck = ''
    export HOME=$(mktemp -d);
  '';

  pytestFlagsArray = [ "papis tests" ];

  disabledTestPaths = [
    "tests/downloaders"
    "papis/downloaders/usenix.py"
  ];

  disabledTests = [
    "get_document_url"
    "match"
    "test_doi_to_data"
    "test_downloader_getter"
    "test_general"
    "test_get_config_dirs"
    "test_get_configuration"
    "test_get_data"
    "test_valid_dblp_key"
    "test_validate_arxivid"
    "test_yaml"
  ] ++ lib.optionals stdenv.hostPlatform.isDarwin [ "test_default_opener" ];

  pythonImportsCheck = [ "papis" ];

  meta = {
    description = "Powerful command-line document and bibliography manager";
    mainProgram = "papis";
    homepage = "https://papis.readthedocs.io/";
    changelog = "https://github.com/papis/papis/blob/v${version}/CHANGELOG.md";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [
      nico202
      teto
    ];
  };
}
