import QtQuick 2.0


Rectangle{
     id: root
     color: "red"
     border.width: 0
     property var points: []
     property var sensors: null
     property var current_item: 0
     property var chart_canvas: canvas

     Canvas {
         id: canvas
         width: parent.width
         height: parent.height
         renderTarget: Canvas.FramebufferObject
         antialiasing: true

         function drawBackground(ctx) {
             ctx.save();
             ctx.fillStyle = "#252b31";
             ctx.fillRect(0, 0, canvas.width, canvas.height);
             ctx.strokeStyle = "#424a51";
             ctx.lineWidth = 1;
             ctx.beginPath();
             for (var i = 0; i <= 8; i++) {
                 ctx.moveTo(0, i * (canvas.height/8.0));
                 ctx.lineTo(canvas.width, i * (canvas.height/8.0));
             }

             for (i = 0; i <= 12; i++) {
                 ctx.moveTo(i * (canvas.width/12.0), 0);
                 ctx.lineTo(i * (canvas.width/12.0), canvas.height);
             }
             ctx.stroke();

             ctx.restore();
         }


         function drawGraph(ctx, color, points)
         {
             ctx.save();
             //ctx.globalAlpha = 0.7;
             ctx.strokeStyle = color;
             ctx.lineWidth = 2;
             ctx.lineCap = "round";
             ctx.lineJoin = "bevel";
             ctx.shadowColor = color;
             ctx.shadowBlur = 3;
             ctx.beginPath();

             var end = points.length;
             for (var i = 0; i < end; i++)
                 {
                 if (i == 0)
                     {
//                     ctx.arc(points[i].x, canvas.height-points[i].y, 9,0,2*Math.PI);
                     ctx.moveTo(points[i].x, canvas.height-points[i].y);
                     }
                 else
                     {
//                     ctx.arc(points[i].x, canvas.height-points[i].y, 9,0,2*Math.PI);
//                     ctx.stroke();
                     ctx.lineTo(points[i].x, canvas.height-points[i].y);
                     }
                 }
             ctx.stroke();
             ctx.restore();
         }

         onPaint: {
             var ctx = canvas.getContext("2d");
             ctx.globalCompositeOperation = "source-over";
             drawBackground(ctx);
         }
     }
}
