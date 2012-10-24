require File.dirname(__FILE__) + '/../../test_helper'

#require 'test_helper'

class DiffHelperTest < ActionView::TestCase

  def  setup
    @inputFileName = Dir.pwd + "/test/unit/helpers/diff_helper_inputFile"
    @targetFileName =    Dir.pwd + "/test/unit/helpers/diff_helper_targetFile"
    @processor = DiffHelper::Processor.new @inputFileName, @targetFileName
  end

  def test_input_file_should_be_read_from_start
    inputFile = DiffHelper::InputFile.new
    assert inputFile.pointer == 0
  end


  def test_advancing_should_change_the_object
    inputFile = DiffHelper::InputFile.new
    # advance the pointer by 1
    inputFile.advance_pointer!
    assert inputFile.pointer == 1
    #advance the pointer by 2
    inputFile.advance_pointer!
    assert inputFile.pointer == 2
  end

  def test_current_line_isReturned_correctly
    inputFile = DiffHelper::InputFile.new
    # add lines to the array
    inputFile.push "this is first line"
    inputFile.push "this is second line"

    # advance the pointer by 1
    inputFile.advance_pointer!
    # current line should be 1
    assert_equal "this is second line", inputFile.current_line
  end

  def test_find_current_line_in_other
    inputFile = DiffHelper::InputFile.new
    # add lines to the array
    inputFile.push "this is first line"
    inputFile.push "this is second line"
    # get to the second line
    inputFile.advance_pointer!

    other = DiffHelper::InputFile.new
    # add lines to the array
    other.push "this is second line"
    other.push "this is some dummy line"

    assert_equal 0, inputFile.find_current_line_in(other)

    #if line is not present then nil should be returned
    other.pop 2
    other.push "some dummy line"

    assert_equal nil, inputFile.find_current_line_in(other)
  end

  def test_line_is_added_to_output_file
    outFile = DiffHelper::OutputFile.new
    outFile.add_line "dummy_type", getInputFile()
    line = outFile[0]
    assert_equal "dummy_type", line.type
    assert "this is first line".eql? line
  end

  #all methods in Processor class of the module except
  # process! should be private. they are not testable
  # as they represent intermediate state of the processing
  # and exist solely as helpers.
  def test_handle_unchanged_lines_for_exact_match

    @processor.process!

    sourceOut = @processor.source_output
    assert_equal  :unchanged, sourceOut[1].type
    assert   sourceOut[0].eql? "this is the first line\n"
    assert_equal  :changed, sourceOut[0].type
  end

  def getInputFile
    inputFile = DiffHelper::InputFile.new
    inputFile.push "this is first line"
    inputFile.push "this is second line"
    inputFile.push "this is third line"
    return inputFile
  end


end
