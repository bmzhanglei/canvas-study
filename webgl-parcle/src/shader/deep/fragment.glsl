
precision lowp float;
uniform float uTime;
uniform float uScale;
varying vec2 vUv;

void main(){
      float angle = atan(vUv.y,vUv.x);
    float strength = angle;
    gl_FragColor =vec4(strength,strength,strength,1);
}