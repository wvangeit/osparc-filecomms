test: clean
	pip install tox
	tox

clean:
	rm -rf src/__pycache__ src/osparc_filecomms.egg-info/
	rm -rf dist
	rm -rf build

wheel:
	python -m build
