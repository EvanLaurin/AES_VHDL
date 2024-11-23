----------------------------------------------------------------------------------

----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity MixColumns is
	Port (state_in  : in std_logic_vector(127 downto 0);
			state_out  : out std_logic_vector(127 downto 0)
			);     
end MixColumns;

architecture Structural of MixColumns is

component MatrixColumnMult
	port( col_in  : in std_logic_vector(31 downto 0);
			col_out  : out std_logic_vector(31 downto 0)
			);
end component;

signal ci0, ci1, ci2, ci3 : std_logic_vector(31 downto 0);
signal co0, co1, co2, co3 : std_logic_vector(31 downto 0);

signal result : std_logic_vector(127 downto 0);

begin

	ci0 <= state_in(127 downto 120) & state_in(95 downto 88) & state_in(63 downto 56) & state_in(31 downto 24);
   ci1 <= state_in(119 downto 112) & state_in(87 downto 80) & state_in(55 downto 48) & state_in(23 downto 16);
   ci2 <= state_in(111 downto 104) & state_in(79 downto 72) & state_in(47 downto 40) & state_in(15 downto 8);
   ci3 <= state_in(103 downto 96) & state_in(71 downto 64) & state_in(39 downto 32) & state_in(7 downto 0);

	m0 : MatrixColumnMult port map(col_in => ci0, col_out => co0);
   m1 : MatrixColumnMult port map(col_in => ci1, col_out => co1);
   m2 : MatrixColumnMult port map(col_in => ci2, col_out => co2);
   m3 : MatrixColumnMult port map(col_in => ci3, col_out => co3);
	
	result(127 downto 120) <= co0(31 downto 24);
   result(119 downto 112) <= co1(31 downto 24);
   result(111 downto 104) <= co2(31 downto 24);
   result(103 downto 96)  <= co3(31 downto 24);
	
	result(95 downto 88)   <= co0(23 downto 16);
   result(87 downto 80)   <= co1(23 downto 16);
   result(79 downto 72)   <= co2(23 downto 16);
   result(71 downto 64)   <= co3(23 downto 16);
	
	result(63 downto 56)   <= co0(15 downto 8);
   result(55 downto 48)   <= co1(15 downto 8);
   result(47 downto 40)   <= co2(15 downto 8);
   result(39 downto 32)   <= co3(15 downto 8);
	 
	result(31 downto 24)   <= co0(7 downto 0);
   result(23 downto 16)   <= co1(7 downto 0);
   result(15 downto 8)    <= co2(7 downto 0);
   result(7 downto 0)     <= co3(7 downto 0);
	
	state_out <= result;
	
end Structural;

