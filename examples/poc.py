from libclay import Clay, Element, ElementDeclaration, SizingAxis, SizingType

clay = Clay((800, 600))

with clay.begin():
    with Element(ElementDeclaration(

    )):
        pass
    with Element(ElementDeclaration(

    )):
        pass

print("length", clay.render_commands.length)
print("capacity", clay.render_commands.capacity)
print(len(clay.render_commands))

axis = SizingAxis()
print(axis.type.name)
