embedded_components {
  id: "sprite"
  type: "sprite"
  data: "default_animation: \"note_1\"\n"
  "material: \"/builtins/materials/sprite.material\"\n"
  "textures {\n"
  "  sampler: \"texture_sampler\"\n"
  "  texture: \"/main/assets.atlas\"\n"
  "}\n"
  ""
  scale {
    x: 2.0
    y: 2.0
  }
}
embedded_components {
  id: "collisionobject"
  type: "collisionobject"
  data: "type: COLLISION_OBJECT_TYPE_DYNAMIC\n"
  "mass: 1.0\n"
  "friction: 0.1\n"
  "restitution: 0.5\n"
  "group: \"note\"\n"
  "mask: \"button\"\n"
  "embedded_collision_shape {\n"
  "  shapes {\n"
  "    shape_type: TYPE_BOX\n"
  "    position {\n"
  "    }\n"
  "    rotation {\n"
  "    }\n"
  "    index: 0\n"
  "    count: 3\n"
  "  }\n"
  "  data: 23.81141\n"
  "  data: 23.899258\n"
  "  data: 10.0\n"
  "}\n"
  ""
}
