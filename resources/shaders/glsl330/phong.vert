#version 330 core

layout(location = 0) in vec3 vertexPosition;
layout(location = 2) in vec3 vertexNormal;

out vec3 FragPos;
out vec3 Normal;

uniform mat4 matModel;
uniform mat4 matView;
uniform mat4 matProjection;

void main() {
  // vertex data in world space
  FragPos = vec3(matModel * vec4(vertexPosition, 1.0));
  Normal = inverse(transpose(mat3(matModel))) * vertexNormal;

  gl_Position = matProjection * matView * matModel * vec4(vertexPosition, 1.0);
}
