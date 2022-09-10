<script setup>
import { onMounted } from "vue";
import * as THREE from "three";
import { OrbitControls } from "three/examples/jsm/controls/OrbitControls";

import basicVertexShader from "@/shader/glsl/vertex.glsl?raw";
import basicFragmentShader from "@/shader/glsl/fragment.glsl?raw";

onMounted(() => {
  const scene = new THREE.Scene();
  // 创建透视相机
  const camera = new THREE.PerspectiveCamera(
    90,
    window.innerHeight / window.innerHeight,
    0.1,
    1000
  );
  // 设置相机位置
  // object3d具有position，属性是1个3维的向量
  camera.position.set(0, 0, 2);
  // 更新摄像头
  camera.aspect = window.innerWidth / window.innerHeight;
  //   更新摄像机的投影矩阵
  camera.updateProjectionMatrix();
  scene.add(camera);

  // 加入辅助轴，帮助我们查看3维坐标轴
  const axesHelper = new THREE.AxesHelper(5);
  scene.add(axesHelper);
  const shaderMaterial = new THREE.ShaderMaterial({
    vertexShader: basicVertexShader,
    fragmentShader: basicFragmentShader,
  });

  // 创建平面
  const floor = new THREE.Mesh(
    new THREE.PlaneBufferGeometry(1, 1, 64, 64),
    shaderMaterial,
  );
  scene.add(floor);

  const renderer = new THREE.WebGLRenderer({ alpha: true });
  // renderer.shadowMap.enabled = true;
  // renderer.shadowMap.type = THREE.BasicShadowMap;
  // renderer.shadowMap.type = THREE.VSMShadowMap;

  renderer.setSize(window.innerWidth, window.innerHeight);

  // 监听屏幕大小改变的变化，设置渲染的尺寸
  window.addEventListener("resize", () => {
    //   console.log("resize");
    // 更新摄像头
    camera.aspect = window.innerWidth / window.innerHeight;
    //   更新摄像机的投影矩阵
    camera.updateProjectionMatrix();

    //   更新渲染器
    renderer.setSize(window.innerWidth, window.innerHeight);
    //   设置渲染器的像素比例
    renderer.setPixelRatio(window.devicePixelRatio);
  });

  // 将渲染器添加到body
  document.getElementById("test").appendChild(renderer.domElement);

  // 初始化控制器
  const controls = new OrbitControls(camera, renderer.domElement);
  // 设置控制器阻尼
  controls.enableDamping = true;
  // 设置自动旋转
  // controls.autoRotate = true;

  const clock = new THREE.Clock();
  function animate(t) {
    const elapsedTime = clock.getElapsedTime();
    //   console.log(elapsedTime);
    requestAnimationFrame(animate);
    // 使用渲染器渲染相机看这个场景的内容渲染出来
    renderer.render(scene, camera);
  }

  animate();
});
</script>

<template>
  <div id="test"></div>
</template>

<style>
canvas {
  background-color: black;
}
</style>
