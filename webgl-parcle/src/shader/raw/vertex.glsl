precision lowp float;
attribute vec3  position;
attribute vec2  uv;
uniform mat4 modelMatrix;
uniform mat4 viewMatrix;
uniform mat4 projectionMatrix;
varying vec2 vUv;
varying float vElevation;
// high -2^16 - 2^16
// mediump -2^10 - 2^10
// lowp -2^8 - 2^8
uniform float uTime;

void main(){
    vUv = uv;
    vec4 modelPosition = modelMatrix * vec4( position, 1.0 );
    // modelPosition.x += 1.0;
    // modelPosition.z += modelPosition.x;
    modelPosition.z = sin((modelPosition.x+uTime)*10.0)*0.03;
    modelPosition.z += sin((modelPosition.y+uTime)*10.0)*0.05;
    vElevation = modelPosition.z;
    gl_Position = projectionMatrix * viewMatrix *  modelPosition;
}