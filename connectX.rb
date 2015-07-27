require 'tk'

class ConnectX

   @root = TkRoot.new

   @gridArray = Array.new()
   @gridValueArray = Array.new()

   @victory = false

   @turn = 1


   #initialize
   #Class init
   #Inputs: number of columns (c), rows(r) and length of the line (l)
   #return: void
   def initialize(c, r, l)

      @root = TkRoot.new do  
         title "Hello World"  
         # the min size of window  
         minsize(1024,660)  
      end  

      @root.title = "Window"

      rowsTextBox = TkEntry.new(@root)
      columnsTextBox = TkEntry.new(@root)
      $maxLineTextBox = TkEntry.new(@root)


      #UI Elements setup
      numberOfRows = TkVariable.new
      numberOfcolumns = TkVariable.new
      maxLines = TkVariable.new
      rowsTextBox.textvariable = numberOfRows
      columnsTextBox.textvariable = numberOfcolumns
      $maxLineTextBox.textvariable = maxLines
      numberOfcolumns.value = c
      numberOfRows.value = r
      $maxLineTextBox.value = l

      #Texboxes for game setup including the number of columns, rows and the length of the line in order to win the game
      columnsTextBox.place('height' => 25,
                  'width'  => 25,
                  'x'      => 125,
                  'y'      => 50)

      rowsTextBox.place('height' => 25,
                  'width'  => 25,
                  'x'      => 175,
                  'y'      => 50)

      $maxLineTextBox.place('height' => 25,
                  'width'  => 25,
                  'x'      => 225,
                  'y'      => 50)


      
      #Labels for current turn and the corresponfind textboxes
      $turnLabel = TkLabel.new(@root) 
                  $turnLabel.text = "Green"
                  $turnLabel.place('height' => 30, 'width' => 100, 'x' => 20, 'y' => 50)
                  $turnLabel.foreground = "green"

      $turnTitleLabel = TkLabel.new(@root) 
                  $turnTitleLabel.text = "Turn"
                  $turnTitleLabel.place('height' => 30, 'width' => 100, 'x' => 20, 'y' => 20)

      $columnsTitleLabel = TkLabel.new(@root) 
                  $columnsTitleLabel.text = "Columns"
                  $columnsTitleLabel.place('height' => 30, 'width' => 75, 'x' => 100, 'y' => 20)

      $rowsTitleLabel = TkLabel.new(@root) 
                  $rowsTitleLabel.text = "Rows"
                  $rowsTitleLabel.place('height' => 30, 'width' => 50, 'x' => 170, 'y' => 20)

      $maxLineTitleLabel = TkLabel.new(@root) 
                  $maxLineTitleLabel.text = "Max. Lines"
                  $maxLineTitleLabel.place('height' => 30, 'width' => 75, 'x' => 215, 'y' => 20)

      #Start game button setup
      btn_OK = TkButton.new(@root) do
        text "START"
        borderwidth 0
        underline 0
        state "normal"
        cursor "watch"
        font TkFont.new('times 20 bold')
        foreground  "red"
        activebackground "blue"
        relief      "groove"
        command (proc {ConnectX.startGame(numberOfcolumns.value.to_i,numberOfRows.value.to_i)})
        place('height' => 25,'width' => 150,'x' => 300,'y'=> 50)
      end

   end

   #Victory
   #Method called when someone wins, it informs the winner and ends the game
   #Inputs: none
   #return: void
   def ConnectX.victory

      #Victory Label Setup. This label informs the users who won the game
      $victoryLabel = TkLabel.new(@root) 
      if @turn == 1
         $victoryLabel.text = "BLUE VICTORY!!!!"
         $victoryLabel.foreground = "blue"
      else 
         $victoryLabel.text = "GREEN VICTORY!!!!"
         $victoryLabel.foreground = "green"
      end
      $victoryLabel.place('height' => 200, 'width' => 1024, 'x' => 0, 'y' => 0)

      #Exit Button. This button ends the game
      btn_Reset = TkButton.new(@root) do
        text "EXIT"
        borderwidth 0
        underline 0
        state "normal"
        cursor "watch"
        font TkFont.new('times 20 bold')
        foreground  "red"
        activebackground "blue"
        relief      "groove"
        command (proc {ConnectX.quit})
        place('height' => 25,'width' => 150,'x' => 435,'y'=> 150)
      end

   end

   #CheckVertical
   #Method checks if the vertical line containing the last play is a winner
   #Inputs: The column of the current play (column) and the number of rows (rows)
   #return: @victory boolean, true if there is a winner
   def ConnectX.checkVertical(column,rows)

      valuesArray = Array.new()

      #Create array of the values in the vertical column
      for i in 1..rows
         #print column,",",i,"\n"
         valuesArray.push(@gridValueArray[column][i])
      end

      #Calls longestSequence to check if there is enough chips to take a win,if so then wins.
      if longestSequence(valuesArray) == $maxLineTextBox.value.to_i
         @victory = true
      end

      return @victory

   end

   #CheckHorizontal
   #Method checks if the horizontal line containing the last play is a winner
   #Inputs: The row of the current play (row) and the number of columns (columns)
   #return: @victory boolean, true if there is a winner
   def ConnectX.checkHorizontal(row,columns)

      #print $maxLineTextBox.value 

      valuesArray = Array.new()

      #Create array of the values in the horizontal column
      for i in 0..columns-1
         #print i,",",row-1,"\n"
         valuesArray.push(@gridValueArray[i][row])
      end

      #Calls longestSequence to check if there is enough chips to take a win,if so then wins.
      if longestSequence(valuesArray) == $maxLineTextBox.value.to_i
         @victory = true
      end

      return @victory

   end

   #checkNegativeDiagonal
   #Method checks if the vertical line of negative m containing the last play is a winner
   #Inputs: The column of the current play (column), the row of the current play (row), the number of columns (columns), the number of rows (rows)
   #return: @victory boolean, true if there is a winner
   def ConnectX.checkNegativeDiagonal(column,row,columns,rows)
      
      valuesArray = Array.new()
      row -= 1

      #Identifies the fist coordinate of the negative diagonal containing the current play
      while column > 0 do
         column -= 1
         row -= 1
      end 

      if row < 0
         diff = row
         row = 0
         column = diff.abs 
      end

      currentx = column
      currenty = row

      image = TkPhotoImage.new
      image.file = "red_circle.gif"

      touched = true

      #Create array of the values in the negative diagonal containing the current play
      while touched do

         if currentx < columns and currenty < rows
            #@gridArray[currentx][currenty + 1].image = image 
            valuesArray.insert(-1,@gridValueArray[currentx][currenty + 1])
         else
            touched = false
         end

         currentx +=  1
         currenty +=  1

      end 

      #Calls longestSequence to check if there is enough chips to take a win,if so then wins.
      if longestSequence(valuesArray) == $maxLineTextBox.value.to_i
         @victory = true
      end

      return @victory

   end

   #checkPositiveDiagonal
   #Method checks if the vertical line of positive m containing the last play is a winner
   #Inputs: The column of the current play (column), the row of the current play (row), the number of columns (columns), the number of rows (rows)
   #return: @victory boolean, true if there is a winner
   def ConnectX.checkPositiveDiagonal(column,row,columns,rows)

         valuesArray = Array.new()
         row -= 1

         #Identifies the fist coordinate of the positive diagonal containing the current play
         while column < columns - 1 do
            column += 1
            row -= 1
         end 

         if row < 0
            diff = row
            row = 0
            column = columns - 1 + diff
         end
         
         #print column," ", row,"\n"

         currentx = column
         currenty = row

         image = TkPhotoImage.new
         image.file = "red_circle.gif"

         touched = true

         #Create array of the values in the positive diagonal containing the current play
         while touched do

            if currentx >= 0 and currenty < rows
               #@gridArray[currentx][currenty + 1].image = image
               valuesArray.insert(-1,@gridValueArray[currentx][currenty + 1])
            else
               touched = false
            end

            currentx -=  1
            currenty +=  1

         end 

         
         #Calls longestSequence to check if there is enough chips to take a win,if so then wins.
         if longestSequence(valuesArray) == $maxLineTextBox.value.to_i
            @victory = true
         end

         return @victory

   end

   #StartGame
   #Method starts a game
   #Inputs: Number of columns (columns) and rows (rows) in the game grid
   #Return: void
   def ConnectX.startGame(columns,rows) 
      ConnectX.generateGrid(columns,rows)
   end

   #UpdateGrid
   #Updates the Grid with the latest play
   #Inputs: Number of columns (columns) and rows (rows) in the game grid
   #Return: void
   def ConnectX.updateGrid(columns,rows)

      image = TkPhotoImage.new

      #Updates the current player turn, green or blue
      if @turn == 1
         image.file = "green_circle.gif"
         $turnLabel.text = "Blue"
         $turnLabel.foreground = "blue"
      elsif @turn == 2
         image.file = "blue_circle.gif"
         $turnLabel.text = "Green"
         $turnLabel.foreground = "green"
      end
         
      stop = true
      counter = 0

      #Updates the grid with the current play
      while stop

         if @gridValueArray[columns][rows-counter] == 0
            @gridArray[columns][rows-counter].image = image
            @gridValueArray[columns][rows-counter] = @turn
            stop = false 
         else
            counter = counter + 1
         end

         if rows - counter < 1
            break
         end
         
      end

      #switch turns
      if @turn == 1
         @turn = 2
      elsif @turn == 2
         @turn = 1
      end

      #Calls checkPositiveDiagonal and declares a win if it returns true
      if checkPositiveDiagonal(columns,rows-counter,@gridValueArray.length,@gridValueArray[0].length-1)
         print "Victory!!!"
         victory
      end

      #Calls checkNegativeDiagonal and declares a win if it returns true
      if checkNegativeDiagonal(columns,rows-counter,@gridValueArray.length,@gridValueArray[0].length-1)
         print "Victory!!!"
         victory
      end

      #Calls checkVertical and declares a win if it returns true
      if checkVertical(columns,@gridValueArray[0].length-1)
         print "Victory!!!"
         victory
      end

      #Calls checkHorizintal and declares a win if it returns true
      if checkHorizontal(rows-counter,@gridValueArray.length)
         print "Victory!!!"
         victory
      end
      
   end

   #GenerateGrid
   #Generate the Grid when the game starts
   #Inputs: Number of columns (columns) and rows (rows) in the game grid
   #Return: void
   def ConnectX.generateGrid(columns,rows)
      
      #Creates the grid using tk and add buttons on the top for the users to make their plays
      for i in 0..columns-1
         @gridArray.insert(-1,Array.new)
         @gridValueArray.insert(-1,Array.new)
         #Creates circles for all the plays...
         for j in 0..rows
            if j == 0
               image = TkPhotoImage.new
               image.file = "red_circle.gif"
               btn_OK = TkButton.new(@root) do
                  text "OK"
                  borderwidth 0
                  image image
                  underline 0
                  state "normal"
                  cursor "watch"
                  font TkFont.new('times 20 bold')
                  foreground  "red"
                  activebackground "blue"
                  relief      "groove"
                  new_i = i
                  command (proc {ConnectX.updateGrid(new_i,rows)})
                  pack("side" => "left",  "padx"=> "1", "pady"=> "1")
                  place('height' => image.height, 'width' => image.width, 'x' => 50 + 50 * i, 'y' => 100 + 50 * j) 
               end
               @gridArray[i].insert(-1,btn_OK)
               @gridValueArray[i].insert(-1,1)
            else
               #...except on the first line that it creates buttons for the plays
               image = TkPhotoImage.new
               image.file = "empty_circle.gif"
               label = TkLabel.new(@root) 
               label.image = image
               label.place('height' => image.height,'width' => image.width,'x' => 50 + 50 * i, 'y' => 100 + 50 * j)
               @gridArray[i].insert(-1,label)
               @gridValueArray[i].insert(-1,0)
            end  
         end
      end

   end

   #LongestSequence
   #Receives an array and returns the length of the longest consecutive line of values
   #Inputs: array (line)
   #Return: integer (longest)
   def ConnectX.longestSequence(line)
       
       longest = 0
       length = 1

       #print line

       for i in 0..line.length - 1 
         
         if line[i] == line[i-1] and line[i] != 0
               length += 1
           else 
               length = 1
         end
         
         if length > longest 
            longest = length
         end

       end
       
       return longest;

   end

   #Quit
   #Ends the game
   #Inputs: None
   #Return: void
   def ConnectX.quit

      Kernel.exit

   end

end

game = ConnectX.new(7,6,4)

Tk.mainloop
