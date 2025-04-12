from setuptools import setup, Extension
from Cython.Build import cythonize

setup(
    name="libclay",
    version="0.1.0",
    ext_modules=cythonize(
        [
            Extension(
                "libclay",
                sources=[
                    "libclay/*.pyx"
                ],
                define_macros=[("CLAY_IMPLEMENTATION", "1")],
            )
        ]
    ),
)
