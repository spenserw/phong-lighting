#version 330 core

out vec4 FragColor;

in vec3 FragPos;
in vec3 Normal;

uniform vec3 objectColor;
uniform vec3 lightColor;
uniform vec3 lightPosition;
uniform vec3 cameraPosition;

const float ambientConstant = 0.1;
const float diffuseConstant = 0.9;
const float specularConstant = 0.5;

void main() {
  vec3 ambient = ambientConstant * lightColor;

  vec3 norm = normalize(Normal);

  vec3 lightDirection = normalize(lightPosition - FragPos);
  float diffuseStrength = max(dot(lightDirection, norm), 0.0) * diffuseConstant;
  vec3 diffuse = diffuseStrength * lightColor;

  vec3 reflection = 2 * normalize(dot(lightDirection, norm)) * norm - lightDirection;
  vec3 cameraDirection = normalize(cameraPosition - FragPos);
  float specularStrength = max(dot(reflection, cameraDirection), 0.0) * specularConstant;
  vec3 specular = specularStrength * lightColor;

  vec3 illumination = (ambient + diffuse + specular);
  vec3 result = illumination * objectColor;
  FragColor = vec4(result, 1.0);
}
