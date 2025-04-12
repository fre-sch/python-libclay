from libc.stdint cimport uint8_t, int32_t, uintptr_t, uint32_t, uint16_t, int16_t, intptr_t

cdef extern from "clay.h":
    ctypedef int bool
    ctypedef void* Clay_Context

    uint8_t CLAY__ELEMENT_DEFINITION_LATCH

    void Clay__SuppressUnusedLatchDefinitionVariableWarning()

    ctypedef struct Clay_String:
        bool isStaticallyAllocated
        int32_t length
        const char* chars

    ctypedef struct Clay_StringSlice:
        int32_t length
        const char* chars
        const char* baseChars

    ctypedef struct Clay_Arena:
        uintptr_t nextAllocation
        size_t capacity
        char* memory

    ctypedef struct Clay_Dimensions:
        float width
        float height

    ctypedef struct Clay_Vector2:
        float x
        float y

    ctypedef struct Clay_Color:
        float r
        float g
        float b
        float a

    ctypedef struct Clay_BoundingBox:
        float x
        float y
        float width
        float height

    ctypedef struct Clay_ElementId:
        uint32_t id
        uint32_t offset
        uint32_t baseId
        Clay_String stringId

    ctypedef struct Clay_CornerRadius:
        float topLeft
        float topRight
        float bottomLeft
        float bottomRight

    ctypedef enum Clay_LayoutDirection:
        CLAY_LEFT_TO_RIGHT
        CLAY_TOP_TO_BOTTOM

    ctypedef enum Clay_LayoutAlignmentX:
        CLAY_ALIGN_X_LEFT
        CLAY_ALIGN_X_RIGHT
        CLAY_ALIGN_X_CENTER

    ctypedef enum Clay_LayoutAlignmentY:
        CLAY_ALIGN_Y_TOP
        CLAY_ALIGN_Y_BOTTOM
        CLAY_ALIGN_Y_CENTER

    ctypedef enum Clay__SizingType:
        CLAY__SIZING_TYPE_FIT
        CLAY__SIZING_TYPE_GROW
        CLAY__SIZING_TYPE_PERCENT
        CLAY__SIZING_TYPE_FIXED

    ctypedef struct Clay_ChildAlignment:
        Clay_LayoutAlignmentX x
        Clay_LayoutAlignmentY y

    ctypedef struct Clay_SizingMinMax:
        float min
        float max

    ctypedef union Clay_SizingSize:
        Clay_SizingMinMax minMax
        float percent

    ctypedef struct Clay_SizingAxis:
        Clay_SizingSize size
        Clay__SizingType type

    ctypedef struct Clay_Sizing:
        Clay_SizingAxis width
        Clay_SizingAxis height

    ctypedef struct Clay_Padding:
        uint16_t left
        uint16_t right
        uint16_t top
        uint16_t bottom

    ctypedef struct Clay__Clay_PaddingWrapper:
        Clay_Padding wrapped

    ctypedef struct Clay_LayoutConfig:
        Clay_Sizing sizing
        Clay_Padding padding
        uint16_t childGap
        Clay_ChildAlignment childAlignment
        Clay_LayoutDirection layoutDirection

    ctypedef struct Clay__Clay_LayoutConfigWrapper:
        Clay_LayoutConfig wrapped

    Clay_LayoutConfig CLAY_LAYOUT_DEFAULT

    ctypedef enum Clay_TextElementConfigWrapMode:
        CLAY_TEXT_WRAP_WORDS
        CLAY_TEXT_WRAP_NEWLINES
        CLAY_TEXT_WRAP_NONE

    ctypedef enum Clay_TextAlignment:
        CLAY_TEXT_ALIGN_LEFT
        CLAY_TEXT_ALIGN_CENTER
        CLAY_TEXT_ALIGN_RIGHT

    ctypedef struct Clay_TextElementConfig:
        void* userData
        Clay_Color textColor
        uint16_t fontId
        uint16_t fontSize
        uint16_t letterSpacing
        uint16_t lineHeight
        Clay_TextElementConfigWrapMode wrapMode
        Clay_TextAlignment textAlignment

    ctypedef struct Clay__Clay_TextElementConfigWrapper:
        Clay_TextElementConfig wrapped

    ctypedef struct Clay_ImageElementConfig:
        void* imageData
        Clay_Dimensions sourceDimensions

    ctypedef struct Clay__Clay_ImageElementConfigWrapper:
        Clay_ImageElementConfig wrapped

    ctypedef enum Clay_FloatingAttachPointType:
        CLAY_ATTACH_POINT_LEFT_TOP
        CLAY_ATTACH_POINT_LEFT_CENTER
        CLAY_ATTACH_POINT_LEFT_BOTTOM
        CLAY_ATTACH_POINT_CENTER_TOP
        CLAY_ATTACH_POINT_CENTER_CENTER
        CLAY_ATTACH_POINT_CENTER_BOTTOM
        CLAY_ATTACH_POINT_RIGHT_TOP
        CLAY_ATTACH_POINT_RIGHT_CENTER
        CLAY_ATTACH_POINT_RIGHT_BOTTOM

    ctypedef struct Clay_FloatingAttachPoints:
        Clay_FloatingAttachPointType element
        Clay_FloatingAttachPointType parent

    ctypedef enum Clay_PointerCaptureMode:
        CLAY_POINTER_CAPTURE_MODE_CAPTURE
        CLAY_POINTER_CAPTURE_MODE_PASSTHROUGH

    ctypedef enum Clay_FloatingAttachToElement:
        CLAY_ATTACH_TO_NONE
        CLAY_ATTACH_TO_PARENT
        CLAY_ATTACH_TO_ELEMENT_WITH_ID
        CLAY_ATTACH_TO_ROOT

    ctypedef struct Clay_FloatingElementConfig:
        Clay_Vector2 offset
        Clay_Dimensions expand
        uint32_t parentId
        int16_t zIndex
        Clay_FloatingAttachPoints attachPoints
        Clay_PointerCaptureMode pointerCaptureMode
        Clay_FloatingAttachToElement attachTo

    ctypedef struct Clay__Clay_FloatingElementConfigWrapper:
        Clay_FloatingElementConfig wrapped

    ctypedef struct Clay_CustomElementConfig:
        void* customData

    ctypedef struct Clay__Clay_CustomElementConfigWrapper:
        Clay_CustomElementConfig wrapped

    ctypedef struct Clay_ScrollElementConfig:
        bool horizontal
        bool vertical

    ctypedef struct Clay__Clay_ScrollElementConfigWrapper:
        Clay_ScrollElementConfig wrapped

    ctypedef struct Clay_BorderWidth:
        uint16_t left
        uint16_t right
        uint16_t top
        uint16_t bottom
        uint16_t betweenChildren

    ctypedef struct Clay_BorderElementConfig:
        Clay_Color color
        Clay_BorderWidth width

    ctypedef struct Clay__Clay_BorderElementConfigWrapper:
        Clay_BorderElementConfig wrapped

    ctypedef struct Clay_TextRenderData:
        Clay_StringSlice stringContents
        Clay_Color textColor
        uint16_t fontId
        uint16_t fontSize
        uint16_t letterSpacing
        uint16_t lineHeight

    ctypedef struct Clay_RectangleRenderData:
        Clay_Color backgroundColor
        Clay_CornerRadius cornerRadius

    ctypedef struct Clay_ImageRenderData:
        Clay_Color backgroundColor
        Clay_CornerRadius cornerRadius
        Clay_Dimensions sourceDimensions
        void* imageData

    ctypedef struct Clay_CustomRenderData:
        Clay_Color backgroundColor
        Clay_CornerRadius cornerRadius
        void* customData

    ctypedef struct Clay_ScrollRenderData:
        bool horizontal
        bool vertical

    ctypedef struct Clay_BorderRenderData:
        Clay_Color color
        Clay_CornerRadius cornerRadius
        Clay_BorderWidth width

    ctypedef union Clay_RenderData:
        Clay_RectangleRenderData rectangle
        Clay_TextRenderData text
        Clay_ImageRenderData image
        Clay_CustomRenderData custom
        Clay_BorderRenderData border
        Clay_ScrollRenderData scroll

    ctypedef struct Clay_ScrollContainerData:
        Clay_Vector2* scrollPosition
        Clay_Dimensions scrollContainerDimensions
        Clay_Dimensions contentDimensions
        Clay_ScrollElementConfig config
        bool found

    ctypedef struct Clay_ElementData:
        Clay_BoundingBox boundingBox
        bool found

    ctypedef enum Clay_RenderCommandType:
        CLAY_RENDER_COMMAND_TYPE_NONE
        CLAY_RENDER_COMMAND_TYPE_RECTANGLE
        CLAY_RENDER_COMMAND_TYPE_BORDER
        CLAY_RENDER_COMMAND_TYPE_TEXT
        CLAY_RENDER_COMMAND_TYPE_IMAGE
        CLAY_RENDER_COMMAND_TYPE_SCISSOR_START
        CLAY_RENDER_COMMAND_TYPE_SCISSOR_END
        CLAY_RENDER_COMMAND_TYPE_CUSTOM

    ctypedef struct Clay_RenderCommand:
        Clay_BoundingBox boundingBox
        Clay_RenderData renderData
        void* userData
        uint32_t id
        int16_t zIndex
        Clay_RenderCommandType commandType

    ctypedef struct Clay_RenderCommandArray:
        int32_t capacity
        int32_t length
        Clay_RenderCommand* internalArray

    ctypedef enum Clay_PointerDataInteractionState:
        CLAY_POINTER_DATA_PRESSED_THIS_FRAME
        CLAY_POINTER_DATA_PRESSED
        CLAY_POINTER_DATA_RELEASED_THIS_FRAME
        CLAY_POINTER_DATA_RELEASED

    ctypedef struct Clay_PointerData:
        Clay_Vector2 position
        Clay_PointerDataInteractionState state

    ctypedef struct Clay_ElementDeclaration:
        Clay_ElementId id
        Clay_LayoutConfig layout
        Clay_Color backgroundColor
        Clay_CornerRadius cornerRadius
        Clay_ImageElementConfig image
        Clay_FloatingElementConfig floating
        Clay_CustomElementConfig custom
        Clay_ScrollElementConfig scroll
        Clay_BorderElementConfig border
        void* userData

    ctypedef struct Clay__Clay_ElementDeclarationWrapper:
        Clay_ElementDeclaration wrapped

    ctypedef enum Clay_ErrorType:
        CLAY_ERROR_TYPE_TEXT_MEASUREMENT_FUNCTION_NOT_PROVIDED
        CLAY_ERROR_TYPE_ARENA_CAPACITY_EXCEEDED
        CLAY_ERROR_TYPE_ELEMENTS_CAPACITY_EXCEEDED
        CLAY_ERROR_TYPE_TEXT_MEASUREMENT_CAPACITY_EXCEEDED
        CLAY_ERROR_TYPE_DUPLICATE_ID
        CLAY_ERROR_TYPE_FLOATING_CONTAINER_PARENT_NOT_FOUND
        CLAY_ERROR_TYPE_PERCENTAGE_OVER_1
        CLAY_ERROR_TYPE_INTERNAL_ERROR

    ctypedef struct Clay_ErrorData:
        Clay_ErrorType errorType
        Clay_String errorText
        void* userData

    ctypedef void (*_Clay_ErrorHandler_Clay_ErrorHandler_errorHandlerFunction_ft)(Clay_ErrorData errorText)

    ctypedef struct Clay_ErrorHandler:
        _Clay_ErrorHandler_Clay_ErrorHandler_errorHandlerFunction_ft errorHandlerFunction
        void* userData

    uint32_t Clay_MinMemorySize()

    Clay_Arena Clay_CreateArenaWithCapacityAndMemory(size_t capacity, void* memory)

    void Clay_SetPointerState(Clay_Vector2 position, bool pointerDown)

    Clay_Context* Clay_Initialize(Clay_Arena arena, Clay_Dimensions layoutDimensions, Clay_ErrorHandler errorHandler)

    Clay_Context* Clay_GetCurrentContext()

    void Clay_SetCurrentContext(Clay_Context* context)

    void Clay_UpdateScrollContainers(bool enableDragScrolling, Clay_Vector2 scrollDelta, float deltaTime)

    void Clay_SetLayoutDimensions(Clay_Dimensions dimensions)

    void Clay_BeginLayout()

    Clay_RenderCommandArray Clay_EndLayout()

    Clay_ElementId Clay_GetElementId(Clay_String idString)

    Clay_ElementId Clay_GetElementIdWithIndex(Clay_String idString, uint32_t index)

    Clay_ElementData Clay_GetElementData(Clay_ElementId id)

    bool Clay_Hovered()

    ctypedef void (*_Clay_OnHover_onHoverFunction_ft)(Clay_ElementId elementId, Clay_PointerData pointerData, intptr_t userData)

    void Clay_OnHover(_Clay_OnHover_onHoverFunction_ft onHoverFunction, intptr_t userData)

    bool Clay_PointerOver(Clay_ElementId elementId)

    Clay_ScrollContainerData Clay_GetScrollContainerData(Clay_ElementId id)

    ctypedef Clay_Dimensions (*_Clay_SetMeasureTextFunction_measureTextFunction_ft)(Clay_StringSlice text, Clay_TextElementConfig* config, void* userData)

    void Clay_SetMeasureTextFunction(_Clay_SetMeasureTextFunction_measureTextFunction_ft measureTextFunction, void* userData)

    ctypedef Clay_Vector2 (*_Clay_SetQueryScrollOffsetFunction_queryScrollOffsetFunction_ft)(uint32_t elementId, void* userData)

    void Clay_SetQueryScrollOffsetFunction(_Clay_SetQueryScrollOffsetFunction_queryScrollOffsetFunction_ft queryScrollOffsetFunction, void* userData)

    Clay_RenderCommand* Clay_RenderCommandArray_Get(Clay_RenderCommandArray* array, int32_t index)

    void Clay_SetDebugModeEnabled(bool enabled)

    bool Clay_IsDebugModeEnabled()

    void Clay_SetCullingEnabled(bool enabled)

    int32_t Clay_GetMaxElementCount()

    void Clay_SetMaxElementCount(int32_t maxElementCount)

    int32_t Clay_GetMaxMeasureTextCacheWordCount()

    void Clay_SetMaxMeasureTextCacheWordCount(int32_t maxMeasureTextCacheWordCount)

    void Clay_ResetMeasureTextCache()

    void Clay__OpenElement()

    void Clay__ConfigureOpenElement(const Clay_ElementDeclaration config)

    void Clay__ConfigureOpenElementPtr(const Clay_ElementDeclaration* config)

    void Clay__CloseElement()

    Clay_ElementId Clay__HashString(Clay_String key, uint32_t offset, uint32_t seed)

    void Clay__OpenTextElement(Clay_String text, Clay_TextElementConfig* textConfig)

    Clay_TextElementConfig* Clay__StoreTextElementConfig(Clay_TextElementConfig config)

    uint32_t Clay__GetParentElementId()

    Clay_Color Clay__debugViewHighlightColor

    uint32_t Clay__debugViewWidth
