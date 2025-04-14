from cpython.mem cimport PyMem_Malloc
from libc.stdio cimport printf

from libclay._clay cimport (
    Clay_String,
    Clay_GetElementId,
    Clay_MinMemorySize,
    Clay_CreateArenaWithCapacityAndMemory,
    Clay_Dimensions,
    Clay_Initialize,
    Clay_ErrorHandler,
    Clay_BeginLayout,
    Clay_EndLayout,
    Clay__OpenElement,
    Clay__ConfigureOpenElement,
    Clay__CloseElement,
    Clay_ElementDeclaration,
    Clay_RenderCommandArray,
)
from libclay._wrapper cimport *


cdef class Element:
    cdef ElementDeclaration element_declaration

    def __init__(self, ElementDeclaration element_declaration):
        self.element_declaration = element_declaration

    def __enter__(self):
        Clay__OpenElement()
        Clay__ConfigureOpenElement(self.element_declaration.__internal)

    def __exit__(self, exc_type, exc_val, exc_tb):
        Clay__CloseElement()

    @staticmethod
    def open(element_declaration: ElementDeclaration) -> None:
        Clay__OpenElement()
        Clay__ConfigureOpenElement(element_declaration.__internal)

    @staticmethod
    def close() -> None:
        Clay__CloseElement()

    @staticmethod
    def new_id(id_string: str) -> ElementId:
        cdef Clay_String clay_string = clay_string_from_py(id_string)
        return ElementId.from_c(Clay_GetElementId(clay_string))


cdef class Layout:
    cdef Clay clay

    def __init__(self, clay):
        self.clay = clay

    def __enter__(self):
        Clay_BeginLayout()

    def __exit__(self, exc_type, exc_val, exc_tb):
        cdef Clay_RenderCommandArray array
        array = Clay_EndLayout()
        self.clay.render_commands = RenderCommandArray.from_c(array)

    @staticmethod
    def set_dimensions(width: float, height: float) -> None:
        Clay_SetLayoutDimensions(Clay_Dimensions(width, height))

    def begin(self) -> None:
        Clay_BeginLayout()

    def end(self) -> RenderCommandArray:
        cdef Clay_RenderCommandArray array
        array = Clay_EndLayout()
        return RenderCommandArray.from_c(array)


cdef class Clay:
    cdef public Arena arena
    cdef public RenderCommandArray render_commands

    cdef void* __context

    def __init__(self, (float, float) dimensions):
        cdef size_t memory_size = Clay_MinMemorySize()
        cdef void* memory = PyMem_Malloc(memory_size)
        self.arena = Arena.from_c(
            Clay_CreateArenaWithCapacityAndMemory(memory_size, memory)
        )
        self.__context = Clay_Initialize(
            self.arena.__internal,
            Clay_Dimensions(dimensions[0], dimensions[1]),
            Clay_ErrorHandler(NULL, NULL)
        )

    def layout(self) -> Layout:
        return Layout(self)
