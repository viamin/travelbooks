#
# DO NOT MODIFY!!!!
# This file is automatically generated by racc 1.4.5
# from racc grammer file "lib/parser.y".
#

require 'racc/parser'


  require "css/sac/conditions"
  require "css/sac/selectors"


module CSS

  module SAC

    class GeneratedParser < Racc::Parser

module_eval <<'..end lib/parser.y modeval..id1128ccb808', 'lib/parser.y', 307
  include CSS::SAC::Conditions
  include CSS::SAC::Selectors
..end lib/parser.y modeval..id1128ccb808

##### racc 1.4.5 generates ###

racc_reduce_table = [
 0, 0, :racc_error,
 9, 44, :_reduce_none,
 3, 44, :_reduce_none,
 3, 48, :_reduce_none,
 3, 48, :_reduce_none,
 3, 48, :_reduce_none,
 2, 48, :_reduce_none,
 2, 48, :_reduce_none,
 2, 48, :_reduce_none,
 0, 48, :_reduce_none,
 7, 52, :_reduce_10,
 7, 55, :_reduce_11,
 5, 55, :_reduce_12,
 3, 47, :_reduce_none,
 3, 47, :_reduce_none,
 0, 47, :_reduce_none,
 7, 50, :_reduce_16,
 2, 57, :_reduce_17,
 3, 57, :_reduce_18,
 2, 60, :_reduce_none,
 1, 54, :_reduce_none,
 0, 54, :_reduce_none,
 4, 59, :_reduce_22,
 1, 59, :_reduce_23,
 7, 51, :_reduce_24,
 4, 61, :_reduce_25,
 1, 63, :_reduce_none,
 0, 63, :_reduce_none,
 2, 64, :_reduce_28,
 0, 64, :_reduce_none,
 2, 65, :_reduce_none,
 2, 65, :_reduce_none,
 0, 65, :_reduce_none,
 2, 66, :_reduce_33,
 2, 66, :_reduce_34,
 1, 66, :_reduce_35,
 1, 67, :_reduce_none,
 1, 67, :_reduce_none,
 2, 68, :_reduce_none,
 5, 49, :_reduce_39,
 2, 58, :_reduce_none,
 1, 58, :_reduce_none,
 0, 58, :_reduce_none,
 1, 70, :_reduce_43,
 3, 69, :_reduce_44,
 3, 69, :_reduce_45,
 2, 69, :_reduce_46,
 4, 72, :_reduce_47,
 1, 72, :_reduce_none,
 2, 73, :_reduce_49,
 1, 73, :_reduce_50,
 3, 71, :_reduce_51,
 1, 71, :_reduce_none,
 2, 77, :_reduce_53,
 1, 74, :_reduce_54,
 1, 74, :_reduce_55,
 6, 78, :_reduce_56,
 2, 80, :_reduce_57,
 2, 80, :_reduce_58,
 5, 82, :_reduce_59,
 4, 62, :_reduce_none,
 5, 62, :_reduce_61,
 4, 62, :_reduce_62,
 1, 62, :_reduce_none,
 4, 62, :_reduce_none,
 0, 62, :_reduce_none,
 2, 85, :_reduce_none,
 1, 84, :_reduce_none,
 0, 84, :_reduce_none,
 3, 83, :_reduce_69,
 1, 83, :_reduce_none,
 2, 86, :_reduce_71,
 1, 86, :_reduce_72,
 2, 86, :_reduce_none,
 2, 86, :_reduce_none,
 2, 86, :_reduce_none,
 1, 86, :_reduce_none,
 1, 86, :_reduce_none,
 2, 87, :_reduce_none,
 2, 87, :_reduce_none,
 2, 87, :_reduce_none,
 2, 87, :_reduce_none,
 2, 87, :_reduce_none,
 2, 87, :_reduce_none,
 2, 87, :_reduce_none,
 2, 87, :_reduce_none,
 5, 81, :_reduce_86,
 6, 81, :_reduce_87,
 2, 88, :_reduce_none,
 1, 75, :_reduce_none,
 0, 75, :_reduce_none,
 2, 76, :_reduce_91,
 2, 76, :_reduce_92,
 2, 76, :_reduce_93,
 2, 76, :_reduce_94,
 1, 76, :_reduce_none,
 1, 76, :_reduce_none,
 1, 76, :_reduce_none,
 1, 76, :_reduce_none,
 1, 89, :_reduce_99,
 4, 79, :_reduce_100,
 4, 79, :_reduce_101,
 0, 79, :_reduce_none,
 1, 90, :_reduce_none,
 1, 90, :_reduce_none,
 1, 90, :_reduce_none,
 1, 53, :_reduce_none,
 1, 53, :_reduce_none,
 3, 56, :_reduce_none,
 3, 56, :_reduce_none,
 2, 56, :_reduce_none,
 2, 56, :_reduce_none,
 2, 45, :_reduce_none,
 2, 45, :_reduce_none,
 2, 45, :_reduce_none,
 1, 45, :_reduce_none,
 1, 45, :_reduce_none,
 1, 45, :_reduce_none,
 0, 45, :_reduce_none,
 2, 46, :_reduce_none,
 0, 46, :_reduce_none ]

racc_reduce_n = 121

racc_shift_n = 230

racc_action_table = [
   108,   166,    54,   -70,   138,   189,   190,     8,   149,    50,
   107,    53,    48,    12,   172,    50,   107,    84,    48,    62,
    19,    84,     8,    63,    36,    19,   -70,    83,    12,    19,
    61,    83,   -70,   139,   -70,    50,   173,   100,    48,     8,
   167,   110,   -70,   191,    54,    12,  -120,   110,   123,   127,
  -120,    21,   132,   116,    26,   119,    32,    19,   122,   125,
   126,   128,   129,   131,   114,   117,   145,    54,     5,    99,
   146,   123,   127,     3,     4,   132,   116,   120,   119,   224,
   223,   122,   125,   126,   128,   129,   131,   114,   117,    36,
    54,    72,    73,    74,   123,   127,    91,    36,   132,   116,
   120,   119,    22,    96,   122,   125,   126,   128,   129,   131,
   114,   117,    36,    19,   135,   136,    21,    22,   137,    26,
    36,    32,    95,   120,    21,    22,   140,    26,    28,    32,
    91,    19,    30,    34,    50,   107,    19,    48,    90,    21,
    30,    34,    26,    28,    32,   147,    19,    21,    36,    19,
    26,    28,    32,    22,     5,    84,    36,    19,   152,     3,
     4,    22,    36,    19,    19,    83,   110,    22,    30,    34,
    36,    36,   154,    91,    19,    21,    30,    34,    26,    28,
    32,    36,    19,    21,  -120,    36,    26,    28,    32,    21,
    22,    36,    26,    28,    32,   158,    22,    21,    21,    36,
    26,    26,    32,    32,    22,    30,    34,    19,    21,    19,
    19,    26,    21,    32,     5,    26,    28,    32,    21,     3,
     4,    26,    28,    32,    84,    84,    21,    19,    84,    26,
    28,    32,    19,    19,    83,    83,    19,    19,    83,   122,
   125,   126,   128,   129,   131,   114,   117,    19,    19,     8,
    19,    19,    10,  -120,  -120,    12,     5,  -120,     5,    19,
     5,     3,     4,     3,     4,     3,     4,     5,    19,     5,
    19,     5,     3,     4,     3,     4,     3,     4,    19,    19,
    19,    19,    19,    19,   180,    19,    19,    61,    19,   185,
    19,    78,   192,    19,    19,    19,   196,    19,    19,   199,
    19,    19,    19,    19,    19,    19,    59,    19,    19,   209,
    46,    91,    19,   213,   214,    19,    19,    19,   218,    19,
    19,    16,    19,     6,    19,    19,    19 ]

racc_action_check = [
    80,   124,    21,   130,    87,   148,   148,    17,    97,    80,
    80,    21,    80,    17,   130,   153,   153,   207,   153,    29,
    73,   177,    45,    29,    42,   207,   130,   207,    45,   177,
    29,   177,   130,    87,   130,    18,   130,    69,    18,   194,
   124,    80,   130,   148,    82,   194,   207,   153,    82,    82,
   177,    42,    82,    82,    42,    82,    42,    78,    82,    82,
    82,    82,    82,    82,    82,    82,    93,   174,    11,    68,
    93,   174,   174,    11,    11,   174,   174,    82,   174,   212,
   212,   174,   174,   174,   174,   174,   174,   174,   174,    20,
   179,    40,    40,    40,   179,   179,    81,    89,   179,   179,
   174,   179,    89,    66,   179,   179,   179,   179,   179,   179,
   179,   179,    67,    83,    84,    85,    20,    67,    86,    20,
     9,    20,    65,   179,    89,     9,    88,    89,    89,    89,
    64,    91,    67,    67,   157,   157,    92,   157,    62,    67,
     9,     9,    67,    67,    67,    94,    95,     9,    75,    72,
     9,     9,     9,    75,     0,   178,    70,   100,   106,     0,
     0,    70,   184,   178,   107,   178,   157,   184,    75,    75,
    23,    24,   108,   109,   110,    75,    70,    70,    75,    75,
    75,    25,   111,    70,   178,   215,    70,    70,    70,   184,
   215,   144,   184,   184,   184,   113,   144,    23,    24,    71,
    23,    24,    23,    24,    71,   215,   215,   114,    25,   116,
   117,    25,   215,    25,    41,   215,   215,   215,   144,    41,
    41,   144,   144,   144,    60,   151,    71,    61,   181,    71,
    71,    71,    60,   151,    60,   151,   181,   119,   181,   118,
   118,   118,   118,   118,   118,   118,   118,   122,   123,     2,
    54,   125,     2,    60,   151,     2,    39,   181,     3,   126,
     5,    39,    39,     3,     3,     5,     5,    35,   128,     4,
   129,     7,    35,    35,     4,     4,     7,     7,    49,   131,
   132,   135,   136,   137,   138,   139,   140,   141,    46,   145,
   147,    44,   149,    38,   152,    37,   155,    34,   158,   166,
   167,   172,   173,    32,    30,    27,    26,   180,    19,   183,
    12,   186,   187,   188,   193,    10,   196,   199,   206,     8,
   209,     6,   214,     1,   218,   223,   224 ]

racc_action_pointer = [
   145,   323,   224,   249,   260,   251,   321,   262,   310,   114,
   306,    59,   299,   nil,   nil,   nil,   nil,   -18,    25,   299,
    83,     0,   nil,   164,   165,   175,   295,   296,   nil,    18,
   295,   nil,   294,   nil,   288,   258,   nil,   286,   284,   247,
    84,   205,    18,   nil,   281,    -3,   279,   nil,   nil,   269,
   nil,   nil,   nil,   nil,   241,   nil,   nil,   nil,   nil,   nil,
   223,   218,   133,   nil,   119,   111,    92,   106,    64,    32,
   150,   193,   140,    11,   nil,   142,   nil,   nil,    48,   nil,
    -1,    85,    42,   104,    84,    85,    85,     3,    94,    91,
   nil,   122,   127,    65,   133,   137,   nil,   -25,   nil,   nil,
   148,   nil,   nil,   nil,   nil,   nil,   128,   155,   163,   162,
   165,   173,   nil,   165,   198,   nil,   200,   201,   223,   228,
   nil,   nil,   238,   239,     0,   242,   250,   nil,   259,   261,
     2,   270,   271,   nil,   nil,   272,   273,   274,   254,   276,
   277,   275,   nil,   nil,   185,   284,   nil,   281,     2,   281,
   nil,   224,   285,     5,   nil,   266,   nil,   124,   289,   nil,
   nil,   nil,   nil,   nil,   nil,   nil,   259,   291,   nil,   nil,
   nil,   nil,   292,   293,    65,   nil,   nil,    20,   154,    88,
   298,   227,   nil,   277,   156,   nil,   300,   303,   274,   nil,
   nil,   nil,   nil,   282,    14,   nil,   307,   nil,   nil,   308,
   nil,   nil,   nil,   nil,   nil,   nil,   294,    16,   nil,   311,
   nil,   nil,    69,   nil,   313,   179,   nil,   nil,   315,   nil,
   nil,   nil,   nil,   316,   317,   nil,   nil,   nil,   nil,   nil ]

racc_action_default = [
  -118,  -121,   -15,  -116,  -117,  -115,  -121,  -118,  -120,    -9,
  -120,  -118,  -121,  -113,  -114,  -112,   230,   -15,  -121,  -120,
   -96,  -121,   -54,   -97,   -95,   -98,  -121,  -120,   -55,   -48,
  -120,    -2,  -120,   -43,  -120,  -118,   -99,  -120,  -120,  -118,
   -52,  -118,   -90,   -50,  -121,   -15,  -120,   -14,  -107,  -120,
  -106,  -119,   -92,   -58,  -120,   -57,   -93,   -91,   -94,   -53,
   -65,  -120,  -121,   -46,  -121,  -121,   -27,    -6,  -121,  -121,
    -7,  -121,  -120,  -120,   -35,    -8,   -49,   -89,  -120,   -13,
  -121,   -21,  -121,  -120,  -121,  -121,  -121,   -63,  -121,  -121,
   -45,  -120,  -120,  -121,   -23,  -120,   -26,   -29,    -3,   -44,
  -120,    -4,   -51,   -33,   -34,    -5,  -121,  -120,  -121,   -21,
  -120,  -120,   -20,  -121,  -120,   -76,  -120,  -120,  -121,  -120,
   -36,   -77,  -120,  -120,  -121,  -120,  -120,   -37,  -120,  -120,
   -32,  -120,  -120,   -72,   -38,  -120,  -120,  -120,  -121,  -120,
  -120,   -48,   -47,   -19,   -42,  -121,   -17,  -120,  -102,  -121,
   -25,   -65,  -120,  -121,   -12,  -121,  -110,  -111,  -120,   -84,
   -74,   -85,   -71,   -75,   -78,   -88,  -121,  -120,   -79,   -80,
   -81,   -82,  -120,  -120,  -121,   -83,   -73,   -65,   -65,  -121,
  -120,   -65,   -39,  -121,   -41,   -18,  -121,  -120,  -121,  -104,
  -105,  -103,   -28,  -121,   -15,  -109,  -120,  -108,   -10,  -120,
   -86,   -31,   -30,   -69,   -62,   -64,   -68,   -65,   -60,  -120,
   -40,   -22,  -121,   -56,  -120,    -9,   -11,   -87,  -120,   -59,
   -67,   -61,   -16,  -120,  -120,   -24,    -1,   -66,  -100,  -101 ]

racc_goto_table = [
    18,    31,    44,    93,   124,     9,   113,   183,   109,   150,
     2,    51,   184,    13,    14,    15,    88,    17,    97,    60,
    47,    45,    64,    92,    65,   174,    66,    71,    52,    68,
    69,    56,    57,    58,   155,   141,   102,   142,    80,    76,
    49,    81,   188,    55,     1,    67,    82,   210,    79,    70,
    77,    75,   184,    89,   219,   220,   162,   187,   nil,    98,
   nil,   nil,   101,   nil,   103,   104,   nil,   105,   nil,   nil,
   106,   nil,   nil,   nil,   nil,   134,   nil,   nil,   nil,   nil,
   nil,   195,   nil,   143,   144,   197,   nil,   148,   nil,   nil,
   nil,   nil,   151,   nil,   nil,   nil,   203,   nil,   nil,   153,
   nil,   206,   156,   157,   nil,   nil,   159,   193,   160,   161,
   nil,   163,   nil,   nil,   164,   165,   nil,   168,   169,   nil,
   170,   171,   nil,   175,   176,   211,   nil,   177,   178,   179,
   nil,   181,   182,   204,   205,   nil,   nil,   208,   nil,   186,
   nil,   nil,   nil,   nil,   194,   nil,   nil,   nil,   nil,   nil,
   198,   nil,   nil,   nil,   nil,   nil,   nil,   nil,   nil,   200,
   nil,   nil,   nil,   221,   201,   202,   nil,   nil,   nil,   nil,
   nil,   nil,   207,   nil,   nil,   nil,   nil,   nil,   nil,   212,
   nil,   nil,   nil,   nil,   nil,   nil,   nil,   nil,   216,   nil,
   nil,   217,   nil,   nil,   nil,   nil,   nil,   215,   nil,   nil,
   nil,   222,   nil,   nil,   nil,   nil,   225,   226,   nil,   nil,
   227,   nil,   nil,   nil,   nil,   228,   229 ]

racc_goto_check = [
     3,     5,     3,    16,    40,     4,    11,    15,    13,    21,
     2,     3,     6,     2,     2,     2,    19,     2,    20,     3,
     4,     2,     3,    14,     3,    22,     3,    23,    33,     3,
     3,    33,    33,    33,    11,    27,    28,    29,     3,    32,
    10,     3,    36,    38,     1,     2,     3,    15,     4,     2,
    33,     2,     6,     3,    41,    42,    44,    47,   nil,     5,
   nil,   nil,     5,   nil,     3,     3,   nil,     5,   nil,   nil,
     3,   nil,   nil,   nil,   nil,     3,   nil,   nil,   nil,   nil,
   nil,    13,   nil,     3,     3,    13,   nil,     3,   nil,   nil,
   nil,   nil,     3,   nil,   nil,   nil,    40,   nil,   nil,     3,
   nil,    40,     3,     3,   nil,   nil,     3,    19,     3,     3,
   nil,     3,   nil,   nil,     3,     3,   nil,     3,     3,   nil,
     3,     3,   nil,     3,     3,    16,   nil,     3,     3,     3,
   nil,     3,     3,    19,    19,   nil,   nil,    19,   nil,     3,
   nil,   nil,   nil,   nil,     3,   nil,   nil,   nil,   nil,   nil,
     3,   nil,   nil,   nil,   nil,   nil,   nil,   nil,   nil,     3,
   nil,   nil,   nil,    19,     3,     3,   nil,   nil,   nil,   nil,
   nil,   nil,     3,   nil,   nil,   nil,   nil,   nil,   nil,     3,
   nil,   nil,   nil,   nil,   nil,   nil,   nil,   nil,     3,   nil,
   nil,     3,   nil,   nil,   nil,   nil,   nil,     4,   nil,   nil,
   nil,     3,   nil,   nil,   nil,   nil,     3,     5,   nil,   nil,
     3,   nil,   nil,   nil,   nil,     3,     3 ]

racc_goto_pointer = [
   nil,    44,    10,    -8,     3,    -8,  -132,   nil,   nil,   nil,
    22,   -75,   nil,   -72,   -41,  -137,   -61,   nil,   nil,   -44,
   -48,   -88,  -105,   -13,   nil,   nil,   nil,   -54,   -35,   -52,
   nil,   nil,    -3,     8,   nil,   nil,  -106,   nil,    22,   nil,
   -78,  -152,  -151,   nil,   -62,   nil,   nil,   -91 ]

racc_goto_default = [
   nil,   nil,   nil,    85,   nil,   nil,    35,    39,    41,    11,
   111,   nil,     7,   nil,   nil,   nil,   112,    94,    38,   nil,
   nil,   nil,   nil,   nil,   118,    86,    27,    29,    33,    37,
    40,    42,   nil,    43,    20,    23,   nil,    25,   121,    87,
   nil,   nil,   nil,   130,   133,   115,    24,   nil ]

racc_token_table = {
 false => 0,
 Object.new => 1,
 :FUNCTION => 2,
 :INCLUDES => 3,
 :DASHMATCH => 4,
 :LBRACE => 5,
 :HASH => 6,
 :PLUS => 7,
 :GREATER => 8,
 :S => 9,
 :STRING => 10,
 :IDENT => 11,
 :COMMA => 12,
 :URI => 13,
 :CDO => 14,
 :CDC => 15,
 :NUMBER => 16,
 :PERCENTAGE => 17,
 :LENGTH => 18,
 :EMS => 19,
 :EXS => 20,
 :ANGLE => 21,
 :TIME => 22,
 :FREQ => 23,
 :IMPORTANT_SYM => 24,
 :IMPORT_SYM => 25,
 :MEDIA_SYM => 26,
 :PAGE_SYM => 27,
 :CHARSET_SYM => 28,
 :DIMENSION => 29,
 ";" => 30,
 "@" => 31,
 "}" => 32,
 ":" => 33,
 "/" => 34,
 "-" => 35,
 "." => 36,
 "*" => 37,
 "[" => 38,
 "]" => 39,
 ")" => 40,
 "=" => 41,
 :IDEN => 42 }

racc_use_result_var = true

racc_nt_base = 43

Racc_arg = [
 racc_action_table,
 racc_action_check,
 racc_action_default,
 racc_action_pointer,
 racc_goto_table,
 racc_goto_check,
 racc_goto_default,
 racc_goto_pointer,
 racc_nt_base,
 racc_reduce_table,
 racc_token_table,
 racc_shift_n,
 racc_reduce_n,
 racc_use_result_var ]

Racc_token_to_s_table = [
'$end',
'error',
'FUNCTION',
'INCLUDES',
'DASHMATCH',
'LBRACE',
'HASH',
'PLUS',
'GREATER',
'S',
'STRING',
'IDENT',
'COMMA',
'URI',
'CDO',
'CDC',
'NUMBER',
'PERCENTAGE',
'LENGTH',
'EMS',
'EXS',
'ANGLE',
'TIME',
'FREQ',
'IMPORTANT_SYM',
'IMPORT_SYM',
'MEDIA_SYM',
'PAGE_SYM',
'CHARSET_SYM',
'DIMENSION',
'";"',
'"@"',
'"}"',
'":"',
'"/"',
'"-"',
'"."',
'"*"',
'"["',
'"]"',
'")"',
'"="',
'IDEN',
'$start',
'stylesheet',
's_cdo_cdc_0toN',
's_0toN',
'import_0toN',
'ruleset_media_page_0toN',
'ruleset',
'media',
'page',
'import',
'string_or_uri',
'medium_0toN',
'ignorable_at',
'string_uri_or_ident_1toN',
'medium_rollup',
'ruleset_0toN',
'medium_1toN',
'medium',
'page_start',
'declaration_0toN',
'optional_page',
'optional_pseudo_page',
'operator',
'combinator',
'unary_operator',
'property',
'selector_1toN',
'selector',
'simple_selector_1toN',
'selector_list',
'simple_selector',
'element_name',
'hcap_0toN',
'hcap_1toN',
'class',
'attrib',
'attrib_val_0or1',
'pseudo',
'function',
'declaration',
'expr',
'prio_0or1',
'prio',
'term',
'num_or_length',
'hexcolor',
'attribute_id',
'eql_incl_dash']

Racc_debug_parser = false

##### racc system variables end #####

 # reduce 0 omitted

 # reduce 1 omitted

 # reduce 2 omitted

 # reduce 3 omitted

 # reduce 4 omitted

 # reduce 5 omitted

 # reduce 6 omitted

 # reduce 7 omitted

 # reduce 8 omitted

 # reduce 9 omitted

module_eval <<'.,.,', 'lib/parser.y', 24
  def _reduce_10( val, _values, result )
        self.document_handler.import_style(val[2], val[4] || [])
   result
  end
.,.,

module_eval <<'.,.,', 'lib/parser.y', 29
  def _reduce_11( val, _values, result )
        self.document_handler.ignorable_at_rule(val[1])
   result
  end
.,.,

module_eval <<'.,.,', 'lib/parser.y', 33
  def _reduce_12( val, _values, result )
        yyerrok
        self.document_handler.ignorable_at_rule(val[1])
   result
  end
.,.,

 # reduce 13 omitted

 # reduce 14 omitted

 # reduce 15 omitted

module_eval <<'.,.,', 'lib/parser.y', 43
  def _reduce_16( val, _values, result )
        self.document_handler.end_media(val[2])
   result
  end
.,.,

module_eval <<'.,.,', 'lib/parser.y', 45
  def _reduce_17( val, _values, result )
 self.document_handler.start_media(val.first)
   result
  end
.,.,

module_eval <<'.,.,', 'lib/parser.y', 52
  def _reduce_18( val, _values, result )
        yyerrok
        self.document_handler.start_media(val.first)
        error = ParseException.new("Error near: \"#{val[0]}\"")
        self.error_handler.error(error)
   result
  end
.,.,

 # reduce 19 omitted

 # reduce 20 omitted

 # reduce 21 omitted

module_eval <<'.,.,', 'lib/parser.y', 61
  def _reduce_22( val, _values, result )
 result = [val.first, val.last].flatten
   result
  end
.,.,

module_eval <<'.,.,', 'lib/parser.y', 62
  def _reduce_23( val, _values, result )
 result = [val.first]
   result
  end
.,.,

module_eval <<'.,.,', 'lib/parser.y', 69
  def _reduce_24( val, _values, result )
        page_stuff = val.first
        self.document_handler.end_page(page_stuff[0], page_stuff[1])
   result
  end
.,.,

module_eval <<'.,.,', 'lib/parser.y', 75
  def _reduce_25( val, _values, result )
        result = [val[2], val[3]]
        self.document_handler.start_page(val[2], val[3])
   result
  end
.,.,

 # reduce 26 omitted

 # reduce 27 omitted

module_eval <<'.,.,', 'lib/parser.y', 81
  def _reduce_28( val, _values, result )
 result = val[1]
   result
  end
.,.,

 # reduce 29 omitted

 # reduce 30 omitted

 # reduce 31 omitted

 # reduce 32 omitted

module_eval <<'.,.,', 'lib/parser.y', 90
  def _reduce_33( val, _values, result )
 result = :SAC_DIRECT_ADJACENT_SELECTOR
   result
  end
.,.,

module_eval <<'.,.,', 'lib/parser.y', 91
  def _reduce_34( val, _values, result )
 result = :SAC_CHILD_SELECTOR
   result
  end
.,.,

module_eval <<'.,.,', 'lib/parser.y', 92
  def _reduce_35( val, _values, result )
 result = :SAC_DESCENDANT_SELECTOR
   result
  end
.,.,

 # reduce 36 omitted

 # reduce 37 omitted

 # reduce 38 omitted

module_eval <<'.,.,', 'lib/parser.y', 104
  def _reduce_39( val, _values, result )
        self.document_handler.end_selector([val.first].flatten.compact)
   result
  end
.,.,

 # reduce 40 omitted

 # reduce 41 omitted

 # reduce 42 omitted

module_eval <<'.,.,', 'lib/parser.y', 111
  def _reduce_43( val, _values, result )
 result = val.flatten
   result
  end
.,.,

module_eval <<'.,.,', 'lib/parser.y', 117
  def _reduce_44( val, _values, result )
        self.document_handler.start_selector([val.first].flatten.compact)
   result
  end
.,.,

module_eval <<'.,.,', 'lib/parser.y', 121
  def _reduce_45( val, _values, result )
        yyerrok
        self.document_handler.start_selector([val.first].flatten.compact)
   result
  end
.,.,

module_eval <<'.,.,', 'lib/parser.y', 124
  def _reduce_46( val, _values, result )
        self.document_handler.start_selector([val.first].flatten.compact)
   result
  end
.,.,

module_eval <<'.,.,', 'lib/parser.y', 126
  def _reduce_47( val, _values, result )
 result = [val[0], val[3]]
   result
  end
.,.,

 # reduce 48 omitted

module_eval <<'.,.,', 'lib/parser.y', 137
  def _reduce_49( val, _values, result )
        result =  if val[1].nil?
                    val.first
                  else
                    ConditionalSelector.new(val.first, val[1])
                  end
   result
  end
.,.,

module_eval <<'.,.,', 'lib/parser.y', 140
  def _reduce_50( val, _values, result )
        result = ConditionalSelector.new(nil, val.first)
   result
  end
.,.,

module_eval <<'.,.,', 'lib/parser.y', 153
  def _reduce_51( val, _values, result )
        result =
          case val[1]
          when :SAC_DIRECT_ADJACENT_SELECTOR
            SiblingSelector.new(val.first, val[2])
          when :SAC_DESCENDANT_SELECTOR
            DescendantSelector.new(val.first, val[2])
          when :SAC_CHILD_SELECTOR
            ChildSelector.new(val.first, val[2])
          end
   result
  end
.,.,

 # reduce 52 omitted

module_eval <<'.,.,', 'lib/parser.y', 156
  def _reduce_53( val, _values, result )
 result = ClassCondition.new(val[1])
   result
  end
.,.,

module_eval <<'.,.,', 'lib/parser.y', 159
  def _reduce_54( val, _values, result )
 result = ElementSelector.new(val.first)
   result
  end
.,.,

module_eval <<'.,.,', 'lib/parser.y', 160
  def _reduce_55( val, _values, result )
 result = SimpleSelector.new()
   result
  end
.,.,

module_eval <<'.,.,', 'lib/parser.y', 166
  def _reduce_56( val, _values, result )
        result = AttributeCondition.build(val[2], val[4])
   result
  end
.,.,

module_eval <<'.,.,', 'lib/parser.y', 171
  def _reduce_57( val, _values, result )
        result = PseudoClassCondition.new(val[1])
   result
  end
.,.,

module_eval <<'.,.,', 'lib/parser.y', 171
  def _reduce_58( val, _values, result )
 result = PseudoClassCondition.new(val[1])
   result
  end
.,.,

module_eval <<'.,.,', 'lib/parser.y', 185
  def _reduce_59( val, _values, result )
        if value = self.property_parser.parse_tokens(
          self.tokenizer.tokenize(val.flatten[0..-2].join(' '))
        )

          value = [value].flatten

          self.document_handler.property(val.first, value, !val[4].nil?)
          result = value
        end
   result
  end
.,.,

 # reduce 60 omitted

module_eval <<'.,.,', 'lib/parser.y', 193
  def _reduce_61( val, _values, result )
        yyerrok
        error = ParseException.new("Unkown property: \"#{val[1]}\"")
        self.error_handler.error(error)
   result
  end
.,.,

module_eval <<'.,.,', 'lib/parser.y', 198
  def _reduce_62( val, _values, result )
        yyerrok
        error = ParseException.new("Unkown property: \"#{val[0]}\"")
        self.error_handler.error(error)
   result
  end
.,.,

 # reduce 63 omitted

 # reduce 64 omitted

 # reduce 65 omitted

 # reduce 66 omitted

 # reduce 67 omitted

 # reduce 68 omitted

module_eval <<'.,.,', 'lib/parser.y', 210
  def _reduce_69( val, _values, result )
 result = val
   result
  end
.,.,

 # reduce 70 omitted

module_eval <<'.,.,', 'lib/parser.y', 214
  def _reduce_71( val, _values, result )
 result = val
   result
  end
.,.,

module_eval <<'.,.,', 'lib/parser.y', 215
  def _reduce_72( val, _values, result )
 result = val
   result
  end
.,.,

 # reduce 73 omitted

 # reduce 74 omitted

 # reduce 75 omitted

 # reduce 76 omitted

 # reduce 77 omitted

 # reduce 78 omitted

 # reduce 79 omitted

 # reduce 80 omitted

 # reduce 81 omitted

 # reduce 82 omitted

 # reduce 83 omitted

 # reduce 84 omitted

 # reduce 85 omitted

module_eval <<'.,.,', 'lib/parser.y', 236
  def _reduce_86( val, _values, result )
        result = Function.new(val[0], val[2].flatten.select { |x| x !~ /,/ })
   result
  end
.,.,

module_eval <<'.,.,', 'lib/parser.y', 236
  def _reduce_87( val, _values, result )
 yyerrok; result = [val[0], val[2], val[3]]
   result
  end
.,.,

 # reduce 88 omitted

 # reduce 89 omitted

 # reduce 90 omitted

module_eval <<'.,.,', 'lib/parser.y', 249
  def _reduce_91( val, _values, result )
        result = CombinatorCondition.new(val[0], val[1])
   result
  end
.,.,

module_eval <<'.,.,', 'lib/parser.y', 252
  def _reduce_92( val, _values, result )
        result = CombinatorCondition.new(val[0], val[1])
   result
  end
.,.,

module_eval <<'.,.,', 'lib/parser.y', 255
  def _reduce_93( val, _values, result )
        result = CombinatorCondition.new(val[0], val[1])
   result
  end
.,.,

module_eval <<'.,.,', 'lib/parser.y', 258
  def _reduce_94( val, _values, result )
        result = CombinatorCondition.new(val[0], val[1])
   result
  end
.,.,

 # reduce 95 omitted

 # reduce 96 omitted

 # reduce 97 omitted

 # reduce 98 omitted

module_eval <<'.,.,', 'lib/parser.y', 264
  def _reduce_99( val, _values, result )
 result = IDCondition.new(val.first)
   result
  end
.,.,

module_eval <<'.,.,', 'lib/parser.y', 267
  def _reduce_100( val, _values, result )
 result = [val.first, val[2]]
   result
  end
.,.,

module_eval <<'.,.,', 'lib/parser.y', 268
  def _reduce_101( val, _values, result )
 result = [val.first, val[2]]
   result
  end
.,.,

 # reduce 102 omitted

 # reduce 103 omitted

 # reduce 104 omitted

 # reduce 105 omitted

 # reduce 106 omitted

 # reduce 107 omitted

 # reduce 108 omitted

 # reduce 109 omitted

 # reduce 110 omitted

 # reduce 111 omitted

 # reduce 112 omitted

 # reduce 113 omitted

 # reduce 114 omitted

 # reduce 115 omitted

 # reduce 116 omitted

 # reduce 117 omitted

 # reduce 118 omitted

 # reduce 119 omitted

 # reduce 120 omitted

 def _reduce_none( val, _values, result )
  result
 end

    end   # class GeneratedParser

  end   # module SAC

end   # module CSS