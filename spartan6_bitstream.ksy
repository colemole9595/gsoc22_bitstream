# Copyright (C) 2022 Anmol Shrivastava <colemole9595@gmail.com>
#
# Use of this source code is governed by a ISC-style
# license that can be found in the LICENSE file or at
# https://opensource.org/licenses/ISC
#
# SPDX-License-Identifier: ISC

meta:
  id: spartan6_bitstream
  file-extension: bin
  endian: be

seq:
  - id: dummyword
    contents: [0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff]
  - id: syncword
    contents: [0xaa, 0x99, 0x55, 0x66]
  - id: packets
    type: packet
    repeat: expr
    repeat-expr: 93
    # repeat: until
    # repeat-until: _.dummy_check == 0x00dd

types:
  packet:
    seq:
      - id: type
        type: b3
        enum: packet_type
      - id: operation
        type: b2
        enum: opcode
      - id: reg_addr
        type: b6
        enum: cfg_reg
      - id: word_count
        type: b5
      - id: word_count_2
        type: b32
        if: type == packet_type::type2
      - id: data
        # type: u2
        size: word_count * 2
        if: type == packet_type::type1
      - id: data_2
        # type: u2
        size: word_count_2 * 2 + 4
        if: type == packet_type::type2
    instances:
      dummy_check:
        io: _parent._io
        pos: _parent._io.pos
        type: u2

enums:
  packet_type:
    1: type1
    2: type2
  opcode:
    0: nop
    1: read
    2: write
  cfg_reg:
    0: crc
    1: far
    1: far_maj
    2: far_min
    3: fdri
    4: fdro
    5: cmd
    6: ctl
    6: ctl1
    7: mask
    8: stat
    9: lout
    10: cor1
    11: cor2
    12: pwrdn_reg
    13: flr
    14: idcode
    15: cwdt
    16: hc_opt_reg
    18: csbo
    19: general1
    20: general2
    21: general3
    22: general4
    23: general5
    24: mode_reg
    25: pu_gwe
    26: pu_gts
    27: mfwr
    28: cclk_freq
    29: seu_opt
    30: exp_sign
    31: rdbk_sign
    32: bootsts
    33: eye_mask
    34: cbc_reg
