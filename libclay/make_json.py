import sys, os, json
import click
from autopxd import AutoPxd, parse, CONTEXT_SETTINGS
from autopxd.nodes import PxdNode, Type, Enum


def json_encode(value):
    if isinstance(value, PxdNode):
        out = {
            slot: getattr(value, slot)
            for slot in value.__slots__
        }
        out["type"] = type(value).__name__
        return out


def translate(code, hdrname, extra_cpp_args=None, whitelist=None, debug=False, regex=None):
    if extra_cpp_args is None:
        extra_cpp_args = []
    if regex is None:
        regex = []
    extra_incdir = os.path.dirname(hdrname)
    if extra_incdir:
        extra_cpp_args += [f"-I{extra_incdir}"]
    p = AutoPxd(hdrname)
    p.visit(
        parse(
            code,
            extra_cpp_args=extra_cpp_args,
            whitelist=whitelist,
            debug=debug,
            regex=regex,
        )
    )
    return json.dumps(p.decl_stack, default=json_encode, ensure_ascii=False, indent=2)


@click.command(
    context_settings=CONTEXT_SETTINGS,
    help="Generate a Cython pxd file from a C header file.",
)
@click.option("--version", "-v", is_flag=True, help="Print program version and exit.")
@click.option(
    "--include-dir",
    "-I",
    multiple=True,
    metavar="<dir>",
    help="Allow the C preprocessor to search for files in <dir>.",
)
@click.option(
    "--regex",
    "-R",
    multiple=True,
    help="Apply sed-style search/replace (s/.../.../g) after preprocessor",
)
@click.option(
    "--compiler-directive",
    "-D",
    multiple=True,
    help="Additional directives for the C compiler.",
    metavar="<directive>",
)
@click.option(
    "--debug/--no-debug",
    default=False,
    help="Dump preprocessor output to stderr.",
)
@click.argument(
    "infile",
    type=click.File("r"),
    default=sys.stdin,
)
@click.argument(
    "outfile",
    type=click.File("w"),
    default=sys.stdout,
)
def cli(
    version,
    infile,
    outfile,
    include_dir,
    regex,
    compiler_directive,
    debug,
):
    extra_cpp_args = [f"-D{directive}" for directive in compiler_directive]
    for directory in include_dir:
        extra_cpp_args += [f"-I{directory}"]

    outfile.write(
        translate(
            infile.read(),
            infile.name,
            extra_cpp_args,
            debug=debug,
            regex=regex
        )
    )


if __name__ == "__main__":
    cli()
