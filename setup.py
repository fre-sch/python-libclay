from setuptools import setup, Extension
from Cython.Build import cythonize

setup(
    name="libclay",
    version="0.1.0",
    ext_modules=cythonize(
        [
            Extension(
                "libclay._wrapper",
                sources=[
                    "libclay/_wrapper.pyx",
                ],
                define_macros=[("CLAY_IMPLEMENTATION", "1")],
            ),
            Extension(
                "libclay._macro",
                sources=[
                    "libclay/_macro.pyx",
                ],
                define_macros=[("CLAY_IMPLEMENTATION", "1")],
            ),
        ]
    ),
)
