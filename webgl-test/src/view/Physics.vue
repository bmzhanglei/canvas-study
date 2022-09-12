<script setup>
import { onMounted } from "vue";
import * as THREE from "three";
import { OrbitControls } from "three/examples/jsm/controls/OrbitControls";
import * as CANNON from "cannon-es";


const scene = new THREE.Scene();
const camera = new THREE.PerspectiveCamera(
  75,
  window.innerWidth / window.innerHeight,
  0.1,
  1000
);
camera.position.set(0, 0, 18);
scene.add(camera);

// 创建球和平面
const sphereGeometry = new THREE.SphereGeometry(1, 20, 20);
const sphereMaterial = new THREE.MeshStandardMaterial();
const sphere = new THREE.Mesh(sphereGeometry, sphereMaterial);
sphere.castShadow = true;
scene.add(sphere);

const floor = new THREE.Mesh(
  new THREE.PlaneBufferGeometry(20, 20),
  new THREE.MeshStandardMaterial()
);

floor.position.set(0, -5, 0);
floor.rotation.x = -Math.PI / 2;
floor.receiveShadow = true;
scene.add(floor);

const world = new CANNON.World();
world.gravity.set(0, -9.8, 0);
const sphereShape = new CANNON.Sphere(1);
const sphereWorldMaterial = new CANNON.Material("sphere");

// 创建物理世界的物体
const sphereBody = new CANNON.Body({
  shape: sphereShape,
  position: new CANNON.Vec3(0, 0, 0),
  //   小球质量
  mass: 1,
  //   物体材质
  material: sphereWorldMaterial,
});

world.addBody(sphereBody);

const floorShape = new CANNON.Plane();
const floorBody = new CANNON.Body();
const floorMaterial = new CANNON.Material("floor1");
floorBody.material = floorMaterial;
floorBody.mass = 0;
floorBody.addShape(floorShape);
floorBody.position.set(0, -5, 0);
floorBody.quaternion.setFromAxisAngle(new CANNON.Vec3(1, 0, 0), -Math.PI / 2);
world.addBody(floorBody);

const ambientLight = new THREE.AmbientLight(0xffffff, 0.5);
scene.add(ambientLight);
const dirLight = new THREE.DirectionalLight(0xffffff, 0.5);
dirLight.castShadow = true;
scene.add(dirLight);

const renderer = new THREE.WebGLRenderer({ alpha: true });
// 设置渲染的尺寸大小
renderer.setSize(window.innerWidth, window.innerHeight);
// 开启场景中的阴影贴图
renderer.shadowMap.enabled = true;

const controls = new OrbitControls(camera, renderer.domElement);
// 设置控制器阻尼，让控制器更有真实效果,必须在动画循环里调用.update()。
controls.enableDamping = true;

// 添加坐标轴辅助器
const axesHelper = new THREE.AxesHelper(5);
scene.add(axesHelper);

const clock = new THREE.Clock();

function render() {
  //   let time = clock.getElapsedTime();
  let deltaTime = clock.getDelta();
  // 更新物理引擎里世界的物体
  world.step(1 / 120, deltaTime);

  sphere.position.copy(sphereBody.position);

  renderer.render(scene, camera);
  //   渲染下一帧的时候就会调用render函数
  requestAnimationFrame(render);
}

render();


onMounted(() => {
  document.getElementById("test").appendChild(renderer.domElement);
  window.addEventListener("resize", () => {
    // 更新摄像头
    camera.aspect = window.innerWidth / window.innerHeight;
    //   更新摄像机的投影矩阵
    camera.updateProjectionMatrix();

    //   更新渲染器
    renderer.setSize(window.innerWidth, window.innerHeight);
    //   设置渲染器的像素比
    renderer.setPixelRatio(window.devicePixelRatio);
  });
});
</script>

<template>
  <div id="test"></div>
</template>
