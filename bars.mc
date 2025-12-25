import Toybox.Graphics;
import Toybox.Lang;
import Toybox.Math;




module Bars {


    //draws Progressbar with Border at position X:Y with height/width and percenComp filled/receded Bar, optional show Percent filled 
    function drawProgressbar(
        dc as Dc,
        x as Number,
        y as Number,
        percentComp as Float,
        width as Number,
        height as Number,
        color as Graphics.ColorType,
        backgroundColor as Graphics.ColorType,
        filling as Boolean,
        showPercent as Boolean,
        font as Graphics.FontType) as Void {     
              
        if (width == 0 || height==0 ) {return;}
        var _backgroundColorOpp = (backgroundColor == Graphics.COLOR_BLACK) ? Graphics.COLOR_WHITE : Graphics.COLOR_BLACK;
        dc.setColor(_backgroundColorOpp, Graphics.COLOR_TRANSPARENT);

        var _borderwidth = 1;         
        dc.setPenWidth(_borderwidth);
        dc.drawRectangle(x, y, width, height);

        var _clampedPercent = percentComp > 1.0 ? 1.0 : percentComp;
        _clampedPercent = percentComp < 0.0 ? 0.0 : percentComp;
        var _fillWidth = (width - _borderwidth * 2) * _clampedPercent;
        
        var _barStart = x;
        if (filling == false) { _barStart = x + _fillWidth; _fillWidth = width - _fillWidth - 2 * _borderwidth;} // adjust Bar Position for receding Progressbars

        dc.setColor(color, Graphics.COLOR_BLACK);        
        dc.fillRectangle(_barStart + _borderwidth, y + _borderwidth, _fillWidth, height -  2 * _borderwidth);

        //display percent number in Bar
        if (showPercent) {
            dc.setColor(_backgroundColorOpp, Graphics.COLOR_TRANSPARENT);
            var _percentNumber = _clampedPercent * 100;
            var _percentDisp = _percentNumber.format("%.1f") + "%";
            var _textJustify = _clampedPercent <= 0.66 ? Graphics.TEXT_JUSTIFY_LEFT : Graphics.TEXT_JUSTIFY_RIGHT;
            dc.drawText(x + _borderwidth + (width - _borderwidth * 2) * _clampedPercent , y - _borderwidth, font, _percentDisp, _textJustify);
        }

    }

    //draws Progressbar with Border at position X:Y with height/width and percenComp filled/receding Bar, optional show Percent filled 
    function drawProgressbarRounded(
        dc as Dc,
        x as Number,
        y as Number,
        percentComp as Float,
        width as Number,
        height as Number,
        color as Graphics.ColorType,
        backgroundColor as Graphics.ColorType,
        filling as Boolean,
        showPercent as Boolean,
        font as Graphics.FontType) as Void {    

        if (width == 0 || height==0 ) {return;}
        
        var _backgroundColorOpp = (backgroundColor == Graphics.COLOR_BLACK) ? Graphics.COLOR_WHITE : Graphics.COLOR_BLACK;
        dc.setColor(_backgroundColorOpp, Graphics.COLOR_TRANSPARENT);

        var _borderwidth = 1;
        dc.setPenWidth(_borderwidth);
        dc.drawRoundedRectangle(x, y, width, height, height * 0.5);

        var _clampedPercent = percentComp > 1.0 ? 1.0 : percentComp;
        _clampedPercent = percentComp < 0.0 ? 0.0 : percentComp;
        var _fillWidth = (width - _borderwidth * 2) * _clampedPercent;


        var _barStart = x;
        if (filling == false) { _barStart = x + _fillWidth; _fillWidth = width - _fillWidth - 2 * _borderwidth;}

        dc.setColor(color, Graphics.COLOR_BLACK);        
        dc.fillRoundedRectangle(_barStart + _borderwidth, y + _borderwidth, _fillWidth, height -  2 * _borderwidth, 0.5 * height - _borderwidth);
        
        //display percent number in Bar
        if (showPercent) {
            dc.setColor(_backgroundColorOpp, Graphics.COLOR_TRANSPARENT);
            var _percentNumber = _clampedPercent * 100;
            var _percentDisp = _percentNumber.format("%.1f") + "%";
            var _textJustify = _clampedPercent <= 0.66 ? Graphics.TEXT_JUSTIFY_LEFT : Graphics.TEXT_JUSTIFY_RIGHT;
            dc.drawText(x + _borderwidth + (width - _borderwidth * 2) * _clampedPercent , y - _borderwidth, font, _percentDisp, _textJustify);
        }
        

    }

    //draws an arced Progressbar
    function drawProgressBarArc(dc as Dc,
        xCenter as Number,
        yCenter as Number,
        r as Number,
        padding as Number,
        arcStart as Number,
        arcEnd as Number,
        direction as ArcDirection,
        percentComp as Float,
        height as Number,
        color as Graphics.ColorType,
        backgroundColor as Graphics.ColorType,
        filling as Boolean,
        showPercent as Boolean,
        font as Graphics.FontType) as Void {

        if (arcStart==arcEnd) {return;}

        var _borderColor = (backgroundColor == Graphics.COLOR_BLACK) ? Graphics.COLOR_WHITE : Graphics.COLOR_BLACK;

        var _borderwidth = 1;
        var _rBarMid = r - height * 0.5 - _borderwidth - padding;
        var _clampedPercent = percentComp > 1.0 ? 1.0 : percentComp;

        //calculates Arclenght, adjust values when crossing 3 o´clock position 
        if (direction.equals(Graphics.ARC_COUNTER_CLOCKWISE) && arcStart > arcEnd) {arcEnd+=360;} else if (arcStart < arcEnd) {arcStart+=360;}
        var _arclength = arcEnd - arcStart;        

        //calculates bar start and end
        var _barStart = arcStart;
        var _barEnd = Math.floor(arcStart + _arclength * _clampedPercent);
        if (!filling) {_barStart = _barEnd; _barEnd = arcEnd;} // for receding bars

        //draws bar
        dc.setPenWidth(height - _borderwidth * 2);
        dc.setColor(color, Graphics.COLOR_TRANSPARENT);
        dc.drawArc(
            xCenter,
            yCenter,
            _rBarMid,
            direction,
            _barStart,
            _barEnd
        );

        dc.setColor(_borderColor, Graphics.COLOR_TRANSPARENT);

        if (showPercent) {
            //display percent Value 
            var _percentNumber = _clampedPercent * 100;
            var _percentDisp = _percentNumber.format("%.1f") + "%";

            //sets text direction to the display percent value correctly 
            var _textdirection = direction.equals(Graphics.ARC_CLOCKWISE) ? Graphics.RADIAL_TEXT_DIRECTION_CLOCKWISE : Graphics.RADIAL_TEXT_DIRECTION_COUNTER_CLOCKWISE;           
            var _textradius = _textdirection.equals(Graphics.RADIAL_TEXT_DIRECTION_CLOCKWISE) ? r - padding - _borderwidth - 1 : r - padding + _borderwidth - height + 1;         
            var _textJustify = _clampedPercent <= 0.66 ? Graphics.TEXT_JUSTIFY_LEFT : Graphics.TEXT_JUSTIFY_RIGHT;

            dc.drawRadialText(
                xCenter,
                yCenter,
                font,
                _percentDisp,
                _textJustify,
                arcStart + _arclength * _clampedPercent,
                _textradius,
                _textdirection
                );
        }       
        
        //draw border
        dc.setPenWidth(_borderwidth);
        dc.drawArc(
            xCenter,
            yCenter,
            r - padding,
            direction,
            arcStart,
            arcEnd
        );
        dc.drawArc(
            xCenter,
            yCenter,
            r - padding - height,
            direction,
            arcStart,
            arcEnd
        );
        
        //calculate and draw ends 
        var x1 = xCenter + Math.cos(arcStart * Math.PI / 180) * (r - padding - height) ;
        var y1 = yCenter - Math.sin(arcStart * Math.PI / 180) * (r - padding - height) ;
        var x2 = xCenter + Math.cos(arcStart * Math.PI / 180) * (r - padding) ;
        var y2 = yCenter - Math.sin(arcStart * Math.PI / 180) * (r - padding);
        dc.drawLine(x1,y1,x2,y2);
        x1 = xCenter + Math.cos(arcEnd * Math.PI / 180) * (r - padding - height) ;
        y1 = yCenter - Math.sin(arcEnd * Math.PI / 180) * (r - padding - height) ;
        x2 = xCenter + Math.cos(arcEnd * Math.PI / 180) * (r - padding) ;
        y2 = yCenter - Math.sin(arcEnd * Math.PI / 180) * (r - padding);
        dc.drawLine(x1,y1,x2,y2);
    }


    //draws an arced Progressbar with rounded ends
    function drawProgressBarArcRounded(dc as Dc,
        xCenter as Number,
        yCenter as Number,
        r as Number,
        padding as Number,
        arcStart as Number,
        arcEnd as Number,
        direction as ArcDirection,
        percentComp as Float,
        height as Number,
        color as Graphics.ColorType,
        backgroundColor as Graphics.ColorType,
        filling as Boolean,
        showPercent as Boolean,
        font as Graphics.FontType) as Void {

        if (arcStart==arcEnd) {return;}

        var _borderColor = (backgroundColor == Graphics.COLOR_BLACK) ? Graphics.COLOR_WHITE : Graphics.COLOR_BLACK;

        var _borderwidth = 1;
        var _clampedPercent = percentComp > 1.0 ? 1.0 : percentComp;
        var _rBarMid = r - height * 0.5 - _borderwidth - padding;

        //calculates Arclenght, adjust values when crossing 3 o´clock position         
        if (direction.equals(Graphics.ARC_COUNTER_CLOCKWISE) && arcStart > arcEnd) {arcEnd+=360;} else if (arcStart < arcEnd) {arcStart+=360;}
        var _arclength = arcEnd - arcStart;        

        //calculates bar start and end
        var _barLength = Math.floor(_arclength * _clampedPercent);
        var _barStart = filling? arcStart : arcStart + _arclength;
        var _barEnd = filling? arcStart + _barLength : arcEnd;

        //draw arced bar 
        dc.setPenWidth(height - _borderwidth * 2);
        dc.setColor(color, Graphics.COLOR_TRANSPARENT);
        dc.drawArc(
            xCenter,
            yCenter,
            _rBarMid,
            direction,
            _barStart,
            _barEnd
        );

        dc.setColor(_borderColor, Graphics.COLOR_TRANSPARENT);

        if (showPercent) {
            //display percent Value 
            var _percentNumber = _clampedPercent * 100;
            var _percentDisp = _percentNumber.format("%.1f") + "%";

            //sets text direction to the display percent value correctly 
            var _textdirection = direction.equals(Graphics.ARC_CLOCKWISE) ? Graphics.RADIAL_TEXT_DIRECTION_CLOCKWISE : Graphics.RADIAL_TEXT_DIRECTION_COUNTER_CLOCKWISE;           
            var _textradius = _textdirection.equals(Graphics.RADIAL_TEXT_DIRECTION_CLOCKWISE) ? r - padding - _borderwidth - 1 : r - padding + _borderwidth - height + 1;       
            var _textJustify = _clampedPercent <= 0.66 ? Graphics.TEXT_JUSTIFY_LEFT : Graphics.TEXT_JUSTIFY_RIGHT;

            dc.drawRadialText(
                xCenter,
                yCenter,
                font,
                _percentDisp,
                _textJustify,
                arcStart + _arclength * _clampedPercent,
                _textradius,
                _textdirection
                );
        }       

        //darw border
        dc.drawArc(
            xCenter,
            yCenter,
            r - padding,
            direction,
            arcStart,
            arcEnd
        );
        dc.drawArc(
            xCenter,
            yCenter,
            r - padding - height,
            direction,
            arcStart,
            arcEnd
        );
        
        //draw bar ends

        var _add = direction.equals(Graphics.ARC_CLOCKWISE) ? -1 : 1; //sets direction for adjusted center of rounded end
        
        //barstart
        //calculates center of rounded ends
        var _arcAdjust = Math.asin((height - 2 * _borderwidth) / (_rBarMid));
        var x1 = xCenter + Math.cos(arcStart * Math.PI / 180 + _add * _arcAdjust * 0.5) * (r - padding - height * 0.5) ;
        var y1 = yCenter - Math.sin(arcStart * Math.PI / 180 + _add * _arcAdjust * 0.5) * (r - padding - height * 0.5) ;
        //calculates arc start/end points, inner angle is startangle
        var _degStart = _arcAdjust + 0.5 * Math.PI;
        _degStart = _degStart / 2 / Math.PI * 360;
        dc.drawArc(x1, y1, height * 0.5 + Math.floor(_borderwidth * 0.5), direction, _degStart, _degStart + 180);
        //draw new backround to cover bar and border outside of rounded end
        dc.setColor(backgroundColor, Graphics.COLOR_TRANSPARENT); 
        var _thick = height * (Math.sqrt(2)-1) / 2;
        dc.setPenWidth(_thick+2);
        dc.drawArc(x1, y1, height * 0.5 + Math.floor(_borderwidth * 0.5) + _thick * 0.5 + 2, direction, _degStart, _degStart + 180);        

        //barend
        dc.setColor(_borderColor, Graphics.COLOR_TRANSPARENT);
        dc.setPenWidth(_borderwidth);
        _arcAdjust = Math.asin((height - 2 * _borderwidth) / (r - padding -_borderwidth - height * 0.5));
        x1 = xCenter + Math.cos(arcEnd * Math.PI / 180 - _add * _arcAdjust * 0.5) * (r - padding - height * 0.5) ;
        y1 = yCenter - Math.sin(arcEnd * Math.PI / 180 - _add * _arcAdjust * 0.5) * (r - padding - height * 0.5) ;
        _degStart = _arcAdjust + 0.5 * Math.PI;
        _degStart = _degStart / 2 / Math.PI * 360;
        var _barEndDirection = direction.equals(Graphics.ARC_CLOCKWISE) ? Graphics.ARC_COUNTER_CLOCKWISE : Graphics.ARC_CLOCKWISE;
        dc.drawArc(x1, y1, height * 0.5 + Math.floor(_borderwidth * 0.5), _barEndDirection, _degStart, _degStart + 180);
        dc.setColor(backgroundColor, Graphics.COLOR_TRANSPARENT);
        dc.setPenWidth(_thick+2);
        dc.drawArc(x1, y1, height * 0.5 + Math.floor(_borderwidth * 0.5) + _thick * 0.5 + 2, _barEndDirection, _degStart, _degStart + 180);
    }






}