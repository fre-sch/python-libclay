from libclay import Clay, Element, ElementDeclaration, SizingAxis, SizingType

clay = Clay((800, 600))

with clay.layout():
    with Element(ElementDeclaration(
        id_=Element.new_id("first"),
    )):
        pass
    with Element(ElementDeclaration(
        id_=Element.new_id("second"),
    )):
        pass

print("length", clay.render_commands.length)
print("capacity", clay.render_commands.capacity)


axis = SizingAxis()
print(axis.type_.name)
