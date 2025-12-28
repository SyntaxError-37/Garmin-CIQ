import Toybox.Activity;
import Toybox.Graphics;
import Toybox.Lang;
import Toybox.WatchUi;
import Toybox.Math;



import Bars;

class bartestView extends WatchUi.DataField {

    var prg;
    var tapped = false;
    var barSet = false;

    public const Colors as Array<Graphics.ColorType> = [
            Graphics.COLOR_BLUE,
            Graphics.COLOR_DK_BLUE,
            Graphics.COLOR_DK_GRAY,
            Graphics.COLOR_DK_GREEN,
            Graphics.COLOR_DK_RED,
            Graphics.COLOR_GREEN,
            Graphics.COLOR_DK_GRAY,
            Graphics.COLOR_RED,
            Graphics.COLOR_YELLOW,
            Graphics.COLOR_PINK,
            Graphics.COLOR_PURPLE,
            Graphics.COLOR_ORANGE,
            Graphics.COLOR_LT_GRAY
        ];       
    var dim = [] as Array;
    var style =[] as Array;

    function flipCoin() as Boolean {
        return Math.rand() > 1073741823 ? true : false;
    }
    
    function initialize() {
        DataField.initialize();        
        tapped = true;
    }


    // Display the value you computed here. This will be called
    // once a second when the data field is visible.
    function onUpdate(dc as Dc) as Void {
        
        System.println(tapped);
        dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_BLACK);
        dc.clear();
        var yC = dc.getHeight() * 0.5 as Float;
        var xC = dc.getWidth() * 0.5 as Float;    
        
        
        if (tapped) {
            dim = [] as Array;
            style = [] as Array;
            var _arcStart = (Math.rand() / 2147483647.0) * 360.0;
            var _arcEnd = _arcStart + (Math.rand() / 2147483647.0) * 210 + 60;
            var _color = Colors[Math.floor((Math.rand() / 2147483647.0) * 12).toNumber()];                      
            dim.add([
                xC, 
                yC,
                xC,
                2,
                (xC * 0.24).toNumber(),
                _arcStart,
                _arcEnd,
                flipCoin() ? Graphics.ARC_CLOCKWISE : Graphics.ARC_COUNTER_CLOCKWISE
                ]);
            style.add([
                _color,
                Graphics.COLOR_BLACK,
                true,
                true,
                flipCoin()
            ]);

            _arcStart = (Math.rand() / 2147483647.0) * 360.0;
            _arcEnd = _arcStart + (Math.rand() / 2147483647.0) * 210 + 60;

            dim.add([
                xC, 
                yC,
                xC * 0.65,
                0,
                (xC * 0.18).toNumber(),
                _arcStart,
                _arcEnd,
                flipCoin() ? Graphics.ARC_CLOCKWISE : Graphics.ARC_COUNTER_CLOCKWISE
                ]);
            style.add([
                Colors[Math.floor((Math.rand() / 2147483647.0) * 12).toNumber()],
                Graphics.COLOR_BLACK,
                true,
                true,
                flipCoin()
            ]);

            _arcStart = (Math.rand() / 2147483647.0) * 360.0;
            _arcEnd = _arcStart + (Math.rand() / 2147483647.0) * 210 + 60;

            dim.add([
                xC, 
                yC,
                xC * 0.4,
                0,
                (xC * 0.12).toNumber(),
                _arcStart,
                _arcEnd,
                flipCoin() ? Graphics.ARC_CLOCKWISE : Graphics.ARC_COUNTER_CLOCKWISE
                ]);
            style.add([
                Colors[Math.floor((Math.rand() / 2147483647.0) * 12).toNumber()],
                Graphics.COLOR_BLACK,
                true,
                true,
                flipCoin()
            ]);
            prg = 0;
            tapped = false;
            barSet = true;
        }        
        
        if (barSet) {
            Bars.drawProgressbarArc(
                dc,
                dim[0],
                prg,
                style[0]
            );     
            Bars.drawProgressbarArc(
                dc,
                dim[1],
                prg,
                style[1]
            );        
            Bars.drawProgressbarArc(
                dc,
                dim[2],
                prg,
                style[2]
            );                
            prg += 0.2 * (Math.rand() / 2147483647.0);
            if (prg > 1)
            {prg = 0; tapped=true;}
        }
    }

    
        

 
}





 