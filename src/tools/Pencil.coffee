{ToolWithStroke} = require './base'
{createShape} = require '../core/shapes'
util = require '../core/util'

module.exports = class Pencil extends ToolWithStroke

  name: 'Pencil'
  iconName: 'pencil'

  pendingPoints: []
  raf: 0

  begin: (x, y, lc) ->
    @raf = null
    @pendingPoints = []
    @color = lc.getColor('primary')
    @currentShape = @makeShape()
    @currentShape.addPoint(@makePoint(x, y, lc))

  continue: (x, y, lc) ->
    @pendingPoints.push({x,y})
    if !@raf
      @raf = util.requestAnimationFrame () =>
        if _this.currentShape # May not exist. Pointer left canvas bounds or mouseup before AF fires?
          @pendingPoints.forEach (point, i) ->
            _this.currentShape.addPoint(_this.makePoint(point.x, point.y, lc))
            lc.drawShapeInProgress(_this.currentShape)
        @raf = null
        @pendingPoints = []

  end: (x, y, lc) ->
    lc.saveShape(@currentShape)
    @currentShape = undefined

  makePoint: (x, y, lc) ->
    createShape('Point', {x, y, size: @strokeWidth, @color})
  makeShape: -> createShape('LinePath')
