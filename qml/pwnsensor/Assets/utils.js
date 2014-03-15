.pragma library

function clamp(val, min, max)
{
    return((val<min)?min:((val>max)?max:val))
}

// rgbToHsb converts an input color Object{r:red, g: green, b: blue} to HSB color space
// References
//  [1] https://github.com/bgrins/TinyColor
//  [2] http://en.wikipedia.org/wiki/HSL_and_HSV
function rgbToHsb(rgb){
    var max = Math.max(rgb.r, rgb.g, rgb.b), min = Math.min(rgb.r, rgb.g, rgb.b);
    var C = max-min;
    var l = (max+min)/2.
    var h;

    if(C==0){
        h=0
    }
    else{
        var s = l > 0.5 ? C / (2 - max - min) : C / (max + min);
        switch(max) {
            case rgb.r: h = (rgb.g - rgb.b) / C + (rgb.g < rgb.b ? 6 : 0); break;
            case rgb.g: h = (rgb.b - rgb.r) / C + 2; break;
            case rgb.b: h = (rgb.r - rgb.g) / C + 4; break;
        }
        h /= 6;
    }
    return { h: h, s: (C==0)?0.:C/max, b: max };
}


// References
//  [1] https://github.com/bgrins/TinyColor
function hsbToColor(hsb) {
    var lightness = (2 - hsb.s)*hsb.b;
    var satHSL = hsb.s*hsb.b/((lightness <= 1) ? lightness : 2 - lightness);
    lightness /= 2;
    return Qt.hsla(hsb.h, satHSL, lightness, 1.0);
}


//    from https://github.com/bgrins/TinyColor
function rgbToHsl(r, g, b) {
    var max = Math.max(r, g, b), min = Math.min(r, g, b);
    var h, s, l = (max + min) / 2;

    if(max == min) {
        h = s = 0; // achromatic
    }
    else {
        var d = max - min;
        s = l > 0.5 ? d / (2 - max - min) : d / (max + min);
        switch(max) {
            case r: h = (g - b) / d + (g < b ? 6 : 0); break;
            case g: h = (b - r) / d + 2; break;
            case b: h = (r - g) / d + 4; break;
        }
        h /= 6;
    }
    return { h: h, s: s, l: l };
}
