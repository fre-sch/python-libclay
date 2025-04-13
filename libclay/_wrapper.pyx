from libclay._clay cimport *
from enum import Enum


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


cdef class StringSlice:
    @property
    def length(self):
        return self.__internal.length
    @length.setter
    def length(self, value):
        self.__internal.length = value

    @property
    def chars(self):
        return self.__internal.chars
    @chars.setter
    def chars(self, value):
        self.__internal.chars = value

    @property
    def base_chars(self):
        return self.__internal.baseChars
    @base_chars.setter
    def base_chars(self, value):
        self.__internal.baseChars = value

    @staticmethod
    cdef StringSlice from_c(Clay_StringSlice value):
        instance = StringSlice()
        instance.__internal = value
        return instance



cdef class Arena:
    @property
    def next_allocation(self):
        return self.__internal.nextAllocation

    @property
    def capacity(self):
        return self.__internal.capacity

    @property
    def memory(self):
        return self.__internal.memory

    @staticmethod
    cdef Arena from_c(Clay_Arena value):
        instance = Arena()
        instance.__internal = value
        return instance



cdef class Dimensions:
    @property
    def width(self):
        return self.__internal.width
    @width.setter
    def width(self, value):
        self.__internal.width = value

    @property
    def height(self):
        return self.__internal.height
    @height.setter
    def height(self, value):
        self.__internal.height = value

    @staticmethod
    cdef Dimensions from_c(Clay_Dimensions value):
        instance = Dimensions()
        instance.__internal = value
        return instance



cdef class Vector2:
    @property
    def x(self):
        return self.__internal.x
    @x.setter
    def x(self, value):
        self.__internal.x = value

    @property
    def y(self):
        return self.__internal.y
    @y.setter
    def y(self, value):
        self.__internal.y = value

    @staticmethod
    cdef Vector2 from_c(Clay_Vector2 value):
        instance = Vector2()
        instance.__internal = value
        return instance



cdef class Color:
    @property
    def r(self):
        return self.__internal.r
    @r.setter
    def r(self, value):
        self.__internal.r = value

    @property
    def g(self):
        return self.__internal.g
    @g.setter
    def g(self, value):
        self.__internal.g = value

    @property
    def b(self):
        return self.__internal.b
    @b.setter
    def b(self, value):
        self.__internal.b = value

    @property
    def a(self):
        return self.__internal.a
    @a.setter
    def a(self, value):
        self.__internal.a = value

    @staticmethod
    cdef Color from_c(Clay_Color value):
        instance = Color()
        instance.__internal = value
        return instance



cdef class BoundingBox:
    @property
    def x(self):
        return self.__internal.x
    @x.setter
    def x(self, value):
        self.__internal.x = value

    @property
    def y(self):
        return self.__internal.y
    @y.setter
    def y(self, value):
        self.__internal.y = value

    @property
    def width(self):
        return self.__internal.width
    @width.setter
    def width(self, value):
        self.__internal.width = value

    @property
    def height(self):
        return self.__internal.height
    @height.setter
    def height(self, value):
        self.__internal.height = value

    @staticmethod
    cdef BoundingBox from_c(Clay_BoundingBox value):
        instance = BoundingBox()
        instance.__internal = value
        return instance



cdef class ElementId:
    @property
    def id(self):
        return self.__internal.id
    @id.setter
    def id(self, value):
        self.__internal.id = value

    @property
    def offset(self):
        return self.__internal.offset
    @offset.setter
    def offset(self, value):
        self.__internal.offset = value

    @property
    def base_id(self):
        return self.__internal.baseId
    @base_id.setter
    def base_id(self, value):
        self.__internal.baseId = value

    @property
    def string_id(self):
        return self.__internal.stringId
    @string_id.setter
    def string_id(self, value):
        self.__internal.stringId = value

    @staticmethod
    cdef ElementId from_c(Clay_ElementId value):
        instance = ElementId()
        instance.__internal = value
        return instance



cdef class CornerRadius:
    @property
    def top_left(self):
        return self.__internal.topLeft
    @top_left.setter
    def top_left(self, value):
        self.__internal.topLeft = value

    @property
    def top_right(self):
        return self.__internal.topRight
    @top_right.setter
    def top_right(self, value):
        self.__internal.topRight = value

    @property
    def bottom_left(self):
        return self.__internal.bottomLeft
    @bottom_left.setter
    def bottom_left(self, value):
        self.__internal.bottomLeft = value

    @property
    def bottom_right(self):
        return self.__internal.bottomRight
    @bottom_right.setter
    def bottom_right(self, value):
        self.__internal.bottomRight = value

    @staticmethod
    cdef CornerRadius from_c(Clay_CornerRadius value):
        instance = CornerRadius()
        instance.__internal = value
        return instance



cdef class ChildAlignment:
    @property
    def x(self) -> LayoutAlignmentX:
        return LayoutAlignmentX(self.__internal.x)
    @x.setter
    def x(self, value: LayoutAlignmentX):
        self.__internal.x = value.value

    @property
    def y(self) -> LayoutAlignmentY:
        return LayoutAlignmentY(self.__internal.y)
    @y.setter
    def y(self, value: LayoutAlignmentY):
        self.__internal.y = value.value

    @staticmethod
    cdef ChildAlignment from_c(Clay_ChildAlignment value):
        instance = ChildAlignment()
        instance.__internal = value
        return instance



cdef class SizingMinMax:
    @property
    def min(self):
        return self.__internal.min
    @min.setter
    def min(self, value):
        self.__internal.min = value

    @property
    def max(self):
        return self.__internal.max
    @max.setter
    def max(self, value):
        self.__internal.max = value

    @staticmethod
    cdef SizingMinMax from_c(Clay_SizingMinMax value):
        instance = SizingMinMax()
        instance.__internal = value
        return instance



cdef class SizingSize:
    @property
    def min_max(self) -> SizingMinMax:
        return SizingMinMax.from_c(self.__internal.minMax)
    @min_max.setter
    def min_max(self, value: SizingMinMax):
        self.__internal.minMax = value.__internal

    @property
    def percent(self):
        return self.__internal.percent
    @percent.setter
    def percent(self, value):
        self.__internal.percent = value

    @staticmethod
    cdef SizingSize from_c(Clay_SizingSize value):
        instance = SizingSize()
        instance.__internal = value
        return instance



cdef class SizingAxis:
    @property
    def size(self) -> SizingSize:
        return SizingSize.from_c(self.__internal.size)
    @size.setter
    def size(self, value: SizingSize):
        self.__internal.size = value.__internal

    @property
    def type(self) -> SizingType:
        return SizingType(self.__internal.type)
    @type.setter
    def type(self, value: SizingType):
        self.__internal.type = value.value

    @staticmethod
    cdef SizingAxis from_c(Clay_SizingAxis value):
        instance = SizingAxis()
        instance.__internal = value
        return instance



cdef class Sizing:
    @property
    def width(self) -> SizingAxis:
        return SizingAxis.from_c(self.__internal.width)
    @width.setter
    def width(self, value: SizingAxis):
        self.__internal.width = value.__internal

    @property
    def height(self) -> SizingAxis:
        return SizingAxis.from_c(self.__internal.height)
    @height.setter
    def height(self, value: SizingAxis):
        self.__internal.height = value.__internal

    @staticmethod
    cdef Sizing from_c(Clay_Sizing value):
        instance = Sizing()
        instance.__internal = value
        return instance



cdef class Padding:
    @property
    def left(self):
        return self.__internal.left
    @left.setter
    def left(self, value):
        self.__internal.left = value

    @property
    def right(self):
        return self.__internal.right
    @right.setter
    def right(self, value):
        self.__internal.right = value

    @property
    def top(self):
        return self.__internal.top
    @top.setter
    def top(self, value):
        self.__internal.top = value

    @property
    def bottom(self):
        return self.__internal.bottom
    @bottom.setter
    def bottom(self, value):
        self.__internal.bottom = value

    @staticmethod
    cdef Padding from_c(Clay_Padding value):
        instance = Padding()
        instance.__internal = value
        return instance



cdef class PaddingWrapper:
    @property
    def wrapped(self) -> Padding:
        return Padding.from_c(self.__internal.wrapped)
    @wrapped.setter
    def wrapped(self, value: Padding):
        self.__internal.wrapped = value.__internal

    @staticmethod
    cdef PaddingWrapper from_c(Clay__Clay_PaddingWrapper value):
        instance = PaddingWrapper()
        instance.__internal = value
        return instance



cdef class LayoutConfig:
    @property
    def sizing(self) -> Sizing:
        return Sizing.from_c(self.__internal.sizing)
    @sizing.setter
    def sizing(self, value: Sizing):
        self.__internal.sizing = value.__internal

    @property
    def padding(self) -> Padding:
        return Padding.from_c(self.__internal.padding)
    @padding.setter
    def padding(self, value: Padding):
        self.__internal.padding = value.__internal

    @property
    def child_gap(self):
        return self.__internal.childGap
    @child_gap.setter
    def child_gap(self, value):
        self.__internal.childGap = value

    @property
    def child_alignment(self) -> ChildAlignment:
        return ChildAlignment.from_c(self.__internal.childAlignment)
    @child_alignment.setter
    def child_alignment(self, value: ChildAlignment):
        self.__internal.childAlignment = value.__internal

    @property
    def layout_direction(self) -> LayoutDirection:
        return LayoutDirection(self.__internal.layoutDirection)
    @layout_direction.setter
    def layout_direction(self, value: LayoutDirection):
        self.__internal.layoutDirection = value.value

    @staticmethod
    cdef LayoutConfig from_c(Clay_LayoutConfig value):
        instance = LayoutConfig()
        instance.__internal = value
        return instance



cdef class LayoutConfigWrapper:
    @property
    def wrapped(self) -> LayoutConfig:
        return LayoutConfig.from_c(self.__internal.wrapped)
    @wrapped.setter
    def wrapped(self, value: LayoutConfig):
        self.__internal.wrapped = value.__internal

    @staticmethod
    cdef LayoutConfigWrapper from_c(Clay__Clay_LayoutConfigWrapper value):
        instance = LayoutConfigWrapper()
        instance.__internal = value
        return instance



cdef class TextElementConfig:
    @property
    def user_data(self):
        return <object> self.__internal.userData
    @user_data.setter
    def user_data(self, object value):
        self.__internal.userData = <void*> value

    @property
    def text_color(self) -> Color:
        return Color.from_c(self.__internal.textColor)
    @text_color.setter
    def text_color(self, value: Color):
        self.__internal.textColor = value.__internal

    @property
    def font_id(self):
        return self.__internal.fontId
    @font_id.setter
    def font_id(self, value):
        self.__internal.fontId = value

    @property
    def font_size(self):
        return self.__internal.fontSize
    @font_size.setter
    def font_size(self, value):
        self.__internal.fontSize = value

    @property
    def letter_spacing(self):
        return self.__internal.letterSpacing
    @letter_spacing.setter
    def letter_spacing(self, value):
        self.__internal.letterSpacing = value

    @property
    def line_height(self):
        return self.__internal.lineHeight
    @line_height.setter
    def line_height(self, value):
        self.__internal.lineHeight = value

    @property
    def wrap_mode(self) -> TextElementConfigWrapMode:
        return TextElementConfigWrapMode(self.__internal.wrapMode)
    @wrap_mode.setter
    def wrap_mode(self, value: TextElementConfigWrapMode):
        self.__internal.wrapMode = value.value

    @property
    def text_alignment(self) -> TextAlignment:
        return TextAlignment(self.__internal.textAlignment)
    @text_alignment.setter
    def text_alignment(self, value: TextAlignment):
        self.__internal.textAlignment = value.value

    @staticmethod
    cdef TextElementConfig from_c(Clay_TextElementConfig value):
        instance = TextElementConfig()
        instance.__internal = value
        return instance



cdef class TextElementConfigWrapper:
    @property
    def wrapped(self) -> TextElementConfig:
        return TextElementConfig.from_c(self.__internal.wrapped)
    @wrapped.setter
    def wrapped(self, value: TextElementConfig):
        self.__internal.wrapped = value.__internal

    @staticmethod
    cdef TextElementConfigWrapper from_c(Clay__Clay_TextElementConfigWrapper value):
        instance = TextElementConfigWrapper()
        instance.__internal = value
        return instance



cdef class ImageElementConfig:
    @property
    def image_data(self):
        return <object> self.__internal.imageData
    @image_data.setter
    def image_data(self, object value):
        self.__internal.imageData = <void*> value

    @property
    def source_dimensions(self) -> Dimensions:
        return Dimensions.from_c(self.__internal.sourceDimensions)
    @source_dimensions.setter
    def source_dimensions(self, value: Dimensions):
        self.__internal.sourceDimensions = value.__internal

    @staticmethod
    cdef ImageElementConfig from_c(Clay_ImageElementConfig value):
        instance = ImageElementConfig()
        instance.__internal = value
        return instance



cdef class ImageElementConfigWrapper:
    @property
    def wrapped(self) -> ImageElementConfig:
        return ImageElementConfig.from_c(self.__internal.wrapped)
    @wrapped.setter
    def wrapped(self, value: ImageElementConfig):
        self.__internal.wrapped = value.__internal

    @staticmethod
    cdef ImageElementConfigWrapper from_c(Clay__Clay_ImageElementConfigWrapper value):
        instance = ImageElementConfigWrapper()
        instance.__internal = value
        return instance



cdef class FloatingAttachPoints:
    @property
    def element(self) -> FloatingAttachPointType:
        return FloatingAttachPointType(self.__internal.element)
    @element.setter
    def element(self, value: FloatingAttachPointType):
        self.__internal.element = value.value

    @property
    def parent(self) -> FloatingAttachPointType:
        return FloatingAttachPointType(self.__internal.parent)
    @parent.setter
    def parent(self, value: FloatingAttachPointType):
        self.__internal.parent = value.value

    @staticmethod
    cdef FloatingAttachPoints from_c(Clay_FloatingAttachPoints value):
        instance = FloatingAttachPoints()
        instance.__internal = value
        return instance



cdef class FloatingElementConfig:
    @property
    def offset(self) -> Vector2:
        return Vector2.from_c(self.__internal.offset)
    @offset.setter
    def offset(self, value: Vector2):
        self.__internal.offset = value.__internal

    @property
    def expand(self) -> Dimensions:
        return Dimensions.from_c(self.__internal.expand)
    @expand.setter
    def expand(self, value: Dimensions):
        self.__internal.expand = value.__internal

    @property
    def parent_id(self):
        return self.__internal.parentId
    @parent_id.setter
    def parent_id(self, value):
        self.__internal.parentId = value

    @property
    def z_index(self):
        return self.__internal.zIndex
    @z_index.setter
    def z_index(self, value):
        self.__internal.zIndex = value

    @property
    def attach_points(self) -> FloatingAttachPoints:
        return FloatingAttachPoints.from_c(self.__internal.attachPoints)
    @attach_points.setter
    def attach_points(self, value: FloatingAttachPoints):
        self.__internal.attachPoints = value.__internal

    @property
    def pointer_capture_mode(self) -> PointerCaptureMode:
        return PointerCaptureMode(self.__internal.pointerCaptureMode)
    @pointer_capture_mode.setter
    def pointer_capture_mode(self, value: PointerCaptureMode):
        self.__internal.pointerCaptureMode = value.value

    @property
    def attach_to(self) -> FloatingAttachToElement:
        return FloatingAttachToElement(self.__internal.attachTo)
    @attach_to.setter
    def attach_to(self, value: FloatingAttachToElement):
        self.__internal.attachTo = value.value

    @staticmethod
    cdef FloatingElementConfig from_c(Clay_FloatingElementConfig value):
        instance = FloatingElementConfig()
        instance.__internal = value
        return instance



cdef class FloatingElementConfigWrapper:
    @property
    def wrapped(self) -> FloatingElementConfig:
        return FloatingElementConfig.from_c(self.__internal.wrapped)
    @wrapped.setter
    def wrapped(self, value: FloatingElementConfig):
        self.__internal.wrapped = value.__internal

    @staticmethod
    cdef FloatingElementConfigWrapper from_c(Clay__Clay_FloatingElementConfigWrapper value):
        instance = FloatingElementConfigWrapper()
        instance.__internal = value
        return instance



cdef class CustomElementConfig:
    @property
    def custom_data(self):
        return <object> self.__internal.customData
    @custom_data.setter
    def custom_data(self, object value):
        self.__internal.customData = <void*> value

    @staticmethod
    cdef CustomElementConfig from_c(Clay_CustomElementConfig value):
        instance = CustomElementConfig()
        instance.__internal = value
        return instance



cdef class CustomElementConfigWrapper:
    @property
    def wrapped(self) -> CustomElementConfig:
        return CustomElementConfig.from_c(self.__internal.wrapped)
    @wrapped.setter
    def wrapped(self, value: CustomElementConfig):
        self.__internal.wrapped = value.__internal

    @staticmethod
    cdef CustomElementConfigWrapper from_c(Clay__Clay_CustomElementConfigWrapper value):
        instance = CustomElementConfigWrapper()
        instance.__internal = value
        return instance



cdef class ScrollElementConfig:
    @property
    def horizontal(self):
        return self.__internal.horizontal
    @horizontal.setter
    def horizontal(self, value):
        self.__internal.horizontal = value

    @property
    def vertical(self):
        return self.__internal.vertical
    @vertical.setter
    def vertical(self, value):
        self.__internal.vertical = value

    @staticmethod
    cdef ScrollElementConfig from_c(Clay_ScrollElementConfig value):
        instance = ScrollElementConfig()
        instance.__internal = value
        return instance



cdef class ScrollElementConfigWrapper:
    @property
    def wrapped(self) -> ScrollElementConfig:
        return ScrollElementConfig.from_c(self.__internal.wrapped)
    @wrapped.setter
    def wrapped(self, value: ScrollElementConfig):
        self.__internal.wrapped = value.__internal

    @staticmethod
    cdef ScrollElementConfigWrapper from_c(Clay__Clay_ScrollElementConfigWrapper value):
        instance = ScrollElementConfigWrapper()
        instance.__internal = value
        return instance



cdef class BorderWidth:
    @property
    def left(self):
        return self.__internal.left
    @left.setter
    def left(self, value):
        self.__internal.left = value

    @property
    def right(self):
        return self.__internal.right
    @right.setter
    def right(self, value):
        self.__internal.right = value

    @property
    def top(self):
        return self.__internal.top
    @top.setter
    def top(self, value):
        self.__internal.top = value

    @property
    def bottom(self):
        return self.__internal.bottom
    @bottom.setter
    def bottom(self, value):
        self.__internal.bottom = value

    @property
    def between_children(self):
        return self.__internal.betweenChildren
    @between_children.setter
    def between_children(self, value):
        self.__internal.betweenChildren = value

    @staticmethod
    cdef BorderWidth from_c(Clay_BorderWidth value):
        instance = BorderWidth()
        instance.__internal = value
        return instance



cdef class BorderElementConfig:
    @property
    def color(self) -> Color:
        return Color.from_c(self.__internal.color)
    @color.setter
    def color(self, value: Color):
        self.__internal.color = value.__internal

    @property
    def width(self) -> BorderWidth:
        return BorderWidth.from_c(self.__internal.width)
    @width.setter
    def width(self, value: BorderWidth):
        self.__internal.width = value.__internal

    @staticmethod
    cdef BorderElementConfig from_c(Clay_BorderElementConfig value):
        instance = BorderElementConfig()
        instance.__internal = value
        return instance



cdef class BorderElementConfigWrapper:
    @property
    def wrapped(self) -> BorderElementConfig:
        return BorderElementConfig.from_c(self.__internal.wrapped)
    @wrapped.setter
    def wrapped(self, value: BorderElementConfig):
        self.__internal.wrapped = value.__internal

    @staticmethod
    cdef BorderElementConfigWrapper from_c(Clay__Clay_BorderElementConfigWrapper value):
        instance = BorderElementConfigWrapper()
        instance.__internal = value
        return instance



cdef class TextRenderData:
    @property
    def string_contents(self) -> StringSlice:
        return StringSlice.from_c(self.__internal.stringContents)
    @string_contents.setter
    def string_contents(self, value: StringSlice):
        self.__internal.stringContents = value.__internal

    @property
    def text_color(self) -> Color:
        return Color.from_c(self.__internal.textColor)
    @text_color.setter
    def text_color(self, value: Color):
        self.__internal.textColor = value.__internal

    @property
    def font_id(self):
        return self.__internal.fontId
    @font_id.setter
    def font_id(self, value):
        self.__internal.fontId = value

    @property
    def font_size(self):
        return self.__internal.fontSize
    @font_size.setter
    def font_size(self, value):
        self.__internal.fontSize = value

    @property
    def letter_spacing(self):
        return self.__internal.letterSpacing
    @letter_spacing.setter
    def letter_spacing(self, value):
        self.__internal.letterSpacing = value

    @property
    def line_height(self):
        return self.__internal.lineHeight
    @line_height.setter
    def line_height(self, value):
        self.__internal.lineHeight = value

    @staticmethod
    cdef TextRenderData from_c(Clay_TextRenderData value):
        instance = TextRenderData()
        instance.__internal = value
        return instance



cdef class RectangleRenderData:
    @property
    def background_color(self) -> Color:
        return Color.from_c(self.__internal.backgroundColor)
    @background_color.setter
    def background_color(self, value: Color):
        self.__internal.backgroundColor = value.__internal

    @property
    def corner_radius(self) -> CornerRadius:
        return CornerRadius.from_c(self.__internal.cornerRadius)
    @corner_radius.setter
    def corner_radius(self, value: CornerRadius):
        self.__internal.cornerRadius = value.__internal

    @staticmethod
    cdef RectangleRenderData from_c(Clay_RectangleRenderData value):
        instance = RectangleRenderData()
        instance.__internal = value
        return instance



cdef class ImageRenderData:
    @property
    def background_color(self) -> Color:
        return Color.from_c(self.__internal.backgroundColor)
    @background_color.setter
    def background_color(self, value: Color):
        self.__internal.backgroundColor = value.__internal

    @property
    def corner_radius(self) -> CornerRadius:
        return CornerRadius.from_c(self.__internal.cornerRadius)
    @corner_radius.setter
    def corner_radius(self, value: CornerRadius):
        self.__internal.cornerRadius = value.__internal

    @property
    def source_dimensions(self) -> Dimensions:
        return Dimensions.from_c(self.__internal.sourceDimensions)
    @source_dimensions.setter
    def source_dimensions(self, value: Dimensions):
        self.__internal.sourceDimensions = value.__internal

    @property
    def image_data(self):
        return <object> self.__internal.imageData
    @image_data.setter
    def image_data(self, object value):
        self.__internal.imageData = <void*> value

    @staticmethod
    cdef ImageRenderData from_c(Clay_ImageRenderData value):
        instance = ImageRenderData()
        instance.__internal = value
        return instance



cdef class CustomRenderData:
    @property
    def background_color(self) -> Color:
        return Color.from_c(self.__internal.backgroundColor)
    @background_color.setter
    def background_color(self, value: Color):
        self.__internal.backgroundColor = value.__internal

    @property
    def corner_radius(self) -> CornerRadius:
        return CornerRadius.from_c(self.__internal.cornerRadius)
    @corner_radius.setter
    def corner_radius(self, value: CornerRadius):
        self.__internal.cornerRadius = value.__internal

    @property
    def custom_data(self):
        return <object> self.__internal.customData
    @custom_data.setter
    def custom_data(self, object value):
        self.__internal.customData = <void*> value

    @staticmethod
    cdef CustomRenderData from_c(Clay_CustomRenderData value):
        instance = CustomRenderData()
        instance.__internal = value
        return instance



cdef class ScrollRenderData:
    @property
    def horizontal(self):
        return self.__internal.horizontal
    @horizontal.setter
    def horizontal(self, value):
        self.__internal.horizontal = value

    @property
    def vertical(self):
        return self.__internal.vertical
    @vertical.setter
    def vertical(self, value):
        self.__internal.vertical = value

    @staticmethod
    cdef ScrollRenderData from_c(Clay_ScrollRenderData value):
        instance = ScrollRenderData()
        instance.__internal = value
        return instance



cdef class BorderRenderData:
    @property
    def color(self) -> Color:
        return Color.from_c(self.__internal.color)
    @color.setter
    def color(self, value: Color):
        self.__internal.color = value.__internal

    @property
    def corner_radius(self) -> CornerRadius:
        return CornerRadius.from_c(self.__internal.cornerRadius)
    @corner_radius.setter
    def corner_radius(self, value: CornerRadius):
        self.__internal.cornerRadius = value.__internal

    @property
    def width(self) -> BorderWidth:
        return BorderWidth.from_c(self.__internal.width)
    @width.setter
    def width(self, value: BorderWidth):
        self.__internal.width = value.__internal

    @staticmethod
    cdef BorderRenderData from_c(Clay_BorderRenderData value):
        instance = BorderRenderData()
        instance.__internal = value
        return instance



cdef class RenderData:
    @property
    def rectangle(self) -> RectangleRenderData:
        return RectangleRenderData.from_c(self.__internal.rectangle)

    @property
    def text(self) -> TextRenderData:
        return TextRenderData.from_c(self.__internal.text)

    @property
    def image(self) -> ImageRenderData:
        return ImageRenderData.from_c(self.__internal.image)

    @property
    def custom(self) -> CustomRenderData:
        return CustomRenderData.from_c(self.__internal.custom)

    @property
    def border(self) -> BorderRenderData:
        return BorderRenderData.from_c(self.__internal.border)

    @property
    def scroll(self) -> ScrollRenderData:
        return ScrollRenderData.from_c(self.__internal.scroll)

    @staticmethod
    cdef RenderData from_c(Clay_RenderData value):
        instance = RenderData()
        instance.__internal = value
        return instance



cdef class ScrollContainerData:
    @property
    def scroll_position(self) -> Vector2:
        return Vector2.from_c(self.__internal.scrollPosition[0])

    @property
    def scroll_container_dimensions(self) -> Dimensions:
        return Dimensions.from_c(self.__internal.scrollContainerDimensions)

    @property
    def content_dimensions(self) -> Dimensions:
        return Dimensions.from_c(self.__internal.contentDimensions)

    @property
    def config(self) -> ScrollElementConfig:
        return ScrollElementConfig.from_c(self.__internal.config)

    @property
    def found(self):
        return self.__internal.found

    @staticmethod
    cdef ScrollContainerData from_c(Clay_ScrollContainerData value):
        instance = ScrollContainerData()
        instance.__internal = value
        return instance



cdef class ElementData:
    @property
    def bounding_box(self) -> BoundingBox:
        return BoundingBox.from_c(self.__internal.boundingBox)
    @bounding_box.setter
    def bounding_box(self, value: BoundingBox):
        self.__internal.boundingBox = value.__internal

    @property
    def found(self):
        return self.__internal.found
    @found.setter
    def found(self, value):
        self.__internal.found = value

    @staticmethod
    cdef ElementData from_c(Clay_ElementData value):
        instance = ElementData()
        instance.__internal = value
        return instance



cdef class RenderCommand:
    @property
    def bounding_box(self) -> BoundingBox:
        return BoundingBox.from_c(self.__internal.boundingBox)

    @property
    def render_data(self) -> RenderData:
        return RenderData.from_c(self.__internal.renderData)

    @property
    def user_data(self):
        return <object> self.__internal.userData

    @property
    def id(self):
        return self.__internal.id

    @property
    def z_index(self):
        return self.__internal.zIndex

    @property
    def command_type(self) -> RenderCommandType:
        return RenderCommandType(self.__internal.commandType)

    @staticmethod
    cdef RenderCommand from_c(Clay_RenderCommand value):
        instance = RenderCommand()
        instance.__internal = value
        return instance



cdef class RenderCommandArray:
    @property
    def capacity(self):
        return self.__internal.capacity

    @property
    def length(self):
        return self.__internal.length

    @property
    def internal_array(self) -> RenderCommand:
        return RenderCommand.from_c(self.__internal.internalArray[0])

    @staticmethod
    cdef RenderCommandArray from_c(Clay_RenderCommandArray value):
        instance = RenderCommandArray()
        instance.__internal = value
        return instance



cdef class PointerData:
    @property
    def position(self) -> Vector2:
        return Vector2.from_c(self.__internal.position)
    @position.setter
    def position(self, value: Vector2):
        self.__internal.position = value.__internal

    @property
    def state(self) -> PointerDataInteractionState:
        return PointerDataInteractionState(self.__internal.state)
    @state.setter
    def state(self, value: PointerDataInteractionState):
        self.__internal.state = value.value

    @staticmethod
    cdef PointerData from_c(Clay_PointerData value):
        instance = PointerData()
        instance.__internal = value
        return instance



cdef class ElementDeclaration:
    @property
    def id(self) -> ElementId:
        return ElementId.from_c(self.__internal.id)
    @id.setter
    def id(self, value: ElementId):
        self.__internal.id = value.__internal

    @property
    def layout(self) -> LayoutConfig:
        return LayoutConfig.from_c(self.__internal.layout)
    @layout.setter
    def layout(self, value: LayoutConfig):
        self.__internal.layout = value.__internal

    @property
    def background_color(self) -> Color:
        return Color.from_c(self.__internal.backgroundColor)
    @background_color.setter
    def background_color(self, value: Color):
        self.__internal.backgroundColor = value.__internal

    @property
    def corner_radius(self) -> CornerRadius:
        return CornerRadius.from_c(self.__internal.cornerRadius)
    @corner_radius.setter
    def corner_radius(self, value: CornerRadius):
        self.__internal.cornerRadius = value.__internal

    @property
    def image(self) -> ImageElementConfig:
        return ImageElementConfig.from_c(self.__internal.image)
    @image.setter
    def image(self, value: ImageElementConfig):
        self.__internal.image = value.__internal

    @property
    def floating(self) -> FloatingElementConfig:
        return FloatingElementConfig.from_c(self.__internal.floating)
    @floating.setter
    def floating(self, value: FloatingElementConfig):
        self.__internal.floating = value.__internal

    @property
    def custom(self) -> CustomElementConfig:
        return CustomElementConfig.from_c(self.__internal.custom)
    @custom.setter
    def custom(self, value: CustomElementConfig):
        self.__internal.custom = value.__internal

    @property
    def scroll(self) -> ScrollElementConfig:
        return ScrollElementConfig.from_c(self.__internal.scroll)
    @scroll.setter
    def scroll(self, value: ScrollElementConfig):
        self.__internal.scroll = value.__internal

    @property
    def border(self) -> BorderElementConfig:
        return BorderElementConfig.from_c(self.__internal.border)
    @border.setter
    def border(self, value: BorderElementConfig):
        self.__internal.border = value.__internal

    @property
    def user_data(self):
        return <object> self.__internal.userData
    @user_data.setter
    def user_data(self, object value):
        self.__internal.userData = <void*> value

    @staticmethod
    cdef ElementDeclaration from_c(Clay_ElementDeclaration value):
        instance = ElementDeclaration()
        instance.__internal = value
        return instance



cdef class ElementDeclarationWrapper:
    @property
    def wrapped(self) -> ElementDeclaration:
        return ElementDeclaration.from_c(self.__internal.wrapped)
    @wrapped.setter
    def wrapped(self, value: ElementDeclaration):
        self.__internal.wrapped = value.__internal

    @staticmethod
    cdef ElementDeclarationWrapper from_c(Clay__Clay_ElementDeclarationWrapper value):
        instance = ElementDeclarationWrapper()
        instance.__internal = value
        return instance



cdef class ErrorData:
    @property
    def error_type(self) -> ErrorType:
        return ErrorType(self.__internal.errorType)
    @error_type.setter
    def error_type(self, value: ErrorType):
        self.__internal.errorType = value.value

    @property
    def error_text(self):
        return self.__internal.errorText
    @error_text.setter
    def error_text(self, value):
        self.__internal.errorText = value

    @property
    def user_data(self):
        return <object> self.__internal.userData
    @user_data.setter
    def user_data(self, object value):
        self.__internal.userData = <void*> value

    @staticmethod
    cdef ErrorData from_c(Clay_ErrorData value):
        instance = ErrorData()
        instance.__internal = value
        return instance

