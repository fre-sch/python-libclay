from libclay import Clay, Element, SizingAxis, SizingType

clay = Clay((800, 600))

with clay.begin():
    with Element():
        pass

print(len(clay.render_commands))

axis = SizingAxis()
print(axis.type.name)
