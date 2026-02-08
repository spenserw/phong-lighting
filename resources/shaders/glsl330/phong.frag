#version 330 core

out vec4 FragColor;

in vec3 FragPos;
in vec3 Normal;

uniform vec3 objectColor;
uniform vec3 lightColor;
uniform vec3 lightPosition;

void main() {
  float ambientStrength = 0.2;
  vec3 ambient = ambientStrength * lightColor;

  vec3 norm = normalize(Normal);
  vec3 lightDirection = normalize(lightPosition - FragPos);
  // max 0 to not wash out ambient lighting from negative normals
  float diffuseStrength = max(dot(lightDirection, norm), 0.0);
  vec3 diffuse = diffuseStrength * lightColor;

  vec3 result = (ambient + diffuse) * objectColor;
  FragColor = vec4(result, 1.0);
}
