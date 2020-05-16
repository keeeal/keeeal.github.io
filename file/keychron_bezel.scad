
$fn = 64;

module keychron_bezel(width, height, edge_thickness=2, top_thickness=1) {
    
    module x_profile() {
        module a() translate([0, 15.3]) circle(.4);
        module b() translate([-.4, 16.6]) square([.8, top_thickness]);
        module c() translate([3.1, 16.6]) square([edge_thickness, top_thickness]);
        module d() translate([2.3, 0]) square([edge_thickness, .8]);
        module e() translate([.3, 0]) square([.8, .8]);
        module f() translate([.7, 1.4]) circle(.4);
        hull() { a(); b(); }
        hull() { b(); c(); }
        hull() { c(); d(); }
        hull() { d(); e(); }
        hull() { e(); f(); }
    }

    module y_profile() {
        module a() translate([0, 16.2]) circle(.4);
        module b() translate([-.4, 16.6]) square([.8, top_thickness]);
        module c() translate([3.1, 16.6]) square([edge_thickness, top_thickness]);
        module d() translate([2.3, 0]) square([edge_thickness, .8]);
        module e() translate([.3, 0]) square([.8, .8]);
        hull() { a(); b(); }
        hull() { b(); c(); }
        hull() { c(); d(); }
        hull() { d(); e(); }
    }

    module r_profile() {
        module b() translate([0, 16.6]) square([.8, top_thickness]);
        module c() translate([3.1, 16.6]) square([edge_thickness, top_thickness]);
        module d() translate([2.3, 0]) square([edge_thickness, .8]);
        module e() translate([.3, 0]) square([.8, .8]);
        hull() { b(); c(); }
        hull() { c(); d(); }
        hull() { d(); e(); }
    }
    
    w = width - 4.6;
    h = height - 5.6;

    module half_shell() {
        rotate([90, 0, 90]) linear_extrude(w/2) x_profile();
        rotate([0, 0, 90]) rotate_extrude(angle=90) r_profile();
        translate([0, -h, 0]) rotate([90, 0, 180]) linear_extrude(h) y_profile();
        translate([0, -h, 0]) rotate([0, 0, 180]) rotate_extrude(angle=90) r_profile();
        translate([0, -h, 0]) mirror([0, 1, 0]) rotate([90, 0, 90]) linear_extrude(w/2) x_profile();
    }

    module left() {
        difference() {
            half_shell();
            translate([0, -43.3, .5]) rotate([0, -90, 0])
            linear_extrude(10) minkowski() {
                circle(3.2);
                square([4, 50.5], true);
            }
        }
    }

    module right() {
        half_shell();
    }
    
    left();
    translate([w/2+10, -edge_thickness-13.50, 0])
    mirror([1, 0, 0]) right();
}

//keychron_bezel(width=311.0, height=102.4); // K6
keychron_bezel(width=370.0, height=124.0); // K4

















