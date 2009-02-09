class CSS::SAC::GeneratedPropertyParser

token ANGLE COLOR URI PERCENTAGE LENGTH EMS EXS STRING IDENT INTEGER COMMA
token TIME NUMBER FREQ HASH

rule
  property
    : azimuth
    | background_attachment
    | background_color
    | background_image
    | background_position
    | background_repeat
    | background
    | border_collapse
    | border_color
    | border_spacing
    | border_style
    | border_trbl
    | border_trbl_color
    | border_trbl_style
    | border_trbl_width
    | border_width
    | border
    | bottom
    | caption_side
    | clear
    | clip
    | color_lex
    | content
    | counter_increment_or_reset
    | cue_after_or_before
    | cue
    | cursor
    | direction
    | display
    | elevation
    | empty_cells
    | float
    | font_family
    | font_size
    | font_style
    | font_variant
    | font_weight
    | font
    | hlrt
    | letter_spacing
    | line_height
    | list_style_image
    | list_style_position
    | list_style_type
    | list_style
    | margin_rltb
    | margin
    | max_height_or_width
    | min_height_or_width
    | orphans
    | outline_color
    | outline_style
    | outline_width
    | outline
    | overflow
    | padding_trbl
    | padding
    | page_break_ab 
    | page_break_inside
    | pause_ab
    | pause
    | pitch_range
    | pitch
    | play_during
    | position
    | quotes
    | richness
    | speak_header
    | speak_numeral
    | speak_punctuation
    | speak
    | speech_rate
    | stress
    | table_layout
    | text_align
    | text_decoration
    | text_indent
    | text_transform
    | unicode_bidi
    | vertical_align
    | visibility
    | voice_family
    | volume
    | white_space
    | windows
    | width
    | word_spacing
    | z_index
    ;
  angle
    : ANGLE { result = CSS::SAC::Number.new(val.first) }
    | zero
    ;
  percentage
    : PERCENTAGE { result = CSS::SAC::Number.new(val.first) }
    | zero
    ;
  time
    : TIME { result = CSS::SAC::Number.new(val.first) }
    | zero
    ;
  number
    : NUMBER { result = CSS::SAC::Number.new(val.first) }
    ;
  integer
    : NUMBER { result = CSS::SAC::Number.new(val.first) }
    ;
  frequency
    : FREQ { result = CSS::SAC::Number.new(val.first) }
    | zero
    ;
  string
    : STRING { result = LexicalString.new(val.first) }
    ;
  uri
    : URI { result = LexicalURI.new(val.first) }
    ;
  length
    : length_values { result = CSS::SAC::Number.new(val.first) }
    | zero
    ;
  auto
    : 'auto' { result = LexicalIdent.new(val.first) }
    ;
  inherit
    : 'inherit' { result = LexicalIdent.new(val.first) }
    ;
  invert
    : 'invert' { result = LexicalIdent.new(val.first) }
    ;
  ident
    : IDENT { result = LexicalIdent.new(val.first) }
    ;
  none
    : 'none' { result = LexicalIdent.new(val.first) }
    ;
  normal
    : 'normal' { result = LexicalIdent.new(val.first) }
    ;
  transparent
    : 'transparent' { result = LexicalIdent.new(val.first) }
    ;
  length_values
    : LENGTH
    | EMS
    | EXS
    ;
  zero
    : '0' { result = CSS::SAC::Number.new('0') }
    ;
  color
    : COLOR
    | HASH { result = Color.new(val.first) }
    | color_names { result = LexicalIdent.new(val.first) }
    ;
  color_names
    : 'aqua'
    | 'black'
    | 'blue'
    | 'fuchsia'
    | 'gray'
    | 'green'
    | 'lime'
    | 'maroon'
    | 'navy'
    | 'olive'
    | 'orange'
    | 'purple'
    | 'red'
    | 'silver'
    | 'teal'
    | 'white'
    | 'yellow'
    ;
  azimuth
    : 'azimuth' ANGLE { result = CSS::SAC::Number.new(val[1]) }
    | 'azimuth' azimuth_side_and_behind {
        result = [val[1]].flatten.map { |x|
          LexicalIdent.new(x)
        }
      }
    | 'azimuth' 'leftwards' { result = LexicalIdent.new(val[1]) }
    | 'azimuth' 'rightwards' { result = LexicalIdent.new(val[1]) }
    | 'azimuth' inherit { result = val[1] }
    ;
  azimuth_side_and_behind
    : azimuth_side_values 'behind' { result = val }
    | 'behind' azimuth_side_values { result = val }
    | azimuth_side_values
    | 'behind'
    ;
  azimuth_side_values
    : 'left-side'
    | 'far-left'
    | 'left'
    | 'center-left'
    | 'center'
    | 'center-right'
    | 'right'
    | 'far-right'
    | 'right-side'
    ;
  background_attachment
    : 'background-attachment' background_attachment_values {
        result = val[1]
      }
    | 'background-attachment' inherit { result = val[1] }
    ;
  background_attachment_values
    : background_attachment_values_ident {
        result = LexicalIdent.new(val.first)
      }
    ;
  background_attachment_values_ident
    : 'scroll'
    | 'fixed'
    ;
  background_color
    : 'background-color' background_color_values { result = val[1] }
    | 'background-color' inherit { result = val[1] }
    ;
  background_color_values
    : color
    | transparent
    ;
  background_image
    : 'background-image' background_image_values { result = val[1] }
    | 'background-image' inherit { result = val[1] }
    ;
  background_image_values
    : uri
    | 'none' { result = LexicalIdent.new(val.first) }
    ;
  background_position
    : 'background-position' background_position_values {
        result = [val[1]].flatten.compact
      }
    | 'background-position' inherit { result = val[1] }
    ;
  background_position_values
    : pl_left_center_right optional_pl_top_center_bottom { result = val }
    | left_center_right top_center_bottom { result = val }
    | top_center_bottom left_center_right { result = val }
    | left_center_right
    | top_center_bottom
    ;
  pl_left_center_right
    : percentage
    | length
    | left_center_right
    ;
  left_center_right
    : left_center_right_values { result = LexicalIdent.new(val.first) }
    ;
  left_center_right_values
    : 'left'
    | 'center'
    | 'right'
    ;
  optional_pl_top_center_bottom
    : percentage
    | length
    | top_center_bottom
    |
    ;
  top_center_bottom
    : top_center_bottom_values { result = LexicalIdent.new(val.first) }
    ;
  top_center_bottom_values
    : 'top'
    | 'center'
    | 'bottom'
    ;
  background_repeat
    : 'background-repeat' background_repeat_values { result = val[1] }
    | 'background-repeat' inherit { result = val[1] }
    ;
  background_repeat_values
    : background_repeat_values_ident { result = LexicalIdent.new(val.first) }
    ;
  background_repeat_values_ident
    : 'repeat'
    | 'repeat-x'
    | 'repeat-y'
    | 'no-repeat'
    ;
  background
    : 'background' background_values { result = [val[1]].flatten.compact }
    | 'background' inherit { result = val[1] }
    ;
  background_values

  : background_color_values background_image_values background_repeat_values background_attachment_values background_position_values { result = val }

  | background_position_values background_attachment_values background_repeat_values background_image_values background_color_values { result = val }

  | background_color_values background_image_values background_repeat_values background_position_values background_attachment_values { result = val }

  | background_position_values background_attachment_values background_repeat_values background_color_values background_image_values { result = val }

  | background_color_values background_image_values background_attachment_values background_repeat_values background_position_values { result = val }

  | background_position_values background_attachment_values background_image_values background_repeat_values background_color_values { result = val }

  | background_color_values background_image_values background_attachment_values background_position_values background_repeat_values { result = val }

  | background_position_values background_attachment_values background_image_values background_color_values background_repeat_values { result = val }

  | background_color_values background_image_values background_position_values background_repeat_values background_attachment_values { result = val }

  | background_position_values background_attachment_values background_color_values background_repeat_values background_image_values { result = val }

  | background_color_values background_image_values background_position_values background_attachment_values background_repeat_values { result = val }

  | background_position_values background_attachment_values background_color_values background_image_values background_repeat_values { result = val }

  | background_color_values background_repeat_values background_image_values background_attachment_values background_position_values { result = val }

  | background_position_values background_repeat_values background_attachment_values background_image_values background_color_values { result = val }

  | background_color_values background_repeat_values background_image_values background_position_values background_attachment_values { result = val }

  | background_position_values background_repeat_values background_attachment_values background_color_values background_image_values { result = val }

  | background_color_values background_repeat_values background_attachment_values background_image_values background_position_values { result = val }

  | background_position_values background_repeat_values background_image_values background_attachment_values background_color_values { result = val }

  | background_color_values background_repeat_values background_attachment_values background_position_values background_image_values { result = val }

  | background_position_values background_repeat_values background_image_values background_color_values background_attachment_values { result = val }

  | background_color_values background_repeat_values background_position_values background_image_values background_attachment_values { result = val }

  | background_position_values background_repeat_values background_color_values background_attachment_values background_image_values { result = val }

  | background_color_values background_repeat_values background_position_values background_attachment_values background_image_values { result = val }

  | background_position_values background_repeat_values background_color_values background_image_values background_attachment_values { result = val }

  | background_color_values background_attachment_values background_image_values background_repeat_values background_position_values { result = val }

  | background_position_values background_image_values background_attachment_values background_repeat_values background_color_values { result = val }

  | background_color_values background_attachment_values background_image_values background_position_values background_repeat_values { result = val }

  | background_position_values background_image_values background_attachment_values background_color_values background_repeat_values { result = val }

  | background_color_values background_attachment_values background_repeat_values background_image_values background_position_values { result = val }

  | background_position_values background_image_values background_repeat_values background_attachment_values background_color_values { result = val }

  | background_color_values background_attachment_values background_repeat_values background_position_values background_image_values { result = val }

  | background_position_values background_image_values background_repeat_values background_color_values background_attachment_values { result = val }

  | background_color_values background_attachment_values background_position_values background_image_values background_repeat_values { result = val }

  | background_position_values background_image_values background_color_values background_attachment_values background_repeat_values { result = val }

  | background_color_values background_attachment_values background_position_values background_repeat_values background_image_values { result = val }

  | background_position_values background_image_values background_color_values background_repeat_values background_attachment_values { result = val }

  | background_color_values background_position_values background_image_values background_repeat_values background_attachment_values { result = val }

  | background_position_values background_color_values background_attachment_values background_repeat_values background_image_values { result = val }

  | background_color_values background_position_values background_image_values background_attachment_values background_repeat_values { result = val }

  | background_position_values background_color_values background_attachment_values background_image_values background_repeat_values { result = val }

  | background_color_values background_position_values background_repeat_values background_image_values background_attachment_values { result = val }

  | background_position_values background_color_values background_repeat_values background_attachment_values background_image_values { result = val }

  | background_color_values background_position_values background_repeat_values background_attachment_values background_image_values { result = val }

  | background_position_values background_color_values background_repeat_values background_image_values background_attachment_values { result = val }

  | background_color_values background_position_values background_attachment_values background_image_values background_repeat_values { result = val }

  | background_position_values background_color_values background_image_values background_attachment_values background_repeat_values { result = val }

  | background_color_values background_position_values background_attachment_values background_repeat_values background_image_values { result = val }

  | background_position_values background_color_values background_image_values background_repeat_values background_attachment_values { result = val }

  | background_image_values background_color_values background_repeat_values background_attachment_values background_position_values { result = val }

  | background_image_values background_color_values background_repeat_values background_position_values background_attachment_values { result = val }

  | background_attachment_values background_position_values background_repeat_values background_image_values background_color_values { result = val }

  | background_image_values background_color_values background_attachment_values background_repeat_values background_position_values { result = val }

  | background_image_values background_color_values background_attachment_values background_position_values background_repeat_values { result = val }

  | background_attachment_values background_position_values background_repeat_values background_color_values background_image_values { result = val }

  | background_image_values background_color_values background_position_values background_repeat_values background_attachment_values { result = val }

  | background_image_values background_color_values background_position_values background_attachment_values background_repeat_values { result = val }

  | background_attachment_values background_position_values background_image_values background_repeat_values background_color_values { result = val }

  | background_image_values background_repeat_values background_color_values background_attachment_values background_position_values { result = val }

  | background_image_values background_repeat_values background_color_values background_position_values background_attachment_values { result = val }

  | background_attachment_values background_position_values background_image_values background_color_values background_repeat_values { result = val }

  | background_image_values background_repeat_values background_attachment_values background_color_values background_position_values { result = val }

  | background_image_values background_repeat_values background_attachment_values background_position_values background_color_values { result = val }

  | background_attachment_values background_position_values background_color_values background_repeat_values background_image_values { result = val }

  | background_image_values background_repeat_values background_position_values background_color_values background_attachment_values { result = val }

  | background_image_values background_repeat_values background_position_values background_attachment_values background_color_values { result = val }

  | background_attachment_values background_position_values background_color_values background_image_values background_repeat_values { result = val }

  | background_image_values background_attachment_values background_color_values background_repeat_values background_position_values { result = val }

  | background_attachment_values background_repeat_values background_position_values background_image_values background_color_values { result = val }

  | background_image_values background_attachment_values background_color_values background_position_values background_repeat_values { result = val }

  | background_attachment_values background_repeat_values background_position_values background_color_values background_image_values { result = val }

  | background_image_values background_attachment_values background_repeat_values background_color_values background_position_values { result = val }

  | background_attachment_values background_repeat_values background_image_values background_position_values background_color_values { result = val }

  | background_image_values background_attachment_values background_repeat_values background_position_values background_color_values { result = val }

  | background_attachment_values background_repeat_values background_image_values background_color_values background_position_values { result = val }

  | background_image_values background_attachment_values background_position_values background_color_values background_repeat_values { result = val }

  | background_attachment_values background_repeat_values background_color_values background_position_values background_image_values { result = val }

  | background_image_values background_attachment_values background_position_values background_repeat_values background_color_values { result = val }

  | background_attachment_values background_repeat_values background_color_values background_image_values background_position_values { result = val }

  | background_image_values background_position_values background_color_values background_repeat_values background_attachment_values { result = val }

  | background_attachment_values background_image_values background_position_values background_repeat_values background_color_values { result = val }

  | background_image_values background_position_values background_color_values background_attachment_values background_repeat_values { result = val }

  | background_attachment_values background_image_values background_position_values background_color_values background_repeat_values { result = val }

  | background_image_values background_position_values background_repeat_values background_color_values background_attachment_values { result = val }

  | background_attachment_values background_image_values background_repeat_values background_position_values background_color_values { result = val }

  | background_image_values background_position_values background_repeat_values background_attachment_values background_color_values { result = val }

  | background_attachment_values background_image_values background_repeat_values background_color_values background_position_values { result = val }

  | background_image_values background_position_values background_attachment_values background_color_values background_repeat_values { result = val }

  | background_attachment_values background_image_values background_color_values background_position_values background_repeat_values { result = val }

  | background_image_values background_position_values background_attachment_values background_repeat_values background_color_values { result = val }

  | background_attachment_values background_image_values background_color_values background_repeat_values background_position_values { result = val }

  | background_repeat_values background_color_values background_image_values background_attachment_values background_position_values { result = val }

  | background_attachment_values background_color_values background_position_values background_repeat_values background_image_values { result = val }

  | background_repeat_values background_color_values background_image_values background_position_values background_attachment_values { result = val }

  | background_attachment_values background_color_values background_position_values background_image_values background_repeat_values { result = val }

  | background_repeat_values background_color_values background_attachment_values background_image_values background_position_values { result = val }

  | background_attachment_values background_color_values background_repeat_values background_position_values background_image_values { result = val }

  | background_repeat_values background_color_values background_attachment_values background_position_values background_image_values { result = val }

  | background_attachment_values background_color_values background_repeat_values background_image_values background_position_values { result = val }

  | background_repeat_values background_color_values background_position_values background_image_values background_attachment_values { result = val }

  | background_attachment_values background_color_values background_image_values background_position_values background_repeat_values { result = val }

  | background_repeat_values background_color_values background_position_values background_attachment_values background_image_values { result = val }

  | background_attachment_values background_color_values background_image_values background_repeat_values background_position_values { result = val }

  | background_repeat_values background_image_values background_color_values background_attachment_values background_position_values { result = val }

  | background_repeat_values background_image_values background_color_values background_position_values background_attachment_values { result = val }

  | background_repeat_values background_position_values background_attachment_values background_image_values background_color_values { result = val }

  | background_repeat_values background_image_values background_attachment_values background_color_values background_position_values { result = val }

  | background_repeat_values background_image_values background_attachment_values background_position_values background_color_values { result = val }

  | background_repeat_values background_position_values background_attachment_values background_color_values background_image_values { result = val }

  | background_repeat_values background_image_values background_position_values background_color_values background_attachment_values { result = val }

  | background_repeat_values background_image_values background_position_values background_attachment_values background_color_values { result = val }

  | background_repeat_values background_position_values background_image_values background_attachment_values background_color_values { result = val }

  | background_repeat_values background_attachment_values background_color_values background_image_values background_position_values { result = val }

  | background_repeat_values background_attachment_values background_color_values background_position_values background_image_values { result = val }

  | background_repeat_values background_position_values background_image_values background_color_values background_attachment_values { result = val }

  | background_repeat_values background_attachment_values background_image_values background_color_values background_position_values { result = val }

  | background_repeat_values background_attachment_values background_image_values background_position_values background_color_values { result = val }

  | background_repeat_values background_position_values background_color_values background_attachment_values background_image_values { result = val }

  | background_repeat_values background_attachment_values background_position_values background_color_values background_image_values { result = val }

  | background_repeat_values background_attachment_values background_position_values background_image_values background_color_values { result = val }

  | background_repeat_values background_position_values background_color_values background_image_values background_attachment_values { result = val }

  | background_color_values background_repeat_values background_image_values background_attachment_values { result = val }

  | background_attachment_values background_repeat_values background_image_values background_color_values { result = val }

  | background_attachment_values background_position_values background_image_values background_color_values { result = val }

  | background_position_values background_color_values background_image_values background_attachment_values { result = val }

  | background_image_values background_repeat_values background_attachment_values background_position_values { result = val }

  | background_attachment_values background_repeat_values background_color_values background_image_values { result = val }

  | background_attachment_values background_position_values background_color_values background_image_values { result = val }

  | background_image_values background_repeat_values background_position_values background_attachment_values { result = val }

  | background_attachment_values background_image_values background_repeat_values background_color_values { result = val }

  | background_attachment_values background_image_values background_position_values background_color_values { result = val }

  | background_position_values background_color_values background_attachment_values background_image_values { result = val }

  | background_image_values background_attachment_values background_repeat_values background_position_values { result = val }

  | background_attachment_values background_image_values background_color_values background_position_values { result = val }

  | background_attachment_values background_image_values background_color_values background_repeat_values { result = val }

  | background_image_values background_attachment_values background_position_values background_repeat_values { result = val }

  | background_attachment_values background_color_values background_position_values background_image_values { result = val }

  | background_position_values background_image_values background_color_values background_attachment_values { result = val }

  | background_attachment_values background_color_values background_repeat_values background_image_values { result = val }

  | background_attachment_values background_color_values background_image_values background_position_values { result = val }

  | background_image_values background_position_values background_repeat_values background_attachment_values { result = val }

  | background_image_values background_position_values background_attachment_values background_color_values { result = val }

  | background_position_values background_image_values background_attachment_values background_color_values { result = val }

  | background_image_values background_position_values background_color_values background_attachment_values { result = val }

  | background_attachment_values background_color_values background_image_values background_repeat_values { result = val }

  | background_image_values background_attachment_values background_position_values background_color_values { result = val }

  | background_position_values background_attachment_values background_color_values background_image_values { result = val }

  | background_image_values background_attachment_values background_color_values background_position_values { result = val }

  | background_image_values background_position_values background_attachment_values background_repeat_values { result = val }

  | background_image_values background_color_values background_position_values background_attachment_values { result = val }

  | background_position_values background_attachment_values background_image_values background_color_values { result = val }

  | background_image_values background_color_values background_attachment_values background_position_values { result = val }

  | background_repeat_values background_attachment_values background_image_values background_color_values { result = val }

  | background_color_values background_position_values background_attachment_values background_image_values { result = val }

  | background_color_values background_image_values background_repeat_values background_position_values { result = val }

  | background_color_values background_position_values background_image_values background_attachment_values { result = val }

  | background_color_values background_image_values background_position_values background_repeat_values { result = val }

  | background_color_values background_attachment_values background_position_values background_image_values { result = val }

  | background_color_values background_repeat_values background_image_values background_position_values { result = val }

  | background_color_values background_attachment_values background_image_values background_position_values { result = val }

  | background_color_values background_repeat_values background_position_values background_image_values { result = val }

  | background_color_values background_image_values background_position_values background_attachment_values { result = val }

  | background_color_values background_position_values background_image_values background_repeat_values { result = val }

  | background_color_values background_image_values background_attachment_values background_position_values { result = val }

  | background_color_values background_position_values background_repeat_values background_image_values { result = val }

  | background_repeat_values background_image_values background_attachment_values background_position_values { result = val }

  | background_position_values background_attachment_values background_repeat_values background_color_values { result = val }

  | background_image_values background_color_values background_repeat_values background_position_values { result = val }

  | background_repeat_values background_attachment_values background_color_values background_image_values { result = val }

  | background_position_values background_attachment_values background_color_values background_repeat_values { result = val }

  | background_image_values background_color_values background_position_values background_repeat_values { result = val }

  | background_repeat_values background_image_values background_position_values background_attachment_values { result = val }

  | background_position_values background_repeat_values background_attachment_values background_color_values { result = val }

  | background_image_values background_repeat_values background_color_values background_position_values { result = val }

  | background_repeat_values background_image_values background_attachment_values background_color_values { result = val }

  | background_position_values background_repeat_values background_color_values background_attachment_values { result = val }

  | background_image_values background_repeat_values background_position_values background_color_values { result = val }

  | background_repeat_values background_attachment_values background_image_values background_position_values { result = val }

  | background_position_values background_color_values background_attachment_values background_repeat_values { result = val }

  | background_image_values background_position_values background_color_values background_repeat_values { result = val }

  | background_repeat_values background_image_values background_color_values background_attachment_values { result = val }

  | background_position_values background_color_values background_repeat_values background_attachment_values { result = val }

  | background_image_values background_position_values background_repeat_values background_color_values { result = val }

  | background_repeat_values background_attachment_values background_position_values background_image_values { result = val }

  | background_repeat_values background_color_values background_attachment_values background_image_values { result = val }

  | background_attachment_values background_position_values background_repeat_values background_color_values { result = val }

  | background_repeat_values background_color_values background_image_values background_position_values { result = val }

  | background_repeat_values background_position_values background_image_values background_attachment_values { result = val }

  | background_repeat_values background_color_values background_image_values background_attachment_values { result = val }

  | background_attachment_values background_position_values background_color_values background_repeat_values { result = val }

  | background_repeat_values background_color_values background_position_values background_image_values { result = val }

  | background_repeat_values background_position_values background_attachment_values background_image_values { result = val }

  | background_attachment_values background_repeat_values background_position_values background_color_values { result = val }

  | background_repeat_values background_image_values background_color_values background_position_values { result = val }

  | background_image_values background_attachment_values background_repeat_values background_color_values { result = val }

  | background_attachment_values background_repeat_values background_color_values background_position_values { result = val }

  | background_repeat_values background_image_values background_position_values background_color_values { result = val }

  | background_attachment_values background_image_values background_repeat_values background_position_values { result = val }

  | background_attachment_values background_color_values background_position_values background_repeat_values { result = val }

  | background_repeat_values background_position_values background_color_values background_image_values { result = val }

  | background_image_values background_attachment_values background_color_values background_repeat_values { result = val }

  | background_attachment_values background_color_values background_repeat_values background_position_values { result = val }

  | background_repeat_values background_position_values background_image_values background_color_values { result = val }

  | background_attachment_values background_image_values background_position_values background_repeat_values { result = val }

  | background_image_values background_repeat_values background_attachment_values background_color_values { result = val }

  | background_repeat_values background_position_values background_attachment_values background_color_values { result = val }

  | background_position_values background_color_values background_image_values background_repeat_values { result = val }

  | background_attachment_values background_repeat_values background_image_values background_position_values { result = val }

  | background_image_values background_repeat_values background_color_values background_attachment_values { result = val }

  | background_repeat_values background_position_values background_color_values background_attachment_values { result = val }

  | background_attachment_values background_repeat_values background_position_values background_image_values { result = val }

  | background_image_values background_color_values background_attachment_values background_repeat_values { result = val }

  | background_attachment_values background_position_values background_image_values background_repeat_values { result = val }

  | background_image_values background_color_values background_repeat_values background_attachment_values { result = val }

  | background_repeat_values background_attachment_values background_position_values background_color_values { result = val }

  | background_position_values background_color_values background_repeat_values background_image_values { result = val }

  | background_attachment_values background_position_values background_repeat_values background_image_values { result = val }

  | background_color_values background_attachment_values background_repeat_values background_image_values { result = val }

  | background_repeat_values background_attachment_values background_color_values background_position_values { result = val }

  | background_position_values background_image_values background_repeat_values background_attachment_values { result = val }

  | background_color_values background_attachment_values background_image_values background_repeat_values { result = val }

  | background_repeat_values background_color_values background_position_values background_attachment_values { result = val }

  | background_position_values background_image_values background_color_values background_repeat_values { result = val }

  | background_position_values background_image_values background_attachment_values background_repeat_values { result = val }

  | background_repeat_values background_color_values background_attachment_values background_position_values { result = val }

  | background_color_values background_repeat_values background_attachment_values background_image_values { result = val }

  | background_color_values background_position_values background_attachment_values background_repeat_values { result = val }

  | background_position_values background_image_values background_repeat_values background_color_values { result = val }

  | background_color_values background_position_values background_repeat_values background_attachment_values { result = val }

  | background_position_values background_repeat_values background_image_values background_attachment_values { result = val }

  | background_color_values background_attachment_values background_position_values background_repeat_values { result = val }

  | background_position_values background_repeat_values background_color_values background_image_values { result = val }

  | background_color_values background_attachment_values background_repeat_values background_position_values { result = val }

  | background_position_values background_repeat_values background_attachment_values background_image_values { result = val }

  | background_color_values background_repeat_values background_position_values background_attachment_values { result = val }

  | background_position_values background_repeat_values background_image_values background_color_values { result = val }

  | background_color_values background_repeat_values background_attachment_values background_position_values { result = val }

  | background_color_values background_image_values background_attachment_values background_repeat_values { result = val }

  | background_position_values background_attachment_values background_image_values background_repeat_values { result = val }

  | background_position_values background_attachment_values background_repeat_values background_image_values { result = val }

  | background_color_values background_image_values background_repeat_values background_attachment_values { result = val }

  | background_position_values background_attachment_values background_repeat_values { result = val }

  | background_attachment_values background_repeat_values background_image_values { result = val }

  | background_repeat_values background_image_values background_color_values { result = val }

  | background_repeat_values background_attachment_values background_image_values { result = val }

  | background_repeat_values background_color_values background_image_values { result = val }

  | background_position_values background_image_values background_color_values { result = val }

  | background_repeat_values background_image_values background_attachment_values { result = val }

  | background_image_values background_repeat_values background_color_values { result = val }

  | background_image_values background_color_values background_repeat_values { result = val }

  | background_image_values background_attachment_values background_repeat_values { result = val }

  | background_color_values background_attachment_values background_position_values { result = val }

  | background_color_values background_position_values background_attachment_values { result = val }

  | background_image_values background_repeat_values background_attachment_values { result = val }

  | background_color_values background_repeat_values background_image_values { result = val }

  | background_attachment_values background_color_values background_position_values { result = val }

  | background_repeat_values background_attachment_values background_position_values { result = val }

  | background_position_values background_repeat_values background_image_values { result = val }

  | background_position_values background_color_values background_image_values { result = val }

  | background_attachment_values background_position_values background_color_values { result = val }

  | background_color_values background_image_values background_attachment_values { result = val }

  | background_position_values background_image_values background_repeat_values { result = val }

  | background_repeat_values background_position_values background_attachment_values { result = val }

  | background_image_values background_position_values background_color_values { result = val }

  | background_repeat_values background_position_values background_image_values { result = val }

  | background_color_values background_image_values background_repeat_values { result = val }

  | background_position_values background_color_values background_attachment_values { result = val }

  | background_repeat_values background_image_values background_position_values { result = val }

  | background_image_values background_color_values background_position_values { result = val }

  | background_position_values background_attachment_values background_color_values { result = val }

  | background_image_values background_position_values background_repeat_values { result = val }

  | background_attachment_values background_repeat_values background_position_values { result = val }

  | background_color_values background_repeat_values background_position_values { result = val }

  | background_image_values background_repeat_values background_position_values { result = val }

  | background_color_values background_position_values background_repeat_values { result = val }

  | background_repeat_values background_color_values background_position_values { result = val }

  | background_color_values background_attachment_values background_image_values { result = val }

  | background_position_values background_attachment_values background_image_values { result = val }

  | background_repeat_values background_position_values background_color_values { result = val }

  | background_position_values background_color_values background_repeat_values { result = val }

  | background_color_values background_position_values background_image_values { result = val }

  | background_position_values background_image_values background_attachment_values { result = val }

  | background_attachment_values background_position_values background_repeat_values { result = val }

  | background_attachment_values background_image_values background_repeat_values { result = val }

  | background_color_values background_image_values background_position_values { result = val }

  | background_image_values background_color_values background_attachment_values { result = val }

  | background_attachment_values background_position_values background_image_values { result = val }

  | background_position_values background_repeat_values background_attachment_values { result = val }

  | background_color_values background_repeat_values background_attachment_values { result = val }

  | background_image_values background_attachment_values background_color_values { result = val }

  | background_attachment_values background_image_values background_position_values { result = val }

  | background_color_values background_attachment_values background_repeat_values { result = val }

  | background_repeat_values background_color_values background_attachment_values { result = val }

  | background_image_values background_position_values background_attachment_values { result = val }

  | background_repeat_values background_attachment_values background_color_values { result = val }

  | background_attachment_values background_color_values background_repeat_values { result = val }

  | background_image_values background_attachment_values background_position_values { result = val }

  | background_attachment_values background_repeat_values background_color_values { result = val }

  | background_attachment_values background_image_values background_color_values { result = val }

  | background_attachment_values background_color_values background_image_values { result = val }

  | background_position_values background_repeat_values background_color_values { result = val }

  | background_attachment_values background_repeat_values { result = val }

  | background_image_values background_position_values { result = val }

  | background_repeat_values background_attachment_values { result = val }

  | background_repeat_values background_color_values { result = val }

  | background_position_values background_image_values { result = val }

  | background_image_values background_color_values { result = val }

  | background_repeat_values background_image_values { result = val }

  | background_position_values background_repeat_values { result = val }

  | background_color_values background_repeat_values { result = val }

  | background_image_values background_attachment_values { result = val }

  | background_attachment_values background_image_values { result = val }

  | background_repeat_values background_position_values { result = val }

  | background_color_values background_position_values { result = val }

  | background_color_values background_attachment_values { result = val }

  | background_attachment_values background_position_values { result = val }

  | background_color_values background_image_values { result = val }

  | background_position_values background_attachment_values { result = val }

  | background_position_values background_color_values { result = val }

  | background_image_values background_repeat_values { result = val }

  | background_attachment_values background_color_values { result = val }

  | background_attachment_values { result = val }

  | background_color_values { result = val }

  | background_repeat_values { result = val }

  | background_image_values { result = val }

  | background_position_values { result = val }

    ;
  border_collapse
    : 'border-collapse' border_collapse_values {
        result = LexicalIdent.new(val[1])
      }
    | 'border-collapse' inherit { result = val[1] }
    ; 
  border_collapse_values
    : 'collapse'
    | 'separate'
    ;
  border_color
    : 'border-color' border_color_values { result = val[1].flatten }
    | 'border-color' inherit { result = val[1] }
    ;
  border_color_values

  : color_or_transparent color_or_transparent color_or_transparent color_or_transparent { result = val }

  | color_or_transparent color_or_transparent color_or_transparent { result = val }

  | color_or_transparent color_or_transparent { result = val }

  | color_or_transparent { result = val }

    ;
  color_or_transparent
    : color
    | transparent
    ;
  border_spacing
    : 'border-spacing' border_spacing_values { result = [val[1]].flatten }
    | 'border-spacing' inherit { result = val[1] }
    ;
  border_spacing_values
    : length length { result = val }
    | length
    ;
  border_style
    : 'border-style' border_style_values_1to4 { result = [val[1]].flatten }
    | 'border-style' inherit { result = val[1] }
    ;
  border_style_values_1to4
    : border_style_values border_style_values border_style_values
      border_style_values { result = val }
    | border_style_values border_style_values border_style_values {
        result = val
      }
    | border_style_values border_style_values { result = val }
    | border_style_values
    ;
  border_style_values
    : border_style_values_ident { result = LexicalIdent.new(val.first) }
    ;
  border_style_values_ident
    : 'none'
    | 'hidden'
    | 'dotted'
    | 'dashed'
    | 'solid'
    | 'double'
    | 'groove'
    | 'ridge'
    | 'inset'
    | 'outset'
    ;
  border_trbl
    : border_trbl_keys border_values { result = [val[1]].flatten }
    | border_trbl_keys inherit { result = val[1] }
    ;
  border_trbl_keys
    : 'border-top'
    | 'border-right'
    | 'border-bottom'
    | 'border-left'
    ;
  border_trbl_color
    : border_trbl_color_keys border_trbl_color_values { result = val[1] }
    | border_trbl_color_keys inherit { result = val[1] }
    ;
  border_trbl_color_keys
    : 'border-top-color'
    | 'border-right-color'
    | 'border-bottom-color'
    | 'border-left-color'
    ;
  border_trbl_color_values
    : color
    | transparent
    ;
  border_trbl_style
    : border_trbl_style_keys border_style_values { result = val[1] }
    | border_trbl_style_keys inherit { result = val[1] }
    ;
  border_trbl_style_keys
    : 'border-top-style'
    | 'border-right-style'
    | 'border-bottom-style'
    | 'border-left-style'
    ;
  border_trbl_width
    : border_trbl_width_keys border_width_values { result = val[1] }
    | border_trbl_width_keys inherit { result = val[1] }
    ;
  border_trbl_width_keys
    : 'border-top-width'
    | 'border-right-width'
    | 'border-bottom-width'
    | 'border-left-width'
    ;
  border_width
    : 'border-width' border_width_values_1to4 { result = [val[1]].flatten }
    | 'border-width' inherit { result = val[1] }
    ;
  border_width_values
    : border_width_values_ident { result = LexicalIdent.new(val.first) }
    | length
    ;
  border_width_values_ident
    : 'thin'
    | 'medium'
    | 'thick'
    ;
  border_width_values_1to4

  : border_width_values border_width_values border_width_values border_width_values { result = val }

  | border_width_values border_width_values border_width_values { result = val }

  | border_width_values border_width_values { result = val }

  | border_width_values { result = val }

    ;
  border
    : 'border' border_values { result = [val[1]].flatten }
    | 'border' border_style_values { result = val[1] }
    | 'border' inherit { result = val[1] }
    ;
  border_values

  : border_width_values border_style_values color { result = val }

  | color border_style_values border_width_values { result = val }

  | border_width_values color border_style_values { result = val }

  | color border_width_values border_style_values { result = val }

  | border_style_values border_width_values color { result = val }

  | border_style_values color border_width_values { result = val }

  | border_width_values color { result = val }

  | color border_width_values { result = val }

  | border_style_values color { result = val }

  | border_style_values border_width_values { result = val }

  | border_width_values border_style_values { result = val }

  | color border_style_values { result = val }

  | border_style_values { result = val }

  | border_width_values { result = val }

  | color { result = val }

    ;
  bottom
    : 'bottom' bottom_values { result = val[1] }
    | 'bottom' inherit { result = val[1] }
    ;
  bottom_values
    : length
    | percentage
    | auto
    ;
  caption_side
    : 'caption-side' caption_side_values { result = LexicalIdent.new(val[1]) }
    | 'caption-side' inherit { result = val[1] }
    ;
  caption_side_values
    : 'top'
    | 'bottom'
    ;
  clear
    : 'clear' clear_values { result = LexicalIdent.new(val[1]) }
    | 'clear' inherit { result = val[1] }
    ;
  clear_values
    : 'none'
    | 'left'
    | 'right'
    | 'both'
    ;
  clip
    : 'clip' clip_values { result = val[1] }
    | 'clip' inherit { result = val[1] }
    ;
  clip_values
    : shape
    | auto
    ;
  shape
    : 'rect(' shape_param COMMA shape_param COMMA shape_param COMMA
      shape_param {
        result = Function.new(val[0], [val[1], val[3], val[5], val[7]])
      }
    ;
  shape_param
    : length
    | 'auto'
    ;
  color_lex
    : 'color' color { result = val[1] }
    | 'color' 'inherit' { result = LexicalIdent.new(val[1]) }
    ;
  content
    : 'content' content_values_1toN { result = [val[1]].flatten }
    | 'content' inherit { result = val[1] }
    ;
  content_values_1toN
    : content_values content_values_1toN { result = val }
    | content_values
    ;
  content_values
    : content_values_ident { result = LexicalIdent.new(val.first) }
    | string
    | normal
    | none
    | uri
    | counter
    | 'attr(' ident {
        result = Function.new(val[0], [val[1]])
      }
    ;
  content_values_ident
    : 'open-quote'
    | 'close-quote'
    | 'no-open-quote'
    | 'no-close-quote'
    ;
  counter
    : 'counter(' IDENT list_style_type_values {
        result = Function.new(val[0], [val[1], val[2]].flatten)
      }
    | 'counter(' IDENT { result = Function.new(val[0], [val[1]]) }
    | 'counters(' IDENT string list_style_type_values {
        result = Function.new(val[0], [val[1], val[2], val[3]].flatten)
      }
    | 'counters(' IDENT string {
        result = Function.new(val[0], [val[1], val[2]])
      }
    ;
  counter_increment_or_reset
    : counter_increment_or_reset_keys counter_increment_values_1toN {
        result = [val[1]].flatten
      }
    | counter_increment_or_reset_keys none { result = val[1] }
    | counter_increment_or_reset_keys inherit { result = val[1] }
    ;
  counter_increment_or_reset_keys
    : 'counter-increment'
    | 'counter-reset'
    ;
  counter_increment_values_1toN
    : counter_increment_values counter_increment_values_1toN { result = val }
    | counter_increment_values
    ;
  counter_increment_values
    : ident number { result = val }
    | ident
    ;
  cue_after_or_before
    : cue_after_or_before_keys cue_after_or_before_values { result = val[1] }
    | cue_after_or_before_keys inherit { result = val[1] }
    ;
  cue_after_or_before_values
    : uri
    | none
    ;
  cue_after_or_before_keys
    : 'cue-after'
    | 'cue-before'
    ;
  cue
    : 'cue' cue_values { result = val[1] }
    | 'cue' inherit { result = val[1] }
    ;
  cue_values
    : cue_after_or_before_values cue_after_or_before_values { result = val }
    | cue_after_or_before_values
    ;
    ;
  cursor
    : 'cursor' cursor_values { result = val[1] }
    | 'cursor' inherit { result = val[1] }
    ;
  cursor_values
    : uri_0toN cursor_values_idents {
        result = [val[0], LexicalIdent.new(val[1])].flatten.compact
      }
    ;
  cursor_values_idents
    : 'auto'
    | 'crosshair'
    | 'default'
    | 'pointer'
    | 'move'
    | 'e-resize'
    | 'ne-resize'
    | 'nw-resize'
    | 'n-resize'
    | 'se-resize'
    | 'sw-resize'
    | 's-resize'
    | 'w-resize'
    | 'text'
    | 'wait'
    | 'help'
    | 'progress'
    ;
  uri_0toN
    : uri COMMA uri_0toN { result = [val.first, val.last] }
    | uri
    |
    ;
  direction
    : 'direction' 'ltr' { result = LexicalIdent.new(val[1]) }
    | 'direction' 'rtl' { result = LexicalIdent.new(val[1]) }
    | 'direction' inherit { result = val[1] }
    ;
  display
    : 'display' display_values { result = LexicalIdent.new(val[1]) }
    | 'display' inherit { result = val[1] }
    ;
  display_values
    : 'inline'
    | 'block'
    | 'list-item'
    | 'run-in'
    | 'inline-block'
    | 'table'
    | 'inline-table'
    | 'table-row-group'
    | 'table-header-group'
    | 'table-footer-group'
    | 'table-row'
    | 'table-column-group'
    | 'table-column'
    | 'table-cell'
    | 'table-caption'
    | 'none'
    ;
  elevation
    : 'elevation' elevation_values { result = val[1] }
    | 'elevation' inherit { result = val[1] }
    ;
  elevation_values
    : angle
    | elevation_values_ident { result = LexicalIdent.new(val.first) }
    ;
  elevation_values_ident
    | 'below'
    | 'level'
    | 'above'
    | 'higher'
    | 'lower'
    ;
  empty_cells
    : 'empty-cells' empty_cells_values { result = LexicalIdent.new(val[1]) }
    | 'empty-cells' inherit { result = val[1] }
    ;
  empty_cells_values
    : 'show'
    | 'hide'
    ;
  float
    : 'float' float_values { result = LexicalIdent.new(val[1]) }
    | 'float' inherit { result = val[1] }
    ;
  float_values
    : 'left'
    | 'right'
    | 'none'
    ;
  font_family
    : 'font-family' font_family_values_1toN { result = [val[1]].flatten }
    | 'font-family' inherit { result = val[1] }
    ;
  font_family_values_1toN
    : font_family_values COMMA font_family_values_1toN {
        result = [val.first, val.last]
      }
    | font_family_values
    ;
  font_family_values
    : ident
    | string
    | generic_family { result = LexicalIdent.new(val.first) }
    ;
  generic_family
    : 'serif'
    | 'sans-serif'
    | 'cursive'
    | 'fantasy'
    | 'monospace'
    ;
  font_size
    : 'font-size' font_size_values { result = val[1] }
    | 'font-size' inherit { result = val[1] }
    ;
  font_size_values
    : absolute_size { result = LexicalIdent.new(val.first) }
    | relative_size { result = LexicalIdent.new(val.first) }
    | length
    | percentage
    ;
  absolute_size
    : 'xx-small'
    | 'x-small'
    | 'small'
    | 'medium'
    | 'large'
    | 'x-large'
    | 'xx-large'
    ;
  relative_size
    : 'larger'
    | 'smaller'
    ;
  font_style
    : 'font-style' font_style_values { result = val[1] }
    | 'font-style' inherit { result = val[1] }
    ;
  font_style_values
    : font_style_values_ident { result = LexicalIdent.new(val.first) }
    | normal
    ;
  font_style_values_ident
    : 'italic'
    | 'oblique'
    ;
  font_variant
    : 'font-variant' font_variant_values { result = val[1] }
    | 'font-variant' inherit { result = val[1] }
    ;
  font_variant_values
    : 'small-caps' { result = LexicalIdent.new(val.first) }
    | normal
    ;
  font_weight
    : 'font-weight' font_weight_values { result = val[1] }
    | 'font-weight' inherit { result = val[1] }
    ;
  font_weight_values
    : font_weight_values_ident { result = LexicalIdent.new(val.first) }
    | normal
    | number /* this is too loose. */
    ;
  font_weight_values_ident
    : 'bold'
    | 'bolder'
    | 'lighter'
    ;
  font
    : 'font' font_values { result = [val[1]].flatten.compact }
    | 'font' inherit { result = val[1] }
    ;
  font_values
    : font_style_variant_weight_0or1 font_size_values slash_line_height_0or1
      font_family_values_1toN { result = val }
    | font_values_ident { result = LexicalIdent.new(val.first) }
    ;
  font_values_ident
    : 'caption'
    | 'icon'
    | 'menu'
    | 'message-box'
    | 'small-caption'
    | 'status-bar'
    ;
  font_style_variant_weight_0or1

    : font_style_values font_variant_values font_weight_values { result = val }

    | font_weight_values font_variant_values font_style_values { result = val }

    | font_style_values font_weight_values font_variant_values { result = val }

    | font_weight_values font_style_values font_variant_values { result = val }

    | font_variant_values font_style_values font_weight_values { result = val }

    | font_variant_values font_weight_values font_style_values { result = val }

    | font_style_values font_weight_values { result = val }

    | font_weight_values font_style_values { result = val }

    | font_variant_values font_weight_values { result = val }

    | font_variant_values font_style_values { result = val }

    | font_style_values font_variant_values { result = val }

    | font_weight_values font_variant_values { result = val }

    | font_variant_values { result = val }

    | font_style_values { result = val }

    | font_weight_values { result = val }

    |
    ;
  slash_line_height_0or1
    : '/' line_height_values { result = val[1] }
    |
    ;
  hlrt
    : hlrt_keys bottom_values { result = val[1] }
    | hlrt_keys inherit { result = val[1] }
    ;
  hlrt_keys
    : 'height'
    | 'left'
    | 'right'
    | 'top'
    ;
  letter_spacing
    : 'letter-spacing' letter_spacing_values { result = val[1] }
    | 'letter-spacing' inherit { result = val[1] }
    ;
  letter_spacing_values
    : normal
    | length
    ;
  line_height
    : 'line-height' line_height_values { result = val[1] }
    | 'line-height' inherit { result = val[1] }
    ;
  line_height_values
    : normal
    | number
    | length
    | percentage
    ;
  list_style_image
    : 'list-style-image' list_style_image_values { result = val[1] }
    | 'list-style-image' inherit { result = val[1] }
    ;
  list_style_image_values
    : uri
    | none
    ;
  list_style_position
    : 'list-style-position' list_style_position_values { result = val[1] }
    | 'list-style-position' inherit { result = val[1] }
    ;
  list_style_position_values
    : list_style_position_ident { result = LexicalIdent.new(val.first) }
    ;
  list_style_position_ident
    : 'inside'
    | 'outside'
    ;
  list_style_type
    : 'list-style-type' list_style_type_values { result = val[1] }
    | 'list-style-type' inherit { result = val[1] }
    ;
  list_style_type_values
    : list_style_type_values_ident { result = LexicalIdent.new(val.first) }
    | none
    ;
  list_style_type_values_ident
    : 'disc'
    | 'circle'
    | 'square'
    | 'decimal'
    | 'decimal-leading-zero'
    | 'lower-roman'
    | 'upper-roman'
    | 'lower-greek'
    | 'lower-latin'
    | 'upper-latin'
    | 'armenian'
    | 'georgian'
    | 'lower-alpha'
    | 'upper-alpha'
    ;
  list_style
    : 'list-style' list_style_values { result = [val[1]].flatten }
    | 'list-style' inherit { result = val[1] }
    ;
  list_style_values

    : list_style_type_values list_style_position_values list_style_image_values { result = val }

    | list_style_image_values list_style_position_values list_style_type_values { result = val }

    | list_style_type_values list_style_image_values list_style_position_values { result = val }

    | list_style_image_values list_style_type_values list_style_position_values { result = val }

    | list_style_position_values list_style_type_values list_style_image_values { result = val }

    | list_style_position_values list_style_image_values list_style_type_values { result = val }

    | list_style_type_values list_style_image_values { result = val }

    | list_style_image_values list_style_type_values { result = val }

    | list_style_position_values list_style_image_values { result = val }

    | list_style_position_values list_style_type_values { result = val }

    | list_style_type_values list_style_position_values { result = val }

    | list_style_image_values list_style_position_values { result = val }

    | list_style_position_values { result = val }

    | list_style_type_values { result = val }

    | list_style_image_values { result = val }

    ;
  margin_rltb
    : margin_rltb_keys margin_width_values { result = val[1] }
    | margin_rltb_keys inherit { result = val[1] }
    ;
  margin_rltb_keys
    : 'margin-right'
    | 'margin-left'
    | 'margin-top'
    | 'margin-bottom'
    ;
  margin
    : 'margin' margin_width_values_1to4 { result = [val[1]].flatten }
    | 'margin' inherit { result = val[1] }
    ;
  margin_width_values
    : length
    | percentage
    | auto
    ;
  margin_width_values_1to4

  : margin_width_values margin_width_values margin_width_values margin_width_values { result = val }

  | margin_width_values margin_width_values margin_width_values { result = val }

  | margin_width_values margin_width_values { result = val }

  | margin_width_values { result = val }

    ;
  max_height_or_width
    : max_height_or_width_keys max_height_values { result = val[1] }
    | max_height_or_width_keys inherit { result = val[1] }
    ;
  max_height_or_width_keys
    : 'max-height'
    | 'max-width'
    ;
  max_height_values
    : length
    | percentage
    | none
    ;
  min_height_or_width
    : min_height_or_width_keys min_height_values { result = val[1] }
    | min_height_or_width_keys inherit { result = val[1] }
    ;
  min_height_or_width_keys
    : 'min-height'
    | 'min-width'
    ;
  min_height_values
    : length
    | percentage
    ;
  orphans
    : 'orphans' integer { result = val[1] }
    | 'orphans' inherit { result = val[1] }
    ;
  outline_color
    : 'outline-color' outline_color_values { result = val[1] }
    | 'outline-color' inherit { result = val[1] }
    ;
  outline_color_values
    : color
    | invert
    ;
  outline_style
    : 'outline-style' outline_style_values { result = val[1] }
    | 'outline-style' inherit { result = val[1] }
    ;
  outline_style_values
    : border_style_values
    ;
  outline_width
    : 'outline-width' outline_width_values { result = val[1] }
    | 'outline-width' inherit { result = val[1] }
    ;
  outline_width_values
    : border_width_values
    ;
  outline
    : 'outline' outline_values { result = [val[1]].flatten }
    | 'outline' inherit { result = val[1] }
    ;
  outline_values

    : outline_color_values outline_style_values outline_width_values { result = val }

    | outline_width_values outline_style_values outline_color_values { result = val }

    | outline_color_values outline_width_values outline_style_values { result = val }

    | outline_width_values outline_color_values outline_style_values { result = val }

    | outline_style_values outline_color_values outline_width_values { result = val }

    | outline_style_values outline_width_values outline_color_values { result = val }

    | outline_color_values outline_width_values { result = val }

    | outline_width_values outline_color_values { result = val }

    | outline_style_values outline_width_values { result = val }

    | outline_style_values outline_color_values { result = val }

    | outline_color_values outline_style_values { result = val }

    | outline_width_values outline_style_values { result = val }

    | outline_style_values { result = val }

    | outline_color_values { result = val }

    | outline_width_values { result = val }

    ;
  overflow
    : 'overflow' overflow_values { result = LexicalIdent.new(val[1]) }
    | 'overflow' inherit { result = val[1] }
    ;
  overflow_values
    : 'visible'
    | 'hidden'
    | 'scroll'
    | 'auto'
    ;
  padding_trbl
    : padding_trbl_keys padding_width { result = val[1] }
    | padding_trbl_keys inherit { result = val[1] }
    ;
  padding_trbl_keys
    : 'padding-top'
    | 'padding-right'
    | 'padding-bottom'
    | 'padding-left'
    ;
  padding_width
    : length
    | percentage
    ;
  padding
    : 'padding' padding_width_1to4 { result = [val[1]].flatten }
    | 'padding' inherit { result = val[1] }
    ;
  padding_width_values
    : length
    | percentage
    ;
  padding_width_1to4

  : padding_width_values padding_width_values padding_width_values padding_width_values { result = val }

  | padding_width_values padding_width_values padding_width_values { result = val }

  | padding_width_values padding_width_values { result = val }

  | padding_width_values { result = val }

    ;
  page_break_ab
    : page_break_ab_keys page_break_ab_values {
        result = LexicalIdent.new(val[1])
      }
    | page_break_ab_keys inherit { result = val[1] }
    ;
  page_break_ab_keys
    : 'page-break-after'
    | 'page-break-before'
    ;
  page_break_ab_values
    : 'auto'
    | 'always'
    | 'avoid'
    | 'left'
    | 'right'
    ;
  page_break_inside
    : 'page-break-inside' page_break_inside_values {
        result = LexicalIdent.new(val[1])
      }
    | 'page-break-inside' inherit { result = val[1] }
    ;
  page_break_inside_values
    : 'avoid'
    | 'auto'
    ;
  pause_ab
    : pause_ab_keys pause_ab_values { result = val[1] }
    | pause_ab_keys inherit { result = val[1] }
    ;
  pause_ab_keys
    : 'pause-after'
    | 'pause-before'
    ;
  pause_ab_values
    : time
    | percentage
    ;
  pause
    : 'pause' pause_values_1or2 { result = val[1] }
    | 'pause' inherit { result = val[1] }
    ;
  pause_values_1or2
    : pause_values pause_values { result = val }
    | pause_values
    ;
  pause_values
    : time
    | percentage
    ;
  pitch_range
    : 'pitch-range' number { result = val[1] }
    | 'pitch-range' inherit { result = val[1] }
    ;
  pitch
    : 'pitch' pitch_values { result = val[1] }
    | 'pitch' inherit { result = val[1] }
    ;
  pitch_values
    : frequency
    | pitch_values_ident { result = LexicalIdent.new(val.first) }
    ;
  pitch_values_ident
    : 'x-low'
    | 'low'
    | 'medium'
    | 'high'
    | 'x-high'
    ;
  play_during
    : 'play-during' play_during_values { result = val[1] }
    | 'play-during' inherit { result = val[1] }
    ;
  play_during_values
    : uri mix_or_repeat_0or1 { result = [val].flatten.compact }
    | auto
    | none
    ;
  mix_or_repeat_0or1

  : 'mix' 'repeat' {
    result = val.map { |x| LexicalIdent.new(x) }
  }

  | 'repeat' 'mix' {
    result = val.map { |x| LexicalIdent.new(x) }
  }

  | 'repeat' {
    result = val.map { |x| LexicalIdent.new(x) }
  }

  | 'mix' {
    result = val.map { |x| LexicalIdent.new(x) }
  }

    |
    ;
  position
    : 'position' position_values { result = LexicalIdent.new(val[1]) }
    | 'position' inherit { result = val[1] }
    ;
  position_values
    : 'static'
    | 'relative'
    | 'absolute'
    | 'fixed'
    ;
  quotes
    : 'quotes' quotes_values { result = [val[1]].flatten }
    | 'quotes' inherit { result = val[1] }
    ;
  quotes_values
    : string_pair_1toN
    | none
    ;
  string_pair_1toN
    : string string string_pair_1toN { result = val }
    | string string { result = val }
    ;
  richness
    : 'richness' number { result = val[1] }
    | 'richness' inherit { result = val[1] }
    ;
  speak_header
    : 'speak-header' speak_header_values { result = LexicalIdent.new(val[1]) }
    | 'speak-header' inherit { result = val[1] }
    ;
  speak_header_values
    : 'once'
    | 'always'
    ;
  speak_numeral
    : 'speak-numeral' speak_numeral_values { result = LexicalIdent.new(val[1]) }
    | 'speak-numeral' inherit { result = val[1] }
    ;
  speak_numeral_values
    : 'digits'
    | 'continuous'
    ;
  speak_punctuation
    : 'speak-punctuation' speak_punctuation_values {
        result = LexicalIdent.new(val[1])
      }
    | 'speak-punctuation' inherit { result = val[1] }
    ;
  speak_punctuation_values
    : 'code'
    | 'none'
    ;
  speak
    : 'speak' speak_values { result = LexicalIdent.new(val[1]) }
    | 'speak' inherit { result = val[1] }
    ;
  speak_values
    : 'normal'
    | 'none'
    | 'spell-out'
    ;
  speech_rate
    : 'speech-rate' speech_rate_values { result = LexicalIdent.new(val[1]) }
    | 'speech-rate' number { result = val[1] }
    | 'speech-rate' inherit { result = val[1] }
    ;
  speech_rate_values
    : 'x-slow'
    | 'slow'
    | 'medium'
    | 'fast'
    | 'x-fast'
    | 'faster'
    | 'slower'
    ;
  stress
    : 'stress' number { result = val[1] }
    | 'stress' inherit { result = val[1] }
    ;
  table_layout
    : 'table-layout' table_layout_values { result = LexicalIdent.new(val[1]) }
    | 'table-layout' inherit { result = val[1] }
    ;
  table_layout_values
    : 'auto'
    | 'fixed'
    ;
  text_align
    : 'text-align' text_align_values { result = LexicalIdent.new(val[1]) }
    | 'text-align' inherit { result = val[1] }
    ;
  text_align_values
    : 'left'
    | 'right'
    | 'center'
    | 'justify'
    ;
  text_decoration
    : 'text-decoration' text_decoration_values { result = val[1] }
    | 'text-decoration' inherit { result = val[1] }
    ;
  text_decoration_values

  : 'underline' 'overline' 'line-through' 'blink' {
    result = val.map { |x| LexicalIdent.new(x) }
  }

  | 'blink' 'line-through' 'overline' 'underline' {
    result = val.map { |x| LexicalIdent.new(x) }
  }

  | 'underline' 'overline' 'blink' 'line-through' {
    result = val.map { |x| LexicalIdent.new(x) }
  }

  | 'blink' 'line-through' 'underline' 'overline' {
    result = val.map { |x| LexicalIdent.new(x) }
  }

  | 'underline' 'line-through' 'overline' 'blink' {
    result = val.map { |x| LexicalIdent.new(x) }
  }

  | 'blink' 'overline' 'line-through' 'underline' {
    result = val.map { |x| LexicalIdent.new(x) }
  }

  | 'underline' 'line-through' 'blink' 'overline' {
    result = val.map { |x| LexicalIdent.new(x) }
  }

  | 'blink' 'overline' 'underline' 'line-through' {
    result = val.map { |x| LexicalIdent.new(x) }
  }

  | 'underline' 'blink' 'overline' 'line-through' {
    result = val.map { |x| LexicalIdent.new(x) }
  }

  | 'blink' 'underline' 'line-through' 'overline' {
    result = val.map { |x| LexicalIdent.new(x) }
  }

  | 'underline' 'blink' 'line-through' 'overline' {
    result = val.map { |x| LexicalIdent.new(x) }
  }

  | 'blink' 'underline' 'overline' 'line-through' {
    result = val.map { |x| LexicalIdent.new(x) }
  }

  | 'overline' 'underline' 'line-through' 'blink' {
    result = val.map { |x| LexicalIdent.new(x) }
  }

  | 'overline' 'underline' 'blink' 'line-through' {
    result = val.map { |x| LexicalIdent.new(x) }
  }

  | 'line-through' 'blink' 'overline' 'underline' {
    result = val.map { |x| LexicalIdent.new(x) }
  }

  | 'overline' 'line-through' 'underline' 'blink' {
    result = val.map { |x| LexicalIdent.new(x) }
  }

  | 'overline' 'line-through' 'blink' 'underline' {
    result = val.map { |x| LexicalIdent.new(x) }
  }

  | 'line-through' 'blink' 'underline' 'overline' {
    result = val.map { |x| LexicalIdent.new(x) }
  }

  | 'overline' 'blink' 'underline' 'line-through' {
    result = val.map { |x| LexicalIdent.new(x) }
  }

  | 'line-through' 'overline' 'blink' 'underline' {
    result = val.map { |x| LexicalIdent.new(x) }
  }

  | 'overline' 'blink' 'line-through' 'underline' {
    result = val.map { |x| LexicalIdent.new(x) }
  }

  | 'line-through' 'overline' 'underline' 'blink' {
    result = val.map { |x| LexicalIdent.new(x) }
  }

  | 'line-through' 'underline' 'overline' 'blink' {
    result = val.map { |x| LexicalIdent.new(x) }
  }

  | 'line-through' 'underline' 'blink' 'overline' {
    result = val.map { |x| LexicalIdent.new(x) }
  }

  | 'blink' 'overline' 'line-through' {
    result = val.map { |x| LexicalIdent.new(x) }
  }

  | 'underline' 'blink' 'overline' {
    result = val.map { |x| LexicalIdent.new(x) }
  }

  | 'overline' 'line-through' 'blink' {
    result = val.map { |x| LexicalIdent.new(x) }
  }

  | 'blink' 'line-through' 'underline' {
    result = val.map { |x| LexicalIdent.new(x) }
  }

  | 'overline' 'underline' 'blink' {
    result = val.map { |x| LexicalIdent.new(x) }
  }

  | 'line-through' 'overline' 'underline' {
    result = val.map { |x| LexicalIdent.new(x) }
  }

  | 'blink' 'underline' 'line-through' {
    result = val.map { |x| LexicalIdent.new(x) }
  }

  | 'overline' 'blink' 'underline' {
    result = val.map { |x| LexicalIdent.new(x) }
  }

  | 'line-through' 'underline' 'overline' {
    result = val.map { |x| LexicalIdent.new(x) }
  }

  | 'overline' 'blink' 'line-through' {
    result = val.map { |x| LexicalIdent.new(x) }
  }

  | 'line-through' 'blink' 'underline' {
    result = val.map { |x| LexicalIdent.new(x) }
  }

  | 'blink' 'underline' 'overline' {
    result = val.map { |x| LexicalIdent.new(x) }
  }

  | 'overline' 'line-through' 'underline' {
    result = val.map { |x| LexicalIdent.new(x) }
  }

  | 'line-through' 'underline' 'blink' {
    result = val.map { |x| LexicalIdent.new(x) }
  }

  | 'line-through' 'overline' 'blink' {
    result = val.map { |x| LexicalIdent.new(x) }
  }

  | 'underline' 'blink' 'line-through' {
    result = val.map { |x| LexicalIdent.new(x) }
  }

  | 'blink' 'overline' 'underline' {
    result = val.map { |x| LexicalIdent.new(x) }
  }

  | 'underline' 'line-through' 'blink' {
    result = val.map { |x| LexicalIdent.new(x) }
  }

  | 'overline' 'underline' 'line-through' {
    result = val.map { |x| LexicalIdent.new(x) }
  }

  | 'line-through' 'blink' 'overline' {
    result = val.map { |x| LexicalIdent.new(x) }
  }

  | 'underline' 'overline' 'blink' {
    result = val.map { |x| LexicalIdent.new(x) }
  }

  | 'underline' 'overline' 'line-through' {
    result = val.map { |x| LexicalIdent.new(x) }
  }

  | 'underline' 'line-through' 'overline' {
    result = val.map { |x| LexicalIdent.new(x) }
  }

  | 'blink' 'line-through' 'overline' {
    result = val.map { |x| LexicalIdent.new(x) }
  }

  | 'overline' 'line-through' {
    result = val.map { |x| LexicalIdent.new(x) }
  }

  | 'line-through' 'underline' {
    result = val.map { |x| LexicalIdent.new(x) }
  }

  | 'blink' 'overline' {
    result = val.map { |x| LexicalIdent.new(x) }
  }

  | 'line-through' 'overline' {
    result = val.map { |x| LexicalIdent.new(x) }
  }

  | 'overline' 'underline' {
    result = val.map { |x| LexicalIdent.new(x) }
  }

  | 'overline' 'blink' {
    result = val.map { |x| LexicalIdent.new(x) }
  }

  | 'underline' 'overline' {
    result = val.map { |x| LexicalIdent.new(x) }
  }

  | 'line-through' 'blink' {
    result = val.map { |x| LexicalIdent.new(x) }
  }

  | 'underline' 'line-through' {
    result = val.map { |x| LexicalIdent.new(x) }
  }

  | 'blink' 'line-through' {
    result = val.map { |x| LexicalIdent.new(x) }
  }

  | 'blink' 'underline' {
    result = val.map { |x| LexicalIdent.new(x) }
  }

  | 'underline' 'blink' {
    result = val.map { |x| LexicalIdent.new(x) }
  }

  | 'underline' {
    result = val.map { |x| LexicalIdent.new(x) }
  }

  | 'line-through' {
    result = val.map { |x| LexicalIdent.new(x) }
  }

  | 'overline' {
    result = val.map { |x| LexicalIdent.new(x) }
  }

  | 'blink' {
    result = val.map { |x| LexicalIdent.new(x) }
  }

    | none
    ;
  text_indent
    : 'text-indent' text_indent_values { result = val[1] }
    | 'text-indent' inherit { result = val[1] }
    ;
  text_indent_values
    : length
    | percentage
    ;
  text_transform
    : 'text-transform' text_transform_values {
        result = LexicalIdent.new(val[1])
      }
    | 'text-transform' inherit { result = val[1] }
    ;
  text_transform_values
    : 'capitalize'
    | 'uppercase'
    | 'lowercase'
    | 'none'
    ;
  unicode_bidi
    : 'unicode-bidi' unicode_bidi_values { result = LexicalIdent.new(val[1]) }
    | 'unicode-bidi' inherit { result = val[1] }
    ;
  unicode_bidi_values
    : 'normal'
    | 'embed'
    | 'bidi-override'
    ;
  vertical_align
    : 'vertical-align' vertical_align_values { result = val[1] }
    | 'vertical-align' inherit { result = val[1] }
    ;
  vertical_align_values
    : vertical_align_values_ident { result = LexicalIdent.new(val.first) }
    | percentage
    | length
    ;
  vertical_align_values_ident
    : 'baseline'
    | 'sub'
    | 'super'
    | 'top'
    | 'text-top'
    | 'middle'
    | 'bottom'
    | 'text-bottom'
    ;
  visibility
    : 'visibility' visibility_values { result = LexicalIdent.new(val[1]) }
    | 'visibility' inherit { result = val[1] }
    ;
  visibility_values
    : 'visible'
    | 'hidden'
    | 'collapse'
    ;
  voice_family
    : 'voice-family' voice_family_values { result = val[1] }
    | 'voice-family' inherit { result = val[1] }
    ;
  voice_family_values
    : specific_voice_generic_voice_1toN { result = val.flatten }
    ;
  specific_voice_generic_voice_1toN
    : generic_voice COMMA specific_voice_generic_voice_1toN {
        result = [val.first, val.last]
      }
    | specific_voice COMMA specific_voice_generic_voice_1toN {
        result = [val.first, val.last]
      }
    | generic_voice
    | specific_voice
    ;
  generic_voice
    : generic_voice_ident { result = LexicalIdent.new(val.first) }
    ;
  generic_voice_ident
    : 'male'
    | 'female'
    | 'child'
    ;
  specific_voice
    : ident
    | string
    ;
  volume
    : 'volume' volume_values { result = val[1] }
    | 'volume' inherit { result = val[1] }
    ;
  volume_values
    : number
    | percentage
    | volume_values_ident { result = LexicalIdent.new(val.first) }
    ;
  volume_values_ident
    : 'silent'
    | 'x-soft'
    | 'soft'
    | 'medium'
    | 'loud'
    | 'x-loud'
    ;
   white_space
    : 'white-space' white_space_values { result = LexicalIdent.new(val[1]) }
    | 'white-space' inherit { result = val[1] }
    ;
  white_space_values
    : 'normal'
    | 'pre'
    | 'nowrap'
    | 'pre-wrap'
    | 'pre-line'
    ;
  windows
    : 'windows' integer { result = val[1] }
    | 'windows' inherit { result = val[1] }
    ;
  width
    : 'width' width_values { result = val[1] }
    | 'width' inherit { result = val[1] }
    ;
  width_values
    : length
    | percentage
    | auto
    ;
  word_spacing
    : 'word-spacing' word_spacing_values { result = val[1] }
    | 'word-spacing' inherit { result = val[1] }
    ;
  word_spacing_values
    : 'normal' { result = LexicalIdent.new(val.first) }
    | length
    ;
  z_index
    : 'z-index' z_index_values { result = val[1] }
    | 'z-index' inherit { result = val[1] }
    ;
  z_index_values
    : auto
    | integer
    ;
/* vim: set filetype=racc : */
