from cpython.mem cimport PyMem_Malloc
from libc.stdio cimport printf

from libclay._clay cimport (
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
    Clay_RenderCommandArray,
)
from libclay._wrapper cimport *


class Element:

    def __init__(self, ElementDeclaration element_declaration):
        self.element_declaration = element_declaration

    def __enter__(self):
        self.open(self.element_declaration)

    def __exit__(self, exc_type, exc_val, exc_tb):
        self.close()

    @staticmethod
    def open(element_declaration: ElementDeclaration) -> None:
        Clay__OpenElement()
        Clay__ConfigureOpenElement(element_declaration._cvalue)

    @staticmethod
    def close() -> None:
        Clay__CloseElement()

    @staticmethod
    def new_id(id_string: str) -> ElementId:
        cdef ClayString string = ClayString.from_str(id_string)
        cdef Clay_ElementId clay_element_id = Clay_GetElementId(string._cvalue)
        return ElementId.from_c(clay_element_id)


cdef class Layout:
    cdef Clay clay

    def __init__(self, clay):
        self.clay = clay

    def __enter__(self):
        self.begin()

    def __exit__(self, exc_type, exc_val, exc_tb):
        self.clay.render_commands = self.end()

    def set_dimensions(self, width: float, height: float) -> None:
        Clay_SetLayoutDimensions(Clay_Dimensions(width, height))

    def begin(self) -> None:
        Clay_BeginLayout()

    def end(self) -> RenderCommandArray:
        cdef Clay_RenderCommandArray array
        array = Clay_EndLayout()
        print(array)
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
            self.arena._cvalue,
            Clay_Dimensions(dimensions[0], dimensions[1]),
            Clay_ErrorHandler(NULL, NULL)
        )

    def layout(self) -> Layout:
        return Layout(self)
