scroll_y += scroll_speed;
if (keyboard_check(vk_shift)) scroll_y += 2.2;
if (keyboard_check_pressed(vk_escape) || keyboard_check_pressed(vk_enter)) finish_credits();
if (scroll_y > 9400) finish_credits();
