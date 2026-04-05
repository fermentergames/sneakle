///
function ordinal_string(n) {
    var suffix = "th";
    var last_two = real(n) mod 100;
    
    // Handle special cases: 11, 12, 13 with default "th"
    if (last_two < 11 || last_two > 13) {
        switch (real(n) mod 10) {
            case 1: suffix = "st"; break;
            case 2: suffix = "nd"; break;
            case 3: suffix = "rd"; break;
        }
    }
    
    return string(n) + suffix;
}