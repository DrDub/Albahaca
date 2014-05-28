var H = Strict.AlbahacaHS;

function render(){
    var svgElement = document.getElementById("svg");
    var inputSvg = document.getElementById("input-svg");
    var inputTxt = document.getElementById("input-txt");
    var text = inputTxt.value;
    svgElement.innerHTML = inputSvg.value;

    var draw=Snap("#svg");


    var points = [];
    var paths=draw.selectAll("path");
    for(var j in paths) {
        var p = paths[j];
        var points_in_path = [];
        var i = 0; 
        if(p.getTotalLength){
            while(i<p.getTotalLength()){
                var point = p.getPointAtLength(i);
                points_in_path.push({instance: "Point", x: point.x, y: point.y });
                //draw.circle(point.x, point.y, 5);
                i+= 20;
            }
            points.push(points_in_path); 
        }
    }
    var r=H.wander(15, points);
    console.log(JSON.stringify(r));
    for(var i in r) {
        var p = r[i][0];
        draw.text(p.x,p.y, 
                  text.substr(2*i,2));
                  //text.charAt(i));
    }
}
