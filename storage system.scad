// box connector parameters
// oficina
//unit_side = 55;
//unit_height = 45;
// mesa de luz
unit_side = 65;
unit_height = 75;
connector_height = 5;
connector_base = 5;

tolerance = 1;
wall = 1.2;

//base 5x5
//printer 3x3
//translate([0,0,-2]) base(2, 1);
//translate([calcSizeTest(0),calcSizeTest(0),calcHeight(0) + 1]) 
box(2, 2, 1);
//color("blue")
//translate([calcSizeTest(0),calcSizeTest(0),calcHeight(1) + 2]) box(1, 1, 1);
//color("green")
//translate([calcSizeTest(0),calcSizeTest(1),calcHeight(0) + 1]) box(2, 1, 2);

function calcSizeTest(units) = calcSize(units) + tolerance/2;

function calcSize(units) = units * unit_side;
function calcHeight(units) = units * unit_height;

module connector(width, length) {
    // Width and length in connector units.
    // Width = 2 means a side with size 2 * unit_side
    total_width = (width * unit_side);
    total_length = (length * unit_side);
    
    difference() {
        cube([
            total_width, 
            total_length, 
            connector_height + wall
        ], center = false);
        translate([wall + tolerance/2, wall + tolerance/2, wall]) cube([
            total_width - 2*wall - tolerance, 
            total_length - 2*wall - tolerance, 
            connector_height + wall
        ], center = false);
        translate([connector_base, connector_base, -connector_height]) cube([
            total_width - 2*connector_base, 
            total_length - 2*connector_base, 
            4*connector_height
        ], center = false);
    }
    
}


module base(width, length) {
    for (x =[0:width-1])
       for (y =[0:length-1]) 
           translate([calcSize(x),calcSize(y),0]) connector(1, 1);
}

module outer_box(width, length, height) { 
 
    for(x = [0 : width-1])
    {
        for(y = [0 : length-1])
        {
            translate([
                calcSize(x)+wall+tolerance/2,
                calcSize(y)+wall+tolerance/2, 
                0
            ])
                linear_extrude(connector_height,center = false)
                    square([
                        calcSize(1) - (2*wall) - 2*tolerance,
                        calcSize(1) - (2*wall) - 2*tolerance
                    ],center = false);
        } 
    }  
        
    translate([0,0,connector_height])
        linear_extrude(calcHeight(height),center = false)
            square([
                calcSize(width) - tolerance,
                calcSize(length) - tolerance
            ],center = false);
}

module inner_box(width, length, height) {
    for(x = [0 : width-1])
    {
        for(y = [0 : length-1])
        {
            translate([
                calcSize(x)+2*wall+tolerance/2,
                calcSize(y)+2*wall+tolerance/2, 
                wall
            ])
                linear_extrude(connector_height,center = false)
                    square([
                        calcSize(1) - (4*wall) - 2*tolerance,
                        calcSize(1) - (4*wall) - 2*tolerance
                    ],center = false);
        } 
    }
    
    translate([wall, wall, connector_height+wall])
        linear_extrude(calcHeight(height),center = false)
            square([
                calcSize(width) - (2*wall) - tolerance,
                calcSize(length) - (2*wall) - tolerance
            ],center = false);
}

module box(width, length, height) {
    color("red")
    difference() {
        outer_box(width, length, height);
        inner_box(width, length, height);
    }
}
