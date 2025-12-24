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
        dc.setColor((backgroundColor == Graphics.COLOR_BLACK) ? Graphics.COLOR_WHITE : Graphics.COLOR_BLACK, Graphics.COLOR_TRANSPARENT);
        var _borderwidth = 1;
        dc.setPenWidth(_borderwidth);
        dc.drawRectangle(x, y, width, height);
        var _clampedPercent = percentComp > 1.0 ? 1.0 : percentComp;
        _clampedPercent = percentComp < 0.0 ? 0.0 : percentComp;
        var _fillWidth = (width - _borderwidth * 2) * _clampedPercent;
        dc.setColor(color, Graphics.COLOR_BLACK);
        var _barStart = x;
        if (filling == false) { _barStart = x + _fillWidth; _fillWidth = width - _fillWidth - 2 * _borderwidth;}
        dc.fillRectangle(_barStart + _borderwidth, y + _borderwidth, _fillWidth, height -  2 * _borderwidth);
        dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_TRANSPARENT);
        var _percentNumber = _clampedPercent * 100;
        var _percentDisp = _percentNumber.format("%.1f") + "%";
        if (showPercent) {
            if (_clampedPercent <= 0.66) {dc.drawText(x + _borderwidth + (width - _borderwidth * 2) * _clampedPercent , y - _borderwidth, font, _percentDisp, Graphics.TEXT_JUSTIFY_LEFT);} 
            else {dc.drawText(x + (width - _borderwidth * 2) * _clampedPercent + _borderwidth, y - _borderwidth, font, _percentDisp, Graphics.TEXT_JUSTIFY_RIGHT);}
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
        dc.setColor((backgroundColor == Graphics.COLOR_BLACK) ? Graphics.COLOR_WHITE : Graphics.COLOR_BLACK, Graphics.COLOR_TRANSPARENT);
        var _borderwidth = 1;
        dc.setPenWidth(_borderwidth);
        dc.drawRoundedRectangle(x, y, width, height, height * 0.5);
        var _clampedPercent = percentComp > 1.0 ? 1.0 : percentComp;
        _clampedPercent = percentComp < 0.0 ? 0.0 : percentComp;
        var _fillWidth = (width - _borderwidth * 2) * _clampedPercent;
        dc.setColor(color, Graphics.COLOR_BLACK);
        var _barStart = x;
        if (filling == false) { _barStart = x + _fillWidth; _fillWidth = width - _fillWidth - 2 * _borderwidth;}
        dc.fillRoundedRectangle(_barStart + _borderwidth, y + _borderwidth, _fillWidth, height -  2 * _borderwidth, 0.5 * height - _borderwidth);
        dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_TRANSPARENT);
        var _percentNumber = _clampedPercent * 100;
        var _percentDisp = _percentNumber.format("%.1f") + "%";
        if (showPercent) {
            if (_clampedPercent <= 0.66) {dc.drawText(x + _borderwidth + (width - _borderwidth * 2) * _clampedPercent , y - _borderwidth, font, _percentDisp, Graphics.TEXT_JUSTIFY_LEFT);} 
            else {dc.drawText(x + (width - _borderwidth * 2) * _clampedPercent + _borderwidth, y - _borderwidth, font, _percentDisp, Graphics.TEXT_JUSTIFY_RIGHT);}
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
        var _borderwidth = 1;
        var _clampedPercent = percentComp > 1.0 ? 1.0 : percentComp;
        if (direction.equals(Graphics.ARC_COUNTER_CLOCKWISE) && arcStart > arcEnd) {arcEnd+=360;}
        if (direction.equals(Graphics.ARC_CLOCKWISE) && arcStart < arcEnd) {arcStart+=360;}
        var _arclength = arcEnd - arcStart;        


        var _textdirection = Graphics.RADIAL_TEXT_DIRECTION_CLOCKWISE;              
        if (direction.equals(Graphics.ARC_COUNTER_CLOCKWISE)) { _textdirection = Graphics.RADIAL_TEXT_DIRECTION_COUNTER_CLOCKWISE;}
        var _textradius = r - padding - _borderwidth - 1;
        if (_textdirection.equals(Graphics.RADIAL_TEXT_DIRECTION_CLOCKWISE)) {_textradius = r - padding + _borderwidth - height + 1;} 

        var _barStart = arcStart;
        var _barEnd = Math.floor(arcStart + _arclength * _clampedPercent);
        if (!filling) {_barStart = _barEnd; _barEnd = arcEnd;}

        dc.setPenWidth(height - _borderwidth * 2);
        dc.setColor(color, Graphics.COLOR_TRANSPARENT);
        dc.drawArc(
            xCenter,
            yCenter,
            r - _borderwidth - height * 0.5 - padding,
            direction,
            _barStart,
            _barEnd
        );

        var _percentNumber = _clampedPercent * 100;
        var _percentDisp = _percentNumber.format("%.1f") + "%";
        dc.setColor((backgroundColor == Graphics.COLOR_BLACK) ? Graphics.COLOR_WHITE : Graphics.COLOR_BLACK, Graphics.COLOR_TRANSPARENT);
        dc.setPenWidth(_borderwidth);
        if (_clampedPercent <= 0.66) {
            dc.drawRadialText(
                xCenter,
                yCenter,
                font,
                _percentDisp,
                Graphics.TEXT_JUSTIFY_LEFT,
                arcStart + _arclength * _clampedPercent,
                _textradius,
                _textdirection
            );
        } else {
            dc.drawRadialText(
                xCenter,
                yCenter,
                font,
                _percentDisp,
                Graphics.TEXT_JUSTIFY_RIGHT,
                arcStart + _arclength * _clampedPercent,
                _textradius,
                _textdirection
            );
        }

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
        var _borderwidth = 1;
        var _clampedPercent = percentComp > 1.0 ? 1.0 : percentComp;
        if (direction.equals(Graphics.ARC_COUNTER_CLOCKWISE) && arcStart > arcEnd) {arcEnd+=360;}
        if (direction.equals(Graphics.ARC_CLOCKWISE) && arcStart < arcEnd) {arcStart+=360;}
        var _arclength = arcEnd - arcStart;        


        var _textdirection = Graphics.RADIAL_TEXT_DIRECTION_CLOCKWISE;              
        if (direction.equals(Graphics.ARC_COUNTER_CLOCKWISE)) { _textdirection = Graphics.RADIAL_TEXT_DIRECTION_COUNTER_CLOCKWISE;}
        var _textradius = r - padding - _borderwidth - 1;
        if (_textdirection.equals(Graphics.RADIAL_TEXT_DIRECTION_CLOCKWISE)) {_textradius = r - padding + _borderwidth - height + 1;} 

        var _barStart = arcStart;
        var _barEnd = Math.floor(arcStart + _arclength * _clampedPercent);
        if (!filling) {_barStart = _barEnd; _barEnd = arcEnd;}

        dc.setPenWidth(height - _borderwidth * 2);
        dc.setColor(color, Graphics.COLOR_TRANSPARENT);
        dc.drawArc(
            xCenter,
            yCenter,
            r - _borderwidth - height * 0.5 - padding,
            direction,
            _barStart,
            _barEnd
        );

        var _percentNumber = _clampedPercent * 100;
        var _percentDisp = _percentNumber.format("%.1f") + "%";
        dc.setColor((backgroundColor == Graphics.COLOR_BLACK) ? Graphics.COLOR_WHITE : Graphics.COLOR_BLACK, Graphics.COLOR_TRANSPARENT);
        dc.setPenWidth(_borderwidth);
        if (_clampedPercent <= 0.66) {
            dc.drawRadialText(
                xCenter,
                yCenter,
                font,
                _percentDisp,
                Graphics.TEXT_JUSTIFY_LEFT,
                arcStart + _arclength * _clampedPercent,
                _textradius,
                _textdirection
            );
        } else {
            dc.drawRadialText(
                xCenter,
                yCenter,
                font,
                _percentDisp,
                Graphics.TEXT_JUSTIFY_RIGHT,
                arcStart + _arclength * _clampedPercent,
                _textradius,
                _textdirection
            );
        }

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
        
        var _add = 1;
        if (direction.equals(Graphics.ARC_CLOCKWISE)) {_add = -1;}

        var _arcAdjust = Math.asin((height - 2 * _borderwidth) / (r - padding - _borderwidth - height * 0.5));
        var x1 = xCenter + Math.cos(arcStart * Math.PI / 180 + _add * _arcAdjust * 0.5) * (r - padding - height * 0.5) ;
        var y1 = yCenter - Math.sin(arcStart * Math.PI / 180 + _add * _arcAdjust * 0.5) * (r - padding - height * 0.5) ;
        var _deg = Math.atan((x1 - xCenter)/(y1 - yCenter)) + 0.5 * Math.PI;
        _deg = _deg / 2 / Math.PI * 360;
        var _barEndDirection = direction;
        var _addDeg = 1;
        if (arcStart < 180 && direction.equals(Graphics.ARC_CLOCKWISE)) {_barEndDirection = Graphics.ARC_COUNTER_CLOCKWISE; _addDeg = -1;} else if(arcStart < 180) {_barEndDirection = Graphics.ARC_CLOCKWISE; _addDeg = 1;}
        dc.drawArc(x1, y1, height * 0.5, _barEndDirection, _deg, _deg + _addDeg * 180);
        dc.setColor(backgroundColor, Graphics.COLOR_TRANSPARENT); 
        var _thick = (Math.sqrt(2)*height - height) / 2;
        dc.setPenWidth(_thick+2);
        dc.drawArc(x1, y1, height * 0.5 + _thick * 0.5 + 2, _barEndDirection, _deg, _deg + _addDeg * 180);        


        dc.setColor((backgroundColor == Graphics.COLOR_BLACK) ? Graphics.COLOR_WHITE : Graphics.COLOR_BLACK, Graphics.COLOR_TRANSPARENT);
        dc.setPenWidth(_borderwidth);
        _arcAdjust = Math.asin((height - 2 * _borderwidth) / (r - padding -_borderwidth - height * 0.5));
        x1 = xCenter + Math.cos(arcEnd * Math.PI / 180 - _add * _arcAdjust * 0.5) * (r - padding - height * 0.5) ;
        y1 = yCenter - Math.sin(arcEnd * Math.PI / 180 - _add * _arcAdjust * 0.5) * (r - padding - height * 0.5) ;
        _deg = Math.atan((x1 - xCenter)/(y1 - yCenter)) + 0.5 * Math.PI;
        _deg = _deg / 2 / Math.PI * 360;
        _barEndDirection = direction;
        _addDeg = 1;
        if (arcEnd < 180 && direction.equals(Graphics.ARC_CLOCKWISE)) {_barEndDirection = Graphics.ARC_COUNTER_CLOCKWISE; _addDeg = -1;} else if(arcEnd < 180) {_barEndDirection = Graphics.ARC_CLOCKWISE; _addDeg = 1;}
        dc.drawArc(x1, y1, height * 0.5, _barEndDirection, _deg + _addDeg * 180, _deg);
        dc.setColor(backgroundColor, Graphics.COLOR_TRANSPARENT);
        dc.setPenWidth(_thick+2);
        dc.drawArc(x1, y1, height * 0.5 + _thick * 0.5 + 2, _barEndDirection, _deg + _addDeg * 180, _deg);
    }






}