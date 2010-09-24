class GenericSpreadsheet
  
  # write the current spreadsheet to csv_string
  def to_csv(filename=nil,sheet=nil)
    csv_string = write_csv_content(STDOUT,sheet)
  end
  
  def write_csv_content(file=nil,sheet=nil)
   csv_string = ""
    if first_row(sheet) # sheet is not empty
      1.upto(last_row(sheet)) do |row|
        1.upto(last_column(sheet)) do |col|
          csv_string += "," if col > 1
          onecell = cell(row,col,sheet)
          onecelltype = celltype(row,col,sheet)
          csv_string += one_cell_output(onecelltype,onecell,empty?(row,col,sheet))
        end
        csv_string += "\n"
      end # sheet not empty
    end
    csv_string
  end  
end