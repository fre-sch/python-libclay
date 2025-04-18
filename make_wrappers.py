import json
import re
from dataclasses import dataclass
from textwrap import indent
from fnmatch import fnmatchcase


pythonize_re = re.compile(
    r"""
        (?<=[a-z])      # preceded by lowercase
        (?=[A-Z])       # followed by uppercase
        |               #   OR
        (?<=[A-Z])       # preceded by lowercase
        (?=[A-Z][a-z])  # followed by uppercase, then lowercase
    """,
    re.X,
)

struct_read_only = [
    "Clay_String",
    "Clay_ScrollContainerData",
    "Clay_RenderData",
    "Clay_RenderCommand",
    "Clay_RenderCommandArray",
    "Clay_Arena",
    "Clay_ElementId",
    "Clay_ErrorData",
]
struct_skip = [
    "Clay_String",
    "Clay_ErrorHandler",
    "*Wrapper",
]


type_map = {}

MODE_PXD = "pxd"
MODE_PYX = "pyx"


def strip_clay(name):
    name = re.sub("^_*[Cc][Ll][Aa][Yy]_+", "", name)
    name = re.sub("^_*[Cc][Ll][Aa][Yy]_+", "", name)
    return name


def strip_prefix(name, prefixes):
    for prefix in prefixes:
        name = name.replace(prefix, "")
    return name


def camel_to_snake(name):
    return pythonize_re.sub("_", name).lower()


def function_string(mode, sig_impl):
    sig, impl = sig_impl
    if mode == MODE_PYX:
        return f"{sig}:\n{impl}"
    if "cdef " in sig:
        return f"{sig}\n"
    return ""


def attributes_string(mode, attributes):
    result = []
    for attr in attributes:
        # cdef attributes go in pxd files, but not in pyx files
        if mode == MODE_PXD and "cdef " in attr:
            result.append(attr)
        # python attributes go in pyx files, but not in pxd files
        elif mode == MODE_PYX and "cdef " not in attr:
            result.append(attr)

    return "\n".join(result)


class DeclNode:
    prio = 10000

    def __init__(self, decl):
        self.decl = decl
        type_map[self.cname] = self

    @property
    def cname(self):
        return self.decl["name"]

    @property
    def pname(self):
        return strip_clay(self.cname)

    def ctor_str(self, arg_name, is_ptr):
        if is_ptr:
            return f"{self.pname}.from_c({arg_name}[0])"
        return f"{self.pname}.from_c({arg_name})"

    def cvalue_str(self, arg_name, is_ptr):
        if is_ptr:
            return f"&({arg_name}._cvalue)"
        return f"{arg_name}._cvalue"

    def render(self, mode):
        return ""


class FieldNode(DeclNode):
    def __init__(self, decl, is_read_only):
        super().__init__(decl)
        self.is_read_only = is_read_only

    @property
    def pname(self):
        name = camel_to_snake(self.decl["name"])
        if name in __builtins__.__dict__:
            return f"{name}_"
        return name

    @property
    def type_node(self):
        type_name = self.decl["type_name"]
        if type_name in type_map:
            return type_map[type_name]
        if self.is_ptr:
            return type_map.get(self.decl["node"]["type_name"])

    @property
    def is_ptr(self):
        return self.decl["type"] == "Ptr"

    def param_string(self, is_optional):
        if self.type_node:
            type_str = f"Optional[{self.type_node.pname}]" if is_optional else self.type_node.pname
            annotation_str = f": {type_str}"
        else:
            annotation_str = ""
        value_str = " = None" if is_optional else ""
        return f"{self.pname}{annotation_str}{value_str}"

    def type_unmapped_getter(self, mode):
        return function_string(mode, (
            "@property\n"
            f"def {self.pname}(self)",
            f"    return self._cvalue.{self.cname}\n"
        ))

    def type_unmapped_setter(self, mode):
        if self.is_read_only:
            return ""

        return function_string(mode, (
            f"@{self.pname}.setter\n"
            f"def {self.pname}(self, value)",
            f"    self._cvalue.{self.cname} = value\n"
        ))

    def typed_getter(self, mode):
        field_name = f"self._cvalue.{self.cname}"
        return function_string(mode, (
            "@property\n"
            f"def {self.pname}(self) -> {self.type_node.pname}",
            f"    return {self.type_node.ctor_str(field_name, self.is_ptr)}\n"
        ))

    def typed_setter(self, mode):
        if self.is_read_only:
            return ""

        field_name = f"self._cvalue.{self.cname}"
        return function_string(mode, (
            f"@{self.pname}.setter\n"
            f"def {self.pname}(self, value: {self.type_node.pname})",
            f"    self._cvalue.{self.cname} = {self.type_node.cvalue_str('value', self.is_ptr)}\n"
        ))

    def render(self, mode):
        if self.type_node is None:
            return self.type_unmapped_getter(mode) + self.type_unmapped_setter(mode)

        return self.typed_getter(mode) + self.typed_setter(mode)


class StructNode(DeclNode):
    prio = 2

    @property
    def attributes(self):
        return (
            f"cdef {self.cname} _cvalue",
        )

    @property
    def fields(self):
        return [
            FieldNode(it, (self.cname in struct_read_only))
            for it in self.decl.get("fields", [])
        ]

    @property
    def constructor(self):
        if self.cname in struct_read_only:
            return (
                "def __init__(self)",
                "    raise TypeError('This class cannot be instantiated directly.')\n\n"
            )
        else:
            fields = self.fields
            params_string = ", \n".join([
                field.param_string(True)
                for field in fields
            ])

            setters = ""
            for field in fields:
                cvalue_str = field.type_node.cvalue_str(field.pname, field.is_ptr) if field.type_node else field.pname
                setters += (
                    f"if {field.pname} is not None:\n"
                    f"    self._cvalue.{field.cname} = {cvalue_str}\n"
                )

            return (
                f"def __init__(self, \n{indent(params_string, '        ')}\n)",
                indent(setters, "    ")
                + "\n\n"
            )

    @property
    def static_constructor(self):
        return (
            "\n@staticmethod\n"
            f"cdef {self.pname} from_c({self.cname} value)",
            f"    cdef {self.pname} instance = {self.pname}.__new__({self.pname})\n"
            "    instance._cvalue = value\n"
            "    return instance\n\n"
        )

    def render(self, mode):
        fields_str = "\n".join(field.render(mode) for field in self.fields)

        return f"cdef class {self.pname}:\n" + indent(
            attributes_string(mode, self.attributes)
            + function_string(mode, self.constructor)
            + fields_str
            + function_string(mode, self.static_constructor),
            "    "
        )


class VoidPointer(DeclNode):
    cname = "void*"
    pname = "object"

    def __init__(self):
        super().__init__({})

    def ctor_str(self, arg_name, is_ptr):
        return f"<object> {arg_name}"

    def cvalue_str(self, arg_name, is_ptr):
        return f"<void*> {arg_name}"


class ClayStringNode(StructNode):
    cname = "Clay_String"
    pname = "ClayString"

    def __init__(self):
        super().__init__({})

    @property
    def attributes(self):
        return (
            f"cdef {self.cname} _cvalue",
            f"cdef bytes _bytes",
        )

    def render(self, mode):
        to_str = function_string(mode, (
            "\ndef __str__(self)",
            "    cdef bytes _bytes = self._cvalue.chars\n"
            "    return _bytes.decode(\"utf-8\")\n\n"
        ))

        from_str = function_string(mode, (
            "\n@staticmethod\n"
            f"cdef {self.pname} from_str(str value)",
            f"    cdef {self.pname} instance = {self.pname}.__new__({self.pname})\n"
            "    instance._bytes = value.encode(\"utf-8\")\n"
            f"    instance._cvalue = {self.cname}(\n"
            "        isStaticallyAllocated=False,\n"
            "        length=len(instance._bytes),\n"
            "        chars=instance._bytes)\n"
            "    return instance\n\n"
        ))

        return f"cdef class {self.pname}:\n" + indent(
            attributes_string(mode, self.attributes)
            + function_string(mode, self.constructor)
            + to_str
            + from_str
            + function_string(mode, self.static_constructor),
            "    "
        )


class UnionNode(StructNode):
    prio = 1

    @property
    def constructor(self):
        if self.cname in struct_read_only:
            return (
                "def __init__(self)",
                "    raise TypeError('This class cannot be instantiated directly.')\n\n"
            )
        else:
            fields = self.fields
            params_string = ", ".join([
                field.param_string(True) for field in fields
            ])
            args_string = ", ".join([
                field.type_node.cvalue_str(field.pname, field.is_ptr)
                if field.type_node
                else field.pname
                for field in fields
            ])
            if fields:
                field = fields[0]
                code_string = (
                    f"if {field.pname}:\n"
                    f"    self._cvalue = {self.cname}({field.cname}={field.pname})\n"
                )
                for field in fields[1:]:
                    code_string += (
                        f"elif {field.pname}:\n"
                        f"    self._cvalue = {self.cname}({field.cname}={field.pname})\n"
                    )
                code_string += (
                    f"else:\n"
                    f"    raise ValueError('no')\n"
                )
            else:
                code_string = ""

            return (
                f"def __init__(self, *, {params_string})",
                indent(code_string, "    ")
            )


class EnumNode(DeclNode):
    prio = 0

    base_item_prefixes = [
        "CLAY_ATTACH_POINT_",
        "CLAY_POINTER_DATA_",
        "CLAY_ATTACH_TO_",
        "CLAY_TEXT_WRAP_",
        "CLAY_TEXT_ALIGN_",
        "CLAY_ALIGN_X_",
        "CLAY_ALIGN_Y_",
        "CLAY_",
    ]

    def item_prefixes(self):
        return sorted(
            [
                camel_to_snake(self.cname).upper() + "_",
                *self.base_item_prefixes,
            ],
            key=lambda it: len(it),
            reverse=True,
        )

    @property
    def items(self):
        return [
            (strip_prefix(it, self.item_prefixes()), it)
            for it in self.decl.get("items", [])
        ]

    def ctor_str(self, arg_name, is_ptr):
        return f"{self.pname}({arg_name})"

    def cvalue_str(self, arg_name, is_ptr):
        return f"{arg_name}.value"

    def render(self, mode):
        if mode == MODE_PXD:
            return ""

        name = strip_clay(self.decl["name"])
        items_str = "\n".join(
            [f"{pname} = {cname}" for pname, cname in self.items]
        )
        return f"class {name}(Enum):\n" + indent(items_str, "    ") + "\n"


def skip_name(name):
    for pat in struct_skip:
        if fnmatchcase(name, pat):
            return True
    return False


def visit(decl):
    if "name" in decl and skip_name(decl["name"]):
        return None

    if decl.get("kind") == "struct":
        return StructNode(decl)

    if decl.get("kind") == "union":
        return UnionNode(decl)

    if decl.get("type") == "Enum":
        return EnumNode(decl)

    return None


import click
import pathlib

@click.command()
@click.argument("defs_json_file", type=click.File(mode="rb"))
@click.argument("out_path", type=click.Path(path_type=pathlib.Path))
def main(defs_json_file, out_path):
    decl_stacks = json.load(defs_json_file)

    nodes = [
        VoidPointer(),
        ClayStringNode(),
    ]

    for stack in decl_stacks:
        for decl in stack:
            if (node := visit(decl)) is not None:
                nodes.append(node)
    nodes.sort(key=lambda it: it.prio)
    with out_path.with_suffix(".pyx").open("w") as out_pyx_file:
        out_pyx_file.write(
            "from cpython.mem cimport PyMem_Malloc\n"
            "from libc.string cimport strncpy\n"
            "from libclay._clay cimport *\n"
            "from enum import Enum\n"
            "from typing import Optional\n"
            "\n\n"
        )
        out_pyx_file.write("\n\n".join([node.render(MODE_PYX) for node in nodes]))
    with out_path.with_suffix(".pxd").open("w") as out_pxd_file:
        out_pxd_file.write(
            "from libclay._clay cimport *\n"
            "from enum import Enum\n"
            "\n\n"
        )
        out_pxd_file.write("\n\n".join([node.render(MODE_PXD) for node in nodes]))


if __name__ == "__main__":
    main()
