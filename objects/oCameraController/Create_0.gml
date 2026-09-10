cam_width = 1366;
cam_height = 768;

camera = camera_create_view(0, 0, cam_width, cam_height);
view_camera[0] = camera;
view_enabled = true;
view_visible[0] = true;

target = oPlayer;   // objeto que a câmera segue
lerp_factor = 0.15; // suavidade do follow (0 a 1, menor = mais suave)

cam_x = target.x - cam_width / 2;
cam_y = target.y - cam_height / 2;