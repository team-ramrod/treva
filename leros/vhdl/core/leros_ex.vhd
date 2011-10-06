--
--  Copyright 2011 Martin Schoeberl <masca@imm.dtu.dk>,
--                 Technical University of Denmark, DTU Informatics. 
--  All rights reserved.
--
-- Redistribution and use in source and binary forms, with or without
-- modification, are permitted provided that the following conditions are met:
-- 
--    1. Redistributions of source code must retain the above copyright notice,
--       this list of conditions and the following disclaimer.
-- 
--    2. Redistributions in binary form must reproduce the above copyright
--       notice, this list of conditions and the following disclaimer in the
--       documentation and/or other materials provided with the distribution.
-- 
-- THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDER ``AS IS'' AND ANY EXPRESS
-- OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES
-- OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN
-- NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY
-- DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
-- (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
-- LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
-- ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
-- (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF
-- THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
-- 
-- The views and conclusions contained in the software and documentation are
-- those of the authors and should not be interpreted as representing official
-- policies, either expressed or implied, of the copyright holder.
-- 

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.leros_types.all;

-- Some fmax number with Cyclone EP1C12C6
--
--	Memory is with rdaddr in clock process, rddata combinational
--		which is the 'normal' memory configuration, but Quartus
--		adds path through logic for read during write
--	fully registered on-chip memory 256 MHz
--	only input registers, output goes to a LC register (with reset): 165 MHz
--	plus a 16-bit adder: 147 MHz
--	more in ALU + opd mux: 135 MHz
--
--	Memory with rddata in clock process, rdaddr combinational
--		what does this model in read during write? Probably the
--		old value.
--	only input registers, output goes to a LC register (with reset): 256 MHz
--	plus a 16-bit adder: 166 MHz
--	more in ALU (add/sub) and opd mux between imm and DM output: 148 MHz


entity leros_ex is
	port  (
		clk : in std_logic;
		reset : in std_logic;
		din : in fedec_out_type;
		ioin : in io_in_type;
		dout : out ex_out_type
	);
end leros_ex;

architecture rtl of leros_ex is

	-- the accu
	signal accu, opd  : stream_unsigned;
	--signal log, arith, a_mux : stream_unsigned;
	signal logic, arith, shift, a_mux : stream_unsigned;
	
	signal wrdata, rddata : stream_std;
	signal wraddr, rdaddr : std_logic_vector(DM_BITS-1 downto 0);
	
	signal wraddr_dly : std_logic_vector(DM_BITS-1 downto 0);
	signal pc_dly : std_logic_vector(IM_BITS-1 downto 0);
	

begin

	dout.accu <= std_logic_vector(accu(to_integer(unsigned(din.imm(7 downto 4)))));
	dout.dm_data <= rddata((to_integer(unsigned(din.imm(7 downto 4)))));
	rdaddr <= din.dm_addr;
	-- address for the write needs one cycle delay
	wraddr <= wraddr_dly;
		
in_mux : entity work.in_mux port map(din.dec.sel_imm, din.imm, rddata, opd);

-- that's the ALU	
process(din, accu, opd, logic, arith, ioin)
begin

	-- Benjamin's
	case din.dec.op is
		when "00" =>
		--when op_ld =>
			for i in (stream-1) downto 0 loop
				logic(i) <= opd(i);
				arith(i) <= accu(i) + opd(i);
				shift(i) <= accu(i) + opd(i); -- NB shift NYI
			end loop;	
		when "01" =>
		--when op_and =>
			for i in (stream-1) downto 0 loop
				logic(i) <= accu(i) and opd(i);
				arith(i) <= accu(i) - opd(i);
				shift(i) <= accu(i) + opd(i); -- NB shift NYI
			end loop;	
		when "10" =>
		--when op_or =>
			for i in (stream-1) downto 0 loop
				logic(i) <= accu(i) or opd(i);
				arith(i) <= accu(i) * opd(i);
				shift(i) <= accu(i) + opd(i); -- NB shift NYI
			end loop;	
		when "11" =>
		--when op_xor =>
			for i in (stream-1) downto 0 loop
				logic(i) <= accu(i) xor opd(i);
				arith(i) <= accu(i) * opd(i); -- NB div NYI
				shift(i) <= accu(i) + opd(i); -- NB shift NYI
			end loop;	

		when others =>
			null;
	end case;
	
	case din.dec.op_class is
		when arith_flag =>
			for i in (stream-1) downto 0 loop
				a_mux(i) <= arith(i);
			end loop;	
		when others =>
			null;
	end case;		
			--

--	-- Zac's
	if din.dec.add_sub='0' then
		for i in (stream-1) downto 0 loop
			arith(i) <= accu(i) + opd(i);
		end loop;
	else
		for i in (stream-1) downto 0 loop
			arith(i) <= accu(i) - opd(i);
		end loop;
	end if;

--	case din.dec.op is
--		when op_ld =>
--			for i in (stream-1) downto 0 loop
--				logic(i) <= opd(i);
--			end loop;
--		when op_and =>
--			for i in (stream-1) downto 0 loop
--				logic(i) <= accu(i) and opd(i);
--			end loop;
--		when op_or =>
--			for i in (stream-1) downto 0 loop
--				logic(i) <= accu(i) or opd(i);
--			end loop;
--		when op_xor =>
--			for i in (stream-1) downto 0 loop
--				logic(i) <= accu(i) xor opd(i);
--			end loop;
--		when others =>
--			null;
--	end case;
	
	if din.dec.log_add='0' then
		if din.dec.shr='1' then
			for i in (stream-1) downto 0 loop
				a_mux(i) <= '0' & accu(i)(15 downto 1);
			end loop;
		else
			if din.dec.inp='1' then
				for i in (stream-1) downto 0 loop
					a_mux(i) <= unsigned(ioin.rddata);
				end loop;
			else
				for i in (stream-1) downto 0 loop
					a_mux(i) <= logic(i);
				end loop;
			end if;
		end if;
	else
		--for i in (stream-1) downto 0 loop	
			--a_mux(i) <= arith(i);
		--end loop;
	end if;
		
end process;

-- a MUX between 'normal' data and the PC for jal
out_mux : entity work.out_mux port map(din.dec.jal, accu, pc_dly, wrdata);

accu_unit : entity work.accu port map(clk, reset, din.dec.al_ena, din.dec.ah_ena, din.pc, din.dm_addr, a_mux, pc_dly, wraddr_dly, accu);

-- the data memory (DM)
-- read during write is usually undefined in an FPGA,
-- but that is not modelled
dm : entity work.dm port map(clk, din.dec.store, wrdata, wraddr, rdaddr, rddata);
	
end rtl;
