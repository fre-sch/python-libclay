import json
import re
from dataclasses import dataclass
from textwrap import indent

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

struct_read_only_fields = [
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


def mode_print(mode, sig_impl):
    sig, impl = sig_impl
    if mode == MODE_PYX:
        return f"{sig}:\n{impl}"
    if "cdef " in sig:
        return f"{sig}\n"
    return ""


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
            return f"&({arg_name}.__internal)"
        return f"{arg_name}.__internal"

    def render(self, mode):
        return ""


class ClayStringNode(DeclNode):
    prio = 0
    cname = "Clay_String"
    pname = "str"

    def __init__(self):
        super().__init__(None)

    def ctor_str(self, arg_name, is_ptr):
        return f"clay_string_to_py({arg_name})"

    def cvalue_str(self, arg_name, is_ptr):
        return f'{arg_name} # Clay_String'

    def render(self, mode):
        return mode_print(mode, (
            "cdef str clay_string_to_py(Clay_String value)",
            "    py_bytes = <bytes> value.chars[:value.length]\n"
            "    return py_bytes.decode(\"UTF-8\")\n\n"
        )) + mode_print(mode, (
            "cdef Clay_String clay_string_from_py(str value)",
            "    py_bytes = value.encode(\"UTF-8\")\n"
            "    return Clay_String(isStaticallyAllocated=False, length=len(py_bytes), chars=py_bytes)\n\n"
        ))


class FieldNode(DeclNode):
    def __init__(self, decl, is_read_only):
        super().__init__(decl)
        self.is_read_only = is_read_only

    @property
    def pname(self):
        return camel_to_snake(self.decl["name"])

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

    def void_ptr_getter(self, mode):
        return mode_print(mode, (
            "@property\n"
            f"def {self.pname}(self)",
            f"    return <object> self.__internal.{self.cname}\n"
        ))

    def void_ptr_setter(self, mode):
        if self.is_read_only:
            return ""

        return mode_print(mode, (
            f"@{self.pname}.setter\n"
            f"def {self.pname}(self, object value)",
            f"    self.__internal.{self.cname} = <void*> value\n"
        ))

    def type_unmapped_getter(self, mode):
        return mode_print(mode, (
            "@property\n"
            f"def {self.pname}(self)",
            f"    return self.__internal.{self.cname}\n"
        ))

    def type_unmapped_setter(self, mode):
        if self.is_read_only:
            return ""

        return mode_print(mode, (
            f"@{self.pname}.setter\n"
            f"def {self.pname}(self, value)",
            f"    self.__internal.{self.cname} = value\n"
        ))

    def typed_getter(self, mode):
        field_name = f"self.__internal.{self.cname}"
        return mode_print(mode, (
            "@property\n"
            f"def {self.pname}(self) -> {self.type_node.pname}",
            f"    return {self.type_node.ctor_str(field_name, self.is_ptr)}\n"
        ))

    def typed_setter(self, mode):
        if self.is_read_only:
            return ""

        field_name = f"self.__internal.{self.cname}"
        return mode_print(mode, (
            f"@{self.pname}.setter\n"
            f"def {self.pname}(self, value: {self.type_node.pname})",
            f"    self.__internal.{self.cname} = {self.type_node.cvalue_str('value', self.is_ptr)}\n"
        ))

    def render(self, mode):
        if self.type_node is None:
            if self.decl["type_name"] == "void*":
                return self.void_ptr_getter(mode) + self.void_ptr_setter(mode)
            return self.type_unmapped_getter(mode) + self.type_unmapped_setter(mode)

        return self.typed_getter(mode) + self.typed_setter(mode)


class StructNode(DeclNode):
    prio = 2

    @property
    def fields(self):
        return [
            FieldNode(it, (self.cname in struct_read_only_fields))
            for it in self.decl.get("fields", [])
        ]

    def render(self, mode):
        if mode == MODE_PXD:
            internal_string = f"cdef {self.cname} __internal\n"
        else:
            internal_string = ""

        fields_str = "\n".join(field.render(mode) for field in self.fields)
        static_constructor = mode_print(mode, (
            "\n@staticmethod\n"
            f"cdef {self.pname} from_c({self.cname} value)",
            f"    instance = {self.pname}()\n"
            "    instance.__internal = value\n"
            "    return instance\n\n"
        ))
        return f"cdef class {self.pname}:\n" + indent(
            internal_string + fields_str + static_constructor, "    "
        )


class UnionNode(StructNode):
    prio = 1


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


def visit(decl):
    if decl.get("name") in struct_skip:
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
        ClayStringNode()
    ]
    for stack in decl_stacks:
        for decl in stack:
            if (node := visit(decl)) is not None:
                nodes.append(node)
    nodes.sort(key=lambda it: it.prio)
    with out_path.with_suffix(".pyx").open("w") as out_pyx_file:
        out_pyx_file.write(
            "from libclay._clay cimport *\n"
            "from enum import Enum\n\n\n")
        out_pyx_file.write("\n\n".join([node.render(MODE_PYX) for node in nodes]))
    with out_path.with_suffix(".pxd").open("w") as out_pxd_file:
        out_pxd_file.write(
            "from libclay._clay cimport *\n"
            "from enum import Enum\n\n\n")
        out_pxd_file.write("\n\n".join([node.render(MODE_PXD) for node in nodes]))


if __name__ == "__main__":
    main()
