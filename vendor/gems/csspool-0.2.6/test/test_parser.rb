require File.dirname(__FILE__) + "/helper"

class ParserTest < Test::Unit::TestCase
  def setup
    @sac = CSS::SAC::Parser.new()
  end

  def teardown
    flexmock_verify
    flexmock_close
  end

  def test_parse_rule
    class << @sac.document_handler
      attr_accessor :selector
      alias :start_selector :selector=
    end
    @sac.parse('h1 > div { }')

    expected_rule = @sac.document_handler.selector
    assert expected_rule

    rule = @sac.parse_rule('h1 > div')
    assert rule
    assert_equal 1, rule.length
    assert_equal expected_rule, rule
  end

  def test_page
    flexmock(@sac.document_handler).
      should_receive(:start_page).ordered.
        with('foo', 'print').once
    flexmock(@sac.document_handler).
      should_receive(:property).ordered.with('color', on { |list|
      list.length == 1 && list.first.dimension_unit_text.nil? &&
        list.first.lexical_unit_type == :SAC_IDENT &&
        list.first.string_value == "black" &&
        list.first.integer_value.nil?
    }, false).once
    flexmock(@sac.document_handler).
      should_receive(:end_page).ordered.
        with('foo', 'print').once
    @sac.parse('@page foo:print { color: black }')
  end

  def test_empty
    assert_nothing_raised {
      @sac.parse('')
    }
  end

  def test_at_import
    flexmock(@sac.document_handler).
      should_receive(:import_style).ordered.
        with('"subs.css"', []).once
    @sac.parse('@import "subs.css";')
    flexmock_verify
  end

  def test_at_import_many_media
    flexmock(@sac.document_handler).
      should_receive(:import_style).ordered.
        with('"subs.css"', ['paper', 'boobs']).once
    @sac.parse('@import "subs.css" paper, boobs;')
    flexmock_verify
  end

  def test_multi_import
    flexmock(@sac.document_handler).
      should_receive(:import_style).ordered.
        with('"subs.css"', []).once
    flexmock(@sac.document_handler).
      should_receive(:import_style).ordered.
        with('"subs1.css"', []).once
    @sac.parse('@import "subs.css"; @import "subs1.css";')
    flexmock_verify
  end

  def test_media
    flexmock(@sac.document_handler).
      should_receive(:start_media).ordered.
        with(['print', 'tv']).once
    flexmock(@sac.document_handler).
      should_receive(:start_selector).ordered.once
    flexmock(@sac.document_handler).
      should_receive(:property).ordered.with('color', on { |list|
      list.length == 1 && list.first.dimension_unit_text.nil? &&
        list.first.lexical_unit_type == :SAC_IDENT &&
        list.first.string_value == "black" &&
        list.first.integer_value.nil?
    }, false).once
    flexmock(@sac.document_handler).
      should_receive(:end_selector).ordered.once
    flexmock(@sac.document_handler).
      should_receive(:end_media).ordered.
        with(['print', 'tv']).once
    @sac.parse('@media print, tv { h1 { color: black } }')
  end

  def test_media_single
    flexmock(@sac.document_handler).
      should_receive(:start_media).ordered.
        with(['print']).once
    flexmock(@sac.document_handler).
      should_receive(:end_media).ordered.
        with(['print']).once
    @sac.parse('@media print { h1 { color: black } }')
  end

  def test_comment
    flexmock(@sac.document_handler).
      should_receive(:comment).ordered.
      with("/* sup bro */").once
    @sac.parse('/* sup bro */')
  end

  def test_weird
    @sac.parse('#topnav legend  { display: none; }')
  end

  def test_ignorable_at_rule
    flexmock(@sac.document_handler).
      should_receive(:start_document).ordered.once
    flexmock(@sac.document_handler).
      should_receive(:ignorable_at_rule).ordered.
      with("blah").once
    flexmock(@sac.document_handler).
      should_receive(:end_document).ordered.once
    @sac.parse('@blah "style.css";')
  end

  def test_selector
    flexmock(@sac.document_handler).
      should_receive(:start_document).ordered.once
    flexmock(@sac.document_handler).
      should_receive(:start_selector).ordered.once
    flexmock(@sac.document_handler).
      should_receive(:property).ordered.with('color', on { |list|
      list.length == 1 && list.first.dimension_unit_text.nil? &&
        list.first.lexical_unit_type == :SAC_IDENT &&
        list.first.string_value == "black" &&
        list.first.integer_value.nil?
    }, false).once
    flexmock(@sac.document_handler).
      should_receive(:end_selector).ordered.once
    flexmock(@sac.document_handler).
      should_receive(:end_document).ordered.once

    @sac.parse('div h1 { color: black; }')
    flexmock_verify
  end

  def test_properties
    flexmock(@sac.document_handler).
      should_receive(:property).with('color', on { |list|
      list.length == 1 && list.first.dimension_unit_text.nil? &&
        list.first.lexical_unit_type == :SAC_IDENT &&
        list.first.string_value == "black" &&
        list.first.integer_value.nil?
    }, false).once
    @sac.parse('div h1 { color: black; }')
    flexmock_verify

    flexmock(@sac.document_handler).
      should_receive(:property).never
    @sac.parse('div h1 { }')
    flexmock_verify
  end

  def test_properties_unary_op
    flexmock(@sac.document_handler).
      should_receive(:property).with('border-spacing', on { |list|
      list.length == 1 && list.first.dimension_unit_text == 'em' &&
        list.first.lexical_unit_type == :SAC_EM &&
        list.first.integer_value == -10
    }, false).once
    @sac.parse('div h1 { border-spacing: -10em; }')
    @sac.parse('div h1 { border: dashed black dotted; }')
    flexmock_verify
  end

  def test_properties_function
    flexmock(@sac.document_handler).
      should_receive(:property).with('clip', on { |list|
      list.length == 1 && list.first.dimension_unit_text.nil? &&
        list.first.lexical_unit_type == :SAC_RECT_FUNCTION &&
        list.first.string_value == "rect(1in, 1in, 1in, 2in)" &&
        list.first.parameters.length == 4 &&
        list.first.parameters.map { |x| x.to_s } == %w{ 1in 1in 1in 2in } &&
        list.first.integer_value.nil?
    }, false).once
    @sac.parse('div h1 { clip: rect(1in, 1in, 1in, 2in); }')
    flexmock_verify
  end

  def test_important_properties
    flexmock(@sac.document_handler).
      should_receive(:property).with('color', on { |list|
      list.length == 1 && list.first.dimension_unit_text.nil? &&
        list.first.lexical_unit_type == :SAC_IDENT &&
        list.first.string_value == "black" &&
        list.first.integer_value.nil?
    }, true).once
    @sac.parse('h1 { color: black !important; }')
    flexmock_verify
  end

  def test_pseudo_function
    flexmock(@sac.document_handler).
      should_receive(:start_selector).ordered.once
    flexmock(@sac.document_handler).
      should_receive(:property).with('color', on { |list|
      list.length == 1 && list.first.dimension_unit_text.nil? &&
        list.first.lexical_unit_type == :SAC_IDENT &&
        list.first.string_value == "black" &&
        list.first.integer_value.nil?
    }, true).ordered.once
    flexmock(@sac.document_handler).
      should_receive(:end_selector).ordered.once
    @sac.parse('h1:nth(1) { color: black !important; }')
    flexmock_verify
  end

  def test_pseudo_class
    flexmock(@sac.document_handler).
      should_receive(:start_selector).ordered.once
    flexmock(@sac.document_handler).
      should_receive(:property).with('color', on { |list|
      list.length == 1 && list.first.dimension_unit_text.nil? &&
        list.first.lexical_unit_type == :SAC_IDENT &&
        list.first.string_value == "black" &&
        list.first.integer_value.nil?
    }, true).ordered.once
    flexmock(@sac.document_handler).
      should_receive(:end_selector).ordered.once
    @sac.parse('a:hover { color: black !important; }')
    flexmock_verify
  end

  def test_pseudo_class_to_css
    class << @sac.document_handler
      attr_accessor :selectors
      alias :start_selector :selectors=
    end
    @sac.parse('a:hover { color: black !important; }')
    assert_equal 'a:hover', @sac.document_handler.selectors.first.to_css
  end

  def test_pseudo_function_to_css
    class << @sac.document_handler
      attr_accessor :selectors
      alias :start_selector :selectors=
    end
    @sac.parse('a:nth(3) { color: black !important; }')
    assert_equal 'a:nth(3)', @sac.document_handler.selectors.first.to_css
  end
end
