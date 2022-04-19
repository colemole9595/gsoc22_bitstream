# Documentation of the Xilinx Spartan 6 Bitstream - GSoC'22 Proposal

IRC: colemole9595 on libera.chat

Slack: colemole9595 in the CHIPS Alliance Workspace

<sup>Click [here](https://github.com/colemole9595/gsoc22_bitstream/blob/main/README.md) for the markdown document that this proposal is generated from.</sup>

## Introduction

The AMD/Xilinx Spartan 6 series of FPGAs is immensely popular and has found itself in a number of open source projects[^novena] and low cost development boards[^mimas][^mimas2]. A quick search yields many results[^int1][^int2][^int3][^int4] from as early as last year where people express interest about an open source Spartan 6 flow. The aim of this proposal is to build upon Project X-Ray's success with the Series7 and extend it to support the Spartan 6 series.

The smallest part in the series, the XC6SLX4 has 2,731,488 bits of configuration data. Even if the tools allowed for it, decoding the bitstream by manipulating and observing the changes to individual bits would be infeasible. Statistical techniques in addition to exploiting the regular nature of the FPGA tiles are the most practical method to discover the meaning behind the bits.

## Vision

Reverse engineering a bitstream is a monumental task. At the time of writing this, prjxray has over 3,500 commits from over 39 contributors. My ideal outcome for this project is the creation of a well documented base that allows for as many contributors to add effort as easily as possible.

## Project Plan

As the main idea is to extend Project X-Ray to add support for the Spartan 6 series, I will use this section to explain the methodology that will be borrowed. Devices support will be limited to those under the free ISE WebPACK Edition license (6SLX4 to 6SLX75T). I want to further limit the devices to just one fabric, the XC6SLX9, as I have one on hand. Thanks to some [recent work](https://github.com/f4pga/prjxray/pull/1088) by @tmichalak, the infrastructure to read and write the bitstreams to and from a textual representation already exists.

After setting up the basic infrastructure that is init-db, parts-yaml and tilegrid fuzzers, the next step would be to create minitests and experiments that inform the creation of fuzzers for a particular tile type. I expect some of the fuzzers to transfer over without issue from Project X-Ray.

My top priority is successfully completing the GSoC project and hitting all mandatory milestones. In order to make success more likely, I have placed the core milestones at the front of the queue and placed the stretch goals deeper into the timeline. This way the risk can be reduced and when things eventually don't go to plan I will have some time to course correct.

### Deliverables

#### Core
- Part Fuzzer:
    This component is responsible for extracting information about configuration rows, columns and their frame counts.
- Tilegrid Fuzzer:
    This component is responsible for fuzzing individual tiles and adding information about the base address to the bitsteam database. It consists of a sub-fuzzer for each tile type (such as BRAM, DSP, CLB, etc).
- A dozen tile types will be localized in the bit stream.

#### Stretch
- BRAM data fuzzing using data2mem.

#### Community Bonding Period: May 20 - Jun 12
- Deep dive into Xilinx docs and Project X-Ray's internals.
- Study archived experiments in https://github.com/SymbiFlow/prjxray-experiments-archive-2017/ and try to recreate a few observations.
- Investigate the use of `data2mem` to obtain the BRAM data mapping.
- Investigate the output of `xdl -report` for details about architecture.

#### Week 1: Jun 13 - Jun 19
- Tool can perform database creation for mask, segbits and ppips given a part/fabric.
- Work on Part Fuzzer begins.

#### Week 2: Jun 20 - Jun 26
- Part Fuzzer is able to extract information about the structure of the FPGA configuration and classify address ranges by frame type such as Core, Block RAM and IOB.

#### Week 3: Jun 27 - Jul 03
- Minitest for LOC and observation of CLB behaviour in bitstream.
- Work on tilegrid fuzzer begins.

#### Week 4: Jul 04 - Jul 10
- Tilegrid fuzzer is able to extract address information given a generate.tcl, Makefile and top.py.

#### Week 5: Jul 11 - Jul 17
- Extract tilegrid information about CLBs.

#### Week 6: Jul 18 - Jul 24
- Extract tilegrid information about IOBs.

#### Week 7: Jul 25 - Jul 31
- Extract tilegrid information about PLLs.

#### Week 8: Aug 01 - Aug 07
- Extract tilegrid information about BRAMs.

#### Week 9: Aug 08 - Aug 14
- Extract tilegrid information about DSPs.

#### Week 10: Aug 15 - Aug 21
- Extract tilegrid information about GCLKs.

#### Week 11: Aug 22 - Aug 28
- Extract tilegrid information about BUFGs and BUFGMUXs.

#### Week 12: Aug 29 - Sep 04
- Extract tilegrid information about BUFHs.
- Write article explaining progress so far.

#### Week 13: Sep 05 - Sep 11
- Core milestones should be achieved by this week.
- Buffer week.

#### Week 14: Sep 12 - Sep 18
- Extract tilegrid information about O/ISERDES2s.

#### Week 15: Sep 19 - Sep 25
- Extract tilegrid information about CARRY4.

#### Week 16: Sep 26 - Oct 02
- Extract tilegrid information about DPRAM32.

#### Week 17: Oct 03 - Oct 09
- Extract tilegrid information about SLICEX.

#### Week 18: Oct 10 - Oct 16
- Extract tilegrid information about SLICEL.

#### Week 19: Oct 17 - Oct 23
- Extract tilegrid information about SLICEM.

#### Week 20: Oct 24 - Oct 30
- Write a detailed tutorial for writing custom fuzzers that includes at least two worked out examples.
- Write a retrospective article about the experience.

#### Week 21: Oct 31 - Nov 06
- Buffer period to tie up loose ends.

#### Week 22: Nov 07 - Nov 13
- Buffer period to tie up loose ends.

## Risks

- One of the most significant risks faced by this project is inconsistent/incorrect vendor tools and documentation. I have already come across incorrect vendor documentation regarding `bitgen`'s ability to produce a debug bitstream for the Spartan 6 series and unexplained discrepancies in the Frame Length register's values in valid real world bitstreams.
- Another significant risk is if some of the techniques used in Project X-Ray won't be applicable to the Spartan 6 parts due to the use of a different toolchain. For example, if a bug such as [MUXF8 vivado compatibility](https://github.com/f4pga/prjxray/issues/14) were to present itself in ISE, then a whole load of fuzzers would not be transferable between the projects.

## Preliminary Work

- Transformed the output of `partgen -p spartan6 -nopkgfile' into a [devices.yaml](https://github.com/colemole9595/gsoc22_bitstream/blob/main/devices.yaml) file.
- Opened a [pull request](https://github.com/f4pga/prjxray/pull/1909) to fix a small issue with int_maketodo's verbose logging.
- Opened a [pull request](https://github.com/f4pga/prjxray/pull/1910) to add disk reporting functionality to run_fuzzer.py.
<!-- - Opened a [pull request]() to document the two fuzzers that are most relevant to this proposal. -->
- Wrote a quick and dirty Kaitai [parser definition](https://github.com/colemole9595/gsoc22_bitstream/blob/main/spartan6_bitstream.ksy) to visualize XC6LX9 bitstreams.

## Resources

- I have a Spartan 6 LX9 based development board (a [Numato Mimas](https://numato.com/product/mimas-spartan-6-fpga-development-board/)) that might come in handy to try to uncover what some of the undocumented registers do.
- I have a desktop that can act as a CI runner to offload long fuzzing sessions from my laptop.

## Motivation

I came across Claire's [video](https://www.youtube.com/watch?v=SOn0g3k0FlE)[^clairevid] about the iceStorm project while browsing the Chaos Communication Congress's video page and was blown away by the talk. I had no idea that something like that was possible and had always assumed that FPGAs and the software that powered them were black magic. Up to this point, my only interaction with FPGAs was with a Digilent board I played with in the university makerspace. I was fascinated by the capabilities of the hardware and went on to slowly teach myself how to use it. As a regularly user of open source software, I want to contribute back to the community. I also very much enjoy the act of taking apart something to understand it. I will no doubt feel great joy reverse engineering the bitstream format.

## About Me

I'm Anmol. I'm currently living in Bengaluru, a city in India. I graduated in 2016 with a Bachelors in Mechanical Engineering from the Birla Institute of Technology and Science, Pilani.

## Skills and Deficiencies

- BASH, cmake, C++11/14, ISE, Python, Verilog, Vivado: I am comfortable with these languages/tools. I took a walk through the experiments, minitests and fuzzers and did not find that they were too advanced for me.

- Tcl, Github CI : I don't have as much experience with these and will need to learn.

## Footnotes and Useful Links

- https://github.com/Martoni/debit
- https://github.com/Wolfgang-Spraul/fpgatools

[^novena]: [Novena- Crowd Supply](https://www.crowdsupply.com/sutajio-kosagi/novena)

[^mimas]: [Numato Mimas](https://numato.com/product/mimas-spartan-6-fpga-development-board/)

[^mimas2]: [Numato Mimas V2](https://numato.com/product/mimas-v2-spartan-6-fpga-development-board-with-ddr-sdram/)

[^int1]: https://github.com/f4pga/ideas/issues/10

[^int2]: https://github.com/timvideos/getting-started/issues/45

[^int3]: https://freenode.irclog.whitequark.org/~h~openfpga/search?q=spartan+6

[^int4]: https://freenode.irclog.whitequark.org/symbiflow/search?q=spartan+6

[^clairevid]: [A Free and Open Source Verilog-to-Bitstream Flow for iCE40 FPGAs](https://www.youtube.com/watch?v=SOn0g3k0FlE)

[^ug380]: [UG380: Spartan-6 FPGA Configuration User Guide](https://www.xilinx.com/support/documentation/user_guides/ug380.pdf) (v2.11) March 22, 2019

[^ug628]: [UG628: Command Line Tools User Guide](https://www.xilinx.com/support/documentation/sw_manuals/xilinx14_7/devref.pdf) (v14.7) October 2, 2013
