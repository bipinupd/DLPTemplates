from pytest import fixture

@fixture(scope='session')
def project(request):
    return request.config.getoption("--project_id")

def pytest_addoption(parser):
    parser.addoption(
        "--project_id", 
        action="store", 
        help="Project Id where you run the integration/smoke test"
    )
