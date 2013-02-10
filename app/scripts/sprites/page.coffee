define [
    'sprite'
    'sprites/tile'
    'timer'
], (Sprite, Tile, Timer) ->
    class Page extends Sprite
        constructor: (pageNumber, words) ->
            super "page#{ pageNumber }", 0, 0
            @tiles = []
            @canClick = true
            @currentTile = false
            for word in words
                for i in [0..1]
                    @tiles.push new Tile word
            for i in [@tiles.length...20]
                @tiles.push new Tile '[pic]'

            @_shuffleTiles()
            padding = 22
            cols = 4
            rows = 5
            bufferX = (@width - (padding * (cols-1) + @tiles[0].width * cols)) / 2
            bufferY = (@height - (padding * (rows-1) + @tiles[0].height * rows)) / 2
            for y in [0...rows]
                for x in [0...cols]
                    index = x + y * cols
                    @tiles[index].x = bufferX + x * (@tiles[index].width + padding)
                    @tiles[index].y = bufferY + y * (@tiles[index].height + padding)


        draw: (batch) ->
            for tile in @tiles
                if tile.alive
                    tile.draw batch
            return

        update: (delta, mouse) ->
            if @canClick and not @hasClicked and mouse.leftButton
                @canClick = false
                @hasClicked = true
                for tile in @tiles
                    if tile.contains mouse.x, mouse.y
                        tile.flip()
                        if @currentTile
                            otherTile = @currentTile
                            if @currentTile.word == tile.word
                                Timer.in 1500, =>
                                    otherTile.alive = false
                                    tile.alive = false
                                    @canClick = true
                            else
                                Timer.in 1500, =>
                                    otherTile.flip()
                                    tile.flip()
                                    @canClick = true
                            @currentTile = false
                        else
                            @currentTile = tile
                            @canClick = true
                        break

            if not mouse.leftButton
                @hasClicked = false

        _shuffleTiles: ->
            i = @tiles.length

            while --i
                j = Math.floor Math.random() * (i + 1)
                [@tiles[i], @tiles[j]] = [@tiles[j], @tiles[i]]
