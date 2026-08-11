// printable.scad
// Select a single part to render for 3D printing

use <main.scad>

/* [Print Selection] */
// Select which part to render
part_to_print = 0; // [0:GMKtec NUC G3, 1:Raspberry Pi + SSD 1, 2:Raspberry Pi + SSD 2, 3:Raspberry Pi 3B/4B, 4:Roof Plate]

// Render the selected part centered on the origin
if (part_to_print == 0) {
    support_nucg3();
} else if (part_to_print == 1) {
    support_raspi_ssd1();
} else if (part_to_print == 2) {
    support_raspi_ssd2();
} else if (part_to_print == 3) {
    support_raspi();
} else if (part_to_print == 4) {
    support_roof();
}
