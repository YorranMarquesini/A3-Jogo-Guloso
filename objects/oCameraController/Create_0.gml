// CREATE

cam_width = 1366;
cam_height = 768;

camera = camera_create_view(
    0,
    0,
    cam_width,
    cam_height
);

view_enabled = true;
view_visible[0] = true;
view_camera[0] = camera;

target = oPlayer;