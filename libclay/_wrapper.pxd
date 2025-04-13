from libclay._clay cimport *
from enum import Enum


























cdef class StringSlice:
    cdef Clay_StringSlice __internal



    @staticmethod
    cdef StringSlice from_c(Clay_StringSlice value)


cdef class Arena:
    cdef Clay_Arena __internal



    @staticmethod
    cdef Arena from_c(Clay_Arena value)


cdef class Dimensions:
    cdef Clay_Dimensions __internal


    @staticmethod
    cdef Dimensions from_c(Clay_Dimensions value)


cdef class Vector2:
    cdef Clay_Vector2 __internal


    @staticmethod
    cdef Vector2 from_c(Clay_Vector2 value)


cdef class Color:
    cdef Clay_Color __internal




    @staticmethod
    cdef Color from_c(Clay_Color value)


cdef class BoundingBox:
    cdef Clay_BoundingBox __internal




    @staticmethod
    cdef BoundingBox from_c(Clay_BoundingBox value)


cdef class ElementId:
    cdef Clay_ElementId __internal




    @staticmethod
    cdef ElementId from_c(Clay_ElementId value)


cdef class CornerRadius:
    cdef Clay_CornerRadius __internal




    @staticmethod
    cdef CornerRadius from_c(Clay_CornerRadius value)


cdef class ChildAlignment:
    cdef Clay_ChildAlignment __internal


    @staticmethod
    cdef ChildAlignment from_c(Clay_ChildAlignment value)


cdef class SizingMinMax:
    cdef Clay_SizingMinMax __internal


    @staticmethod
    cdef SizingMinMax from_c(Clay_SizingMinMax value)


cdef class SizingSize:
    cdef Clay_SizingSize __internal


    @staticmethod
    cdef SizingSize from_c(Clay_SizingSize value)


cdef class SizingAxis:
    cdef Clay_SizingAxis __internal


    @staticmethod
    cdef SizingAxis from_c(Clay_SizingAxis value)


cdef class Sizing:
    cdef Clay_Sizing __internal


    @staticmethod
    cdef Sizing from_c(Clay_Sizing value)


cdef class Padding:
    cdef Clay_Padding __internal




    @staticmethod
    cdef Padding from_c(Clay_Padding value)


cdef class PaddingWrapper:
    cdef Clay__Clay_PaddingWrapper __internal

    @staticmethod
    cdef PaddingWrapper from_c(Clay__Clay_PaddingWrapper value)


cdef class LayoutConfig:
    cdef Clay_LayoutConfig __internal





    @staticmethod
    cdef LayoutConfig from_c(Clay_LayoutConfig value)


cdef class LayoutConfigWrapper:
    cdef Clay__Clay_LayoutConfigWrapper __internal

    @staticmethod
    cdef LayoutConfigWrapper from_c(Clay__Clay_LayoutConfigWrapper value)


cdef class TextElementConfig:
    cdef Clay_TextElementConfig __internal








    @staticmethod
    cdef TextElementConfig from_c(Clay_TextElementConfig value)


cdef class TextElementConfigWrapper:
    cdef Clay__Clay_TextElementConfigWrapper __internal

    @staticmethod
    cdef TextElementConfigWrapper from_c(Clay__Clay_TextElementConfigWrapper value)


cdef class ImageElementConfig:
    cdef Clay_ImageElementConfig __internal


    @staticmethod
    cdef ImageElementConfig from_c(Clay_ImageElementConfig value)


cdef class ImageElementConfigWrapper:
    cdef Clay__Clay_ImageElementConfigWrapper __internal

    @staticmethod
    cdef ImageElementConfigWrapper from_c(Clay__Clay_ImageElementConfigWrapper value)


cdef class FloatingAttachPoints:
    cdef Clay_FloatingAttachPoints __internal


    @staticmethod
    cdef FloatingAttachPoints from_c(Clay_FloatingAttachPoints value)


cdef class FloatingElementConfig:
    cdef Clay_FloatingElementConfig __internal







    @staticmethod
    cdef FloatingElementConfig from_c(Clay_FloatingElementConfig value)


cdef class FloatingElementConfigWrapper:
    cdef Clay__Clay_FloatingElementConfigWrapper __internal

    @staticmethod
    cdef FloatingElementConfigWrapper from_c(Clay__Clay_FloatingElementConfigWrapper value)


cdef class CustomElementConfig:
    cdef Clay_CustomElementConfig __internal

    @staticmethod
    cdef CustomElementConfig from_c(Clay_CustomElementConfig value)


cdef class CustomElementConfigWrapper:
    cdef Clay__Clay_CustomElementConfigWrapper __internal

    @staticmethod
    cdef CustomElementConfigWrapper from_c(Clay__Clay_CustomElementConfigWrapper value)


cdef class ScrollElementConfig:
    cdef Clay_ScrollElementConfig __internal


    @staticmethod
    cdef ScrollElementConfig from_c(Clay_ScrollElementConfig value)


cdef class ScrollElementConfigWrapper:
    cdef Clay__Clay_ScrollElementConfigWrapper __internal

    @staticmethod
    cdef ScrollElementConfigWrapper from_c(Clay__Clay_ScrollElementConfigWrapper value)


cdef class BorderWidth:
    cdef Clay_BorderWidth __internal





    @staticmethod
    cdef BorderWidth from_c(Clay_BorderWidth value)


cdef class BorderElementConfig:
    cdef Clay_BorderElementConfig __internal


    @staticmethod
    cdef BorderElementConfig from_c(Clay_BorderElementConfig value)


cdef class BorderElementConfigWrapper:
    cdef Clay__Clay_BorderElementConfigWrapper __internal

    @staticmethod
    cdef BorderElementConfigWrapper from_c(Clay__Clay_BorderElementConfigWrapper value)


cdef class TextRenderData:
    cdef Clay_TextRenderData __internal






    @staticmethod
    cdef TextRenderData from_c(Clay_TextRenderData value)


cdef class RectangleRenderData:
    cdef Clay_RectangleRenderData __internal


    @staticmethod
    cdef RectangleRenderData from_c(Clay_RectangleRenderData value)


cdef class ImageRenderData:
    cdef Clay_ImageRenderData __internal




    @staticmethod
    cdef ImageRenderData from_c(Clay_ImageRenderData value)


cdef class CustomRenderData:
    cdef Clay_CustomRenderData __internal



    @staticmethod
    cdef CustomRenderData from_c(Clay_CustomRenderData value)


cdef class ScrollRenderData:
    cdef Clay_ScrollRenderData __internal


    @staticmethod
    cdef ScrollRenderData from_c(Clay_ScrollRenderData value)


cdef class BorderRenderData:
    cdef Clay_BorderRenderData __internal



    @staticmethod
    cdef BorderRenderData from_c(Clay_BorderRenderData value)


cdef class RenderData:
    cdef Clay_RenderData __internal






    @staticmethod
    cdef RenderData from_c(Clay_RenderData value)


cdef class ScrollContainerData:
    cdef Clay_ScrollContainerData __internal





    @staticmethod
    cdef ScrollContainerData from_c(Clay_ScrollContainerData value)


cdef class ElementData:
    cdef Clay_ElementData __internal


    @staticmethod
    cdef ElementData from_c(Clay_ElementData value)


cdef class RenderCommand:
    cdef Clay_RenderCommand __internal






    @staticmethod
    cdef RenderCommand from_c(Clay_RenderCommand value)


cdef class RenderCommandArray:
    cdef Clay_RenderCommandArray __internal



    @staticmethod
    cdef RenderCommandArray from_c(Clay_RenderCommandArray value)


cdef class PointerData:
    cdef Clay_PointerData __internal


    @staticmethod
    cdef PointerData from_c(Clay_PointerData value)


cdef class ElementDeclaration:
    cdef Clay_ElementDeclaration __internal










    @staticmethod
    cdef ElementDeclaration from_c(Clay_ElementDeclaration value)


cdef class ElementDeclarationWrapper:
    cdef Clay__Clay_ElementDeclarationWrapper __internal

    @staticmethod
    cdef ElementDeclarationWrapper from_c(Clay__Clay_ElementDeclarationWrapper value)


cdef class ErrorData:
    cdef Clay_ErrorData __internal



    @staticmethod
    cdef ErrorData from_c(Clay_ErrorData value)
