from cpython.mem cimport PyMem_Malloc
from libc.stdio cimport printf

from libclay._clay cimport (
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


cdef class MainContext:
    cdef Clay clay

    def __init__(self, clay):
        self.clay = clay

    def __enter__(self):
        Clay_BeginLayout()

    def __exit__(self, exc_type, exc_val, exc_tb):
        cdef Clay_RenderCommandArray array
        array = Clay_EndLayout()
        self.clay.render_commands = RenderCommandArray.from_c(array)



cdef class Clay:
    cdef Arena arena
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

    def begin(self):
        return MainContext(self)

    def set_layout_dimensions(self, float width, float height):
        Clay_SetLayoutDimensions(Clay_Dimensions(width, height))
