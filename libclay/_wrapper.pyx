from cpython.mem cimport PyMem_Malloc
from libc.string cimport strncpy
from libclay._clay cimport *
from enum import Enum
from typing import Optional


class LayoutDirection(Enum):
    LEFT_TO_RIGHT = CLAY_LEFT_TO_RIGHT
    TOP_TO_BOTTOM = CLAY_TOP_TO_BOTTOM


class LayoutAlignmentX(Enum):
    LEFT = CLAY_ALIGN_X_LEFT
    RIGHT = CLAY_ALIGN_X_RIGHT
    CENTER = CLAY_ALIGN_X_CENTER


class LayoutAlignmentY(Enum):
    TOP = CLAY_ALIGN_Y_TOP
    BOTTOM = CLAY_ALIGN_Y_BOTTOM
    CENTER = CLAY_ALIGN_Y_CENTER


class SizingType(Enum):
    FIT = CLAY__SIZING_TYPE_FIT
    GROW = CLAY__SIZING_TYPE_GROW
    PERCENT = CLAY__SIZING_TYPE_PERCENT
    FIXED = CLAY__SIZING_TYPE_FIXED


class TextElementConfigWrapMode(Enum):
    WORDS = CLAY_TEXT_WRAP_WORDS
    NEWLINES = CLAY_TEXT_WRAP_NEWLINES
    NONE = CLAY_TEXT_WRAP_NONE


class TextAlignment(Enum):
    LEFT = CLAY_TEXT_ALIGN_LEFT
    CENTER = CLAY_TEXT_ALIGN_CENTER
    RIGHT = CLAY_TEXT_ALIGN_RIGHT


class FloatingAttachPointType(Enum):
    LEFT_TOP = CLAY_ATTACH_POINT_LEFT_TOP
    LEFT_CENTER = CLAY_ATTACH_POINT_LEFT_CENTER
    LEFT_BOTTOM = CLAY_ATTACH_POINT_LEFT_BOTTOM
    CENTER_TOP = CLAY_ATTACH_POINT_CENTER_TOP
    CENTER_CENTER = CLAY_ATTACH_POINT_CENTER_CENTER
    CENTER_BOTTOM = CLAY_ATTACH_POINT_CENTER_BOTTOM
    RIGHT_TOP = CLAY_ATTACH_POINT_RIGHT_TOP
    RIGHT_CENTER = CLAY_ATTACH_POINT_RIGHT_CENTER
    RIGHT_BOTTOM = CLAY_ATTACH_POINT_RIGHT_BOTTOM


class PointerCaptureMode(Enum):
    CAPTURE = CLAY_POINTER_CAPTURE_MODE_CAPTURE
    PASSTHROUGH = CLAY_POINTER_CAPTURE_MODE_PASSTHROUGH


class FloatingAttachToElement(Enum):
    NONE = CLAY_ATTACH_TO_NONE
    PARENT = CLAY_ATTACH_TO_PARENT
    ELEMENT_WITH_ID = CLAY_ATTACH_TO_ELEMENT_WITH_ID
    ROOT = CLAY_ATTACH_TO_ROOT


class RenderCommandType(Enum):
    NONE = CLAY_RENDER_COMMAND_TYPE_NONE
    RECTANGLE = CLAY_RENDER_COMMAND_TYPE_RECTANGLE
    BORDER = CLAY_RENDER_COMMAND_TYPE_BORDER
    TEXT = CLAY_RENDER_COMMAND_TYPE_TEXT
    IMAGE = CLAY_RENDER_COMMAND_TYPE_IMAGE
    SCISSOR_START = CLAY_RENDER_COMMAND_TYPE_SCISSOR_START
    SCISSOR_END = CLAY_RENDER_COMMAND_TYPE_SCISSOR_END
    CUSTOM = CLAY_RENDER_COMMAND_TYPE_CUSTOM


class PointerDataInteractionState(Enum):
    PRESSED_THIS_FRAME = CLAY_POINTER_DATA_PRESSED_THIS_FRAME
    PRESSED = CLAY_POINTER_DATA_PRESSED
    RELEASED_THIS_FRAME = CLAY_POINTER_DATA_RELEASED_THIS_FRAME
    RELEASED = CLAY_POINTER_DATA_RELEASED


class ErrorType(Enum):
    TEXT_MEASUREMENT_FUNCTION_NOT_PROVIDED = CLAY_ERROR_TYPE_TEXT_MEASUREMENT_FUNCTION_NOT_PROVIDED
    ARENA_CAPACITY_EXCEEDED = CLAY_ERROR_TYPE_ARENA_CAPACITY_EXCEEDED
    ELEMENTS_CAPACITY_EXCEEDED = CLAY_ERROR_TYPE_ELEMENTS_CAPACITY_EXCEEDED
    TEXT_MEASUREMENT_CAPACITY_EXCEEDED = CLAY_ERROR_TYPE_TEXT_MEASUREMENT_CAPACITY_EXCEEDED
    DUPLICATE_ID = CLAY_ERROR_TYPE_DUPLICATE_ID
    FLOATING_CONTAINER_PARENT_NOT_FOUND = CLAY_ERROR_TYPE_FLOATING_CONTAINER_PARENT_NOT_FOUND
    PERCENTAGE_OVER_1 = CLAY_ERROR_TYPE_PERCENTAGE_OVER_1
    INTERNAL_ERROR = CLAY_ERROR_TYPE_INTERNAL_ERROR


cdef class SizingSize:
    def __init__(self, *, min_max: Optional[SizingMinMax] = None, percent = None):
        if min_max:
            self._cvalue = Clay_SizingSize(minMax=min_max)
        elif percent:
            self._cvalue = Clay_SizingSize(percent=percent)
        else:
            raise ValueError('no')
    @property
    def min_max(self) -> SizingMinMax:
        return SizingMinMax.from_c(self._cvalue.minMax)
    @min_max.setter
    def min_max(self, value: SizingMinMax):
        self._cvalue.minMax = value._cvalue

    @property
    def percent(self):
        return self._cvalue.percent
    @percent.setter
    def percent(self, value):
        self._cvalue.percent = value

    @staticmethod
    cdef SizingSize from_c(Clay_SizingSize value):
        cdef SizingSize instance = SizingSize.__new__(SizingSize)
        instance._cvalue = value
        return instance



cdef class RenderData:
    def __init__(self):
        raise TypeError('This class cannot be instantiated directly.')

    @property
    def rectangle(self) -> RectangleRenderData:
        return RectangleRenderData.from_c(self._cvalue.rectangle)

    @property
    def text(self) -> TextRenderData:
        return TextRenderData.from_c(self._cvalue.text)

    @property
    def image(self) -> ImageRenderData:
        return ImageRenderData.from_c(self._cvalue.image)

    @property
    def custom(self) -> CustomRenderData:
        return CustomRenderData.from_c(self._cvalue.custom)

    @property
    def border(self) -> BorderRenderData:
        return BorderRenderData.from_c(self._cvalue.border)

    @property
    def scroll(self) -> ScrollRenderData:
        return ScrollRenderData.from_c(self._cvalue.scroll)

    @staticmethod
    cdef RenderData from_c(Clay_RenderData value):
        cdef RenderData instance = RenderData.__new__(RenderData)
        instance._cvalue = value
        return instance



cdef class ClayString:
    def __init__(self):
        raise TypeError('This class cannot be instantiated directly.')


    def __str__(self):
        cdef bytes _bytes = self._cvalue.chars
        return _bytes.decode("utf-8")


    @staticmethod
    cdef ClayString from_str(str value):
        cdef ClayString instance = ClayString.__new__(ClayString)
        instance._bytes = value.encode("utf-8")
        instance._cvalue = Clay_String(
            isStaticallyAllocated=False,
            length=len(instance._bytes),
            chars=instance._bytes)
        return instance


    @staticmethod
    cdef ClayString from_c(Clay_String value):
        cdef ClayString instance = ClayString.__new__(ClayString)
        instance._cvalue = value
        return instance



cdef class StringSlice:
    def __init__(self,
            length = None,
            chars = None,
            base_chars = None
    ):
        if length is not None:
            self._cvalue.length = length
        if chars is not None:
            self._cvalue.chars = chars
        if base_chars is not None:
            self._cvalue.baseChars = base_chars


    @property
    def length(self):
        return self._cvalue.length
    @length.setter
    def length(self, value):
        self._cvalue.length = value

    @property
    def chars(self):
        return self._cvalue.chars
    @chars.setter
    def chars(self, value):
        self._cvalue.chars = value

    @property
    def base_chars(self):
        return self._cvalue.baseChars
    @base_chars.setter
    def base_chars(self, value):
        self._cvalue.baseChars = value

    @staticmethod
    cdef StringSlice from_c(Clay_StringSlice value):
        cdef StringSlice instance = StringSlice.__new__(StringSlice)
        instance._cvalue = value
        return instance



cdef class Arena:
    def __init__(self):
        raise TypeError('This class cannot be instantiated directly.')

    @property
    def next_allocation(self):
        return self._cvalue.nextAllocation

    @property
    def capacity(self):
        return self._cvalue.capacity

    @property
    def memory(self):
        return self._cvalue.memory

    @staticmethod
    cdef Arena from_c(Clay_Arena value):
        cdef Arena instance = Arena.__new__(Arena)
        instance._cvalue = value
        return instance



cdef class Dimensions:
    def __init__(self,
            width = None,
            height = None
    ):
        if width is not None:
            self._cvalue.width = width
        if height is not None:
            self._cvalue.height = height


    @property
    def width(self):
        return self._cvalue.width
    @width.setter
    def width(self, value):
        self._cvalue.width = value

    @property
    def height(self):
        return self._cvalue.height
    @height.setter
    def height(self, value):
        self._cvalue.height = value

    @staticmethod
    cdef Dimensions from_c(Clay_Dimensions value):
        cdef Dimensions instance = Dimensions.__new__(Dimensions)
        instance._cvalue = value
        return instance



cdef class Vector2:
    def __init__(self,
            x = None,
            y = None
    ):
        if x is not None:
            self._cvalue.x = x
        if y is not None:
            self._cvalue.y = y


    @property
    def x(self):
        return self._cvalue.x
    @x.setter
    def x(self, value):
        self._cvalue.x = value

    @property
    def y(self):
        return self._cvalue.y
    @y.setter
    def y(self, value):
        self._cvalue.y = value

    @staticmethod
    cdef Vector2 from_c(Clay_Vector2 value):
        cdef Vector2 instance = Vector2.__new__(Vector2)
        instance._cvalue = value
        return instance



cdef class Color:
    def __init__(self,
            r = None,
            g = None,
            b = None,
            a = None
    ):
        if r is not None:
            self._cvalue.r = r
        if g is not None:
            self._cvalue.g = g
        if b is not None:
            self._cvalue.b = b
        if a is not None:
            self._cvalue.a = a


    @property
    def r(self):
        return self._cvalue.r
    @r.setter
    def r(self, value):
        self._cvalue.r = value

    @property
    def g(self):
        return self._cvalue.g
    @g.setter
    def g(self, value):
        self._cvalue.g = value

    @property
    def b(self):
        return self._cvalue.b
    @b.setter
    def b(self, value):
        self._cvalue.b = value

    @property
    def a(self):
        return self._cvalue.a
    @a.setter
    def a(self, value):
        self._cvalue.a = value

    @staticmethod
    cdef Color from_c(Clay_Color value):
        cdef Color instance = Color.__new__(Color)
        instance._cvalue = value
        return instance



cdef class BoundingBox:
    def __init__(self,
            x = None,
            y = None,
            width = None,
            height = None
    ):
        if x is not None:
            self._cvalue.x = x
        if y is not None:
            self._cvalue.y = y
        if width is not None:
            self._cvalue.width = width
        if height is not None:
            self._cvalue.height = height


    @property
    def x(self):
        return self._cvalue.x
    @x.setter
    def x(self, value):
        self._cvalue.x = value

    @property
    def y(self):
        return self._cvalue.y
    @y.setter
    def y(self, value):
        self._cvalue.y = value

    @property
    def width(self):
        return self._cvalue.width
    @width.setter
    def width(self, value):
        self._cvalue.width = value

    @property
    def height(self):
        return self._cvalue.height
    @height.setter
    def height(self, value):
        self._cvalue.height = value

    @staticmethod
    cdef BoundingBox from_c(Clay_BoundingBox value):
        cdef BoundingBox instance = BoundingBox.__new__(BoundingBox)
        instance._cvalue = value
        return instance



cdef class ElementId:
    def __init__(self):
        raise TypeError('This class cannot be instantiated directly.')

    @property
    def id_(self):
        return self._cvalue.id

    @property
    def offset(self):
        return self._cvalue.offset

    @property
    def base_id(self):
        return self._cvalue.baseId

    @property
    def string_id(self) -> ClayString:
        return ClayString.from_c(self._cvalue.stringId)

    @staticmethod
    cdef ElementId from_c(Clay_ElementId value):
        cdef ElementId instance = ElementId.__new__(ElementId)
        instance._cvalue = value
        return instance



cdef class CornerRadius:
    def __init__(self,
            top_left = None,
            top_right = None,
            bottom_left = None,
            bottom_right = None
    ):
        if top_left is not None:
            self._cvalue.topLeft = top_left
        if top_right is not None:
            self._cvalue.topRight = top_right
        if bottom_left is not None:
            self._cvalue.bottomLeft = bottom_left
        if bottom_right is not None:
            self._cvalue.bottomRight = bottom_right


    @property
    def top_left(self):
        return self._cvalue.topLeft
    @top_left.setter
    def top_left(self, value):
        self._cvalue.topLeft = value

    @property
    def top_right(self):
        return self._cvalue.topRight
    @top_right.setter
    def top_right(self, value):
        self._cvalue.topRight = value

    @property
    def bottom_left(self):
        return self._cvalue.bottomLeft
    @bottom_left.setter
    def bottom_left(self, value):
        self._cvalue.bottomLeft = value

    @property
    def bottom_right(self):
        return self._cvalue.bottomRight
    @bottom_right.setter
    def bottom_right(self, value):
        self._cvalue.bottomRight = value

    @staticmethod
    cdef CornerRadius from_c(Clay_CornerRadius value):
        cdef CornerRadius instance = CornerRadius.__new__(CornerRadius)
        instance._cvalue = value
        return instance



cdef class ChildAlignment:
    def __init__(self,
            x: Optional[LayoutAlignmentX] = None,
            y: Optional[LayoutAlignmentY] = None
    ):
        if x is not None:
            self._cvalue.x = x.value
        if y is not None:
            self._cvalue.y = y.value


    @property
    def x(self) -> LayoutAlignmentX:
        return LayoutAlignmentX(self._cvalue.x)
    @x.setter
    def x(self, value: LayoutAlignmentX):
        self._cvalue.x = value.value

    @property
    def y(self) -> LayoutAlignmentY:
        return LayoutAlignmentY(self._cvalue.y)
    @y.setter
    def y(self, value: LayoutAlignmentY):
        self._cvalue.y = value.value

    @staticmethod
    cdef ChildAlignment from_c(Clay_ChildAlignment value):
        cdef ChildAlignment instance = ChildAlignment.__new__(ChildAlignment)
        instance._cvalue = value
        return instance



cdef class SizingMinMax:
    def __init__(self,
            min_ = None,
            max_ = None
    ):
        if min_ is not None:
            self._cvalue.min = min_
        if max_ is not None:
            self._cvalue.max = max_


    @property
    def min_(self):
        return self._cvalue.min
    @min_.setter
    def min_(self, value):
        self._cvalue.min = value

    @property
    def max_(self):
        return self._cvalue.max
    @max_.setter
    def max_(self, value):
        self._cvalue.max = value

    @staticmethod
    cdef SizingMinMax from_c(Clay_SizingMinMax value):
        cdef SizingMinMax instance = SizingMinMax.__new__(SizingMinMax)
        instance._cvalue = value
        return instance



cdef class SizingAxis:
    def __init__(self,
            size: Optional[SizingSize] = None,
            type_: Optional[SizingType] = None
    ):
        if size is not None:
            self._cvalue.size = size._cvalue
        if type_ is not None:
            self._cvalue.type = type_.value


    @property
    def size(self) -> SizingSize:
        return SizingSize.from_c(self._cvalue.size)
    @size.setter
    def size(self, value: SizingSize):
        self._cvalue.size = value._cvalue

    @property
    def type_(self) -> SizingType:
        return SizingType(self._cvalue.type)
    @type_.setter
    def type_(self, value: SizingType):
        self._cvalue.type = value.value

    @staticmethod
    cdef SizingAxis from_c(Clay_SizingAxis value):
        cdef SizingAxis instance = SizingAxis.__new__(SizingAxis)
        instance._cvalue = value
        return instance



cdef class Sizing:
    def __init__(self,
            width: Optional[SizingAxis] = None,
            height: Optional[SizingAxis] = None
    ):
        if width is not None:
            self._cvalue.width = width._cvalue
        if height is not None:
            self._cvalue.height = height._cvalue


    @property
    def width(self) -> SizingAxis:
        return SizingAxis.from_c(self._cvalue.width)
    @width.setter
    def width(self, value: SizingAxis):
        self._cvalue.width = value._cvalue

    @property
    def height(self) -> SizingAxis:
        return SizingAxis.from_c(self._cvalue.height)
    @height.setter
    def height(self, value: SizingAxis):
        self._cvalue.height = value._cvalue

    @staticmethod
    cdef Sizing from_c(Clay_Sizing value):
        cdef Sizing instance = Sizing.__new__(Sizing)
        instance._cvalue = value
        return instance



cdef class Padding:
    def __init__(self,
            left = None,
            right = None,
            top = None,
            bottom = None
    ):
        if left is not None:
            self._cvalue.left = left
        if right is not None:
            self._cvalue.right = right
        if top is not None:
            self._cvalue.top = top
        if bottom is not None:
            self._cvalue.bottom = bottom


    @property
    def left(self):
        return self._cvalue.left
    @left.setter
    def left(self, value):
        self._cvalue.left = value

    @property
    def right(self):
        return self._cvalue.right
    @right.setter
    def right(self, value):
        self._cvalue.right = value

    @property
    def top(self):
        return self._cvalue.top
    @top.setter
    def top(self, value):
        self._cvalue.top = value

    @property
    def bottom(self):
        return self._cvalue.bottom
    @bottom.setter
    def bottom(self, value):
        self._cvalue.bottom = value

    @staticmethod
    cdef Padding from_c(Clay_Padding value):
        cdef Padding instance = Padding.__new__(Padding)
        instance._cvalue = value
        return instance



cdef class LayoutConfig:
    def __init__(self,
            sizing: Optional[Sizing] = None,
            padding: Optional[Padding] = None,
            child_gap = None,
            child_alignment: Optional[ChildAlignment] = None,
            layout_direction: Optional[LayoutDirection] = None
    ):
        if sizing is not None:
            self._cvalue.sizing = sizing._cvalue
        if padding is not None:
            self._cvalue.padding = padding._cvalue
        if child_gap is not None:
            self._cvalue.childGap = child_gap
        if child_alignment is not None:
            self._cvalue.childAlignment = child_alignment._cvalue
        if layout_direction is not None:
            self._cvalue.layoutDirection = layout_direction.value


    @property
    def sizing(self) -> Sizing:
        return Sizing.from_c(self._cvalue.sizing)
    @sizing.setter
    def sizing(self, value: Sizing):
        self._cvalue.sizing = value._cvalue

    @property
    def padding(self) -> Padding:
        return Padding.from_c(self._cvalue.padding)
    @padding.setter
    def padding(self, value: Padding):
        self._cvalue.padding = value._cvalue

    @property
    def child_gap(self):
        return self._cvalue.childGap
    @child_gap.setter
    def child_gap(self, value):
        self._cvalue.childGap = value

    @property
    def child_alignment(self) -> ChildAlignment:
        return ChildAlignment.from_c(self._cvalue.childAlignment)
    @child_alignment.setter
    def child_alignment(self, value: ChildAlignment):
        self._cvalue.childAlignment = value._cvalue

    @property
    def layout_direction(self) -> LayoutDirection:
        return LayoutDirection(self._cvalue.layoutDirection)
    @layout_direction.setter
    def layout_direction(self, value: LayoutDirection):
        self._cvalue.layoutDirection = value.value

    @staticmethod
    cdef LayoutConfig from_c(Clay_LayoutConfig value):
        cdef LayoutConfig instance = LayoutConfig.__new__(LayoutConfig)
        instance._cvalue = value
        return instance



cdef class TextElementConfig:
    def __init__(self,
            user_data: Optional[object] = None,
            text_color: Optional[Color] = None,
            font_id = None,
            font_size = None,
            letter_spacing = None,
            line_height = None,
            wrap_mode: Optional[TextElementConfigWrapMode] = None,
            text_alignment: Optional[TextAlignment] = None
    ):
        if user_data is not None:
            self._cvalue.userData = <void*> user_data
        if text_color is not None:
            self._cvalue.textColor = text_color._cvalue
        if font_id is not None:
            self._cvalue.fontId = font_id
        if font_size is not None:
            self._cvalue.fontSize = font_size
        if letter_spacing is not None:
            self._cvalue.letterSpacing = letter_spacing
        if line_height is not None:
            self._cvalue.lineHeight = line_height
        if wrap_mode is not None:
            self._cvalue.wrapMode = wrap_mode.value
        if text_alignment is not None:
            self._cvalue.textAlignment = text_alignment.value


    @property
    def user_data(self) -> object:
        return <object> self._cvalue.userData
    @user_data.setter
    def user_data(self, value: object):
        self._cvalue.userData = <void*> value

    @property
    def text_color(self) -> Color:
        return Color.from_c(self._cvalue.textColor)
    @text_color.setter
    def text_color(self, value: Color):
        self._cvalue.textColor = value._cvalue

    @property
    def font_id(self):
        return self._cvalue.fontId
    @font_id.setter
    def font_id(self, value):
        self._cvalue.fontId = value

    @property
    def font_size(self):
        return self._cvalue.fontSize
    @font_size.setter
    def font_size(self, value):
        self._cvalue.fontSize = value

    @property
    def letter_spacing(self):
        return self._cvalue.letterSpacing
    @letter_spacing.setter
    def letter_spacing(self, value):
        self._cvalue.letterSpacing = value

    @property
    def line_height(self):
        return self._cvalue.lineHeight
    @line_height.setter
    def line_height(self, value):
        self._cvalue.lineHeight = value

    @property
    def wrap_mode(self) -> TextElementConfigWrapMode:
        return TextElementConfigWrapMode(self._cvalue.wrapMode)
    @wrap_mode.setter
    def wrap_mode(self, value: TextElementConfigWrapMode):
        self._cvalue.wrapMode = value.value

    @property
    def text_alignment(self) -> TextAlignment:
        return TextAlignment(self._cvalue.textAlignment)
    @text_alignment.setter
    def text_alignment(self, value: TextAlignment):
        self._cvalue.textAlignment = value.value

    @staticmethod
    cdef TextElementConfig from_c(Clay_TextElementConfig value):
        cdef TextElementConfig instance = TextElementConfig.__new__(TextElementConfig)
        instance._cvalue = value
        return instance



cdef class ImageElementConfig:
    def __init__(self,
            image_data: Optional[object] = None,
            source_dimensions: Optional[Dimensions] = None
    ):
        if image_data is not None:
            self._cvalue.imageData = <void*> image_data
        if source_dimensions is not None:
            self._cvalue.sourceDimensions = source_dimensions._cvalue


    @property
    def image_data(self) -> object:
        return <object> self._cvalue.imageData
    @image_data.setter
    def image_data(self, value: object):
        self._cvalue.imageData = <void*> value

    @property
    def source_dimensions(self) -> Dimensions:
        return Dimensions.from_c(self._cvalue.sourceDimensions)
    @source_dimensions.setter
    def source_dimensions(self, value: Dimensions):
        self._cvalue.sourceDimensions = value._cvalue

    @staticmethod
    cdef ImageElementConfig from_c(Clay_ImageElementConfig value):
        cdef ImageElementConfig instance = ImageElementConfig.__new__(ImageElementConfig)
        instance._cvalue = value
        return instance



cdef class FloatingAttachPoints:
    def __init__(self,
            element: Optional[FloatingAttachPointType] = None,
            parent: Optional[FloatingAttachPointType] = None
    ):
        if element is not None:
            self._cvalue.element = element.value
        if parent is not None:
            self._cvalue.parent = parent.value


    @property
    def element(self) -> FloatingAttachPointType:
        return FloatingAttachPointType(self._cvalue.element)
    @element.setter
    def element(self, value: FloatingAttachPointType):
        self._cvalue.element = value.value

    @property
    def parent(self) -> FloatingAttachPointType:
        return FloatingAttachPointType(self._cvalue.parent)
    @parent.setter
    def parent(self, value: FloatingAttachPointType):
        self._cvalue.parent = value.value

    @staticmethod
    cdef FloatingAttachPoints from_c(Clay_FloatingAttachPoints value):
        cdef FloatingAttachPoints instance = FloatingAttachPoints.__new__(FloatingAttachPoints)
        instance._cvalue = value
        return instance



cdef class FloatingElementConfig:
    def __init__(self,
            offset: Optional[Vector2] = None,
            expand: Optional[Dimensions] = None,
            parent_id = None,
            z_index = None,
            attach_points: Optional[FloatingAttachPoints] = None,
            pointer_capture_mode: Optional[PointerCaptureMode] = None,
            attach_to: Optional[FloatingAttachToElement] = None
    ):
        if offset is not None:
            self._cvalue.offset = offset._cvalue
        if expand is not None:
            self._cvalue.expand = expand._cvalue
        if parent_id is not None:
            self._cvalue.parentId = parent_id
        if z_index is not None:
            self._cvalue.zIndex = z_index
        if attach_points is not None:
            self._cvalue.attachPoints = attach_points._cvalue
        if pointer_capture_mode is not None:
            self._cvalue.pointerCaptureMode = pointer_capture_mode.value
        if attach_to is not None:
            self._cvalue.attachTo = attach_to.value


    @property
    def offset(self) -> Vector2:
        return Vector2.from_c(self._cvalue.offset)
    @offset.setter
    def offset(self, value: Vector2):
        self._cvalue.offset = value._cvalue

    @property
    def expand(self) -> Dimensions:
        return Dimensions.from_c(self._cvalue.expand)
    @expand.setter
    def expand(self, value: Dimensions):
        self._cvalue.expand = value._cvalue

    @property
    def parent_id(self):
        return self._cvalue.parentId
    @parent_id.setter
    def parent_id(self, value):
        self._cvalue.parentId = value

    @property
    def z_index(self):
        return self._cvalue.zIndex
    @z_index.setter
    def z_index(self, value):
        self._cvalue.zIndex = value

    @property
    def attach_points(self) -> FloatingAttachPoints:
        return FloatingAttachPoints.from_c(self._cvalue.attachPoints)
    @attach_points.setter
    def attach_points(self, value: FloatingAttachPoints):
        self._cvalue.attachPoints = value._cvalue

    @property
    def pointer_capture_mode(self) -> PointerCaptureMode:
        return PointerCaptureMode(self._cvalue.pointerCaptureMode)
    @pointer_capture_mode.setter
    def pointer_capture_mode(self, value: PointerCaptureMode):
        self._cvalue.pointerCaptureMode = value.value

    @property
    def attach_to(self) -> FloatingAttachToElement:
        return FloatingAttachToElement(self._cvalue.attachTo)
    @attach_to.setter
    def attach_to(self, value: FloatingAttachToElement):
        self._cvalue.attachTo = value.value

    @staticmethod
    cdef FloatingElementConfig from_c(Clay_FloatingElementConfig value):
        cdef FloatingElementConfig instance = FloatingElementConfig.__new__(FloatingElementConfig)
        instance._cvalue = value
        return instance



cdef class CustomElementConfig:
    def __init__(self,
            custom_data: Optional[object] = None
    ):
        if custom_data is not None:
            self._cvalue.customData = <void*> custom_data


    @property
    def custom_data(self) -> object:
        return <object> self._cvalue.customData
    @custom_data.setter
    def custom_data(self, value: object):
        self._cvalue.customData = <void*> value

    @staticmethod
    cdef CustomElementConfig from_c(Clay_CustomElementConfig value):
        cdef CustomElementConfig instance = CustomElementConfig.__new__(CustomElementConfig)
        instance._cvalue = value
        return instance



cdef class ScrollElementConfig:
    def __init__(self,
            horizontal = None,
            vertical = None
    ):
        if horizontal is not None:
            self._cvalue.horizontal = horizontal
        if vertical is not None:
            self._cvalue.vertical = vertical


    @property
    def horizontal(self):
        return self._cvalue.horizontal
    @horizontal.setter
    def horizontal(self, value):
        self._cvalue.horizontal = value

    @property
    def vertical(self):
        return self._cvalue.vertical
    @vertical.setter
    def vertical(self, value):
        self._cvalue.vertical = value

    @staticmethod
    cdef ScrollElementConfig from_c(Clay_ScrollElementConfig value):
        cdef ScrollElementConfig instance = ScrollElementConfig.__new__(ScrollElementConfig)
        instance._cvalue = value
        return instance



cdef class BorderWidth:
    def __init__(self,
            left = None,
            right = None,
            top = None,
            bottom = None,
            between_children = None
    ):
        if left is not None:
            self._cvalue.left = left
        if right is not None:
            self._cvalue.right = right
        if top is not None:
            self._cvalue.top = top
        if bottom is not None:
            self._cvalue.bottom = bottom
        if between_children is not None:
            self._cvalue.betweenChildren = between_children


    @property
    def left(self):
        return self._cvalue.left
    @left.setter
    def left(self, value):
        self._cvalue.left = value

    @property
    def right(self):
        return self._cvalue.right
    @right.setter
    def right(self, value):
        self._cvalue.right = value

    @property
    def top(self):
        return self._cvalue.top
    @top.setter
    def top(self, value):
        self._cvalue.top = value

    @property
    def bottom(self):
        return self._cvalue.bottom
    @bottom.setter
    def bottom(self, value):
        self._cvalue.bottom = value

    @property
    def between_children(self):
        return self._cvalue.betweenChildren
    @between_children.setter
    def between_children(self, value):
        self._cvalue.betweenChildren = value

    @staticmethod
    cdef BorderWidth from_c(Clay_BorderWidth value):
        cdef BorderWidth instance = BorderWidth.__new__(BorderWidth)
        instance._cvalue = value
        return instance



cdef class BorderElementConfig:
    def __init__(self,
            color: Optional[Color] = None,
            width: Optional[BorderWidth] = None
    ):
        if color is not None:
            self._cvalue.color = color._cvalue
        if width is not None:
            self._cvalue.width = width._cvalue


    @property
    def color(self) -> Color:
        return Color.from_c(self._cvalue.color)
    @color.setter
    def color(self, value: Color):
        self._cvalue.color = value._cvalue

    @property
    def width(self) -> BorderWidth:
        return BorderWidth.from_c(self._cvalue.width)
    @width.setter
    def width(self, value: BorderWidth):
        self._cvalue.width = value._cvalue

    @staticmethod
    cdef BorderElementConfig from_c(Clay_BorderElementConfig value):
        cdef BorderElementConfig instance = BorderElementConfig.__new__(BorderElementConfig)
        instance._cvalue = value
        return instance



cdef class TextRenderData:
    def __init__(self,
            string_contents: Optional[StringSlice] = None,
            text_color: Optional[Color] = None,
            font_id = None,
            font_size = None,
            letter_spacing = None,
            line_height = None
    ):
        if string_contents is not None:
            self._cvalue.stringContents = string_contents._cvalue
        if text_color is not None:
            self._cvalue.textColor = text_color._cvalue
        if font_id is not None:
            self._cvalue.fontId = font_id
        if font_size is not None:
            self._cvalue.fontSize = font_size
        if letter_spacing is not None:
            self._cvalue.letterSpacing = letter_spacing
        if line_height is not None:
            self._cvalue.lineHeight = line_height


    @property
    def string_contents(self) -> StringSlice:
        return StringSlice.from_c(self._cvalue.stringContents)
    @string_contents.setter
    def string_contents(self, value: StringSlice):
        self._cvalue.stringContents = value._cvalue

    @property
    def text_color(self) -> Color:
        return Color.from_c(self._cvalue.textColor)
    @text_color.setter
    def text_color(self, value: Color):
        self._cvalue.textColor = value._cvalue

    @property
    def font_id(self):
        return self._cvalue.fontId
    @font_id.setter
    def font_id(self, value):
        self._cvalue.fontId = value

    @property
    def font_size(self):
        return self._cvalue.fontSize
    @font_size.setter
    def font_size(self, value):
        self._cvalue.fontSize = value

    @property
    def letter_spacing(self):
        return self._cvalue.letterSpacing
    @letter_spacing.setter
    def letter_spacing(self, value):
        self._cvalue.letterSpacing = value

    @property
    def line_height(self):
        return self._cvalue.lineHeight
    @line_height.setter
    def line_height(self, value):
        self._cvalue.lineHeight = value

    @staticmethod
    cdef TextRenderData from_c(Clay_TextRenderData value):
        cdef TextRenderData instance = TextRenderData.__new__(TextRenderData)
        instance._cvalue = value
        return instance



cdef class RectangleRenderData:
    def __init__(self,
            background_color: Optional[Color] = None,
            corner_radius: Optional[CornerRadius] = None
    ):
        if background_color is not None:
            self._cvalue.backgroundColor = background_color._cvalue
        if corner_radius is not None:
            self._cvalue.cornerRadius = corner_radius._cvalue


    @property
    def background_color(self) -> Color:
        return Color.from_c(self._cvalue.backgroundColor)
    @background_color.setter
    def background_color(self, value: Color):
        self._cvalue.backgroundColor = value._cvalue

    @property
    def corner_radius(self) -> CornerRadius:
        return CornerRadius.from_c(self._cvalue.cornerRadius)
    @corner_radius.setter
    def corner_radius(self, value: CornerRadius):
        self._cvalue.cornerRadius = value._cvalue

    @staticmethod
    cdef RectangleRenderData from_c(Clay_RectangleRenderData value):
        cdef RectangleRenderData instance = RectangleRenderData.__new__(RectangleRenderData)
        instance._cvalue = value
        return instance



cdef class ImageRenderData:
    def __init__(self,
            background_color: Optional[Color] = None,
            corner_radius: Optional[CornerRadius] = None,
            source_dimensions: Optional[Dimensions] = None,
            image_data: Optional[object] = None
    ):
        if background_color is not None:
            self._cvalue.backgroundColor = background_color._cvalue
        if corner_radius is not None:
            self._cvalue.cornerRadius = corner_radius._cvalue
        if source_dimensions is not None:
            self._cvalue.sourceDimensions = source_dimensions._cvalue
        if image_data is not None:
            self._cvalue.imageData = <void*> image_data


    @property
    def background_color(self) -> Color:
        return Color.from_c(self._cvalue.backgroundColor)
    @background_color.setter
    def background_color(self, value: Color):
        self._cvalue.backgroundColor = value._cvalue

    @property
    def corner_radius(self) -> CornerRadius:
        return CornerRadius.from_c(self._cvalue.cornerRadius)
    @corner_radius.setter
    def corner_radius(self, value: CornerRadius):
        self._cvalue.cornerRadius = value._cvalue

    @property
    def source_dimensions(self) -> Dimensions:
        return Dimensions.from_c(self._cvalue.sourceDimensions)
    @source_dimensions.setter
    def source_dimensions(self, value: Dimensions):
        self._cvalue.sourceDimensions = value._cvalue

    @property
    def image_data(self) -> object:
        return <object> self._cvalue.imageData
    @image_data.setter
    def image_data(self, value: object):
        self._cvalue.imageData = <void*> value

    @staticmethod
    cdef ImageRenderData from_c(Clay_ImageRenderData value):
        cdef ImageRenderData instance = ImageRenderData.__new__(ImageRenderData)
        instance._cvalue = value
        return instance



cdef class CustomRenderData:
    def __init__(self,
            background_color: Optional[Color] = None,
            corner_radius: Optional[CornerRadius] = None,
            custom_data: Optional[object] = None
    ):
        if background_color is not None:
            self._cvalue.backgroundColor = background_color._cvalue
        if corner_radius is not None:
            self._cvalue.cornerRadius = corner_radius._cvalue
        if custom_data is not None:
            self._cvalue.customData = <void*> custom_data


    @property
    def background_color(self) -> Color:
        return Color.from_c(self._cvalue.backgroundColor)
    @background_color.setter
    def background_color(self, value: Color):
        self._cvalue.backgroundColor = value._cvalue

    @property
    def corner_radius(self) -> CornerRadius:
        return CornerRadius.from_c(self._cvalue.cornerRadius)
    @corner_radius.setter
    def corner_radius(self, value: CornerRadius):
        self._cvalue.cornerRadius = value._cvalue

    @property
    def custom_data(self) -> object:
        return <object> self._cvalue.customData
    @custom_data.setter
    def custom_data(self, value: object):
        self._cvalue.customData = <void*> value

    @staticmethod
    cdef CustomRenderData from_c(Clay_CustomRenderData value):
        cdef CustomRenderData instance = CustomRenderData.__new__(CustomRenderData)
        instance._cvalue = value
        return instance



cdef class ScrollRenderData:
    def __init__(self,
            horizontal = None,
            vertical = None
    ):
        if horizontal is not None:
            self._cvalue.horizontal = horizontal
        if vertical is not None:
            self._cvalue.vertical = vertical


    @property
    def horizontal(self):
        return self._cvalue.horizontal
    @horizontal.setter
    def horizontal(self, value):
        self._cvalue.horizontal = value

    @property
    def vertical(self):
        return self._cvalue.vertical
    @vertical.setter
    def vertical(self, value):
        self._cvalue.vertical = value

    @staticmethod
    cdef ScrollRenderData from_c(Clay_ScrollRenderData value):
        cdef ScrollRenderData instance = ScrollRenderData.__new__(ScrollRenderData)
        instance._cvalue = value
        return instance



cdef class BorderRenderData:
    def __init__(self,
            color: Optional[Color] = None,
            corner_radius: Optional[CornerRadius] = None,
            width: Optional[BorderWidth] = None
    ):
        if color is not None:
            self._cvalue.color = color._cvalue
        if corner_radius is not None:
            self._cvalue.cornerRadius = corner_radius._cvalue
        if width is not None:
            self._cvalue.width = width._cvalue


    @property
    def color(self) -> Color:
        return Color.from_c(self._cvalue.color)
    @color.setter
    def color(self, value: Color):
        self._cvalue.color = value._cvalue

    @property
    def corner_radius(self) -> CornerRadius:
        return CornerRadius.from_c(self._cvalue.cornerRadius)
    @corner_radius.setter
    def corner_radius(self, value: CornerRadius):
        self._cvalue.cornerRadius = value._cvalue

    @property
    def width(self) -> BorderWidth:
        return BorderWidth.from_c(self._cvalue.width)
    @width.setter
    def width(self, value: BorderWidth):
        self._cvalue.width = value._cvalue

    @staticmethod
    cdef BorderRenderData from_c(Clay_BorderRenderData value):
        cdef BorderRenderData instance = BorderRenderData.__new__(BorderRenderData)
        instance._cvalue = value
        return instance



cdef class ScrollContainerData:
    def __init__(self):
        raise TypeError('This class cannot be instantiated directly.')

    @property
    def scroll_position(self) -> Vector2:
        return Vector2.from_c(self._cvalue.scrollPosition[0])

    @property
    def scroll_container_dimensions(self) -> Dimensions:
        return Dimensions.from_c(self._cvalue.scrollContainerDimensions)

    @property
    def content_dimensions(self) -> Dimensions:
        return Dimensions.from_c(self._cvalue.contentDimensions)

    @property
    def config(self) -> ScrollElementConfig:
        return ScrollElementConfig.from_c(self._cvalue.config)

    @property
    def found(self):
        return self._cvalue.found

    @staticmethod
    cdef ScrollContainerData from_c(Clay_ScrollContainerData value):
        cdef ScrollContainerData instance = ScrollContainerData.__new__(ScrollContainerData)
        instance._cvalue = value
        return instance



cdef class ElementData:
    def __init__(self,
            bounding_box: Optional[BoundingBox] = None,
            found = None
    ):
        if bounding_box is not None:
            self._cvalue.boundingBox = bounding_box._cvalue
        if found is not None:
            self._cvalue.found = found


    @property
    def bounding_box(self) -> BoundingBox:
        return BoundingBox.from_c(self._cvalue.boundingBox)
    @bounding_box.setter
    def bounding_box(self, value: BoundingBox):
        self._cvalue.boundingBox = value._cvalue

    @property
    def found(self):
        return self._cvalue.found
    @found.setter
    def found(self, value):
        self._cvalue.found = value

    @staticmethod
    cdef ElementData from_c(Clay_ElementData value):
        cdef ElementData instance = ElementData.__new__(ElementData)
        instance._cvalue = value
        return instance



cdef class RenderCommand:
    def __init__(self):
        raise TypeError('This class cannot be instantiated directly.')

    @property
    def bounding_box(self) -> BoundingBox:
        return BoundingBox.from_c(self._cvalue.boundingBox)

    @property
    def render_data(self) -> RenderData:
        return RenderData.from_c(self._cvalue.renderData)

    @property
    def user_data(self) -> object:
        return <object> self._cvalue.userData

    @property
    def id_(self):
        return self._cvalue.id

    @property
    def z_index(self):
        return self._cvalue.zIndex

    @property
    def command_type(self) -> RenderCommandType:
        return RenderCommandType(self._cvalue.commandType)

    @staticmethod
    cdef RenderCommand from_c(Clay_RenderCommand value):
        cdef RenderCommand instance = RenderCommand.__new__(RenderCommand)
        instance._cvalue = value
        return instance



cdef class RenderCommandArray:
    def __init__(self):
        raise TypeError('This class cannot be instantiated directly.')

    @property
    def capacity(self):
        return self._cvalue.capacity

    @property
    def length(self):
        return self._cvalue.length

    @property
    def internal_array(self) -> RenderCommand:
        return RenderCommand.from_c(self._cvalue.internalArray[0])

    @staticmethod
    cdef RenderCommandArray from_c(Clay_RenderCommandArray value):
        cdef RenderCommandArray instance = RenderCommandArray.__new__(RenderCommandArray)
        instance._cvalue = value
        return instance



cdef class PointerData:
    def __init__(self,
            position: Optional[Vector2] = None,
            state: Optional[PointerDataInteractionState] = None
    ):
        if position is not None:
            self._cvalue.position = position._cvalue
        if state is not None:
            self._cvalue.state = state.value


    @property
    def position(self) -> Vector2:
        return Vector2.from_c(self._cvalue.position)
    @position.setter
    def position(self, value: Vector2):
        self._cvalue.position = value._cvalue

    @property
    def state(self) -> PointerDataInteractionState:
        return PointerDataInteractionState(self._cvalue.state)
    @state.setter
    def state(self, value: PointerDataInteractionState):
        self._cvalue.state = value.value

    @staticmethod
    cdef PointerData from_c(Clay_PointerData value):
        cdef PointerData instance = PointerData.__new__(PointerData)
        instance._cvalue = value
        return instance



cdef class ElementDeclaration:
    def __init__(self,
            id_: Optional[ElementId] = None,
            layout: Optional[LayoutConfig] = None,
            background_color: Optional[Color] = None,
            corner_radius: Optional[CornerRadius] = None,
            image: Optional[ImageElementConfig] = None,
            floating: Optional[FloatingElementConfig] = None,
            custom: Optional[CustomElementConfig] = None,
            scroll: Optional[ScrollElementConfig] = None,
            border: Optional[BorderElementConfig] = None,
            user_data: Optional[object] = None
    ):
        if id_ is not None:
            self._cvalue.id = id_._cvalue
        if layout is not None:
            self._cvalue.layout = layout._cvalue
        if background_color is not None:
            self._cvalue.backgroundColor = background_color._cvalue
        if corner_radius is not None:
            self._cvalue.cornerRadius = corner_radius._cvalue
        if image is not None:
            self._cvalue.image = image._cvalue
        if floating is not None:
            self._cvalue.floating = floating._cvalue
        if custom is not None:
            self._cvalue.custom = custom._cvalue
        if scroll is not None:
            self._cvalue.scroll = scroll._cvalue
        if border is not None:
            self._cvalue.border = border._cvalue
        if user_data is not None:
            self._cvalue.userData = <void*> user_data


    @property
    def id_(self) -> ElementId:
        return ElementId.from_c(self._cvalue.id)
    @id_.setter
    def id_(self, value: ElementId):
        self._cvalue.id = value._cvalue

    @property
    def layout(self) -> LayoutConfig:
        return LayoutConfig.from_c(self._cvalue.layout)
    @layout.setter
    def layout(self, value: LayoutConfig):
        self._cvalue.layout = value._cvalue

    @property
    def background_color(self) -> Color:
        return Color.from_c(self._cvalue.backgroundColor)
    @background_color.setter
    def background_color(self, value: Color):
        self._cvalue.backgroundColor = value._cvalue

    @property
    def corner_radius(self) -> CornerRadius:
        return CornerRadius.from_c(self._cvalue.cornerRadius)
    @corner_radius.setter
    def corner_radius(self, value: CornerRadius):
        self._cvalue.cornerRadius = value._cvalue

    @property
    def image(self) -> ImageElementConfig:
        return ImageElementConfig.from_c(self._cvalue.image)
    @image.setter
    def image(self, value: ImageElementConfig):
        self._cvalue.image = value._cvalue

    @property
    def floating(self) -> FloatingElementConfig:
        return FloatingElementConfig.from_c(self._cvalue.floating)
    @floating.setter
    def floating(self, value: FloatingElementConfig):
        self._cvalue.floating = value._cvalue

    @property
    def custom(self) -> CustomElementConfig:
        return CustomElementConfig.from_c(self._cvalue.custom)
    @custom.setter
    def custom(self, value: CustomElementConfig):
        self._cvalue.custom = value._cvalue

    @property
    def scroll(self) -> ScrollElementConfig:
        return ScrollElementConfig.from_c(self._cvalue.scroll)
    @scroll.setter
    def scroll(self, value: ScrollElementConfig):
        self._cvalue.scroll = value._cvalue

    @property
    def border(self) -> BorderElementConfig:
        return BorderElementConfig.from_c(self._cvalue.border)
    @border.setter
    def border(self, value: BorderElementConfig):
        self._cvalue.border = value._cvalue

    @property
    def user_data(self) -> object:
        return <object> self._cvalue.userData
    @user_data.setter
    def user_data(self, value: object):
        self._cvalue.userData = <void*> value

    @staticmethod
    cdef ElementDeclaration from_c(Clay_ElementDeclaration value):
        cdef ElementDeclaration instance = ElementDeclaration.__new__(ElementDeclaration)
        instance._cvalue = value
        return instance



cdef class ErrorData:
    def __init__(self):
        raise TypeError('This class cannot be instantiated directly.')

    @property
    def error_type(self) -> ErrorType:
        return ErrorType(self._cvalue.errorType)

    @property
    def error_text(self) -> ClayString:
        return ClayString.from_c(self._cvalue.errorText)

    @property
    def user_data(self) -> object:
        return <object> self._cvalue.userData

    @staticmethod
    cdef ErrorData from_c(Clay_ErrorData value):
        cdef ErrorData instance = ErrorData.__new__(ErrorData)
        instance._cvalue = value
        return instance
