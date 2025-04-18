from libclay._clay cimport *
from enum import Enum


























cdef class SizingSize:
    cdef Clay_SizingSize _cvalue

    @staticmethod
    cdef SizingSize from_c(Clay_SizingSize value)


cdef class RenderData:
    cdef Clay_RenderData _cvalue





    @staticmethod
    cdef RenderData from_c(Clay_RenderData value)


cdef class ClayString:
    cdef Clay_String _cvalue
    cdef bytes _bytes
    @staticmethod
    cdef ClayString from_str(str value)

    @staticmethod
    cdef ClayString from_c(Clay_String value)


cdef class StringSlice:
    cdef Clay_StringSlice _cvalue


    @staticmethod
    cdef StringSlice from_c(Clay_StringSlice value)


cdef class Arena:
    cdef Clay_Arena _cvalue


    @staticmethod
    cdef Arena from_c(Clay_Arena value)


cdef class Dimensions:
    cdef Clay_Dimensions _cvalue

    @staticmethod
    cdef Dimensions from_c(Clay_Dimensions value)


cdef class Vector2:
    cdef Clay_Vector2 _cvalue

    @staticmethod
    cdef Vector2 from_c(Clay_Vector2 value)


cdef class Color:
    cdef Clay_Color _cvalue



    @staticmethod
    cdef Color from_c(Clay_Color value)


cdef class BoundingBox:
    cdef Clay_BoundingBox _cvalue



    @staticmethod
    cdef BoundingBox from_c(Clay_BoundingBox value)


cdef class ElementId:
    cdef Clay_ElementId _cvalue



    @staticmethod
    cdef ElementId from_c(Clay_ElementId value)


cdef class CornerRadius:
    cdef Clay_CornerRadius _cvalue



    @staticmethod
    cdef CornerRadius from_c(Clay_CornerRadius value)


cdef class ChildAlignment:
    cdef Clay_ChildAlignment _cvalue

    @staticmethod
    cdef ChildAlignment from_c(Clay_ChildAlignment value)


cdef class SizingMinMax:
    cdef Clay_SizingMinMax _cvalue

    @staticmethod
    cdef SizingMinMax from_c(Clay_SizingMinMax value)


cdef class SizingAxis:
    cdef Clay_SizingAxis _cvalue

    @staticmethod
    cdef SizingAxis from_c(Clay_SizingAxis value)


cdef class Sizing:
    cdef Clay_Sizing _cvalue

    @staticmethod
    cdef Sizing from_c(Clay_Sizing value)


cdef class Padding:
    cdef Clay_Padding _cvalue



    @staticmethod
    cdef Padding from_c(Clay_Padding value)


cdef class LayoutConfig:
    cdef Clay_LayoutConfig _cvalue




    @staticmethod
    cdef LayoutConfig from_c(Clay_LayoutConfig value)


cdef class TextElementConfig:
    cdef Clay_TextElementConfig _cvalue







    @staticmethod
    cdef TextElementConfig from_c(Clay_TextElementConfig value)


cdef class ImageElementConfig:
    cdef Clay_ImageElementConfig _cvalue

    @staticmethod
    cdef ImageElementConfig from_c(Clay_ImageElementConfig value)


cdef class FloatingAttachPoints:
    cdef Clay_FloatingAttachPoints _cvalue

    @staticmethod
    cdef FloatingAttachPoints from_c(Clay_FloatingAttachPoints value)


cdef class FloatingElementConfig:
    cdef Clay_FloatingElementConfig _cvalue






    @staticmethod
    cdef FloatingElementConfig from_c(Clay_FloatingElementConfig value)


cdef class CustomElementConfig:
    cdef Clay_CustomElementConfig _cvalue
    @staticmethod
    cdef CustomElementConfig from_c(Clay_CustomElementConfig value)


cdef class ScrollElementConfig:
    cdef Clay_ScrollElementConfig _cvalue

    @staticmethod
    cdef ScrollElementConfig from_c(Clay_ScrollElementConfig value)


cdef class BorderWidth:
    cdef Clay_BorderWidth _cvalue




    @staticmethod
    cdef BorderWidth from_c(Clay_BorderWidth value)


cdef class BorderElementConfig:
    cdef Clay_BorderElementConfig _cvalue

    @staticmethod
    cdef BorderElementConfig from_c(Clay_BorderElementConfig value)


cdef class TextRenderData:
    cdef Clay_TextRenderData _cvalue





    @staticmethod
    cdef TextRenderData from_c(Clay_TextRenderData value)


cdef class RectangleRenderData:
    cdef Clay_RectangleRenderData _cvalue

    @staticmethod
    cdef RectangleRenderData from_c(Clay_RectangleRenderData value)


cdef class ImageRenderData:
    cdef Clay_ImageRenderData _cvalue



    @staticmethod
    cdef ImageRenderData from_c(Clay_ImageRenderData value)


cdef class CustomRenderData:
    cdef Clay_CustomRenderData _cvalue


    @staticmethod
    cdef CustomRenderData from_c(Clay_CustomRenderData value)


cdef class ScrollRenderData:
    cdef Clay_ScrollRenderData _cvalue

    @staticmethod
    cdef ScrollRenderData from_c(Clay_ScrollRenderData value)


cdef class BorderRenderData:
    cdef Clay_BorderRenderData _cvalue


    @staticmethod
    cdef BorderRenderData from_c(Clay_BorderRenderData value)


cdef class ScrollContainerData:
    cdef Clay_ScrollContainerData _cvalue




    @staticmethod
    cdef ScrollContainerData from_c(Clay_ScrollContainerData value)


cdef class ElementData:
    cdef Clay_ElementData _cvalue

    @staticmethod
    cdef ElementData from_c(Clay_ElementData value)


cdef class RenderCommand:
    cdef Clay_RenderCommand _cvalue





    @staticmethod
    cdef RenderCommand from_c(Clay_RenderCommand value)


cdef class RenderCommandArray:
    cdef Clay_RenderCommandArray _cvalue


    @staticmethod
    cdef RenderCommandArray from_c(Clay_RenderCommandArray value)


cdef class PointerData:
    cdef Clay_PointerData _cvalue

    @staticmethod
    cdef PointerData from_c(Clay_PointerData value)


cdef class ElementDeclaration:
    cdef Clay_ElementDeclaration _cvalue









    @staticmethod
    cdef ElementDeclaration from_c(Clay_ElementDeclaration value)


cdef class ErrorData:
    cdef Clay_ErrorData _cvalue


    @staticmethod
    cdef ErrorData from_c(Clay_ErrorData value)


